-- plugins/lint_and_autocomplete.lua
-- Sets up linting, autocomplete, and snippets for Neovim using Lua.

return {
  -- LuaSnip: A snippet engine for Neovim written in Lua
  { "L3MON4D3/LuaSnip" },

  -- luasnip completion source for nvim-cmp
  {
    "saadparwaiz1/cmp_luasnip",
    after = 'nvim-cmp', -- Corrected from 'afer' to 'after'
  },

  -- A collection of snippets for various programming languages
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
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
    after = 'nvim-cmp',
  },

  -- Asynchronous lint engine for syntax and error checking
  {
    "dense-analysis/ale",
    ft = { "javascript", "python", "rust", "go" },
  },

  -- Autocompletion plugin for Neovim that uses a modern architecture
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "onsails/lspkind.nvim",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "rafamadriz/friendly-snippets",
      "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = 'buffer' },
          { name = "emoji" },
          { name = 'vim-dadbod-completion' },
          { name = "path" },
        }),
      })
      cmp.setup.filetype({ "sql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      }
      )
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
          { name = "buffer" },
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

  -- ddc.vim - The next generation auto-completion framework for Neovim
  -- {
  --   "Shougo/ddc.vim",
  --   event = "InsertEnter",
  -- },

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
}
