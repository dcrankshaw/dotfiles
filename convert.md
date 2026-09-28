# Vim to VS Code Settings Conversion Plan

## Overview
Converting `/Users/dancrankshaw/dotfiles/vimrc` to VS Code `settings.json` for use with the VSCode Vim extension.

## Current Vim Configuration Analysis

### Plugins Used
- **scrooloose/nerdcommenter** - Code commenting
- **scrooloose/nerdtree** - File tree explorer (mapped to `<C-n>`)
- **tpope/vim-fugitive** - Git integration
- **tpope/vim-sensible** - Sensible defaults
- **junegunn/fzf** + **fzf.vim** - Fuzzy file finder
- **junegunn/goyo.vim** - Distraction-free writing
- **bfrg/vim-cpp-modern** - C++ syntax highlighting
- **corntrace/bufexplorer** - Buffer management
- **ctrlpvim/ctrlp.vim** - File finder (with custom ignore patterns)
- **tomtom/tcomment_vim** - Toggle comments (mapped to `//`)
- **altercation/vim-colors-solarized** - Color scheme

### Key Mappings
- **Leader key**: `,` (comma)
- **Window navigation**: `<C-h/j/k/l>` for moving between splits
- **NERDTree toggle**: `<C-n>`
- **Comment toggle**: `//` (visual and normal mode)
- **Custom shortcuts**:
  - `<leader>ev` - Edit vimrc in vertical split
  - `<leader>w` - Create vertical split and move to it
  - `<leader>nh` - Clear search highlighting
  - `<leader>o` - Insert line below without entering insert mode
  - `<leader>O` - Insert line above without entering insert mode
  - `<leader>re` - Reload/edit vimrc
  - `<leader>rs` - Source vimrc
  - `<leader>=` - Equalize window sizes

### Editor Settings
- **Indentation**: 2 spaces, expand tabs
- **Search**: hlsearch, ignorecase, smartcase, incsearch
- **Display**: Line numbers, ruler, show mode, show matching brackets
- **Splits**: splitbelow, splitright
- **Other**: nowrap, hidden buffers, auto-change directory to file location

### Visual Settings
- **Color scheme**: Solarized dark with true color support
- **UI**: No visual bell, no error bells, always show status line

## Conversion Strategy

### 1. VS Code Extensions Needed
- **ms-vscode.vscode-vim** - Core Vim emulation (full mode)

### 2. Plugin Functionality Mapping

| Vim Plugin | VS Code Equivalent | Implementation |
|------------|-------------------|----------------|
| NERDTree | Built-in Explorer | Configure Explorer + Vim bindings |
| NERDCommenter/TComment | Built-in commenting | Configure `//` binding for Vim |
| FZF/CtrlP | Quick Open (Cmd+P) | Configure file exclusions in search settings |
| BufExplorer | Tab management | Use `<leader>be` → "View: Show All Editors" or Quick Open |

### 3. Settings.json Structure

