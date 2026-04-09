-- Formatting and linting plugins
return {
  { -- Code formatting
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        yaml = { 'yamllint' },
        json = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
      },
    },
  },

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Define linters
      lint.linters_by_ft = {
        python = { 'ruff' },
        yaml = { 'yamllint' },
        ansible = { 'ansible-lint' },
        bash = { 'shellcheck' },
        lua = { 'luacheck' },
      }

      -- Setup autocommand for linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          pcall(lint.try_lint)
        end,
      })

      vim.keymap.set('n', '<leader>tl', function()
        lint.try_lint()
      end, { desc = '[T]oggle [L]int' })
    end,
  },
}
