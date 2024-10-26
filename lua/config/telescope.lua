-- [[ configure telescope ]]
-- see `:help telescope` and `:help telescope.setup()`

-- set up nvim-nonicons
local icons = require 'nvim-nonicons'

-- import telescope modules
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local sorters = require 'telescope.sorters'

-- Set up Trouble
local open_with_trouble = require('trouble.sources.telescope').open

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require('trouble.sources.telescope').add

-- Useful for easily creating commands
local z_utils = require 'telescope._extensions.zoxide.utils'

require('telescope').setup {
  defaults = {
    prompt_prefix = '  ' .. icons.get 'telescope' .. '  ',
    selection_caret = '❯ ',
    entry_prefix = '   ',
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
        ['<c-n>'] = 'move_selection_next',
        ['<c-p>'] = 'move_selection_previous',
        ['<leftmouse>'] = 'select_default',
        ['<scrollwheelup>'] = 'preview_scrolling_up',
        ['<scrollwheeldown>'] = 'preview_scrolling_down',
        ['<c-s>'] = function(prompt_bufnr)
          require('flash').jump {
            pattern = '^',
            label = { after = { 0, 0 } },
            search = {
              mode = 'search',
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
                end,
              },
            },
            action = function(match)
              local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
              picker:set_selection(match.pos[1] - 1)
            end,
          }
        end,

        -- Open Telescope with Trouble
        ['<c-t>'] = open_with_trouble,
        ['<c-x>'] = add_to_trouble,
      },

      n = {
        ['<c-s>'] = function(prompt_bufnr)
          require('flash').jump {
            pattern = '^',
            label = { after = { 0, 0 } },
            search = {
              mode = 'search',
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
                end,
              },
            },
            action = function(match)
              local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
              picker:set_selection(match.pos[1] - 1)
            end,
          }
        end,

        -- Open Telescope with Trouble
        ['<c-t>'] = open_with_trouble,
        ['<c-x>'] = add_to_trouble,
      },
    },
    previewer = true,
    file_ignore_patterns = {},
    path_display = {},
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    set_env = { ['COLORTERM'] = 'truecolor' },
  },
  pickers = {},
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown {},
    },
    dash = {
      dash_app_path = '/applications/dash.app',
      search_engine = 'google',
      debounce = 20,
      file_type_keywords = {
        dashboard = false,
        telescopeprompt = true,
        terminal = false,
        packer = false,
        fzf = false,
        javascript = { 'javascript', 'nodejs' },
        typescript = { 'typescript', 'javascript', 'nodejs' },
        typescriptreact = { 'typescript', 'javascript', 'react' },
        javascriptreact = { 'javascript', 'react' },
        sh = 'bash',
      },
    },
    zoxide = {
      prompt_title = '[ Zoxide List ]',
      list_command = 'zoxide query -ls',
      mappings = {
        default = {
          action = function(selection)
            vim.cmd.edit(selection.path)
          end,
          after_action = function(selection)
            print('Directory changed to ' .. selection.path)
          end,
        },
        ['<C-s>'] = { action = z_utils.create_basic_command 'split' },
        ['<C-v>'] = { action = z_utils.create_basic_command 'vsplit' },
        ['<C-e>'] = { action = z_utils.create_basic_command 'edit' },
        ['<C-b>'] = {
          keepinsert = true,
          action = function(selection)
            require('telescope.builtin').file_browser { cwd = selection.path }
          end,
        },
        ['<C-f>'] = {
          keepinsert = true,
          action = function(selection)
            require('telescope.builtin').find_files { cwd = selection.path }
          end,
        },
        ['<C-t>'] = {
          action = function(selection)
            vim.cmd.tcd(selection.path)
          end,
        },
      },
    },
    helpgrep = {
      ignore_paths = {
        vim.fn.stdpath 'state' .. '/lazy/readme',
      },
    },
    gpt = {
      title = 'GPT Actions',
      commands = {
        'add_tests',
        'chat',
        'docstring',
        'explain_code',
        'fix_bugs',
        'grammar_correction',
        'interactive',
        'optimize_code',
        'summarize',
        'translate',
        'code_readability_analysis',
      },
      theme = require('telescope.themes').get_dropdown {},
    },
    tldr = {
      tldr_command = 'tldr',
      tldr_args = '--color always',
    },
    ft = 'mason', -- for mason
    lazy = {
      show_icon = true,
      mappings = {
        open_in_browser = '<C-o>',
        open_in_file_browser = '<M-b>',
        open_in_find_files = '<C-f>',
        open_in_live_grep = '<C-g>',
        open_in_terminal = '<C-t>',
        open_plugins_picker = '<C-b>',
        open_lazy_root_find_files = '<C-r>f',
        open_lazy_root_live_grep = '<C-r>g',
        change_cwd_to_plugin = '<C-c>d',
      },
      actions_opts = {
        open_in_browser = {
          auto_close = false,
        },
        change_cwd_to_plugin = {
          auto_close = false,
        },
      },
      terminal_opts = {
        relative = 'editor',
        style = 'minimal',
        border = 'rounded',
        title = 'Telescope lazy',
        title_pos = 'center',
        width = 0.5,
        height = 0.5,
      },
      media_files = {
        -- filetypes whitelist
        -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
        filetypes = { 'png', 'webp', 'jpg', 'jpeg' },
        -- find command (defaults to `fd`)
        find_cmd = 'rg',
      },
    },
  },
}

-- enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.getcwd()
  if current_file ~= '' then
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  local git_root = vim.fn.systemlist('git -c ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a Git Repository. Searching on Current Working Directory'
    return vim.fn.getcwd()
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

-- Load extensions for noice, emoji.nvim, telescope-swap-files, ui-select, themes, fzy native search
require('telescope').load_extension 'noice'
require('telescope').load_extension 'emoji'
require('telescope').load_extension 'uniswapfiles'
require('telescope').load_extension 'ui-select'
require('telescope').load_extension 'themes'
require('telescope').load_extension 'fzy_native'
require('telescope').load_extension 'git_signs'
require('telescope').load_extension 'zoxide'
require('telescope').load_extension 'repo'
require('telescope').load_extension 'helpgrep'
require('telescope').load_extension 'gpt'
require('telescope').load_extension 'lazy'
require('telescope').load_extension 'jsonfly'
require('telescope').load_extension 'media_files'
require('telescope').load_extension 'lazygit'
-- require('telescope').load_extension 'rest'
require('telescope').load_extension 'jumper'
require('telescope').load_extension 'lazygit'

-- Set up help page fuzzy search with a command
vim.api.nvim_create_user_command('FuzzyHelp', function()
  require('telescope.builtin').help_tags {
    prompt_title = 'Search Help',
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = function(_, map)
      map('i', '<cr>', function(bufnr)
        local selection = action_state.get_selected_entry(bufnr)
        actions.close(bufnr)
        vim.cmd('vert bo help ' .. selection.value)
        vim.defer_fn(function()
          require('telescope.builtin').current_buffer_fuzzy_find()
        end, 100)
      end)
      return true
    end,
  }
end, {})

-- Set up man page fuzzy search with a command
vim.api.nvim_create_user_command('FuzzyMan', function()
  require('telescope.builtin').man_pages {
    prompt_title = 'Search Man Pages',
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = function(_, map)
      map('i', '<cr>', function(bufnr)
        local selection = action_state.get_selected_entry(bufnr)
        actions.close(bufnr)
        vim.cmd('vert bo Man ' .. selection.value)
        vim.defer_fn(function()
          require('telescope.builtin').current_buffer_fuzzy_find {
            file_encoding = 'utf-8',
            previewer = false,
          }
        end, 100)
      end)
      return true
    end,
  }
end, {})

-- Set up noice fuzzy search with a command to open new buffer
vim.api.nvim_create_user_command('FuzzyNoice', function()
  require('telescope').extensions.noice.noice {
    prompt_title = 'Search Noice Messages',
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = function(_, map)
      map('i', '<CR>', function(bufnr)
        local selection = action_state.get_selected_entry(bufnr)
        actions.close(bufnr)

        local content_to_yank = ''
        if selection.message and selection.message._lines and #selection.message._lines > 0 then
          local line = selection.message._lines[1]
          if line and line._texts and #line._texts > 0 then
            content_to_yank = line._texts[1]._content or ''
          end
        end

        if content_to_yank ~= '' then
          vim.fn.setreg('+', content_to_yank)
          vim.notify('Yanked to clipboard: ' .. content_to_yank, vim.log.levels.INFO)
        else
          vim.notify('No content found to yank.', vim.log.levels.ERROR)
        end
      end)
      return true
    end,
  }
end, {})

-- Set up fuzzy search with a command for Obsidian Programming Vault
vim.api.nvim_create_user_command('SearchObsidianProgramming', function()
  require('telescope.builtin').find_files {
    prompt_title = 'Search Obsidian Programming Vault',
    cwd = '/Users/joshpeterson/Library/CloudStorage/Dropbox/DropsyncFiles/Obsidian Vault/Programming',
  }
end, {})

-- Set up fuzzy search for messages
vim.api.nvim_create_user_command('TelescopeMessages', function()
  require('telescope.builtin').find_files {
    prompt_title = 'View Messages Log',
    cwd = vim.fn.stdpath 'cache',

    attach_mappings = function(_, map)
      map('i', '<CR>', function(bufnr)
        local selection = require('telescope.actions.state').get_selected_entry(bufnr)
        require('telescope.actions').close(bufnr)
        vim.notify('Selected: ' .. selection.value, vim.log.levels.INFO)
      end)
      return true
    end,
  }
end, {})

local function start_spinner()
  local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  local current_frame = 1
  local spinner_timer = vim.loop.new_timer()

  vim.notify('Starting directory listing...', vim.log.levels.INFO, { title = 'Noice' })

  spinner_timer:start(
    0,
    100,
    vim.schedule_wrap(function()
      if not vim.g.spinner_active then
        spinner_timer:stop()
        spinner_timer:close()
        vim.api.nvim_command "echon ''"
      else
        vim.api.nvim_echo({ { spinner_frames[current_frame], 'None' } }, false, {})
        current_frame = (current_frame % #spinner_frames) + 1
      end
    end)
  )

  vim.g.spinner_active = true
end

local function stop_spinner()
  vim.g.spinner_active = false
  vim.notify('Directory listing complete. Okay to search now.', vim.log.levels.INFO, { title = 'Noice' })
end

local search_log_files

search_log_files = function()
  require('telescope.builtin').find_files {
    prompt_title = 'Search Log Files',
    find_command = {
      'rg',
      '--files',
      '--hidden',
      '--glob',
      '!.git',
      '--glob',
      '!node_modules',
      '--glob',
      '*.log',
      vim.fn.expand '~/Library/Logs',
      '/Library/Logs',
      '/private/var/log',
      '/Library/Logs/DiagnosticReports/',
      vim.fn.expand '~/Library/Logs/DiagnosticReports/',
      '/var/db/diagnostics/',
      '/Library/Application Support/',
      vim.fn.expand '~/Library/Application Support/',
      '/.npm/_logs',
      vim.fn.expand '~/.npm/_logs/',
      '/.cache/',
      vim.fn.expand '~/.cache/',
      '/.local',
      vim.fn.expand '~/.local/',
      '/.config/',
      vim.fn.expand '~/.config/',
      '/.fig/',
      vim.fn.expand '~/.fig/',
      '/npm-debug.log',
      vim.fn.expand '~/npm-debug.log',
      '/.pgadmin/',
      vim.fn.expand '~/.pgadmin/',
      '/.ipfs/',
      vim.fn.expand '~/.ipfs/',
      'tmux.*\\.log',
    },

    attach_mappings = function(_, map)
      map('i', '<CR>', function(bufnr)
        local selection = require('telescope.actions.state').get_selected_entry(bufnr)
        require('telescope.actions').close(bufnr)
        if selection then
          vim.cmd('edit ' .. selection.value)
          require('telescope.builtin').current_buffer_fuzzy_find {
            prompt_title = 'Search in ' .. vim.fn.fnamemodify(selection.value, ':t'),
          }
        end
      end)

      map('i', '<C-b>', function()
        local curr_buf = vim.api.nvim_get_current_buf()
        vim.cmd('bdelete! ' .. curr_buf)
        search_log_files()
      end)

      return true
    end,
  }
end

vim.api.nvim_create_user_command('SearchLogFiles', function()
  start_spinner()
  search_log_files()
  vim.defer_fn(function()
    stop_spinner()
  end, 500)
end, {})

local search_changelog_files

search_changelog_files = function()
  require('telescope.builtin').find_files {
    prompt_title = 'Search Changelog Files',
    find_command = {
      'rg',
      '--files',
      '--hidden',
      '--glob',
      '!.git',
      '--glob',
      '!node_modules',
      '--glob',
      '*Changelog.md',
      '--glob',
      '*CHANGELOG.md',
      vim.fn.expand '~/',
    },
    attach_mappings = function(_, map)
      map('i', '<CR>', function(bufnr)
        local selection = require('telescope.actions.state').get_selected_entry(bufnr)
        require('telescope.actions').close(bufnr)
        if selection then
          vim.cmd('edit ' .. selection.value)
          require('telescope.builtin').current_buffer_fuzzy_find {
            prompt_title = 'Search in ' .. vim.fn.fnamemodify(selection.value, ':t'),
          }
        end
      end)

      map('i', '<C-b>', function()
        local curr_buf = vim.api.nvim_get_current_buf()
        vim.cmd('bdelete! ' .. curr_buf)
        search_changelog_files()
      end)

      return true
    end,
  }
end

vim.api.nvim_create_user_command('SearchChangelogFiles', function()
  start_spinner()
  search_changelog_files()
  vim.defer_fn(function()
    stop_spinner()
  end, 500)
end, {})
