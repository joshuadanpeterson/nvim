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
vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    pattern = "*",
    callback = function()
        require('lint').try_lint()
    end,
})
