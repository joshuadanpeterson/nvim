-- plugins/conform.lua
-- Lazy-loaded conform.nvim configuration

return {
  {
    "conform-config",
    name = "conform-config",
    event = { "BufReadPre", "BufNewFile" },
    dir = vim.fn.stdpath("config"),
    config = function()
      require('config.conform')
    end,
  },
}
