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

  -- Rainbow delimiters for Neovim using Tree-sitter
  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('rainbow-delimiters.setup').setup {
        -- Configuration options
      }
    end,
  },

  -- transparent plugin (avoid lazy loading as per plugin documentation)
  {
    'xiyaowong/transparent.nvim',
    priority = 1000, -- load early to ensure proper initialization
    config = function()
      require('transparent').setup {
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
          'EndOfBuffer',
        },
        extra_groups = {
          'NormalFloat',           -- plugins which have float panel such as Lazy, Mason, LspInfo
        },
        exclude_groups = {},       -- table: groups you don't want to clear
        on_clear = function() end, -- function: code to be executed after highlight groups are cleared
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
            options = {                       -- options to be disabled when entering Minimalist mode
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
    'joshuadanpeterson/typewriter.nvim', --live plugin
    -- dir = '~/Dropbox/programming/neovim/plugin-development/typewriter', --plugin development
    event = 'BufReadPre',
    config = function()
      require('typewriter').setup {
        enable_with_zen_mode = true,
        enable_with_true_zen = true,
        keep_cursor_position = true,
        enable_notifications = true,
        enable_horizontal_scroll = false,
        start_enabled = true,
        always_center = true,
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
          { label = '%-%-theme%-primary%-color',   color = '#0f1219' },
          { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
        },

        -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
        exclude_filetypes = {},
        exclude_buftypes = {},
      }
    end,
  },

  -- mode: cursor highlighting/coloring
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    event = "VeryLazy",
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
  {
    'echasnovski/mini.icons',
    opts = {},
    lazy = true,
    specs = {
      { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  -- This plugin attempts to add image support to Neovim.
  {
    '3rd/image.nvim',
    event = "VeryLazy",
    config = function()
      -- ...
    end,
  },

  -- img-clip.nvim: Effortlessly embed images into any markup language, like LaTeX, Markdown or Typst.
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
  },

  -- statuscol
  {
    "luukvbaal/statuscol.nvim",
    event = "BufReadPost",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup(
        {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
            { text = { "%s" },                  click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            {
              sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
              click = "v:lua.ScSa"
            },
            {
              sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
              click = "v:lua.ScSa"
            },
          },
        }
      )
    end
  },

  -- nvim-ufo: better fold management
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = "BufReadPost",
    config = function()
      local ts_utils = require('nvim-treesitter.ts_utils')
      local parsers = require('nvim-treesitter.parsers')

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
        open_fold_hl_timeout = 400,
        close_fold_kinds_for_ft = {
          default = {}
        },
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (' ... %d lines '):format(endLnum - lnum) -- Use '...' as the fold icon
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          local ts_summary = ''

          -- Use Tree-sitter to get relevant information for the fold
          local bufnr = vim.api.nvim_get_current_buf()
          local lang = parsers.get_buf_lang(bufnr)
          if not lang then return virtText end

          local query_string = [[
          (function_declaration
            name: (identifier) @function.name)
        ]]
          local parsed_query = vim.treesitter.query.parse(lang, query_string)
          local parser = parsers.get_parser(bufnr)
          local tree = parser:parse()[1]
          local root = tree:root()

          for id, node in parsed_query:iter_captures(root, bufnr, lnum, endLnum) do
            if parsed_query.captures[id] == 'function.name' then
              ts_summary = ts_summary .. vim.treesitter.get_node_text(node, bufnr) .. ' '
            end
          end

          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end

          if ts_summary ~= '' then
            ts_summary = ' ... ' .. ts_summary
          end

          table.insert(newVirtText, { ts_summary .. suffix, 'MoreMsg' })
          return newVirtText
        end,
        enable_get_fold_virt_text = false,
        preview = {
          win_config = {
            border = 'rounded',
            winblend = 12,
            winhighlight = 'Normal:Normal',
            maxheight = 20,
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = 'gg',
            jumpBot = 'G',
            toggleFold = 'za',
            toggleAllFolds = 'zA',
          },
        }
      })
    end
  },

  --[[ Testing plugins ]]
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
