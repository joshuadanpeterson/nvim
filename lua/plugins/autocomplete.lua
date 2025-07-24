-- plugins/autocomplete.lua
-- Sets up autocomplete for Neovim using Lua

return {
  -- Main nvim-cmp plugin with all completion sources as dependencies
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet engine (required)
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        -- Remove build step to prevent startup execution
        -- build = 'make install_jsregexp', -- Commented out to avoid startup execution
        config = function()
          -- Optionally run the build command manually after InsertEnter
          vim.api.nvim_create_autocmd('InsertEnter', {
            once = true,
            callback = function()
              -- Check if jsregexp is not installed
              local ok = pcall(require, 'luasnip.extras._jsregexp')
              if not ok then
                vim.notify('LuaSnip: jsregexp not installed. Run :!make install_jsregexp in LuaSnip directory', vim.log.levels.INFO)
              end
            end,
          })
        end,
      },

      -- Snippet collections
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',

      -- LSP source
      'hrsh7th/cmp-nvim-lsp',

      -- Buffer sources
      'hrsh7th/cmp-buffer',
      'amarakon/nvim-cmp-buffer-lines',

      -- Path completion
      'hrsh7th/cmp-path',

      -- Copilot
      {
        'zbirenbaum/copilot-cmp',
        config = function()
          require('copilot_cmp').setup()
        end,
      },

      -- UI enhancements
      {
        'onsails/lspkind.nvim',
        config = function()
          require('lspkind').init()
        end,
      },
      {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        opts = {
          color_square_width = 2,
        },
      },

      -- Language specific sources
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-emoji',
      'lukas-reineke/cmp-rg',
      'andersevenrud/cmp-tmux',
      'hrsh7th/cmp-calc',
      'ray-x/cmp-sql',
      'ray-x/cmp-treesitter',

      -- Auto-pairs integration
      {
        'windwp/nvim-autopairs',
        config = function()
          require('nvim-autopairs').setup {}
        end,
      },
    },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('config.cmp')
    end,
  },

  -- Cmdline completion (separate event)
  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
  },

  -- JSON/npm specific completion (lazy loaded by filetype)
  {
    'David-Kunz/cmp-npm',
    ft = 'json',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('cmp-npm').setup {}
    end,
  },
}
