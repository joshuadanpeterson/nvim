-- plugins/lsp.lua
--[[
        custom.plugins.lsp: Configures the Language Server Protocol (LSP) support in Neovim, enabling features like auto-completion, go-to definition, and inline errors, Treesitter for enhanced syntax highlighting and language features. This includes setting up language servers, customizing LSP-related keybindings, and integrating with completion plugins.
]]


return {

        -- nvim-lspconfig for configuring language servers
        {
                'neovim/nvim-lspconfig',
                config = function()
                        require('mason').setup()
                        require('mason-lspconfig').setup({
                                ensure_installed = {
                                        -- LSP servers
                                        "lua_ls",        -- Lua
                                        "tsserver",      -- TypeScript/JavaScript
                                        "eslint-lsp",    -- JavaScript
                                        "pyright",       -- Python
                                        "html",          -- HTML
                                        "cssls",         -- CSS
                                        "bashls",        -- Bash
                                        "rust_analyzer", -- Rust
                                        "gopls",         -- Go
                                        "phpactor",      -- PHP
                                        "solargraph",    -- Ruby
                                        "jsonls",        -- JSON
                                        "yamlls",        -- YAML
                                        "sqls",          -- SQL
                                        "dockerls",      -- Docker
                                        "vimls",         -- VimScript
                                        -- Add more servers per your requirement

                                        -- Linters
                                        "luacheck",                 -- Lua
                                        "eslint_d",                 -- TypeScript/JavaScript
                                        "flake8", "pylint", "mypy", -- Python
                                        "htmlhint",                 -- HTML
                                        "stylelint",                -- CSS
                                        "shellcheck",               -- Bash
                                        "clippy",                   -- Rust
                                        "golangci-lint",            -- Go
                                        "phpcs", "phpstan",         -- PHP
                                        "rubocop",                  -- Ruby
                                        "jsonlint",                 -- JSON
                                        "yamllint",                 -- YAML
                                        "sqlfluff",                 -- SQL
                                        "hadolint",                 -- Docker
                                        "vint",                     -- VimScript

                                        -- Formatters
                                        "stylua",               -- Lua
                                        "prettier",             -- TypeScript/JavaScript, JSON, YAML, HTML, CSS
                                        "black",                -- Python
                                        "gofumpt", "goimports", -- Go
                                        "php-cs-fixer",         -- PHP
                                        "rufo",                 -- Ruby
                                        "sqlformat",            -- SQL
                                        "dockerfile_lint",      -- Docker
                                        "vim-codefmt"           -- VimScript
                                        -- More formatters can be added per your requirements
                                },
                                automatic_installation = true, -- Automatically install missing LSPs
                        })
                        -- Example for configuring Lua language server:
                        require('lspconfig').lua_ls.setup {
                                on_init = function(client)
                                        local path = client.workspace_folders[1].name
                                        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                                                -- Dynamically construct the path to the leetcode.nvim directory
                                                local home = os.getenv("HOME")
                                                local leetcode_nvim_path = home ..
                                                    "/.local/share/nvim/lazy/leetcode.nvim"

                                                client.config.settings = vim.tbl_deep_extend('force',
                                                        client.config.settings, {
                                                                Lua = {
                                                                        runtime = {
                                                                                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                                                                version = 'LuaJIT',
                                                                        },
                                                                        diagnostics = {
                                                                                -- Get the language server to recognize the `vim` global
                                                                                globals = { 'vim' },
                                                                        },
                                                                        workspace = {
                                                                                -- Make the server aware of Neovim runtime files
                                                                                checkThirdParty = false,
                                                                                library = {
                                                                                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                                                                                        [vim.fn.stdpath('config') .. '/lua'] = true,
                                                                                        [leetcode_nvim_path] = true,
                                                                                },
                                                                        },
                                                                        -- Do not send telemetry data containing a randomized but unique identifier
                                                                        telemetry = {
                                                                                enable = false,
                                                                        },
                                                                },
                                                        })

                                                client.notify("workspace/didChangeConfiguration",
                                                        { settings = client.config.settings })
                                        end
                                        return true
                                end
                        }

                        -- Setup for TypeScript and JavaScript via tsserver
                        require('lspconfig').tsserver.setup {
                                on_attach = function(client, bufnr)
                                        -- Disable tsserver formatting if you prefer formatting via prettier or another tool
                                        client.server_capabilities.document_formatting = false

                                        -- Example keybindings for LSP functions
                                        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
                                        local opts = { noremap = true, silent = true }
                                        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                                        buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
                                        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
                                        -- Add more keybindings as needed
                                end,
                        }

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

        -- nvim-emmet | for integration with emmet-language-server
        {
                "olrtg/nvim-emmet",
                config = function()
                        vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
                end,
        },

        -- lspsaga.nvim for beautiful UIs for various LSP-related features
        {
                'nvimdev/lspsaga.nvim',
                config = function()
                        require('lspsaga').setup({})
                end,
                dependencies = {
                        'nvim-treesitter/nvim-treesitter', -- optional
                        'nvim-tree/nvim-web-devicons',     -- optional
                }
        },

        -- For using glow for LSP hover
        {
                'JASONews/glow-hover',
                config = function()
                        require 'glow-hover'.setup {
                                -- The followings are the default values
                                max_width = 50,
                                padding = 10,
                                border = 'shadow',
                                glow_path = 'glow'
                        }
                end,
        },

        -- Ensure you have the necessary plugins for LSP features like autocompletion, etc.
        -- For example, nvim-cmp and its sources, LuaSnip for snippets, etc.
}
