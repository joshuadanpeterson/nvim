" plugin/health_compat.vim
" Shim legacy health#report_* functions for Neovim 0.11+, where they were removed.
" Only define if not already present (so older Neovim versions keep builtin).

if exists('*health#report_start') == 0
  function! health#report_start(title) abort
    call luaeval('pcall(function(t) return (vim.health and vim.health.start and vim.health.start(t)) end, _A)', a:title)
  endfunction
endif

if exists('*health#report_ok') == 0
  function! health#report_ok(msg) abort
    call luaeval('pcall(function(m) return (vim.health and vim.health.ok and vim.health.ok(m)) end, _A)', a:msg)
  endfunction
endif

if exists('*health#report_warn') == 0
  function! health#report_warn(msg) abort
    call luaeval('pcall(function(m) return (vim.health and (vim.health.warn or vim.health.info) and (vim.health.warn or vim.health.info)(m)) end, _A)', a:msg)
  endfunction
endif

if exists('*health#report_error') == 0
  function! health#report_error(msg) abort
    call luaeval('pcall(function(m) return (vim.health and vim.health.error and vim.health.error(m)) end, _A)', a:msg)
  endfunction
endif

if exists('*health#report_info') == 0
  function! health#report_info(msg) abort
    call luaeval('pcall(function(m) return (vim.health and (vim.health.info or vim.health.ok) and (vim.health.info or vim.health.ok)(m)) end, _A)', a:msg)
  endfunction
endif
