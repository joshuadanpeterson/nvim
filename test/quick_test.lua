-- quick_test.lua
-- Quick validation script for essential Neovim functionality
-- This script performs a lightweight check of critical components

local function print_result(success, message)
    local status = success and "✓" or "✗"
    local color = success and "\27[32m" or "\27[31m"
    print(color .. status .. " " .. message .. "\27[0m")
    return success
end

local function quick_test()
    print("\27[36m=== Quick Neovim Configuration Test ===\27[0m")
    print()
    
    local results = {}
    
    -- Test 1: Lazy.nvim
    local lazy_ok = pcall(require, 'lazy')
    table.insert(results, print_result(lazy_ok, "Lazy.nvim plugin manager"))
    
    -- Test 2: Legendary.nvim
    local legendary_ok = pcall(require, 'legendary')
    table.insert(results, print_result(legendary_ok, "Legendary.nvim keymap manager"))
    
    -- Test 3: Telescope
    local telescope_ok = pcall(require, 'telescope')
    table.insert(results, print_result(telescope_ok, "Telescope fuzzy finder"))
    
    -- Test 4: LSP
    local lsp_ok = vim.lsp ~= nil
    table.insert(results, print_result(lsp_ok, "LSP functionality"))
    
    -- Test 5: Mason
    local mason_ok = pcall(require, 'mason')
    table.insert(results, print_result(mason_ok, "Mason LSP installer"))
    
    -- Test 6: Treesitter
    local ts_ok = pcall(require, 'nvim-treesitter')
    table.insert(results, print_result(ts_ok, "Treesitter syntax highlighting"))
    
    -- Test 7: Which-key
    local wk_ok = pcall(require, 'which-key')
    table.insert(results, print_result(wk_ok, "Which-key help system"))
    
    -- Test 8: Critical commands
    local commands = {'Telescope', 'Lazy', 'Mason', 'LspInfo'}
    local cmd_results = {}
    for _, cmd in ipairs(commands) do
        cmd_results[cmd] = vim.fn.exists(':' .. cmd) == 2
    end
    local cmd_ok = true
    for _, status in pairs(cmd_results) do
        cmd_ok = cmd_ok and status
    end
    table.insert(results, print_result(cmd_ok, "Critical commands available"))
    
    -- Summary
    local passed = 0
    for _, result in ipairs(results) do
        if result then passed = passed + 1 end
    end
    
    print()
    if passed == #results then
        print("\27[32m🎉 All quick tests passed! (" .. passed .. "/" .. #results .. ")\27[0m")
        print("\27[32mYour Neovim configuration appears to be working correctly.\27[0m")
    else
        print("\27[31m❌ Some tests failed! (" .. passed .. "/" .. #results .. " passed)\27[0m")
        print("\27[33mRun the full test suite for detailed diagnostics: :lua require('test.test_config').run_all_tests()\27[0m")
    end
    
    return passed == #results
end

-- Run the test if called directly
if vim and vim.fn then
    return quick_test()
else
    print("This script must be run from within Neovim")
end
