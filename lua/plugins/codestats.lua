return {
  {
    'nyaa8/codestats.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- CODESTATS_API_KEY
      local codestats_api_key = os.getenv 'CODESTATS_API_KEY'
      assert(codestats_api_key ~= nil, 'CODESTATS_API_KEY is not set')
      require('codestats').setup {
        token = codestats_api_key,
      }
    end,
  },
}
