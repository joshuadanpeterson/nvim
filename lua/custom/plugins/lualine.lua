-- lualine.lua
--[[
  custom.plugins.lualine: Customizes the status line in Neovim using the Lualine plugin. Configurations typically involve setting the appearance of the status line, choosing which components to display, and possibly integrating with other plugins for status information.
]]


return {
  -- lualine configuration
  {
    'nvim-lualine/lualine.nvim',
    event = 'bufreadpre',
    config = function()
      vim.keymap.set('n', '<leader>l', ':lua require("lualine").refresh<cr>', { desc = 'refresh status line' })
      require('lualine').setup {
        opts = {
          options = {
            icons_enabled = true,
            theme = 'nord',
            component_separators = '|',
            section_separators = '',
          },
          sections = {
            lualine_a = { 'mode' },
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
                style = '%h:%m:%s',
              },
              'encoding',
              {
                'filetype',
                colored = true,
              },
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
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
            lualine_z = { 'location' },
          },
          tabline = {},
        } }
    end,
  },
}
