-- plugins/lsp.lua
--[[
        custom.plugins.lsp: Configures the Language Server Protocol (LSP) support in Neovim, enabling features like auto-completion, go-to definition, and inline errors, Treesitter for enhanced syntax highlighting and language features. This includes setting up language servers, customizing LSP-related keybindings, and integrating with completion plugins.
]]

return {
  -- nvim-lspconfig for configuring language servers
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },

  -- Mason for managing LSP servers, linters, and formatters
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup {
        ui = {
          border = 'single', -- Set border style
        },
      }
    end,
  },

  -- Mason-LSPConfig to bridge Mason and nvim-lspconfig
  { 'williamboman/mason-lspconfig.nvim' },

  -- Neodev for Lua development with Neovim API support
  { 'folke/neodev.nvim' },

  -- Trouble.nvim for an enhanced diagnostic list
  {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup {
        -- Configuration options
      }
    end,
  },

  -- nvim-emmet | for integration with emmet-language-server
  {
    'olrtg/nvim-emmet',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },

  -- lspsaga.nvim for beautiful UIs for various LSP-related features
  {
    'nvimdev/lspsaga.nvim',
    config = function()
      require('lspsaga').setup {}
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'kyazdani42/nvim-web-devicons', -- optional
    },
  },

  -- For using glow for LSP hover
  {
    'JASONews/glow-hover',
    config = function()
      require('glow-hover').setup {
        -- The followings are the default values
        max_width = 50,
        padding = 10,
        border = 'shadow',
        glow_path = 'glow',
      }
    end,
  },

  -- typescript.nvim for JSX autocompletion
  'jose-elias-alvarez/typescript.nvim',

  -- emmet-ls
  'aca/emmet-ls',

  -- lsp-zero for simplified LSP setup
  'VonHeikemen/lsp-zero.nvim',
}
