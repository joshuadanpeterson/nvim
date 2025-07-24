# README for Neovim Configuration

<a href="https://dotfyle.com/joshuadanpeterson/nvim"><img src="https://dotfyle.com/joshuadanpeterson/nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/joshuadanpeterson/nvim"><img src="https://dotfyle.com/joshuadanpeterson/nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/joshuadanpeterson/nvim"><img src="https://dotfyle.com/joshuadanpeterson/nvim/badges/plugin-manager?style=flat" /></a>

## Neovim Configuration Overview

This repository hosts an advanced `init.lua` configuration for Neovim, crafted to enhance the development workflow with a wide array of functionalities and plugins. It draws inspiration from the kickstart.nvim template and integrates additional customizations for a personalized coding environment. Here's an integrated overview of the features, plugins, and setup instructions.

## Key Features

1. **Efficient Navigation**: Utilizes `<space>` as the leader key, with both relative and absolute line numbers for ease of navigation.
2. **Enhanced Readability**: Implements word wrapping and line breaking for improved text readability.
3. **Plugin Management**: Employs `lazy.nvim` for effective and lazy loading of plugins, optimizing startup time.
4. **Comprehensive Search**: Integrates `Telescope` for an extensive fuzzy finding experience across files, buffers, and more.
5. **Syntax Highlighting**: Utilizes `Treesitter` for superior syntax highlighting and code comprehension.
6. **Code Intelligence**: Features robust LSP support for numerous languages, offering autocompletion, linting, and more.
7. **Snippet Management**: Integrates `LuaSnip` for powerful and efficient snippet handling.
8. **Git Operations**: Facilitates seamless Git workflows within Neovim with plugins like `vim-fugitive` and `gitsigns.nvim`.
9. **Aesthetic Enhancements**: Adopts the Nord theme for a visually pleasing coding environment, with support for transparent backgrounds.
10. **Project Navigation**: Incorporates `ThePrimeagen/harpoon` for quick access and navigation to frequently used files and projects.

## Plugins Highlight

- **Autocompletion & Snippets**: `nvim-cmp`, `LuaSnip`
- **LSP & Syntax**: `nvim-lspconfig`, `nvim-treesitter`, `williamboman/mason.nvim`
- **Utility**: `tpope/vim-fugitive`, `lewis6991/gitsigns.nvim`, `mfussenegger/nvim-lint`
- **UI Enhancements**: `shaunsingh/nord.nvim`, `nvim-lualine/lualine.nvim`
- **Navigation & Search**: `nvim-telescope/telescope.nvim`, `folke/which-key.nvim`, `ThePrimeagen/harpoon`
- **Miscellaneous**: `j-hui/fidget.nvim`, `numToStr/Comment.nvim`, `tpope/vim-sleuth`

## Installation

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

1. Install Neovim if you haven't already.
2. Clone this repository to your Neovim configuration directory (`~/.config/nvim/`).

```sh
git clone https://github.com/joshuadanpeterson/nvim.git ~/.config/nvim
```

3. Launch Neovim; the plugins will automatically install on the first run.
4. A restart of Neovim might be necessary once all plugins are installed.

## Customization

The configuration is designed for easy customization. You're encouraged to modify the `init.lua` and files within the `lua/` directory to tailor the setup to your preferences. The scripts are well-documented to facilitate understanding and modifications.

## Profiling Neovim Startup Performance

A robust profiling script is available to analyze and optimize Neovim startup times, ensuring performance targets are met consistently. The profiling tool measures both cold start and cached startup times, and produces detailed reports in CSV format for thorough analysis.

### Usage

To profile your Neovim startup, navigate to the Neovim configuration directory and execute the profiling script:

```bash
python3 scripts/profile_init.py
```

### Performance Targets

- **Cold Start:** < 400 ms
- **Cached Start:** < 150 ms

### Report

The script generates a detailed `after.csv` report in the `profile/` directory, summarizing performance metrics and the execution times of various modules or scripts. This report serves as a benchmark for ongoing optimizations.

### Best Practices for Adding New Plugins

When adding new plugins to maintain optimal startup performance:

1. **Use Lazy Loading**: Configure plugins to load only when needed using `lazy.nvim`'s event, command, or filetype triggers
2. **Profile After Changes**: Run `python3 scripts/profile_init.py` after adding new plugins to ensure targets are still met
3. **Optimize Heavy Plugins**: For plugins that significantly impact startup time:
   - Consider alternatives with better performance
   - Configure them to load on-demand rather than at startup
   - Use the `event = "VeryLazy"` option for non-critical plugins
4. **Monitor Module Load Times**: Review the CSV report to identify slow-loading modules
5. **Set Budget Limits**: Aim to keep individual module load times under 20ms where possible

## Contribution

Feel free to fork the repository and make your changes.

## Acknowledgements

This configuration is a fork and extension of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), with gratitude to its creators and contributors for laying the groundwork for this setup.

---

This README provides a comprehensive guide to setting up a feature-rich Neovim environment that balances functionality with performance, ensuring a smooth and productive development experience.
