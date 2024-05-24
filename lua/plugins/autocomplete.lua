-- plugins/autocomplete.lua
-- Sets up autocomplete for Neovim using Lua

return {

  -- Autocompletion plugin for Neovim that uses a modern architecture
  {
    'hrsh7th/nvim-cmp',
    lazy = false,
    priority = 100,
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
    end,
  },

  -- LuaSnip: A snippet engine for Neovim written in Lua
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip', -- luasnip completion source for nvim-cmp
      'rafamadriz/friendly-snippets', -- A collection of snippets for various programming languages
    },
    version = 'v2.*', -- Follow latest release
    build = 'make install_jsregexp',
  },

  -- nvim-cmp source for Neovim's built-in LSP
  {
    'hrsh7th/cmp-nvim-lsp',
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
  },

  -- nvim-cmp-buffer-lines for buffer autocomplete
  {
    'amarakon/nvim-cmp-buffer-lines',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- nvim-cmp/cmp-buffer
  {
    'hrsh7th/cmp-buffer',
    config = function()
      require('cmp').setup {
        sources = {
          { name = 'buffer' },
        },
      }
    end,
  },

  -- nvim-cmp/cmp-path
  {
    'hrsh7th/cmp-path',
    config = function()
      require('cmp').setup {
        sources = {
          { name = 'path' },
        },
      }
    end,
  },

  -- Adds VSCode-like pictograms
  {
    'onsails/lspkind-nvim',
    after = 'nvim-cmp',
    config = function()
      require('lspkind').init()
    end,
  },

  -- copilot-cmp for GitHub Copilot completions
  {
    'zbirenbaum/copilot-cmp',
    after = 'nvim-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  -- cmp-cmdline for command line completion
  {
    'hrsh7th/cmp-cmdline',
    after = 'nvim-cmp',
  },

  -- Tailwind Colorizer
  {
    'roobert/tailwindcss-colorizer-cmp.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      color_square_width = 2,
    },
  },

  -- cmp-npm for package autocomplete
  {
    'David-Kunz/cmp-npm',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = 'json',
    config = function()
      require('cmp-npm').setup {}
    end,
  },

  -- ripgrep source for completion
  {
    'lukas-reineke/cmp-rg',
  },

  -- nvim-cmp source for neovim Lua API
  {
    'hrsh7th/cmp-nvim-lua',
  },

  -- nvim-cmp source for emojis
  {
    'hrsh7th/cmp-emoji',
  },

  -- Tmux completion source for nvim-cmp-buffer-lines
  {
    'andersevenrud/cmp-tmux',
  },

  -- nvim-cmp source for math calculation
  {
    'hrsh7th/cmp-calc',
  },

  -- -- Neovim CSS Intellisense for HTML
  -- {
  --   'Jezda1337/nvim-html-css',
  --   event = { 'BufReadPre', 'BufNewFile' },
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'nvim-lua/plenary.nvim',
  --   },
  --   config = function()
  --     require('html-css'):setup()
  --   end,
  -- },

  -- nvim-cmp source for sql keywords
  {
    'ray-x/cmp-sql',
  },

  -- nvim-cmp source for treesitter nodes
  {
    'ray-x/cmp-treesitter',
  },
}
