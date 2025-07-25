-- ui.lua
--[[
	custom.plugins.ui: Customizes overall user interface aspects of Neovim that aren't covered by the colorscheme or status line configurations. This might include settings for UI elements like tab bars, icons, window splitting behavior, and popup menus.
]]

return {
  -- nvim-web-devicons: adds filetype icons to neovim plugins
  {
    'kyazdani42/nvim-web-devicons',
    event = 'BufReadPre',
  },

  -- nvim-nonicons: more icons
  {
    'yamatsum/nvim-nonicons',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    event = 'BufReadPre',
    config = function()
      require('nvim-nonicons').setup {}
    end,
  },

  -- fidget.nvim configuration moved to fidget.lua

  -- dressing.nvim - improves UI
  {
    'stevearc/dressing.nvim',
    event = 'BufReadPre',
    opts = {
      input = {
        border = 'rounded',
      },
      select = {
        get_config = function(opts)
          if opts.kind == 'legendary.nvim' then
            return {
              telescope = {
                sorter = require('telescope.sorters').fuzzy_with_index_bias {},
              },
            }
          else
            return {}
          end
        end,
      },
    },
  },

  -- Customizable Neovim dashboard for better startup experience
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function()
      local logo = [[
::::    ::: ::::::::::  ::::::::  :::     ::: ::::::::::: ::::    ::::
:+:+:   :+: :+:        :+:    :+: :+:     :+:     :+:     +:+:+: :+:+:+
:+:+:+  +:+ +:+        +:+    +:+ +:+     +:+     +:+     +:+ +:+:+ +:+
+#+ +:+ +#+ +#++:++#   +#+    +:+ +#+     +:+     +#+     +#+  +:+  +#+
+#+  +#+#+# +#+        +#+    +#+  +#+   +#+      +#+     +#+       +#+
#+#   #+#+# #+#        #+#    #+#   #+#+#+#       #+#     #+#       #+#
###    #### ##########  ########      ###     ########### ###       ###
      ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'

      local opts = {
        theme = 'doom',
        hide = {
          statusline = false,
        },
        config = {
          header = vim.split(logo, '\n'),
          center = {
            { action = 'Telescope find_files', desc = ' Find file', icon = ' ', key = 'f' },
            { action = 'ene | startinsert', desc = ' New file', icon = ' ', key = 'n' },
            { action = 'Telescope oldfiles', desc = ' Recent files', icon = ' ', key = 'r' },
            { action = 'Telescope live_grep', desc = ' Find text', icon = ' ', key = 'g' },
            {
              action = function()
                vim.cmd('cd /Users/joshpeterson/.config/nvim')
                vim.cmd('edit init.lua')
                vim.notify("Changed to Neovim config")
                require('config.keymaps').setup()
              end,
              desc = ' Neovim Config',
              icon = ' ',
              key = 'c'
            },

            {
              action = function()
                vim.cmd('cd /Users/joshpeterson/.config/tmux')
                vim.cmd('edit .tmux.conf')
                vim.notify("Changed to Tmux config")
                require('config.keymaps').setup()
              end,
              desc = ' Tmux Config',
              icon = ' ',
              key = 't'
            },

            {
              action = function()
                vim.cmd('cd /Users/joshpeterson/.config/zsh-config/')
                vim.cmd('edit .zshrc')
                vim.notify("Changed to Zsh config")
                require('config.keymaps').setup()
              end,
              desc = ' Zsh Config',
              icon = ' ',
              key = 'z'
            },
            { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's' },
            { action = 'LazyExtras', desc = ' Lazy Extras', icon = ' ', key = 'x' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'Leet', desc = ' LeetCode', icon = ' ', key = 'd' },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Blogging | edit . | lua vim.notify("Changed working directory to Obsidian Blogging Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Blogging Vault',
              icon = ' ',
              key = 'b'
            },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Crypto | edit . | lua vim.notify("Changed working directory to Obsidian Crypto Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Crypto Vault',
              icon = ' ',
              key = 'C'
            },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Journals | edit . | lua vim.notify("Changed working directory to Obsidian Journal Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Journal Vault',
              icon = ' ',
              key = 'j'
            },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Poetry | edit . | lua vim.notify("Changed working directory to Obsidian Poetry Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Poetry Vault',
              icon = ' ',
              key = 'P'
            },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Programming | edit . | lua vim.notify("Changed working directory to Obsidian Programming Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Programming Vault',
              icon = ' ',
              key = 'p'
            },

            {
              action =
              [[lua vim.cmd('cd /Users/joshpeterson/Dropbox/DropsyncFiles/Obsidian Vault/Udemy/| edit . | lua vim.notify("Changed working directory to Obsidian Udemy Vault"); require("config.keymaps").setup()')]],
              desc = ' Open Udemy Vault',
              icon = ' ',
              key = 'u'
            },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },

  -- tmuxline
  {
    'edkolev/tmuxline.vim',
    event = { 'VimEnter', 'BufReadPre' },
  },
}
