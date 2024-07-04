-- LSP configurations
-- Ensure that the correct filetype is set for your init.lua
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'init.lua',
  callback = function()
    vim.bo.filetype = 'lua'
    -- print 'LSP Filetype set to lua for init.lua'
  end,
})

local lsp_zero = require 'lsp-zero'
lsp_zero.extend_lspconfig()
lsp_zero.preset 'recommended' -- firenvim addition

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps { buffer = bufnr }
end)

local lspconfig = require 'lspconfig' -- firenvim addition
local cmp = require 'cmp' -- firenvim addition

lsp_zero.set_preferences { -- firenvim addition
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
}

-- Enhanced capabilities from nvim-cmp for LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true -- firenvim addition
-- For emmet-ls
local emmet_capabilities = vim.lsp.protocol.make_client_capabilities()
emmet_capabilities.textDocument.completion.completionItem.snippetSupport = true

-- neodev.nvim setup ahead of LSP config
require('neodev').setup {
  ui = {
    border = 'rounded',
  },
  library = {
    plugins = { 'nvim-dap-ui' },
    types = true,
  },
}

-- Setup mason to manage LSP installations
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls',
    'tsserver',
    'basedpyright',
    'html',
    'cssls',
    'bashls',
    'rust_analyzer',
    'gopls',
    'phpactor',
    'emmet_ls',
    'solargraph',
    'jsonls',
    'yamlls',
    'sqls',
    'dockerls',
    'vimls',
  },
  handlers = {
    -- Default handler
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
      }
      -- print('LSP server ' .. server_name .. ' configured with nvim-cmp capabilities')
    end,
    -- Custom handler for lua_ls
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      lua_opts.capabilities = capabilities
      lua_opts.settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
          hint = {
            enable = true, -- necessary
          },
        },
      }
      require('lspconfig').lua_ls.setup(lua_opts)
      -- print 'Lua LSP configured with nvim-cmp capabilities'
    end,
    -- Custom handler for tsserver
    tsserver = function()
      require('lspconfig').tsserver.setup {
        -- on_attach = function(client, bufnr)
        --   client.resolved_capabilities.document_formatting = false
        -- end,
        -- cmd = { 'typescript-language-server', '--stdio' },
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
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            -- documentFormatting = false,
          },
        },
        init_options = {
          hostInfo = 'neovim',
          preferences = {
            quotePreference = 'single',
            allowIncompleteCompletions = false,
          },
        },
        disableSuggestions = true,
      }
    end,
    -- Custom handler for html
    html = function()
      require('lspconfig').html.setup {
        cmd = { '/System/Volumes/Data/Users/joshpeterson/.nvm/versions/node/v18.12.1/bin/html-languageserver', '--stdio' },
        filetypes = { 'html', 'htmldjango', 'handlebars', 'javascript', 'typescriptreact', 'javascriptreact' },
        init_options = {
          configurationSection = { 'html', 'css', 'javascript' },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
        },
        capabilities = capabilities,
      }
    end,
    -- Custom handler for emmet_ls
    emmet_ls = function()
      require('lspconfig').emmet_ls.setup {
        capabilities = emmet_capabilities,
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'javascript' },
        init_options = {
          html = {
            options = {
              -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
              ['bem.enabled'] = true,
            },
          },
        },
      }
    end,
  },
}

-- Configure TypeScript server with typescript.nvim
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
      preferences = {
        quotePreference = 'single',
        allowIncompleteCompletions = false,
      },
    },
    on_attach = function(client, bufnr)
      print('Attaching to', bufnr)
    end,
    flags = {
      debounce_text_changes = 150,
    },
    handlers = {
      ['window/logMessage'] = function(err, method, params, client_id)
        print(method, vim.inspect(params))
      end,
      ['window/showMessage'] = function(err, method, params, client_id)
        print(method, vim.inspect(params))
      end,
    },
  },
}

-- Customize LSP status messages
-- vim.lsp.handlers['$/progress'] = function() end
-- vim.lsp.handlers['window/showMessageRequest'] = function(_, result, _)
--   -- Do something with the message request or ignore it
-- end

-- Finalize the LSP setup
lsp_zero.setup()

-- Customizing diagnostic display
vim.diagnostic.config {
  virtual_text = false, -- Enable inline diagnostics
  signs = true, -- Show signs in the sign column
  underline = true, -- Underline diagnostics
  update_in_insert = false, -- Update diagnostics in insert mode
  severity_sort = true, -- Sort diagnostics by severity
  float = {
    source = 'always', -- Show the source of the diagnostic
    border = 'rounded', -- Rounded border for floating windows
    focusable = true,
  },
}

-- Set border for LspInfo
require('lspconfig.ui.windows').default_options.border = 'single'

-- Set up nvim-lint to integrate with the LSP diagnostics
vim.cmd [[
  augroup NvimLint
    autocmd!
    autocmd BufWritePost,BufReadPost,InsertLeave * lua require('lint').try_lint()
  augroup END
]]

-- Set filetype for Google Apps Script files as JavaScript
vim.cmd(
  [[
  autocmd BufRead,BufNewFile *script.google.com_*.txt set filetype=javascript
]],
  false
)
