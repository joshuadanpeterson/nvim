-- linter configuration
-- config/linter.lua

Lint = require 'lint'

-- Function to set custom eslint configuration for Google Apps Script
local function set_custom_eslint()
  Lint.linters.eslint = {
    cmd = 'eslint',
    args = {
      '--stdin',
      '--stdin-filename',
      '%filepath',
      '--config',
      '~/.config/nvim/lua/linter_configs/google_apps_script_eslintrc.json', -- Specify your ESLint config path
    },
    stdin = true,
  }
end

Lint.linters.eslint_d = Lint.linters.eslint_d
  or {
    cmd = 'eslint_d',
    stdin = true,
    args = {
      '--stdin',
      '--stdin-filename',
      '%filepath',
      '--format',
      'json',
    },
    parser = Lint.linters.eslint_d.parser,
  }

Lint.linters.eslint_google_apps_script = {
  name = 'eslint_google_apps_script',
  cmd = 'eslint',
  args = {
    '--stdin',
    '--stdin-filename',
    '%filepath',
    '--config',
    '~/.config/nvim/lua/linter_configs/google_apps_script_eslintrc.json',
    '--format',
    'json',
  },
  stdin = true,
  parser = Lint.linters.eslint.parser,
}

-- Configure 'nvim-lint'
Lint.linters_by_ft = {
  lua = { 'luacheck' },
  javascript = {
    function(bufnr)
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match 'script.google.com' then
        return 'eslint_google_apps_script'
      else
        return 'eslint_d'
      end
    end,
  },
  typescript = { 'eslint_d' }, -- Add similar condition if TypeScript is used in Apps Script
  javascriptreact = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  python = { 'flake8', 'pylint', 'mypy' },
  html = { 'htmlhint' },
  css = { 'stylelint' },
  sh = { 'shellcheck' },
  rust = { 'clippy' },
  go = { 'golangci-lint' },
  php = { 'phpcs', 'phpstan' },
  ruby = { 'rubocop' },
  json = { 'jsonlint' },
  yaml = { 'yamllint' },
  sql = { 'sqlfluff' },
  dockerfile = { 'hadolint' },
  vim = { 'vint' },
}

-- Automatically run the linter on buffer read and write
vim.cmd [[
  augroup LintOnSave
    autocmd!
    autocmd BufWritePost * lua Lint.try_lint()
    autocmd BufReadPost * lua Lint.try_lint()
  augroup END
]]

-- Using Lua autocmds
vim.cmd(
  [[
  augroup Linting
    autocmd!
    autocmd BufWritePost * lua require('lint').try_lint()
  augroup END
]],
  false
)
