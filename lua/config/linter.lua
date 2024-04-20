-- linter configuration

-- configure 'nvim-lint'
require('lint').linters_by_ft = {
    lua = { 'luacheck' },
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
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
