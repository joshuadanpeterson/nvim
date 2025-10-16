-- lua/config/compat/health_shim.lua
-- Optional Lua shim: map missing report_* fields to new vim.health API (0.11+)
local health = vim.health
if not health then return end

local function noop() end
local has_new = type(health.start) == 'function'

health.report_start = health.report_start or (has_new and health.start or noop)
health.report_ok    = health.report_ok    or (has_new and health.ok    or noop)
health.report_warn  = health.report_warn  or (has_new and health.warn  or noop)
health.report_error = health.report_error or (has_new and health.error or noop)
health.report_info  = health.report_info  or (has_new and health.info  or noop)
