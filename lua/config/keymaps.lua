-- This config file contains my keymaps
-- lua/config/keymaps.lua

-- import dependencies
local wk = require("which-key")
local harpoon = require("harpoon")
local dap = require('dap')
local dapui = require('dapui')
local tmux = require('config.tmux')

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

-- General and Basic Keymaps
local generalMappings = {
	name = "General and Basic Keymaps",
	-- ['<Space>'] = { '<Nop>', "No Operation" },
	['k'] = { "v:count == 0 ? 'gk' : 'k'", "Move up (respecting display lines)", expr = true },
	['j'] = { "v:count == 0 ? 'gj' : 'j'", "Move down (respecting display lines)", expr = true },
	['c'] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", "Toggle comment for current line", mode = { "n", "v" } },
	['<Esc>'] = { "<ESC>:noh<CR>:require('notify').dismiss()<CR>", "Clear search highlight and notifications" },
	['l'] = { refresh_lualine, "Refresh status line" },
	['n'] = { "<cmd>Noice<cr>", "Noice" },
	['d'] = { ":NoiceDismiss<CR>", "Dismiss Noice Message" },
	['L'] = { ":SearchLogFiles<CR>", "Search Log Files" },
	['C'] = { ":SearchChangelogFiles<CR>", "Search Changelog Files" },
}

