-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`
local icons = require("nvim-nonicons")
require('telescope').setup({
        defaults = {
                prompt_prefix = "  " .. icons.get("telescope") .. "  ",
                selection_caret = " ❯ ",
                entry_prefix = "   ",
                mappings = {
                        i = {
                                ['<c-u>'] = false,
                                ['<c-d>'] = false,
                                -- enable mouse support in telescope window
                                ['<c-n>'] = "move_selection_next",
                                ['<c-p>'] = "move_selection_previous",
                                -- add mouse support for scrolling and selection
                                ["<leftmouse>"] = "select_default",
                                ["<scrollwheelup>"] = "preview_scrolling_up",
                                ["<scrollwheeldown>"] = "preview_scrolling_down",
                        },
                },
        },
        pickers = {
        },
        extensions = {
                dash = {
                        -- configure path to dash.app if installed somewhere other than /applications/dash.app
                        dash_app_path = '/applications/dash.app',
                        -- search engine to fall back to when dash has no results, must be one of: 'ddg', 'duckduckgo', 'startpage', 'google'
                        search_engine = 'google',
                        -- debounce while typing, in milliseconds
                        debounce = 20,
                        -- map filetype strings to the keywords you've configured for docsets in dash
                        -- setting to false will disable filtering by filetype for that filetype
                        -- filetypes not included in this table will not filter the query by filetype
                        -- check src/lua_bindings/dash_config_binding.rs to see all defaults
                        -- the values you pass for file_type_keywords are merged with the defaults
                        -- to disable filtering for all filetypes,
                        -- set file_type_keywords = false
                        file_type_keywords = {
                                dashboard = false,
                                telescopeprompt = true,
                                terminal = false,
                                packer = false,
                                fzf = false,
                                -- a table of strings will search on multiple keywords
                                javascript = { 'javascript', 'nodejs' },
                                typescript = { 'typescript', 'javascript', 'nodejs' },
                                typescriptreact = { 'typescript', 'javascript', 'react' },
                                javascriptreact = { 'javascript', 'react' },
                                -- you can also do a string, for example,
                                sh = 'bash'
                        },
                },
        },
})


-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == "" then
                current_dir = cwd
        else
                -- Extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ":h")
        end

        -- Find the Git root directory from the current file's path
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
            [1]
        if vim.v.shell_error ~= 0 then
                print("Not a git repository. Searching on current working directory")
                return cwd
        end
        return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
                require('telescope.builtin').live_grep({
                        search_dirs = { git_root },
                })
        end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})


-- [[ Configure Harpoon Telescope ]]
local harpoon = require('harpoon')
harpoon:setup({})

-- basic telescope-ui configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                        results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
        }):find()
end

vim.keymap.set("n", "<leader>e", function() toggle_telescope(harpoon:list()) end,
        { desc = "Open harpoon window" })

-- noice
require("telescope").load_extension("noice")

-- emoji.nvim
require("telescope").load_extension("emoji")
