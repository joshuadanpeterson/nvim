-- Treesitter configuration
-- config/treesitter.lua

-- Set this to true to skip the deprecated module loading for context_commentstring
vim.g.skip_ts_context_commentstring_module = true

require 'plugins.treesitter'

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'comment',
    'csv',
    'dockerfile',
    'dart',
    'go',
    'graphql',
    'http',
    'htmldjango',
    'json',
    'jq',
    'markdown',
    'php',
    'regex',
    'scss',
    'toml',
    'xml',
    'yaml',
    'c',
    'lua',
    'vimdoc',
    'vim',
    'python',
    'html',
    'css',
    'javascript',
    'jsx',
    'typescript',
    'tsx',
    'latex',
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  sync_install = true,

  additional_vim_regex_highlighting = false,

  autotag = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes from source code
    persist_queries = false, -- Persist queries across sessions
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight other brackets/parentheses
  },
  -- Which query to use for finding delimiters
  query = 'rainbow-parens',
  -- Highlight the entire buffer all at once
  strategy = require('ts-rainbow').strategy.global,
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<C-bs>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['a='] = { query = '@assignment.outer', desc = 'Select outer part of an assignment' },
        ['i='] = { query = '@assignment.inner', desc = 'Select inner part of an assignment' },
        ['l='] = { query = '@assignment.lhs', desc = 'Select left hand side of an assignment' },
        ['r='] = { query = '@assignment.rhs', desc = 'Select right hand side of an assignment' },

        ['aa'] = { query = '@parameter.outer', desc = 'Select outer part of a parameter/argument' },
        ['ia'] = { query = '@parameter.inner', desc = 'Select inner part of a parameter/argument' },

        ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
        ['ii'] = { query = '@conditional.inner', desc = 'Select inner part of a conditional' },

        ['al'] = { query = '@loop.outer', desc = 'Select outer part of a loop' },
        ['il'] = { query = '@loop.inner', desc = 'Select inner part of a loop' },

        ['af'] = { query = '@call.outer', desc = 'Select outer part of a function call' },
        ['if'] = { query = '@call.inner', desc = 'Select inner part of a function call' },

        ['am'] = { query = '@function.outer', desc = 'Select outer part of a method/function definition' },
        ['im'] = { query = '@function.inner', desc = 'Select inner part of a method/function definition' },

        ['ac'] = { query = '@class.outer', desc = 'Select outer part of a class' },
        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class' },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>Sa'] = { '@parameter.inner', desc = 'Swap parameters/argument with next' },
        ['<leader>Sf'] = { '@function.outer', desc = 'Swap function with next' },
      },
      swap_previous = {
        ['<leader>SA'] = { '@parameter.inner', desc = 'Swap parameters/argument with prev' },
        ['<leader>SF'] = { '@function.outer', desc = 'Swap function with previous' },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = { query = '@call.outer', desc = 'Next function call start' },
        [']m'] = { query = '@function.outer', desc = 'Next method/function def start' },
        [']c'] = { query = '@class.outer', desc = 'Next class start' },
        [']i'] = { query = '@conditional.outer', desc = 'Next conditional start' },
        [']l'] = { query = '@loop.outer', desc = 'Next loop start' },

        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        [']s'] = { query = '@scope', query_group = 'locals', desc = 'Next scope' },
        [']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
      },
      goto_next_end = {
        [']F'] = { query = '@call.outer', desc = 'Next function call end' },
        [']M'] = { query = '@function.outer', desc = 'Next method/function def end' },
        [']C'] = { query = '@class.outer', desc = 'Next class end' },
        [']I'] = { query = '@conditional.outer', desc = 'Next conditional end' },
        [']L'] = { query = '@loop.outer', desc = 'Next loop end' },
      },
      goto_previous_start = {
        ['[f'] = { query = '@call.outer', desc = 'Prev function call start' },
        ['[m'] = { query = '@function.outer', desc = 'Prev method/function def start' },
        ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
        ['[i'] = { query = '@conditional.outer', desc = 'Prev conditional start' },
        ['[l'] = { query = '@loop.outer', desc = 'Prev loop start' },
      },
      goto_previous_end = {
        ['[F'] = { query = '@call.outer', desc = 'Prev function call end' },
        ['[M'] = { query = '@function.outer', desc = 'Prev method/function def end' },
        ['[C'] = { query = '@class.outer', desc = 'Prev class end' },
        ['[I'] = { query = '@conditional.outer', desc = 'Prev conditional end' },
        ['[L'] = { query = '@loop.outer', desc = 'Prev loop end' },
      },
    },
  },
}

-- Setup ts_context_commentstring
require('ts_context_commentstring').setup {}

-- Get Treesitter to support embeded languages
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.tsx.used_by = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html' }
