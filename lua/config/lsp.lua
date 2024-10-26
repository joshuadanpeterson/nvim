-- Set filetype for init.lua
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'init.lua',
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})

-- Load lsp-zero and apply preset
local lsp_zero = require 'lsp-zero'
lsp_zero.extend_lspconfig()
lsp_zero.preset 'recommended'

-- Attach default keymaps using lsp-zero
lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps { buffer = bufnr }
end)

-- Load required plugins
local lspconfig = require 'lspconfig'
local cmp = require 'cmp'

-- Set lsp-zero preferences
lsp_zero.set_preferences {
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
}

-- Enhanced capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup neodev.nvim for better Lua LSP support
require('neodev').setup {
  ui = { border = 'rounded' },
  library = { plugins = { 'nvim-dap-ui' }, types = true },
}

-- Configure mason for LSP installations
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls', 'ts_ls', 'basedpyright', 'html', 'cssls',
    'bashls', 'rust_analyzer', 'gopls', 'phpactor',
    'emmet_ls', 'solargraph', 'jsonls', 'yamlls',
    'sqls', 'dockerls', 'vimls'
  },
  handlers = {
    function(server_name)
      lspconfig[server_name].setup { capabilities = capabilities }
    end,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lua_opts.capabilities = capabilities
      lua_opts.settings = {
        Lua = {
          runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
          telemetry = { enable = false },
          hint = { enable = true },
        },
      }
      lspconfig.lua_ls.setup(lua_opts)
    end,
    ts_ls = function()
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        init_options = {
          hostInfo = 'neovim',
          preferences = { quotePreference = 'single', allowIncompleteCompletions = false },
        },
        disableSuggestions = true,
      }
    end,
    html = function()
      lspconfig.html.setup {
        cmd = { '/path/to/html-languageserver', '--stdio' },
        filetypes = { 'html', 'htmldjango', 'handlebars', 'javascript', 'typescriptreact', 'javascriptreact' },
        capabilities = capabilities,
        init_options = {
          configurationSection = { 'html', 'css', 'javascript' },
          embeddedLanguages = { css = true, javascript = true },
          provideFormatter = true,
        },
      }
    end,
    emmet_ls = function()
      lspconfig.emmet_ls.setup {
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'javascript' },
        init_options = {
          html = { options = { ['bem.enabled'] = true } },
        },
      }
    end,
  },
}

-- Additional custom LSP configurations
lspconfig.basedpyright.setup {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
}

-- Optional: Setup typescript.nvim plugin with filetype-based loading
vim.api.nvim_create_autocmd("FileType", {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    require('typescript').setup {
      disable_commands = false,
      debug = false,
      server = {
        capabilities = capabilities,
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        init_options = {
          hostInfo = 'neovim',
          preferences = { quotePreference = 'single', allowIncompleteCompletions = false },
        },
        flags = { debounce_text_changes = 150 },
      },
    }
  end,
})

-- Finalize LSP setup
lsp_zero.setup()

-- Diagnostic customization
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = 'always',
    border = 'rounded',
    focusable = true,
  },
}

-- Set border for LspInfo
require('lspconfig.ui.windows').default_options.border = 'single'

-- Custom lint integration
vim.cmd [[
  augroup NvimLint
    autocmd!
    autocmd BufWritePost,BufReadPost,InsertLeave * lua require('lint').try_lint()
  augroup END
]]

-- Google Apps Script filetype as JavaScript
vim.cmd [[
  autocmd BufRead,BufNewFile *script.google.com_*.txt set filetype=javascript
]]
