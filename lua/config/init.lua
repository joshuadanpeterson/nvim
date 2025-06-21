-- Load config files

-- Custom configs
local keymaps = require 'config.keymaps' -- For keybindings managed with which-key
local cmp = require 'config.cmp' -- For autocomplete config
local tmux = require 'config.tmux' -- For Tmux navigation
local conform = require 'config.conform' -- For conform.nvim
local telescope = require 'config.telescope' -- For Telescope
local lsp = require 'config.lsp' -- For LSP configurations
local linter = require 'config.linter' -- For linter configurations
local fidget = require 'config.fidget' -- For fidget configurations
local noice = require 'config.noice'
local lualine = require 'config.lualine'
local nvim_lint = require 'config.nvim-lint'
local markdown = require 'config.markdown'
local logging = require 'config.logging'
local logging_utils = require 'config.logging-utils'

return {
  keymaps,
  cmp,
  tmux,
  conform,
  telescope,
  lsp,
  linter,
  fidget,
  noice,
  lualine,
  nvim_lint,
  markdown,
}
