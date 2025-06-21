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
vim.g.db_ui_sqlfluff_path = '/Users/joshpeterson/.pyenv/shims/sqlfluff'
-- vim.opt.cursorline = true
vim.opt.wrap = true

-- Customize the CursorLine highlight group
-- vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#D3D3D3' })

-- Vim-Dadbod config
vim.cmd [[
  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]]

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.db_ui_auto_execute_table_helpers = 1

vim.g.ale_linters = {
  html = { 'htmlhint' },
}

vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.g.tpipeline_restore = 1

-- Fold management

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.foldcolumn = "1"
    vim.opt_local.foldenable = true
    vim.o.foldlevel = 99          -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.opt.foldmethod = "indent" -- or another method like "expr", "marker", etc.
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
  end
})

vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpItemAbbrMatch' })
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })

-- termguicolors
if vim.fn.exists '+termguicolors' == 1 then
  vim.opt.termguicolors = true
end

vim.cmd [[
augroup TransparentFloatingWindows
    autocmd!
    autocmd VimEnter * hi NormalFloat guibg=NONE
    autocmd VimEnter * hi FloatBorder guibg=NONE
augroup END
]]

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "LazyNormal", { link = "Normal" })
    vim.api.nvim_set_hl(0, "LazyButtonActive", { link = "Visual" })
    vim.api.nvim_set_hl(0, "LazyProgressTodo", { link = "Todo" })
  end,
})

-- nvim-lint config
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.lua',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.js', '*.jsx', '.ts', '.tsx' },
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.py',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.html',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.css',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.sql',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.md',
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.sh', '*.zsh' },
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.yaml', '*.yml' },
  callback = function()
    require('lint').try_lint()
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.toml' },
  callback = function()
    require('lint').try_lint()
  end,
})

-- Firenvim config
if vim.g.started_by_firenvim then
  vim.o.guifont = 'FiraCode Nerd Font:h18'
  vim.cmd [[set linespace=0]]
  vim.cmd [[set laststatus=0]]

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'github.com/*',
    callback = function()
      vim.o.lines = 15
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*script.google.com_*.txt',
    callback = function()
      vim.bo.filetype = 'javascript'
      vim.cmd 'syntax enable'
      vim.cmd 'set syntax=javascript'
      vim.b.ale_linters = { 'eslint', 'jshint', 'ts_ls' }
      if vim.bo.filetype == 'javascript' then
        require('lint').try_lint()
      end
    end,
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*leetcode.com_*.txt',
    callback = function()
      local bufname = vim.fn.bufname '%'
      if bufname:match 'leetcode.com_.*%.txt' then
        vim.bo.filetype = 'python'
        vim.cmd 'syntax enable'
        vim.cmd 'set syntax=python'
        if vim.bo.filetype == 'python' then
          vim.fn.setenv('PYTHON_LINT_CONFIG', '~/.config/nvim/lua/linter_configs/.pylintrc_leetcode')
          vim.b.ale_linters = { 'pylint' }
          require('lint').try_lint()
        end
      else
        vim.fn.setenv('PYTHON_LINT_CONFIG', nil)
      end
    end,
  })

  local function set_leetcode_pylint_options()
    local bufname = vim.fn.bufname '%'
    if string.match(bufname, 'leetcode.com_.*%.txt') then
      vim.b.ale_linters = { 'pylint' }
      vim.b.ale_python_pylint_options = '--rcfile=~/.config/nvim/lua/linter_configs/.pylintrc_leetcode'
    else
      vim.b.ale_linters = { 'pylint' }
      vim.b.ale_python_pylint_options = '--rcfile=/.config/nvim/lua/linter_configs/.pylintrc_leetcode'
    end
  end

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*.py',
    callback = set_leetcode_pylint_options,
  })

  vim.g.firenvim_config = {
    globalSettings = { alt = 'all' },
    localSettings = {
      ['.*'] = {
        cmdline = 'neovim',
        content = 'text',
        priority = 0,
        selector = 'textarea',
        takeover = 'always',
      },
      ['https://script.google.com/.*'] = {
        cmdline = 'neovim',
        content = 'text',
        priority = 1,
        selector = 'textarea',
        takeover = 'always',
      },
    },
  }

  vim.fn.mkdir(vim.fn.stdpath 'cache' .. '/firenvim', 'p')
  vim.g.firenvim_logfile = vim.fn.stdpath 'cache' .. '/firenvim/firenvim.log'
end

-- LSP log level is now managed by the logging system

-- Set custom highlights for autocomplete menu after colorscheme is loaded
vim.cmd [[
  augroup CustomColors
    autocmd!
    " Set the background of the popup menu to light grey
    autocmd ColorScheme * highlight Pmenu guibg=#D3D3D3
    " Set the background of the selected item in the popup menu to a slightly darker grey
    autocmd ColorScheme * highlight PmenuSel guibg=#C0C0C0 guifg=NONE
  augroup END
]]

-- Update highlight groups for transparency
vim.cmd [[
  hi Normal guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
  hi Folded guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi SpecialKey guibg=NONE ctermbg=NONE
  hi VertSplit guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
  hi EndOfBuffer guibg=NONE ctermbg=NONE
  hi StatusLine guibg=#2E3440 guifg=#D8DEE9
  hi StatusLineNC guibg=#2E3440 guifg=#D8DEE9
]]

--[[ Functions to configure precognition.nvim to track with horizontal scrolling ]]

-- Function to update virtual text position
local function update_virtual_text(bufnr, ns_id, extmarks)
  for _, extmark in ipairs(extmarks) do
    local id, lnum, col, opts = unpack(extmark)
    -- Calculate new column position based on current window view
    local new_col = col - vim.fn.winsaveview().leftcol
    if new_col >= 0 then
      -- Update virtual text position
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum, new_col, opts)
    end
  end
end

-- Function to track horizontal scrolling
local function track_horizontal_scroll()
  local bufnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace 'precognition'
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, ns_id, 0, -1, { details = true })

  -- Update virtual text on BufWinEnter and WinScrolled events
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinScrolled' }, {
    callback = function()
      update_virtual_text(bufnr, ns_id, extmarks)
    end,
  })
end

-- Call the function to start tracking
track_horizontal_scroll()

-- Set http filetype
vim.filetype.add({
  extension = {
    ['http'] = 'http',
  },
})

-- Set Comment color
vim.cmd [[highlight Comment guifg=#808080 ctermfg=244]]

-- Enable highlights
vim.cmd([[
  augroup TreesitterHighlight
    autocmd!
    autocmd VimEnter * TSEnable highlight
  augroup END
]])

-- Set .zsh to bash filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.zsh",
  command = "set filetype=sh"
})

-- Set JSON filetype format with error handling
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.json",
  callback = function()
    -- Save current cursor position
    local cursor_pos = vim.fn.getcurpos()
    
    -- Get current buffer content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, "\n")
    
    -- Only proceed if content is not empty
    if content:match("^%s*$") then
      return
    end
    
    -- Test if jq can parse the content
    local handle = io.popen("echo '" .. content:gsub("'", "'\"'\"'") .. "' | jq . 2>/dev/null")
    local result = handle:read("*a")
    local exit_code = handle:close()
    
    -- Only format if jq succeeded
    if exit_code then
      vim.cmd("%!jq .")
      -- Restore cursor position
      vim.fn.setpos('.', cursor_pos)
    else
      -- Show warning but don't break the file
      vim.notify("JSON formatting skipped: Invalid JSON syntax", vim.log.levels.WARN)
    end
  end
})
