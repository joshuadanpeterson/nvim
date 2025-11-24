-- init.lua
--  This script initializes Neovim with custom configurations and plugins.
--  It sets up lazy.nvim, legendary.nvim, and other plugins for a seamless development experience.

-- Custom configs
require 'config.settings' -- For basic Neovim settings
require 'config.compat.health_shim' -- Shim health API for Neovim 0.11+ (compat)
-- require("config.vim")      -- For vim config

-- Load lazy loading helpers
require 'config.lazy-loading-helpers'

-- lazy.nvim setup
-- lazy.nvim is a lazy-loading plugin manager for Neovim.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
local stat = (vim.uv or vim.loop).fs_stat(lazypath)
if not stat then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ configure plugins ]]
local lazy = require 'lazy'
lazy.setup({
  -- Your plugin setup goes here
  -- legendary.nvim configuration moved to lua/plugins/legendary.lua

  -- import custom plugins
  { import = 'plugins.ui' }, -- load ui file so nvim-nonicons module loads properly
  { import = 'plugins' },    -- load plugins
  -- load autocomplete
  { import = 'plugins.autocomplete' },

  -- lazy.nvim
  {
    'folke/lazy.nvim',
    lazy = true,  -- Lazy load the plugin
    cmd = 'Lazy', -- Load the plugin when the Lazy command is used
    opts = ({
      ui = {
        border = 'rounded', -- Set border style to rounded

        -- a number <1 is a percentage., >1 is a fixed size
        size = { width = 0.8, height = 0.8 },
        wrap = true, -- wrap the lines in the ui
        backdrop = 0,
        title = nil, ---@type string only works when border is not "none"
        title_pos = 'center', ---@type "center" | "left" | "right"
        -- Show pills on top of the Lazy window
        pills = true, ---@type boolean
        icons = {
          cmd = ' ',
          config = '',
          event = ' ',
          favorite = ' ',
          ft = ' ',
          init = ' ',
          import = ' ',
          keys = ' ',
          lazy = '󰒲 ',
          loaded = '●',
          not_loaded = '○',
          plugin = ' ',
          runtime = ' ',
          require = '󰢱 ',
          source = ' ',
          start = ' ',
          task = '✔ ',
          list = {
            '●',
            '➜',
            '★',
            '‒',
          },
        },
      },
    }),
  },
}, {
  performance = {
    cache = {
      enabled = true, -- Enable byte-compilation cache for faster startup
    },
    reset_packpath = true, -- Reset packpath to improve startup time
    rtp = {
      reset = true, -- Reset runtime path for better performance
      paths = {}, -- Add custom paths here if needed
      disabled_plugins = {
        -- Disable some built-in plugins for faster startup
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Plugin Manager Setup

-- Legendary setup moved to lua/plugins/legendary.lua


-- Codestats configuration moved to lua/plugins/codestats.lua

-- Pieces configuration moved to lua/plugins/pieces.lua

-- Delete temporary files
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    local tmp_files = vim.fn.glob("~/.local/state/nvim/shada/*.tmp*", true, true)
    for _, file in ipairs(tmp_files) do
      vim.fn.delete(file)
    end
  end,
})

-- Initialize logging system
-- Set up comprehensive logging with debug level for core plugins
local logging = require('config.logging')
local logging_utils = require('config.logging-utils')

-- Setup logging with debug mode enabled for testing
logging.setup({
  core_plugins_debug = true,
  default_log_level = 'debug'
})

-- Setup logging utilities (commands and keymaps)
logging_utils.setup()
