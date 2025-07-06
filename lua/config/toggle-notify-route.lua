-- toggle-notify-route.lua
-- Helper script to toggle Noice's notify route if conflicts persist with nvim-notify
--
-- Usage: :lua require('config.toggle-notify-route').toggle()

local M = {}

-- Function to toggle the notify route skip in noice configuration
function M.toggle()
  local noice_config_path = vim.fn.stdpath('config') .. '/lua/plugins/noice.lua'
  
  -- Read the current file
  local file = io.open(noice_config_path, 'r')
  if not file then
    vim.notify('Could not open noice.lua configuration file', vim.log.levels.ERROR)
    return
  end
  
  local content = file:read('*all')
  file:close()
  
  -- Check current state and toggle
  local is_commented = content:match('%-%-.*{ filter = { event = "notify" }, opts = { skip = true } }')
  local new_content
  
  if is_commented then
    -- Uncomment the line
    new_content = content:gsub('(%s*)%-%- ({ filter = { event = "notify" }, opts = { skip = true } },)', '%1%2')
    vim.notify('Enabled Noice notify route skip (conflicts should be resolved)', vim.log.levels.INFO)
  else
    -- Comment the line
    new_content = content:gsub('(%s*)({ filter = { event = "notify" }, opts = { skip = true } },)', '%1-- %2')
    vim.notify('Disabled Noice notify route skip (using default behavior)', vim.log.levels.INFO)
  end
  
  -- Write the modified content back
  file = io.open(noice_config_path, 'w')
  if not file then
    vim.notify('Could not write to noice.lua configuration file', vim.log.levels.ERROR)
    return
  end
  
  file:write(new_content)
  file:close()
  
  vim.notify('Configuration updated. Restart Neovim for changes to take effect.', vim.log.levels.WARN)
end

-- Function to check current notify route status
function M.status()
  local noice_config_path = vim.fn.stdpath('config') .. '/lua/plugins/noice.lua'
  
  local file = io.open(noice_config_path, 'r')
  if not file then
    vim.notify('Could not open noice.lua configuration file', vim.log.levels.ERROR)
    return
  end
  
  local content = file:read('*all')
  file:close()
  
  local is_commented = content:match('%-%-.*{ filter = { event = "notify" }, opts = { skip = true } }')
  
  if is_commented then
    vim.notify('Notify route skip is currently DISABLED (commented)', vim.log.levels.INFO)
  else
    vim.notify('Notify route skip is currently ENABLED (active)', vim.log.levels.INFO)
  end
end

return M
