alias k=kubectl

ytmux() {
  local jobname="${1:-${YOLO_DEFAULT_JOB:-dancrankshaw-devbox}}"
  local ctx_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_KUBECTL_CONTEXT" ]]; then
    ctx_flag="--context=${YOLO_KUBECTL_CONTEXT}"
    cluster_display="$YOLO_KUBECTL_CONTEXT"
  fi
  echo "→ cluster: ${cluster_display}  job: ${jobname}" >&2
  kubectl $ctx_flag -n dancrankshaw cp ~/dotfiles/tmux_conf "${jobname}-0:/root/.tmux.conf"
}

ydevbox() {
  local jobname="${1:-${YOLO_DEFAULT_JOB:-dancrankshaw-devbox}}"
  local ctx_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_KUBECTL_CONTEXT" ]]; then
    ctx_flag="--context=${YOLO_KUBECTL_CONTEXT}"
    cluster_display="$YOLO_KUBECTL_CONTEXT"
  fi
  echo "→ cluster: ${cluster_display}  job: ${jobname}" >&2
  kubectl $ctx_flag exec -it -n dancrankshaw "${jobname}-0" -- bash
}

ysync() {
  local repo_root
  local jobname="${1:-${YOLO_DEFAULT_JOB:-dancrankshaw-devbox}}"
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi
  local cluster_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
    cluster_flag="--cluster=${YOLO_CLUSTER_NAME}"
    cluster_display="$YOLO_CLUSTER_NAME"
  fi
  echo "→ cluster: ${cluster_display}  job: ${jobname}" >&2
  (cd "$repo_root" && uv run yolo $cluster_flag sync --job-name "${jobname}")
}

ycluster() {
  local cluster="$1"
  if [[ -z "$cluster" ]]; then
    echo "Current contexts:"
    echo "  yolo:  $(grep '^current-context:' ~/.yolo/config | cut -d' ' -f2)"
    echo "  kube:  $(kubectl config current-context)"
    if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
      echo "  direnv (this worktree): $YOLO_CLUSTER_NAME  job=${YOLO_DEFAULT_JOB:-<default>}"
    else
      echo "  direnv: <not set — using global config>"
    fi
    echo ""
    echo "Usage: ycluster <cluster-name>"
    echo "Available clusters: $(grep -E '^\s*cluster:' ~/.yolo/config | awk '{print $2}' | tr '\n' ' ')"
    return 1
  fi

  # Update yolo config
  if grep -q "^- name: ${cluster}$" ~/.yolo/config; then
    sed -i '' "s/^current-context:.*/current-context: ${cluster}/" ~/.yolo/config
    echo "Updated ~/.yolo/config to: ${cluster}"
  else
    echo "Warning: Cluster '${cluster}' not found in ~/.yolo/config"
  fi

  # Update kube config
  if kubectl config use-context "$cluster" 2>/dev/null; then
    echo "Updated ~/.kube/config to: ${cluster}"
  else
    echo "Warning: Context '${cluster}' not found in ~/.kube/config"
  fi
}
# Remove old aliases so they can be redefined as functions
unalias ylist 2>/dev/null
unalias yracks 2>/dev/null

ylist() {
  local cluster_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
    cluster_flag="--cluster=${YOLO_CLUSTER_NAME}"
    cluster_display="$YOLO_CLUSTER_NAME"
  fi
  echo "→ cluster: ${cluster_display}" >&2
  uv run yolo $cluster_flag list "$@"
}

yracks() {
  local cluster_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
    cluster_flag="--cluster=${YOLO_CLUSTER_NAME}"
    cluster_display="$YOLO_CLUSTER_NAME"
  fi
  echo "→ cluster: ${cluster_display}" >&2
  uv run yolo $cluster_flag describe racks "$@"
}

yinteractive() {
  local cluster_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
    cluster_flag="--cluster=${YOLO_CLUSTER_NAME}"
    cluster_display="$YOLO_CLUSTER_NAME"
  fi
  echo "→ cluster: ${cluster_display}" >&2
  uv run yolo $cluster_flag interactive "$@"
}

ydelete() {
  local jobname="${1:-${YOLO_DEFAULT_JOB:-}}"
  if [[ -z "$jobname" ]]; then
    echo "Usage: ydelete <job-name>"
    echo "  (or set YOLO_DEFAULT_JOB via ysetcluster)"
    return 1
  fi
  local cluster_flag=""
  local cluster_display="<global config>"
  if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
    cluster_flag="--cluster=${YOLO_CLUSTER_NAME}"
    cluster_display="$YOLO_CLUSTER_NAME"
  fi
  echo "→ cluster: ${cluster_display}  job: ${jobname}" >&2
  uv run yolo $cluster_flag delete "$jobname"
}

yolo-worktree() {
      "$HOME/yolo/user_scripts/dancrankshaw/devtools/create-worktree.sh" "$@"
}

# If you currently have: alias mai-claude="~/mai-agents/claude.sh --model opus"
# remove it first (harmless if it doesn't exist)
unalias mai-claude 2>/dev/null
unalias cc 2>/dev/null

