# Neovim Configuration Test Suite

This directory contains comprehensive test scripts to validate your Neovim configuration, ensuring all plugins load correctly, keymaps function properly, and critical commands are available.

## Test Scripts

### 1. `test_config.lua` - Comprehensive Test Suite

The main test script that performs thorough validation of your Neovim configuration.

**Features:**
- ✅ Plugin loading validation
- ✅ Critical command availability testing
- ✅ LSP functionality verification
- ✅ Telescope extension testing
- ✅ Keymap integrity checking
- ✅ Treesitter parser validation
- ✅ Performance benchmarking
- ✅ Health check analysis
- ✅ Log file error detection

**Usage:**
```lua
-- From within Neovim
:lua require('test.test_config').run_all_tests()

-- Run individual test modules
:lua require('test.test_config').test_plugin_loading()
:lua require('test.test_config').test_lsp_functionality()
:lua require('test.test_config').test_telescope_functionality()
```

### 2. `quick_test.lua` - Fast Validation

A lightweight test script for quick validation of essential functionality.

**Usage:**
```lua
-- From within Neovim
:lua require('test.quick_test')

-- Or using the dofile command
:lua dofile(vim.fn.stdpath('config') .. '/test/quick_test.lua')
```

### 3. `run_tests.lua` - Test Runner

A convenient wrapper script for running the full test suite.

**Usage:**
```lua
-- From within Neovim
:lua require('test.run_tests')
```

## Running Tests

### Method 1: From Neovim Command Line

1. Open Neovim
2. Run one of these commands:
   ```vim
   :lua require('test.test_config').run_all_tests()
   :lua require('test.quick_test')
   :lua require('test.run_tests')
   ```

### Method 2: From Terminal (using nvim -l)

```bash
cd ~/.config/nvim
nvim -l test/quick_test.lua
nvim -l test/run_tests.lua
```

### Method 3: As a Neovim Command

You can add these to your keymaps for easy access:

```lua
-- Add to your keymaps.lua
vim.keymap.set('n', '<leader>tt', function()
    require('test.test_config').run_all_tests()
end, { desc = 'Run config tests' })

vim.keymap.set('n', '<leader>tq', function()
    require('test.quick_test')
end, { desc = 'Quick config test' })
```

## Test Categories

### 1. Plugin Loading Tests
- Validates that all critical plugins can be loaded without errors
- Checks lazy.nvim plugin status
- Identifies failed or missing plugins

### 2. Critical Commands Tests
- Verifies availability of essential commands:
  - `Lazy`, `LazyUpdate`, `LazyCheck`
  - `Telescope`, `Mason`, `MasonUpdate`
  - `LspInfo`, `LspStart`, `LspRestart`
  - `Trouble`, `WhichKey`, `TSUpdate`
  - And more...

### 3. LSP Functionality Tests
- Checks LSP module availability
- Lists active LSP clients
- Validates LSP commands
- Tests Mason package installation

### 4. Telescope Functionality Tests
- Validates Telescope core functionality
- Tests builtin functions (find_files, live_grep, etc.)
- Checks extension loading status

### 5. Keymap Integrity Tests
- Validates which-key integration
- Tests legendary.nvim functionality
- Ensures keymap targets exist

### 6. Treesitter Tests
- Checks Treesitter availability
- Lists installed parsers
- Validates parser functionality

### 7. Performance Tests
- Measures plugin loading times
- Identifies performance bottlenecks
- Provides optimization suggestions

### 8. Health Checks
- Runs `:checkhealth` and analyzes output
- Identifies critical errors and warnings
- Provides health status summary

### 9. Log File Analysis
- Checks recent log files for errors
- Analyzes LSP logs, lazy.nvim logs
- Reports recent error patterns

## Expected Plugins

The test suite expects these critical plugins to be available:

- **Core**: `lazy`, `legendary`, `plenary`
- **Navigation**: `telescope`, `which-key`, `harpoon`
- **LSP**: `nvim-lspconfig`, `mason`, `trouble`
- **UI**: `lualine`, `noice`, `flash`
- **Development**: `nvim-treesitter`, `copilot`, `cmp`, `conform`
- **Utilities**: `oil`

## Interpreting Results

### ✅ Success (Green)
- Component is working correctly
- No action needed

### ⚠️ Warning (Yellow)
- Component is available but may have issues
- Optional feature or non-critical problem
- Review recommended but not urgent

### ❌ Error (Red)
- Critical component is missing or broken
- Immediate attention required
- May impact core functionality

## Troubleshooting

### Common Issues

1. **Plugin Loading Failures**
   - Check lazy.nvim configuration
   - Verify plugin specifications
   - Run `:Lazy sync` to update plugins

2. **Command Not Available**
   - Plugin may not be loaded
   - Check plugin configuration
   - Verify plugin installation

3. **LSP Issues**
   - Run `:LspInfo` for diagnostics
   - Check Mason installation: `:Mason`
   - Verify LSP server installation

4. **Keymap Problems**
   - Check which-key configuration
   - Verify legendary.nvim setup
   - Review keymap definitions

### Getting Help

1. Run the full test suite for detailed diagnostics
2. Check `:checkhealth` output for system-level issues
3. Review log files in `~/.local/state/nvim/`
4. Use `:Lazy profile` to identify plugin loading issues

## Customization

You can customize the test suite by modifying the `TEST_CONFIG` table in `test/test_config.lua`:

```lua
local TEST_CONFIG = {
    critical_plugins = {
        -- Add your essential plugins here
    },
    critical_commands = {
        -- Add your essential commands here
    },
    -- ... other configuration options
}
```

This allows you to tailor the tests to your specific configuration needs.
