-- visuals.lua

return {
  -- vim-surround: easily manage pairs like brackets, quotes in your text.
  {
    'tpope/vim-surround',
    event = 'BufReadPre',
  },

  -- indentline: display vertical lines at each indentation level.
  {
    'yggdroot/indentline',
    event = 'BufReadPre',
  },

  -- Treesitter-based rainbow parentheses for Neovim, enhancing the readability of nested parentheses.
  {
    'hiphish/nvim-ts-rainbow2',
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  -- transparent plugin
  {
    'xiyaowong/transparent.nvim',
    event = 'BufReadPre',
    config = function()
      require('transparent').setup {
        extra_groups = {
          'NormalFloat', -- plugins which have float panel such as Lazy, Mason, LspInfo
        },
      }
    end,
  },

  -- Makes the background of the editor transparent.
  {
    'tribela/vim-transparent',
    event = 'BufReadPre',
  },

  -- Twilight, for text dimming
  {
    'folke/twilight.nvim',
    cmd = 'Twilight',
    opts = {
      dimming = {
        alpha = 100, -- amount of dimming
        color = { 'Normal', '#ffffff' },
        term_bg = '#FFFFFF',
        inactive = false,
      },
      context = 10,
      treesitter = true,
      expand = {
        'function',
        'method',
        'table',
        'if_statement',
      },
      exclude = {},
    },
  },

  -- true-zen
  {
    -- 'Pocco81/true-zen.nvim',
    dir = '~/Dropbox/programming/projects/contributions/true-zen.nvim', -- true-zen test
    cmd = { 'TZAtaraxis', 'TZMinimalist', 'TZFocus', 'TZBottom' },
    config = function()
      require('true-zen').setup {
        modes = {
          ataraxis = {
            shade = 'dark',
            backdrop = 0,
            minimum_writing_area = {
              width = 70,
              height = 44,
            },
            quit_untoggles = true,
            padding = {
              left = 52,
              right = 52,
              top = 0,
              bottom = 0,
            },
            callbacks = {
              open_pre = function()
                vim.cmd 'TWEnable'
              end,
              open_pos = nil,
              close_pre = nil,
              close_pos = function()
                vim.cmd 'TWDisable'
                vim.cmd 'Twilight'
              end,
            },
            options = {
              showtabline = 0, -- Ensure showtabline is set to a numeric value
            },
          },
          minimalist = {
            ignored_buf_types = { 'nofile' }, -- save current options from any window except ones displaying these kinds of buffers
            options = { -- options to be disabled when entering Minimalist mode
              number = false,
              relativenumber = true,
              showtabline = 0,
              signcolumn = 'no',
              statusline = '',
              cmdheight = 1,
              laststatus = 0,
              showcmd = false,
              showmode = false,
              ruler = false,
              numberwidth = 1,
            },
            callbacks = { -- run functions when opening/closing Minimalist mode
              open_pre = nil,
              open_pos = nil,
              close_pre = nil,
              close_pos = nil,
            },
          },
          narrow = {
            folds_style = 'informative',
            run_ataraxis = true,
            callbacks = {
              open_pre = nil,
              open_pos = nil,
              close_pre = nil,
              close_pos = nil,
            },
            options = {
              showtabline = 0, -- Ensure showtabline is set to a numeric value
            },
          },
          focus = {
            callbacks = {
              open_pre = nil,
              open_pos = nil,
              close_pre = nil,
              close_pos = nil,
            },
            options = {
              showtabline = 0, -- Ensure showtabline is set to a numeric value
            },
          },
        },
        integrations = {
          tmux = true,
          kitty = {
            enabled = false,
            font = '+3',
          },
          twilight = true,
          lualine = true,
        },
      }
    end,
  },

  -- Zen Mode, distraction-free coding
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.10,
        width = 120,
        height = 0.90,
        options = {},
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = true },
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = {
          enabled = false,
          font = '+4',
        },
        alacritty = {
          enabled = false,
          font = '14',
        },
        wezterm = {
          enabled = false,
          font = '+4',
        },
      },
      on_open = function(win)
        vim.cmd 'TWEnable'
      end,
      on_close = function()
        vim.cmd 'TWDisable'
      end,
    },
  },

  -- typewriter: enable typewriter-like scrolling
  {
    'joshuadanpeterson/typewriter.nvim',
    -- dir = '~/Dropbox/programming/neovim/plugin-development/typewriter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    event = 'BufReadPre',
    config = function()
      require('typewriter').setup {
        enable_with_zen_mode = true,
        enable_with_true_zen = true,
        keep_cursor_position = true,
        enable_notifications = true,
        enable_horizontal_scroll = true,
      }
    end,
  },

  -- nvim-highlight-colors: highlight colors in your buffer
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    config = function()
      require('nvim-highlight-colors').setup {
        ---Render style
        ---@usage 'background'|'foreground'|'virtual'
        render = 'background',

        ---Set virtual symbol (requires render to be set to 'virtual')
        virtual_symbol = '■',

        ---Set virtual symbol suffix (defaults to '')
        virtual_symbol_prefix = '',

        ---Set virtual symbol suffix (defaults to ' ')
        virtual_symbol_suffix = ' ',

        ---Set virtual symbol position()
        ---@usage 'inline'|'eol'|'eow'
        ---inline mimics VS Code style
        ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
        ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and virtual_symbol_suffix = ''` when used.
        virtual_symbol_position = 'inline',

        ---Highlight hex colors, e.g. '#FFFFFF'
        enable_hex = true,

        ---Highlight short hex colors e.g. '#fff'
        enable_short_hex = true,

        ---Highlight rgb colors, e.g. 'rgb(0 0 0)'
        enable_rgb = true,

        ---Highlight hsl colors, e.g. 'hsl(150deg 30% 40%)'
        enable_hsl = true,

        ---Highlight CSS variables, e.g. 'var(--testing-color)'
        enable_var_usage = true,

        ---Highlight named colors, e.g. 'green'
        enable_named_colors = true,

        ---Highlight tailwind colors, e.g. 'bg-blue-500'
        enable_tailwind = true,

        ---Set custom colors
        ---Label must be properly escaped with '%' to adhere to `string.gmatch`
        --- :help string.gmatch
        custom_colors = {
          { label = '%-%-theme%-primary%-color', color = '#0f1219' },
          { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
        },

        -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
        exclude_filetypes = {},
        exclude_buftypes = {},
      }
    end,
  },

  -- auto-cursorline.nvim: For a highlighted cursorline
  -- {
  --   'delphinus/auto-cursorline.nvim',
  --   config = function()
  --     require('auto-cursorline').setup {}
  --   end,
  -- },

  -- mode: cursor highlighting/coloring
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    config = function()
      require('modes').setup {
        colors = {
          bg = '', -- Optional bg param, defaults to Normal hl group
          copy = '#f5c359',
          delete = '#c75c6a',
          insert = '#78ccc5',
          visual = '#9745be',
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { 'NvimTree', 'TelescopePrompt' },
      }
    end,
  },

  -- mini.icons
  -- typewriter.vim: Typewriter sounds for Vim
  -- Currently working on developing PR for Neovim adaptation
  {
    -- 'AndrewRadev/typewriter.vim',
    dir = '~/Dropbox/programming/projects/contributions/typewriter.vim', -- typewriter.vim test
  },

  -- vim-keysound: Typewriter sounds for Vim
  {
    -- 'skywind3000/vim-keysound',
    dir = '~/Dropbox/programming/projects/contributions/vim-keysound', -- vim-keysound test
  },
}
