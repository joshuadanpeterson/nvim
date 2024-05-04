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

-- Firenvim autocmd to set filetype based on URL
-- set firenvim window height to kill 'custom_entries_view' error on GitHub.com
if vim.g.started_by_firenvim then
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "github.com/*", -- Match GitHub URLs
        callback = function()
            vim.o.lines = 15
        end,
    })
end

-- Firenvim in Google Apps Script
-- Set linter for Apps Script
if vim.g.started_by_firenvim then
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*script.google.com_*.txt", -- This pattern will match the buffer name
        callback = function()
            vim.bo.filetype = "javascript"
            vim.cmd("syntax enable")         -- Ensure syntax is enabled for this buffer
            vim.cmd("set syntax=javascript") -- Force JavaScript syntax rules
            if vim.bo.filetype == 'javascript' then
                require('lint').try_lint()   -- Trigger linting
            end
        end,
    })
end

-- Firenvim settings
vim.g.firenvim_config = {
    globalSettings = { alt = "all" },
    localSettings = {
        [".*"] = {
            cmdline  = "neovim",
            content  = "text",
            priority = 0,
            selector = "textarea",
            takeover = "always",
        },
        -- Specific settings for Google Apps Script
        ['https://script.google.com/.*'] = {
            cmdline  = "neovim",
            content  = "text", -- Ensure it's text to handle as plain text
            priority = 1,      -- Higher priority to override the default settings
            selector = "textarea",
            takeover = "always",
        }
    }
}

-- Add LSP debugging
vim.lsp.set_log_level("debug")
