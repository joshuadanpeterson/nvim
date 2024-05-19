-- linter configuration
-- config/linter.lua

Lint = require('lint');

-- Function to set custom eslint configuration for Google Apps Script
local function set_custom_eslint()
    Lint.linters.eslint = {
        cmd = 'eslint',
        args = {
            '--stdin',
            '--stdin-filename',
            '%filepath',
            '--config',
            '~/.config/nvim/lua/linter_configs/google_apps_script_eslintrc.json' -- Specify your ESLint config path
        },
        stdin = true
    }
end

-- Configure 'nvim-lint'
Lint.linters_by_ft = {
    lua = { 'luacheck' },
    javascript = {
        function()
            if vim.fn.bufname():match('script.google.com') then
                -- Use custom ESLint configuration for Google Apps Script
                set_custom_eslint()
            else
                -- Default to eslint_d for other JavaScript files
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

-- Debugging key type in Lint.lua (add this part in Lint.lua file in nvim-lint)
-- local function lookup_linter(ft)
--     print('Looking up linter for filetype:', ft)
--     local key = Lint.linters_by_ft[ft]
--     print('Key type:', type(key))
--     if type(key) == 'function' then
--         print('Key is a function:', key)
--     else
--         print('Key value:', key)
--     end
--     if key == nil then
--         print('No linter found for filetype:', ft)
--     end
--     return key
-- end

-- -- Example usage
-- local ft = 'javascript' -- Replace with actual filetype during testing
-- lookup_linter(ft)
