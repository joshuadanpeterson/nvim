-- init.lua


-- Custom configs
require('config.settings') -- For basic Neovim settings
require("config.vim")      -- For vim config

-- lazy.nvim setup
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
require('lazy').setup({
  -- note: first, some plugins that don't require any configuration

  -- legendary.nvim
  {
    'mrjones2014/legendary.nvim',
    -- since legendary.nvim handles all your keymaps/commands,
    -- its recommended to load legendary.nvim before other plugins
    priority = 10000,
    lazy = false,
    -- sqlite is only needed if you want to use frecency sorting
    dependencies = { 'kkharji/sqlite.lua' }
  },

  -- import custom plugins
  { import = 'custom.plugins' },
  { import = 'kickstart.plugins' },

})

-- Custom configs
require('config.keymaps')               -- For keybindings managed with which-key
require('config.cmp')                   -- For autocomplete config
require('config.tmux')                  -- For Tmux navigation
require('config.conform')               -- For conform.nvim
require('config.telescope')             -- For Telescope
require('config.lsp')                   -- For LSP configurations
require('config.linter')                -- For linter configurations
require('config.fidget')                -- For fidget configurations
require('kickstart.plugins.autoformat') -- For Kickstart Autoformat plugins
require('kickstart.plugins.debug')      -- For Kickstart Debug plugins

-- Plugin Manager Setup

-- Setup legendary.nvim
-- Automatically loads keymaps
require('legendary').setup({
  -- Initial keymaps to bind, can also be a function that returns the list
  keymaps = {},
  -- Initial commands to bind, can also be a function that returns the list
  commands = {},
  -- Initial augroups/autocmds to bind, can also be a function that returns the list
  autocmds = {},
  -- Initial functions to bind, can also be a function that returns the list
  funcs = {},
  -- Initial item groups to bind,
  -- note that item groups can also
  -- be under keymaps, commands, autocmds, or funcs;
  -- can also be a function that returns the list
  itemgroups = {},
  -- default opts to merge with the `opts` table
  -- of each individual item
  default_opts = {
    -- for example, { silent = true, remap = false }
    keymaps = {},
    -- for example, { args = '?', bang = true }
    commands = {},
    -- for example, { buf = 0, once = true }
    autocmds = {},
  },
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that returns a string.
  select_prompt = ' legendary.nvim ',
  -- Character to use to separate columns in the UI
  col_separator_char = '│',
  -- Optionally pass a custom formatter function. This function
  -- receives the item as a parameter and the mode that legendary
  -- was triggered from (e.g. `function(item, mode): string[]`)
  -- and must return a table of non-nil string values for display.
  -- It must return the same number of values for each item to work correctly.
  -- The values will be used as column values when formatted.
  -- See function `default_format(item)` in
  -- `lua/legendary/ui/format.lua` to see default implementation.
  default_item_formatter = nil,
  -- Customize icons used by the default item formatter
  icons = {
    -- keymap items list the modes in which the keymap applies
    -- by default, you can show an icon instead by setting this to
    -- a non-nil icon
    keymap = nil,
    command = '',
    fn = '󰡱',
    itemgroup = '',
  },
  -- Include builtins by default, set to false to disable
  include_builtin = true,
  -- Include the commands that legendary.nvim creates itself
  -- in the legend by default, set to false to disable
  include_legendary_cmds = true,
  -- Options for list sorting. Note that fuzzy-finders will still
  -- do their own sorting. For telescope.nvim, you can set it to use
  -- `require('telescope.sorters').fuzzy_with_index_bias({})` when
  -- triggered via `legendary.nvim`. Example config for `dressing.nvim`:
  --
  require('dressing').setup({
    select = {
      get_config = function(opts)
        if opts.kind == 'legendary.nvim' then
          return {
            telescope = {
              sorter = require('telescope.sorters').fuzzy_with_index_bias({})
            }
          }
        else
          return {}
        end
      end
    }
  }),
  sort = {
    -- put most recently selected item first, this works
    -- both within global and item group lists
    most_recent_first = true,
    -- sort user-defined items before built-in items
    user_items_first = true,
    -- sort the specified item type before other item types,
    -- value must be one of: 'keymap', 'command', 'autocmd', 'group', nil
    item_type_bias = nil,
    -- settings for frecency sorting.
    -- https://en.wikipedia.org/wiki/Frecency
    -- Set `frecency = false` to disable.
    -- this feature requires sqlite.lua (https://github.com/kkharji/sqlite.lua)
    -- and will be automatically disabled if sqlite is not available.
    -- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
    frecency = {
      -- the directory to store the database in
      db_root = string.format('%s/legendary/', vim.fn.stdpath('data')),
      -- the maximum number of timestamps for a single item
      -- to store in the database
      max_timestamps = 10,
    },
  },
  -- Which extensions to load; no extensions are loaded by default.
  -- Setting the plugin name to `false` disables loading the extension.
  -- Setting it to any other value will attempt to load the extension,
  -- and pass the value as an argument to the extension, which should
  -- be a single function. Extensions are modules under `legendary.extensions.*`
  -- which return a single function, which is responsible for loading and
  -- initializing the extension.
  extensions = {
    nvim_tree = false,
    smart_splits = false,
    op_nvim = false,
    diffview = false,
    lazy_nvim = true,
    which_key = {
      -- Automatically add which-key tables to legendary
      -- see ./doc/WHICH_KEY.md for more details
      auto_register = true,
      -- you can put which-key.nvim tables here,
      -- or alternatively have them auto-register,
      -- see ./doc/WHICH_KEY.md
      mappings = {},
      opts = {},
      -- controls whether legendary.nvim actually binds they keymaps,
      -- or if you want to let which-key.nvim handle the bindings.
      -- if not passed, true by default
      do_binding = true,
      -- controls whether to use legendary.nvim item groups
      -- matching your which-key.nvim groups; if false, all keymaps
      -- are added at toplevel instead of in a group.
      use_groups = true,
    }
  },
  scratchpad = {
    -- How to open the scratchpad buffer,
    -- 'current' for current window, 'float'
    -- for floating window
    view = 'float',
    -- How to show the results of evaluated Lua code.
    -- 'print' for `print(result)`, 'float' for a floating window.
    results_view = 'float',
    -- Border style for floating windows related to the scratchpad
    float_border = 'rounded',
    -- Whether to restore scratchpad contents from a cache file
    keep_contents = true,
  },
  -- Directory used for caches
  cache_path = string.format('%s/legendary/', vim.fn.stdpath('cache')),
  -- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
  log_level = 'info',
})

-- Setup neovim lua configuration
require('neodev').setup()

-- multicursors.nvim Status Line module
require('multicursors').setup {
  hint_config = false,
}

-- CODESTATS_API_KEY
local codestats_api_key = os.getenv("CODESTATS_API_KEY")
assert(codestats_api_key ~= nil, "CODESTATS_API_KEY is not set")
require('codestats-nvim').setup({
  token = codestats_api_key
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
