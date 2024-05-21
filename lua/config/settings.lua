-- settings.lua
-- Basic Neovim settings

-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.opt.conceallevel = 1
vim.opt.guifont = 'FiraCode:h18'
-- Ensure sqlfluff is in your PATH
vim.g.db_ui_sqlfluff_path = '/Users/joshpeterson/.pyenv/shims/sqlfluff'

-- Ensure that the source is enabled for SQL filetypes
vim.cmd [[
  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]]

-- Suppress provider warnings in checkhealth
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Optional: Configure vim-dadbod
vim.g.db_ui_auto_execute_table_helpers = 1

-- linter setup
vim.g.ale_linters = {
    html = { 'htmlhint' },
}

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Restore tmux statusline when Neovim closes
vim.g.tpipeline_restore = 1

-- nvim-cmp color config
-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

-- After writing the whole buffer to a file
vim.api.nvim_create_autocmd({ "bufwritepost" }, {
    pattern = { "*.lua" },
    callback = function()
        require('lint').try_lint()
    end,
})

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Set color consistency w/Tmux
if vim.fn.exists('+termguicolors') == 1 then
    vim.api.nvim_set_option('t_8f', '\\<Esc>[38;2;%lu;%lu;%lum')
    vim.api.nvim_set_option('t_8b', '\\<Esc>[48;2;%lu;%lu;%lum')
    vim.opt.termguicolors = true
end

-- Set which-key backgrounds to transparent
vim.cmd [[
augroup TransparentWhichKeyWindows
    autocmd!
    autocmd VimEnter * hi WhichKeyFloat guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKey guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyGroup guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyDesc guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeySeperator guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyBorder guibg=#87CEEB ctermbg=NONE
augroup END
]]

-- set legendary's floating window transparent
vim.cmd([[
augroup TransparentFloatingWindows
    autocmd!
    autocmd VimEnter * hi NormalFloat guibg=NONE
    autocmd VimEnter * hi FloatBorder guibg=NONE
augroup END
]])


-- Add LSP debugging
vim.lsp.set_log_level("debug") -- settings.lua
-- Basic Neovim settings

-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.linebreak = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, 'Comment', { italic = true })
vim.opt.conceallevel = 1

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Restore tmux statusline when Neovim closes
vim.g.tpipeline_restore = 1

-- nvim-cmp color config
-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

-- After writing the whole buffer to a file
vim.api.nvim_create_autocmd({ "bufwritepost" }, {
    pattern = { "*.lua" },
    callback = function()
        require('lint').try_lint()
    end,
})

-- [[ highlight on yank ]]
-- see `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('yankhighlight', { clear = true })
vim.api.nvim_create_autocmd('textyankpost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Set color consistency w/Tmux
if vim.fn.exists('+termguicolors') == 1 then
    vim.api.nvim_set_option('t_8f', '\\<Esc>[38;2;%lu;%lu;%lum')
    vim.api.nvim_set_option('t_8b', '\\<Esc>[48;2;%lu;%lu;%lum')
    vim.opt.termguicolors = true
end

-- Set which-key backgrounds to transparent
vim.cmd [[
augroup TransparentWhichKeyWindows
    autocmd!
    autocmd VimEnter * hi WhichKeyFloat guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKey guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyGroup guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyDesc guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeySeperator guibg=NONE ctermbg=NONE
    autocmd VimEnter * hi WhichKeyBorder guibg=#87CEEB ctermbg=NONE
augroup END
]]

-- set legendary's floating window transparent
vim.cmd([[
augroup TransparentFloatingWindows
    autocmd!
    autocmd VimEnter * hi NormalFloat guibg=NONE
    autocmd VimEnter * hi FloatBorder guibg=NONE
augroup END
]])

-- Firenvim config
-- Check if Neovim is started by Firenvim
if vim.g.started_by_firenvim then
    -- Specific settings for GitHub
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "github.com/*",
        callback = function()
            vim.o.lines = 15 -- Set window height to prevent 'custom_entries_view' error
        end,
    })

    -- Specific settings for Google Apps Script
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*script.google.com_*.txt",
        callback = function()
            vim.bo.filetype = "javascript"
            vim.cmd("syntax enable")
            vim.cmd("set syntax=javascript")
            -- Setting ALE linters specifically for this filetype
            vim.b.ale_linters = { 'eslint', 'jshint', 'tsserver' } -- Example: add your preferred linters here
            if vim.bo.filetype == 'javascript' then
                require('lint').try_lint()
            end
        end,
    })

    -- LeetCode
    -- Combine all LeetCode specific settings into one coherent block
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*leetcode.com_*.txt", -- This pattern targets files from LeetCode
        callback = function()
            local bufname = vim.fn.bufname('%')

            -- Debug: Print current buffer name
            print("Current buffer name: " .. bufname)

            -- Apply settings if the buffer is a Python file from LeetCode
            if bufname:match('leetcode.com_.*%.txt') then
                print("LeetCode settings applied")

                -- Set the filetype and syntax for Python
                vim.bo.filetype = "python"
                vim.cmd("syntax enable")
                vim.cmd("set syntax=python")

                -- Ensure we're only using Pylint for Python files
                if vim.bo.filetype == 'python' then
                    -- Set the Pylint configuration specific to LeetCode
                    vim.fn.setenv('PYTHON_LINT_CONFIG', '~/.config/nvim/lua/linter_configs/.pylintrc_leetcode')

                    -- Use only pylint for linting on LeetCode
                    vim.b.ale_linters = { 'pylint' }

                    -- Trigger linting with nvim-lint if required
                    require('lint').try_lint()
                end
            else
                -- Reset the environment variable when not editing a LeetCode Python file
                vim.fn.setenv('PYTHON_LINT_CONFIG', nil)
            end
        end,
    })

    -- Set pylint as linter for LeetCode
    -- Function to set ALE linter options based on the file pattern
    local function set_leetcode_pylint_options()
        local bufname = vim.fn.bufname('%')

        -- Match the filename pattern for LeetCode
        if string.match(bufname, 'leetcode.com_.*%.txt') then
            -- Set specific pylint options for LeetCode
            vim.b.ale_linters = { 'pylint' }
            vim.b.ale_python_pylint_options = '--rcfile=~/.config/nvim/lua/linter_configs/.pylintrc_leetcode'
        else
            -- Set default pylint options
            vim.b.ale_linters = { 'pylint' }
            vim.b.ale_python_pylint_options = '--rcfile=/path/to/your/.pylintrc_leetcode'
        end
    end

    -- Auto-command to apply the linter settings based on the file name
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.py",
        callback = set_leetcode_pylint_options,
    })

    -- Global and specific settings for Firenvim
    vim.g.firenvim_config = {
        globalSettings = { alt = "all" },
        localSettings = {
            [".*"] = {
                cmdline = "neovim",
                content = "text",
                priority = 0,
                selector = "textarea",
                takeover = "always",
            },
            ['https://script.google.com/.*'] = {
                cmdline = "neovim",
                content = "text", -- Ensure it's text to handle as plain text
                priority = 1,     -- Higher priority to override the default settings
                selector = "textarea",
                takeover = "always",
            }
        }
    }
end

-- Add LSP debugging
vim.lsp.set_log_level("debug")
