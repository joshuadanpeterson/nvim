-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`

-- set up nvim-nonicons
local icons = require("nvim-nonicons")

-- import telescope modules
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local sorters = require('telescope.sorters')

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
                previewer = true,
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

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- telescope live_grep in git root
-- function to find the git root directory based on the current buffer's path
local function find_git_root()
        -- use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- if the buffer is not associated with a file, return nil
        if current_file == "" then
                current_dir = cwd
        else
                -- extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ":h")
        end

        -- find the git root directory from the current file's path
        local git_root = vim.fn.systemlist("git -c " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
            [1]
        if vim.v.shell_error ~= 0 then
                print("not a git repository. searching on current working directory")
                return cwd
        end
        return git_root
end

-- custom live_grep function to search in git root
local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
                require('telescope.builtin').live_grep({
                        search_dirs = { git_root },
                })
        end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})


-- [[ configure harpoon telescope ]]
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
                prompt_title = "harpoon",
                finder = require("telescope.finders").new_table({
                        results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
        }):find()
end

vim.keymap.set("n", "<leader>he", function() toggle_telescope(harpoon:list()) end,
        { desc = "Open Harpoon Window" })

-- load extensions for noice, emoji.nvim, telescope-swap-files, ui-select, themes, fzy native search
require("telescope").load_extension("noice")
require("telescope").load_extension("emoji")
require('telescope').load_extension('uniswapfiles')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('themes')
require('telescope').load_extension('fzy_native')
require("telescope").load_extension("git_signs")

-- extend telescope mappings with flash integration
require('telescope').setup({
        defaults = {
                mappings = {
                        n = {
                                ["<c-s>"] = function(prompt_bufnr)
                                        require("flash").jump({
                                                pattern = "^",
                                                label = { after = { 0, 0 } },
                                                search = {
                                                        mode = "search",
                                                        exclude = {
                                                                function(win)
                                                                        return vim.bo[vim.api.nvim_win_get_buf(win)]
                                                                            .filetype ~= "TelescopeResults"
                                                                end,
                                                        },
                                                },
                                                action = function(match)
                                                        local picker = require("telescope.actions.state")
                                                            .get_current_picker(prompt_bufnr)
                                                        picker:set_selection(match.pos[1] - 1)
                                                end,
                                        })
                                end,
                        },
                        i = {
                                -- Assuming you want these mappings to work in insert mode
                                ["<c-s>"] = function(prompt_bufnr)
                                        require("flash").jump({
                                                pattern = "^",
                                                label = { after = { 0, 0 } },
                                                search = {
                                                        mode = "search",
                                                        exclude = {
                                                                function(win)
                                                                        return vim.bo[vim.api.nvim_win_get_buf(win)]
                                                                            .filetype ~= "TelescopeResults"
                                                                end,
                                                        },
                                                },
                                                action = function(match)
                                                        local picker = require("telescope.actions.state")
                                                            .get_current_picker(prompt_bufnr)
                                                        picker:set_selection(match.pos[1] - 1)
                                                end,
                                        })
                                end,
                        },
                },
        },
})

-- set up help page fuzzy search with a command
vim.api.nvim_create_user_command('FuzzyHelp', function()
        require('telescope.builtin').help_tags({
                prompt_title = 'Search Help',
                sorter = sorters.get_fzy_sorter(),
                attach_mappings = function(_, map)
                        map('i', '<cr>', function(bufnr)
                                local selection = action_state.get_selected_entry(bufnr)
                                actions.close(bufnr)
                                vim.cmd('vert bo help ' .. selection.value)
                                vim.defer_fn(function()
                                        require('telescope.builtin')
                                            .current_buffer_fuzzy_find()
                                end, 100)
                        end)
                        return true
                end
        })
end, {})

-- set up man page fuzzy search with a command
vim.api.nvim_create_user_command('FuzzyMan', function()
        require('telescope.builtin').man_pages({
                prompt_title = 'Search Man Pages',
                sorter = sorters.get_fzy_sorter(),
                attach_mappings = function(_, map)
                        map('i', '<cr>', function(bufnr)
                                local selection = action_state.get_selected_entry(bufnr)
                                actions.close(bufnr)
                                vim.cmd('vert bo Man ' .. selection.value)
                                vim.defer_fn(function()
                                        require('telescope.builtin')
                                            .current_buffer_fuzzy_find({
                                                    file_encoding = "utf-8",
                                                    previewer = false,
                                            })
                                end, 100)
                        end)
                        return true
                end
        })
end, {})

-- set up noice fuzzy search with a command to open new buffer
vim.api.nvim_create_user_command('FuzzyNoice', function()
        require('telescope').extensions.noice.noice({
                prompt_title = 'Search Noice Messages',
                sorter = sorters.get_fzy_sorter(),
                attach_mappings = function(_, map)
                        map('i', '<CR>', function(bufnr)
                                local selection = action_state.get_selected_entry(bufnr)
                                actions.close(bufnr)

                                -- Attempt to extract the content from the complex structure
                                local content_to_yank = ""
                                if selection.message and selection.message._lines and #selection.message._lines > 0 then
                                        local line = selection.message._lines[1]
                                        if line and line._texts and #line._texts > 0 then
                                                content_to_yank = line._texts[1]._content or ""
                                        end
                                end

                                -- Yank the extracted content to the "+" register (system clipboard)
                                if content_to_yank ~= "" then
                                        vim.fn.setreg('+', content_to_yank)
                                        vim.notify("Yanked to clipboard: " .. content_to_yank, vim.log.levels.INFO)
                                else
                                        vim.notify("No content found to yank.", vim.log.levels.ERROR)
                                end
                        end)
                        return true
                end
        })
end, {})

-- set up fuzzy search with a command for Obsidian Programming Vault
vim.api.nvim_create_user_command('SearchObsidianProgramming', function()
        require('telescope.builtin').find_files({
                prompt_title = "Search Obsidian Programming Vault",
                cwd = "/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Programming",
                -- other options
        })
end, {})

-- set up fuzzy search for messages
vim.api.nvim_create_user_command('TelescopeMessages', function()
        require('telescope.builtin').find_files({
                prompt_title = "View Messages Log",
                cwd = vim.fn.stdpath('cache'), -- Assuming you are logging messages to a file in the cache directory.

                attach_mappings = function(_, map)
                        map('i', '<CR>', function(bufnr)
                                local selection = require('telescope.actions.state').get_selected_entry(bufnr)
                                require('telescope.actions').close(bufnr)
                                -- Here you could yank the content, open it, or do any other processing.
                                vim.notify("Selected: " .. selection.value, vim.log.levels.INFO)
                        end)
                        return true
                end
        })
end, {})

-- set up fuzzy search for log files
-- create spinner for directory search
-- local function start_spinner()
--         local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--         local current_frame = 1
--         local spinner_timer = vim.loop.new_timer()

--         vim.notify("Starting log directory listing...", vim.log.levels.INFO, { title = "Noice" })

--         -- Start the spinner
--         spinner_timer:start(0, 100, vim.schedule_wrap(function()
--                 if not vim.g.spinner_active then
--                         spinner_timer:stop()             -- Stop the spinner if global flag is cleared
--                         spinner_timer:close()
--                         vim.api.nvim_command("echon ''") -- Clear any remaining spinner character
--                         vim.notify("Log directory listing complete.", vim.log.levels.INFO, { title = "Noice" })
--                 else
--                         vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
--                         current_frame = (current_frame % #spinner_frames) + 1
--                 end
--         end))

--         vim.g.spinner_active = true
-- end

-- local function stop_spinner()
--         vim.g.spinner_active = false -- This will stop the spinner
-- end

-- -- Function to search for and save directories containing .log files
-- local function save_log_directories()
--         start_spinner() -- Start the spinner before the job starts
--         local cmd =
--         "find ~ -type f -name '*.log' 2>&1 | grep -v 'Operation not permitted' | sort -u > ~/.cache/nvim/log_directories.txt"

--         vim.fn.jobstart(cmd, {
--                 on_exit = function(j, exit_code)
--                         stop_spinner() -- Stop the spinner when the job is done
--                         if exit_code == 0 then
--                                 vim.notify("Log directory listing complete. You can now use 'SearchLogFiles'.",
--                                         vim.log.levels.INFO, { title = "Noice" })
--                         else
--                                 vim.notify("Error during log directory listing. Exit code: " .. exit_code,
--                                         vim.log.levels.ERROR, { title = "Noice" })
--                         end
--                 end,
--         })
-- end

-- -- save_log_directories()

-- -- Function to check log directory status
-- local function check_log_directory_status()
--         local filepath = vim.fn.expand("~/.cache/nvim/log_directories.txt")
--         if vim.fn.filereadable(filepath) == 1 then
--                 local last_modified = os.date("%c", vim.fn.getftime(filepath))
--                 vim.notify("Log directory listing file exists. Last updated: " .. last_modified, vim.log.levels.INFO,
--                         { title = "Noice" })
--         else
--                 vim.notify("Log directory listing file does not exist.", vim.log.levels.WARN, { title = "Noice" })
--         end
-- end

-- -- Create the user commands
-- vim.api.nvim_create_user_command('SaveLogDirectories', save_log_directories, {})
-- vim.api.nvim_create_user_command('CheckLogDirectoryStatus', check_log_directory_status, {})

-- Function to start the spinner
-- create spinner for directory search
-- local function start_spinner()
--         local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--         local current_frame = 1
--         local spinner_timer = vim.loop.new_timer()

--         vim.notify("Starting log directory listing...", vim.log.levels.INFO, { title = "Noice" })

--         -- Start the spinner
--         spinner_timer:start(0, 100, vim.schedule_wrap(function()
--                 if not vim.g.spinner_active then
--                         spinner_timer:stop()             -- Stop the spinner if global flag is cleared
--                         spinner_timer:close()
--                         vim.api.nvim_command("echon ''") -- Clear any remaining spinner character
--                         vim.notify("Log directory listing complete.", vim.log.levels.INFO, { title = "Noice" })
--                 else
--                         vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
--                         current_frame = (current_frame % #spinner_frames) + 1
--                 end
--         end))

--         vim.g.spinner_active = true
-- end

-- local function stop_spinner()
--         vim.g.spinner_active = false -- This will stop the spinner
-- end

-- -- Function to search for and save directories containing .log files
-- local function save_log_directories()
--         start_spinner() -- Start the spinner before the job starts
--         local cmd =
--         "find ~ -type f -name '*.log' 2>&1 | grep -v 'Operation not permitted' | sort -u > ~/.cache/nvim/log_directories.txt"

--         vim.fn.jobstart(cmd, {
--                 on_exit = function(j, exit_code)
--                         stop_spinner() -- Stop the spinner when the job is done
--                         if exit_code == 0 then
--                                 vim.notify("Log directory listing complete. You can now use 'SearchLogFiles'.",
--                                         vim.log.levels.INFO, { title = "Noice" })
--                         else
--                                 vim.notify("Error during log directory listing. Exit code: " .. exit_code,
--                                         vim.log.levels.ERROR, { title = "Noice" })
--                         end
--                 end,
--         })
-- end

-- -- save_log_directories()

-- -- Function to check log directory status
-- local function check_log_directory_status()
--         local filepath = vim.fn.expand("~/.cache/nvim/log_directories.txt")
--         if vim.fn.filereadable(filepath) == 1 then
--                 local last_modified = os.date("%c", vim.fn.getftime(filepath))
--                 vim.notify("Log directory listing file exists. Last updated: " .. last_modified, vim.log.levels.INFO,
--                         { title = "Noice" })
--         else
--                 vim.notify("Log directory listing file does not exist.", vim.log.levels.WARN, { title = "Noice" })
--         end
-- end

-- -- Create the user commands
-- vim.api.nvim_create_user_command('SaveLogDirectories', save_log_directories, {})
-- vim.api.nvim_create_user_command('CheckLogDirectoryStatus', check_log_directory_status, {})

-- Function to start the spinner
-- create spinner for directory search
-- local function start_spinner()
--         local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--         local current_frame = 1
--         local spinner_timer = vim.loop.new_timer()

--         vim.notify("Starting log directory listing...", vim.log.levels.INFO, { title = "Noice" })

--         -- Start the spinner
--         spinner_timer:start(0, 100, vim.schedule_wrap(function()
--                 if not vim.g.spinner_active then
--                         spinner_timer:stop()             -- Stop the spinner if global flag is cleared
--                         spinner_timer:close()
--                         vim.api.nvim_command("echon ''") -- Clear any remaining spinner character
--                         vim.notify("Log directory listing complete.", vim.log.levels.INFO, { title = "Noice" })
--                 else
--                         vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
--                         current_frame = (current_frame % #spinner_frames) + 1
--                 end
--         end))

--         vim.g.spinner_active = true
-- end

-- local function stop_spinner()
--         vim.g.spinner_active = false -- This will stop the spinner
-- end

-- -- Function to search for and save directories containing .log files
-- local function save_log_directories()
--         start_spinner() -- Start the spinner before the job starts
--         local cmd =
--         "find ~ -type f -name '*.log' 2>&1 | grep -v 'Operation not permitted' | sort -u > ~/.cache/nvim/log_directories.txt"

--         vim.fn.jobstart(cmd, {
--                 on_exit = function(j, exit_code)
--                         stop_spinner() -- Stop the spinner when the job is done
--                         if exit_code == 0 then
--                                 vim.notify("Log directory listing complete. You can now use 'SearchLogFiles'.",
--                                         vim.log.levels.INFO, { title = "Noice" })
--                         else
--                                 vim.notify("Error during log directory listing. Exit code: " .. exit_code,
--                                         vim.log.levels.ERROR, { title = "Noice" })
--                         end
--                 end,
--         })
-- end

-- -- save_log_directories()

-- -- Function to check log directory status
-- local function check_log_directory_status()
--         local filepath = vim.fn.expand("~/.cache/nvim/log_directories.txt")
--         if vim.fn.filereadable(filepath) == 1 then
--                 local last_modified = os.date("%c", vim.fn.getftime(filepath))
--                 vim.notify("Log directory listing file exists. Last updated: " .. last_modified, vim.log.levels.INFO,
--                         { title = "Noice" })
--         else
--                 vim.notify("Log directory listing file does not exist.", vim.log.levels.WARN, { title = "Noice" })
--         end
-- end

-- -- Create the user commands
-- vim.api.nvim_create_user_command('SaveLogDirectories', save_log_directories, {})
-- vim.api.nvim_create_user_command('CheckLogDirectoryStatus', check_log_directory_status, {})

-- Function to start the spinner
-- create spinner for directory search
-- local function start_spinner()
--         local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
--         local current_frame = 1
--         local spinner_timer = vim.loop.new_timer()

--         vim.notify("Starting log directory listing...", vim.log.levels.INFO, { title = "Noice" })

--         -- Start the spinner
--         spinner_timer:start(0, 100, vim.schedule_wrap(function()
--                 if not vim.g.spinner_active then
--                         spinner_timer:stop()             -- Stop the spinner if global flag is cleared
--                         spinner_timer:close()
--                         vim.api.nvim_command("echon ''") -- Clear any remaining spinner character
--                         vim.notify("Log directory listing complete.", vim.log.levels.INFO, { title = "Noice" })
--                 else
--                         vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
--                         current_frame = (current_frame % #spinner_frames) + 1
--                 end
--         end))

--         vim.g.spinner_active = true
-- end

-- local function stop_spinner()
--         vim.g.spinner_active = false -- This will stop the spinner
-- end

-- -- Function to search for and save directories containing .log files
-- local function save_log_directories()
--         start_spinner() -- Start the spinner before the job starts
--         local cmd =
--         "find ~ -type f -name '*.log' 2>&1 | grep -v 'Operation not permitted' | sort -u > ~/.cache/nvim/log_directories.txt"

--         vim.fn.jobstart(cmd, {
--                 on_exit = function(j, exit_code)
--                         stop_spinner() -- Stop the spinner when the job is done
--                         if exit_code == 0 then
--                                 vim.notify("Log directory listing complete. You can now use 'SearchLogFiles'.",
--                                         vim.log.levels.INFO, { title = "Noice" })
--                         else
--                                 vim.notify("Error during log directory listing. Exit code: " .. exit_code,
--                                         vim.log.levels.ERROR, { title = "Noice" })
--                         end
--                 end,
--         })
-- end

-- -- save_log_directories()

-- -- Function to check log directory status
-- local function check_log_directory_status()
--         local filepath = vim.fn.expand("~/.cache/nvim/log_directories.txt")
--         if vim.fn.filereadable(filepath) == 1 then
--                 local last_modified = os.date("%c", vim.fn.getftime(filepath))
--                 vim.notify("Log directory listing file exists. Last updated: " .. last_modified, vim.log.levels.INFO,
--                         { title = "Noice" })
--         else
--                 vim.notify("Log directory listing file does not exist.", vim.log.levels.WARN, { title = "Noice" })
--         end
-- end

-- -- Create the user commands
-- vim.api.nvim_create_user_command('SaveLogDirectories', save_log_directories, {})
-- vim.api.nvim_create_user_command('CheckLogDirectoryStatus', check_log_directory_status, {})

-- Function to start the spinner
local function start_spinner()
        local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local current_frame = 1
        local spinner_timer = vim.loop.new_timer()

        vim.notify("Starting log directory listing...", vim.log.levels.INFO, { title = "Noice" })

        -- Start the spinner
        spinner_timer:start(0, 100, vim.schedule_wrap(function()
                if not vim.g.spinner_active then
                        spinner_timer:stop()             -- Stop the spinner if global flag is cleared
                        spinner_timer:close()
                        vim.api.nvim_command("echon ''") -- Clear any remaining spinner character
                else
                        vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
                        current_frame = (current_frame % #spinner_frames) + 1
                end
        end))

        vim.g.spinner_active = true
end

-- Function to stop the spinner and notify that it's okay to search
local function stop_spinner()
        vim.g.spinner_active = false -- This will stop the spinner
        vim.notify("Log directory listing complete. Okay to search now.", vim.log.levels.INFO, { title = "Noice" })
end

-- Telescope finder for log files
local search_log_files

search_log_files = function()
        require('telescope.builtin').find_files({
                prompt_title = "Search Log Files",
                find_command = {
                        'rg', '--files', '--hidden', '--glob', '!.git', '--glob', '!node_modules',
                        '--glob', '*.log',
                        vim.fn.expand("~/Library/Logs"),
                        '/Library/Logs',
                        '/private/var/log',
                        '/Library/Logs/DiagnosticReports/',
                        vim.fn.expand("~/Library/Logs/DiagnosticReports/"),
                        '/var/db/diagnostics/',
                        '/Library/Application Support/',
                        vim.fn.expand("~/Library/Application Support/")
                },

                attach_mappings = function(_, map)
                        map('i', '<CR>', function(bufnr)
                                local selection = require('telescope.actions.state').get_selected_entry(bufnr)
                                require('telescope.actions').close(bufnr)
                                if selection then
                                        vim.cmd('edit ' .. selection.value)
                                        -- Open grep in the current buffer immediately after opening the file
                                        require('telescope.builtin').current_buffer_fuzzy_find({
                                                prompt_title = 'Search in ' .. vim.fn.fnamemodify(selection.value, ":t"),
                                        })
                                end
                        end)

                        -- Map a key to go back to the previous Telescope search
                        map('i', '<C-b>', function()
                                local curr_buf = vim.api.nvim_get_current_buf()
                                vim.cmd('bdelete! ' .. curr_buf)
                                search_log_files() -- Reopen Telescope finder
                        end)


                        return true
                end
        })
end

-- Command to initialize a Telescope finder for log files
vim.api.nvim_create_user_command('SearchLogFiles', function()
        start_spinner()                                  -- Start the spinner before initiating the search
        search_log_files()
        vim.defer_fn(function() stop_spinner() end, 500) -- Assume the search completes within this time; adjust as needed
end, {})
