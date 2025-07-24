-- lazy-loading-helpers.lua
-- Helper functions and commands for lazy-loaded plugins

local M = {}

-- Create a command to manually update Treesitter parsers
vim.api.nvim_create_user_command('TSUpdateAll', function()
  vim.notify('Updating Treesitter parsers...', vim.log.levels.INFO)
  vim.cmd('TSUpdate')
end, { desc = 'Update all Treesitter parsers' })

-- Create a command to manually update Mason packages
vim.api.nvim_create_user_command('MasonUpdateAll', function()
  vim.notify('Updating Mason packages...', vim.log.levels.INFO)
  vim.cmd('MasonUpdate')
end, { desc = 'Update all Mason packages' })

-- Function to check if lazy loading is working
M.check_lazy_loading = function()
  local stats = require('lazy').stats()
  vim.notify(string.format(
    'Lazy Loading Stats:\n' ..
    'Total plugins: %d\n' ..
    'Loaded plugins: %d\n' ..
    'Startup time: %.2fms',
    stats.count,
    stats.loaded,
    stats.startuptime
  ), vim.log.levels.INFO)
end

-- Command to check lazy loading stats
vim.api.nvim_create_user_command('LazyStats', M.check_lazy_loading, 
  { desc = 'Show lazy loading statistics' })

return M
