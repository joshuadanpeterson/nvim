-- config/cmp.lua
-- Configures Neovim for enhanced editing capabilities with autocomplete, LSP, and linting.

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local tailwindcss_colorizer_cmp = require("tailwindcss-colorizer-cmp")

-- Define icons for different kinds of completions
local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

-- nvim-cmp setup
cmp.setup({
    snippet = {
        expand = function(args)
            -- For luasnip users
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = 'menu,menuone,noinsert',
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
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
            -- Tailwind CSS colorizer formatter integration
            vim_item = tailwindcss_colorizer_cmp.formatter(entry, vim_item) or vim_item

            -- lspkind formatter integration
            local lspkind_formatted = lspkind.cmp_format({
                mode = "symbol_text",
                with_text = true,
                maxwidth = 50,
                ellipsis_char = "...",
                before = function(entry, vim_item)
                    -- Optional: Customize vim_item here if needed
                    return vim_item
                end,
            })(entry, vim_item)

            -- Additional customization if needed
            if not lspkind_formatted.kind then
                -- Fallback to kind_icons array if lspkind is not available
                vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or '', vim_item.kind)
            end

            -- Source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
            })[entry.source.name]

            return vim_item
        end
    },
})



vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        require('lint').try_lint()
    end,
})
