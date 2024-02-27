-- treesitter.lua
--[[
        custom.plugins.treesitter: Configures Neovim's integration with Tree-sitter, an incremental parsing system that enhances syntax highlighting, code navigation, and various code analysis features. This file tailors the Tree-sitter setup to suit specific development workflows, including defining language parsers to install, enabling syntax-aware code editing features like indentation and folding, and customizing highlight groups for improved readability. Additional configurations may involve setting up Tree-sitter based code navigation shortcuts, enabling language-specific features such as automatic tag closing or context-aware commenting, and integrating with other plugins that leverage Tree-sitter's parsing capabilities for advanced code analysis and manipulation tasks. Through custom.plugins.treesitter, users can vastly improve their coding experience in Neovim by leveraging the power of Tree-sitter's fine-grained understanding of code structure.
]]


return {

        -- nvim-treesitter for enhanced syntax highlighting and additional language features
        {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate',
                config = function()
                        require('nvim-treesitter.configs').setup {
                                -- Ensure all maintained parsers are installed
                                ensure_installed = "all",
                                sync_install = false, -- Install parsers synchronously (only applies to `ensure_installed`)

                                highlight = {
                                        enable = true, -- Enable Treesitter-based highlighting
                                },

                                -- Treesitter playground for exploring Treesitter queries and captures
                                playground = {
                                        enable = true,
                                        disable = {},
                                        updatetime = 25, -- Debounced time for highlighting nodes from source code
                                        persist_queries = false, -- Persist queries across sessions
                                },
                        }
                end
        },

        -- nvim-treesitter/playground to explore Treesitter queries in a UI
        {
                'nvim-treesitter/playground',
                cmd = 'TSPlaygroundToggle',
        },
}