# iTerm2 tab color helpers (work only in iTerm2, ignored elsewhere)
_iterm_tab_rgb() {
  local r=$1 g=$2 b=$3
  printf '\033]6;1;bg;red;brightness;%d\a'   "$r"
  printf '\033]6;1;bg;green;brightness;%d\a' "$g"
  printf '\033]6;1;bg;blue;brightness;%d\a'  "$b"
}

_iterm_tab_reset() {
  printf '\033]6;1;bg;*;default\a'
}

# Wrapper: tab orange while running, reset afterward
cc() {
  # orange (tweak if you want a different shade)
  _iterm_tab_rgb 255 140 0

  # always reset on exit or Ctrl-C
  trap '_iterm_tab_reset' EXIT INT TERM

  # run the real command (bypass aliases/functions with "command")
  command ~/mai-agents/claude.sh "$@"
  local rc=$?

  # cleanup
  trap - EXIT INT TERM
  _iterm_tab_reset
  return $rc
}

ysetcluster() {
  local cluster="$1"
  local jobname="${2:-}"

  if [[ -z "$cluster" ]]; then
    echo "Usage: ysetcluster <cluster> [default-jobname]"
    echo ""
    echo "Sets the cluster for the current worktree via direnv."
    echo "Available clusters: falcon-phx-ga falcon-phx-ca falcon-satx-ca falcon-phx-gb"
    echo ""
    if [[ -n "$YOLO_CLUSTER_NAME" ]]; then
      echo "Active (from .envrc): cluster=$YOLO_CLUSTER_NAME job=${YOLO_DEFAULT_JOB:-<default>}"
    else
      echo "No per-worktree cluster set (using global config)."
    fi
    return 1
  fi

  local repo_root
  repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$repo_root" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  local envrc="$repo_root/.envrc"

  # Write .envrc
  cat > "$envrc" <<EOF
export YOLO_CLUSTER_NAME=${cluster}
export YOLO_KUBECTL_CONTEXT=${cluster}
EOF

  if [[ -n "$jobname" ]]; then
    echo "export YOLO_DEFAULT_JOB=${jobname}" >> "$envrc"
  fi

  direnv allow "$envrc"
  echo "Wrote $envrc"
  echo "  cluster: $cluster"
  [[ -n "$jobname" ]] && echo "  default job: $jobname"
  echo ""
  echo "This worktree will now auto-target $cluster when you cd into it."
}

# --- Cluster-prefixed wrappers (auto-generated) ---
_YOLO_CLUSTERS=(falcon-phx-ga falcon-phx-ca falcon-satx-ca falcon-phx-gb)

for _cluster in "${_YOLO_CLUSTERS[@]}"; do

  # ysync
  eval "${_cluster}-ysync() {
    local jobname=\"\${1:-dancrankshaw-devbox}\"
    local repo_root
    repo_root=\$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -z \"\$repo_root\" ]]; then
      echo \"Error: Not in a git repository\"
      return 1
    fi
    echo \"→ cluster: ${_cluster}  job: \${jobname}\" >&2
    (cd \"\$repo_root\" && uv run yolo --cluster=${_cluster} sync --job-name \"\${jobname}\")
  }"

  # ytmux
  eval "${_cluster}-ytmux() {
    local jobname=\"\${1:-dancrankshaw-devbox}\"
    echo \"→ cluster: ${_cluster}  job: \${jobname}\" >&2
    kubectl --context=${_cluster} -n dancrankshaw cp ~/dotfiles/tmux_conf \"\${jobname}-0:/root/.tmux.conf\"
  }"

  # ydevbox
  eval "${_cluster}-ydevbox() {
    local jobname=\"\${1:-dancrankshaw-devbox}\"
    echo \"→ cluster: ${_cluster}  job: \${jobname}\" >&2
    kubectl --context=${_cluster} exec -it -n dancrankshaw \"\${jobname}-0\" -- bash
  }"

  # ylist
  eval "${_cluster}-ylist() {
    echo \"→ cluster: ${_cluster}\" >&2
    uv run yolo --cluster=${_cluster} list \"\$@\"
  }"

  # yracks
  eval "${_cluster}-yracks() {
    echo \"→ cluster: ${_cluster}\" >&2
    uv run yolo --cluster=${_cluster} describe racks \"\$@\"
  }"

  # yinteractive
  eval "${_cluster}-yinteractive() {
    echo \"→ cluster: ${_cluster}\" >&2
    uv run yolo --cluster=${_cluster} interactive \"\$@\"
  }"

  # ydelete
  eval "${_cluster}-ydelete() {
    local jobname=\"\${1:-}\"
    if [[ -z \"\$jobname\" ]]; then
      echo \"Usage: ${_cluster}-ydelete <job-name>\"
      return 1
    fi
    echo \"→ cluster: ${_cluster}  job: \${jobname}\" >&2
    uv run yolo --cluster=${_cluster} delete \"\$jobname\"
  }"

done
unset _cluster _YOLO_CLUSTERS
