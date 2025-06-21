-- logging-utils.lua
-- User commands and utilities for the logging system

local logging = require('config.logging')

-- Create user commands for logging management
vim.api.nvim_create_user_command('LogOpen', function(opts)
  local log_type = opts.args or 'main'
  
  if log_type == 'main' or log_type == 'nvim' then
    logging.open_nvim_log()
  elseif log_type == 'error' or log_type == 'errors' then
    logging.open_error_log()
  elseif log_type == 'plugin' or log_type == 'plugins' then
    logging.open_plugin_log()
  elseif log_type == 'debug' then
    logging.open_debug_log()
  else
    vim.notify("Usage: :LogOpen [main|error|plugin|debug]", vim.log.levels.INFO)
  end
end, {
  nargs = '?',
  complete = function()
    return { 'main', 'error', 'plugin', 'debug' }
  end,
  desc = 'Open various log files'
})

-- Command to clean logs
vim.api.nvim_create_user_command('LogClean', function(opts)
  local days = tonumber(opts.args) or 7
  logging.clean_logs(days)
  vim.notify(string.format("Cleaned logs older than %d days", days), vim.log.levels.INFO)
end, {
  nargs = '?',
  desc = 'Clean logs older than specified days (default: 7)'
})

-- Command to show log statistics
vim.api.nvim_create_user_command('LogStats', function()
  local stats = logging.get_log_stats()
  local lines = { "=== Log File Statistics ===" }
  
  for name, info in pairs(stats) do
    if info.exists then
      local size_mb = math.floor(info.size / 1024 / 1024 * 100) / 100
      local mtime_str = os.date('%Y-%m-%d %H:%M:%S', info.mtime)
      table.insert(lines, string.format("%s: %.2f MB (modified: %s)", name, size_mb, mtime_str))
    else
      table.insert(lines, string.format("%s: Not found", name))
    end
  end
  
  -- Display in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  local width = 60
  local height = #lines + 2
  local opts_win = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    anchor = 'NW',
    style = 'minimal',
    border = 'rounded',
    title = ' Log Statistics ',
    title_pos = 'center'
  }
  
  vim.api.nvim_open_win(buf, true, opts_win)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
end, {
  desc = 'Show log file statistics'
})

-- Command to toggle debug logging
vim.api.nvim_create_user_command('LogToggleDebug', function()
  logging.config.core_plugins_debug = not logging.config.core_plugins_debug
  if logging.config.core_plugins_debug then
    logging.set_core_plugins_debug()
    vim.notify("Debug logging enabled for core plugins", vim.log.levels.INFO)
  else
    vim.notify("Debug logging disabled for core plugins", vim.log.levels.INFO)
  end
end, {
  desc = 'Toggle debug logging for core plugins'
})

-- Command to manually log test messages
vim.api.nvim_create_user_command('LogTest', function(opts)
  local level = opts.args or 'info'
  local message = "Test log message from user command"
  
  if level == 'debug' then
    logging.debug(message, true)
  elseif level == 'info' then
    logging.info(message, true)
  elseif level == 'warn' then
    logging.warn(message, true)
  elseif level == 'error' then
    logging.error(message, true)
  else
    vim.notify("Usage: :LogTest [debug|info|warn|error]", vim.log.levels.INFO)
    return
  end
  
  vim.notify(string.format("Test %s message logged", level), vim.log.levels.INFO)
end, {
  nargs = '?',
  complete = function()
    return { 'debug', 'info', 'warn', 'error' }
  end,
  desc = 'Log a test message at specified level'
})

-- Command to quickly open Neovim's main log for recurring checks
vim.api.nvim_create_user_command('LogNvim', function()
  -- Use the lua command provided in the requirements
  vim.cmd('edit ' .. vim.fn.stdpath('log') .. '/nvim.log')
end, {
  desc = 'Open Neovim main log file for recurring checks'
})

-- Set up keymaps for quick access to logging functions
local function setup_keymaps()
  -- Create a logging keymap group
  vim.keymap.set('n', '<leader>l', '', { desc = '+logs' })
  
  -- Open different log files
  vim.keymap.set('n', '<leader>ln', '<cmd>LogNvim<cr>', { desc = 'Open Neovim main log' })
  vim.keymap.set('n', '<leader>le', '<cmd>LogOpen error<cr>', { desc = 'Open error log' })
  vim.keymap.set('n', '<leader>lp', '<cmd>LogOpen plugin<cr>', { desc = 'Open plugin log' })
  vim.keymap.set('n', '<leader>ld', '<cmd>LogOpen debug<cr>', { desc = 'Open debug log' })
  
  -- Log management
  vim.keymap.set('n', '<leader>ls', '<cmd>LogStats<cr>', { desc = 'Show log statistics' })
  vim.keymap.set('n', '<leader>lc', '<cmd>LogClean<cr>', { desc = 'Clean old logs' })
  vim.keymap.set('n', '<leader>lt', '<cmd>LogToggleDebug<cr>', { desc = 'Toggle debug logging' })
  vim.keymap.set('n', '<leader>lT', '<cmd>LogTest<cr>', { desc = 'Test logging system' })
end

-- Auto command to show log errors in quickfix if they occur frequently
local function setup_error_monitoring()
  -- Track error frequency
  local error_count = 0
  local error_threshold = 5
  local error_window = 60 -- seconds
  local last_error_time = 0
  
  vim.api.nvim_create_autocmd("User", {
    pattern = "LogError",
    callback = function()
      local current_time = os.time()
      
      -- Reset counter if outside time window
      if current_time - last_error_time > error_window then
        error_count = 0
      end
      
      error_count = error_count + 1
      last_error_time = current_time
      
      -- If we hit threshold, notify user
      if error_count >= error_threshold then
        vim.notify(
          string.format("High error frequency detected (%d errors in %d seconds). Check logs with :LogOpen error", 
            error_count, error_window),
          vim.log.levels.WARN
        )
        error_count = 0 -- Reset to avoid spam
      end
    end,
  })
end

-- Function to create telescope picker for log files
local function create_log_telescope_picker()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  
  local function log_picker()
    local log_files = {
      { name = "Neovim Main Log", command = "LogNvim" },
      { name = "Error Log", command = "LogOpen error" },
      { name = "Plugin Log", command = "LogOpen plugin" },
      { name = "Debug Log", command = "LogOpen debug" },
      { name = "Log Statistics", command = "LogStats" },
      { name = "Clean Logs", command = "LogClean" },
    }
    
    pickers.new({}, {
      prompt_title = 'Log Files',
      finder = finders.new_table {
        results = log_files,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd(selection.value.command)
        end)
        return true
      end,
    }):find()
  end
  
  -- Create command for telescope picker
  vim.api.nvim_create_user_command('LogPicker', log_picker, {
    desc = 'Telescope picker for log files'
  })
  
  -- Add keymap for telescope picker
  vim.keymap.set('n', '<leader>ll', '<cmd>LogPicker<cr>', { desc = 'Log file picker' })
end

-- Setup function
local function setup()
  setup_keymaps()
  setup_error_monitoring()
  
  -- Only setup telescope picker if telescope is available
  local ok, _ = pcall(require, 'telescope')
  if ok then
    create_log_telescope_picker()
  end
end

return {
  setup = setup
}
