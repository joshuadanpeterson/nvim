-- finder.lua
-- Fuzzy Finder (files, lsp, etc)
--[[
	custom.plugins.finder: Sets up file and content search tools within Neovim, such as Telescope or FZF. This includes configuring search behaviors, customizing the user interface, and defining keybindings for launching searches.
]]


return {

	-- Telescope
	-- Sets vim.ui.select to telescope. That means for example that neovim core stuff can fill the telescope picker
	{
		"nvim-telescope/telescope-ui-select.nvim"
	},

	-- Fuzzy Finder Algorithm, requires local dependencies to be built. Only loads if make is available.
	{
		'nvim-telescope/telescope-fzf-native.nvim'
	},

	-- telescope-project: manage and switch between projects with telescope.
	{
		'nvim-telescope/telescope-project.nvim'
	},

	-- fzf vim: integrates the fzf command-line fuzzy finder with vim.
	{
		'junegunn/fzf.vim'
	},

	-- Fuzzy Finder (files, lsp, etc) with dependencies including plenary.nvim and telescope-ui-select.nvim
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
	}
}