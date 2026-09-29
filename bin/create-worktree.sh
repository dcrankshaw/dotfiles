#!/usr/bin/env bash
#
# create-worktree.sh - Automate yolo git worktree setup with uv venv and VSCode configuration
#
# Usage: create-worktree.sh <worktree-name> [--branch <branch> | --remote-branch <branch>] [--new-branch] [--open]
#
# Arguments:
#   <worktree-name>     Required. Name for the worktree directory
#   --branch <branch>   Existing local branch to checkout (required without --new-branch),
#                       or base branch for the new branch (default origin/main)
#   --remote-branch <branch>
#                       Fetch this branch from origin and use it as the base for a new branch
#   --new-branch        Create a new branch named ${YOLO_USER:-$USER}/<worktree-name> from the selected base
#   --open              Optional. Open VSCode after setup
#
# Environment Variables:
#   YOLO_REPO_DIR            Main yolo checkout that worktrees are added to (default: ~/yolo)
#   YOLO_USER                Branch prefix for --new-branch (default: $USER)
#   YOLO_WORKTREES_DIR       Override default worktree location
#   YOLO_WORKTREE_PATH_FILE  If set, the created worktree path is written to this file.
#                            Shell wrappers use it to cd into the new worktree, since this
#                            script runs in its own process and cannot change the caller's cwd.

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

