-- linter configuration

-- configure 'nvim-lint'
require('lint').linters_by_ft = {
    lua = { 'luacheck' },
    javascript = { 'eslint' },
    typescript = { 'eslint' },
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
