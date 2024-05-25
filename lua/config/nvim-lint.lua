-- config/nvim-lint.lua

local lint = require 'lint'

lint.linters_by_ft = {
  python = { 'flake8' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  lua = { 'luacheck' },
  css = { 'stylelint' },
  html = { 'htmlhint' },
  markdown = { 'markdownlint' },
}

lint.linters = {
  flake8 = {
    cmd = 'flake8',
    args = { '--format', 'default', '-' },
    stdin = true,
    stream = 'stderr',
    ignore_exitcode = true,
    parser = require('lint.parser').from_errorformat('%f:%l:%c: %t%n%n%n,%-G%.%#', {
      source = 'flake8',
      severity = vim.diagnostic.severity.INFO,
    }),
  },
  eslint = {
    cmd = 'eslint',
    args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
    stdin = true,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = function(output, bufnr)
      local decode = require('json').decode
      local messages = {}
      for _, diagnostic in ipairs(decode(output)) do
        for _, msg in ipairs(diagnostic.messages) do
          table.insert(messages, {
            lnum = msg.line - 1,
            col = msg.column - 1,
            end_lnum = msg.endLine - 1,
            end_col = msg.endColumn - 1,
            severity = require('lint').severity[msg.severity] or require('lint').severity.ERROR,
            source = 'eslint',
            message = msg.message,
          })
        end
      end
      return messages
    end,
  },
  luacheck = {
    cmd = 'luacheck',
    args = { '--formatter', 'plain', '--codes', '--ranges', '--filename', '%filepath', '-' },
    stdin = true,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = require('lint.parser').from_errorformat('%f:%l:%c: %t%n%n%n,%-G%.%#', {
      source = 'luacheck',
      severity = vim.diagnostic.severity.INFO,
    }),
  },
  stylelint = {
    cmd = 'stylelint',
    args = { '--formatter', 'json', '--stdin-filename', '%filepath' },
    stdin = true,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = function(output, bufnr)
      local decode = require('json').decode
      local messages = {}
      for _, file in ipairs(decode(output).files) do
        for _, msg in ipairs(file.warnings) do
          table.insert(messages, {
            lnum = msg.line - 1,
            col = msg.column - 1,
            severity = require('lint').severity[msg.severity] or require('lint').severity.ERROR,
            source = 'stylelint',
            message = msg.text,
          })
        end
      end
      return messages
    end,
  },
  htmlhint = {
    cmd = 'htmlhint',
    args = { '--format', 'json', '%filepath' },
    stdin = false,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = function(output, bufnr)
      local decode = require('json').decode
      local messages = {}
      for _, file in ipairs(decode(output)) do
        for _, msg in ipairs(file.messages) do
          table.insert(messages, {
            lnum = msg.line - 1,
            col = msg.column - 1,
            severity = require('lint').severity[msg.severity] or require('lint').severity.ERROR,
            source = 'htmlhint',
            message = msg.message,
          })
        end
      end
      return messages
    end,
  },
  markdownlint = {
    cmd = 'markdownlint',
    args = { '--stdin' },
    stdin = true,
    stream = 'stdout',
    ignore_exitcode = true,
    parser = require('lint.parser').from_errorformat('%f:%l %m,%f:%l %m', {
      source = 'markdownlint',
      severity = vim.diagnostic.severity.WARN,
    }),
  },
}

return lint