usage() {
    cat <<EOF
Usage: $(basename "$0") <worktree-name> [--branch <branch> | --remote-branch <branch>] [--new-branch] [--open]

Create a yolo git worktree with uv venv and VSCode configuration.

Arguments:
    <worktree-name>     Name for the worktree directory (e.g., my-feature)
    --branch <branch>   Existing local branch to checkout (required unless --new-branch),
                        or the base branch when using --new-branch (default: origin/main)
    --remote-branch <branch>
                        Fetch this branch from origin and create a new branch from it
                        (implies --new-branch)
    --new-branch        Create a new branch named \${YOLO_USER:-\$USER}/<worktree-name> (recommended for new work)
    --open              Open VSCode after setup

Environment Variables:
    YOLO_REPO_DIR            Main yolo checkout that worktrees are added to (default: ~/yolo)
    YOLO_USER                Branch prefix for --new-branch (default: \$USER)
    YOLO_WORKTREES_DIR       Override default worktree location
    YOLO_WORKTREE_PATH_FILE  If set, the created worktree path is written to this file
                             (used by the \`yolo-worktree\` shell wrapper to cd into it)

Examples:
    $(basename "$0") my-feature --new-branch              # Create new branch '\${YOLO_USER:-\$USER}/my-feature' from origin/main
    $(basename "$0") my-feature --new-branch --branch dev # Create new branch '\${YOLO_USER:-\$USER}/my-feature' from dev
    $(basename "$0") my-feature --remote-branch user/topic # Fetch origin/user/topic and create a new branch from it
    $(basename "$0") bugfix --branch fix/issue-123        # Checkout existing branch
    $(basename "$0") experiment --new-branch --open       # Create new branch and open VSCode
EOF
    exit 1
}

# Validate prerequisites
check_prerequisites() {
    local missing=()

    if ! command -v git &>/dev/null; then
        missing+=("git")
    fi

    if ! command -v uv &>/dev/null; then
        missing+=("uv")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        exit 1
    fi
}

# Find the main yolo checkout. This script lives in dotfiles, not in the repo, so it
# can't locate the repo from its own path.
find_repo_root() {
    local dir="${YOLO_REPO_DIR:-$HOME/yolo}"
    if [[ -d "$dir/.git" ]] && [[ -f "$dir/pyproject.toml" ]] \
        && grep -q 'name = "yolo"' "$dir/pyproject.toml" 2>/dev/null; then
        echo "$dir"
        return 0
    fi

    log_error "No main yolo checkout at '$dir'. Set YOLO_REPO_DIR to point at one."
    exit 1
}

# Detect Python path based on environment
detect_python_path() {
    # Mac: use conda yolo environment
    if [[ -f "$HOME/miniconda3/envs/yolo/bin/python" ]]; then
        echo "$HOME/miniconda3/envs/yolo/bin/python"
        return 0
    fi

    # Mac alternative: anaconda instead of miniconda
    if [[ -f "$HOME/anaconda3/envs/yolo/bin/python" ]]; then
        echo "$HOME/anaconda3/envs/yolo/bin/python"
        return 0
    fi

    # Condor: use system python 3.12
    if [[ -f "/mnt/vast/python/miniconda3/envs/yolo312/bin/python3.12" ]]; then
        echo "/mnt/vast/python/miniconda3/envs/yolo312/bin/python3.12"
        return 0
    fi

    # MSI Coder devbox: uv-managed 3.12 with CPU torch preinstalled (the system
    # python3 there is 3.13, which yolo's requires-python rejects).
    local devbox_python
    devbox_python="/opt/python/cpython-3.12-linux-$(uname -m)-gnu/bin/python3.12"
    if [[ -x "$devbox_python" ]]; then
        echo "$devbox_python"
        return 0
    fi

    # Fallback: try to find python via conda
    if command -v conda &>/dev/null; then
        local conda_python
        conda_python="$(conda run -n yolo which python 2>/dev/null)" || true
        if [[ -n "$conda_python" ]] && [[ -f "$conda_python" ]]; then
            echo "$conda_python"
            return 0
        fi
    fi

    # Last resort: system python3
    if command -v python3 &>/dev/null; then
        log_warn "Using system python3 as fallback"
        which python3
        return 0
    fi

    log_error "Could not find a suitable Python installation"
    exit 1
}

# Main script
main() {
    local worktree_name=""
    local branch=""
    local remote_branch=""
    local new_branch=false
    local open_vscode=false
    # $USER is `coder` on the MSI devbox, so prefer the explicit alias.
    local branch_owner="${YOLO_USER:-$USER}"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --branch)
                if [[ -z "${2:-}" ]]; then
                    log_error "--branch requires a value"
                    usage
                fi
                branch="$2"
                shift 2
                ;;
            --remote-branch)
                if [[ -z "${2:-}" ]]; then
                    log_error "--remote-branch requires a value"
                    usage
                fi
                remote_branch="$2"
                shift 2
                ;;
            --new-branch)
                new_branch=true
                shift
                ;;
            --open)
                open_vscode=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                ;;
            *)
                if [[ -z "$worktree_name" ]]; then
                    worktree_name="$1"
                else
                    log_error "Unexpected argument: $1"
                    usage
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$worktree_name" ]]; then
        log_error "Worktree name is required"
        usage
    fi

    # Validate worktree name (no slashes, spaces, or special chars)
    if [[ ! "$worktree_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        log_error "Invalid worktree name: '$worktree_name'. Use only alphanumeric characters, hyphens, and underscores."
        exit 1
    fi

    if [[ -n "$branch" && -n "$remote_branch" ]]; then
        log_error "--branch and --remote-branch are mutually exclusive"
        exit 1
    fi

    # Resolve the branch default. Only --new-branch may default to a remote-tracking
    # ref; checking one out directly would produce a detached worktree.
    if [[ -n "$remote_branch" ]]; then
        new_branch=true
    elif $new_branch; then
        branch="${branch:-origin/main}"
    elif [[ -z "$branch" ]]; then
        log_error "--branch <local-branch>, --remote-branch <branch>, or --new-branch is required"
        usage
    fi

    check_prerequisites

    log_info "Setting up yolo worktree: $worktree_name"

    # Find repo root
    local repo_root
    repo_root="$(find_repo_root)"
    log_info "Found yolo repo at: $repo_root"

    # Determine worktree destination
    local worktrees_dir
    if [[ -n "${YOLO_WORKTREES_DIR:-}" ]]; then
        worktrees_dir="$YOLO_WORKTREES_DIR"
    else
        # Create worktrees directory as sibling to repo parent with -worktrees suffix
        local repo_parent
        repo_parent="$(dirname "$repo_root")"
        local repo_name
        repo_name="$(basename "$repo_root")"
        worktrees_dir="$repo_parent/${repo_name}-worktrees"
    fi

    local worktree_path="$worktrees_dir/$worktree_name"

    # Check if worktree already exists
    if [[ -d "$worktree_path" ]]; then
        log_error "Worktree path already exists: $worktree_path"
        exit 1
    fi

    # Create worktrees directory if needed
    mkdir -p "$worktrees_dir"

    log_info "Creating worktree at: $worktree_path"

    # Create git worktree
    cd "$repo_root"
    if [[ -n "$remote_branch" ]]; then
        remote_branch="${remote_branch#origin/}"
        if ! git check-ref-format --branch "$remote_branch" >/dev/null 2>&1; then
            log_error "Invalid remote branch: '$remote_branch'"
            exit 1
        fi

        log_info "Fetching remote branch 'origin/$remote_branch'"
        git fetch origin "+refs/heads/$remote_branch:refs/remotes/origin/$remote_branch"
        branch="origin/$remote_branch"
    fi

    if $new_branch; then
        local branch_name="${branch_owner}/${worktree_name}"
        log_info "Creating new branch '$branch_name' from '$branch'"
        git worktree add -b "$branch_name" "$worktree_path" "$branch"
    else
        if ! git show-ref --verify --quiet "refs/heads/$branch"; then
            log_error "No local branch named '$branch'."
            log_error "Pass a local branch, or use --new-branch to create one from '$branch'."
            exit 1
        fi
        log_info "Checking out branch: $branch"
        git worktree add "$worktree_path" "$branch"
    fi
    log_success "Created git worktree"

    # Initialize submodules
    log_info "Initializing submodules..."
    cd "$worktree_path"
    git submodule update --init --recursive
    log_success "Submodules initialized"

    # Detect Python and create venv
    log_info "Detecting Python installation..."
    local python_path
    python_path="$(detect_python_path)"
    log_info "Using Python: $python_path"

    log_info "Creating uv virtual environment..."
    uv venv --system-site-packages --python "$python_path"
    log_success "Created virtual environment"

    # Sync packages
    # Increase file descriptor limit to avoid "Too many open files" errors during uv sync.
    # macOS default launchd limit (256) is too low for building many packages concurrently.
    ulimit -n 65536 2>/dev/null || log_warn "Could not increase file descriptor limit"
    log_info "Syncing packages with uv (this may take a while)..."
    uv sync --all-packages --frozen
    log_success "Packages synced"

    # Create VSCode settings
    log_info "Creating VSCode settings..."
    mkdir -p "$worktree_path/.vscode"
    cat > "$worktree_path/.vscode/settings.json" <<'EOF'
{
  "python.defaultInterpreterPath": "${workspaceFolder}/.venv/bin/python"
}
EOF
    log_success "Created .vscode/settings.json"

    # Summary
    local final_branch
    if $new_branch; then
        final_branch="${branch_owner}/${worktree_name}"
    else
        final_branch="$branch"
    fi

    echo ""
    log_success "Worktree setup complete!"
    echo ""
    echo "  Path:   $worktree_path"
    echo "  Branch: $final_branch"
    echo "  Venv:   $worktree_path/.venv"
    echo ""
    echo "To use this worktree:"
    echo "  cd $worktree_path"
    echo ""

    # Hand the path back to a shell wrapper (see `yolo-worktree`) so it can cd there.
    # This script runs in its own process and cannot change the caller's cwd itself.
    if [[ -n "${YOLO_WORKTREE_PATH_FILE:-}" ]]; then
        printf '%s\n' "$worktree_path" > "$YOLO_WORKTREE_PATH_FILE"
    fi

    # Open VSCode if requested
    if $open_vscode; then
        if command -v code &>/dev/null; then
            log_info "Opening VSCode..."
            code "$worktree_path"
        else
            log_warn "VSCode 'code' command not found. Please open manually."
        fi
    fi
}

main "$@"
