-- lua/plugins/current-theme.lua

-- Applying the nord colorscheme
vim.cmd 'colorscheme nord'

-- Additional configurations for the nord theme
vim.g.nord_transparent = true -- Set to false to disable transparency globally

-- You can set specific styles for sidebars and floats if nord supports it via vim.g options
-- For example, if nord supports setting transparency via vim.g options, do it here
-- vim.g.nord_sidebars = 'transparent'
-- vim.g.nord_floats = 'transparent'
