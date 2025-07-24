-- plugins/keymaps.lua
-- Lazy-loaded keymap configuration

return {
  {
    "keymap-config",
    name = "keymap-config",
    event = "VeryLazy",
    dir = vim.fn.stdpath("config"),
    config = function()
      require('config.keymaps').setup()
    end,
  },
}
