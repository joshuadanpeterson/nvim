# Neovim Logging System

This comprehensive logging system implements debug logging for core plugins and error capturing mechanisms as requested. It provides enhanced visibility into Neovim operations and helps surface errors for debugging.

## Features

### 1. Debug Logging for Core Plugins
- **LSP log level**: Set to `debug` automatically
- **Legendary.nvim log level**: Set to `debug` in `init.lua`
- **Core plugins debug mode**: Enabled during testing phase
- **Automatic log level management**: Centralized configuration

### 2. Error Capturing Mechanisms
- **vim.notify hooks**: Captures all error and warning notifications
- **LSP error handling**: Intercepts LSP error messages
- **VimL error capture**: Hooks into Vim script errors
- **Lua error capture**: Comprehensive error tracking with stack traces

### 3. Log File Management
- **Separate log files** for different types of messages:
  - `nvim_errors.log` - Error messages
  - `nvim_plugins.log` - Plugin info and warnings
  - `nvim_debug.log` - Debug messages
  - Plus access to Neovim's main log
- **Automatic log rotation**: When files exceed 10MB
- **Log cleanup**: Automatically removes logs older than 7 days
- **Timestamped entries**: With source file information

### 4. Easy Access to Logs
- **User commands**: `:LogOpen`, `:LogStats`, `:LogClean`, etc.
- **Keymaps**: `<leader>l` prefix for all logging functions
- **Telescope integration**: Quick picker for log files
- **Floating window stats**: Visual log file information

## Usage

### Commands

```vim
:LogOpen [main|error|plugin|debug]  " Open specific log file
:LogNvim                            " Open Neovim's main log
:LogStats                           " Show log file statistics
:LogClean [days]                    " Clean logs older than N days (default: 7)
:LogToggleDebug                     " Toggle debug logging on/off
:LogTest [level]                    " Test logging at specific level
:LogPicker                          " Telescope picker for log files
```

### Keymaps

| Keymap | Description |
|--------|-------------|
| `<leader>ln` | Open Neovim main log |
| `<leader>le` | Open error log |
| `<leader>lp` | Open plugin log |
| `<leader>ld` | Open debug log |
| `<leader>ls` | Show log statistics |
| `<leader>lc` | Clean old logs |
| `<leader>lt` | Toggle debug logging |
| `<leader>lT` | Test logging system |
| `<leader>ll` | Log file picker (Telescope) |

### Programmatic Usage

```lua
local logging = require('config.logging')

-- Log messages at different levels
logging.debug("Debug message", true)    -- true adds source context
logging.info("Info message")
logging.warn("Warning message")
logging.error("Error message")

-- Capture Lua errors
local success, result = pcall(function()
    -- Some potentially failing operation
end)
if not success then
    logging.capture_lua_error(result)
end

-- Get log statistics
local stats = logging.get_log_stats()
print(vim.inspect(stats))
```

## Implementation Details

### Core Components

1. **`config/logging.lua`**: Main logging module
   - Error capturing hooks
   - File management and rotation
   - Debug mode configuration
   - Public API for logging functions

2. **`config/logging-utils.lua`**: User interface
   - User commands
   - Keymaps
   - Telescope integration
   - Error frequency monitoring

### Integration Points

1. **init.lua**: 
   - Sets `legendary` log level to `debug`
   - Initializes logging system on startup

2. **config/lsp.lua**: 
   - LSP configurations use centralized logging
   - Error handlers hook into logging system

3. **config/settings.lua**: 
   - Removed redundant LSP log level setting
   - Integrated with centralized logging

### Log File Locations

All logs are stored in Neovim's standard log directory:
```
~/.local/state/nvim/
├── nvim.log          # Neovim's main log
├── nvim_errors.log   # Our error log
├── nvim_plugins.log  # Our plugin/info log
└── nvim_debug.log    # Our debug log
```

### Automatic Features

1. **Startup Log Cleaning**: Removes logs older than 7 days on Neovim start
2. **Error Frequency Monitoring**: Warns if more than 5 errors occur in 60 seconds
3. **Log Rotation**: Automatically rotates logs when they exceed 10MB
4. **Source Context**: Debug messages include file and line number information

## Configuration

The logging system can be configured when setting up:

```lua
logging.setup({
  core_plugins_debug = true,        -- Enable debug for core plugins
  default_log_level = 'debug',      -- Default log level
  max_log_size = 10 * 1024 * 1024, -- 10MB before rotation
  max_log_files = 5,                -- Keep 5 rotated files
})
```

## Neovim Main Log Access

As requested, easy access to Neovim's own log is provided:

- **Command**: `:LogNvim`
- **Keymap**: `<leader>ln`
- **Lua**: `vim.cmd('edit ' .. vim.fn.stdpath('log') .. '/nvim.log')`

This implements the exact functionality mentioned in the requirements for recurring checks of Neovim's main log.

## Testing

To test the logging system:

1. Use `:LogTest debug` to log a test debug message
2. Use `:LogStats` to see current log file status
3. Use `:LogOpen debug` to view the debug log
4. Check that debug messages appear when using core plugins

## Benefits

- **Proactive Error Detection**: Errors are automatically captured and logged
- **Debug Visibility**: Core plugin debug information is readily available
- **Centralized Management**: All logging controlled from one place
- **Easy Access**: Quick commands and keymaps for log inspection
- **Automatic Maintenance**: Self-cleaning and rotating log files
- **Performance Monitoring**: Track error frequency and plugin behavior

This system provides comprehensive visibility into Neovim's operation and makes debugging much more efficient.
