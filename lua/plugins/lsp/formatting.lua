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

      -- Run only linters whose executable is available on PATH
      local function try_lint_available()
        if not vim.opt_local.modifiable:get() then
          return
        end

        local ft = vim.bo.filetype
        local linter_names = lint._resolve_linter_by_ft(ft)
        local names_to_run = {}

        for _, name in ipairs(linter_names) do
          local linter = lint.linters[name]
          if linter then
            local cmd = type(linter) == 'table' and linter.cmd or name
            if type(cmd) == 'function' then
              cmd = cmd()
            end
            if type(cmd) == 'string' and vim.fn.executable(cmd) == 1 then
              table.insert(names_to_run, name)
            end
          end
        end

        if #names_to_run > 0 then
          lint.try_lint(names_to_run)
        end
      end

      -- Setup autocommand for linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          try_lint_available()
        end,
      })

      vim.keymap.set('n', '<leader>tl', try_lint_available, { desc = '[T]oggle [L]int' })
    end,
  },
}
