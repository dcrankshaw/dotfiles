# VS Code Vim Settings

This settings.json file converts your Vim configuration to work with VS Code and the Vim extension.

## Installation Steps

1. **Install the Vim extension**:
   - Open VS Code
   - Go to Extensions (Cmd+Shift+X)
   - Search for "Vim" by vscodevim
   - Install it

2. **Apply the settings**:
   - Open VS Code settings (Cmd+,)
   - Click "Open Settings (JSON)" in the top right
   - Copy the contents of `vscode-settings.json` and merge with your existing settings
   - Save the file

## Key Mappings Converted

### Window Navigation
- `<C-h/j/k/l>` - Navigate between split windows (same as Vim)

### Leader Key Shortcuts (Leader = `,`)
- `,nh` - Clear search highlighting
- `,w` - Create vertical split
- `,ev` - Open settings in split (replaces editing vimrc)
- `,o` - Insert blank line below without entering insert mode
- `,O` - Insert blank line above without entering insert mode
- `,=` - Equalize split widths
- `,be` - Buffer explorer (show all open editors)

### Other Mappings
- `<C-n>` - Toggle file explorer (replaces NERDTree)
- `//` - Toggle comment line (normal and visual mode)

## Settings Applied

### Editor Settings
- 2-space indentation with spaces (no tabs)
- Line numbers enabled
- Rulers at 80 and 100 columns
- Word wrap disabled

### Search Settings
- Case-insensitive search with smart case
- Incremental search
- Search highlighting
- File exclusions (same patterns as your CtrlP config)

### Vim Extension Settings
- System clipboard integration enabled
- Full Vim mode enabled
- Leader key set to comma (`,`)

## File Exclusions

The following file types are excluded from search (matching your CtrlP configuration):
- Build artifacts: `*.class`, `target/`, `CMakeFiles/`, `*.o`, `*.a`
- Temporary files: `*.swp`, `*.backup`
- Data files: `*.pyc`, `*.data`, `*.train`, `*.test`
- Archives: `*.pdf`, `*.tar`, `*.tgz`
- Development files: `assembly/`, `debug/googletest-src/`, etc.

## Usage Tips

1. **Buffer switching**: Use `,be` to get a searchable list of all open files (replaces BufExplorer)
2. **File navigation**: Use `<C-n>` to toggle the file explorer, or Cmd+P for quick file open
3. **Commenting**: Use `//` in normal or visual mode to toggle comments
4. **Splits**: Use `,w` to create splits, `<C-h/j/k/l>` to navigate between them
5. **Settings**: Use `,ev` to quickly open VS Code settings in a split

## Differences from Vim

- Theme/colorscheme: Uses your existing VS Code theme
- File finder: Uses VS Code's built-in Quick Open (Cmd+P) instead of FZF/CtrlP
- Git integration: Uses VS Code's built-in Git features
- Terminal: Uses VS Code's integrated terminal