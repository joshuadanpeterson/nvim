-- livecoding.lua
-- Live-coding plugins for Neovim: Strudel and Sonic Pi

return {
  -- Strudel: Browser-based live coding with JavaScript patterns
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

  -- Sonic Pi: Live coding music with Ruby
  {
    "magicmonty/sonicpi.nvim",
    ft = { "ruby", "sonicpi" },
    dependencies = { 'hrsh7th/nvim-cmp', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("sonicpi").setup({
        server_dir = "/Applications/Sonic Pi.app/Contents/Resources/app/server",
        lsp_diagnostics = true,
      })
      -- QoL: setup autorun helpers (toggle via <leader>Ja / <leader>Jm)
      pcall(require, 'config.sonicpi').setup()
    end,
  },
}
