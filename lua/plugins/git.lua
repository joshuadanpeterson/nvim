-- git.lua
--[[
        custom.plugins.git: Enhances Git integration in Neovim, possibly through plugins like fugitive.vim or gitsigns.nvim. Configurations could include commands for common Git operations, keybindings for navigating changes, and UI customizations for displaying Git information.
]]

return {
        -- git related plugins

        -- Git integration for Vim.
        {
                'tpope/vim-fugitive',
        },

        -- Complements vim-fugitive, allowing interaction with GitHub.
        {
                'tpope/vim-rhubarb',
        },

        -- gitgutter: Displays git diff markers in the sign column.
        {
                'airblade/vim-gitgutter'
        },

        {
                -- adds git related signs to the gutter, as well as utilities for managing changes
                'lewis6991/gitsigns.nvim',
                opts = {
                        -- see `:help gitsigns.txt`
                        signs = {
                                add = { text = '+' },
                                change = { text = '~' },
                                delete = { text = '_' },
                                topdelete = { text = '‾' },
                                changedelete = { text = '~' },
                        },
                        on_attach = function(bufnr)
                                vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
                                        { buffer = bufnr, desc = 'preview git hunk' })

                                -- don't override the built-in and fugitive keymaps
                                local gs = package.loaded.gitsigns
                                vim.keymap.set({ 'n', 'v' }, ']c', function()
                                        if vim.wo.diff then
                                                return ']c'
                                        end
                                        vim.schedule(function()
                                                gs.next_hunk()
                                        end)
                                        return '<ignore>'
                                end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
                                vim.keymap.set({ 'n', 'v' }, '[c', function()
                                        if vim.wo.diff then
                                                return '[c'
                                        end
                                        vim.schedule(function()
                                                gs.prev_hunk()
                                        end)
                                        return '<ignore>'
                                end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
                        end,
                },
        },
}
