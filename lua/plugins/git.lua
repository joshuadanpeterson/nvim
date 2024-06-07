-- git.lua
--[[
        custom.plugins.git: Enhances Git integration in Neovim, possibly through plugins like fugitive.vim or gitsigns.nvim. Configurations could include commands for common Git operations, keybindings for navigating changes, and UI customizations for displaying Git information.
]]

return {
  -- Git integration for Vim
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' },
  },

  -- Complements vim-fugitive, allowing interaction with GitHub
  {
    'tpope/vim-rhubarb',
    event = 'User FugitiveLoaded',
  },

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          vim.keymap.set({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<ignore>'
          end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
          vim.keymap.set({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<ignore>'
          end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
        end,
      }
    end,
  },

  -- Telescope GitSigns
  {
    'radyz/telescope-gitsigns',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Telescope',
  },
}
