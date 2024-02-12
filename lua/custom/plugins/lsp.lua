-- lsp.lua
--[[
        custom.plugins.lsp: Configures the Language Server Protocol (LSP) support in Neovim, enabling features like auto-completion, go-to definition, and inline errors, Treesitter for enhanced syntax highlighting and language features. This includes setting up language servers, customizing LSP-related keybindings, and integrating with completion plugins.
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

        -- nvim-lspconfig for configuring language servers
        {
                'neovim/nvim-lspconfig',
                config = function()
                        require('mason').setup()
                        require('mason-lspconfig').setup({
                                ensure_installed = {
                                        -- LSP servers
                                        "lua_ls", -- Lua
                                        "tsserver", -- TypeScript/JavaScript
                                        "pyright", -- Python
                                        "html",  -- HTML
                                        "cssls", -- CSS
                                        "bashls", -- Bash
                                        "rust_analyzer", -- Rust
                                        "gopls", -- Go
                                        "phpactor", -- PHP
                                        "ruby_ls", -- Ruby
                                        "jsonls", -- JSON
                                        "yamlls", -- YAML
                                        "sqls",  -- SQL
                                        "dockerls", -- Docker
                                        "vimls", -- VimScript
                                        -- Add more servers per your requirement

                                        -- Linters
                                        "luacheck", -- Lua
                                        "eslint", -- TypeScript/JavaScript
                                        "flake8", "pylint", "mypy", -- Python
                                        "htmlhint", -- HTML
                                        "stylelint", -- CSS
                                        "shellcheck", -- Bash
                                        "clippy", -- Rust
                                        "golangci-lint", -- Go
                                        "phpcs", "phpstan", -- PHP
                                        "rubocop", -- Ruby
                                        "jsonlint", -- JSON
                                        "yamllint", -- YAML
                                        "sqlfluff", -- SQL
                                        "hadolint", -- Docker
                                        "vint", -- VimScript

                                        -- Formatters
                                        "stylua", -- Lua
                                        "prettier", -- TypeScript/JavaScript, JSON, YAML, HTML, CSS
                                        "black", -- Python
                                        "gofumpt", "goimports", -- Go
                                        "php-cs-fixer", -- PHP
                                        "rufo", -- Ruby
                                        "sqlformat", -- SQL
                                        "dockerfile_lint", -- Docker
                                        "vim-codefmt" -- VimScript
                                        -- More formatters can be added per your requirements
                                },
                                automatic_installation = true, -- Automatically install missing LSPs
                        })
                        -- Example for configuring Lua language server:
                        require('lspconfig').lua_ls.setup {
                          on_init = function(client)
                            local path = client.workspace_folders[1].name
                            if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
                              client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                                Lua = {
                                  runtime = {
                                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT',
                                  },
                                  diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = {'vim'},
                                  },
                                  workspace = {
                                    -- Make the server aware of Neovim runtime files
                                    checkThirdParty = false,
                                    library = {
                                      [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                      [vim.fn.stdpath('config') .. '/lua'] = true,
                                    },
                                  },
                                  -- Do not send telemetry data containing a randomized but unique identifier
                                  telemetry = {
                                    enable = false,
                                  },
                                },
                              })

                              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                            end
                            return true
                          end
                        }

                        -- Setup for TypeScript and JavaScript via tsserver
                        require('lspconfig').tsserver.setup {}

                        -- Python via pyright
                        require('lspconfig').pyright.setup {}

                        -- HTML
                        require('lspconfig').html.setup {}

                        -- CSS, SCSS, and LESS
                        require('lspconfig').cssls.setup {}

                        -- Bash
                        require('lspconfig').bashls.setup {}

                        -- Rust
                        require('lspconfig').rust_analyzer.setup {}

                        -- Go
                        require('lspconfig').gopls.setup {}

                        -- PHP
                        require('lspconfig').phpactor.setup {}

                        -- Ruby
                        require('lspconfig').solargraph.setup {}

                        -- SQL
                        require('lspconfig').sqls.setup {}

                        -- Docker
                        require('lspconfig').dockerls.setup {}

                        -- VimScript
                        require('lspconfig').vimls.setup {}

                        -- JSON
                        require('lspconfig').jsonls.setup {}

                        -- YAML
                        require('lspconfig').yamlls.setup {}
                end
        },

        -- Mason for managing LSP servers, linters, and formatters
        {
                'williamboman/mason.nvim',
                config = function()
                        require('mason').setup()
                end
        },

        -- Mason-LSPConfig to bridge Mason and nvim-lspconfig
        'williamboman/mason-lspconfig.nvim',

        -- Neodev for Lua development with Neovim API support
        'folke/neodev.nvim',

        -- Trouble.nvim for an enhanced diagnostic list
        {
                'folke/trouble.nvim',
                requires = 'nvim-tree/nvim-web-devicons',
                config = function()
                        require('trouble').setup {
                                -- Configuration options
                        }
                end
        },

        -- Ensure you have the necessary plugins for LSP features like autocompletion, etc.
        -- For example, nvim-cmp and its sources, LuaSnip for snippets, etc.
}
