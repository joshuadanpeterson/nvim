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

        -- useful plugin to show you pending keybinds.
        -- Shows a popup with possible keybindings of the command you started typing.
        {
                'folke/which-key.nvim',
                opts = function(_, opts)
                        if require("lazyvim.util").has("noice.nvim") then
                                opts.defaults["<leader>sn"] = { name = "+noice" }
                        end
                end
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
        }

}
