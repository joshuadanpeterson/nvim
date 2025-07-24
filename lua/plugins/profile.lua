-- plugins/profile.lua
-- Lazy-loaded profile configuration

return {
  {
    "profile-config",
    name = "profile-config",
    event = "VeryLazy",
    dir = vim.fn.stdpath("config"),
    config = function()
      require('config.profile').setup()
    end,
  },
}
