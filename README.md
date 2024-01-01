# README for Neovim Configuration (`init.lua`)

This repository contains a comprehensive `init.lua` configuration for Neovim, based on the kickstart.nvim template. It is tailored to provide an enhanced coding experience with a variety of plugins and settings. Below is an overview of the key features and plugins included in this configuration.

## Key Features

1. **Leader Key**: The `<space>` key is set as the leader key for more efficient command access.
2. **Line Numbers**: Both relative and absolute line numbers are enabled for easier navigation.
3. **Word Wrap and Line Break**: Improved readability with automatic word wrapping and line breaking.
4. **Lazy Loading of Plugins**: Utilizes `lazy.nvim` for efficient plugin management.
5. **Telescope Integration**: Powerful fuzzy finder integrated for file searching, buffer exploration, and more.
6. **Treesitter Integration**: Enhanced syntax highlighting and code comprehension with Treesitter configurations.
7. **LSP Configuration**: Language Server Protocol support for various languages, enhancing coding capabilities.
8. **Autocompletion**: Set up with `nvim-cmp` for smart code completions.
9. **Snippet Support**: LuaSnip integration for efficient code snippet management.
10. **Linting**: Integrated with `nvim-lint` for real-time code quality checks.
11. **Git Integration**: Plugins like `vim-fugitive` and `gitsigns.nvim` for seamless Git operations within Neovim.
12. **Visual Enhancements**: Nord theme for a soothing visual experience, with transparent background support.

## Plugins

Here's a list of some key plugins included in the configuration:

- `tpope/vim-fugitive`
- `tpope/vim-rhubarb`
- `hrsh7th/cmp-nvim-lsp`
- `nvim-lua/plenary.nvim`
- `L3MON4D3/LuaSnip`
- `mfussenegger/nvim-lint`
- `tpope/vim-sleuth`
- `neovim/nvim-lspconfig`
- `nvim-treesitter/nvim-treesitter`
- `williamboman/mason.nvim`
- `j-hui/fidget.nvim`
- `folke/neodev.nvim`
- `numToStr/Comment.nvim`
- `shaunsingh/nord.nvim`
- `nvim-telescope/telescope.nvim`
- `nvim-lualine/lualine.nvim`
- `folke/which-key.nvim`
- `lewis6991/gitsigns.nvim`

## Installation

To use this configuration:

1. Ensure you have Neovim installed.
2. Clone this repository into your Neovim configuration directory, typically `~/.config/nvim/`.
3. Open Neovim, and the plugins will be automatically installed on first launch.
4. You may need to restart Neovim once all plugins are installed.

## Customization

Feel free to modify the `init.lua` file to suit your preferences. The configuration is well-commented, making it easier to understand and customize.

## Contribution

Contributions to improve this configuration are welcome. Please feel free to fork the repository, make changes, and submit a pull request.

## Acknowledgements

This config files is based off of a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Many thanks to the numerous contributors that created the original file that helped me get my start in Neovim.

---

**Note**: This configuration aims to provide a balance between functionality and performance, ensuring a smooth and efficient Neovim experience.
