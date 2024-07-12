-- plugins/init.lua
--[[
    `custom.plugins.init`: Serves as the central orchestrator for loading and initializing custom plugin configurations within Neovim. This file aggregates the various plugin setups listed under the `custom.plugins` directory, ensuring a structured and modular approach to configuring Neovim's environment. It acts as an entry point, selectively importing and executing the configurations for individual plugins such as themes, language support, user interface enhancements, and developer tools. By centralizing the plugin initialization process, `custom.plugins.init` facilitates easy management and updates to the Neovim setup, allowing for clear separation of concerns and streamlined organization of the editor's extended functionalities.
]]

local colorscheme = require 'plugins.colorscheme'
local copilot = require 'plugins.copilot'
local harpoon = require 'plugins.harpoon'
local lualine = require 'plugins.lualine'
local finder = require 'plugins.finder'
local git = require 'plugins.git'
local ui = require 'plugins.ui'
local utility = require 'plugins.utility'
local lsp = require 'plugins.lsp'
local obsidian = require 'plugins.obsidian'
local noice = require 'plugins.noice'
local autoformat = require 'plugins.autoformat'
local debug = require 'plugins.debug'
local which_key = require 'plugins.which-key'
local linters = require 'plugins.linters'
local autocomplete = require 'plugins.autocomplete'
local visuals = require 'plugins.visuals'
local markdown = require 'plugins.markdown'

return {
  colorscheme,
  copilot,
  harpoon,
  lualine,
  finder,
  git,
  ui, -- Ensure ui is loaded before utility
  utility,
  lsp,
  obsidian,
  noice,
  autoformat,
  debug,
  which_key,
  linters,
  autocomplete,
  visuals,
}
