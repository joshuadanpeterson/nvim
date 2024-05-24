-- config/cmp.lua
-- Configures Neovim for enhanced editing capabilities with autocomplete, LSP, and linting.

-- Debug statement: Check $HOME/.cache/nvim/lsp.log
-- vim.lsp.set_log_level 'debug'

local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
local tailwindcss_colorizer_cmp = require 'tailwindcss-colorizer-cmp'
require('luasnip.loaders.from_vscode').lazy_load()

-- Custom Telescope source
-- require('cmp').register_source('custom_telescope', require('custom.custom_cmp_telescope').new())

cmp.setup {
  snippet = {
    expand = function(args)
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
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
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
  },
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'buffer-lines' },
    { name = 'path' },
    { name = 'emoji' },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Apply tailwindcss colorizer formatter
      vim_item = tailwindcss_colorizer_cmp.formatter(entry, vim_item)

      -- Apply lspkind formatter
      vim_item = lspkind.cmp_format {
        mode = 'symbol_text',
        maxwidth = 50,
        ellipsis_char = '...',
      }(entry, vim_item)

      -- Set the menu field
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        path = '[Path]',
        nvim_lua = '[Lua]',
        latex_symbols = '[LaTeX]',
      })[entry.source.name]

      return vim_item
    end,
  },
}

-- Cmdline setup for '/' and ':'
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- Integrates autopairs into Autocompletion
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

-- Set configuration for specific filetype.
cmp.setup.filetype('html', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer-lines' },
  }, {
    { name = 'buffer' },
  }, {
    { name = 'path' },
  }),
})

-- Ensure `nvim-cmp` works for embedded JavaScript/JSX in HTML files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'html',
  callback = function()
    require('cmp').setup.buffer {
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'buffer-lines' },
        { name = 'path' },
        { name = 'emoji' },
      },
    }
  end,
})

-- Additional configuration for specific filetypes (optional)
cmp.setup.filetype('javascript', {
  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
})
-- Set CMP source for prompt buffer type
-- cmp.setup.filetype('prompt', {
--   sources = {
--     { name = 'custom_telescope' },
--   },
-- })

