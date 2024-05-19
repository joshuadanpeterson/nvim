-- config/cmp.lua
-- Configures Neovim for enhanced editing capabilities with autocomplete, LSP, and linting.

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'emoji' },
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Apply tailwindcss colorizer formatter
            vim_item = tailwindcss_colorizer_cmp.formatter(entry, vim_item)


            -- Apply lspkind formatter
            return lspkind.cmp_format({
                mode = 'symbol_text',
                maxwidth = 50,
                ellipsis_char = '...',
            })(entry, vim_item)
        end,
    },
})

-- Ensure `nvim-cmp` works for embedded JavaScript/JSX in HTML files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function()
        require('cmp').setup.buffer({
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'emoji' },
            },
        })
    end,
})
