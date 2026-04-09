-- Neovim Configuration - Modular & Optimized for Python, YAML, Ansible
-- =====================================================================
--
-- This is a clean, modular Neovim configuration designed for:
-- - Python development (pyright + black + isort + ruff)
-- - YAML & Ansible (ansiblels + yaml-language-server)
-- - Fast startup times through lazy loading
-- - Easy maintenance with organized plugin specs
--
-- Structure:
--   lua/config/        - Core settings, keymaps, autocommands
--   lua/plugins/       - Plugin specifications organized by category
--     ui.lua           - UI, appearance, file explorer, telescope
--     lsp/lsp.lua      - Language servers (Python, Ansible, Lua, etc.)
--     lsp/formatting.lua - Code formatting and linting
--     completion/cmp.lua - Autocompletion and snippets
--     dev/tools.lua    - Development tools (debugging, testing)

-- Set leader key (MUST be first)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

-- Load core configuration modules
require 'config.options'
require 'config.keymaps'
require 'config.autocommands'

-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Load modular plugin specifications ]]
require('lazy').setup {
  { import = 'plugins.ui' },
  { import = 'plugins.lsp' },
  { import = 'plugins.completion' },
  { import = 'plugins.dev' },
}

-- [[ Final UI tweaks ]]
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.opt.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et
