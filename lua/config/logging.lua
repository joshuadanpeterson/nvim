-- logging.lua
-- Comprehensive logging configuration for Neovim
-- Implements debug logging for core plugins and error capturing mechanisms

local M = {}

-- Configuration
local config = {
  -- Core plugin debug settings
  core_plugins_debug = true,
  -- Log file paths
  error_log_file = vim.fn.stdpath('log') .. '/nvim_errors.log',
  plugin_log_file = vim.fn.stdpath('log') .. '/nvim_plugins.log',
  debug_log_file = vim.fn.stdpath('log') .. '/nvim_debug.log',
  -- Log levels
  default_log_level = 'debug',
  -- Maximum log file size (in bytes) before rotation
  max_log_size = 10 * 1024 * 1024, -- 10MB
  -- Number of rotated log files to keep
  max_log_files = 5,
}

-- Utility function to ensure log directory exists
local function ensure_log_dir()
  local log_dir = vim.fn.stdpath('log')
  if vim.fn.isdirectory(log_dir) == 0 then
    vim.fn.mkdir(log_dir, 'p')
  end
end

-- Function to rotate log files if they exceed max size
local function rotate_log_file(log_file)
  local stat = vim.loop.fs_stat(log_file)
  if stat and stat.size > config.max_log_size then
    -- Rotate existing log files
    for i = config.max_log_files - 1, 1, -1 do
      local old_file = log_file .. '.' .. i
      local new_file = log_file .. '.' .. (i + 1)
      if vim.loop.fs_stat(old_file) then
        os.rename(old_file, new_file)
      end
    end
    -- Move current log to .1
    os.rename(log_file, log_file .. '.1')
  end
end

-- Enhanced logging function with file output
local function log_to_file(level, message, log_file, context)
  ensure_log_dir()
  rotate_log_file(log_file)
  
  local timestamp = os.date('%Y-%m-%d %H:%M:%S')
  local source_info = ""
  
  -- Get source information from debug traceback
  if context then
    local info = debug.getinfo(3, "Sl")
    if info then
      source_info = string.format(" [%s:%d]", 
        info.source:match("([^/]+)$") or info.source, 
        info.currentline or 0)
    end
  end
  
  local log_entry = string.format("[%s] [%s]%s %s\n", 
    timestamp, 
    level:upper(), 
    source_info,
    message
  )
  
  -- Write to file
  local file = io.open(log_file, 'a')
  if file then
    file:write(log_entry)
    file:close()
  end
  
  -- Also output to vim's internal logging (commented out to prevent recursion)
  -- if level == 'error' then
  --   vim.notify(message, vim.log.levels.ERROR)
  -- elseif level == 'warn' then
  --   vim.notify(message, vim.log.levels.WARN)
  -- elseif level == 'debug' and config.core_plugins_debug then
  --   vim.notify(message, vim.log.levels.DEBUG)
  -- end
end

-- Public logging functions
function M.debug(message, context)
  log_to_file('debug', message, config.debug_log_file, context)
end

function M.info(message, context)
  log_to_file('info', message, config.plugin_log_file, context)
end

function M.warn(message, context)
  log_to_file('warn', message, config.plugin_log_file, context)
end

function M.error(message, context)
  log_to_file('error', message, config.error_log_file, context)
end

-- Function to capture and log Lua errors
function M.capture_lua_error(err)
  local error_msg = string.format("Lua Error: %s\nTraceback: %s", 
    tostring(err), 
    debug.traceback()
  )
  M.error(error_msg, true)
end

-- Function to set up error capturing hooks
function M.setup_error_hooks()
  -- Hook into vim.notify to capture error notifications
  local original_notify = vim.notify
  vim.notify = function(msg, level, opts)
    if level == vim.log.levels.ERROR then
      M.error("vim.notify ERROR: " .. tostring(msg), true)
    elseif level == vim.log.levels.WARN then
      M.warn("vim.notify WARN: " .. tostring(msg), true)
    end
    return original_notify(msg, level, opts)
  end
  
  -- Set up autocmd to catch VimL errors
  vim.api.nvim_create_autocmd("User", {
    pattern = "VimError",
    callback = function(args)
      M.error("VimL Error: " .. vim.inspect(args), true)
    end,
  })
  
  -- Hook into LSP error handling
  local original_lsp_handler = vim.lsp.handlers["window/showMessage"]
  vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config_)
    if result and result.type == 1 then -- Error message
      M.error("LSP Error: " .. result.message, true)
    end
    if original_lsp_handler then
      return original_lsp_handler(err, result, ctx, config_)
    end
  end
