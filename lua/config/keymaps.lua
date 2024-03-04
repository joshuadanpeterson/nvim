-- This config file contains my keymaps
-- lua/config/keymaps.lua

-- import dependencies
local wk = require("which-key")
local harpoon = require("harpoon")
local dap = require('dap')
local dapui = require('dapui')

-- set up lualine function
local function setup_lualine()
	-- Ensure this function contains your lualine setup configuration
	require('lualine').setup {
		-- Your lualine configuration goes here
	}
end

local function refresh_lualine()
	package.loaded['lualine'] = nil
	setup_lualine()
end

-- set up telescope.actions
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- General and Basic Keymaps
local generalMappings = {
	['<Space>'] = { '<Nop>', "No Operation" },
	['k'] = { "v:count == 0 ? 'gk' : 'k'", "Move up (respecting display lines)", expr = true },
	['j'] = { "v:count == 0 ? 'gj' : 'j'", "Move down (respecting display lines)", expr = true },
	['<C-_>'] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Toggle comment for current line", mode = { "n", "v" } },
	['<Esc>'] = { "<ESC>:noh<CR>:require('notify').dismiss()<CR>", "Clear search highlight and notifications" },
	['nl'] = { refresh_lualine, "Refresh status line" },
	['nd'] = { ":NoiceDismiss<CR>", "Dismiss Noice Message" },
}

