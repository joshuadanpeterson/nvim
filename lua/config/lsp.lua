-- config.lsp
-- LSP configurations

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- LSP servers setup
local servers = { 'lua_ls', 'tsserver', 'pyright', 'html', 'cssls', 'bashls', 'rust_analyzer', 'gopls', 'phpactor',
    'ruby_ls', 'jsonls', 'yamlls', 'sqls', 'dockerls', 'vimls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = cmp_nvim_lsp.default_capabilities(),
    }
end

-- lspconfig
require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                lua = {
                    runtime = {
                        -- tell the language server which version of lua you're using
                        -- (most likely luajit in the case of neovim)
                        version = 'luaJIT'
                    },
                    diagnostics = {
                        globals = { 'vim' }, -- This informs the LS that `vim` is a global variable and shouldn't be flagged as undefined
                    },
                    -- make the server aware of neovim runtime files
                    workspace = {
                        checkthirdparty = false,
                        library = vim.api.nvim_get_runtime_file("", true), -- Make the LS aware of Neovim runtime files
                    },

                }
            })

            client.notify("workspace/didchangeconfiguration", { settings = client.config.settings })
        end
        return true
    end
}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- Key mappings or other buffer-specific settings go here
    -- Example of setting a keymap with bufnr:
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',
        { noremap = true, silent = true })
    -- ... more configurations
end
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.

-- Load Neovim's built-in LSP configuration module
local lspconfig = require('lspconfig')

-- Configure Jedi Language Server
lspconfig.jedi_language_server.setup {
    on_attach = on_attach, -- assuming you have an `on_attach` function as shown in your config
    flags = {
        debounce_text_changes = 150,
    }
}

-- TypeScript and JavaScript LSP configuration
lspconfig.tsserver.setup {
    on_attach = function(_client, _bufnr)
        -- Your custom on_attach function
        -- (e.g., key mappings for LSP functions)
    end,
    -- Additional LSP settings can be added here
}

--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- tsserver = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },

    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
        },
    },
}


-- Setup LSP Configurations for `nvim-cmp`
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- Example: Setting up Lua LSP
require 'lspconfig'.lua_ls.setup {
    capabilities = capabilities,
}

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})

-- Integrates autopairs into Autocompletion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
