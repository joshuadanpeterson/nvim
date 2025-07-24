-- plugins/linters.lua
-- Sets up linting for Neovim using Lua.

return {

  -- An asynchronous linting framework for Neovim
  {
    'mfussenegger/nvim-lint',
    event = { 'BufWritePost', 'BufNewFile', 'InsertLeave' },
    config = function()
      local lint = require 'lint'

      lint.linters_by_ft = {
        python = { 'black', 'flake8' },
        javascript = { 'prettierd', 'eslint_d' },
        jsx = { 'prettierd', 'eslint_d' },
        typescript = { 'prettierd', 'eslint_d' },
        tsx = { 'prettierd', 'eslint_d' },
        go = { 'golangci-lint' },
        rust = { 'rust-clippy' },
        bash = { 'shellcheck' },
        markdown = { 'markdownlint' },
        html = { 'htmlhint' },
        css = { 'stylelint' },
        tailwind = { 'stylelint' },
        bootstrap = { 'stylelint' },
        sql = { 'sqlfluff' },
        ruby = { 'rubocop' },
        lua = { 'luacheck' },
        graphql = { 'graphql-schema-linter' },
        yaml = { 'yamllint' },
        toml = { 'taplo' },
        json = { 'jsonlint' },
        scss = { 'stylelint' },
      }

      -- Load additional linter configuration
      require('config.linter')
      require('config.nvim-lint')

      -- local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

      -- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      --   group = lint_augroup,
      --   callback = function()
      --     lint.try_lint()
      --   end,
      -- })
    end,
  },
}
