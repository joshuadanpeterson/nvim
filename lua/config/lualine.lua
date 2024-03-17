-- config/lualine.lua

--[[
    Customizes the status line in Neovim using the Lualine plugin. Configurations typically involve setting the appearance of the status line, choosing which components to display, and possibly integrating with other plugins for status information.
]]

local function is_active()
    local ok, hydra = pcall(require, 'hydra.statusline')
    return ok and hydra.is_active()
end

local function get_name()
    local ok, hydra = pcall(require, 'hydra.statusline')
    if ok then
        return hydra.get_name()
    end
    return ''
end

local function setup_lualine()
    -- Define the lualine setup configuration
    local config = {
        options = {
            icons_enabled = true,
            theme = 'nord',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { { 'filename', file_status = true, path = 1, }, 'diagnostics', 'branch', 'diff', get_name, cond = is_active },
            lualine_c = { {
                'searchcount',
                maxcount = 999,
                timeout = 500,
            },
                -- install harpoon2
                "harpoon2",
            },
            lualine_x = { {
                'datetime',
                fmt = function()
                    return os.date('%Y-%m-%d %H:%M')
                end,
            },
                'encoding',
                {
                    'filetype',
                    colored = true,
                },
                {
                    'copilot',
                    -- Default values
                    symbols = {
                        status = {
                            icons = {
                                enabled = " ",
                                sleep = " ", -- auto-trigger disabled
                                disabled = " ",
                                warning = " ",
                                unknown = " "
                            },
                            hl = {
                                enabled = "#50FA7B",
                                sleep = "#AEB7D0",
                                disabled = "#6272A4",
                                warning = "#FFB86C",
                                unknown = "#FF5555"
                            }
                        },
                        spinners = require("copilot-lualine.spinners").dots,
                        spinner_color = "#6272A4"
                    },
                    show_colors = true,
                    show_loading = true
                },
            },
            lualine_y = { 'progress' },
            lualine_z = {
                'location',
            },
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
