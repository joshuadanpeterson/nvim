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
            "nvim-telescope/telescope-ui-select.nvim"
        },
        config = function()
            local harpoon = require('harpoon')
            harpoon:setup({})

            -- Set keymaps
            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Add Harpoon File" })
            vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end, { desc = "Delete Harpoon File" })
            vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Previous Harpoon File" })
            vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Next Harpoon File" })
            vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "Harpoon Quick Menu" })
            for i = 1, 9 do
                vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end,
                    { desc = "Harpoon to File " .. i })
            end
        end
    }

}
