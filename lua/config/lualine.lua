-- config/lualine.lua
--[[
    Customizes the status line in Neovim using the Lualine plugin. Configurations typically involve setting the appearance of the status line, choosing which components to display, and possibly integrating with other plugins for status information.
]]

-- Setup nonicons
local icons = require 'nvim-nonicons'
local icon = icons.get 'git-branch'
local nonicons_extention = require 'nvim-nonicons.extentions.lualine'
local nonicons = nonicons_extention.mode

-- hydra
local function is_active()
  local ok, hydra = pcall(require, 'hydra.statusline')
  return ok and hydra.is_active()
end

local function get_name()
  local ok, hydra = pcall(require, 'hydra.statusline')
  if ok then
    return hydra.get_name()
  end
  return ''
end

-- variables
local branch = { 'branch', icon = '' }
local mode = { 'mode', icon = '󰡛' }
local diagnostics = { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ' }, colored = false }
local searchcount = { 'searchcount', maxcount = 999, timeout = 500 }
local datetime = {
  'datetime',
  fmt = function()
    return os.date '%Y-%m-%d %H:%M'
  end,
}

local filetype = { 'filetype', colored = true }

local copilot = {
  'copilot',
  symbols = {
    status = {
      icons = {
        enabled = ' ',
        sleep = ' ',
        disabled = ' ',
        warning = ' ',
        unknown = ' ',
      },
      hl = {
        enabled = '#50FA7B',
        sleep = '#AEB7D0',
        disabled = '#6272A4',
        warning = '#FFB86C',
        unknown = '#FF5555',
      },
    },
    spinners = require('copilot-lualine.spinners').dots,
    spinner_color = '#6272A4',
  },
  show_colors = true,
  show_loading = true,
}

local pluginUpdates = {
  require('lazy.status').updates,
  cond = require('lazy.status').has_updates,
  color = { fg = '#ff9e64' },
}

-- Harpoon
local Harpoonline = require 'harpoonline'
Harpoonline.setup {
  on_update = function()
    require('lualine').refresh()
  end,
}
local harpoonline = { Harpoonline.format, 'filename' }

-- Define the lualine setup configuration
local config = {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { nonicons, mode },
    lualine_b = {
      { 'filename', file_status = true, path = 1 },
      diagnostics,
      branch,
      'diff',
      { get_name, cond = is_active },
      -- 'grapple',
    },
    lualine_c = { harpoonline, searchcount },
    lualine_x = { 'encoding', filetype, copilot },
    lualine_y = { 'progress', 'location' },
    lualine_z = { pluginUpdates, icon, datetime },
  },
  inactive_sections = {
    lualine_a = { { 'filename', file_status = true, path = 1 }, 'diagnostics', 'diff' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'copilot' },
    lualine_z = { 'location' },
  },
  tabline = {},
}

-- Setup lualine with the defined configuration
require('lualine').setup(config)
