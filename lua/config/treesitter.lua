-- Treesitter configuration
-- config/treesitter.lua

local languages = {
  'bash',
  'c',
  'comment',
  'csv',
  'css',
  'dart',
  'dockerfile',
  'go',
  'graphql',
  'html',
  'htmldjango',
  'http',
  'javascript',
  'jq',
  'json',
  'latex',
  'lua',
  'markdown',
  'php',
  'python',
  'regex',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}

if vim.fn.executable('tree-sitter') == 0 and vim.fn.executable('/usr/local/bin/tree-sitter') == 1 then
  vim.env.PATH = '/usr/local/bin:' .. vim.env.PATH
end

local parsers = require('nvim-treesitter.parsers')
local strudel_parser = {
  install_info = {
    path = '/Users/joshpeterson/Dropbox/programming/projects/strudel/tree-sitter-strdl',
    queries = 'queries',
  },
}
parsers.strudel = strudel_parser

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    parsers.strudel = strudel_parser
  end,
})

vim.api.nvim_create_user_command('TSInstallConfigured', function()
  require('nvim-treesitter').install(languages):wait(300000)
end, { desc = 'Install configured Treesitter parsers' })

local filetypes = {
  'bash',
  'c',
  'comment',
  'csv',
  'css',
  'dart',
  'dockerfile',
  'go',
  'graphql',
  'html',
  'htmldjango',
  'http',
  'javascript',
  'javascriptreact',
  'jq',
  'json',
  'latex',
  'lua',
  'markdown',
  'php',
  'python',
  'regex',
  'scss',
  'strudel',
  'strdl',
  'str',
  'toml',
  'typescript',
  'typescriptreact',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.treesitter.language.register('javascript', 'javascriptreact')
vim.treesitter.language.register('javascript', 'jsx')
vim.treesitter.language.register('tsx', 'typescriptreact')
vim.treesitter.language.register('strudel', { 'strdl', 'str' })

local ts_select = require('nvim-treesitter-textobjects.select')
local ts_swap = require('nvim-treesitter-textobjects.swap')
local ts_move = require('nvim-treesitter-textobjects.move')

require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
}

local function map_textobject(keys, query, desc)
  vim.keymap.set({ 'x', 'o' }, keys, function()
    ts_select.select_textobject(query, 'textobjects')
  end, { desc = desc })
end

map_textobject('a=', '@assignment.outer', 'Select outer part of an assignment')
map_textobject('i=', '@assignment.inner', 'Select inner part of an assignment')
map_textobject('l=', '@assignment.lhs', 'Select left hand side of an assignment')
map_textobject('r=', '@assignment.rhs', 'Select right hand side of an assignment')
map_textobject('aa', '@parameter.outer', 'Select outer part of a parameter/argument')
map_textobject('ia', '@parameter.inner', 'Select inner part of a parameter/argument')
map_textobject('ai', '@conditional.outer', 'Select outer part of a conditional')
map_textobject('ii', '@conditional.inner', 'Select inner part of a conditional')
map_textobject('al', '@loop.outer', 'Select outer part of a loop')
map_textobject('il', '@loop.inner', 'Select inner part of a loop')
map_textobject('af', '@call.outer', 'Select outer part of a function call')
map_textobject('if', '@call.inner', 'Select inner part of a function call')
map_textobject('am', '@function.outer', 'Select outer part of a method/function definition')
map_textobject('im', '@function.inner', 'Select inner part of a method/function definition')
map_textobject('ac', '@class.outer', 'Select outer part of a class')
map_textobject('ic', '@class.inner', 'Select inner part of a class')

vim.keymap.set('n', '<leader>Sa', function()
  ts_swap.swap_next('@parameter.inner')
end, { desc = 'Swap parameters/argument with next' })

vim.keymap.set('n', '<leader>Sf', function()
  ts_swap.swap_next('@function.outer')
end, { desc = 'Swap function with next' })

vim.keymap.set('n', '<leader>SA', function()
  ts_swap.swap_previous('@parameter.inner')
end, { desc = 'Swap parameters/argument with prev' })

vim.keymap.set('n', '<leader>SF', function()
  ts_swap.swap_previous('@function.outer')
end, { desc = 'Swap function with previous' })

local function map_move(keys, fn, query, query_group, desc)
  vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
    fn(query, query_group or 'textobjects')
  end, { desc = desc })
end

map_move(']f', ts_move.goto_next_start, '@call.outer', nil, 'Next function call start')
map_move(']m', ts_move.goto_next_start, '@function.outer', nil, 'Next method/function def start')
map_move(']c', ts_move.goto_next_start, '@class.outer', nil, 'Next class start')
map_move(']i', ts_move.goto_next_start, '@conditional.outer', nil, 'Next conditional start')
map_move(']l', ts_move.goto_next_start, '@loop.outer', nil, 'Next loop start')
map_move(']s', ts_move.goto_next_start, '@local.scope', 'locals', 'Next scope')
map_move(']z', ts_move.goto_next_start, '@fold', 'folds', 'Next fold')
map_move(']F', ts_move.goto_next_end, '@call.outer', nil, 'Next function call end')
map_move(']M', ts_move.goto_next_end, '@function.outer', nil, 'Next method/function def end')
map_move(']C', ts_move.goto_next_end, '@class.outer', nil, 'Next class end')
map_move(']I', ts_move.goto_next_end, '@conditional.outer', nil, 'Next conditional end')
map_move(']L', ts_move.goto_next_end, '@loop.outer', nil, 'Next loop end')
map_move('[f', ts_move.goto_previous_start, '@call.outer', nil, 'Prev function call start')
map_move('[m', ts_move.goto_previous_start, '@function.outer', nil, 'Prev method/function def start')
map_move('[c', ts_move.goto_previous_start, '@class.outer', nil, 'Prev class start')
map_move('[i', ts_move.goto_previous_start, '@conditional.outer', nil, 'Prev conditional start')
map_move('[l', ts_move.goto_previous_start, '@loop.outer', nil, 'Prev loop start')
map_move('[F', ts_move.goto_previous_end, '@call.outer', nil, 'Prev function call end')
map_move('[M', ts_move.goto_previous_end, '@function.outer', nil, 'Prev method/function def end')
map_move('[C', ts_move.goto_previous_end, '@class.outer', nil, 'Prev class end')
map_move('[I', ts_move.goto_previous_end, '@conditional.outer', nil, 'Prev conditional end')
map_move('[L', ts_move.goto_previous_end, '@loop.outer', nil, 'Prev loop end')
