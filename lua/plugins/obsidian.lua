-- obsidian.lua configuration for obsidian.nvim plugin in Neovim
-- This script sets up Obsidian vaults management within Neovim, enhancing markdown editing and note navigation.

return {
        -- obsidian.nvim
        {
                "epwalsh/obsidian.nvim",                   -- Plugin path on GitHub
                version = "*",                             -- Use the latest release version
                lazy = true,                               -- Lazy loading to improve startup time
                ft = "markdown",                           -- Activate the plugin for markdown files
                dependencies = {
                        "nvim-lua/plenary.nvim",           -- Required utility library
                        'hrsh7th/nvim-cmp',                -- Autocompletion plugin
                        'nvim-telescope/telescope.nvim',   -- Fuzzy finder plugin for searching and navigating
                        'nvim-treesitter/nvim-treesitter', -- Syntax highlighting based on tree-sitter
                        'epwalsh/pomo.nvim',               -- Pomodoro timer
                        'edkolev/tmuxline.vim',            -- tmuxline status line for blending of Neovim and tmux statuslines
                },
                config = function()                        -- Configuration function for the plugin
                        require('obsidian').setup({
                                -- Workspaces: Each workspace corresponds to an Obsidian vault
                                workspaces = {
                                        { name = "Programming", path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Programming" },
                                        { name = "Blogging",    path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Blogging" },
                                        { name = "Crypto",      path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Crypto" },
                                        { name = "Journals",    path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Journals" },
                                        { name = "Poetry",      path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Poetry" },
                                        { name = "Udemy",       path = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Udemy" },
                                },

                                -- Log level for debugging purposes
                                log_level = vim.log.levels.INFO,

                                -- Autocompletion setup for links, tags, and note references
                                completion = {
                                        nvim_cmp = true, -- Enable integration with nvim-cmp for autocompletion
                                        min_chars = 2,   -- Minimum characters to trigger autocompletion
                                        wiki_link_func = function(opts)
                                                if opts.id == nil then
                                                        return string.format("[[%s]]", opts.label)
                                                elseif opts.label ~= opts.id then
                                                        return string.format("[[%s|%s]]", opts.id, opts.label)
                                                else
                                                        return string.format("[[%s]]", opts.id)
                                                end
                                        end,
                                },


                                -- Default location for creating new notes
                                new_notes_location = "current_dir",
                                -- Use wikilinks style for note linking
                                preferred_link_style = "wikilinks",

                                -- Optional, customize how names/IDs for new notes are created.
                                note_id_func = function(title)
                                        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                                        -- In this case a note with the title 'My new note' will be given an ID that looks
                                        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                                        local suffix = ""
                                        if title ~= nil then
                                                -- If title is given, transform it into valid file name.
                                                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                                        else
                                                -- If title is nil, just add 4 random uppercase letters to the suffix.
                                                for _ = 1, 4 do
                                                        suffix = suffix .. string.char(math.random(65, 90))
                                                end
                                        end
                                        return tostring(os.time()) .. "-" .. suffix
                                end,

                                -- Function for naming images when pasted into notes
                                image_name_func = function()
                                        return string.format("%s-", os.time()) -- Use a timestamp prefix for uniqueness
                                end,

                                -- Configuration for managing markdown frontmatter
                                disable_frontmatter = false, -- Enable frontmatter management by default

                                -- Custom function to open external URLs
                                follow_url_func = function(url)
                                        vim.fn.jobstart({ "open", url }) -- Use "open" command on macOS to open URLs
                                end,

                                -- Finder configuration: Use Telescope by default for searching and navigating notes
                                finder = "telescope.nvim",

                                -- Finder key mappings: Define custom actions within the finder
                                finder_mappings = {
                                        new = "<C-x>", -- Shortcut to create a new note from the search query
                                },

                                -- Sorting preferences for search results
                                sort_by = "modified", -- Sort notes by modification time
                                sort_reversed = true, -- Show the most recently modified notes first

                                -- Configuration for additional UI features and syntax highlighting
                                ui = {
                                        enable = true,
                                        update_debounce = 200,
                                        checkboxes = {
                                                [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                                                ["x"] = { char = "", hl_group = "ObsidianDone" },
                                                [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                                                ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                                        },
                                        bullets = { char = "•", hl_group = "ObsidianBullet" },
                                        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                                        reference_text = { hl_group = "ObsidianRefText" },
                                        highlight_text = { hl_group = "ObsidianHighlightText" },
                                        tags = { hl_group = "ObsidianTag" },
                                        hl_groups = {
                                                ObsidianTodo = { bold = true, fg = "#f78c6c" },
                                                ObsidianDone = { bold = true, fg = "#89ddff" },
                                                ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                                                ObsidianTilde = { bold = true, fg = "#ff5370" },
                                                ObsidianBullet = { bold = true, fg = "#89ddff" },
                                                ObsidianRefText = { underline = true, fg = "#c792ea" },
                                                ObsidianExtLinkIcon = { fg = "#c792ea" },
                                                ObsidianTag = { italic = true, fg = "#89ddff" },
                                                ObsidianHighlightText = { bg = "#75662e" },
                                        },
                                },

                                -- Configuration for handling attachments
                                attachments = {
                                        img_folder = "images", -- Default folder for pasted images
                                },

                                -- YAML parser option: Use the native Lua parser for frontmatter
                                yaml_parser = "native",
                        })
                end,
        },

        -- obsidian-bridge.nvim: sync obsidian w/neovim
        {
                "oflisback/obsidian-bridge.nvim",
                dependencies = {
                        "nvim-telescope/telescope.nvim",
                        "nvim-lua/plenary.nvim",

                },
                config = function()
                        require("obsidian-bridge").setup({
                                scroll_sync = false -- See "Sync of buffer scrolling" section below
                        })
                end,
                event = {
                        "BufReadPre *.md",
                        "BufNewFile *.md",
                },
                lazy = true,
        },
}
