-- ui.lua
--[[
	custom.plugins.ui: Customizes overall user interface aspects of Neovim that aren't covered by the colorscheme or status line configurations. This might include settings for UI elements like tab bars, icons, window splitting behavior, and popup menus.
]]

return {
	-- nvim-web-devicons: adds filetype icons to neovim plugins.
	{
		'kyazdani42/nvim-web-devicons',
		lazy = true
	},

	-- nvim-nonicons: more icons
	{
		'yamatsum/nvim-nonicons',
		requires = {'kyazdani42/nvim-web-devicons'},
		config = function()
			require('nvim-nonicons').setup {}
		end,
	},

	-- -- vim-startify: provides a startup screen with session management.
	-- {
	-- 	'mhinz/vim-startify'
	-- },

	-- Standalone UI for Neovim LSP progress.
	{
		'j-hui/fidget.nvim',
		tag = "v1.0.0",
	},

	-- dressing.nvim - improves UI
	{
	  'stevearc/dressing.nvim',
	  opts = {},
	},

	-- Customizable Neovim dashboard for better startup experience.
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
						{ action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
						{ action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
						{ action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
						{ action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
						{ action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config", icon = " ", key = "c" },
						{ action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
						{ action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
						{ action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
						{ action = "qa", desc = " Quit", icon = " ", key = "q" },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return { "⚡ Neovim loaded " ..
						stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
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

	-- The Fine Command Line
	{
		'MunifTanjim/nui.nvim'
	},

	-- tmuxline
	{
		'edkolev/tmuxline.vim'
	},

}
