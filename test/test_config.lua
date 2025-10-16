#!/usr/bin/env lua
-- test_config.lua
-- Comprehensive Neovim Configuration Validation Test Script
-- 
-- This script validates the Neovim configuration by:
-- 1. Checking if all expected plugins are loaded without errors
-- 2. Validating keymaps don't reference unloaded plugins
-- 3. Testing critical commands (LSP, Telescope, Mason, legendary, Lazy)
-- 4. Running checkhealth diagnostics (optional)
-- 5. Checking log files for errors

local M = {}

-- Test configuration
local TEST_CONFIG = {
    -- Expected critical plugins that must be loaded
    critical_plugins = {
        'lazy',
        'legendary',
        'telescope',
        'mason',
        'nvim-lspconfig',
        'which-key',
        'plenary',
        'nvim-treesitter',
        'trouble',
        'harpoon',
        'lualine',
        'copilot',
        'cmp',
        'conform',
        'noice',
        'flash',
        'oil',
    },
    
    -- Critical commands that should be available
    critical_commands = {
        'Lazy',
        'LazyLoad',
        'LazyUpdate',
        'LazyCheck',
        'Legendary',
        'Telescope',
        'Mason',
        'MasonUpdate',
        'MasonInstall',
        'LspInfo',
        'LspStart',
        'LspRestart',
        'Trouble',
        'WhichKey',
        'TSUpdate',
        'TSInstall',
        'CopilotChat',
        'ConformInfo',
        'Noice',
        'Flash',
        'Oil',
    },
    
    -- LSP servers that should be available
    expected_lsp_servers = {
        'lua_ls',
        'tsserver',
        'pyright',
        'gopls',
        'rust_analyzer',
        'bashls',
        'jsonls',
        'yamlls',
        'html',
        'cssls',
        'tailwindcss',
    },
    
    -- Telescope extensions to check
    telescope_extensions = {
        'fzf',
        'ui-select',
        'project',
        'themes',
        'lazy',
        'notify',
        'rest',
    },
    
    -- Keymap groups to validate (these should not error)
    keymap_groups = {
        '<leader>b',  -- General and Basic Keymaps
        '<leader>H',  -- HTTP Keymaps
        '<leader>s',  -- SQL Keymaps
        '<leader>l',  -- LSP Keymaps
        '<leader>d',  -- Diagnostic Mappings
        '<leader>G',  -- GitHub Copilot Chat
        '<leader>T',  -- Trouble Mappings
        '<leader>f',  -- File operations
        '<leader>g',  -- Git operations
        '<leader>t',  -- Telescope operations
        '<leader>h',  -- Harpoon operations
    },
}

-- Colors for output
local colors = {
    reset = '\27[0m',
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    magenta = '\27[35m',
    cyan = '\27[36m',
    bold = '\27[1m',
}

-- Utility functions
local function print_colored(color, text)
    print(color .. text .. colors.reset)
end

local function print_success(text)
    print_colored(colors.green .. colors.bold, '✓ ' .. text)
end

local function print_error(text)
    print_colored(colors.red .. colors.bold, '✗ ' .. text)
end

local function print_warning(text)
    print_colored(colors.yellow .. colors.bold, '⚠ ' .. text)
end

local function print_info(text)
    print_colored(colors.blue, 'ℹ ' .. text)
end

local function print_header(text)
    print()
    print_colored(colors.cyan .. colors.bold, '=== ' .. text .. ' ===')
end

