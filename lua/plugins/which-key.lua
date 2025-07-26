-- useful plugin to show you pending keybinds.
-- Shows a popup with possible keybindings of the command you started typing.

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    dependencies = {
      { "keymap-config", name = "keymap-config", dir = vim.fn.stdpath("config") },
    },
    config = function()
      local which_key = require 'which-key'

      local opts = {
        preset = "modern",
        delay = function(ctx)
          return ctx.plugin and 0 or 200
        end,
        spec = {},
        notify = true,
        modes = {
          n = true, -- Normal mode
          i = true, -- Insert mode
          x = true, -- Visual mode
          s = true, -- Select mode
          o = true, -- Operator pending mode
          t = true, -- Terminal mode
          c = true, -- Command mode
        },
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        win = {
          no_overlap = true,
          border = 'rounded',
          padding = { 1, 2 },
          title = true,
          title_pos = "center",
          zindex = 1000,
          wo = {
            -- winblend = 80,
          },
        },
        layout = {
          width = { min = 20 },
          spacing = 3,
          align = "left",
        },
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        sort = { "local", "order", "group", "alphanum", "mod", "lower", "icase" },
        expand = 1,
        replace = {
          key = {
            function(key)
              return require("which-key.view").format(key)
            end,
          },
          desc = {
            { "<Plug>%((.*)%)", "%1" },
            { "^%+",            "" },
            { "<[cC]md>",       "" },
            { "<[cC][rR]>",     "" },
            { "<[sS]ilent>",    "" },
            { "^lua%s+",        "" },
            { "^call%s+",       "" },
            { "^:%s*",          "" },
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          colors = true,
          mappings = true,
          rules = {},
          keys = {
            Up = "↑ ",
            Down = "↓ ",
            Left = "← ",
            Right = "→ ",
            C = "󰘴 ",
            M = "󰘵 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "⌫",
            Space = "󱁐 ",
            Tab = "󰌒 ",
          },
        },
        show_help = true,
        show_keys = true,
        triggers = true,
        disable = {
          ft = {},
          bt = {},
          trigger = function(ctx)
            return false
          end,
        },
        debug = false,
      }

      which_key.setup(opts)
      
      -- Ensure keymaps are loaded
      require('config.keymaps').setup()
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Hawtkey: a nvim plugin for finding and suggesting memorable and easy-to-press keys for your nvim shortcuts
  {
    "tris203/hawtkeys.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = {
      leader = " ",                  -- the key you want to use as the leader, default is space
      homerow = 2,                   -- the row you want to use as the homerow, default is 2
      powerFingers = { 2, 3, 6, 7 }, -- the fingers you want to use as the powerfingers, default is {2,3,6,7}
      keyboardLayout = "qwerty",     -- the keyboard layout you use, default is qwerty
      customMaps = {
        --- EG local map = vim.api
        --- map.nvim_set_keymap('n', '<leader>1', '<cmd>echo 1')
        {
          ["map.nvim_set_keymap"] = {        --name of the expression
            modeIndex = "1",                 -- the position of the mode setting
            lhsIndex = "2",                  -- the position of the lhs setting
            rhsIndex = "3",                  -- the position of the rhs setting
            optsIndex = "4",                 -- the position of the index table
            method = "dot_index_expression", -- if the function name contains a dot
          },
        },
        -- If you use whichkey.register with an alias eg wk.register
        ["wk.register"] = {
          method = "which_key",
        },
      },
      highlights = { -- these are the highlight used in search mode
        HawtkeysMatchGreat = { fg = "green", bold = true },
        HawtkeysMatchGood = { fg = "green" },
        HawtkeysMatchOk = { fg = "yellow" },
        HawtkeysMatchBad = { fg = "red" },
      },
    },
  },
}
