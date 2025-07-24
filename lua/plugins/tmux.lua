-- plugins/tmux.lua
-- Lazy-loaded Tmux navigation configuration

return {
  {
    "tmux-config",
    name = "tmux-config",
    event = "VeryLazy",
    dir = vim.fn.stdpath("config"),
    config = function()
      require('config.tmux')
    end,
  },
}
