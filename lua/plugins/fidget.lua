-- plugins/fidget.lua
-- Lazy-loaded fidget.nvim configuration

return {
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function()
      require('config.fidget')
    end,
  },
}
