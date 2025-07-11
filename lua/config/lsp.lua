-- Set filetype for init.lua
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'init.lua',
  callback = function()
    vim.bo.filetype = 'lua'
  end,
})

-- Load required plugins
local lspconfig = require('lspconfig')

-- Enhanced capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup neodev.nvim for better Lua LSP support
require('neodev').setup {
  library = { plugins = { 'nvim-dap-ui' }, types = true },
}

-- Setup mason
require('mason').setup({
  ui = {
    border = 'rounded',
  },
})

-- Note: mason-lspconfig setup temporarily disabled due to version compatibility issues
-- Install LSP servers manually through :Mason command
-- require('mason-lspconfig').setup({
--   ensure_installed = {
--     'lua_ls', 'ts_ls', 'pyright', 'html', 'cssls',
--     'bashls', 'rust_analyzer', 'gopls', 'phpactor',
--     'emmet_ls', 'solargraph', 'jsonls', 'yamlls',
--     'sqls', 'dockerls', 'vimls'
--   }
-- })

-- Common on_attach function for LSP servers
local on_attach = function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
  vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
end

-- Setup LSP keymaps for all LSP servers
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    on_attach(nil, ev.buf)
  end,
})

-- Manual LSP server configurations to avoid automatic_enable issues
-- Lua LSP
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

-- TypeScript/JavaScript LSP
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
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
})

-- HTML LSP
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'html' },
})

-- CSS LSP
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- Python LSP
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Emmet LSP
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
  init_options = {
    html = {
      options = {
        ['bem.enabled'] = true,
      },
    },
  },
})

-- Optional: Setup typescript.nvim plugin with filetype-based loading
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
--   callback = function()
--     require('typescript').setup {
--       disable_commands = false,
--       debug = false,
--       server = {
--         capabilities = capabilities,
--         filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
--         settings = {
--           typescript = {
--             inlayHints = {
--               includeInlayParameterNameHints = 'all',
--               includeInlayFunctionParameterTypeHints = true,
--               includeInlayVariableTypeHints = true,
--               includeInlayPropertyDeclarationTypeHints = true,
--               includeInlayFunctionLikeReturnTypeHints = true,
--               includeInlayEnumMemberValueHints = true,
--             },
--           },
--         },
--         init_options = {
--           hostInfo = 'neovim',
--           preferences = { quotePreference = 'single', allowIncompleteCompletions = false },
--         },
--         flags = { debounce_text_changes = 150 },
--       },
--     }
--   end,
-- })

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
