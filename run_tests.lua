-- run_tests.lua
-- Simple test runner for Neovim configuration validation

-- Load the test module
local test_config = require('test_config')

-- Check if we're running from command line or within Neovim
local function is_running_in_nvim()
    return vim and vim.fn and vim.fn.has and vim.fn.has('nvim') == 1
end

-- Main execution
if is_running_in_nvim() then
    -- Running from within Neovim
    print("Running Neovim configuration tests from within Neovim...")
    test_config.run_all_tests()
else
    -- Running from command line
    print("Error: This script must be run from within Neovim")
    print("Usage:")
    print("  nvim -l run_tests.lua")
    print("  OR from within Neovim: :lua require('run_tests')")
    os.exit(1)
end
