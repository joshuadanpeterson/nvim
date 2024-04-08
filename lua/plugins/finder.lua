-- finder.lua
-- Fuzzy Finder (files, lsp, etc)
--[[
	custom.plugins.finder: Sets up file and content search tools within Neovim, such as Telescope or FZF. This includes configuring search behaviors, customizing the user interface, and defining keybindings for launching searches.
]]


return {

	-- Telescope
	-- Sets vim.ui.select to telescope. That means for example that neovim core stuff can fill the telescope picker
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},

	-- Fuzzy Finder Algorithm, requires local dependencies to be built. Only loads if make is available.
	{
		'nvim-telescope/telescope-fzf-native.nvim',
	},

	-- telescope-project: manage and switch between projects with telescope.
	{
		'nvim-telescope/telescope-project.nvim',
	},

	-- fzy native search
	{
		'nvim-telescope/telescope-fzy-native.nvim',
	},

	-- telescope-zoxide
	{
		'jvgrootveld/telescope-zoxide',
	},

	-- telescope-helpgrep.nvim
	{
		'catgoose/telescope-helpgrep.nvim',
	},

	-- telescope-repo: search filesystem for git repos
	{
		'cljoly/telescope-repo.nvim',
	},

	-- fzf vim: integrates the fzf command-line fuzzy finder with vim.
	{
		'junegunn/fzf.vim',
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},

	-- Telescope GPT: adds ChatGPT functionality to Telescope
	{
		'HPRIOR/telescope-gpt',
		dependencies = {
			'nvim-telescope/telescope.nvim',
			'jackMort/ChatGPT.nvim'
		},
	},

	-- tldr Telescope extension
	{
		'mrjones2014/tldr.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim' },
	},

	-- Fuzzy Finder (files, lsp, etc) with dependencies including plenary.nvim and telescope-ui-select.nvim
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
			'nvim-telescope/telescope-ui-select.nvim',
			'andrew-george/telescope-themes',
			'Lilja/telescope-swap-files',
		},
		config = function()
			require('telescope').setup {
				-- Your existing Telescope configuration
			}
		end,

	},

	-- Tmux Telescope Plugin
	{
		"shivamashtikar/tmuxjump.vim",
		dependencies = {
			"junegunn/fzf.vim", -- fzf.vim for fuzzy finding
			"nvim-telescope/telescope.nvim", -- telescope.nvim for enhanced searching
		},
		config = function()
			-- Optionally set tmuxjump to use Telescope
			vim.g.tmuxjump_telescope = true

			-- For specific file types, like purescript
			vim.cmd([[
			autocmd FileType purescript nnoremap <leader>ft :TmuxJumpFile purs<CR>
			autocmd FileType purescript nnoremap <leader>; :TmuxJumpFirst purs<CR>
		    ]])
		end
	},

	-- Ranger Neovim plugin
	{
		'kevinhwang91/rnvimr',
	},

	-- Flash.nvim
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
	},
}
