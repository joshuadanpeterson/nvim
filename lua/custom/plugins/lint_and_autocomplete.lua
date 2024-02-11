-- lint_and_autocomplete.lua
--[[
        custom.plugins.lint_and_autocomplete: Sets up linting and autocomplete functionalities, possibly through integration with LSP, completion plugins like nvim-cmp, and linters like ESLint or luacheck. Configurations would involve defining linting rules, setting up autocomplete sources, and customizing the UI for suggestions.
]]


return {
        -- Install plugin information here
        -- LuaSnip: A snippet engine for Neovim written in Lua.
        {
                'L3MON4D3/LuaSnip',
        },

        -- luasnip completion source for nvim-cmp
        {
                'saadparwaiz1/cmp_luasnip'
        },

        -- Snippets collection for a set of different programming languages.
        {
                'rafamadriz/friendly-snippets'
        },

        -- nvim-lint: An asynchronous linting framework for Neovim.
        {
                'mfussenegger/nvim-lint',
        },

        -- nvim-cmp source for neovim's built-in LSP.
        {
                'hrsh7th/cmp-nvim-lsp',
        },

        -- Intellisense engine for Vim8 & Neovim, full language server protocol support.
        {
                'neoclide/coc.nvim',
                branch = 'release'
        },

        -- ale: asynchronous lint engine for syntax and error checking.
        {
                'dense-analysis/ale'
        },

        -- Autocompletion plugin for Neovim that uses a modern architecture.
        {
                'hrsh7th/nvim-cmp',
                dependencies = {
                        -- snippet engine & its associated nvim-cmp source
                        'L3MON4D3/LuaSnip',
                        'saadparwaiz1/cmp_luasnip',

                        -- adds lsp completion capabilities
                        'hrsh7th/cmp-nvim-lsp',

                        -- adds a number of user-friendly snippets
                        'rafamadriz/friendly-snippets',
                }
        },


        -- Command Line Completion
        -- The next generation auto-completion framework for Neovim.
        {
                'Shougo/ddc.vim'
        },

        -- cmp-cmdline
        {
                'hrsh7th/cmp-cmdline'
        },


}
