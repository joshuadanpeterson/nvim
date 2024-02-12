-- lint_and_autocomplete.lua
--[[
        custom.plugins.lint_and_autocomplete: Sets up linting and autocomplete functionalities, possibly through integration with LSP, completion plugins like nvim-cmp, and linters like ESLint or luacheck. Configurations would involve defining linting rules, setting up autocomplete sources, and customizing the UI for suggestions.
]]

-- Assuming this is part of a larger lazy.nvim setup file

-- Plugin installation and configuration
return {
  -- LuaSnip: A snippet engine for Neovim written in Lua
  { "L3MON4D3/LuaSnip" },

  -- luasnip completion source for nvim-cmp
  { "saadparwaiz1/cmp_luasnip" },

  -- A collection of snippets for various programming languages
  { "rafamadriz/friendly-snippets" },

  -- An asynchronous linting framework for Neovim
  { "mfussenegger/nvim-lint" },

  -- nvim-cmp source for Neovim's built-in LSP
  { "hrsh7th/cmp-nvim-lsp" },

  -- Asynchronous lint engine for syntax and error checking
  { "dense-analysis/ale" },

  -- Autocompletion plugin for Neovim that uses a modern architecture
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          -- Add more sources as needed
        }),
      })
    end
  },

  -- copilot-cmp for GitHub Copilot completions
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- ddc.vim - The next generation auto-completion framework for Neovim
  { "Shougo/ddc.vim" },

  -- cmp-cmdline for command line completion
  { "hrsh7th/cmp-cmdline" },

  -- Add more plugins as needed
}

