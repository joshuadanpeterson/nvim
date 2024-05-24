-- LSP configurations

local lsp_zero = require 'lsp-zero'
lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps { buffer = bufnr }

  -- Custom keybindings for diagnostics
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>db', '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>dh', '<cmd>lua vim.diagnostic.open_float(nil, { scope = "cursor" })<CR>', opts) -- Expand diagnostics on hover
end)

-- Enhanced capabilities from nvim-cmp for LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
    'pyright',
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
    end,
    -- Custom handler for lua_ls
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
    end,
    -- Custom handler for tsserver
    tsserver = function()
      require('lspconfig').tsserver.setup {
        on_attach = function(client, bufnr)
          local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
          end
          local opts = { noremap = true, silent = true }
          buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          buf_set_keymap('n', '<space>rm', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          buf_set_keymap('n', '<space>rr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
          buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
          buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        end,
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
    on_attach = function(client, bufnr)
      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end
      local opts = { noremap = true, silent = true }
      buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
      buf_set_keymap('n', '<space>rm', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', '<space>rr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      buf_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
      buf_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    end,
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
  },
}

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
  },
}

-- Keybindings to show diagnostics in a floating window
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Set up nvim-lint to integrate with the LSP diagnostics
vim.cmd [[
  augroup NvimLint
    autocmd!
    autocmd BufWritePost,BufReadPost,InsertLeave * lua require('lint').try_lint()
  augroup END
]]
