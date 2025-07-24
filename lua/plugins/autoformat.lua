-- autoformat.lua
--[[
  kickstart.plugins.autoformat: Enables automatic code formatting in Neovim, potentially integrating with formatters like Prettier, Black, or clang-format. This configuration specifies formatting rules, sets up file type associations, and might define keybindings for manually triggering formatting.
]]

return {

  -- nvim-ts-autotag: Automatically closes and renames HTML tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- vim-commentary: Efficient commenting in Vim, toggle comments easily.
  {
    'tpope/vim-commentary',
    event = 'VeryLazy',
  },

  -- vim-sleuth: Automatically detects tabstop and shiftwidth settings.
  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  -- conform.nvim: Format plugin
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Comment.nvim: Smart and powerful comment plugin for Neovim
  {
    'numtostr/Comment.nvim',
    event = 'BufReadPre',
    config = function()
      require('Comment').setup {
        padding = true,
        sticky = true,
        ignore = '^$',
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
        toggler = {
          line = 'gcc',
          block = 'gbc',
        },
        opleader = {
          line = 'gc',
          block = 'gb',
        },
        pre_hook = function(ctx)
          if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
            local U = require 'Comment.utils'
            local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
              location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require('ts_context_commentstring.utils').get_visual_start_location()
            end
            return require('ts_context_commentstring.internal').calculate_commentstring {
              key = type,
              location = location,
            }
          end
        end,
      }
    end,
  },

  -- nvim-surround: Surround selections
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  --surround-ui: Helper plugin for nvim-surround
  {
    'roobert/surround-ui.nvim',
    dependencies = {
      'kylechui/nvim-surround',
    },
    config = function()
      require('surround-ui').setup {
        root_key = 'S',
      }
    end,
  },

  -- For JSX syntax highlighting and indentation
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
  },

  -- To help Neovim recognize JS and JSX inside of HTML files
  {
    'jonsmithers/vim-html-template-literals',
    event = { 'BufReadPre', 'BufNewFile' },
  },

  {
    'pangloss/vim-javascript',
    event = { 'BufReadPre', 'BufNewFile' },
  },
}
