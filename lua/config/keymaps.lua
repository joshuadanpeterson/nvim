-- This config file contains my keymaps
-- lua/config/keymaps.lua

local wk = require("which-key")
local harpoon = require("harpoon")

-- General and Basic Keymaps
local generalMappings = {
	['<Space>'] = { '<Nop>', "No Operation" },
	k = { "v:count == 0 ? 'gk' : 'k'", "Move up (respecting display lines)", expr = true },
	j = { "v:count == 0 ? 'gj' : 'j'", "Move down (respecting display lines)", expr = true },
	['<C-_>'] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Toggle comment for current line", mode = { "n", "v" } },
	['<Esc>'] = { "<ESC>:noh<CR>:require('notify').dismiss()<CR>", "Clear search highlight and notifications" },
	['<leader>m'] = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Toggle Harpoon menu" },
	['<leader>a'] = { function() harpoon:list():append() end, "Add File to Harpoon Menu" },
	['<leader>d'] = { function() harpoon:list():remove() end, "Remove File from Harpoon Menu" },
	['<leader>nd'] = { "<cmd>NoiceDismiss<CR>", "Dismiss Noice message" },
}

-- LSP Keymaps
local lspMappings = {
	['<leader>rn'] = { vim.lsp.buf.rename, "Rename" },
	['<leader>ca'] = { vim.lsp.buf.code_action, "Code Action" },
	gd = { require('telescope.builtin').lsp_definitions, "Goto Definition" },
	gr = { require('telescope.builtin').lsp_references, "Goto References" },
	gI = { require('telescope.builtin').lsp_implementations, "Goto Implementations" },
	['<leader>D'] = { require('telescope.builtin').lsp_type_definitions, "Type Definition" },
	['<leader>ds'] = { require('telescope.builtin').lsp_document_symbols, "Document Symbols" },
	['<leader>ws'] = { require('telescope.builtin').lsp_workspace_symbols, "Workspace Symbols" },
	K = { vim.lsp.buf.hover, "Hover Documentation" },
	['<C-k>'] = { vim.lsp.buf.signature_help, "Signature Help" },
	['gD'] = { vim.lsp.buf.declaration, "Goto Declaration" },
	['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
	['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
	['<leader>wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
	['<leader>q'] = { vim.diagnostic.setloclist, "Open Diagnostics List" },
	['[d'] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
	[']d'] = { vim.diagnostic.goto_next, "Next Diagnostic" },
	['<leader>f'] = { function() vim.lsp.buf.format { async = true } end, "Format Document" },
}

-- Telescope Keymaps
local telescopeMappings = {
	['<leader>gf'] = { require('telescope.builtin').git_files, "Search Git Files" },
	['<leader>sf'] = { require('telescope.builtin').find_files, "Search Files" },
	['<leader>sh'] = { require('telescope.builtin').help_tags, "Search Help" },
	['<leader>sw'] = { require('telescope.builtin').grep_string, "Search Current Word" },
	['<leader>sg'] = { require('telescope.builtin').live_grep, "Search by Grep" },
	['<leader>sG'] = { "<cmd>Telescope live_grep search_dirs={'$(git rev-parse --show-toplevel)'}<CR>", "Grep in Git Directory" },
	['<leader>sd'] = { require('telescope.builtin').diagnostics, "Search Diagnostics" },
	['<leader>sr'] = { require('telescope.builtin').resume, "Resume Last Search" },
	['<leader>sc'] = { require('telescope.builtin').commands, "Search Telescope Commands" },
	['<leader>ch'] = { require('telescope.builtin').command_history, "Search Command History" },
	['<leader>sH'] = { require('telescope.builtin').search_history, "Search History"},
	['<leader>pg'] = { require('telescope.builtin').man_pages, "Search Man Pages"},
	['<leader>km'] = { require('telescope.builtin').keymaps, "Search Keymaps"},
	['<leader>ss'] = { require('telescope.builtin').spell_suggest, "Search Spelling Suggestions"},
	['<leader>da'] = { "<cmd>Telescope dash search<CR>", "Search Dash" },
	['<leader>st'] = { "<cmd>Telescope themes<CR>", "Search Themes" },
}

-- Rnvimr Keymaps
local rnvimrMappings = {
	['<leader>rt'] = { ":RnvimrToggle<CR>", "Toggle Rnvimr" },
	-- Assuming you want a dedicated keymap for resizing as well, you could use something like this:
	['<leader>rr'] = { ":RnvimrResize<CR>", "Resize Rnvimr" },
	-- If you need the original <M-i> and <M-o> functionality mapped to other keys, you'll need to customize these bindings
	-- For example, for toggling with <M-o> and resizing with <M-i>, but these are not directly translatable into Lua config without considering terminal keymap conflicts
}

-- legendary.nvim Keymaps
local legendaryMappings = {
	['<leader>lg'] = { ":Legendary<CR>", "Search Legendary"},
	['<leader>lk'] = { ":Legendary keymaps<CR>", "Search Legendary Keymaps"},
	['<leader>lc'] = { ":Legendary commands<CR>", "Search Legendary Commands"},
	['<leader>lf'] = { ":Legendary functions<CR>", "Search Legendary Functions"},
	['<leader>la'] = { ":Legendary autocmds<CR>", "Search Legendary Autocmds"},
	['<leader>lr'] = { ":LegendaryRepeat<CR>", "Repeat Last Item Executed"},
	['<leader>l!'] = { ":LegendaryRepeat!<CR>", "Repeat Last Item Executed, no filters"},

}


-- Setup with default options
wk.setup {}

-- Registering mappings
wk.register(generalMappings)
wk.register(lspMappings)
wk.register(telescopeMappings)

-- Registering Rnvimr mappings
wk.register(rnvimrMappings)

-- Registering legendary.nvim mappings
wk.register(legendaryMappings)
