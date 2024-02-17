-- lualine.lua
--[[
  custom.plugins.lualine: Customizes the status line in Neovim using the Lualine plugin. Configurations typically involve setting the appearance of the status line, choosing which components to display, and possibly integrating with other plugins for status information.
]]

local function setup_lualine()
    -- Define the lualine setup configuration
    local config = {
        options = {
            icons_enabled = true,
            theme = 'nord',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { {'filename', file_status = true, path = 1,}, 'diagnostics', 'branch', 'diff' },
            lualine_c = { { 'searchcount',
                            maxcount = 999,
                            timeout = 500,
                           },
            },
            lualine_x = { {
                    'datetime',
                    fmt = function()
                        return os.date('%Y-%m-%d %H:%M')
                    end,
                },
                'encoding',
                { 'filetype',
                    colored = true,
                },
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
        },
        inactive_sections = {
            lualine_a = { { 'filename', file_status = true, path = 1, }, 'diagnostics', 'diff' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = { 'copilot' },
            lualine_z = { 'location' }
        },
        tabline = {}
    }

    -- Setup lualine with the defined configuration
    require('lualine').setup(config)
end

local function refresh_lualine()
    -- Unload the lualine module
    package.loaded['lualine'] = nil
    -- Reload and re-setup lualine with the current configuration
    setup_lualine()
end

-- Keymap to refresh lualine
vim.keymap.set('n', '<leader>nl', refresh_lualine, { desc = 'Refresh status line' })

return {
  -- lualine configuration
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'bufreadpre',
    config = setup_lualine
  },

  -- copilot lualine
  {
    'AndreM222/copilot-lualine',
  },
}
