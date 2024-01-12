-- ~/.config/nvim/custom/plugins.lua

-- Return statement for plugins
return {

    -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
	'nvim-telescope/telescope-fzf-native.nvim',
	-- NOTE: If you are having trouble with this installation,
	--       refer to the README for telescope-fzf-native for more instructions.
	build = 'make',
	cond = function()
	  return vim.fn.executable 'make' == 1
	end,
      },
      {
        "nvim-telescope/telescope-ui-select.nvim"
      }
    },
  },

  -- LuaSnip:
    {
    'L3MON4D3/LuaSnip',
    },

    -- ripgrep config
    {
    'burntsushi/ripgrep'
    },

    -- fd config
    {
    'sharkdp/fd'
    },

    -- nvim-lint
    {
    'mfussenegger/nvim-lint',
    },
      -- git related plugins
    {
    'tpope/vim-fugitive',
    },
    {
    'tpope/vim-rhubarb',
    },

    -- gitgutter: displays git diff markers in the sign column.
    { 'airblade/vim-gitgutter' },

    -- nvim-cmp
    {
    'hrsh7th/cmp-nvim-lsp',
    },

    -- add plenary.nvim
    {
    'nvim-lua/plenary.nvim',
    },

    -- adding nvim-ts-autotag
    {
    'windwp/nvim-ts-autotag',
        config = function()
          require('nvim-ts-autotag').setup()
        end,
        },

        -- autopairs: automatically pairs brackets, quotes, etc.
        { 'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup({}) end,
        },

        -- vim-surround: easily manage pairs like brackets, quotes in your text.
        { 'tpope/vim-surround' },

        -- nvim-tree: a modern file explorer written in lua.
	{
	    'kyazdani42/nvim-tree.lua',
	    requires = {
		'kyazdani42/nvim-web-devicons', -- optional, for file icons
	    },
	    tag = 'nightly' -- optional, updated every week. (see issue #1193)
	},

        -- fzf vim: integrates the fzf command-line fuzzy finder with vim.
        { 'junegunn/fzf.vim' },

        -- vim-startify: provides a startup screen with session management.
        { 'mhinz/vim-startify' },

        -- vim-commentary: efficient commenting in vim, toggle comments easily.
        { 'tpope/vim-commentary' },

        -- coc.nvim: intellisense engine with support for lsp and more.
        { 'neoclide/coc.nvim', branch = 'release' },

        -- ale: asynchronous lint engine for syntax and error checking.
        { 'dense-analysis/ale' },

        -- nvim-web-devicons: adds filetype icons to neovim plugins.
        { 'kyazdani42/nvim-web-devicons', lazy = true },

        -- vim-sneak: minimalist motion plugin to jump to any location in file.
        { 'justinmk/vim-sneak' },

        -- telescope-project: manage and switch between projects with telescope.
        { 'nvim-telescope/telescope-project.nvim' },

        -- indentline: display vertical lines at each indentation level.
        { 'yggdroot/indentline' },

        -- adding nvim-treesitter/playground
        {
        'nvim-treesitter/playground',
        cmd = "Tsplaygroundtoggle",
        },
        {
        'hiphish/nvim-ts-rainbow2',
        },

        -- detect tabstop and shiftwidth automatically
        {
        'tpope/vim-sleuth',
        },
        -- note: this is where your plugins related to lsp can be installed.
        --  the configuration is done below. search for lspconfig to find it below.
        -- lsp configuration & plugins
        {
        'neovim/nvim-lspconfig',
        -- optional: configuration for nvim-lspconfig
        config = function()
          -- your lspconfig setup here
        end,
        },

        -- treesitter
        {
        {'nvim-treesitter/nvim-treesitter', run = ':Tsupdate'},
        },

        {
        'williamboman/mason.nvim',
        -- optional: configuration for mason.nvim
        config = function()
          -- your mason setup here
        end,
        },

        {
        'williamboman/mason-lspconfig.nvim',
        -- optional: configuration for mason-lspconfig.nvim
        },

        {
        'j-hui/fidget.nvim',
        -- optional: configuration for fidget.nvim
        config = function()
          require('fidget').setup({})
        end,
        },

        {
        'folke/neodev.nvim',
        -- optional: configuration for neodev.nvim
        },

        {
        'numtostr/Comment.nvim',
        config = function()
          require('Comment').setup({
            -- optional configuration here
            padding = true,
            sticky = true,
            ignore = '^$',
            mappings = {
              basic = true,
              extra = true,
              extended = false,
            },
            toggler = {
              line = 'gcc', -- toggle line comment
              block = 'gbc', -- toggle block comment
            },
            opleader = {
              line = 'gc', -- line comment operation
              block = 'gb', -- block comment operation
             },
          })
        end,
        },

        {
        -- autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
          -- snippet engine & its associated nvim-cmp source
          'l3mon4d3/luasnip',
          'saadparwaiz1/cmp_luasnip',

          -- adds lsp completion capabilities
          'hrsh7th/cmp-nvim-lsp',

          -- adds a number of user-friendly snippets
          'rafamadriz/friendly-snippets',
        },


        -- install telescope
        {
         'nvim-telescope/telescope.nvim',
         requires = { {'nvim-lua/plenary.nvim'} }
        },

        -- lualine configuration
        {
         'nvim-lualine/lualine.nvim',
         event = 'bufreadpre',
         config = function()
            vim.keymap.set('n', '<leader>l', ':lua require("lualine").refresh<cr>', {desc = 'refresh status line'})
           require('lualine').setup {
             opts = {
               options = {
                 icons_enabled = true,
                 theme = 'nord',
                 component_separators = '|',
                 section_separators = '',
               },
               sections = {
          lualine_a = {'mode'},
          lualine_b = {
            {
              'filename',
              file_status = true,
              path = 1,
            },
            'diagnostics',
            'branch',
            'diff',
          },
          lualine_c = {
            {
              'searchcount',
              maxcount = 999,
              timeout = 500,
            }
          },
          lualine_x = {
            {
              'datetime',
              style = '%h:%m:%s',
            },
            'encoding',
            {
              'filetype',
              colored = true,
            },
          },
          lualine_y = {'progress'},
          lualine_z = {'location'},
        },
        inactive_sections = {
          lualine_a = {
            {
              'filename',
              file_status = true,
              path = 1,
            },
            'diagnostics',
            'diff',
          },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {'location'},
        },
        tabline = {},
           }}
         end,
        },

        },

        -- useful plugin to show you pending keybinds.
        { 'folke/which-key.nvim',
          opts = function(_, opts)
            if require("lazyvim.util").has("noice.nvim") then
              opts.defaults["<leader>sn"] = { name = "+noice" }
            end
          end
        },

        {
        -- adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
          -- see `:help gitsigns.txt`
          signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
          },
          on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'preview git hunk' })

            -- don't override the built-in and fugitive keymaps
            local gs = package.loaded.gitsigns
            vim.keymap.set({ 'n', 'v' }, ']c', function()
              if vim.wo.diff then
                return ']c'
              end
              vim.schedule(function()
                gs.next_hunk()
              end)
              return '<ignore>'
            end, { expr = true, buffer = bufnr, desc = 'jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
              if vim.wo.diff then
                return '[c'
              end
              vim.schedule(function()
                gs.prev_hunk()
              end)
              return '<ignore>'
            end, { expr = true, buffer = bufnr, desc = 'jump to previous hunk' })
          end,
        },
    },
    
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function()
        local logo = [[
             ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
             ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
             ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
             ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
             ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
             ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
        ]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
          theme = "doom",
          hide = {
            -- this is taken care of by lualine
            -- enabling this messes up the actual laststatus setting after loading a file
            statusline = false,
          },
          config = {
            header = vim.split(logo, "\n"),
            -- stylua: ignore
            center = {
              { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "f" },
              { action = "ene | startinsert",                                        desc = " New file",        icon = " ", key = "n" },
              { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
              { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "g" },
              { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
              { action = 'lua require("persistence").load()',                        desc = " Restore Session", icon = " ", key = "s" },
              { action = "LazyExtras",                                               desc = " Lazy Extras",     icon = " ", key = "x" },
              { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
              { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
            },
            footer = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
          },
        }

        for _, button in ipairs(opts.config.center) do
          button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
          button.key_format = "  %s"
        end

        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
          vim.cmd.close()
          vim.api.nvim_create_autocmd("User", {
            pattern = "DashboardLoaded",
            callback = function()
              require("lazy").show()
            end,
          })
        end

        return opts
      end,
    },

    -- Transparent Nord Theme
    {
      'shaunsingh/nord.nvim',
      config = function()
        -- load the theme
        vim.cmd('colorscheme nord')
	require('nord').set({
	  transparent = true,
	  styles = {
		  sidebars = "transparent",
		  floats = "transparent",
	    },

	  })
	end
     },

    -- Transparent Background
    {
      "tribela/vim-transparent"
    },
     {
       "LazyVim/LazyVim",
       opts = {
         colorscheme = "nord",
       },
    },
    -- Using harpoon2
	{
	  "ThePrimeagen/harpoon",
	  branch = "harpoon2",
	  dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-telescope/telescope-project.nvim",
            "nvim-telescope/telescope-ui-select.nvim"
	  },
	  config = function()
	    local harpoon = require('harpoon')
	    harpoon:setup({})

	    -- Set keymaps
            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Add Harpoon File" })
            vim.keymap.set("n", "<leader>d", function() harpoon:list():remove() end, { desc = "Delete Harpoon File" })
            vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Previous Harpoon File"})
            vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Next Harpoon File"})
            vim.keymap.set("n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon Quick Menu" })
            for i = 1, 9 do
              vim.keymap.set("n", "<leader>"..i, function() harpoon:list():select(i) end, { desc = "Harpoon to File " .. i })
	    end
	  end
	}

}