-- LSP Keymaps
local lspMappings = {
	['rn'] = { vim.lsp.buf.rename, "Rename" },
	['ca'] = { vim.lsp.buf.code_action, "Code Action" },
	['gd'] = { require('telescope.builtin').lsp_definitions, "Goto Definition" },
	['gr'] = { require('telescope.builtin').lsp_references, "Goto References" },
	['gI'] = { require('telescope.builtin').lsp_implementations, "Goto Implementations" },
	['D'] = { require('telescope.builtin').lsp_type_definitions, "Type Definition" },
	['ds'] = { require('telescope.builtin').lsp_document_symbols, "Document Symbols" },
	['ws'] = { require('telescope.builtin').lsp_workspace_symbols, "Workspace Symbols" },
	['K'] = { vim.lsp.buf.hover, "Hover Documentation" },
	['C-k>'] = { vim.lsp.buf.signature_help, "Signature Help" },
	['gD'] = { vim.lsp.buf.declaration, "Goto Declaration" },
	['wa'] = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
	['wr'] = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
	['wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
	['Q'] = { vim.diagnostic.setloclist, "Open Diagnostics List" },
	[']d'] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
	['[d'] = { vim.diagnostic.goto_next, "Next Diagnostic" },
	['fm'] = { function() vim.lsp.buf.format { async = true } end, "Format Document" },
}

-- Telescope Keymaps
local telescopeMappings = {
	['tS'] = { require('telescope.builtin').find_files, "Search Files" },
	['tR'] = { '<cmd>Telescope registers<CR>', "Search Registers" },
	['tb'] = { require('telescope.builtin').current_buffer_fuzzy_find, "Search Current Buffer" },
	['th'] = { ":FuzzyHelp<CR>", "Search Help" },
	['tw'] = { require('telescope.builtin').grep_string, "Search Current Word" },
	['tg'] = { require('telescope.builtin').live_grep, "Search by Grep" },
	['td'] = { require('telescope.builtin').diagnostics, "Search Diagnostics" },
	['tr'] = { require('telescope.builtin').resume, "Resume Last Search" },
	['tc'] = { require('telescope.builtin').commands, "Search Telescope Commands" },
	['tC'] = { require('telescope.builtin').command_history, "Search Command History" },
	['tH'] = { require('telescope.builtin').search_history, "Search History" },
	['tM'] = { ":FuzzyMan<CR>", "Search Man Pages" },
	['tm'] = { require('telescope.builtin').keymaps, "Search Keymaps" },
	['ts'] = { require('telescope.builtin').spell_suggest, "Search Spelling Suggestions" },
	['ds'] = { ":Dash<CR>", "Search Dash" },
	['dw'] = { ":DashWord<CR>", "Search Dash by word" },
	['tt'] = { "<cmd>Telescope themes<CR>", "Search Themes" },
	['te'] = { "<cmd>Telescope emoji<CR>", "Search Emojis" },
	['?'] = { require('telescope.builtin').oldfiles, "[?] Find recently opened files" },
	['<space>'] = { require('telescope.builtin').buffers, "[ ] Find existing buffers" },
	["/"] = { require('telescope.builtin').current_buffer_fuzzy_find, "[/] Fuzzily search in current buffer" },
	['tF'] = { "<cmd>Telescope uniswapfiles telescope_swap_files<CR>", "Search Swap Files" },
	['tn'] = { ":FuzzyNoice<CR>", "Search Noice Messages" },
}

-- Rnvimr and Ranger Keymaps
local rnvimrMappings = {
	['rt'] = { ":RnvimrToggle<CR>", "Toggle Rnvimr" },
	['rr'] = { ":RnvimrResize<CR>", "Resize Rnvimr" },
	['rn'] = { function() require("ranger-nvim").open(true) end, "Open Ranger" },
}

-- legendary.nvim Keymaps
local legendaryMappings = {
	['lg'] = { ":Legendary<CR>", "Search Legendary" },
	['lk'] = { ":Legendary keymaps<CR>", "Search Legendary Keymaps" },
	['lc'] = { ":Legendary commands<CR>", "Search Legendary Commands" },
	['lf'] = { ":Legendary functions<CR>", "Search Legendary Functions" },
	['la'] = { ":Legendary autocmds<CR>", "Search Legendary Autocmds" },
	['lr'] = { ":LegendaryRepeat<CR>", "Repeat Last Item Executed" },
	['l!'] = { ":LegendaryRepeat!<CR>", "Repeat Last Item Executed, no filters" },
}

-- live-server.nvim Keymaps
local liveServerMappings = {
	['ls'] = { ":LiveServerStart<CR>", "Start LiveServer" },
	['lt'] = { ":LiveServerStop<CR>", "Stop LiveServer" },
}

-- Tmux Telescope Plugin Keymaps
local tmuxTelescopeMappings = {
	["ft"] = { ":TmuxJumpFile<CR>", "Jump to File in Tmux Pane" },
	[";"]  = { ":TmuxJumpFirst<CR>", "Jump to First Tmux Pane" },
}

-- Harpoon Keymaps
local harpoonMappings = {
	["ha"] = { function() harpoon:list():append() end, "Add File to Harpoon Menu" },
	["hr"] = { function() harpoon:list():remove() end, "Remove File from Harpoon Menu" },
	["hp"] = { function() harpoon.nav.prev() end, "Previous Harpoon File" },
	["hn"] = { function() harpoon.nav.next() end, "Next Harpoon File" },
	["hm"] = { function() harpoon.ui.toggle_quick_menu() end, "Harpoon Quick Menu" },
}

-- Obsidian Keymaps
local obsidianMappings = {
	["on"] = { function() return require("obsidian").util.gf_passthrough() end, "Go to Note Under Cursor", opts = { noremap = false, expr = true, buffer = true } },
	["oc"] = { function() return require("obsidian").util.toggle_checkbox() end, "Toggle Checkboxes", opts = { buffer = true } },
}

-- Lazy Keymaps
local lazyMappings = {
	["lz"] = { ":Lazy<CR>", "Open Lazy" },
	["lr"] = { ":LazyRoot<CR>", "Open LazyRoot" },
	["le"] = { ":LazyExtras<CR>", "Open LazyExtras" },
	["lf"] = { ":LazyFormat<CR>", "Open LazyFormat" },
	["lh"] = { ":LazyHealth<CR>", "Open LazyHealth" },
	["li"] = { ":LazyFormatInfo<CR>", "Open LazyFormatInfo" },
}

-- Flash Keymaps
local flashMappings = {
	['fs'] = { function() require("flash").jump() end, "Flash", mode = { "n", "x", "o" } },
	['fS'] = { function() require("flash").treesitter() end, "Flash Treesitter", mode = { "n", "x", "o" } },
	['fr'] = { function() require("flash").remote() end, "Remote Flash", mode = "o" },
	['fR'] = { function() require("flash").treesitter_search() end, "Treesitter Search", mode = { "o", "x" } },
	['f<c-s>'] = { function() require("flash").toggle() end, "Toggle Flash Search", mode = "c" },
}

-- Git Keymaps
local gitMappings = {
	['gf'] = { require('telescope.builtin').git_files, "Search Git Files" },
	['gd'] = { "<cmd>Telescope live_grep search_dirs={'$(git rev-parse --show-toplevel)'}<CR>", "Grep in Git Directory" },
	['gs'] = { require('telescope.builtin').git_stash, "Search Git Stash" },
	['gS'] = { require('telescope.builtin').git_status, "Search Git Status" },
	['gC'] = { '<cmd>Telescope git_bcommits<CR>', "Search Git Buffer Commits" },
	['gc'] = { require('telescope.builtin').git_commits, "Search Git Directory Commits" },
	['gb'] = { require('telescope.builtin').git_branches, "Search Git Branches" },
	['gp'] = { ':Gitsigns preview_hunk<CR>', 'Toggle Gitsigns Preview Hunk' },
	['gB'] = { ':Gitsigns toggle_current_line_blame<CR>', 'Toggle Git Blame' },
	['gD'] = { ':Gdiffsplit<CR>', 'Toggle Git Diff Split' },
	['gP'] = { '<cmd>Telescope git_signs', 'Search Preview Hunks' },
}

-- DAP Plugin Keymaps
local dapMappings = {
	["<F5>"] = { dap.continue, "Debug: Start/Continue" },
	["<F1>"] = { dap.step_into, "Debug: Step Into" },
	["<F2>"] = { dap.step_over, "Debug: Step Over" },
	["<F3>"] = { dap.step_out, "Debug: Step Out" },
	["db"] = { dap.toggle_breakpoint, "Debug: Toggle Breakpoint" },
	["dB"] = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Debug: Set Breakpoint" },
	["<F7>"] = { dapui.toggle, "Debug: See last session result." },
}

-- Setup with default options
wk.setup {}

-- Registering mappings
wk.register(generalMappings, { prefix = "<leader>", mode = "n" })
wk.register(lspMappings, { prefix = "<leader>", mode = "n" })
-- Registering Telescope mappings under the 'n' (normal) mode leader key
wk.register(telescopeMappings, { prefix = "<leader>", mode = "n" })

-- Registering Rnvimr mappings
wk.register(rnvimrMappings, { prefix = "<leader>", mode = "n" })

-- Registering legendary.nvim mappings
wk.register(legendaryMappings, { prefix = "<leader>", mode = "n" })

-- Registering legendary.nvim mappings
wk.register(liveServerMappings, { prefix = "<leader>", mode = "n" })

-- Registering Tmux Telescope mappings under the 'n' (normal) mode leader key
wk.register(tmuxTelescopeMappings, { prefix = "<leader>", mode = "n" })

-- Registering DAP mappings under the 'n' (normal) mode leader key
-- Note: F-keys are registered globally, not under a leader key.
wk.register(dapMappings, { mode = "n" })

-- For F-keys which are not under the leader key, you can register them separately
wk.register({
	["<F1>"] = { dap.step_into, "Debug: Step Into" },
	["<F2>"] = { dap.step_over, "Debug: Step Over" },
	["<F3>"] = { dap.step_out, "Debug: Step Out" },
	["<F5>"] = { dap.continue, "Debug: Start/Continue" },
	["<F7>"] = { dapui.toggle, "Debug: See last session result." },
}, { mode = "n", prefix = "" })

-- Registering Harpoon mappings under the 'n' (normal) mode leader key
wk.register(harpoonMappings, { prefix = "<leader>", mode = "n" })

-- Registering numeric mappings for selecting Harpoon files
for i = 1, 9 do
	wk.register({
		[tostring(i)] = { function() harpoon.ui.nav_file(i) end, "Harpoon to File " .. i }
	}, { prefix = "<leader>", mode = "n" })
end

-- Registering Obsidian mappings under the 'n' (normal) mode leader key
wk.register(obsidianMappings, { prefix = "<leader>", mode = "n" })

-- Registering Lazy mappings under the 'n' (normal) mode leader key
wk.register(lazyMappings, { prefix = "<leader>", mode = "n" })

-- Registering Flash mappings with which-key
for key, mapping in pairs(flashMappings) do
	local mode = mapping.mode or "n" -- default to normal mode if mode not provided
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			wk.register({ [key] = { mapping[1], mapping[2] } }, { prefix = "<leader>", mode = m })
		end
	else
		wk.register({ [key] = { mapping[1], mapping[2] } }, { prefix = "<leader>", mode = mode })
	end
end

-- Registering Git mappings under the 'n' (normal) mode leader key
wk.register(gitMappings, { prefix = "<leader>", mode = "n" })
