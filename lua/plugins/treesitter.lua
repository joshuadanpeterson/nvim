-- plugins/treesitter.lua
--[[
        custom.plugins.treesitter: Configures Neovim's integration with Tree-sitter, an incremental parsing system that enhances syntax highlighting, code navigation, and various code analysis features. This file tailors the Tree-sitter setup to suit specific development workflows, including defining language parsers to install, enabling syntax-aware code editing features like indentation and folding, and customizing highlight groups for improved readability. Additional configurations may involve setting up Tree-sitter based code navigation shortcuts, enabling language-specific features such as automatic tag closing or context-aware commenting, and integrating with other plugins that leverage Tree-sitter's parsing capabilities for advanced code analysis and manipulation tasks. Through custom.plugins.treesitter, users can vastly improve their coding experience in Neovim by leveraging the power of Tree-sitter's fine-grained understanding of code structure.
]]

return {
  -- nvim-treesitter for enhanced syntax highlighting and additional language features
  {
    'nvim-treesitter/nvim-treesitter',
    -- Avoid run = ':TSUpdate' to prevent blocking on startup
    -- Instead, run updates via Mason or a separate command
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      -- Load the actual Treesitter configuration
      require('config.treesitter')
    end,
  },

  -- nvim-treesitter/playground to explore Treesitter queries in a UI
  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        playground = {
          enable = true,
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o', -- Open the query editor
            toggle_hl_groups = 'i', -- Toggle highlight groups
            toggle_injected_languages = 't', -- Toggle injected languages
            toggle_anonymous_nodes = 'a', -- Toggle anonymous nodes
            toggle_language_display = 'I', -- Toggle language display
            focus_language = 'f', -- Focus on the language under the cursor
            unfocus_language = 'F', -- Unfocus the language
            update = 'R', -- Update the Playground view
            goto_node = '<cr>', -- Go to the node in the source code
            show_help = '?', -- Show help menu
          },
        },
      }
    end,
  },

  -- nvim-treesitter-textobjects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
              ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
              ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
              ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },
              ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
              ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },
              ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
              ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },
              ['af'] = { query = '@function.outer', desc = 'Select outer part of a function call' },
              ['if'] = { query = '@function.inner', desc = 'Select inner part of a function call' },
              ['am'] = { query = '@method.outer', desc = 'Select outer part of a method/function def' },
              ['im'] = { query = '@method.inner', desc = 'Select inner part of a method/function def' },
              ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
            },
          },
        },
      }
    end,
  },

  -- For commenting in mixed contexts, such as JSX inside of HTML
  {
    'joosepalviste/nvim-ts-context-commentstring',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('ts_context_commentstring').setup {
        enable = true,
        enable_autocmd = false,
      }
    end,
  },
}
