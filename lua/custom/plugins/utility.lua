-- utility.lua
--[[
        custom.plugins.utility: Sets up various utility plugins that provide additional functionality to Neovim, such as file management, clipboard integration, or terminal enhancements. Each utility plugin's specific configuration would be included here.
]]


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
                build = 'make install'
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
                        }
                        vim.notify = require('notify')
                end
        },

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
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
          },
        },

        -- vim-tpipeline
        {
                'vimpostor/vim-tpipeline'
        },


}
