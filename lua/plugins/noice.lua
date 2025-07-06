-- This is the configuration for `noice.nvim`, a Neovim plugin that enhances the UI for messages, command line inputs, and popup menus.
-- It is highly customizable, allowing for a refined and user-friendly interface.
--
-- nvim-notify conflict resolution:
-- 1. nvim-notify is configured with higher priority (1100) to load before Noice
-- 2. If conflicts persist, uncomment the route skip line in the routes section
-- 3. This ensures nvim-notify is required only once and configured before Noice

return {
  -- nvim-notify: Configure notify before Noice to resolve conflicts
  {
    'rcarriga/nvim-notify',
    priority = 1100, -- Higher priority than Noice
    config = function()
      require("notify").setup({ stages = "fade", timeout = 3000 })
      vim.notify = require("notify")
    end,
  },
  
  -- Plugin identifier and lazy loading configuration.
  {
    'folke/noice.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        cmdline = {
          enabled = true,
          view = 'cmdline_popup',
        },
        messages = {
          enabled = true,
        },
        popupmenu = {
          enabled = true,
        },
        routes = {
          -- Temporarily disable Noice's notify route if conflicts persist
          { filter = { event = "notify" }, opts = { skip = true } },
        },
        views = {
          cmdline_popup = {
            position = { row = "50%", col = "50%" },
            size      = { width = 60, height = "auto" },
            border    = { style = "rounded" },
            win_options = {
              winhighlight = { NormalFloat = "NormalFloat", FloatBorder = "FloatBorder" },
            },
          },
        },
        presets = {
          bottom_search = false,
          command_palette = false,
          long_message_to_split = false,
          inc_rename = false,
          lsp_doc_border = false,
        },
      }
    end,
  },
}
