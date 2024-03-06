-- useful plugin to show you pending keybinds.
-- Shows a popup with possible keybindings of the command you started typing.
return {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
        end,
        config = function()
                local which_key = require("which-key")

                -- Define plugin options
                local opts = {
                        plugins = {
                                marks = true,     -- shows a list of your marks on ' and `
                                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                                -- Add other plugin configurations here...
                                spelling = {
                                        enabled = true,
                                        suggestions = 20,
                                },
                                presets = {
                                        operators = true,
                                        motions = true,
                                        text_objects = true,
                                        windows = true,
                                        nav = true,
                                        z = true,
                                        g = true,
                                },
                        },

                }

                -- Apply the configuration options
                which_key.setup(opts)
        end
}
