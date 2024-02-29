-- harpoon.lua
--[[
    custom.plugins.harpoon: Configures the Harpoon plugin, which is used for navigating between frequently accessed files and projects within Neovim. This could involve setting marks, customizing the UI, and defining navigation keybindings.
]]

return {
    -- Define the plugin source
    -- Using harpoon2
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup({})
        end
    }

}
