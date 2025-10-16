# Neovim 0.11: healthcheck uses removed vim.health.report_* API (breaks :checkhealth)

On Neovim v0.11.x, :checkhealth for dash.nvim fails due to the legacy health API usage.

## Environment
- Neovim: NVIM v0.11.4 (LuaJIT)
- OS: macOS
- dash.nvim commit: 72ce1b4 (from lockfile)

## Reproduction
1. Install mrjones2014/dash.nvim on Neovim v0.11.x
2. Run :checkhealth or `nvim --headless "+checkhealth" "+qa"`

## Expected
Healthcheck runs and reports OK/warn/error as usual.

## Actual
Error calling legacy functions:

```
Error executing lua: ...dash.nvim/lua/dash/health.lua:47: attempt to call field 'report_start' (a nil value)
```

## Root cause
Neovim 0.11 replaced `vim.health.report_*` with `vim.health.*`:
- `report_start` → `start`
- `report_ok` → `ok`
- `report_warn` → `warn`
- `report_error` → `error`
- `report_info` → `info`

Some plugins also use `vim.fn['health#report_*']` which were removed in 0.11.

## Proposed fix
Detect and use the new API, falling back for older versions:

```lua
local H = vim.health and type(vim.health.start) == 'function' and vim.health or {
  start = vim.fn['health#report_start'],
  ok    = vim.fn['health#report_ok'],
  warn  = vim.fn['health#report_warn'] or vim.fn['health#report_info'],
  error = vim.fn['health#report_error'],
  info  = vim.fn['health#report_info'],
}
-- then use H.start / H.ok / H.warn / H.error / H.info
```

Happy to open a PR if desired.
