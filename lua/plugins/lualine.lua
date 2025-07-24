-- plugins/lualine.lua
--[[
  custom.plugins.lualine: Loads lualine and related plugins.
]]

return {
  -- lualine configuration
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    event = 'VeryLazy',
    config = function()
      require('lualine').setup {}
      require('config.lualine')
    end,
  },

  -- copilot lualine
  {
    'AndreM222/copilot-lualine',
    event = 'BufReadPre',
  },

  -- harpoonline
  {
    'abeldekat/harpoonline',
    event = 'BufReadPre',
  },

  -- lualine-lsp-progress
  {
    'arkav/lualine-lsp-progress',
    event = 'BufReadPre',
  },
}