```json
{
  // VS Code Editor Settings
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.lineNumbers": "on",
  "editor.rulers": [80, 100],
  "editor.wordWrap": "off",
  "editor.showFoldingControls": "always",
  
  // VS Code UI Settings
  "workbench.startupEditor": "none",
  "explorer.confirmDelete": false,
  
  // Search Settings (from CtrlP exclusions)
  "search.useIgnoreFiles": true,
  "search.exclude": {
    "**/*.class": true,
    "**/target/**": true,
    "**/*.swp": true,
    "**/assembly/**": true,
    "**/*.backup": true,
    "**/*.pyc": true,
    "**/*.data": true,
    "**/*.train": true,
    "**/*.test": true,
    "**/*.pdf": true,
    "**/*.tar": true,
    "**/*.tgz": true,
    "**/CMakeFiles/**": true,
    "**/debug/googletest-src/**": true,
    "**/release/googletest-src/**": true,
    "**/*.dia": true,
    "**/*.o": true,
    "**/*.a": true
  },
  
  // Vim Extension Settings
  "vim.leader": ",",
  "vim.useSystemClipboard": true,
  "vim.hlsearch": true,
  "vim.ignorecase": true,
  "vim.smartcase": true,
  "vim.incsearch": true,
  "vim.enableNeovim": false,
  
  // Vim Key Bindings
  "vim.normalModeKeyBindingsNonRecursive": [
    // Window navigation (critical workflow)
    {
      "before": ["<C-h>"],
      "commands": ["workbench.action.focusLeftGroup"]
    },
    {
      "before": ["<C-j>"],
      "commands": ["workbench.action.focusBelowGroup"]
    },
    {
      "before": ["<C-k>"],
      "commands": ["workbench.action.focusAboveGroup"]
    },
    {
      "before": ["<C-l>"],
      "commands": ["workbench.action.focusRightGroup"]
    },
    // Leader key shortcuts (critical workflow)
    {
      "before": ["<leader>", "n", "h"],
      "commands": [":nohl"]
    },
    {
      "before": ["<leader>", "w"],
      "commands": ["workbench.action.splitEditor"]
    },
    {
      "before": ["<leader>", "e", "v"],
      "commands": ["workbench.action.splitEditor", "workbench.action.openSettings"]
    },
    {
      "before": ["<leader>", "o"],
      "after": ["o", "<Esc>", "k"]
    },
    {
      "before": ["<leader>", "O"],
      "after": ["O", "<Esc>", "j"]
    },
    {
      "before": ["<leader>", "="],
      "commands": ["workbench.action.evenEditorWidths"]
    },
    // Buffer/Tab management (replaces BufExplorer)
    {
      "before": ["<leader>", "b", "e"],
      "commands": ["workbench.action.showAllEditors"]
    },
    // File tree toggle
    {
      "before": ["<C-n>"],
      "commands": ["workbench.view.explorer"]
    },
    // Comment toggle (critical workflow)
    {
      "before": ["/", "/"],
      "commands": ["editor.action.commentLine"]
    }
  ],
  
  "vim.visualModeKeyBindingsNonRecursive": [
    // Comment toggle in visual mode (critical workflow)
    {
      "before": ["/", "/"],
      "commands": ["editor.action.commentLine"]
    }
  ],
  
  "vim.insertModeKeyBindings": []
}
```

### 4. Implementation Steps

1. **Install Required Extension**
   - Install VSCode Vim extension (`ms-vscode.vscode-vim`)

2. **Update Global settings.json**
   - Open VS Code settings (Cmd+, then click "Open Settings (JSON)")
   - Merge the configuration above with existing settings
   - Test key bindings

3. **Test Critical Workflows**
   - Verify window navigation (`<C-h/j/k/l>`) works between splits
   - Test comment toggling with `//`
   - Validate leader key shortcuts (`,nh`, `,w`, `,o`, `,O`, `,ev`)
   - Ensure search behavior matches Vim expectations

4. **Fine-tuning**
   - Adjust any problematic key bindings
   - Test file exclusions in search
   - Verify system clipboard integration works

## Updated Requirements (Based on User Feedback)

1. **File Location**: Global VS Code settings
2. **Critical Workflows**: 
   - Window/split navigation (`<C-h/j/k/l>`)
   - Comment toggling (`//`)
   - Leader key shortcuts (`,ev`, `,w`, `,nh`, `,o`, `,O`, `,be`)
   - Search behavior (hlsearch, smartcase, etc.)
3. **Theme**: Use existing VS Code theme (ignore Solarized)
4. **Git Integration**: Ignore fugitive/GitLens (not used)
5. **Vim Mode**: Full Vim mode with system clipboard integration
6. **File Exclusions**: Map to search exclusions only

## Buffer/Tab Management Options for `<leader>be`

VS Code has several built-in commands that can replicate BufExplorer functionality:

### Option 1: Show All Editors (Recommended)
**Command**: `workbench.action.showAllEditors`
- Shows a searchable list of all open editors/tabs
- Similar to BufExplorer's list view
- Allows typing to filter and Enter to switch
- Shows file paths to distinguish between files with same names

### Option 2: Quick Open Recent Files
**Command**: `workbench.action.quickOpenPreviousRecentlyUsedEditor`
- Shows recently used files in MRU (Most Recently Used) order
- More similar to traditional buffer switching
- Press repeatedly to cycle through recent files

### Option 3: Quick Open with Tab Picker
**Command**: `workbench.action.quickOpenPreviousEditor`
- Similar to Cmd+Tab behavior for editors
- Cycles through editors in order

**Recommendation**: Using `workbench.action.showAllEditors` as it most closely matches BufExplorer's searchable list interface.

- Focus on critical workflows: window navigation, commenting, leader shortcuts, search
- Using existing VS Code theme (no theme changes needed)
- Full Vim mode enabled with system clipboard integration
- File exclusions mapped to search settings only (not file watcher)
- `,ev` mapping opens VS Code settings instead of vimrc
- `,o` and `,O` mappings preserved for inserting blank lines
- Auto-directory change feature omitted (not needed)
- Git integration uses VS Code built-ins (no additional extensions)