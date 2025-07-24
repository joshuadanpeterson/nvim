-- plugins/autocomplete.lua
-- Sets up autocomplete for Neovim using Lua

return {

  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      'roobert/tailwindcss-colorizer-cmp.nvim',
      'amarakon/nvim-cmp-buffer-lines',
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('config.cmp')
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    version = 'v2.*',
    build = 'make install_jsregexp',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    after = 'nvim-cmp',
  },

  {
    'amarakon/nvim-cmp-buffer-lines',
    event = 'InsertEnter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  {
    'hrsh7th/cmp-buffer',
    after = 'nvim-cmp',
    config = function()
      require('cmp').setup {
        sources = {
          { name = 'buffer' },
        },
      }
    end,
  },

  {
    'hrsh7th/cmp-path',
    after = 'nvim-cmp',
    config = function()
      require('cmp').setup {
        sources = {
          { name = 'path' },
        },
      }
    end,
  },

  {
    'onsails/lspkind-nvim',
    after = 'nvim-cmp',
    config = function()
      require('lspkind').init()
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    after = 'nvim-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    after = 'nvim-cmp',
  },

  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      color_square_width = 2,
    },
  },

  {
    'David-Kunz/cmp-npm',
    ft = 'json',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('cmp-npm').setup {}
    end,
  },

  {
    'lukas-reineke/cmp-rg',
    event = 'InsertEnter',
  },

  {
    'hrsh7th/cmp-nvim-lua',
    event = 'InsertEnter',
  },

  {
    'hrsh7th/cmp-emoji',
    event = 'InsertEnter',
  },

  {
    'andersevenrud/cmp-tmux',
    event = 'InsertEnter',
  },

  {
    'hrsh7th/cmp-calc',
    event = 'InsertEnter',
  },

  {
    'ray-x/cmp-sql',
    event = 'InsertEnter',
  },

  {
    'ray-x/cmp-treesitter',
    event = 'InsertEnter',
  },
}
