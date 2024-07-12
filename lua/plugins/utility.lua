-- utility.lua
--[[
        custom.plugins.utility: Sets up various utility plugins that provide additional functionality to Neovim, such as file management, clipboard integration, or terminal enhancements. Each utility plugin's specific configuration would be included here.
]]

-- Ensure nvim-nonicons is installed
-- Assuming you want to use nvim-notify icons from nvim-nonicons

local nonicons_extension
local status, nonicons = pcall(require, 'nvim-nonicons.extentions.nvim-notify')
if status then
  nonicons_extension = nonicons
else
  print 'Warning: nvim-nonicons extensions not found'
  nonicons_extension = { icons = {} }
end

return {

  -- add plenary.nvim
  -- A Lua library for Neovim which is a dependency for several plugins including Telescope.
  {
    'nvim-lua/plenary.nvim',
  },

  -- LazyVim
  -- A configuration framework for Neovim aimed at simplicity and minimalism.
  -- {
  -- 'LazyVim/LazyVim',
  -- opts = {
  -- colorscheme = 'nord',
  -- },
  -- },

  -- ripgrep config: Utilizes ripgrep for searching in files.
  {
    'BurntSushi/ripgrep',
  },

  -- fd config: A simple, fast and user-friendly alternative to 'find'.
  {
    'sharkdp/fd',
  },

  -- Dash
  -- Query Dash.app within Neovim with your fuzzy finder
  {
    'mrjones2014/dash.nvim',
    build = 'make install',
    opts = {
      search_engine = 'google',
    },
  },

  -- vim-sneak: minimalist motion plugin to jump to any location in file with two characters.
  {
    'justinmk/vim-sneak',
  },

  -- Codestats
  {
    'YannickFricke/codestats.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() end,
  },

  -- Vim Pencil
  -- Provides a better writing experience in Vim.
  {
    'preservim/vim-pencil',
  },

  -- ChatGPT
  -- Integration of ChatGPT into Neovim for generating code and more.
  {
    'jackMort/ChatGPT.nvim',
    event = 'VeryLazy',
    config = function()
      require('chatgpt').setup {
        api_key_cmd = "grep 'OPENAI_API_KEY' /Users/joshpeterson/.zshenv_private | cut -d'=' -f2 | tr -d \"'\"",
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'folke/trouble.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },

  -- Multi-cursor configuration
  -- This is the Neovim implementation of the famous Emacs Hydra package.
  {
    'smoka7/hydra.nvim',
  },

  {
    'terryma/vim-multiple-cursors',
  },

  -- multicursors.nvim:
  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = {
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>m',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },

  -- formatter.nvim
  {
    'mhartington/formatter.nvim',
    config = function()
      require('formatter').setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            require('formatter.filetypes.lua').stylua,
            function()
              if vim.fn.expand '%:t' == 'special.lua' then -- Use vim.fn.expand for filename check
                return nil
              end
              return {
                exe = 'stylua',
                args = {
                  '--search-parent-directories',
                  '--stdin-filepath',
                  vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
                  '--',
                  '-',
                },
                stdin = true,
              }
            end,
          },
          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      }
    end,
  },

  -- nvim-notify
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {
        stages = 'fade_in_slide_out',
        background_colour = '#000000',
        timeout = 3000,
        icons = nonicons_extension.icons,
      }
      vim.notify = require 'notify'
    end,
  },

  -- pomodoro timer
  {
    'epwalsh/pomo.nvim',
    version = '*', -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { 'TimerStart', 'TimerRepeat', 'TimerStop', 'TimerShow', 'TimerHide', 'TimerPause', 'TimerResume' },
    dependencies = {
      -- Optional, but highly recommended if you want to use the "Default" timer
      'rcarriga/nvim-notify',
    },
    opts = {
      -- See below for full list of options 👇
      -- How often the notifiers are updated.
      update_interval = 1000,

      -- Configure the default notifiers to use for each timer.
      -- You can also configure different notifiers for timers given specific names, see
      -- the 'timers' field below.
      notifiers = {
        -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
        {
          name = 'Default',
          opts = {
            -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
            -- continuously displayed. If you only want a pop-up notification when the timer starts
            -- and finishes, set this to false.
            sticky = true,

            -- Configure the display icons:
            title_icon = '󱎫',
            text_icon = '󰄉',
            -- Replace the above with these if you don't have a patched font:
            -- title_icon = "⏳",
            -- text_icon = "⏱️",
          },
        },

        -- The "System" notifier sends a system notification when the timer is finished.
        -- Currently this is only available on MacOS.
        -- Tracking: https://github.com/epwalsh/pomo.nvim/issues/3
        { name = 'System' },

        -- You can also define custom notifiers by providing an "init" function instead of a name.
        -- See "Defining custom notifiers" below for an example 👇
        -- { init = function(timer) ... end }
      },

      -- Override the notifiers for specific timer names.
      timers = {
        -- For example, use only the "System" notifier when you create a timer called "Break",
        -- e.g. ':TimerStart 2m Break'.
        Break = {
          { name = 'System' },
        },
      },
    },
  },

  -- Tmux Configs
  -- Vim Tmux Navigator for Tmux config
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>',  '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>',  '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>',  '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>',  '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

  -- tmux.nvim
  {
    'aserowy/tmux.nvim',
    event = 'VimEnter',
    config = function()
      require('tmux').setup {
        copy_sync = {
          enable = false,
        },
      }
    end,
  },

  -- vim-tpipeline
  {
    'vimpostor/vim-tpipeline',
    event = 'VeryLazy',
    init = function()
      vim.g.tpipeline_autoembed = 0
      vim.g.tpipeline_statusline = ''
    end,
    config = function()
      vim.cmd.hi { 'link', 'StatusLine', 'WinSeparator' }
      vim.g.tpipeline_statusline = ''
      vim.o.laststatus = 0
      vim.o.fillchars = 'stl:─,stlnc:─'
    end,
    cond = function()
      return vim.env.TMUX ~= nil
    end,
  },
  -- firenvim for using Neovim in Chrome
  {
    'glacambre/firenvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn['firenvim#install'](0)
    end,
  },

  -- ranger.nvim file manager
  {
    'kelly-lin/ranger.nvim',
    config = function()
      require('ranger-nvim').setup { replace_netrw = true }
    end,
  },

  -- vim-floaterm: open terminal window inside of Neovim
  {
    'voldikss/vim-floaterm',
  },

  -- /*** vim-dadbod and related plugins ***/
  {
    'tpope/vim-dadbod',
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = {
      { 'tpope/vim-dadbod' },
    },
  },

  -- hardtime: establish good vim habits
  -- {
  --   'm4xshen/hardtime.nvim',
  --   event = 'VeryLazy',
  --   opts = {
  --     max_count = 5,
  --     timeout = 2000,
  --     keys = {
  --       ['h'] = 'move',
  --       ['j'] = 'move',
  --       ['k'] = 'move',
  --       ['l'] = 'move',
  --       ['-'] = 'move',
  --       ['+'] = 'move',
  --       ['gj'] = 'move',
  --       ['gk'] = 'move',
  --       ['<CR>'] = 'move',
  --       ['<BS>'] = 'delete',
  --       ['x'] = 'delete',
  --       ['X'] = 'delete',
  --       ['s'] = 'delete',
  --       ['S'] = 'delete',
  --       ['i'] = 'insert',
  --       ['I'] = 'insert',
  --       ['a'] = 'insert',
  --       ['A'] = 'insert',
  --       ['o'] = 'insert',
  --       ['O'] = 'insert',
  --     },
  --     disabled_filetypes = {
  --       'help',
  --       'terminal',
  --       'dashboard',
  --       'packer',
  --       'NvimTree',
  --       'TelescopePrompt',
  --       'TelescopeResults',
  --     },
  --     disabled_modes = {
  --       'v', -- Visual mode
  --       'V', -- Visual Line mode
  --       '<C-v>', -- Visual Block mode
  --     },
  --     disabled_keys = {
  --       ['<Up>'] = {},
  --       ['<Down>'] = {},
  --     },
  --     hints = {
  --       ['k%^'] = {
  --         message = function()
  --           return 'Use - instead of k^' -- return the hint message you want to display
  --         end,
  --         length = 2, -- the length of actual key strokes that matches this pattern
  --       },
  --       ['d[tTfF].i'] = { -- this matches d + {t/T/f/F} + {any character} + i
  --         message = function(keys) -- keys is a string of key strokes that matches the pattern
  --           return 'Use ' .. 'c' .. keys:sub(2, 3) .. ' instead of ' .. keys
  --           -- example: Use ct( instead of dt(i
  --         end,
  --         length = 4,
  --       },
  --     },
  --   },
  -- },

  -- precognition.nvim assists with discovering motions (Both vertical and horizontal) to navigate your current buffer
  {
    'tris203/precognition.nvim',
  },

  -- oil.nvim: A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
  {
    'stevearc/oil.nvim',
    opts = {
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 90,
        max_height = 30,
        border = 'rounded',
        win_options = {
          winblend = 0,
        },
      },
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- todo-comments.nvim: highlight and search for todo comments like TODO, HACK, BUG in your code base.
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = true,      -- show icons in the signs column
      sign_priority = 8, -- sign priority
      -- keywords recognized as todo comments
      keywords = {
        FIX = {
          icon = ' ', -- icon used for the sign, and in search results
          color = 'error', -- can be a hex color, or a named color (see below)
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
      gui_style = {
        fg = 'NONE',         -- The gui style to use for the fg highlight group.
        bg = 'BOLD',         -- The gui style to use for the bg highlight group.
      },
      merge_keywords = true, -- when true, custom keywords will be merged with the defaults
      -- highlighting of the line containing the todo comment
      -- * before: highlights before the keyword (typically comment characters)
      -- * keyword: highlights of the keyword
      -- * after: highlights after the keyword (todo text)
      highlight = {
        multiline = true,                -- enable multine todo comments
        multiline_pattern = '^.',        -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
        before = '',                     -- "fg" or "bg" or empty
        keyword = 'wide',                -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = 'fg',                    -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true,            -- uses treesitter to match keywords in comments only
        max_line_len = 400,              -- ignore lines longer than this
        exclude = {},                    -- list of file types to exclude highlighting
      },
      -- list of named colors where we try to extract the guifg from the
      -- list of highlight groups or use the hex color if hl not found as a fallback
      colors = {
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
        info = { 'DiagnosticInfo', '#2563EB' },
        hint = { 'DiagnosticHint', '#10B981' },
        default = { 'Identifier', '#7C3AED' },
        test = { 'Identifier', '#FF00FF' },
      },
      search = {
        command = 'rg',
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
        -- regex that will be used to match keywords.
        -- don't replace the (KEYWORDS) placeholder
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
  },

  -- CodeSnap: Snapshot plugin with rich features that can make pretty code snapshots for Neovim
  {
    'mistricky/codesnap.nvim',
    build = 'make',
    opts = {
      save_path = '~/Dropbox/programming/codesnap',
      parsed = '~/Dropbox/programming/codesnap/CodeSnap_y-m-d_at_h:m:s.png',
      code_font_family = 'Fira Code Nerd Font',
      bg_theme = 'summer',
      breadcrumbs_separator = ' > ',
      has_breadcrumbs = true,
    },
  },

  -- mini.nvim: lua modules

  {
    'echasnovski/mini.nvim',
    branch = 'stable',
    config = function()
      require('mini.doc').setup() -- help doc generation
    end,
  },
}
