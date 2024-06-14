-- Noice transparent background config
require 'plugins.noice'

local noice_hl = vim.api.nvim_create_augroup('NoiceHighlights', {})
vim.api.nvim_clear_autocmds { group = noice_hl }

vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
  group = noice_hl,
  callback = function()
    -- General transparency setting for the command line popup
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })

    -- Specific settings for Noice command line popup
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { bg = 'NONE', fg = '#87CEEB' }) -- Customize the border color
    vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { bg = 'NONE' })

    -- Set a transparent background for various Noice components
    local components = { 'CmdLine', 'Input', 'Lua', 'Filter', 'Rename', 'Substitute', 'Help', 'Search' }
    for _, type in ipairs(components) do
      vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder' .. type, { bg = 'NONE', fg = '#87CEEB' }) -- Customize the border color
      vim.api.nvim_set_hl(0, 'NoiceCmdlineIcon' .. type, { bg = 'NONE' })
    end
  end,
})
