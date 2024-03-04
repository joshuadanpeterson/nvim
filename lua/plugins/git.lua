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
                config = function()
                        require('gitsigns').setup {
                                signs                        = {
                                        add          = { text = '│' },
                                        change       = { text = '│' },
                                        delete       = { text = '_' },
                                        topdelete    = { text = '‾' },
                                        changedelete = { text = '~' },
                                        untracked    = { text = '┆' },
                                },
                                signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
                                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                                watch_gitdir                 = {
                                        follow_files = true
                                },
                                auto_attach                  = true,
                                attach_to_untracked          = false,
                                current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                                current_line_blame_opts      = {
                                        virt_text = true,
                                        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                                        delay = 1000,
                                        ignore_whitespace = false,
                                        virt_text_priority = 100,
                                },
                                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                                sign_priority                = 6,
                                update_debounce              = 100,
                                status_formatter             = nil,   -- Use default
                                max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                                preview_config               = {
                                        -- Options passed to nvim_open_win
                                        border = 'single',
                                        style = 'minimal',
                                        relative = 'cursor',
                                        row = 0,
                                        col = 1
                                },
                                yadm                         = {
                                        enable = false
                                },
                                on_attach                    = function(bufnr)
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
                                end, }
                end
        }
}
