-- plugins/markdown.lua

return {
  -- Load markdown configuration
  {
    "markdown-config",
    name = "markdown-config",
    ft = "markdown",
    dir = vim.fn.stdpath("config"),
    config = function()
      require('config.markdown')
    end,
  },

  -- glow.nvim: markdown preview
  {
    'ellisonleao/glow.nvim',
    ft = 'markdown',
    cmd = 'Glow',
    config = function()
      require('glow').setup {
        keymaps = {
          quit = '<Esc>',
          toggle_fullscreen = '<F11>',
        },
        glow = {
          width = 80,
          height = 30,
          wrap = 'off',
          lines = 10,
        },
      }
    end,
  },

  -- Markdown Preview
  {
    'davidgranstrom/nvim-markdown-preview',
  },

  -- emoji.nvim
  {
    'allaman/emoji.nvim',
    version = '1.0.0',
    ft = 'markdown',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      enable_cmp_integration = true,
    },
  },

  -- markdown.nvim: plugin to improve viewing Markdown files in Neovim
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',                                                      -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    config = function()
      require('render-markdown').setup({
      })
    end,
  },
}
