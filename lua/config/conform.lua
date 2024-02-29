-- conform.nvim config: for formatting

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },  -- Assuming this covers TypeScript, JSON, YAML, HTML, CSS as well
    python = function(bufnr)
      -- Using a function to dynamically select the formatter, but keeping it simple for now
      return { "black" }
    end,
    go = { "gofumpt", "goimports" },  -- Running gofumpt first, then goimports
    php = { "php-cs-fixer" },
    ruby = { "rufo" },
    sql = { "sqlformat" },
    dockerfile = { "dockerfile_lint" },
    vim = { "vim-codefmt" },  -- Assuming vim script files are recognized with 'vim' filetype
    ["*"] = { "codespell" },
    ["_"] = { "trim_whitespace" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
  format_after_save = {
    lsp_fallback = true,
  },
  log_level = vim.log.levels.ERROR,
  notify_on_error = true,
  formatters = {
    -- Add or modify custom formatter configurations here if needed
  },
})

-- Direct assignments for quick overrides or additions
require("conform").formatters_by_ft.lua = { "stylua" }
require("conform").formatters_by_ft.javascript = { "prettier" }
require("conform").formatters_by_ft.python = { "black" }
require("conform").formatters_by_ft.go = { "gofumpt", "goimports" }
require("conform").formatters_by_ft.php = { "php-cs-fixer" }
require("conform").formatters_by_ft.ruby = { "rufo" }
require("conform").formatters_by_ft.sql = { "sqlformat" }
require("conform").formatters_by_ft.dockerfile = { "dockerfile_lint" }
require("conform").formatters_by_ft.vim = { "vim-codefmt" }
