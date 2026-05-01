-- plugins/treesitter.lua

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
      },
    },
    config = function()
      require('config.treesitter')
    end,
  },

  -- For commenting in mixed contexts, such as JSX inside of HTML.
  {
    'joosepalviste/nvim-ts-context-commentstring',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('ts_context_commentstring').setup {
        enable = true,
        enable_autocmd = false,
      }
    end,
  },
}
