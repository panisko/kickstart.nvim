-- Core Neovim options and settings
-- Optimized for Python, YAML, and Ansible development

-- Leader keys (must be before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Font detection
vim.g.have_nerd_font = false

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Clipboard sync (scheduled to avoid startup slowdown)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Text handling
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- UI enhancement
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- Performance tuning
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Split handling
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 24-bit color
vim.opt.termguicolors = true

-- Language-specific indentation (Python = 4 spaces, YAML = 2 spaces)
-- These are defaults; specific filetype plugins override as needed
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Hide netrw (nvim-tree will replace it)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
