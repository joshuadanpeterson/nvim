-- plugins/lualine.lua
--[[
  custom.plugins.lualine: Loads lualine and related plugins.
]]

return {
    -- lualine configuration
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'letieu/harpoon-lualine',
        },
        event = 'bufreadpre',
        config = function()
            require('lualine').setup {
            }
        end
    },

    -- copilot lualine
    {
        'AndreM222/copilot-lualine',
    },

    -- harpoon-lualine
    {
        "letieu/harpoon-lualine",
        dependencies = {
            {
                "ThePrimeagen/harpoon",
                branch = "harpoon2",
            }
        },
    },
}
