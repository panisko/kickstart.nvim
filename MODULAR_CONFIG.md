# Neovim Modular Configuration

A fast, clean Neovim configuration optimized for Python, YAML, and Ansible development.

## Structure

```
nvim/
├── init.lua              # Minimal entry point
├── lua/
│   ├── config/
│   │   ├── options.lua   # Core vim options
│   │   ├── keymaps.lua   # Global keymaps
│   │   └── autocommands.lua  # Filetype-specific settings
│   └── plugins/
│       ├── ui.lua               # UI, telescope, file explorer
│       ├── lsp.lua              # Re-exports lsp/lsp.lua
│       ├── completion.lua       # Re-exports completion/cmp.lua
│       ├── dev.lua              # Re-exports dev/tools.lua
│       ├── lsp/
│       │   ├── lsp.lua          # Language servers (Python, Ansible, etc.)
│       │   └── formatting.lua   # Code formatting and linting
│       ├── completion/
│       │   └── cmp.lua         # nvim-cmp + snippets
│       └── dev/
│           └── tools.lua       # Debugging, testing, git integration
```

## Features

### Language Support
- **Python**: pyright, black, isort, ruff
- **YAML/Ansible**: ansiblels, yamllint, ansible-lint
- **Lua**: lua_ls with dev setup for Neovim config
- **Web**: prettier, jsonls (extensible)

### Development Tools
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- DAP for Python debugging
- Neotest for running tests
- Conform for formatting
- nvim-lint for linting
- Git integration (gitsigns, vim-fugitive)

### UI
- Tokyo Night color scheme
- Lualine status bar
- Which-key for keybind discovery
- Nvim-tree file explorer
- Mini modules (surround, AI, etc.)

## Loading Times

This configuration is optimized for fast startup:
- **Lazy loading**: Most plugins load on-demand (BufRead, InsertEnter, etc.)
- **Plugin isolation**: Each category in separate files
- **Minimal init.lua**: Only ~45 lines, delegates to modules
- **Modular options**: Only necessary settings, no bloat

## Quick Start

1. **Install**: Clone or copy to `~/.config/nvim/`
2. **First launch**: Neovim will bootstrap lazy.nvim and download plugins
3. **LSP/Tools**: Run `:Mason` to install language servers and tools
4. **Enjoy**: All configured and ready to go

## Customization

### Add a new plugin
1. Create a new spec in the appropriate `lua/plugins/*` file
2. Or create a new category file if it doesn't fit existing ones
3. Lazy.nvim will auto-load it next restart

### Modify language settings
- Update `lua/config/autocommands.lua` for file-specific settings
- Update `lua/plugins/lsp/lsp.lua` for LSP-specific configs
- Update `lua/plugins/lsp/formatting.lua` for formatter/linter settings

### Performance tweaks
- Adjust `updatetime` and `timeoutlen` in `lua/config/options.lua`
- Change lazy-loading strategy in plugin specs (e.g., `event = 'VimEnter'`)
- Profile with `:Lazy profile` command

## Keybinds

All keybinds use leader key (`<space>`). Press `<space>?` to see all available bindings via which-key.

Common bindings:
- `<space>sh` - Search help
- `<space>sf` - Search files
- `<space>sg` - Search grep
- `<space>f` - Format buffer
- `<leader>rn` - Rename symbol (LSP)
- `<leader>ca` - Code action (LSP)
- `gd` - Goto definition
- `gr` - Goto references

## License

Same as Neovim. See LICENSE.md
