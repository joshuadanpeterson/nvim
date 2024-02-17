-- visuals.lua

return {
        -- Install plugin information here

        -- vim-surround: easily manage pairs like brackets, quotes in your text.
        {
                'tpope/vim-surround'
        },

        -- indentline: display vertical lines at each indentation level.
        {
                'yggdroot/indentline'
        },

        -- Treesitter-based rainbow parentheses for Neovim, enhancing the readability of nested parentheses.
        {
                'hiphish/nvim-ts-rainbow2',
                dependencies = {
                        'nvim-treesitter/nvim-treesitter'
                }
        },

        -- transparent plugin
        {
                'xiyaowong/transparent.nvim',
                -- transparent plugin panels
                extra_groups = {
                        "NormalFloat",   -- plugins which have float panel such as Lazy, Mason, LspInfo
                        "NvimTreeNormal" -- NvimTree
                },
        },

        -- Makes the background of the editor transparent.
        {
                'tribela/vim-transparent'
        },


        -- Twilight, for text dimming
        {
                "folke/twilight.nvim",
                opts = {
                        dimming = {
                                alpha = 0.75, -- amount of dimming
                                -- we try to get the foreground from the highlight groups or fallback color
                                color = { "Normal", "#ffffff" },
                                term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
                                inactive = false,    -- when true, other windows will be fully dimmed (unless they contain the same buffer)
                        },
                        context = 10,                -- amount of lines we will try to show around the current line
                        treesitter = true,           -- use treesitter when available for the filetype
                        -- treesitter is used to automatically expand the visible text,
                        -- but you can further control the types of nodes that should always be fully expanded
                        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
                                "function",
                                "method",
                                "table",
                                "if_statement",
                        },
                        exclude = {}, -- exclude these filetypes
                }
        },

        -- true-zen
        {
                "Pocco81/true-zen.nvim",
                config = function()
                         require("true-zen").setup {
                                -- your config goes here
                                modes = { -- configurations per mode
                                        ataraxis = {
                                                shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
                                                backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
                                                minimum_writing_area = { -- minimum size of main window
                                                        width = 70,
                                                        height = 44,
                                                },
                                                quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
                                                padding = { -- padding windows
                                                        left = 52,
                                                        right = 52,
                                                        top = 0,
                                                        bottom = 0,
                                                },
                                                callbacks = { -- run functions when opening/closing Ataraxis mode
                                                        open_pre = nil,
                                                        open_pos = nil,
                                                        close_pre = nil,
                                                        close_pos = nil
                                                },
                                        },
                                        minimalist = {
                                                ignored_buf_types = { "nofile" }, -- save current options from any window except ones displaying these kinds of buffers
                                                options = { -- options to be disabled when entering Minimalist mode
                                                        number = false,
                                                        relativenumber = false,
                                                        showtabline = 0,
                                                        signcolumn = "no",
                                                        statusline = "",
                                                        cmdheight = 1,
                                                        laststatus = 0,
                                                        showcmd = false,
                                                        showmode = false,
                                                        ruler = false,
                                                        numberwidth = 1
                                                },
                                                callbacks = { -- run functions when opening/closing Minimalist mode
                                                        open_pre = nil,
                                                        open_pos = nil,
                                                        close_pre = nil,
                                                        close_pos = nil
                                                                },
                                                        },
                                        narrow = {
                                                --- change the style of the fold lines. Set it to:
                                                --- `informative`: to get nice pre-baked folds
                                                --- `invisible`: hide them
                                                --- function() end: pass a custom func with your fold lines. See :h foldtext
                                                folds_style = "informative",
                                                run_ataraxis = true, -- display narrowed text in a Ataraxis session
                                                callbacks = { -- run functions when opening/closing Narrow mode
                                                        open_pre = nil,
                                                        open_pos = nil,
                                                        close_pre = nil,
                                                        close_pos = nil
                                                },
                                        },
                                        focus = {
                                                callbacks = { -- run functions when opening/closing Focus mode
                                                        open_pre = nil,
                                                        open_pos = nil,
                                                        close_pre = nil,
                                                        close_pos = nil
                                                },
                                        }
                                        },
                                        integrations = {
                                                tmux = false, -- hide tmux status bar in (minimalist, ataraxis)
                                                kitty = { -- increment font size in Kitty. Note: you must set `allow_remote_control socket-only` and `listen_on unix:/tmp/kitty` in your personal config (ataraxis)
                                                enabled = false,
                                                font = "+3"
                                        },
                                        twilight = false, -- enable twilight (ataraxis)
                                        lualine = false -- hide nvim-lualine (ataraxis)
                                },
                         }
                end,
        },

        -- Zen Mode, distraction-free coding
        {
                "folke/zen-mode.nvim",
                opts = {
                        window = {
                                backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                                -- height and width can be:
                                -- * an absolute number of cells when > 1
                                -- * a percentage of the width / height of the editor when <= 1
                                -- * a function that returns the width or the height
                                width = 120, -- width of the Zen window
                                height = 1,  -- height of the Zen window
                                -- by default, no options are changed for the Zen window
                                -- uncomment any of the options below, or add other vim.wo options you want to apply
                                options = {
                                        -- signcolumn = "no", -- disable signcolumn
                                        -- number = false, -- disable number column
                                        -- relativenumber = false, -- disable relative numbers
                                        -- cursorline = false, -- disable cursorline
                                        -- cursorcolumn = false, -- disable cursor column
                                        -- foldcolumn = "0", -- disable fold column
                                        -- list = false, -- disable whitespace characters
                                },
                        },
                        plugins = {
                                -- disable some global vim options (vim.o...)
                                -- comment the lines to not apply the options
                                options = {
                                        enabled = true,
                                        ruler = false,   -- disables the ruler text in the cmd line area
                                        showcmd = false, -- disables the command in the last line of the screen
                                        -- you may turn on/off statusline in zen mode by setting 'laststatus'
                                        -- statusline will be shown only if 'laststatus' == 3
                                        laststatus = 0,         -- turn off the statusline in zen mode
                                },
                                twilight = { enabled = true },  -- enable to start Twilight when zen mode opens
                                gitsigns = { enabled = false }, -- disables git signs
                                tmux = { enabled = false },     -- disables the tmux statusline
                                -- this will change the font size on kitty when in zen mode
                                -- to make this work, you need to set the following kitty options:
                                -- - allow_remote_control socket-only
                                -- - listen_on unix:/tmp/kitty
                                kitty = {
                                        enabled = false,
                                        font = "+4", -- font size increment
                                },
                                -- this will change the font size on alacritty when in zen mode
                                -- requires  Alacritty Version 0.10.0 or higher
                                -- uses `alacritty msg` subcommand to change font size
                                alacritty = {
                                        enabled = false,
                                        font = "14", -- font size
                                },
                                -- this will change the font size on wezterm when in zen mode
                                -- See alse also the Plugins/Wezterm section in this projects README
                                wezterm = {
                                        enabled = false,
                                        -- can be either an absolute font size or the number of incremental steps
                                        font = "+4", -- (10% increase per step)
                                },
                        },
                        -- callback where you can add custom code when the Zen window opens
                        on_open = function(win)
                        end,
                        -- callback where you can add custom code when the Zen window closes
                        on_close = function()
                        end,
                }
        },

}
