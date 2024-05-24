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
  -- enable autocompletion in Telescope prompts
  -- commenting out until can figure out how to get it to work
  -- enabled = {
  --   function()
  --     local buftype = vim.api.nvim_buf_get_option_value(0, 'buftype')
  --     if buftype == 'prompt' then
  --       return true
  --     end
  --     return true
  --   end,
  -- },
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
    { name = 'copilot', group_index = 2 },
    { name = 'nvim_lsp', max_item_count = 5 },
    { name = 'luasnip', max_item_count = 5 },
    { name = 'buffer', max_item_count = 5 },
    { name = 'buffer-lines', max_item_count = 5 },
    { name = 'path', max_item_count = 5 },
    { name = 'nvim_lua', max_item_count = 5 },
    { name = 'emoji', max_item_count = 5 },
    { name = 'sql', max_item_count = 5 },
    { name = 'rg', max_item_count = 5, keyword_length = 3 },
    { name = 'npm', max_item_count = 5, keyword_length = 4 },
    { name = 'tmux', max_item_count = 5 },
    { name = 'calc', max_item_count = 5 },
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
        symbol_map = { Copilot = '' },
      }(entry, vim_item)

      -- Specific logic for html-css source
      if entry.source.name == 'html-css' then
        vim_item.menu = entry.completion_item.menu
      else
        -- Set the menu field for other sources
        vim_item.menu = ({
          copilot = '[Copilot]',
          buffer = '[Buffer]',
          nvim_lsp = '[LSP]',
          luasnip = '[LuaSnip]',
          path = '[Filesystem]',
          nvim_lua = '[Lua]',
          latex_symbols = '[LaTeX]',
          ['html-css'] = '[HTML-CSS]',
          treesitter = '[TS]',
          sql = '[SQL]',
        })[entry.source.name]
      end

      return vim_item
    end,
  },
}

-- Cmdline setup for '/' and ':'
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
    { name = 'buffer-lines' },
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
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'html-css' },
    { name = 'buffer-lines' },
  }, {
    { name = 'buffer' },
  }, {
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'emoji' },
    { name = 'calc' },
  }),
})

-- Ensure `nvim-cmp` works for embedded JavaScript/JSX in HTML files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'html',
  callback = function()
    require('cmp').setup.buffer {
      sources = {
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'html-css' },
        { name = 'buffer-lines' },
        { name = 'path' },
        { name = 'emoji' },
        { name = 'calc' },
      },
    }
  end,
})

-- Additional configuration for specific filetypes (optional)
cmp.setup.filetype('javascript', {
  sources = cmp.config.sources {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'calc' },
    { name = 'emoji' },
  },
})

cmp.setup.filetype('lua', {
  sources = cmp.config.sources {
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'nvim_lua' },
    { name = 'calc' },
    { name = 'emoji' },
  },
  -- print 'Cmp sources for Lua filetype set',
})

-- Set CMP source for prompt buffer type
-- cmp.setup.filetype('prompt', {
--   sources = {
--     { name = 'custom_telescope' },
--   },
-- })

-- Ensure that the correct filetype is set for your init.lua
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'init.lua',
  callback = function()
    vim.bo.filetype = 'lua'
    -- print 'Cmp Filetype set to lua for init.lua'
  end,
})

-- Set Autocompletion for init.lua
vim.cmd [[
  augroup initLuaAutoComplete
    autocmd!
    autocmd BufEnter * lua require('cmp').setup.buffer()
  augroup END
]]
