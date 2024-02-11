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

                -- Define custom mappings
                local mappings = {
                        ["<leader>"] = {
                                f = {
                                        name = "+file",
                                        f = { "<cmd>Telescope find_files<cr>", "Find File" },
                                        r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
                                        g = { "<cmd>Telescope live_grep<cr>", "Grep Files" },
                                },
                                b = {
                                        name = "+buffer",
                                        b = { "<cmd>Telescope buffers<cr>", "List Buffers" },
                                },
                                -- If you need a noice shortcut, define it here directly
                                sn = { "<cmd>Noice<cr>", "Noice" },
                                -- Add more custom mappings here...
                        },
                }

                -- Default options for registering mappings
                local wk_opts = {
                        mode = "n",   -- NORMAL mode
                        prefix = "",  -- Adjust as needed
                        buffer = nil, -- Global mappings. Set buffer=bufnr for buffer-local mappings
                        silent = true,
                        noremap = true,
                        nowait = true,
                }

                -- Register the mappings with which-key
                which_key.register(mappings, wk_opts)
        end
}
