-- treesitter.lua
--[[
        custom.plugins.treesitter: Configures Neovim's integration with Tree-sitter, an incremental parsing system that enhances syntax highlighting, code navigation, and various code analysis features. This file tailors the Tree-sitter setup to suit specific development workflows, including defining language parsers to install, enabling syntax-aware code editing features like indentation and folding, and customizing highlight groups for improved readability. Additional configurations may involve setting up Tree-sitter based code navigation shortcuts, enabling language-specific features such as automatic tag closing or context-aware commenting, and integrating with other plugins that leverage Tree-sitter's parsing capabilities for advanced code analysis and manipulation tasks. Through custom.plugins.treesitter, users can vastly improve their coding experience in Neovim by leveraging the power of Tree-sitter's fine-grained understanding of code structure.
]]


return {

        -- nvim-treesitter for enhanced syntax highlighting and additional language features
        {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate',
                event = { 'BufReadPre', 'BufNewFile' },
                dependencies = {
                        'nvim-treesitter/nvim-treesitter-textobjects',
                },
        },

        -- nvim-treesitter/playground to explore Treesitter queries in a UI
        {
                'nvim-treesitter/playground',
                cmd = 'TSPlaygroundToggle',
                dependencies = {
                        'nvim-treesitter/nvim-treesitter',
                }
        },

        -- nvim-treesitter-textobjects
        {
                'nvim-treesitter-textobjects',
                lazy = true,
                config = function()
                        require('nvim-treesitter.configs').setup {
                                textobjects = {
                                        select = {
                                                enable = true,

                                                -- Automatically jump forward to textobj, similar to targets.vim
                                                lookahead = true,

                                                keymaps = {
                                                        -- You can use the capture groups defined in textobjects.scm
                                                        ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
                                                        ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
                                                        ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
                                                        ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },


                                                        ['ai'] = { query = '@assignment.outer', desc = 'Select outer part of an conditional' },
                                                        ['ii'] = { query = '@assignment.inner', desc = 'Select inner part of an conditional' },


                                                        ['al'] = { query = '@assignment.outer', desc = 'Select outer part of a loop' },
                                                        ['il'] = { query = '@assignment.inner', desc = 'Select inner part of a loop' },


                                                        ['af'] = { query = '@assignment.outer', desc = 'Select outer part of a function call' },
                                                        ['if'] = { query = '@assignment.inner', desc = 'Select inner part of a function call' },


                                                        ['am'] = { query = '@assignment.outer', desc = 'Select outer part of a method/function def' },
                                                        ['im'] = { query = '@assignment.inner', desc = 'Select inner part of a method/function def' },


                                                        ['ac'] = { query = '@assignment.outer', desc = 'Select outer part of a class' },
                                                        ['ic'] = { query = '@assignment.inner', desc = 'Select inner part of a class' },
                                                }
                                        }
                                }
                        }
                end
        },
}