-- Test functions
function M.test_plugin_loading()
    print_header('Testing Plugin Loading')
    
    local success_count = 0
    local error_count = 0
    local warnings = {}
    
    for _, plugin in ipairs(TEST_CONFIG.critical_plugins) do
        local status, result = pcall(require, plugin)
        if status then
            print_success('Plugin loaded: ' .. plugin)
            success_count = success_count + 1
        else
            print_error('Failed to load plugin: ' .. plugin)
            print_colored(colors.red, '  Error: ' .. tostring(result))
            error_count = error_count + 1
        end
    end
    
    -- Check if lazy.nvim is properly initialized
    if pcall(require, 'lazy') then
        local lazy = require('lazy')
        local plugins = lazy.plugins()
        if plugins and #plugins > 0 then
            print_success('Lazy.nvim loaded with ' .. #plugins .. ' plugins')
            
            -- Check for failed plugins
            local failed_plugins = {}
            for name, plugin in pairs(plugins) do
                if plugin._ and plugin._.loaded == false and plugin._.installed then
                    table.insert(failed_plugins, name)
                end
            end
            
            if #failed_plugins > 0 then
                print_warning('Some plugins failed to load:')
                for _, name in ipairs(failed_plugins) do
                    print_colored(colors.yellow, '  - ' .. name)
                end
            end
        else
            print_warning('Lazy.nvim loaded but no plugins found')
        end
    end
    
    print()
    print_colored(colors.bold, string.format('Plugin Loading Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.test_critical_commands()
    print_header('Testing Critical Commands')
    
    local success_count = 0
    local error_count = 0
    
    for _, cmd in ipairs(TEST_CONFIG.critical_commands) do
        -- Check if command exists
        if vim.fn.exists(':' .. cmd) == 2 then
            print_success('Command available: ' .. cmd)
            success_count = success_count + 1
        else
            print_error('Command not available: ' .. cmd)
            error_count = error_count + 1
        end
    end
    
    print()
    print_colored(colors.bold, string.format('Commands Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.test_lsp_functionality()
    print_header('Testing LSP Functionality')
    
    local success_count = 0
    local error_count = 0
    
    -- Check if LSP is available
    if vim.lsp then
        print_success('LSP module available')
        success_count = success_count + 1
        
        -- Check active clients
        local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
        local clients = get_clients() or {}
        if #clients > 0 then
            print_success('Active LSP clients: ' .. #clients)
            for _, client in ipairs(clients) do
                print_info('  - ' .. client.name .. ' (ID: ' .. client.id .. ')')
            end
        else
            print_warning('No active LSP clients (this is normal if no files are open)')
        end
        
        -- Test LSP commands
        local lsp_commands = {'LspInfo', 'LspStart', 'LspRestart'}
        for _, cmd in ipairs(lsp_commands) do
            if vim.fn.exists(':' .. cmd) == 2 then
                print_success('LSP command available: ' .. cmd)
                success_count = success_count + 1
            else
                print_error('LSP command not available: ' .. cmd)
                error_count = error_count + 1
            end
        end
    else
        print_error('LSP module not available')
        error_count = error_count + 1
    end
    
    -- Check Mason
    if pcall(require, 'mason') then
        print_success('Mason available')
        local mason_registry = require('mason-registry')
        if mason_registry then
            local installed = mason_registry.get_installed_packages()
            print_info('Mason installed packages: ' .. #installed)
            for _, pkg in ipairs(installed) do
                print_info('  - ' .. pkg.name)
            end
        end
    else
        print_error('Mason not available')
        error_count = error_count + 1
    end
    
    print()
    print_colored(colors.bold, string.format('LSP Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.test_telescope_functionality()
    print_header('Testing Telescope Functionality')
    
    local success_count = 0
    local error_count = 0
    
    if pcall(require, 'telescope') then
        print_success('Telescope loaded')
        success_count = success_count + 1
        
        local telescope = require('telescope')
        
        -- Test builtin functions
        local builtin_status, builtin = pcall(require, 'telescope.builtin')
        if builtin_status then
            print_success('Telescope builtin functions available')
            success_count = success_count + 1
            
            -- Test some critical functions
            local critical_functions = {
                'find_files',
                'live_grep',
                'buffers',
                'help_tags',
                'lsp_references',
                'diagnostics',
            }
            
            for _, func_name in ipairs(critical_functions) do
                if builtin[func_name] then
                    print_success('Telescope function available: ' .. func_name)
                    success_count = success_count + 1
                else
                    print_error('Telescope function not available: ' .. func_name)
                    error_count = error_count + 1
                end
            end
        else
            print_error('Telescope builtin functions not available')
            error_count = error_count + 1
        end
        
        -- Test extensions
        for _, ext in ipairs(TEST_CONFIG.telescope_extensions) do
            if telescope.extensions[ext] then
                print_success('Telescope extension loaded: ' .. ext)
                success_count = success_count + 1
            else
                print_warning('Telescope extension not loaded: ' .. ext)
            end
        end
    else
        print_error('Telescope not available')
        error_count = error_count + 1
    end
    
    print()
    print_colored(colors.bold, string.format('Telescope Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.test_keymap_integrity()
    print_header('Testing Keymap Integrity')
    
    local success_count = 0
    local error_count = 0
    local warnings = {}
    
    -- Test which-key integration
    if pcall(require, 'which-key') then
        print_success('Which-key available')
        success_count = success_count + 1
    else
        print_error('Which-key not available')
        error_count = error_count + 1
        return false
    end
    
    -- Test legendary integration
    if pcall(require, 'legendary') then
        print_success('Legendary available')
        success_count = success_count + 1
        
        -- Try to get legendary items
        local legendary = require('legendary')
        local status, items = pcall(legendary.find)
        if status and items then
            print_success('Legendary keymaps accessible: ' .. #items .. ' items')
            success_count = success_count + 1
        else
            print_warning('Could not access legendary items')
            table.insert(warnings, 'Legendary items not accessible')
        end
    else
        print_error('Legendary not available')
        error_count = error_count + 1
    end
    
    -- Test specific keymap functionality by checking if the mapped functions exist
    local keymap_tests = {
        { group = 'LSP', cmd = 'Lspsaga', desc = 'LSP Saga commands' },
        { group = 'Telescope', cmd = 'Telescope', desc = 'Telescope commands' },
        { group = 'Trouble', cmd = 'Trouble', desc = 'Trouble commands' },
        { group = 'Copilot', cmd = 'CopilotChat', desc = 'Copilot Chat commands' },
    }
    
    for _, test in ipairs(keymap_tests) do
        if vim.fn.exists(':' .. test.cmd) == 2 then
            print_success('Keymap target available: ' .. test.desc)
            success_count = success_count + 1
        else
            print_error('Keymap target not available: ' .. test.desc)
            error_count = error_count + 1
        end
    end
    
    -- Print warnings
    if #warnings > 0 then
        print_warning('Keymap warnings:')
        for _, warning in ipairs(warnings) do
            print_colored(colors.yellow, '  - ' .. warning)
        end
    end
    
    print()
    print_colored(colors.bold, string.format('Keymap Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.test_treesitter()
    print_header('Testing Treesitter')
    
    local success_count = 0
    local error_count = 0
    
    if pcall(require, 'nvim-treesitter') then
        print_success('Treesitter available')
        success_count = success_count + 1
        
        -- Check parsers
        local status, parsers = pcall(require, 'nvim-treesitter.parsers')
        if status and parsers then
            local available_parsers = parsers.get_parser_configs()
            local installed_parsers = {}
            
            for lang, _ in pairs(available_parsers) do
                if parsers.has_parser(lang) then
                    table.insert(installed_parsers, lang)
                end
            end
            
            if #installed_parsers > 0 then
                print_success('Installed Treesitter parsers: ' .. #installed_parsers)
                for i = 1, math.min(10, #installed_parsers) do
                    print_info('  - ' .. installed_parsers[i])
                end
                if #installed_parsers > 10 then
                    print_info('  ... and ' .. (#installed_parsers - 10) .. ' more')
                end
                success_count = success_count + 1
            else
                print_warning('No Treesitter parsers installed')
            end
        else
            print_error('Could not access Treesitter parsers')
            error_count = error_count + 1
        end
    else
        print_error('Treesitter not available')
        error_count = error_count + 1
    end
    
    print()
    print_colored(colors.bold, string.format('Treesitter Summary: %d success, %d errors', 
                  success_count, error_count))
    
    return error_count == 0
end

function M.check_health()
    print_header('Running Neovim Health Checks')
    
    -- Run checkhealth and capture output
    print_info('Running :checkhealth (this may take a moment)...')
    
    -- Create a temporary buffer to capture checkhealth output
    local health_output = {}
    local old_print = print
    print = function(...)
        table.insert(health_output, table.concat({...}, ' '))
        old_print(...)
    end
    
    -- Run health checks
    vim.cmd('silent! checkhealth')
    
    -- Restore print
    print = old_print
    
    -- Analyze health output for errors
    local error_patterns = {
        'ERROR',
        'FAIL',
        'not found',
        'missing',
        'not installed',
        'not available',
    }
    
    local errors = {}
    local warnings = {}
    
    for _, line in ipairs(health_output) do
        local line_lower = line:lower()
        for _, pattern in ipairs(error_patterns) do
            if line_lower:find(pattern:lower()) then
                if line_lower:find('error') or line_lower:find('fail') then
                    table.insert(errors, line)
                else
                    table.insert(warnings, line)
                end
                break
            end
        end
    end
    
    if #errors > 0 then
        print_error('Health check errors found:')
        for _, error in ipairs(errors) do
            print_colored(colors.red, '  ' .. error)
        end
    else
        print_success('No critical health check errors found')
    end
    
    if #warnings > 0 then
        print_warning('Health check warnings:')
        for i = 1, math.min(5, #warnings) do
            print_colored(colors.yellow, '  ' .. warnings[i])
        end
        if #warnings > 5 then
            print_info('  ... and ' .. (#warnings - 5) .. ' more warnings')
        end
    end
    
    return #errors == 0
end

function M.check_log_files()
    print_header('Checking Log Files')
    
    local log_paths = {
        vim.fn.stdpath('log') .. '/lsp.log',
        vim.fn.stdpath('data') .. '/lazy/lazy.log',
        vim.fn.stdpath('state') .. '/nvim.log',
    }
    
    local error_count = 0
    
    for _, log_path in ipairs(log_paths) do
        if vim.fn.filereadable(log_path) == 1 then
            print_info('Checking log: ' .. log_path)
            
            -- Read last 50 lines of log file
            local lines = vim.fn.readfile(log_path, '', 50)
            local recent_errors = {}
            
            for _, line in ipairs(lines) do
                if line:lower():find('error') or line:lower():find('fail') then
                    table.insert(recent_errors, line)
                end
            end
            
            if #recent_errors > 0 then
                print_warning('Recent errors in ' .. vim.fn.fnamemodify(log_path, ':t') .. ':')
                for i = 1, math.min(3, #recent_errors) do
                    print_colored(colors.yellow, '  ' .. recent_errors[i])
                end
                if #recent_errors > 3 then
                    print_info('  ... and ' .. (#recent_errors - 3) .. ' more errors')
                end
                error_count = error_count + 1
            else
                print_success('No recent errors in ' .. vim.fn.fnamemodify(log_path, ':t'))
            end
        else
            print_info('Log file not found: ' .. log_path)
        end
    end
    
    return error_count == 0
end

function M.run_performance_test()
    print_header('Performance Tests')
    
    -- Test startup time components
    local startup_events = {
        'lazy_loading',
        'plugin_initialization',
        'lsp_startup',
        'treesitter_loading',
    }
    
    print_info('Testing plugin loading performance...')
    
    -- Test lazy loading performance
    local uv = vim.uv or vim.loop
    local start_time = uv.hrtime()
    pcall(require, 'lazy')
    local lazy_time = (uv.hrtime() - start_time) / 1000000 -- Convert to ms
    
    if lazy_time < 100 then
        print_success('Lazy.nvim loading time: ' .. string.format('%.2fms', lazy_time))
    else
        print_warning('Lazy.nvim loading time: ' .. string.format('%.2fms', lazy_time) .. ' (slow)')
    end
    
    -- Test telescope loading
    local uv2 = vim.uv or vim.loop
    start_time = uv2.hrtime()
    pcall(require, 'telescope')
    local telescope_time = (uv2.hrtime() - start_time) / 1000000
    
    if telescope_time < 50 then
        print_success('Telescope loading time: ' .. string.format('%.2fms', telescope_time))
    else
        print_warning('Telescope loading time: ' .. string.format('%.2fms', telescope_time) .. ' (slow)')
    end
    
    return true
end

-- Main test runner
function M.run_all_tests()
    print_colored(colors.magenta .. colors.bold, 
                  '🚀 Neovim Configuration Validation Test Suite')
    print_colored(colors.magenta, 
                  'Configuration Path: ' .. vim.fn.stdpath('config'))
    print()
    
    local results = {}
    local tests = {
        { name = 'Plugin Loading', func = M.test_plugin_loading },
        { name = 'Critical Commands', func = M.test_critical_commands },
        { name = 'LSP Functionality', func = M.test_lsp_functionality },
        { name = 'Telescope Functionality', func = M.test_telescope_functionality },
        { name = 'Keymap Integrity', func = M.test_keymap_integrity },
        { name = 'Treesitter', func = M.test_treesitter },
        { name = 'Performance', func = M.run_performance_test },
        { name = 'Health Checks', func = M.check_health },
        { name = 'Log Files', func = M.check_log_files },
    }
    
    local passed = 0
    local failed = 0
    
    for _, test in ipairs(tests) do
        local success = test.func()
        results[test.name] = success
        if success then
            passed = passed + 1
        else
            failed = failed + 1
        end
    end
    
    -- Final summary
    print_header('Test Results Summary')
    
    for _, test in ipairs(tests) do
        if results[test.name] then
            print_success(test.name)
        else
            print_error(test.name)
        end
    end
    
    print()
    if failed == 0 then
        print_colored(colors.green .. colors.bold, 
                      '🎉 All tests passed! (' .. passed .. '/' .. #tests .. ')')
        print_colored(colors.green, 
                      'Your Neovim configuration is working correctly!')
    else
        print_colored(colors.red .. colors.bold, 
                      '❌ Some tests failed! (' .. passed .. '/' .. #tests .. ' passed)')
        print_colored(colors.yellow, 
                      'Please review the errors above and fix any issues.')
    end
    
    return failed == 0
end

-- If running as script, execute tests
if arg and arg[0] and arg[0]:match('test_config%.lua$') then
    M.run_all_tests()
end

return M
