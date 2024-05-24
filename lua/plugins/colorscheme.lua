-- colorscheme.lua
--[[
        custom.plugins.colorscheme: Configures the visual theme of Neovim, including colors for syntax highlighting, background, and other UI elements. It might specify a particular colorscheme plugin and any customizations to it.
]]
return {

  -- nord theme
  -- Transparent Nord Theme
  {
    'shaunsingh/nord.nvim',
    config = function()
      -- load the theme
      vim.cmd 'colorscheme nord'
      require('nord').set {
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      }
    end,
  },

  -- Transparent Background
  {
    'tribela/vim-transparent',
  },

  -- NightFox theme
  -- A highly customizable theme for vim and neovim with support for lsp, treesitter and a variety of plugins.
  {
    'EdenEast/nightfox.nvim',
  },

  -- Nordic theme
  -- Darker Nord theme
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').load()
    end,
  },
}
