-- This is the configuration for `noice.nvim`, a Neovim plugin that enhances the UI for messages, command line inputs, and popup menus.
-- It is highly customizable, allowing for a refined and user-friendly interface.

return {
        -- Plugin identifier and lazy loading configuration.
        'folke/noice.nvim',
        event = 'VeryLazy', -- Specifies that the plugin should load at a very late stage of the startup process.

        -- Dependencies required by `noice.nvim` for it to work.
        dependencies = {
                "MunifTanjim/nui.nvim", -- UI component library needed for creating UI elements.
                "rcarriga/nvim-notify", -- Notification manager for displaying messages in a more visually appealing manner.
        },

        -- Configuration function for setting up `noice.nvim`.
        config = function()
                require('noice').setup({
                        -- Command line configuration section.
                        cmdline = {
                                enabled = true,         -- Enables the enhanced command line UI provided by Noice.
                                view = "cmdline_popup", -- Uses a popup window for the command line to replace the default at the bottom.
                                opts = {},              -- Global options for the command line view; it's kept empty for default settings.

                                -- Defines custom formats for different command line scenarios.
                                format = {
                                        -- Each table entry customizes how certain types of command line inputs are displayed.
                                        cmdline = { pattern = "^:", icon = "", lang = "vim" },
                                        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                                        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
                                        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                                        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                                        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
                                        input = {},
                                },
                        },

                        -- Messages configuration section.
                        messages = {
                                enabled = true,              -- Enables the enhanced messages UI, allowing for better message management.
                                view = "notify",             -- Uses `nvim-notify` for displaying messages.
                                view_error = "notify",       -- Uses `nvim-notify` for displaying error messages.
                                view_warn = "notify",        -- Uses `nvim-notify` for displaying warning messages.
                                view_history = "notify",     -- Uses the default messages view for displaying message history.
                                view_search = "virtualtext", -- Uses virtual text for displaying search count messages.
                        },

                        -- Popup menu configuration section.
                        popupmenu = {
                                enabled = true,  -- Enables the enhanced popup menu UI.
                                backend = "nui", -- Specifies `nui.nvim` as the backend for displaying the popup menu.
                                kind_icons = {}, -- Configuration for icons next to completion items, if desired.
                        },

                        -- Configuration for redirecting command output or messages.
                        redirect = {
                                view = "popup",                  -- Uses a popup view for displaying redirected messages.
                                filter = { event = "msg_show" }, -- Filters for specific types of messages to redirect.
                        },

                        -- Custom commands specific to `noice.nvim`.
                        commands = {
                                -- This section allows for configuring custom commands that enhance message viewing and management.
                                history = {
                                        view = "split",
                                        opts = { enter = true, format = "details" },
                                        filter = {
                                                any = {
                                                        { event = "notify" },
                                                        { error = true },
                                                        { warning = true },
                                                        { event = "msg_show", kind = { "" } },
                                                        { event = "lsp",      kind = "message" },
                                                },
                                        },
                                },
                                last = {
                                        view = "popup",
                                        opts = { enter = true, format = "details" },
                                        filter = {
                                                any = {
                                                        { event = "notify" },
                                                        { error = true },
                                                        { warning = true },
                                                        { event = "msg_show", kind = { "" } },
                                                        { event = "lsp",      kind = "message" },
                                                },
                                        },
                                        filter_opts = { count = 1 },
                                },
                                errors = {
                                        view = "popup",
                                        opts = { enter = true, format = "details" },
                                        filter = { error = true },
                                        filter_opts = { reverse = true },
                                },
                        },

                        -- Notification integration configuration.
                        notify = {
                                enabled = true,  -- Enables using `noice.nvim` for `vim.notify`, integrating with `nvim-notify`.
                                view = "notify", -- Specifies that notifications should be displayed using `nvim-notify`.
                        },

                        -- Language Server Protocol (LSP) configurations.
                        lsp = {
                                progress = {
                                        -- Configurations for displaying LSP progress messages.
                                        enabled = true,
                                        format = "lsp_progress",
                                        format_done = "lsp_progress_done",
                                        throttle = 1000 / 30,
                                        view = "mini",
                                },
                                override = {
                                        -- Allows for overriding default LSP formatting functions.
                                        ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                                        ["vim.lsp.util.stylize_markdown"] = false,
                                        ["cmp.entry.get_documentation"] = false,
                                },
                                hover = {
                                        -- Configurations for LSP hover documentation.
                                        enabled = true,
                                        silent = false,
                                        view = nil,
                                        opts = {},
                                },
                                signature = {
                                        -- Configurations for function signature help.
                                        enabled = true,
                                        auto_open = {
                                                enabled = true,
                                                trigger = true,
                                                luasnip = true,
                                                throttle = 50,
                                        },
                                        view = nil,
                                        opts = {},
                                },
                                message = {
                                        -- Configurations for displaying LSP server messages.
                                        enabled = true,
                                        view = "notify",
                                        opts = {},
                                },
                                documentation = {
                                        -- Configurations for the appearance and behavior of LSP documentation.
                                        view = "hover",
                                        opts = {
                                                lang = "markdown",
                                                replace = true,
                                                render = "plain",
                                                format = { "{message}" },
                                                win_options = { concealcursor = "n", conceallevel = 3 },
                                        },
                                },
                        },
                        markdown = {
                                -- Configurations for handling markdown and links within hover documentation.
                                hover = {
                                        ["|(%S-)|"] = vim.cmd.help,
                                        ["%[.-%]%((%S-)%)"] = require("noice.util").open,
                                },
                                highlights = {
                                        ["|%S-|"] = "@text.reference",
                                        ["@%S+"] = "@parameter",
                                        ["^%s*(Parameters:)"] = "@text.title",
                                        ["^%s*(Return:)"] = "@text.title",
                                        ["^%s*(See also:)"] = "@text.title",
                                        ["{%S-}"] = "@parameter",
                                },
                        },
                        health = {
                                checker = true, -- Enables running health checks, part of `noice.nvim`'s diagnostics.
                        },
                        smart_move = {
                                -- Configurations for automatically moving UI elements to avoid overlapping with existing ones.
                                enabled = true,
                                excluded_filetypes = { "cmp_menu", "cmp_docs", "notify" },
                        },
                        presets = {
                                -- Allows for enabling, disabling, or configuring presets that modify UI behavior.
                                bottom_search = false,
                                command_palette = false,
                                long_message_to_split = false,
                                inc_rename = false,
                                lsp_doc_border = false,
                        },
                        throttle = 1000 / 30, -- Defines the frequency for UI updates, improving performance.
                        views = {},           -- Configuration for custom views.
                        routes = {},          -- Configuration for routing messages through different views or filters.
                        status = {},          -- Configuration for integrating with the status line.
                        format = {},          -- Configuration for custom formatting of messages and inputs.
                })
        end
}
