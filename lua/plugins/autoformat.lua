-- autoformat.lua
--[[
  kickstart.plugins.autoformat: Enables automatic code formatting in Neovim, potentially integrating with formatters like Prettier, Black, or clang-format. This configuration specifies formatting rules, sets up file type associations, and might define keybindings for manually triggering formatting.
]]

return {

  -- nvim-ts-autotag
  -- Automatically closes and renames HTML tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- nvim-autopairs
  -- autopairs: Automatically pairs brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  -- vim-commentary
  -- Efficient commenting in Vim, toggle comments easily.
  {
    'tpope/vim-commentary',
  },

  -- vim-sleuth
  -- Automatically detects tabstop and shiftwidth settings.
  {
    'tpope/vim-sleuth',
  },

  -- conform.nvim: format plugin
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Comment.nvim
  -- Smart and powerful comment plugin for neovim that supports toggling, motions, operators, and more.
  {
    'numtostr/Comment.nvim',
    config = function()
      require('Comment').setup {
        -- optional configuration here
        padding = true,
        sticky = true,
        ignore = '^$',
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
        toggler = {
          line = 'gcc', -- toggle line comment
          block = 'gbc', -- toggle block comment
        },
        opleader = {
          line = 'gc', -- line comment operation
          block = 'gb', -- block comment operation
        },
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx filetypes
          if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
            local U = require 'Comment.utils'

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'

            -- Determine the location where to calculate commentstring from
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

  -- nvim-surround: surround selections
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  -- For JSX syntax highlighting and indentation
  {
    'maxmellon/vim-jsx-pretty',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' },
  },

  -- To help Neovim recognize JS and JSX inside of HTMl files
  {
    'jonsmithers/vim-html-template-literals',
    'pangloss/vim-javascript',
  },
}
