-- finder.lua
-- Fuzzy Finder (files, lsp, etc)
--[[
	custom.plugins.finder: Sets up file and content search tools within Neovim, such as Telescope or FZF. This includes configuring search behaviors, customizing the user interface, and defining keybindings for launching searches.
]]

return {

  -- Telescope UI Select
  {
    'nvim-telescope/telescope-ui-select.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Fuzzy Finder Algorithm
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1,
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Telescope Project
  {
    'nvim-telescope/telescope-project.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Fzy Native Search
  {
    'nvim-telescope/telescope-fzy-native.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Telescope Zoxide
  {
    'jvgrootveld/telescope-zoxide',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Telescope Helpgrep
  {
    'catgoose/telescope-helpgrep.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Telescope Repo
  {
    'cljoly/telescope-repo.nvim',
    lazy = true,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },

  -- Fzf Vim
  {
    'junegunn/fzf.vim',
    cmd = 'Fzf',
    dependencies = {
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'Telescope',
      },
    },
  },

  -- Telescope GPT
  {
    'HPRIOR/telescope-gpt',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'jackMort/ChatGPT.nvim',
    },
    lazy = true,
  },

  -- Tldr Telescope Extension
  {
    'mrjones2014/tldr.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    lazy = true,
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
      'nvim-telescope/telescope-ui-select.nvim',
      'andrew-george/telescope-themes',
      'Lilja/telescope-swap-files',
      'tsakirist/telescope-lazy.nvim',
      'Myzel394/jsonfly.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope-media-files.nvim',
    },
    cmd = 'Telescope',
    config = function()
      require('config.telescope')
    end,
  },

  -- Tmux Telescope Plugin
  {
    'shivamashtikar/tmuxjump.vim',
    dependencies = {
      'junegunn/fzf.vim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      vim.g.tmuxjump_telescope = true
      vim.cmd [[
        autocmd FileType purescript nnoremap <leader>ft :TmuxJumpFile purs<CR>
        autocmd FileType purescript nnoremap <leader>; :TmuxJumpFirst purs<CR>
      ]]
    end,
  },

  -- Ranger Neovim Plugin
  {
    'kevinhwang91/rnvimr',
    cmd = 'RnvimrToggle',
  },

  -- Flash.nvim
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },
}
