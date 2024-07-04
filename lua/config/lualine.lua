-- config/lualine.lua
--[[
    Customizes the status line in Neovim using the Lualine plugin. Configurations typically involve setting the appearance of the status line, choosing which components to display, and possibly integrating with other plugins for status information.
]]

-- Color for highlights
local colors = {
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
}

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

-- Set up theme
local nord = require 'lualine.themes.nord'

-- Define the lualine setup configuration
local config = {
  options = {
    icons_enabled = true,
    theme = nord,
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

-- lualine-lsp-progress config
-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
-- local function ins_right(component)
--   table.insert(config.sections.lualine_x, component)
-- end

ins_left {
  'lsp_progress',
  colors = {
    percentage = colors.cyan,
    title = colors.cyan,
    message = colors.cyan,
    spinner = colors.cyan,
    lsp_client_name = colors.magenta,
    use = true,
  },
  separators = {
    component = ' ',
    progress = ' | ',
    -- message = { pre = '(', post = ')' },
    percentage = { pre = '', post = '%% ' },
    title = { pre = '', post = ': ' },
    lsp_client_name = { pre = '[', post = ']' },
    spinner = { pre = '', post = '' },
    message = { commenced = 'In Progress', completed = 'Completed' },
  },
  display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
  timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
  spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
}
