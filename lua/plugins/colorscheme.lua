-- colorscheme.lua
--[[
        custom.plugins.colorscheme: Configures the visual theme of Neovim, including colors for syntax highlighting, background, and other UI elements. It might specify a particular colorscheme plugin and any customizations to it.
]]

return {
  -- Sonokai theme
  -- {
  --   'sainnhe/sonokai',
  --   lazy = false,
  --   priority = 1000, -- Ensure it loads first
  --   config = function()
  --     -- You can set some Sonokai specific options here if needed
  --     vim.g.sonokai_style = 'andromeda' -- or other styles: 'default', 'andromeda', 'atlantis', 'shusia', 'maia'
  --     vim.g.sonokai_enable_italic = 1
  --     vim.g.sonokai_disable_italic_comment = 0
  --     vim.g.sonokai_cursor = 'auto'
  --     vim.g.sonokai_transparent_background = 0
  --     vim.g.sonokai_show_eob = 1
  --     vim.g.sonokai_diagnostic_text_highlight = 1
  --     vim.g.sonokai_diagnostic_line_highlight = 1
  --     vim.g.sonokai_diagnostic_virtual_text = 'colored'

  --     -- Set the colorscheme
  --     -- vim.cmd 'colorscheme sonokai'

  --     -- Set custom highlights for autocomplete menu after colorscheme is loaded
  --     vim.cmd [[
  --         highlight Pmenu guibg=#D3D3D3
  --         highlight PmenuSel guibg=#C0C0C0 guifg=NONE
  --         highlight CursorLine guibg=#D3D3D3
  --       ]]
  --   end,
  -- },

  -- GitHub theme
  -- {
  --   'projekt0n/github-nvim-theme',
  --   lazy = true,
  --   config = function()
  --     require('github-theme').setup {
  --       darken = {
  --         floats = true,
  --       },
  --       modules = {
  --         'which-key',
  --       },
  --     }
  --   end,
  -- },

  -- nord theme
  -- Transparent Nord Theme
  {
    'shaunsingh/nord.nvim',
    config = function()
      -- load the theme
      vim.cmd 'colorscheme nord'
      require('nord').set {
        transparent = true, -- Set to false to disable transparency globally
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
    event = 'VimEnter',
  },

  -- NightFox theme
  {
    'EdenEast/nightfox.nvim',
    event = 'VimEnter',
  },

  -- Nordic theme
  {
    'AlexvZyl/nordic.nvim',
    event = 'VimEnter',
    config = function()
      require('nordic').load()
    end,
  },

  -- Material theme
  {
    'marko-cerovac/material.nvim',
    event = 'VimEnter',
  },
}
