-- config/sonicpi.lua
-- Auto-run helpers and QoL for sonicpi.nvim

local M = {
  enabled = false,
  hard_reload = false,   -- if true: stop before sending
  write_only = false,    -- if true: trigger only on save
  _timer = nil,
  _debounce_ms = 200,
}

local uv = vim.uv or vim.loop

local function debounced_send()
  if not M.enabled then return end
  if M._timer then M._timer:stop(); M._timer:close(); M._timer = nil end
  M._timer = uv.new_timer()
  M._timer:start(M._debounce_ms, 0, vim.schedule_wrap(function()
    if not M.enabled then return end
    if M.hard_reload then pcall(vim.cmd, 'SonicPiStop') end
    pcall(vim.cmd, 'SonicPiSendBuffer')
  end))
end

function M.toggle_autorun()
  M.enabled = not M.enabled
  vim.notify(('Sonic Pi autorun: %s'):format(M.enabled and 'ON' or 'OFF'))
end

function M.toggle_mode()
  M.hard_reload = not M.hard_reload
  vim.notify(('Sonic Pi reload mode: %s'):format(M.hard_reload and 'HARD (stop+run)' or 'SOFT (run only)'))
end

function M.toggle_write_only()
  M.write_only = not M.write_only
  vim.notify(('Sonic Pi trigger: %s'):format(M.write_only and 'on save' or 'on change'))
end

function M.setup_autorun()
  local grp = vim.api.nvim_create_augroup('SonicPiAutorun', { clear = true })
  -- Trigger on buffer changes
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = grp,
    pattern = '*.sonicpi',
    callback = function()
      if not M.write_only then debounced_send() end
    end,
  })
  -- Trigger on save
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = grp,
    pattern = '*.sonicpi',
    callback = function()
      debounced_send()
    end,
  })
end

function M.setup()
  M.setup_autorun()
end

return M
