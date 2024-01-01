return {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  init = function()
    vim.keymap.set('n', '<leader>l', ':lua require("lualine").refresh<CR>', {desc = 'Refresh status line'})
  end,
  opts = {
    options = {
      theme = 'nord',
      component_separators = '│',
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
        },
        'diagnostics',
        'branch',
        'diff',
      },
      lualine_c = {
        {
          'searchcount',
          maxcount = 999,
          timeout = 500,
        }
      },
      lualine_x = {
        {
          'datetime',
          style = '%H:%M:%S',
        },
        'encoding',
        {
          'filetype',
          colored = true,
        },
      },
      lualine_y = {'progress'},
      lualine_z = {'location'},
    },
    inactive_sections = {
      lualine_a = {
        {
          'filename',
          file_status = true,
          path = 1,
        },
        'diagnostics',
        'diff',
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {'location'},
    },
    tabline = {},
    extensions = {
      'trouble',
      'fzf',
      'nvim-dap-ui',
    },
  },
}
