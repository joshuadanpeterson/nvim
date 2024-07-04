-- plugins/lsp.lua
--[[
        lua.plugins.lsp: Configures the Language Server Protocol (LSP) support in Neovim, enabling features like auto-completion, go-to definition, and inline errors, Treesitter for enhanced syntax highlighting and language features. This includes setting up language servers, customizing LSP-related keybindings, and integrating with completion plugins.
]]

return {
  -- nvim-lspconfig for configuring language servers
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'williamboman/nvim-lsp-installer',
    },
  },

  -- Mason for managing LSP servers, linters, and formatters
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
      require('mason').setup {
        ui = {
          border = 'single',
        },
      }
    end,
  },

  -- Mason-LSPConfig to bridge Mason and nvim-lspconfig
  {
    'williamboman/mason-lspconfig.nvim',
    after = 'mason.nvim',
  },

  -- Neodev for Lua development with Neovim API support
  {
    'folke/neodev.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Trouble.nvim for an enhanced diagnostic list
  {
    'folke/trouble.nvim',
    dependencies = 'kyazdani42/nvim-web-devicons',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
    opts = {
      modes = {
        preview_float = {
          mode = 'diagnostics',
          preview = {
            type = 'float',
            relative = 'editor',
            border = 'rounded',
            title = 'Preview',
            title_pos = 'center',
            position = { 0, -2 },
            size = { width = 0.3, height = 0.3 },
            zindex = 200,
          },
        },
      },
    },
  },

  -- nvim-emmet | for integration with emmet-language-server
  {
    'olrtg/nvim-emmet',
    ft = { 'html', 'css', 'javascript', 'typescript', 'vue', 'svelte', 'jsx', 'tsx' },
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>de', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },

  -- lspsaga.nvim for beautiful UIs for various LSP-related features
  {
    'nvimdev/lspsaga.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('lspsaga').setup {}
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'kyazdani42/nvim-web-devicons',
    },
  },

  -- typescript.nvim for JSX autocompletion
  {
    'jose-elias-alvarez/typescript.nvim',
    ft = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
  },

  -- emmet-ls
  {
    'aca/emmet-ls',
    ft = { 'html', 'css', 'javascript', 'typescript', 'vue', 'svelte', 'jsx', 'tsx' },
  },

  -- lsp-zero for simplified LSP setup
  {
    'VonHeikemen/lsp-zero.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
  },

  -- lsp inlay-hints
  {
    'MysticalDevil/inlay-hints.nvim',
    event = 'LspAttach',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('inlay-hints').setup()
    end,
  },
}
