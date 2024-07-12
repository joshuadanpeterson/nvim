-- This config file contains my keymaps
-- lua/config/keymaps.lua

-- import dependencies
local wk = require 'which-key'
local harpoon = require 'harpoon'
local dap = require 'dap'
local dapui = require 'dapui'
local tmux = require 'config.tmux'

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

-- Configure Telescope Harpoon
-- import telescope modules
local conf = require('telescope.config').values
local harpoon = require('harpoon').setup {}

local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
      .new({}, {
        prompt_title = 'harpoon',
        finder = require('telescope.finders').new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
end

-- Function to toggle inlay hints
local function toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
end

-- General and Basic Keymaps
local generalMappings = {
  name = 'General and Basic Keymaps',
  -- ['<Space>'] = { '<Nop>', "No Operation" },
  ['k'] = { "v:count == 0 ? 'gk' : 'k'", 'Move up (respecting display lines)', expr = true },
  ['j'] = { "v:count == 0 ? 'gj' : 'j'", 'Move down (respecting display lines)', expr = true },
  ['c'] = { ":lua require('Comment.api').toggle_current_linewise()<CR>", 'Toggle comment for current line', mode = { 'n', 'v' } },
  ['<Esc>'] = { "<ESC>:noh<CR>:require('notify').dismiss()<CR>", 'Clear search highlight and notifications' },
  ['l'] = { refresh_lualine, 'Refresh status line' },
  ['n'] = { '<cmd>Noice<cr>', 'Noice' },
  ['d'] = { ':NoiceDismiss<CR>', 'Dismiss Noice Message' },
  ['L'] = { ':SearchLogFiles<CR>', 'Search Log Files' },
  ['C'] = { ':SearchChangelogFiles<CR>', 'Search Changelog Files' },
  ['o'] = { ':Oil --float<CR>', 'Modify Filetree in Buffer' },
  ['p'] = { ':PasteImage<CR>', 'Paste Image to Markdown' },
}

-- Vim Dadbod (SQL) Keymaps
local vimDadbodMappings = {
  name = 'Vim Dadbod (SQL) Keymaps',
  ['b'] = { ':DBUI<CR>', 'DBUI' },
  ['t'] = { ':DBUIToggle<CR>', 'DBUIToggle' },
  ['f'] = { ':DBUIFindBuffer<CR>', 'DBUIFindBuffer' },
  ['a'] = { ':DBUIAddConnection<CR>', 'DBUIAddConnection' },
  ['l'] = { ':DBLastQueryInfo<CR>', 'DBLastQueryInfo' },
  ['c'] = { ':DBUIClose<CR>', 'DBUIClose' },
  ['C'] = { ':DBCompletionClearCache<CR>', 'DBCompletionClearCache' },
  ['h'] = { ':DBUIHideNotifications<CR>', 'Hide Notifications ' },
}

-- LSP Keymaps
local lspMappings = {
  name = 'LSP Keymaps',
  ['r'] = { ':Lspsaga rename<CR>', 'Rename' },
  ['c'] = { ':Lspsaga code_action', 'Code Action' },
  ['d'] = { ':Lspsaga peek_definition<CR>', 'Peek Definition' },
  ['R'] = { require('telescope.builtin').lsp_references, 'Goto References' },
  ['i'] = { ':Lspsaga finder<CR>', 'Show References and Implementations' },
  ['t'] = { ':Lspsaga peek_type_definition<CR>', 'Peek Type Definition' },
  ['s'] = { require('telescope.builtin').lsp_document_symbols, 'Document Symbols' },
  ['w'] = { require('telescope.builtin').lsp_workspace_symbols, 'Workspace Symbols' },
  ['H'] = { ':Lspsaga hover_doc<CR>', 'Hover Documentation' },
  ['S'] = { vim.lsp.buf.signature_help, 'Signature Help' },
  ['g'] = { vim.lsp.buf.declaration, 'Goto Declaration' },
  ['a'] = { vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder' },
  ['x'] = { vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder' },
  ['l'] = {
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    'List Workspace Folders',
  },
}

-- Diagnostic Mappings
local diagnosticMappings = {
  name = 'Diagnostic Mappings',
  ['h'] = { vim.diagnostic.open_float, 'Show Diagnostic Hover' },
  ['i'] = { require('telescope.builtin').diagnostics, 'Search Workspace Diagnostics' },
  ['d'] = {
    function()
      require('telescope.builtin').diagnostics { bufnr = 0 }
    end,
    'Search Buffer Diagnostics',
  },
  ['D'] = { ':Lspsaga show_buf_diagnostics<CR>', 'Show Buffer Diagnostics' },
  ['W'] = { ':Lspsaga show_workspace_diagnostics<CR>', 'Show Workspace Diagnostics' },
  [']'] = { ':Lspsaga diagnostic_jump_prev<CR>', 'Previous Diagnostic' },
  ['['] = { ':Lspsaga diagnostic_jump_next<CR>', 'Next Diagnostic' },
  ['f'] = {
    function()
      vim.lsp.buf.format { async = true }
    end,
    'Format Document',
  },
  ['o'] = { ':Lspsaga outline<CR>', 'Outline Doc' },
  ['n'] = { ':FuzzyNoice<CR>', 'Search Noice Messages' },
  ['N'] = { '<cmd>Telescope notify<CR>', 'Search Notify Messages' },
  ['m'] = { ':messages<CR>', 'Get Messages' },
  ['l'] = { ':LspInfo<CR>', 'Get LspInfo' },
  ['c'] = { ':CmpStatus<CR>', 'Get CmpStatus' },
  ['C'] = { ':ConformInfo<CR>', 'Get ConformInfo' },
  ['t'] = { ':Trouble<CR>', 'Get Trouble' },
  ['q'] = { require('telescope.builtin').quickfix(), 'Search Quickfix List' },
  ['s'] = { ':NoiceStats<CR>', 'Noice Stats' },
  ['e'] = { ':NoiceErrors<CR>', 'Noice Errors' },
  ['a'] = { ':NoiceAll<CR>', 'Noice All' },
  ['b'] = { ':NoiceDebug<CR>', 'Noice Debug' },
  ['I'] = { ':Inspect<CR>', 'Inspect' },
  ['x'] = { ':TodoTelescope<CR>', 'Search TODOs in Telescope' },
  ['X'] = { ':TodoTrouble<CR>', 'Search TODOs in Trouble' },
  ['p'] = { ':TSPlaygroundToggle<CR>:lua vim.defer_fn(function() vim.cmd("wincmd L") end, 50)<CR>', 'Open Treesitter Playground' },
}

-- GitHub Copilot Chat Mappings
local copilotMappings = {
  name = 'GitHub Copilot Chat Mappings',
  ['x'] = { ':CopilotChatToggle<CR>', 'Toggle Copilot Chat' },
  ['s'] = { ':CopilotChatStop<CR>', 'Stop Current Copilot Output' },
  ['r'] = { ':CopilotChatReset<CR>', 'Reset Chat Window' },
  ['e'] = { ':CopilotChatExplain<CR>', 'Explain Selection' },
  ['R'] = { ':CopilotChatReview<CR>', 'Review Selection' },
  ['f'] = { ':CopilotChatFix<CR>', 'Fix Bug' },
  ['o'] = { ':CopilotChatOptimize<CR>', 'Optimize Selection' },
  ['d'] = { ':CopilotChatDocs<CR>', 'Add Docs for Selection' },
  ['t'] = { ':CopilotChatTests<CR>', 'Generate Tests' },
  ['D'] = { ':CopilotChatFixDiagnostic<CR>', 'Assist with Diagnostic' },
  ['c'] = { ':CopilotChatCommit<CR>', 'Write Commit Message' },
  ['S'] = { ':CopilotChatCommitStaged<CR>', 'Write Commit Message for Staged Change' },
  ['i'] = { ':CopilotChatDebugInfo<CR>', 'Show Debug Info' },
  -- TODO: Work out how to add inputs to commands
  -- ['S'] = { 'CopilotChatSave <name>?', 'Save Chat History to File' },
  -- ['L'] = { 'CopilotChatLoad <name>?', 'Load Chat History from File' },
}

-- Trouble Mappings
local troubleMappings = {
  name = 'Trouble Mappings',
}

-- Plugin Mappings
local pluginMappings = {
  name = 'Plugin Mappings',
  ['m'] = { ':Mason<CR>', 'Search Mason' },
  ['l'] = { '<cmd>Telescope lazy<CR>', 'Search Lazy for Plugins' },
  ['L'] = { ':Lazy<CR>', 'Open Lazy' },
  ['e'] = { ':LazyExtras<CR>', 'Open LazyExtras' },
}

-- UI Mappings
local uiMappings = {
  name = 'UI Mappings',
  ['c'] = { ':Telescope colorscheme<CR>', 'Search Colorschemes' },
  ['e'] = { ':Telescope emoji<CR>', 'Search Emojis' },
  ['E'] = { ':InsertEmojiByGroup<CR>', 'Search Emojis by Group' },
  ['s'] = { ':CodeSnap<CR>', 'CodeSnap' },
  ['S'] = { ':CodeSnapSave<CR>', 'Save CodeSnap' },
  ['h'] = { ':CodeSnapHighlight<CR>', 'CodeSnap Highlight' },
  ['H'] = { ':CodeSnapSaveHighlight<CR>', 'CodeSnap Save Highlight' },
}

-- view mappings
local viewMappings = {
  name = 'View Mappings',
  ['M'] = { ':TWCenter<CR>', 'Center Code Block' },
  ['z'] = { ':ZenMode<CR>', 'Toggle ZenMode' },
  ['t'] = { ':Twilight<CR>', 'Enable Twlight' },
  ['a'] = { ':TZAtaraxis<CR>', 'Toggle True Zen: Ataraxis Mode' },
  ['m'] = { ':TZMinimalist<CR>', 'Toggle True Zen: Minimalist Mode' },
  ['n'] = { ':TZNarrow<CR>', 'Toggle True Zen: Narrow Mode' },
  ['f'] = { ':TZFocus<CR>', 'Toggle True Zen: Focus Mode' },
  ['T'] = { ':TWToggle<CR>', 'Toggle Typewriter' },
  ['H'] = { ':TWTop<CR>', 'Move Code Block to Top of Screen' },
  ['L'] = { ':TWBottom<CR>', 'Move Code Block to Bottom of Screen' },
  ['h'] = { toggle_inlay_hints, 'Toggle Inlay Hints' },
  ['p'] = { ':MarkdownPreview<CR>', 'Markdown Preview' },
  ['r'] = { ':RenderMarkdownToggle<CR>', 'Render Markdown' },
}

-- Telescope Keymaps
local telescopeMappings = {
  name = 'Telescope Keymaps',
  ['f'] = {
    function()
      require('telescope.builtin').find_files {
        find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
      }
    end,
    'Search Files',
  },
  ['R'] = { '<cmd>Telescope registers<CR>', 'Search Registers' },
  ['b'] = { require('telescope.builtin').current_buffer_fuzzy_find, 'Search Current Buffer' },
  ['h'] = { ':FuzzyHelp<CR>', 'Search Help' },
  ['w'] = { require('telescope.builtin').grep_string, 'Search Current Word' },
  ['g'] = { require('telescope.builtin').live_grep, 'Search by Grep' },
  ['G'] = { '<cmd>Telescope helpgrep<CR>', 'Search Grep Help' },
  ['r'] = { require('telescope.builtin').resume, 'Resume Last Search' },
  ['c'] = { require('telescope.builtin').commands, 'Search Telescope Commands' },
  ['C'] = { require('telescope.builtin').command_history, 'Search Command History' },
  ['H'] = { require('telescope.builtin').search_history, 'Search History' },
  ['M'] = { ':FuzzyMan<CR>', 'Search Man Pages' },
  ['m'] = { require('telescope.builtin').keymaps, 'Search Keymaps' },
  ['s'] = { require('telescope.builtin').spell_suggest, 'Search Spelling Suggestions' },
  ['D'] = { ':Dash<CR>', 'Search Dash' },
  ['W'] = { ':DashWord<CR>', 'Search Dash by word' },
  ['t'] = { '<cmd>Telescope themes<CR>', 'Search Themes' },
  ['?'] = { require('telescope.builtin').oldfiles, '[?] Find recently opened files' },
  ['S'] = { '<cmd>Telescope uniswapfiles telescope_swap_files<CR>', 'Search Swap Files' },
  ['o'] = { '<cmd>Telescope oldfiles<cr>', 'Recent Files' },
  ['B'] = { '<cmd>Telescope buffers<cr>', 'List Buffers' },
  ['z'] = { '<cmd>Telescope zoxide list<CR>', 'Zoxide List' },
  ['p'] = { '<cmd>Tldr<CR>', 'Search tldr pages' },
  ['j'] = {
    function()
      if vim.bo.filetype == 'json' then
        -- Add a debug print before calling Telescope
        print('Calling Telescope jsonfly with filetype: ' .. vim.bo.filetype)
        vim.cmd 'Telescope jsonfly'
      else
        print('This command is only available for JSON files. Current filetype: ' .. vim.bo.filetype)
      end
    end,
    'Search JSON with jsonfly',
  },
  ['T'] = { ':Telescope treesitter<CR>', 'Search Treesitter' },
}

-- Rnvimr and Ranger Keymaps
local rnvimrMappings = {
  name = 'Rnvimr and Ranger Keymaps',
  ['t'] = { ':RnvimrToggleeCR>', 'Toggle Rnvimr' },
  ['r'] = { ':RnvimrResize<CR>', 'Resize Rnvimr' },
  ['n'] = {
    function()
      require('ranger-nvim').open(true)
    end,
    'Open Ranger',
  },
}

-- legendary.nvim Keymaps
local legendaryMappings = {
  name = 'Legendary Keymaps',
  ['g'] = { ':Legendary<CR>', 'Search Legendary' },
  ['k'] = { ':Legendary keymaps<CR>', 'Search Legendary Keymaps' },
  ['c'] = { ':Legendary commands<CR>', 'Search Legendary Commands' },
  ['f'] = { ':Legendary functions<CR>', 'Search Legendary Functions' },
  ['a'] = { ':Legendary autocmds<CR>', 'Search Legendary Autocmds' },
  ['r'] = { ':LegendaryRepeat<CR>', 'Repeat Last Item Executed' },
  ['!'] = { ':LegendaryRepeat!eCR>', 'Repeat Last Item Executed, no filters' },
  ['s'] = { ':LegendaryScratch<CR>', 'Launch Scratch Pad' },
}

-- Tmux Telescope Plugin Keymaps
local tmuxTelescopeMappings = {
  name = 'tmux Telescope Keymaps',
  ['t'] = { ':TmuxJumpFile<CR>', 'Jump to File in Tmux Pane' },
  [';'] = { ':TmuxJumpFirst<CR>', 'Jump to First Tmux Pane' },
  ['s'] = { tmux.switch_to_tmux_session, 'Switch Tmux Session', { noremap = true, silent = true } },
  ['w'] = { tmux.switch_tmux_window, 'Switch Tmux Window', { noremap = true, silent = true } },
  ['p'] = { tmux.switch_tmux_pane, 'Switch Tmux Pane', { noremap = true, silent = true } },
  ['m'] = { tmux.tmux_menu_picker, 'Tmux Menu Picker', { noremap = true, silent = true } },
}

-- Harpoon Keymaps
local harpoonMappings = {
  name = 'Harpoon Keymaps',
  ['a'] = {
    function()
      harpoon:list():add()
    end,
    'Add File to Harpoon Menu',
  },
  ['r'] = {
    function()
      harpoon:list():remove()
    end,
    'Remove File from Harpoon Menu',
  },
  ['p'] = {
    function()
      harpoon.nav.prev()
    end,
    'Previous Harpoon File',
  },
  ['n'] = {
    function()
      harpoon.nav.next()
    end,
    'Next Harpoon File',
  },
  ['e'] = {
    function()
      toggle_telescope(harpoon:list())
    end,
    'Open Harpoon Window',
  },
}

-- Obsidian Keymaps
local obsidianMappings = {
  name = 'Obsidian Keymaps',
  ['n'] = {
    function()
      return require('obsidian').util.gf_passthrough()
    end,
    'Go to Note Under Cursor',
    opts = { noremap = false, expr = true, buffer = true },
  },
  ['c'] = {
    function()
      return require('obsidian').util.toggle_checkbox()
    end,
    'Toggle Checkboxes',
    opts = { buffer = true },
  },
  ['p'] = { ':SearchObsidianProgramming<CR>', 'Search Obsidian Programming Vault' },

  -- Adding new mappings for Obsidian commands
  ['o'] = { '<cmd>ObsidianOpen<CR>', 'Open Note in Obsidian' },
  ['N'] = { '<cmd>ObsidianNew<CR>', 'Create New Note' },
  ['q'] = { '<cmd>ObsidianQuickSwitch<CR>', 'Quick Switch Note' },
  ['f'] = { '<cmd>ObsidianFollowLink<CR>', 'Follow Note Link' },
  ['b'] = { '<cmd>ObsidianBacklinks<CR>', 'Show Backlinks' },
  ['t'] = { '<cmd>ObsidianTags<CR>', 'Show Tags' },
  ['d'] = { '<cmd>ObsidianToday<CR>', "Open Today's Note" },
  ['y'] = { '<cmd>ObsidianYesterday<CR>', "Open Yesterday's Note" },
  ['m'] = { '<cmd>ObsidianTomorrow<CR>', "Open Tomorrow's Note" },
  ['D'] = { '<cmd>ObsidianDailies<CR>', 'List Daily Notes' },
  ['T'] = { '<cmd>ObsidianTemplate<CR>', 'Insert Template' },
  ['s'] = { '<cmd>ObsidianSearch<CR>', 'Search Notes' },
  ['l'] = { '<cmd>ObsidianLink<CR>', 'Link Note' },
  ['L'] = { '<cmd>ObsidianLinkNew<CR>', 'Link to New Note' },
  ['S'] = { '<cmd>ObsidianLinks<CR>', 'List Links' },
  ['E'] = { '<cmd>ObsidianExtractNote<CR>', 'Extract Note' },
  ['w'] = { '<cmd>ObsidianWorkspace<CR>', 'Switch Workspace' },
  ['i'] = { '<cmd>ObsidianPasteImg<CR>', 'Paste Image' },
  ['R'] = { '<cmd>ObsidianRename<CR>', 'Rename Note' },
}

-- Lazy Keymaps
local lazyMappings = {
  name = 'Lazy Keymaps',
  ['r'] = { ':LazyRoot<CR>', 'Open LazyRoot' },
  ['f'] = { ':LazyFormat<CR>', 'Open LazyFormat' },
  ['h'] = { ':LazyHealth<CR>', 'Open LazyHealth' },
  ['i'] = { ':LazyFormatInfo<CR>', 'Open LazyFormatInfo' },
}

-- Flash Keymaps
local flashMappings = {
  name = 'Flash Keymaps',
  ['s'] = {
    function()
      require('flash').jump()
    end,
    'Flash',
    mode = { 'n', 'x', 'o' },
  },
  ['t'] = {
    function()
      require('flash').treesitter()
    end,
    'Flash Treesitter',
    mode = { 'n', 'x', 'o' },
  },
  ['r'] = {
    function()
      require('flash').remote()
    end,
    'Remote Flash',
    mode = 'o',
  },
  ['R'] = {
    function()
      require('flash').treesitter_search()
    end,
    'Treesitter Search',
    mode = { 'o', 'x' },
  },
  ['T'] = {
    function()
      require('flash').toggle()
    end,
    'Toggle Flash Search',
    mode = 'c',
  },
}

-- Git Keymaps
local gitMappings = {
  name = 'Git Keymaps',
  ['r'] = { require('telescope.builtin').git_files, 'Search Git Files' },
  ['s'] = { require('telescope.builtin').git_stash, 'Search Git Stash' },
  ['S'] = { require('telescope.builtin').git_status, 'Search Git Status' },
  ['C'] = { '<cmd>Telescope git_bcommits<CR>', 'Search Git Buffer Commits' },
  ['d'] = { require('telescope.builtin').git_commits, 'Search Git Directory Commits' },
  ['b'] = { require('telescope.builtin').git_branches, 'Search Git Branches' },
  ['p'] = { '<cmd>Telescope git_signs<CR>', 'Search Preview Hunks' },
  ['T'] = { ':Gitsigns toggle_current_line_blame<CR>', 'Toggle Git Blame' },
  ['t'] = { '<cmd>Telescope repo list<CR>', 'Search Git Repos' },
  ['c'] = { ':LazyGitConfig<CR>', 'Open Lazygit Config' },
  ['g'] = { ':LazyGit<CR>', 'Open LazyGit' },
  ['h'] = { ':Gitsigns preview_hunk_inline', 'Inline Hunk Preview' },
  ['D'] = { ':Gitsigns diffthis', 'Show Diff' },
  ['P'] = { ':Gitsigns preview_hunk', 'Show Hunk Preview Hover' },
}

-- ChatGPT Keymaps
local chatgptMappings = {
  name = 'ChatGPT Keymaps',
  ['c'] = { '<cmd>ChatGPT<CR>', 'ChatGPT' },
  ['C'] = { '<cmd>Telescope gpt<CR>', 'Telescope GPT' },
  ['e'] = { '<cmd>ChatGPTEditWithInstruction<CR>', 'Edit with instruction', mode = { 'n', 'v' } },
  ['g'] = { '<cmd>ChatGPTRun grammar_correction<CR>', 'Grammar Correction', mode = { 'n', 'v' } },
  ['t'] = { '<cmd>ChatGPTRun translate<CR>', 'Translate', mode = { 'n', 'v' } },
  ['k'] = { '<cmd>ChatGPTRun keywords<CR>', 'Keywords', mode = { 'n', 'v' } },
  ['d'] = { '<cmd>ChatGPTRun docstring<CR>', 'Docstring', mode = { 'n', 'v' } },
  ['a'] = { '<cmd>ChatGPTRun add_tests<CR>', 'Add Tests', mode = { 'n', 'v' } },
  ['o'] = { '<cmd>ChatGPTRun optimize_code<CR>', 'Optimize Code', mode = { 'n', 'v' } },
  ['s'] = { '<cmd>ChatGPTRun summarize<CR>', 'Summarize', mode = { 'n', 'v' } },
  ['f'] = { '<cmd>ChatGPTRun fix_bugs<CR>', 'Fix Bugs', mode = { 'n', 'v' } },
  ['x'] = { '<cmd>ChatGPTRun explain_code<CR>', 'Explain Code', mode = { 'n', 'v' } },
  ['r'] = { '<cmd>ChatGPTRun roxygen_edit<CR>', 'Roxygen Edit', mode = { 'n', 'v' } },
  ['l'] = { '<cmd>ChatGPTRun code_readability_analysis<CR>', 'Code Readability Analysis', mode = { 'n', 'v' } },
}

-- CLI App Keymaps
local cliMappings = {
  name = 'CLI App Mappings',
  ['t'] = { ':Lspsaga term_toggle<CR>', 'Launch Terminal' }, -- Launch Terminal
  ['d'] = { '<cmd>FloatermNew lazydocker<CR>', 'Launch Lazydocker' }, -- Launch Lazydocker: docker
  ['p'] = { '<cmd>FloatermNew python<CR>', 'Launch Python3 REPL' }, -- Launch Python3 REPL: python
  ['n'] = { '<cmd>FloatermNew node<CR>', 'Launch Node REPL' }, -- Launch Node REPL: javascript
  ['h'] = { '<cmd>FloatermNew htop<CR>', 'Launch htop' }, -- Launch htop: resource management
  ['b'] = { '<cmd>FloatermNew bpytop<CR>', 'Launch Bpytop' }, -- Launch bpytop: resource management
}

-- DAP Plugin Keymaps
local dapMappings = {
  name = 'DAP Plugin Keymaps',
  ['b'] = { dap.toggle_breakpoint, 'Debug: Toggle Breakpoint' },
  ['B'] = {
    function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end,
    'Debug: Set Breakpoint',
  },
}

-- Setup with default options
wk.setup {}

-- Registering mappings
wk.register(generalMappings, { prefix = '<leader>b', mode = 'n' })

-- Registering DBUI mappings
wk.register(vimDadbodMappings, { prefix = '<leader>s', mode = 'n' })

-- Registering LSP mappings
wk.register(lspMappings, { prefix = '<leader>L', mode = 'n' })

-- Registering LSP mappings
wk.register(diagnosticMappings, { prefix = '<leader>D', mode = 'n' })

-- Registering Trouble mappings
wk.register(troubleMappings, { prefix = '<leader>x', mode = 'n' })

-- Registering GitHub Copilot Chat mappings
wk.register(copilotMappings, { prefix = '<leader>G', mode = 'n' })

-- Registering UI mappings
wk.register(uiMappings, { prefix = '<leader>U', mode = 'n' })

-- Registering View mappings
wk.register(viewMappings, { prefix = '<leader>v', mode = 'n' })

-- Registering Trouble mappings
wk.register(pluginMappings, { prefix = '<leader>p', mode = 'n' })

-- Registering Telescope mappings under the 'n' (normal) mode leader key
wk.register(telescopeMappings, { prefix = '<leader>t', mode = 'n' })

-- Registering Rnvimr mappings
wk.register(rnvimrMappings, { prefix = '<leader>r', mode = 'n' })

-- Registering legendary.nvim mappings
wk.register(legendaryMappings, { prefix = '<leader>M', mode = 'n' })

-- Registering Tmux Telescope mappings under the 'n' (normal) mode leader key
wk.register(tmuxTelescopeMappings, { prefix = '<leader>T', mode = 'n' })

-- Registering ChatGPT Keymaps
wk.register(chatgptMappings, { prefix = '<leader>c' })

-- Registering DAP mappings under the 'n' (normal) mode leader key
-- Note: F-keys are registered globally, not under a leader key.
wk.register(dapMappings, { prefix = 'd', mode = 'n' })

-- For F-keys which are not under the leader key, you can register them separately
wk.register({
  ['<F1>'] = { dap.step_into, 'Debug: Step Into' },
  ['<F2>'] = { dap.step_over, 'Debug: Step Over' },
  ['<F3>'] = { dap.step_out, 'Debug: Step Out' },
  ['<F5>'] = { dap.continue, 'Debug: Start/Continue' },
  ['<F7>'] = { dapui.toggle, 'Debug: See last session result.' },
}, { mode = 'n', prefix = '' })

-- Registering Harpoon mappings under the 'n' (normal) mode leader key
wk.register(harpoonMappings, { prefix = '<leader>h', mode = 'n' })

-- Registering numeric mappings for selecting Harpoon files
for i = 1, 9 do
  local desc = 'Harpoon to File ' .. i
  local action = function()
    harpoon:list():select(i)
  end

  wk.register({
    [tostring(i)] = { action, desc },
  }, { prefix = '<leader>h', mode = 'n' })
end

-- Registering Obsidian mappings under the 'n' (normal) mode leader key
-- Invoke only if Obsidian is loaded
local function isInObsidianVault()
  local obsidian_config_path = vim.fn.getcwd() .. '/.obsidian'
  return vim.fn.isdirectory(obsidian_config_path) ~= 0
end

if isInObsidianVault() then
  local status = pcall(require, 'obsidian')
  if status then
    wk.register(obsidianMappings, { prefix = '<leader>o', mode = 'n' })
  end
end

-- Registering Lazy mappings under the 'n' (normal) mode leader key
wk.register(lazyMappings, { prefix = '<leader>l', mode = 'n' })

-- Registering Flash mappings with which-key
for key, mapping in pairs(flashMappings) do
  local mode = mapping.mode or 'n' -- default to normal mode if mode not provided
  if type(mode) == 'table' then
    for _, m in ipairs(mode) do
      wk.register({ [key] = mapping }, { prefix = '<leader>F', mode = m })
    end
  else
    wk.register({ [key] = mapping }, { prefix = '<leader>F', mode = mode })
  end
end

-- Registering Git mappings under the 'n' (normal) mode leader key
wk.register(gitMappings, { prefix = '<leader>g', mode = 'n' })

-- Registering CLI mappings under the 'n' (normal) mode leader key
wk.register(cliMappings, { prefix = '<leader>C', mode = 'n' })

-- Registering Default Keymaps Names
wk.register {
  ['<leader>f'] = 'File Keymaps',
  ['<leader>u'] = 'Toggle Keymaps',
  ['<leader>q'] = 'Quit',
  ['<leader>w'] = 'Window Managment',
  ['<leader>x'] = 'Trouble',
  ['<leader><Tab>'] = 'Tab Managment',
  ['<leader>['] = 'Previous',
  ['<leader>]'] = 'Next',
  ['<leader>z'] = 'Fold Managment',
}

-- Noice LSP Hoever Doc Scrolling Keymaps
vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true })