-- LSP Keymaps
local lspMappings = {
	name = "LSP Keymaps",
	['r'] = { vim.lsp.buf.rename, "Rename" },
	['c'] = { vim.lsp.buf.code_action, "Code Action" },
	['d'] = { require('telescope.builtin').lsp_definitions, "Goto Definition" },
	['R'] = { require('telescope.builtin').lsp_references, "Goto References" },
	['i'] = { require('telescope.builtin').lsp_implementations, "Goto Implementations" },
	['D'] = { require('telescope.builtin').lsp_type_definitions, "Type Definition" },
	['s'] = { require('telescope.builtin').lsp_document_symbols, "Document Symbols" },
	['w'] = { require('telescope.builtin').lsp_workspace_symbols, "Workspace Symbols" },
	['H'] = { vim.lsp.buf.hover, "Hover Documentation" },
	['S'] = { vim.lsp.buf.signature_help, "Signature Help" },
	['g'] = { vim.lsp.buf.declaration, "Goto Declaration" },
	['a'] = { vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
	['x'] = { vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder" },
	['l'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Workspace Folders" },
	['Q'] = { vim.diagnostic.setloclist, "Open Diagnostics List" },
	[']'] = { vim.diagnostic.goto_prev, "Previous Diagnostic" },
	['['] = { vim.diagnostic.goto_next, "Next Diagnostic" },
	['f'] = { function() vim.lsp.buf.format { async = true } end, "Format Document" },
}

-- Telescope Keymaps
local telescopeMappings = {
	name = "Telescope Keymaps",
	['S'] = {
		function()
			require('telescope.builtin').find_files({
				find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
			})
		end,
		"Search Files"
	},
	['R'] = { '<cmd>Telescope registers<CR>', "Search Registers" },
	['b'] = { require('telescope.builtin').current_buffer_fuzzy_find, "Search Current Buffer" },
	['h'] = { ":FuzzyHelp<CR>", "Search Help" },
	['w'] = { require('telescope.builtin').grep_string, "Search Current Word" },
	['g'] = { require('telescope.builtin').live_grep, "Search by Grep" },
	['G'] = { "<cmd>Telescope helpgrep<CR>", "Search Grep Help" },
	['d'] = { require('telescope.builtin').diagnostics, "Search Diagnostics" },
	['r'] = { require('telescope.builtin').resume, "Resume Last Search" },
	['c'] = { require('telescope.builtin').commands, "Search Telescope Commands" },
	['C'] = { require('telescope.builtin').command_history, "Search Command History" },
	['H'] = { require('telescope.builtin').search_history, "Search History" },
	['M'] = { ":FuzzyMan<CR>", "Search Man Pages" },
	['m'] = { require('telescope.builtin').keymaps, "Search Keymaps" },
	['s'] = { require('telescope.builtin').spell_suggest, "Search Spelling Suggestions" },
	['D'] = { ":Dash<CR>", "Search Dash" },
	['W'] = { ":DashWord<CR>", "Search Dash by word" },
	['t'] = { "<cmd>Telescope themes<CR>", "Search Themes" },
	['e'] = { "<cmd>Telescope emoji<CR>", "Search Emojis" },
	['?'] = { require('telescope.builtin').oldfiles, "[?] Find recently opened files" },
	['F'] = { "<cmd>Telescope uniswapfiles telescope_swap_files<CR>", "Search Swap Files" },
	['n'] = { ":FuzzyNoice<CR>", "Search Noice Messages" },
	['N'] = { "<cmd>Telescope notify<CR>", "Search Notify Messages" },
	['o'] = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
	['B'] = { "<cmd>Telescope buffers<cr>", "List Buffers" },
	['z'] = { "<cmd>Telescope zoxide list<CR>", "Zoxide List" },
	['l'] = { "<cmd>Telescope lazy<CR>", "Search Lazy for Plugins" },
	['T'] = { "<cmd>Tldr<CR>", "Search tldr pages" },
}

-- Rnvimr and Ranger Keymaps
local rnvimrMappings = {
	name = "Rnvimr and Ranger Keymaps",
	['t'] = { ":RnvimrToggleeCR>", "Toggle Rnvimr" },
	['r'] = { ":RnvimrResize<CR>", "Resize Rnvimr" },
	['n'] = { function() require("ranger-nvim").open(true) end, "Open Ranger" },
}

-- legendary.nvim Keymaps
local legendaryMappings = {
	name = "Legendary Keymaps",
	['g'] = { ":Legendary<CR>", "Search Legendary" },
	['k'] = { ":Legendary keymaps<CR>", "Search Legendary Keymaps" },
	['c'] = { ":Legendary commands<CR>", "Search Legendary Commands" },
	['f'] = { ":Legendary functions<CR>", "Search Legendary Functions" },
	['a'] = { ":Legendary autocmds<CR>", "Search Legendary Autocmds" },
	['r'] = { ":LegendaryRepeat<CR>", "Repeat Last Item Executed" },
	['!'] = { ":LegendaryRepeat!eCR>", "Repeat Last Item Executed, no filters" },
	['s'] = { ":LegendaryScratch<CR>", "Launch Scratch Pad" },
}

-- live-server.nvim Keymaps
local liveServerMappings = {
	name = "LiveServer KeyMaps",
	['s'] = { ":LiveServerStart<CR>", "Start LiveServer" },
	['t'] = { ":LiveServerStop<CR>", "Stop LiveServer" },
}

-- Tmux Telescope Plugin Keymaps
local tmuxTelescopeMappings = {
	name = "tmux Telescope Keymaps",
	["t"] = { ":TmuxJumpFile<CR>", "Jump to File in Tmux Pane" },
	[";"] = { ":TmuxJumpFirst<CR>", "Jump to First Tmux Pane" },
	["s"] = { tmux.switch_to_tmux_session, 'Switch Tmux Session', { noremap = true, silent = true } },
	["w"] = { tmux.switch_tmux_window, 'Switch Tmux Window', { noremap = true, silent = true } },
	["p"] = { tmux.switch_tmux_pane, 'Switch Tmux Pane', { noremap = true, silent = true } },
	["m"] = { tmux.tmux_menu_picker, 'Tmux Menu Picker', { noremap = true, silent = true } },
}

-- Harpoon Keymaps
local harpoonMappings = {
	name = "Harpoon Keymaps",
	["a"] = { function() harpoon:list():add() end, "Add File to Harpoon Menu" },
	["r"] = { function() harpoon:list():remove() end, "Remove File from Harpoon Menu" },
	["p"] = { function() harpoon.nav.prev() end, "Previous Harpoon File" },
	["n"] = { function() harpoon.nav.next() end, "Next Harpoon File" },
}

-- Obsidian Keymaps
local obsidianMappings = {
	name = "Obsidian Keymaps",
	["n"] = { function() return require("obsidian").util.gf_passthrough() end, "Go to Note Under Cursor", opts = { noremap = false, expr = true, buffer = true } },
	["c"] = { function() return require("obsidian").util.toggle_checkbox() end, "Toggle Checkboxes", opts = { buffer = true } },
	['p'] = { ':SearchObsidianProgramming<CR>', "Search Obsidian Programming Vault" },

	-- Adding new mappings for Obsidian commands
	["o"] = { "<cmd>ObsidianOpen<CR>", "Open Note in Obsidian" },
	["N"] = { "<cmd>ObsidianNew<CR>", "Create New Note" },
	["q"] = { "<cmd>ObsidianQuickSwitch<CR>", "Quick Switch Note" },
	["f"] = { "<cmd>ObsidianFollowLink<CR>", "Follow Note Link" },
	["b"] = { "<cmd>ObsidianBacklinks<CR>", "Show Backlinks" },
	["t"] = { "<cmd>ObsidianTags<CR>", "Show Tags" },
	["d"] = { "<cmd>ObsidianToday<CR>", "Open Today's Note" },
	["y"] = { "<cmd>ObsidianYesterday<CR>", "Open Yesterday's Note" },
	["m"] = { "<cmd>ObsidianTomorrow<CR>", "Open Tomorrow's Note" },
	["D"] = { "<cmd>ObsidianDailies<CR>", "List Daily Notes" },
	["T"] = { "<cmd>ObsidianTemplate<CR>", "Insert Template" },
	["s"] = { "<cmd>ObsidianSearch<CR>", "Search Notes" },
	["l"] = { "<cmd>ObsidianLink<CR>", "Link Note" },
	["L"] = { "<cmd>ObsidianLinkNew<CR>", "Link to New Note" },
	["S"] = { "<cmd>ObsidianLinks<CR>", "List Links" },
	["E"] = { "<cmd>ObsidianExtractNote<CR>", "Extract Note" },
	["w"] = { "<cmd>ObsidianWorkspace<CR>", "Switch Workspace" },
	["i"] = { "<cmd>ObsidianPasteImg<CR>", "Paste Image" },
	["R"] = { "<cmd>ObsidianRename<CR>", "Rename Note" },
}

-- Lazy Keymaps
local lazyMappings = {
	name = "Lazy Keymaps",
	["z"] = { ":Lazy<CR>", "Open Lazy" },
	["r"] = { ":LazyRoot<CR>", "Open LazyRoot" },
	["e"] = { ":LazyExtras<CR>", "Open LazyExtras" },
	["f"] = { ":LazyFormat<CR>", "Open LazyFormat" },
	["h"] = { ":LazyHealth<CR>", "Open LazyHealth" },
	["i"] = { ":LazyFormatInfo<CR>", "Open LazyFormatInfo" },
}

-- Flash Keymaps
local flashMappings = {
	name = "Flash Keymaps",
	['s'] = { function() require("flash").jump() end, "Flash", mode = { "n", "x", "o" } },
	['S'] = { function() require("flash").treesitter() end, "Flash Treesitter", mode = { "n", "x", "o" } },
	['r'] = { function() require("flash").remote() end, "Remote Flash", mode = "o" },
	['R'] = { function() require("flash").treesitter_search() end, "Treesitter Search", mode = { "o", "x" } },
	['t'] = { function() require("flash").toggle() end, "Toggle Flash Search", mode = "c" },
}

-- Git Keymaps
local gitMappings = {
	name = "Git Keymaps",
	['f'] = { require('telescope.builtin').git_files, "Search Git Files" },
	['d'] = { "<cmd>Telescope live_grep search_dirs={'$(git rev-parse --show-toplevel)'}<CR>", "Grep in Git Directory" },
	['s'] = { require('telescope.builtin').git_stash, "Search Git Stash" },
	['S'] = { require('telescope.builtin').git_status, "Search Git Status" },
	['C'] = { '<cmd>Telescope git_bcommits<CR>', "Search Git Buffer Commits" },
	['c'] = { require('telescope.builtin').git_commits, "Search Git Directory Commits" },
	['b'] = { require('telescope.builtin').git_branches, "Search Git Branches" },
	['p'] = { '<cmd>Telescope git_signs<CR>', 'Search Preview Hunks' },
	['B'] = { ':Gitsigns toggle_current_line_blame<CR>', 'Toggle Git Blame' },
	['D'] = { ':Gdiffsplit<CR>', 'Toggle Git Diff Split' },
	['G'] = { "<cmd>Telescope repo list<CR>", "Search Git Repos" },
	['l'] = { "<cmd>FloatermNew lazygit<CR>", "Open Lazygit" },
}

-- ChatGPT Keymaps
local chatgptMappings = {
	name = "ChatGPT Keymaps",
	['c'] = { "<cmd>ChatGPT<CR>", "ChatGPT" },
	['C'] = { "<cmd>Telescope gpt<CR>", "Telescope GPT" },
	['e'] = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction", mode = { "n", "v" } },
	['g'] = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
	['t'] = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
	['k'] = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
	['d'] = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
	['a'] = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
	['o'] = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
	['s'] = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
	['f'] = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
	['x'] = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
	['r'] = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
	['l'] = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
}

-- CLI App Keymaps
local cliMappings = {
	name = "CLI App Mappings",
	['t'] = { "<cmd>FloatermNew<CR>", "Launch Terminal" },       -- Launch Terminal
	['d'] = { "<cmd>FloatermNew lazydocker<CR>", "Launch Lazydocker" }, -- Launch Lazydocker: docker
	['p'] = { "<cmd>FloatermNew python<CR>", "Launch Python3 REPL" }, -- Launch Python3 REPL: python
	['n'] = { "<cmd>FloatermNew node<CR>", "Launch Node REPL" }, -- Launch Node REPL: javascript
	['h'] = { "<cmd>FloatermNew htop<CR>", "Launch htop" },      -- Launch htop: resource management
	['b'] = { "<cmd>FloatermNew bpytop<CR>", "Launch Bpytop" },  -- Launch bpytop: resource management
}

-- DAP Plugin Keymaps
local dapMappings = {
	name = "DAP Plugin Keymaps",
	["b"] = { dap.toggle_breakpoint, "Debug: Toggle Breakpoint" },
	["B"] = { function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, "Debug: Set Breakpoint" },
}

-- Setup with default options
wk.setup {}

-- Registering mappings
wk.register(generalMappings, { prefix = "<leader>b", mode = "n" })

-- Registering LSP mappings
wk.register(lspMappings, { prefix = "<leader>L", mode = "n" })

-- Registering Telescope mappings under the 'n' (normal) mode leader key
wk.register(telescopeMappings, { prefix = "<leader>t", mode = "n" })

-- Registering Rnvimr mappings
wk.register(rnvimrMappings, { prefix = "<leader>r", mode = "n" })

-- Registering legendary.nvim mappings
wk.register(legendaryMappings, { prefix = "<leader>M", mode = "n" })

-- Registering legendary.nvim mappings
wk.register(liveServerMappings, { prefix = "<leader>S", mode = "n" })

-- Registering Tmux Telescope mappings under the 'n' (normal) mode leader key
wk.register(tmuxTelescopeMappings, { prefix = "<leader>T", mode = "n" })

-- Registering ChatGPT Keymaps
wk.register(chatgptMappings, { prefix = "<leader>c" })

-- Registering DAP mappings under the 'n' (normal) mode leader key
-- Note: F-keys are registered globally, not under a leader key.
wk.register(dapMappings, { prefix = "d", mode = "n" })

-- For F-keys which are not under the leader key, you can register them separately
wk.register({
	["<F1>"] = { dap.step_into, "Debug: Step Into" },
	["<F2>"] = { dap.step_over, "Debug: Step Over" },
	["<F3>"] = { dap.step_out, "Debug: Step Out" },
	["<F5>"] = { dap.continue, "Debug: Start/Continue" },
	["<F7>"] = { dapui.toggle, "Debug: See last session result." },
}, { mode = "n", prefix = "" })

-- Registering Harpoon mappings under the 'n' (normal) mode leader key
wk.register(harpoonMappings, { prefix = "<leader>h", mode = "n" })

-- Registering numeric mappings for selecting Harpoon files
for i = 1, 9 do
	local desc = "Harpoon to File " .. i
	local action = function() harpoon:list():select(i) end

	wk.register({
		[tostring(i)] = { action, desc }
	}, { prefix = "<leader>h", mode = "n" })
end

-- Registering Obsidian mappings under the 'n' (normal) mode leader key
-- Invoke only if Obsidian is loaded
local function isInObsidianVault()
	local obsidian_config_path = vim.fn.getcwd() .. "/.obsidian"
	return vim.fn.isdirectory(obsidian_config_path) ~= 0
end

if isInObsidianVault() then
	local status = pcall(require, 'obsidian')
	if status then
		wk.register(obsidianMappings, { prefix = "<leader>o", mode = "n" })
	end
end

-- Registering Lazy mappings under the 'n' (normal) mode leader key
wk.register(lazyMappings, { prefix = "<leader>l", mode = "n" })

-- Registering Flash mappings with which-key
for key, mapping in pairs(flashMappings) do
	local mode = mapping.mode or "n" -- default to normal mode if mode not provided
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			wk.register({ [key] = mapping }, { prefix = "<leader>F", mode = m })
		end
	else
		wk.register({ [key] = mapping }, { prefix = "<leader>F", mode = mode })
	end
end

-- Registering Git mappings under the 'n' (normal) mode leader key
wk.register(gitMappings, { prefix = "<leader>g", mode = "n" })

-- Registering CLI mappings under the 'n' (normal) mode leader key
wk.register(cliMappings, { prefix = "<leader>C", mode = "n" })

-- Registering Default Keymaps Names
wk.register({
	["<leader>f"] = "File Keymaps",
	["<leader>u"] = "Toggle Keymaps",
	["<leader>q"] = "Quit",
	["<leader>w"] = "Window Managment",
	["<leader>x"] = "Lists",
	["<leader><Tab>"] = "Tab Managment",
	["<leader>["] = "Previous",
	["<leader>]"] = "Next",
	["<leader>g"] = "Git & Misc.",
	["<leader>z"] = "Fold Managment",
})
