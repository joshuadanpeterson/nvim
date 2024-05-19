-- config/lsp.lua
-- LSP configurations

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local typescript = require('typescript')
local null_ls = require('null-ls')

-- Enhanced capabilities from nvim-cmp for LSP
local capabilities = cmp_nvim_lsp.default_capabilities()
-- For emmet-ls
local capabiliteez = vim.lsp.protocol.make_client_capabilities()
capabiliteez.textDocument.completion.completionItem.snippetSupport = true

-- Setup mason to manage LSP installations
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls', 'tsserver', 'pyright', 'html', 'cssls', 'bashls', 'rust_analyzer',
        'gopls', 'phpactor', 'solargraph', 'jsonls', 'yamlls', 'sqls', 'dockerls', 'vimls',
        -- Include additional servers here
    },
})

-- LSP servers setup with specific configurations for certain servers
local servers = {
    'lua_ls', 'tsserver', 'pyright', 'html', 'cssls', 'bashls', 'rust_analyzer',
    'gopls', 'phpactor', 'solargraph', 'jsonls', 'yamlls', 'sqls', 'dockerls', 'vimls',
}

-- Special configurations for specific LSP servers
local special_configurations = {
    lua_ls = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        },
        on_init = function(client)
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                },
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            return true
        end,
    },
}

-- Function to set up LSP servers
local function setup_servers()
    for _, server in ipairs(servers) do
        local config = special_configurations[server] or {}
        config.capabilities = capabilities
        lspconfig[server].setup(config)
    end
end

-- Configure LSP servers
setup_servers()

-- Ensure html LSP is configured
lspconfig.html.setup({
    cmd = { "/System/Volumes/Data/Users/joshpeterson/.nvm/versions/node/v18.12.1/bin/html-languageserver", "--stdio" },
    filetypes = { "html" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true
        },
        provideFormatter = true
    },
    capabilities = capabilities, -- Add capabilities to support nvim-cmp
})

-- Configure cssls
lspconfig.cssls.setup({
    capabilities = capabilities,
})

-- Configure tsserver
lspconfig.tsserver.setup({
    capabilities = capabilities,
})

lspconfig.emmet_ls.setup({
    -- on_attach = on_attach,
    capabilities = capabiliteez,
    filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'javascript' },
    init_options = {
        html = {
            options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
            },
        },
    }
})
    },
})

-- Configure nvim-cmp for auto-completion
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
})

-- Cmdline setup for '/' and ':'
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    },
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
})

-- Integrates autopairs into Autocompletion
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))
