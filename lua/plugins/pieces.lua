return {
  {
    'pieces-app/plugin_neovim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      'hrsh7th/nvim-cmp',
    },
    event = 'VeryLazy',
    build = ':UpdateRemotePlugins',
    config = function()
      -- Pieces for Neovim (optional)
      local ok_pieces, pieces_cfg = pcall(require, "pieces.config")
      if ok_pieces and pieces_cfg then
        pieces_cfg.host = "http://localhost:1000"
      end
    end,
  },
}
