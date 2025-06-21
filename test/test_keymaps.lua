-- test_keymaps.lua
-- Optional keymaps for running configuration tests
-- Add these to your existing keymap configuration

local wk = require('which-key')

-- Test-related keymaps
wk.add({
  -- Test keymaps group
  { "<leader>T", group = "🧪 Configuration Tests" },
  
  -- Quick test - fast validation of essential components
  {
    "<leader>Tq",
    function()
      require('test.quick_test')
    end,
    desc = "Quick Config Test"
  },
  
  -- Full test suite - comprehensive validation
  {
    "<leader>Tf",
    function()
      require('test.test_config').run_all_tests()
    end,
    desc = "Full Test Suite"
  },
  
  -- Individual test modules
  {
    "<leader>Tp",
    function()
      require('test.test_config').test_plugin_loading()
    end,
    desc = "Test Plugin Loading"
  },
  
  {
    "<leader>Tl",
    function()
      require('test.test_config').test_lsp_functionality()
    end,
    desc = "Test LSP Functionality"
  },
  
  {
    "<leader>Tt",
    function()
      require('test.test_config').test_telescope_functionality()
    end,
    desc = "Test Telescope"
  },
  
  {
    "<leader>Tk",
    function()
      require('test.test_config').test_keymap_integrity()
    end,
    desc = "Test Keymaps"
  },
  
  {
    "<leader>Ts",
    function()
      require('test.test_config').test_treesitter()
    end,
    desc = "Test Treesitter"
  },
  
  {
    "<leader>Th",
    function()
      require('test.test_config').check_health()
    end,
    desc = "Check Health"
  },
  
  {
    "<leader>TL",
    function()
      require('test.test_config').check_log_files()
    end,
    desc = "Check Log Files"
  },
  
  {
    "<leader>TP",
    function()
      require('test.test_config').run_performance_test()
    end,
    desc = "Performance Test"
  },
})

-- Alternative keymaps if you prefer different bindings
-- Uncomment and modify as needed:

--[[
vim.keymap.set('n', '<leader>tt', function()
    require('test.test_config').run_all_tests()
end, { desc = 'Run full config tests' })

vim.keymap.set('n', '<leader>tq', function()
    require('test.quick_test')
end, { desc = 'Quick config test' })

vim.keymap.set('n', '<leader>tp', function()
    require('test.test_config').test_plugin_loading()
end, { desc = 'Test plugin loading' })
--]]
