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
                vim.cmd('cd ' .. vim.fn.stdpath('config'))
                vim.cmd('edit init.lua')
                vim.notify("Changed to Neovim config")
                require('config.keymaps').setup()
              end,
              desc = ' Neovim Config',
              icon = ' ',
              key = 'c'
            },

            {
              action = function()
                local tmux = vim.fn.expand('~') .. '/.config/tmux'
                if vim.fn.isdirectory(tmux) == 1 then
                  vim.cmd('cd ' .. tmux)
                  vim.cmd('edit .tmux.conf')
                  vim.notify("Changed to Tmux config")
                  require('config.keymaps').setup()
                end
              end,
              desc = ' Tmux Config',
              icon = ' ',
              key = 't'
            },

            {
              action = function()
                local z = vim.fn.expand('~') .. '/.config/zsh-config'
                if vim.fn.isdirectory(z) == 1 then
                  vim.cmd('cd ' .. z)
                  vim.cmd('edit .zshrc')
                  vim.notify("Changed to Zsh config")
                  require('config.keymaps').setup()
                end
              end,
              desc = ' Zsh Config',
              icon = ' ',
              key = 'z'
            },
            { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's' },
            { action = 'LazyExtras', desc = ' Lazy Extras', icon = ' ', key = 'x' },
            { action = 'Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'Leet', desc = ' LeetCode', icon = ' ', key = 'd' },

            {
              action = (function()
                local v = vim.fn.expand('~') .. '/Dropbox/DropsyncFiles/Obsidian Vault/main'
                if vim.fn.isdirectory(v) == 1 then
                  return [[lua vim.cmd('cd ]] .. v .. [[ | edit . | lua vim.notify("Changed working directory to Obsidian main Vault"); require("config.keymaps").setup()')]]
                end
                return 'echo'
              end)(),
              desc = ' Open main Vault',
              icon = ' ',
              key = 'b'
            },

            {
              action = (function()
                local v = vim.fn.expand('~') .. '/Dropbox/DropsyncFiles/Obsidian Vault/genealogy'
                if vim.fn.isdirectory(v) == 1 then
                  return [[lua vim.cmd('cd ]] .. v .. [[ | edit . | lua vim.notify("Changed working directory to Obsidian genealogy Vault"); require("config.keymaps").setup()')]]
                end
                return 'echo'
              end)(),
              desc = ' Open genealogy Vault',
              icon = ' ',
              key = 'C'
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
