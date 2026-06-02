-- LSP configuration optimized for Python, YAML, and Ansible
local specs = {
  { -- Lua LSP configuration
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true, opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Setup autocommand for LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Navigation
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Symbols
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Code actions
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Document highlighting
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            local function client_supports_method(method)
              if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, event.buf)
              else
                return client.supports_method(method, { bufnr = event.buf })
              end
            end

            if client_supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
              local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })
              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })
            end

            -- Inlay hints
            if client_supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end
        end,
      })

      -- Diagnostic configuration
      if vim.g.have_nerd_font then
        local signs = { Error = '', Warn = '', Hint = '', Info = '' }
        for type, icon in pairs(signs) do
          local hl = 'DiagnosticSign' .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
      end

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      -- Capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- LSP Servers Configuration
      -- Optimized for Python, YAML, Ansible, and Web development
      local servers = {
        -- Python: Using pyright for better type checking
        pyright = {
          on_new_config = function(config, root_dir)
            -- Prefer .venv in the project root (uv / virtualenv convention)
            local venv_python = root_dir .. '/.venv/bin/python'
            if vim.fn.executable(venv_python) == 1 then
              config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
                python = { pythonPath = venv_python },
              })
            end
          end,
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = 'basic',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },

        -- Ansible Language Server
        ansiblels = {
          settings = {
            python = {
              interpreterPath = vim.fn.exepath 'python3' or 'python',
            },
          },
        },

        -- YAML LSP (useful for all YAML, especially Ansible playbooks)
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://raw.githubusercontent.com/ansible/ansible-specification/main/schemas/ansible.json'] = '*.yaml',
              },
              validate = true,
              hover = true,
              completion = true,
            },
          },
        },

        -- Lua LSP
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      -- Tools to ensure installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',       -- Lua formatter
        'black',        -- Python formatter
        'isort',        -- Python import sorter
        'ruff',         -- Python linter
        'yamllint',     -- YAML linter
        'ansible-lint', -- Ansible linter
        'prettier',     -- JavaScript/JSON formatter
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

-- Merge with formatting and linting plugins
local formatting_specs = require 'plugins.lsp.formatting'
for _, spec in ipairs(formatting_specs) do
  table.insert(specs, spec)
end

return specs
