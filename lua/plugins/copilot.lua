-- Copilot.lua
--[[
  custom.plugins.copilot: Sets up GitHub Copilot in Neovim, providing AI-powered code completion and suggestions. This configuration could include keybindings to trigger Copilot suggestions and any Copilot-specific settings.
]]

return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {},
  },

  -- Copilot Chat
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' },  -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  -- Pieces for Neovim
  {
    'pieces-app/plugin_neo_vim',
  },
}
