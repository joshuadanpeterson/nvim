-- useful plugin to show you pending keybinds.
-- Shows a popup with possible keybindings of the command you started typing.

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local which_key = require 'which-key'

      -- Define plugin options
      local opts = {
        plugins = {
          marks = true,     -- shows a list of your marks on ' and `
          registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
          -- Add other plugin configurations here...
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

        -- add operators that will trigger motion and text object completion
        -- to enable all native operators, set the preset / operators plugin above
        operators = { gc = 'Comments' },
        key_labels = {
          -- override the label used to display some keys. It doesn't effect WK in any other way.
          -- For example:
          -- ["<space>"] = "SPC",
          -- ["<cr>"] = "RET",
          -- ["<tab>"] = "TAB",
        },
        motions = {
          count = true,
        },
        icons = {
          breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
          separator = '➜', -- symbol used between a key and it's label
          group = '+', -- symbol prepended to a group
        },
        popup_mappings = {
          scroll_down = '<c-d>', -- binding to scroll down inside the popup
          scroll_up = '<c-u>',   -- binding to scroll up inside the popup
        },
        window = {
          border = 'single',        -- none, single, double, shadow
          position = 'bottom',      -- bottom, top
          margin = { 1, 1, 1, 1 },  -- extra window margin [top, right, bottom, left]
          padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 0,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
          zindex = 1000,            -- positive value to position WhichKey above other floating windows.
        },
        layout = {
          height = { min = 4, max = 25 },                                                 -- min and max height of the columns
          width = { min = 20, max = 50 },                                                 -- min and max width of the columns
          spacing = 3,                                                                    -- spacing between columns
          align = 'left',                                                                 -- align columns left, center or right
        },
        ignore_missing = false,                                                           -- enable this to hide mappings for which you didn't specify a label
        hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', '^:', '^ ', '^call ', '^lua ' }, -- hide mapping boilerplate
        show_help = true,                                                                 -- show a help message in the command line for using WhichKey
        show_keys = true,                                                                 -- show the currently pressed key and its label as a message in the command line
        triggers = 'auto',                                                                -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
        -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        triggers_nowait = {
          -- marks
          '`',
          "'",
          'g`',
          "g'",
          -- registers
          '"',
          '<c-r>',
          -- spelling
          'z=',
        },
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for keymaps that start with a native binding
          i = { 'j', 'k' },
          v = { 'j', 'k' },
        },
        -- disable the WhichKey popup for certain buf types and file types.
        -- Disabled by default for Telescope
        disable = {
          buftypes = {},
          filetypes = {},
        },
      }

      -- Apply the configuration options
      which_key.setup(opts)
    end,
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