end

-- Function to set debug logging for core plugins
function M.set_core_plugins_debug()
  if not config.core_plugins_debug then
    return
  end
  
  -- Set LSP log level to debug
  vim.lsp.set_log_level('debug')
  
  -- Set legendary.nvim log level to debug (if it supports it)
  -- Note: This will be set in the main init.lua where legendary is configured
  
  -- Enable debug logging for other core plugins
  M.debug("Core plugins debug logging enabled", true)
  
  -- Set debug logging for various Neovim subsystems
  vim.g.vimsyn_debug = 1
  vim.g.vim_debug = 1
  
  -- Log current log level settings
  M.debug("LSP log level set to: debug", true)
  M.debug("Core plugins debug mode: enabled", true)
end

-- Function to open various Neovim log files
function M.open_nvim_log()
  vim.cmd('edit ' .. vim.fn.stdpath('log') .. '/nvim.log')
end

function M.open_error_log()
  vim.cmd('edit ' .. config.error_log_file)
end

function M.open_plugin_log()
  vim.cmd('edit ' .. config.plugin_log_file)
end

function M.open_debug_log()
  vim.cmd('edit ' .. config.debug_log_file)
end

-- Function to clean old log files
function M.clean_logs(days_to_keep)
  days_to_keep = days_to_keep or 7
  local cutoff_time = os.time() - (days_to_keep * 24 * 60 * 60)
  
  local log_files = {
    config.error_log_file,
    config.plugin_log_file,
    config.debug_log_file,
  }
  
  for _, log_file in ipairs(log_files) do
    if vim.loop.fs_stat(log_file) then
      -- Read and filter log file
      local lines = {}
      for line in io.lines(log_file) do
        local date_str = line:match("^%[([^%]]+)%]")
        if date_str then
          local year, month, day, hour, min, sec = date_str:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
          if year then
            local line_time = os.time({
              year = tonumber(year),
              month = tonumber(month),
              day = tonumber(day),
              hour = tonumber(hour),
              min = tonumber(min),
              sec = tonumber(sec)
            })
            if line_time >= cutoff_time then
              table.insert(lines, line)
            end
          else
            -- Keep lines without timestamps
            table.insert(lines, line)
          end
        else
          -- Keep lines without timestamps
          table.insert(lines, line)
        end
      end
      
      -- Write back filtered content
      local file = io.open(log_file, 'w')
      if file then
        for _, line in ipairs(lines) do
          file:write(line .. '\n')
        end
        file:close()
      end
    end
  end
  
  M.info(string.format("Cleaned logs older than %d days", days_to_keep), true)
end

-- Function to get log statistics
function M.get_log_stats()
  local stats = {}
  local log_files = {
    { name = "error", path = config.error_log_file },
    { name = "plugin", path = config.plugin_log_file },
    { name = "debug", path = config.debug_log_file },
    { name = "nvim_main", path = vim.fn.stdpath('log') .. '/nvim.log' },
  }
  
  for _, log_info in ipairs(log_files) do
    local stat = vim.loop.fs_stat(log_info.path)
    if stat then
      stats[log_info.name] = {
        size = stat.size,
        mtime = stat.mtime.sec,
        exists = true
      }
    else
      stats[log_info.name] = { exists = false }
    end
  end
  
  return stats
end

-- Setup function to initialize all logging features
function M.setup(opts)
  opts = opts or {}
  
  -- Merge user options with defaults
  for key, value in pairs(opts) do
    if config[key] ~= nil then
      config[key] = value
    end
  end
  
  -- Initialize logging
  ensure_log_dir()
  M.set_core_plugins_debug()
  M.setup_error_hooks()
  
  -- Log initialization
  M.info("Neovim logging system initialized", true)
  M.debug("Debug logging enabled for core plugins", true)
  
  -- Set up autocmd to clean logs periodically
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      -- Clean logs on startup (keep last 7 days)
      M.clean_logs(7)
    end,
  })
end

-- Export configuration for external access
M.config = config

return M
