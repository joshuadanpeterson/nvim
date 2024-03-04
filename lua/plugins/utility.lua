-- utility.lua
--[[
        custom.plugins.utility: Sets up various utility plugins that provide additional functionality to Neovim, such as file management, clipboard integration, or terminal enhancements. Each utility plugin's specific configuration would be included here.
]]

-- import nvim-nonicons
-- require('plugins.ui')

-- nonicons_extension
local nonicons_extention = require("nvim-nonicons.extentions.nvim-notify")

return {

        -- add plenary.nvim
        -- A Lua library for Neovim which is a dependency for several plugins including Telescope.
        {
                'nvim-lua/plenary.nvim',
        },

        -- LazyVim
        -- A configuration framework for Neovim aimed at simplicity and minimalism.
        {
                "LazyVim/LazyVim",
                opts = {
                        colorscheme = "nord",
                },
        },

        -- ripgrep config: Utilizes ripgrep for searching in files.
        {
                'BurntSushi/ripgrep'
        },

        -- fd config: A simple, fast and user-friendly alternative to 'find'.
        {
                'sharkdp/fd'
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
                'justinmk/vim-sneak'
        },

        -- Codestats
        {
                'YannickFricke/codestats.nvim',
                requires = { 'nvim-lua/plenary.nvim' },
                config = function()
                end
        },

        -- Markdown Preview
        {
                "iamcco/markdown-preview.nvim",
                cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
                ft = { "markdown" },
                build = function() vim.fn["mkdp#util#install"]() end,
        },

        -- Vim Pencil
        -- Provides a better writing experience in Vim.
        {
                'preservim/vim-pencil'
        },

        -- ChatGPT
        -- Integration of ChatGPT into Neovim for generating code and more.
        {
                "jackMort/ChatGPT.nvim",
                event = "VeryLazy",
                config = function()
                        require("chatgpt").setup({
                                api_key_cmd =
                                "grep 'OPENAI_API_KEY' /Users/joshpeterson/.zshenv_private | cut -d'=' -f2 | tr -d \"'\""
                        })
                end,
                dependencies = {
                        "MunifTanjim/nui.nvim",
                        "nvim-lua/plenary.nvim",
                        "folke/trouble.nvim",
                        "nvim-telescope/telescope.nvim"
                }
        },

        -- Multi-cursor configuration
        -- This is the Neovim implementation of the famous Emacs Hydra package.
        {
                'smoka7/hydra.nvim'
        },

        {
                'terryma/vim-multiple-cursors'
        },

        -- lazy.nvim:
        {
                "smoka7/multicursors.nvim",
                event = "VeryLazy",
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
                        require("formatter").setup {
                                logging = true,
                                log_level = vim.log.levels.WARN,
                                filetype = {
                                        lua = {
                                                require("formatter.filetypes.lua").stylua,
                                                function()
                                                        if vim.fn.expand('%:t') == "special.lua" then -- Use vim.fn.expand for filename check
                                                                return nil
                                                        end
                                                        return {
                                                                exe = "stylua",
                                                                args = {
                                                                        "--search-parent-directories",
                                                                        "--stdin-filepath", vim.fn.fnameescape(vim.api
                                                                        .nvim_buf_get_name(0)),
                                                                        "--",
                                                                        "-"
                                                                },
                                                                stdin = true
                                                        }
                                                end
                                        },
                                        ["*"] = {
                                                require("formatter.filetypes.any").remove_trailing_whitespace
                                        }
                                }
                        }
                end
        },

        -- notify.nvim
        {
                'rcarriga/nvim-notify',
                config = function()
                        require("notify").setup {
                                stages = 'fade_in_slide_out',
                                background_colour = '#000000',
                                timeout = 3000,
                                icons = nonicons_extention.icons,
                        }
                        vim.notify = require('notify')
                end
        },

        -- pomodoro timer
        {
                "epwalsh/pomo.nvim",
                version = "*", -- Recommended, use latest release instead of latest commit
                lazy = true,
                cmd = { "TimerStart", "TimerRepeat", "TimerStop", "TimerShow", "TimerHide", "TimerPause", "TimerResume" },
                dependencies = {
                        -- Optional, but highly recommended if you want to use the "Default" timer
                        "rcarriga/nvim-notify",
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
                                        name = "Default",
                                        opts = {
                                                -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
                                                -- continuously displayed. If you only want a pop-up notification when the timer starts
                                                -- and finishes, set this to false.
                                                sticky = true,

                                                -- Configure the display icons:
                                                title_icon = "󱎫",
                                                text_icon = "󰄉",
                                                -- Replace the above with these if you don't have a patched font:
                                                -- title_icon = "⏳",
                                                -- text_icon = "⏱️",
                                        },
                                },

                                -- The "System" notifier sends a system notification when the timer is finished.
                                -- Currently this is only available on MacOS.
                                -- Tracking: https://github.com/epwalsh/pomo.nvim/issues/3
                                { name = "System" },

                                -- You can also define custom notifiers by providing an "init" function instead of a name.
                                -- See "Defining custom notifiers" below for an example 👇
                                -- { init = function(timer) ... end }
                        },

                        -- Override the notifiers for specific timer names.
                        timers = {
                                -- For example, use only the "System" notifier when you create a timer called "Break",
                                -- e.g. ':TimerStart 2m Break'.
                                Break = {
                                        { name = "System" },
                                },
                        },
                },
        },

        -- Tmux Configs
        -- Vim Tmux Navigator for Tmux config
        {
                "christoomey/vim-tmux-navigator",
                cmd = {
                        "TmuxNavigateLeft",
                        "TmuxNavigateDown",
                        "TmuxNavigateUp",
                        "TmuxNavigateRight",
                        "TmuxNavigatePrevious",
                },
                keys = {
                        { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
                        { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
                        { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
                        { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
                        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
                },
        },

        -- vim-tpipeline
        {
                'vimpostor/vim-tpipeline'
        },

        -- firenvim for using Neovim in Chrome
        {
                'glacambre/firenvim',
                dependencies = {
                        "nvim-treesitter/nvim-treesitter"
                },
                -- Lazy load firenvim
                -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
                lazy = not vim.g.started_by_firenvim,
                build = function()
                        vim.fn["firenvim#install"](0)
                end
        },

        -- ranger.nvim file manager
        {
                "kelly-lin/ranger.nvim",
                config = function()
                        require("ranger-nvim").setup({ replace_netrw = true })
                end,
        },

        -- live-server for HTML, CSS & JavaScript
        {
                'barrett-ruth/live-server.nvim',
                build = 'pnpm add -g live-server',
                cmd = { 'LiveServerStart', 'LiveServerStop' },
                config = function()
                        require('live-server').setup()
                end,
        },

        -- hologram.nvim for image rendering inside of Neovim
        {
                "edluffy/hologram.nvim",
                config = function()
                        require('hologram').setup {
                                auto_display = true,
                        }
                end
        },


}
