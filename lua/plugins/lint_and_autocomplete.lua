-- plugins/lint_and_autocomplete.lua
-- Sets up linting, autocomplete, and snippets for Neovim using Lua.

return {
  -- LuaSnip: A snippet engine for Neovim written in Lua
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",     -- luasnip completion source for nvim-cmp
      "rafamadriz/friendly-snippets", -- A collection of snippets for various programming languages
    },
    version = "v2.*",                 -- Follow latest release
    build = "make install_jsregexp"
  },

  -- An asynchronous linting framework for Neovim
  {
    "mfussenegger/nvim-lint",
    config = function()
      -- Configuration for nvim-lint can be added here
    end,
  },

  -- nvim-cmp source for Neovim's built-in LSP
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = {
      "hrsh7th/nvim-cmp",
    }
  },

  -- nvim-cmp-buffer-lines for buffer autocomplete
  {
    "amarakon/nvim-cmp-buffer-lines",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    },
  },

  -- Autocompletion plugin for Neovim that uses a modern architecture
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "amarakon/nvim-cmp-buffer-lines",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },

  -- nvim-cmp/cmp-buffer
  {
    "hrsh7th/cmp-buffer",
    config = function()
      require('cmp').setup({
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },

  -- nvim-cmp/cmp-path
  {
    "hrsh7th/cmp-path",
    config = function()
      require('cmp').setup({
        sources = {
          { name = "path" },
        },
      })
    end,
  },

  -- Adds VSCode-like pictograms
  {
    "onsails/lspkind-nvim",
    after = "nvim-cmp",
    config = function()
      require('lspkind').init()
    end,
  },

  -- copilot-cmp for GitHub Copilot completions
  {
    "zbirenbaum/copilot-cmp",
    after = "nvim-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- cmp-cmdline for command line completion
  {
    "hrsh7th/cmp-cmdline",
    after = "nvim-cmp",
  },

  -- Tailwind Colorizer
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      color_square_width = 2,
    },
  },

  -- null-ls.nvim
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint,
        },
      })
    end,
  },
}
