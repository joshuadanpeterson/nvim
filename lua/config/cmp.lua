-- config/cmp.lua
-- Configures Neovim for enhanced editing capabilities with autocomplete, LSP, and linting.

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
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
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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



-- LSP servers setup
local servers = { 'lua_ls', 'tsserver', 'pyright', 'html', 'cssls', 'bashls', 'rust_analyzer', 'gopls', 'phpactor', 'ruby_ls', 'jsonls', 'yamlls', 'sqls', 'dockerls', 'vimls' }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        capabilities = cmp_nvim_lsp.default_capabilities(),
    }
end

-- Linting setup
require('lint').linters_by_ft = {
    lua = { 'luacheck' },
    javascript = { 'eslint' },
    typescript = { 'eslint' },
    python = { 'flake8', 'pylint', 'mypy' },
    html = { 'htmlhint' },
    css = { 'stylelint' },
    sh = { 'shellcheck' },
    rust = { 'clippy' },
    go = { 'golangci-lint' },
    php = { 'phpcs', 'phpstan' },
    ruby = { 'rubocop' },
    json = { 'jsonlint' },
    yaml = { 'yamllint' },
    sql = { 'sqlfluff' },
    dockerfile = { 'hadolint' },
    vim = { 'vint' },
}

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        require('lint').try_lint()
    end,
})

