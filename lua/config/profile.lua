-- Neovim profiling utility
-- lua/config/profile.lua

local M = {}

-- State to track if profiling is enabled
M.profiling_enabled = false
M.profile_output_file = vim.fn.stdpath('cache') .. '/nvim-startuptime.log'

-- Toggle profiling and restart nvim
function M.toggle_profiling()
  if M.profiling_enabled then
    -- Disable profiling
    vim.opt.startuptime = ""
    M.profiling_enabled = false
    vim.notify("Profiling disabled", vim.log.levels.INFO, { title = "Profile" })
  else
    -- Enable profiling
    vim.opt.startuptime = M.profile_output_file
    M.profiling_enabled = true
    vim.notify("Profiling enabled. Restart Neovim to generate profile.", vim.log.levels.INFO, { title = "Profile" })
  end
end

-- Start profiling and restart Neovim
function M.start_profiling()
  -- Set the startuptime option
  vim.opt.startuptime = M.profile_output_file
  
  -- Save current session info if needed
  local current_file = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')
  local current_col = vim.fn.col('.')
  
  -- Create a temporary file to store session info
  local session_file = vim.fn.stdpath('cache') .. '/nvim-profile-session.vim'
  local session_content = string.format([[
    if filereadable('%s')
      edit %s
      call cursor(%d, %d)
    endif
    lua require('config.profile').show_results()
  ]], current_file, current_file, current_line, current_col)
  
  vim.fn.writefile(vim.split(session_content, '\n'), session_file)
  
  -- Restart Neovim with profiling enabled and session restore
  local nvim_cmd = string.format('%s --startuptime %s -S %s', 
    vim.v.progpath, 
    M.profile_output_file,
    session_file
  )
  
  -- Use jobstart to launch new instance and exit current
  vim.fn.jobstart(nvim_cmd, {
    detach = true,
    on_exit = function()
      vim.cmd('quit!')
    end
  })
  
  -- Give a moment for the job to start
  vim.defer_fn(function()
    vim.cmd('quit!')
  end, 100)
end

-- Show profiling results in a split window
function M.show_results()
  -- Check if profile output exists
  if vim.fn.filereadable(M.profile_output_file) == 0 then
    vim.notify("No profiling data found. Run :ProfileStart first.", vim.log.levels.WARN, { title = "Profile" })
    return
  end
  
  -- Read the profile file
  local profile_data = vim.fn.readfile(M.profile_output_file)
  
  -- Create a new buffer for the results
  vim.cmd('new')
  local buf = vim.api.nvim_get_current_buf()
  
  -- Set buffer options
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'startuptime'
  
  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, 'Neovim Startup Profile')
  
  -- Add content to buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, profile_data)
  
  -- Make buffer read-only
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  
  -- Add some helpful keymaps for the profile buffer
  local opts = { buffer = buf, silent = true }
  vim.keymap.set('n', 'q', ':close<CR>', opts)
  vim.keymap.set('n', '<Esc>', ':close<CR>', opts)
  
  -- Move cursor to the summary section (usually at the end)
  vim.cmd('normal! G')
  
  -- Clean up session file if it exists
  local session_file = vim.fn.stdpath('cache') .. '/nvim-profile-session.vim'
  if vim.fn.filereadable(session_file) == 1 then
    vim.fn.delete(session_file)
  end
end

-- Clean up old profile data
function M.clear_profile_data()
  if vim.fn.filereadable(M.profile_output_file) == 1 then
    vim.fn.delete(M.profile_output_file)
    vim.notify("Profile data cleared", vim.log.levels.INFO, { title = "Profile" })
  else
    vim.notify("No profile data to clear", vim.log.levels.INFO, { title = "Profile" })
  end
end

-- Setup function to be called from init
function M.setup()
  -- Create user commands
  vim.api.nvim_create_user_command('ProfileStart', function()
    M.start_profiling()
  end, { desc = 'Start profiling and restart Neovim' })
  
  vim.api.nvim_create_user_command('ProfileShow', function()
    M.show_results()
  end, { desc = 'Show profiling results in a split' })
  
  vim.api.nvim_create_user_command('ProfileToggle', function()
    M.toggle_profiling()
  end, { desc = 'Toggle profiling for next restart' })
  
  vim.api.nvim_create_user_command('ProfileClear', function()
    M.clear_profile_data()
  end, { desc = 'Clear profiling data' })
  
  -- Register keymap if which-key is available
  vim.defer_fn(function()
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.add({
        { "<leader>sp", M.start_profiling, desc = "Start Profiling (restart)" },
      })
    else
      -- Fallback keymap if which-key not available
      vim.keymap.set('n', '<leader>sp', M.start_profiling, { desc = 'Start Profiling (restart)' })
    end
  end, 100)
end

return M
