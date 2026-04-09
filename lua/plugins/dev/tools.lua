-- Development tools for Python, YAML, Ansible
return {
  { -- Debugger for Python
    'mfussenegger/nvim-dap',
    lazy = true,
    cmd = { 'DapToggleBreakpoint', 'DapContinue', 'DapStepOver' },
    dependencies = {
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Setup Python debugging
      require('dap-python').setup(vim.fn.exepath 'python3' or 'python')

      -- DAP UI auto-open/close
      dapui.setup()
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug [B]reakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug [C]ontinue' })
      vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = '[D]ebug [N]ext' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug [I]nto' })
      vim.keymap.set('n', '<leader>do', dap.step_out, { desc = '[D]ebug [O]ut' })
      vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = '[D]ebug [U]I toggle' })
    end,
  },

  { -- Test runner for Python
    'nvim-neotest/neotest',
    lazy = true,
    cmd = { 'Neotest' },
    dependencies = {
      'nvim-neotest/neotest-python',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
          },
        },
      }

      vim.keymap.set('n', '<leader>tr', function()
        require('neotest').run.run()
      end, { desc = '[T]est [R]un nearest' })

      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = '[T]est [F]ile' })

      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output_panel.toggle()
      end, { desc = '[T]est [O]utput' })
    end,
  },

  { -- TOML support
    'cespare/vim-toml',
    ft = { 'toml' },
  },

  { -- JSON/JSONC support
    'neovim/nvim-lspconfig',
    config = function()
      -- jsonls is already configured in lsp.lua, no additional setup needed here
    end,
  },

  { -- Task runner (for Ansible playbooks, Python scripts)
    'stevearc/overseer.nvim',
    lazy = true,
    cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerOpen' },
    config = function()
      require('overseer').setup {
        templates = { 'builtin', 'user.python', 'user.ansible' },
      }

      vim.keymap.set('n', '<leader>tr', '<cmd>OverseerRun<CR>', { desc = '[T]ask [R]un' })
      vim.keymap.set('n', '<leader>tt', '<cmd>OverseerToggle<CR>', { desc = '[T]ask [T]oggle' })
    end,
  },

  { -- Better git integration
    'tpope/vim-fugitive',
    lazy = true,
    cmd = { 'Git', 'GBrowse', 'Gdiffsplit', 'Gvdiffsplit', 'GDelete', 'GRename' },
    keys = {
      { '<leader>gs', '<cmd>Git<CR>', desc = '[G]it [S]tatus' },
      { '<leader>ga', '<cmd>Git add %<CR>', desc = '[G]it Add current file' },
      { '<leader>gc', '<cmd>Git commit<CR>', desc = '[G]it [C]ommit' },
      { '<leader>gp', '<cmd>Git push<CR>', desc = '[G]it [P]ush' },
      { '<leader>gl', '<cmd>Git log<CR>', desc = '[G]it [L]og' },
    },
  },
}
