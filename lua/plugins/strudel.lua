-- strudel.lua
-- Live-coding with Strudel from Neovim

return {
  {
    "gruvw/strudel.nvim",
    lazy = false,           -- eager-load to avoid filetype issues per README
    build = "npm install", -- install JS deps on first install/update
    config = function()
      require("strudel").setup({
        -- Extras requested
        update_on_save = true,
        headless = false,
        ui = {
          hide_menu_panel = false,
          hide_top_bar = false,
          hide_code_editor = false,
          hide_error_display = false,
        },
        -- Keep other defaults (e.g., sync_cursor, report_eval_errors, browser paths)
      })
    end,
  },
}
