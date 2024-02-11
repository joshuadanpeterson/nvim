--[[
	`custom.plugins.init`: Serves as the central orchestrator for loading and initializing custom plugin configurations within Neovim. This file aggregates the various plugin setups listed under the `custom.plugins` directory, ensuring a structured and modular approach to configuring Neovim's environment. It acts as an entry point, selectively importing and executing the configurations for individual plugins such as themes, language support, user interface enhancements, and developer tools. By centralizing the plugin initialization process, `custom.plugins.init` facilitates easy management and updates to the Neovim setup, allowing for clear separation of concerns and streamlined organization of the editor's extended functionalities.
]]

return {
	{ import = 'custom.plugins.colorscheme' },
	{ import = 'custom.plugins.copilot' },
	{ import = 'custom.plugins.dash' },
	{ import = 'custom.plugins.harpoon' },
	{ import = 'custom.plugins.lualine' },
	{ import = 'custom.plugins.finder' },
	{ import = 'custom.plugins.git' },
	{ import = 'custom.plugins.ui' },
	{ import = 'custom.plugins.utility' },
	{ import = 'custom.plugins.lsp' },
	{ import = 'custom.plugins.lint_and_autocomplete' },
	{ import = 'custom.plugins.obsidian' },
	{ import = 'custom.plugins.noice' },
	{ import = 'kickstart.plugins.autoformat' },
	{ import = 'kickstart.plugins.debug' },
	-- Add other plugin files here
}
