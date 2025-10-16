-- This config file contains my keymaps
-- lua/config/keymaps.lua

local M = {}

-- Wrap all keymap registration in a function to be called lazily
function M.setup()
  -- import dependencies
  local wk = require 'which-key'
  local harpoon = require 'harpoon'
  local dap = require 'dap'
  local dapui = require 'dapui'
  local tmux = require 'config.tmux'
  local jumper = require("telescope").extensions.jumper

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
  harpoon:setup()

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

  -- Set up kulala (commented out - plugin not currently loaded)
  -- local kulala = require 'kulala'

  -- Check if kulala is available
  local function is_kulala_available()
    local status, _ = pcall(require, 'kulala')
    return status
  end

  -- Register keymaps
  wk.add({
  -- General and Basic Keymaps
  { "<leader>b",      group = "General and Basic Keymaps" },
  { "<leader>bk",     "v:count == 0 ? 'gk' : 'k'",                                 desc = "Move up (respecting display lines)",      expr = true },
  { "<leader>bj",     "v:count == 0 ? 'gj' : 'j'",                                 desc = "Move down (respecting display lines)",    expr = true },
  { "<leader>bc",     ":lua require('Comment.api').toggle_current_linewise()<CR>", desc = "Toggle comment for current line",         mode = { 'n', 'v' } },
  { "<leader>b<Esc>", "<ESC>:noh<CR>:require('notify').dismiss()<CR>",             desc = "Clear search highlight and notifications" },
  { "<leader>bl",     refresh_lualine,                                             desc = "Refresh status line" },
  { "<leader>bn",     "<cmd>Noice<cr>",                                            desc = "Noice" },
  { "<leader>bd",     ":NoiceDismiss<CR>",                                         desc = "Dismiss Noice Message" },
  { "<leader>bL",     ":SearchLogFiles<CR>",                                       desc = "Search Log Files" },
  { "<leader>bC",     ":SearchChangelogFiles<CR>",                                 desc = "Search Changelog Files" },
  { "<leader>bo",     ":Oil --float<CR>",                                          desc = "Modify Filetree in Buffer" },
  { "<leader>bp",     ":PasteImage<CR>",                                           desc = "Paste Image to Markdown" },

  -- HTTP Keymaps
  { "<leader>H",      group = "HTTP Keymaps" },
  -- Kulala keymaps (commented out - plugin not currently loaded)
  -- { "<leader>Hp",     ":lua require('kulala').jump_prev()<CR>",                                 desc = "Previous HTTP Request" },
  -- { "<leader>Hn",     ":lua require('kulala').jump_next()<CR>",                                 desc = "Next HTTP Request" },
  -- { "<leader>Hr",     ":vsplit | wincmd l | enew | lua require('kulala').run()<CR> | wincmd p", desc = "Send HTTP Request" },
  -- { "<leader>Ht",     ":lua require('kulala').toggle_view()<CR>",                               desc = "Toggle HTTP View" },
  { "<leader>Hh",     ':Hyper<CR>',                                                desc = "Open Hyper" },
  { "<leader>HR",     ':Rest run<CR>',                                             desc = "Run HTTP Request" },
  { "<leader>Hl",     ':Rest log<CR>',                                             desc = "Rest logs" },
  { "<leader>HL",     ':Rest run last<CR>',                                        desc = "Re-run last HTTP Request" },
  { "<leader>He",     ':Telescope rest select_env<CR>',                            desc = "Select .env file" },
  { "<leader>HP",     ':Rest result prev<CR>',                                     desc = "Cycle Previous Result" },
  { "<leader>HN",     ':Rest result next<CR>',                                     desc = "Cycle Next Result" },

  -- Vim Dadbod (SQL) Keymaps
  { "<leader>s",      group = "Vim Dadbod (SQL) Keymaps" },
  { "<leader>sb",     ':DBUI<CR>',                                                 desc = 'DBUI' },
  { "<leader>st",     ':DBUIToggle<CR>',                                           desc = 'DBUIToggle' },
  { "<leader>sf",     ':DBUIFindBuffer<CR>',                                       desc = 'DBUIFindBuffer' },
  { "<leader>sa",     ':DBUIAddConnection<CR>',                                    desc = 'DBUIAddConnection' },
  { "<leader>sl",     ':DBLastQueryInfo<CR>',                                      desc = 'DBLastQueryInfo' },
  { "<leader>sc",     ':DBUIClose<CR>',                                            desc = 'DBUIClose' },
  { "<leader>sC",     ':DBCompletionClearCache<CR>',                               desc = 'DBCompletionClearCache' },
  { "<leader>sh",     ':DBUIHideNotifications<CR>',                                desc = 'Hide Notifications' },

  -- LSP Keymaps
  { "<leader>l",      group = "LSP Keymaps" },
  { "<leader>lr",     ':Lspsaga rename<CR>',                                       desc = 'Rename' },
  { "<leader>lc",     ':Lspsaga code_action<CR>',                                  desc = 'Code Action' },
  { "<leader>ld",     ':Lspsaga peek_definition<CR>',                              desc = 'Peek Definition' },
  { "<leader>lR",     function() require('telescope.builtin').lsp_references() end,         desc = 'Goto References' },
  { "<leader>li",     ':Lspsaga finder<CR>',                                                  desc = 'Show References and Implementations' },
  { "<leader>lt",     ':Lspsaga peek_type_definition<CR>',                                    desc = 'Peek Type Definition' },
  { "<leader>ls",     function() require('telescope.builtin').lsp_document_symbols() end,    desc = 'Document Symbols' },
  { "<leader>lw",     function() require('telescope.builtin').lsp_workspace_symbols() end,   desc = 'Workspace Symbols' },
  { "<leader>lH",     ':Lspsaga hover_doc<CR>',                                    desc = 'Hover Documentation' },
  { "<leader>lS",     function() vim.lsp.buf.signature_help() end,                          desc = 'Signature Help' },
  { "<leader>lg",     function() vim.lsp.buf.declaration() end,                              desc = 'Goto Declaration' },
  { "<leader>la",     function() vim.lsp.buf.add_workspace_folder() end,                    desc = 'Add Workspace Folder' },
  { "<leader>lx",     function() vim.lsp.buf.remove_workspace_folder() end,                 desc = 'Remove Workspace Folder' },
  {
    "<leader>ll",
    function()
      vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()), vim.log.levels.INFO)
    end,
    desc = 'List Workspace Folders'
  },

  -- Diagnostic Mappings
  { "<leader>d",  group = "Diagnostic Mappings" },
  { "<leader>dh", function() vim.diagnostic.open_float() end,                        desc = 'Show Diagnostic Hover' },
  { "<leader>di", function() require('telescope.builtin').diagnostics() end,         desc = 'Search Workspace Diagnostics' },
  {
    "<leader>dd",
    function()
      require('telescope.builtin').diagnostics { bufnr = 0 }
    end,
    desc = 'Search Buffer Diagnostics'
  },
  { "<leader>dD", ':Lspsaga show_buf_diagnostics<CR>',      desc = 'Show Buffer Diagnostics' },
  { "<leader>dW", ':Lspsaga show_workspace_diagnostic<CR>', desc = 'Show Workspace Diagnostics' },
  { "<leader>d]", ':Lspsaga diagnostic_jump_prev<CR>',      desc = 'Previous Diagnostic' },
  { "<leader>d[", ':Lspsaga diagnostic_jump_next<CR>',      desc = 'Next Diagnostic' },
  {
    "<leader>df",
    function()
      vim.lsp.buf.format { async = true }
    end,
    desc = 'Format Document'
  },
  { "<leader>do", ':Lsaga outline<CR>',                                                                   desc = 'Outline Doc' },
  { "<leader>dn", ':FuzzyNoice<CR>',                                                                      desc = 'Search Noice Messages' },
  { "<leader>dN", '<cmd>Telescope notify<CR>',                                                            desc = 'Search Notify Messages' },
  { "<leader>dm", ':messages<CR>',                                                                        desc = 'Get Messages' },
  { "<leader>dl", ':LspInfo<CR>',                                                                         desc = 'Get LspInfo' },
  { "<leader>dc", ':CmpStatus<CR>',                                                                       desc = 'Get CmpStatus' },
  { "<leader>dC", ':ConformInfo<CR>',                                                                     desc = 'Get ConformInfo' },
  { "<leader>dq", function() require('telescope.builtin').quickfix() end,                                 desc = 'Search Quickfix List' },
  { "<leader>ds", ':NoiceStats<CR>',                                                                      desc = 'Noice Stats' },
  { "<leader>de", ':NoiceErrors<CR>',                                                                     desc = 'Noice Errors' },
  { "<leader>da", ':NoiceAll<CR>',                                                                        desc = 'Noice All' },
  { "<leader>dB", ':NoiceDebug<CR>',                                                                      desc = 'Noice Debug' },
  { "<leader>dI", ':Inspect<CR>',                                                                         desc = 'Inspect' },
  { "<leader>dx", ':TodoTelescope<CR>',                                                                   desc = 'Search TODOs in Telescope' },
  { "<leader>dp", ':TSPlaygroundToggle<CR>:lua vim.defer_fn(function() vim.cmd("wincmd L") end, 50)<CR>', desc = 'Open Treesitter Playground' },

  -- GitHub Copilot Chat Mappings
  { "<leader>G",  group = "GitHub Copilot Chat Mappings" },
  { "<leader>Gx", ':CopilotChatToggle<CR>',                                                               desc = 'Toggle Copilot Chat' },
  { "<leader>Gs", ':CopilotChatStop<CR>',                                                                 desc = 'Stop Current Copilot Output' },
  { "<leader>Gr", ':CopilotChatReset<CR>',                                                                desc = 'Reset Chat Window' },
  { "<leader>Ge", ':CopilotChatExplain<CR>',                                                              desc = 'Explain Selection' },
  { "<leader>GR", ':CopilotChatReview<CR>',                                                               desc = 'Review Selection' },
  { "<leader>Gf", ':CopilotChatFix<CR>',                                                                  desc = 'Fix Bug' },
  { "<leader>Go", ':CopilotChatOptimize<CR>',                                                             desc = 'Optimize Selection' },
  { "<leader>Gd", ':CopilotChatDocs<CR>',                                                                 desc = 'Add Docs for Selection' },
  { "<leader>Gt", ':CopilotChatTests<CR>',                                                                desc = 'Generate Tests' },
  { "<leader>GD", ':CopilotChatFixDiagnostic<CR>',                                                        desc = 'Assist with Diagnostic' },
  { "<leader>Gc", ':CopilotChatCommit<CR>',                                                               desc = 'Write Commit Message' },
  { "<leader>GS", ':CopilotChatCommitStaged<CR>',                                                         desc = 'Write Commit Message for Staged Change' },
  { "<leader>Gi", ':CopilotChatDebugInfo<CR>',                                                            desc = 'Show Debug Info' },
  -- TODO: Additional future mappings
  -- { "<leader>GS", 'CopilotChatSave <name>?', desc = 'Save Chat History to File' },
  -- { "<leader>GL", 'CopilotChatLoad <name>?', desc = 'Load Chat History from File' },

  -- Trouble Mappings
  { "<leader>T",  group = "Trouble Mappings" },
  { "<leader>Tt", ':Trouble<CR>',                                                                         desc = 'Toggle Trouble' },
  { "<leader>Td", ':Trouble lsp_document_diagnostics<CR>',                                                desc = 'Document Diagnostics' },
  { "<leader>Tw", ':Trouble lsp_workspace_diagnostics<CR>',                                               desc = 'Workspace Diagnostics' },
  { "<leader>Tr", ':Trouble lsp_references<CR>',                                                          desc = 'LSP References' },
  { "<leader>Tf", ':Trouble lsp_definitions<CR>',                                                         desc = 'LSP Definitions' },
  { "<leader>TT", ':Trouble lsp_type_definitions<CR>',                                                    desc = 'LSP Type Definitions' },
  { "<leader>Ti", ':Trouble lsp_implementations<CR>',                                                     desc = 'LSP Implementations' },
  { "<leader>Ts", ':Trouble lsp_document_symbols<CR>',                                                    desc = 'Document Symbols' },
  { "<leader>Tc", ':Trouble lsp_incoming_calls<CR>',                                                      desc = 'LSP Incoming Calls' },
  { "<leader>To", ':Trouble lsp_outgoing_calls<CR>',                                                      desc = 'LSP Outgoing Calls' },
  { "<leader>Tq", ':Trouble quickfix<CR>',                                                                desc = 'Quickfix' },
  { "<leader>Tl", ':Trouble loclist<CR>',                                                                 desc = 'Location List' },
  { "<leader>Tx", ':TodoTrouble<CR>',                                                                     desc = 'Search TODOs in Trouble' },

  -- Plugin Mappings
  { "<leader>p",  group = "Plugin Mappings" },
  { "<leader>pm", ':Mason<CR>',                                                                           desc = 'Search Mason' },
  { "<leader>pl", '<cmd>Telescope lazy<CR>',                                                              desc = 'Search Lazy for Plugins' },
  { "<leader>pL", ':Lazy<CR>',                                                                            desc = 'Open Lazy' },
  { "<leader>pe", ':LazyExtras<CR>',                                                                      desc = 'Open LazyExtras' },


  -- Plugin Mappings for Pieces
  -- Disabled due to PydanticUndefinedAnnotation error with pieces_os_client
  { "<leader>P",  group = "Pieces Mappings" },

  -- -- Pieces General Commands
  { "<leader>Pp", ':PiecesHealth<CR>',                                                                    desc = 'Check Pieces Health' },
  { "<leader>Pv", ':PiecesOSVersion<CR>',                                                                 desc = 'Display Pieces OS Version' },
  { "<leader>Pg", ':PiecesPluginVersion<CR>',                                                             desc = 'Display Pieces Plugin Version' },

  -- -- Pieces Copilot Commands
  { "<leader>Pc", ':PiecesCopilot<CR>',                                                                   desc = 'Open Pieces Copilot' },
  { "<leader>Pn", ':PiecesConversations<CR>',                                                             desc = 'Open Pieces Copilot Conversations' },

  -- -- Pieces Asset Management Commands
  { "<leader>Ps", ':PiecesSnippets<CR>',                                                                  desc = 'List All Snippets' },
  { "<leader>Pd", ':PiecesCreateSnippet<CR>',                                                             desc = 'Create Snippet from Selection' },

  -- -- Pieces Auth Commands
  { "<leader>Pa", ':PiecesAccount<CR>',                                                                   desc = 'Show Pieces Account Info' },
  { "<leader>Pi", ':PiecesLogin<CR>',                                                                     desc = 'Login to Pieces Account' },
  { "<leader>Po", ':PiecesLogout<CR>',                                                                    desc = 'Logout from Pieces Account' },
  { "<leader>Pc", ':PiecesConnectCloud<CR>',                                                              desc = 'Connect to Pieces Cloud' },
  { "<leader>Px", ':PiecesDisconnectCloud<CR>',                                                           desc = 'Disconnect from Pieces Cloud' },

  -- UI Mappings
  { "<leader>u",  group = "UI Mappings" },
  { "<leader>uc", ':Telescope colorscheme<CR>',                                                           desc = 'Search Colorschemes' },
  { "<leader>ue", ':Telescope emoji<CR>',                                                                 desc = 'Search Emojis' },
  { "<leader>uE", ':InsertEmojiByGroup<CR>',                                                              desc = 'Search Emojis by Group' },
  { "<leader>us", ':CodeSnap<CR>',                                                                        desc = 'CodeSnap' },
  { "<leader>uS", ':CodeSnapSave<CR>',                                                                    desc = 'Save CodeSnap' },
  { "<leader>uh", ':CodeSnapHighlight<CR>',                                                               desc = 'CodeSnap Highlight' },
  { "<leader>uH", ':CodeSnapSaveHighlight<CR>',                                                           desc = 'CodeSnap Save Highlight' },

  -- view mappings
  { "<leader>v",  group = "View Mappings" },
  { "<leader>vM", ':TWCenter<CR>',                                                                        desc = 'Center Code Block' },
  { "<leader>vz", ':ZenMode<CR>',                                                                         desc = 'Toggle ZenMode' },
  { "<leader>vt", ':Twilight<CR>',                                                                        desc = 'Enable Twilight' },
  { "<leader>va", ':TZAtaraxis<CR>',                                                                      desc = 'Toggle True Zen: Ataraxis Mode' },
  { "<leader>vm", ':TZMinimalist<CR>',                                                                    desc = 'Toggle True Zen: Minimalist Mode' },
  { "<leader>vn", ':TZNarrow<CR>',                                                                        desc = 'Toggle True Zen: Narrow Mode' },
  { "<leader>vf", ':TZFocus<CR>',                                                                         desc = 'Toggle True Zen: Focus Mode' },
  { "<leader>vT", ':TWToggle<CR>',                                                                        desc = 'Toggle Typewriter' },
  { "<leader>vH", ':TWTop<CR>',                                                                           desc = 'Move Code Block to Top of Screen' },
  { "<leader>vL", ':TWBottom<CR>',                                                                        desc = 'Move Code Block to Bottom of Screen' },
  { "<leader>vh", toggle_inlay_hints,                                                                     desc = 'Toggle Inlay Hints' },
  { "<leader>vp", ':MarkdownPreview<CR>',                                                                 desc = 'Markdown Preview' },
  { "<leader>vr", ':RenderMarkdownToggle<CR>',                                                            desc = 'Render Markdown' },

  -- Telescope Keymaps
  { "<leader>t",  group = "Telescope Keymaps" },
  {
    "<leader>tf",
    function()
      require('telescope.builtin').find_files {
        find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
      }
    end,
    desc = 'Search Files'
  },
  { "<leader>tR", '<cmd>Telescope registers<CR>',                         desc = 'Search Registers' },
  { "<leader>tb", function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Search Current Buffer' },
  { "<leader>th", ':FuzzyHelp<CR>',                                                        desc = 'Search Help' },
  { "<leader>tw", function() require('telescope.builtin').grep_string() end,               desc = 'Search Current Word' },
  { "<leader>tg", function() require('telescope.builtin').live_grep() end,                 desc = 'Search by Grep' },
  { "<leader>tG", '<cmd>Telescope helpgrep<CR>',                                           desc = 'Search Grep Help' },
  { "<leader>tr", function() require('telescope.builtin').resume() end,                    desc = 'Resume Last Search' },
  { "<leader>tc", function() require('telescope.builtin').commands() end,                  desc = 'Search Telescope Commands' },
  { "<leader>tC", function() require('telescope.builtin').command_history() end,           desc = 'Search Command History' },
  { "<leader>tH", function() require('telescope.builtin').search_history() end,            desc = 'Search History' },
  { "<leader>tM", ':FuzzyMan<CR>',                                                         desc = 'Search Man Pages' },
  { "<leader>tk", function() require('telescope.builtin').keymaps() end,                   desc = 'Search Keymaps' },
  { "<leader>ts", function() require('telescope.builtin').spell_suggest() end,             desc = 'Search Spelling Suggestions' },
  { "<leader>tD", ':Dash<CR>',                                                             desc = 'Search Dash' },
  { "<leader>tW", ':DashWord<CR>',                                                         desc = 'Search Dash by word' },
  { "<leader>tt", '<cmd>Telescope themes<CR>',                                             desc = 'Search Themes' },
  { "<leader>t?", function() require('telescope.builtin').oldfiles() end,                  desc = 'Find recently opened files' },
  { "<leader>tS", '<cmd>Telescope uniswapfiles telescope_swap_files<CR>', desc = 'Search Swap Files' },
  { "<leader>to", '<cmd>Telescope oldfiles<cr>',                          desc = 'Recent Files' },
  { "<leader>tB", '<cmd>Telescope buffers<cr>',                           desc = 'List Buffers' },
  { "<leader>tz", '<cmd>Telescope zoxide list<CR>',                       desc = 'Zoxide List' },
  { "<leader>tp", '<cmd>Tldr<CR>',                                        desc = 'Search tldr pages' },
  {
    "<leader>tJ",
    function()
      if vim.bo.filetype == 'json' then
        vim.cmd 'Telescope jsonfly'
      else
        vim.notify('This command is only available for JSON files. Current filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
      end
    end,
    desc = 'Search JSON with jsonfly'
  },
  { "<leader>tT", ':Telescope treesitter<CR>',            desc = 'Search Treesitter' },
  { "<leader>tl", ':Telescope lsp_document_symbols<CR>',  desc = 'Telescope LSP Document Symbols' },
  { "<leader>te", ':Telescope lsp_workspace_symbols<CR>', desc = 'Telescope LSP Workspace Symbols' },
  { "<leader>tx", ':Telescope commands<CR>',              desc = 'Telescope Commands' },
  { "<leader>td", jumper.jump_to_directory,               desc = 'Jump to Directory' },
  { "<leader>tF", jumper.find_in_files,                   desc = 'Find in Files' },
  { "<leader>tj", jumper.jump_to_file,                    desc = 'Jump to File' },

  -- Rnvimr and Ranger Keymaps
  { "<leader>r",  group = "Rnvimr and Ranger Keymaps" },
  { "<leader>rt", ':RnvimrToggle<CR>',                    desc = 'Toggle Rnvimr' },
  { "<leader>rr", ':RnvimrResize<CR>',                    desc = 'Resize Rnvimr' },
  {
    "<leader>rn",
    function()
      require('ranger-nvim').open(true)
    end,
    desc = 'Open Ranger'
  },

  -- Strudel Keymaps
  { "<leader>j",  group = "Strudel Keymaps" },
  { "<leader>jl", function() require('strudel').launch() end,      desc = 'Strudel Launch' },
  { "<leader>jq", function() require('strudel').quit() end,        desc = 'Strudel Quit' },
  { "<leader>jt", function() require('strudel').toggle() end,      desc = 'Strudel Toggle' },
  { "<leader>ju", function() require('strudel').update() end,      desc = 'Strudel Update' },
  { "<leader>js", function() require('strudel').stop() end,        desc = 'Strudel Stop' },
  { "<leader>jb", function() require('strudel').set_buffer() end,  desc = 'Strudel Set Buffer' },
  { "<leader>jx", function() require('strudel').execute() end,     desc = 'Strudel Execute' },

  -- legendary.nvim Keymaps
  { "<leader>X",  group = "Legendary Keymaps" },
  { "<leader>Xg", ':Legendary<CR>',                desc = 'Search Legendary' },
  { "<leader>Xk", ':Legendary keymaps<CR>',        desc = 'Search Legendary Keymaps' },
  { "<leader>Xc", ':Legendary commands<CR>',       desc = 'Search Legendary Commands' },
  { "<leader>Xf", ':Legendary functions<CR>',      desc = 'Search Legendary Functions' },
  { "<leader>Xa", ':Legendary autocmds<CR>',       desc = 'Search Legendary Autocmds' },
  { "<leader>Xr", ':LegendaryRepeat<CR>',          desc = 'Repeat Last Item Executed' },
  { "<leader>X!", ':LegendaryRepeat!<CR>',         desc = 'Repeat Last Item Executed, no filters' },
  { "<leader>Xs", ':LegendaryScratch<CR>',         desc = 'Launch Scratch Pad' },

  -- Tmux Telescope Plugin Keymaps
  { "<leader>x",  group = "tmux Telescope Keymaps" },
  { "<leader>xt", ':TmuxJumpFile<CR>',             desc = 'Jump to File in Tmux Pane' },
  { "<leader>x;", ':TmuxJumpFirst<CR>',            desc = 'Jump to First Tmux Pane' },
  { "<leader>xs", tmux.switch_to_tmux_session,     desc = 'Switch Tmux Session',                  noremap = true, silent = true },
  { "<leader>xw", tmux.switch_tmux_window,         desc = 'Switch Tmux Window',                   noremap = true, silent = true },
  { "<leader>xp", tmux.switch_tmux_pane,           desc = 'Switch Tmux Pane',                     noremap = true, silent = true },
  { "<leader>xm", tmux.tmux_menu_picker,           desc = 'Tmux Menu Picker',                     noremap = true, silent = true },

  -- Harpoon Keymaps
  { "<leader>h",  group = "Harpoon Keymaps" },
  {
    "<leader>ha",
    function() harpoon:list():add() end,
    desc = 'Add File to Harpoon Menu'
  },
  {
    "<leader>hr",
    function()
      harpoon:list():remove()
    end,
    desc = 'Remove File from Harpoon Menu'
  },
  {
    "<leader>hp",
    function()
      harpoon:list():prev()
    end,
    desc = 'Previous Harpoon File'
  },
  {
    "<leader>hn",
    function()
      harpoon:list():next()
    end,
    desc = 'Next Harpoon File'
  },
  {
    "<leader>he",
    function() toggle_telescope(harpoon:list()) end,
    desc = 'Open Harpoon Window'
  },

  -- Obsidian Keymaps
  { "<leader>o",      group = "Obsidian Keymaps" },
  {
    "<leader>on",
    function()
      return require('obsidian').util.gf_passthrough()
    end,
    desc = 'Go to Note Under Cursor',
    noremap = false,
    expr = true,
    buffer = true
  },
  {
    "<leader>oc",
    function()
      return require('obsidian').util.toggle_checkbox()
    end,
    desc = 'Toggle Checkboxes',
    buffer = true
  },
  { "<leader>op",     ':SearchObsidianProgramming<CR>',          desc = 'Search Obsidian Programming Vault' },
  { "<leader>oo",     '<cmd>ObsidianOpen<CR>',                   desc = 'Open Note in Obsidian' },
  { "<leader>oN",     '<cmd>ObsidianNew<CR>',                    desc = 'Create New Note' },
  { "<leader>oq",     '<cmd>ObsidianQuickSwitch<CR>',            desc = 'Quick Switch Note' },
  { "<leader>of",     '<cmd>ObsidianFollowLink<CR>',             desc = 'Follow Note Link' },
  { "<leader>ob",     '<cmd>ObsidianBacklinks<CR>',              desc = 'Show Backlinks' },
  { "<leader>ot",     '<cmd>ObsidianTags<CR>',                   desc = 'Show Tags' },
  { "<leader>od",     '<cmd>ObsidianToday<CR>',                  desc = "Open Today's Note" },
  { "<leader>oy",     '<cmd>ObsidianYesterday<CR>',              desc = "Open Yesterday's Note" },
  { "<leader>om",     '<cmd>ObsidianTomorrow<CR>',               desc = "Open Tomorrow's Note" },
  { "<leader>oD",     '<cmd>ObsidianDailies<CR>',                desc = 'List Daily Notes' },
  { "<leader>oT",     '<cmd>ObsidianTemplate<CR>',               desc = 'Insert Template' },
  { "<leader>os",     '<cmd>ObsidianSearch<CR>',                 desc = 'Search Notes' },
  { "<leader>ol",     '<cmd>ObsidianLink<CR>',                   desc = 'Link Note' },
  { "<leader>oL",     '<cmd>ObsidianLinkNew<CR>',                desc = 'Link to New Note' },
  { "<leader>oS",     '<cmd>ObsidianLinks<CR>',                  desc = 'List Links' },
  { "<leader>oE",     '<cmd>ObsidianExtractNote<CR>',            desc = 'Extract Note' },
  { "<leader>ow",     '<cmd>ObsidianWorkspace<CR>',              desc = 'Switch Workspace' },
  { "<leader>oi",     '<cmd>ObsidianPasteImg<CR>',               desc = 'Paste Image' },
  { "<leader>oR",     '<cmd>ObsidianRename<CR>',                 desc = 'Rename Note' },

  -- Lazy Keymaps
  { "<leader>L",      group = "Lazy Keymaps" },
  { "<leader>Lr",     ':LazyRoot<CR>',                           desc = 'Open LazyRoot' },
  { "<leader>Lf",     ':LazyFormat<CR>',                         desc = 'Open LazyFormat' },
  { "<leader>Lh",     ':LazyHealth<CR>',                         desc = 'Open LazyHealth' },
  { "<leader>Li",     ':LazyFormatInfo<CR>',                     desc = 'Open LazyFormatInfo' },

  -- Flash Keymaps
  { "<leader>F",      group = "Flash Keymaps" },
  { "<leader>Fs",     mode = { "n", "x", "o" },                  function() require("flash").jump() end,              desc = "Flash" },
  { "<leader>FS",     mode = { "n", "x", "o" },                  function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
  { "<leader>Fr",     mode = { "n", "o" },                       function() require("flash").remote() end,            desc = "Remote Flash" },
  { "<leader>FR",     mode = { "n", "o", "x" },                  function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  { "<leader>F<c-s>", mode = { "n", "c" },                       function() require("flash").toggle() end,            desc = "Toggle Flash Search" },

  -- Git Keymaps
  { "<leader>g",      group = "Git Keymaps" },
  { "<leader>gr",     function() require('telescope.builtin').git_files() end,    desc = 'Search Git Files' },
  { "<leader>gs",     function() require('telescope.builtin').git_stash() end,    desc = 'Search Git Stash' },
  { "<leader>gS",     function() require('telescope.builtin').git_status() end,   desc = 'Search Git Status' },
  { "<leader>gC",     '<cmd>Telescope git_bcommits<CR>',                          desc = 'Search Git Buffer Commits' },
  { "<leader>gd",     function() require('telescope.builtin').git_commits() end,  desc = 'Search Git Directory Commits' },
  { "<leader>gb",     function() require('telescope.builtin').git_branches() end, desc = 'Search Git Branches' },
  { "<leader>gp",     '<cmd>Telescope git_signs<CR>',            desc = 'Search Preview Hunks' },
  { "<leader>gT",     ':Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle Git Blame' },
  { "<leader>gt",     '<cmd>Telescope repo list<CR>',            desc = 'Search Git Repos' },
  { "<leader>gc",     ':LazyGitConfig<CR>',                      desc = 'Open Lazygit Config' },
  { "<leader>gg",     ':LazyGit<CR>',                            desc = 'Open LazyGit' },
  { "<leader>gH",     ':Gitsigns preview_hunk_inline<CR>',       desc = 'Inline Hunk Preview' },
  { "<leader>gD",     ':Gitsigns diffthis<CR>',                  desc = 'Show Git Diffs' },
  { "<leader>gP",     ':Gitsigns preview_hunk<CR>',              desc = 'Show Hunk Preview' },
  { "<leader>gf",     ':Flog<CR>',                               desc = 'Open Git Branch Viewer' },
  { "<leader>gF",     ':Flogsplit<CR>',                          desc = 'Open Git Branch Viewer Split' },
  {
    "<leader>gl",
    function()
      require('gitgraph').draw({}, { all = true, max_count = 5000 })
    end,
    desc = 'Draw GitGraph'
  },
  -- GitHub Keymaps
  { "<leader>ghc",  group = "+Commits", },
  { "<leader>ghcc", '<cmd>GHCloseCommit<cr>',                        desc = 'Close Commit' },
  { "<leader>ghce", '<cmd>GHExpandCommit<cr>',                       desc = 'Expand Commit' },
  { "<leader>ghco", '<cmd>GHOpenToCommit<cr>',                       desc = 'Open To Commit' },
  { "<leader>ghcp", '<cmd>GHPopOutCommit<cr>',                       desc = 'Pop Out Commit' },
  { "<leader>ghcz", '<cmd>GHCollapseCommit<cr>',                     desc = 'Collapse Commit' },
  { "<leader>ghi",  group = "+Issues", },
  { "<leader>ghip", '<cmd>GHPreviewIssue<cr>',                       desc = 'Preview Issue' },
  { "<leader>ghl",  group = "+Litee", },
  { "<leader>ghlt", '<cmd>LTPanel<cr>',                              desc = 'Toggle Panel' },
  { "<leader>ghr",  group = "+Review", },
  { "<leader>ghrb", '<cmd>GHStartReview<cr>',                        desc = 'Begin Review' },
  { "<leader>ghrc", '<cmd>GHCloseReview<cr>',                        desc = 'Close Review' },
  { "<leader>ghrd", '<cmd>GHDeleteReview<cr>',                       desc = 'Delete Review' },
  { "<leader>ghre", '<cmd>GHExpandReview<cr>',                       desc = 'Expand Review' },
  { "<leader>ghrs", '<cmd>GHSubmitReview<cr>',                       desc = 'Submit Review' },
  { "<leader>ghrz", '<cmd>GHCollapseReview<cr>',                     desc = 'Collapse Review' },
  { "<leader>ghp",  group = "+Pull Request", },
  { "<leader>ghpc", '<cmd>GHClosePR<cr>',                            desc = 'Close PR' },
  { "<leader>ghpd", '<cmd>GHPRDetails<cr>',                          desc = 'PR Details' },
  { "<leader>ghpe", '<cmd>GHExpandPR<cr>',                           desc = 'Expand PR' },
  { "<leader>ghpo", '<cmd>GHOpenPR<cr>',                             desc = 'Open PR' },
  { "<leader>ghpp", '<cmd>GHPopOutPR<cr>',                           desc = 'PopOut PR' },
  { "<leader>ghpr", '<cmd>GHRefreshPR<cr>',                          desc = 'Refresh PR' },
  { "<leader>ghpt", '<cmd>GHOpenToPR<cr>',                           desc = 'Open To PR' },
  { "<leader>ghpz", '<cmd>GHCollapsePR<cr>',                         desc = 'Collapse PR' },
  { "<leader>ght",  group = "+Threads", },
  { "<leader>ghtc", '<cmd>GHCreateThread<cr>',                       desc = 'Create Thread' },
  { "<leader>ghtn", '<cmd>GHNextThread<cr>',                         desc = 'Next Thread' },
  { "<leader>ghtt", '<cmd>GHToggleThread<cr>',                       desc = 'Toggle Thread' },

  -- ChatGPT Keymaps
  { "<leader>c",    group = "ChatGPT Keymaps" },
  { "<leader>cc",   '<cmd>ChatGPT<CR>',                              desc = 'ChatGPT' },
  { "<leader>cC",   '<cmd>Telescope gpt<CR>',                        desc = 'Telescope GPT' },
  { "<leader>ce",   '<cmd>ChatGPTEditWithInstruction<CR>',           desc = 'Edit with instruction',     mode = { 'n', 'v' } },
  { "<leader>cg",   '<cmd>ChatGPTRun grammar_correction<CR>',        desc = 'Grammar Correction',        mode = { 'n', 'v' } },
  { "<leader>ct",   '<cmd>ChatGPTRun translate<CR>',                 desc = 'Translate',                 mode = { 'n', 'v' } },
  { "<leader>ck",   '<cmd>ChatGPTRun keywords<CR>',                  desc = 'Keywords',                  mode = { 'n', 'v' } },
  { "<leader>cd",   '<cmd>ChatGPTRun docstring<CR>',                 desc = 'Docstring',                 mode = { 'n', 'v' } },
  { "<leader>ca",   '<cmd>ChatGPTRun add_tests<CR>',                 desc = 'Add Tests',                 mode = { 'n', 'v' } },
  { "<leader>co",   '<cmd>ChatGPTRun optimize_code<CR>',             desc = 'Optimize Code',             mode = { 'n', 'v' } },
  { "<leader>cs",   '<cmd>ChatGPTRun summarize<CR>',                 desc = 'Summarize',                 mode = { 'n', 'v' } },
  { "<leader>cf",   '<cmd>ChatGPTRun fix_bugs<CR>',                  desc = 'Fix Bugs',                  mode = { 'n', 'v' } },
  { "<leader>cx",   '<cmd>ChatGPTRun explain_code<CR>',              desc = 'Explain Code',              mode = { 'n', 'v' } },
  { "<leader>cr",   '<cmd>ChatGPTRun roxygen_edit<CR>',              desc = 'Roxygen Edit',              mode = { 'n', 'v' } },
  { "<leader>cl",   '<cmd>ChatGPTRun code_readability_analysis<CR>', desc = 'Code Readability Analysis', mode = { 'n', 'v' } },

  -- CLI App Keymaps
  { "<leader>C",    group = "CLI App Mappings" },
  { "<leader>Ct",   ':Lspsaga term_toggle<CR>',                      desc = 'Launch Terminal' },
  { "<leader>Cd",   '<cmd>FloatermNew lazydocker<CR>',               desc = 'Launch Lazydocker' },   -- Launch Lazydocker: docker
  { "<leader>Cp",   '<cmd>FloatermNew python<CR>',                   desc = 'Launch Python3 REPL' }, -- Launch Python3 REPL: python
  { "<leader>Cn",   '<cmd>FloatermNew node<CR>',                     desc = 'Launch Node REPL' },    -- Launch Node REPL: javascript
  { "<leader>Ch",   '<cmd>FloatermNew htop<CR>',                     desc = 'Launch htop' },         -- Launch htop: resource management
  { "<leader>Cb",   '<cmd>FloatermNew bpytop<CR>',                   desc = 'Launch Bpytop' },

  -- DAP Plugin Keymaps
  { "<leader>D",    group = "DAP Plugin Keymaps" },
  { "<leader>Db",   dap.toggle_breakpoint,                           desc = 'Debug: Toggle Breakpoint' },
  {
    "<leader>DB",
    function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end,
    desc = 'Debug: Set Breakpoint'
  },

  -- Default Keymaps
  { "<leader><Tab>", desc = "Tab Managment" },
  { "<leader>[",     desc = "Previous" },
  { "<leader>]",     desc = "Next" },
  { "<leader>f",     desc = "File Keymaps" },
  { "<leader>q",     desc = "Quit" },
  { "<leader>w",     desc = "Window Managment" },
  { "<leader>z",     desc = "Fold Managment" },
})

-- Conditionally register kulala keymaps if the plugin is available
if is_kulala_available() then
  wk.add({
    { "<leader>Hp", ":lua require('kulala').jump_prev()<CR>",                                 desc = "Previous HTTP Request" },
    { "<leader>Hn", ":lua require('kulala').jump_next()<CR>",                                 desc = "Next HTTP Request" },
    { "<leader>Hr", ":vsplit | wincmd l | enew | lua require('kulala').run()<CR> | wincmd p", desc = "Send HTTP Request" },
    { "<leader>Ht", ":lua require('kulala').toggle_view()<CR>",                               desc = "Toggle HTTP View" },
  })
end

-- Registering Obsidian mappings under the 'n' (normal) mode leader key
-- Invoke only if Obsidian is loaded
local function isInObsidianVault()
  local obsidian_config_path = vim.fn.getcwd() .. '/.obsidian'
  return vim.fn.isdirectory(obsidian_config_path) ~= 0
end

-- Obsidian mappings are already registered above in the main wk.add() call

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

-- For F-keys which are not under the leader key, you can register them separately
wk.add({
  { "<F1>", dap.step_into, desc = 'Debug: Step Into' },
  { "<F2>", dap.step_over, desc = 'Debug: Step Over' },
  { "<F3>", dap.step_out,  desc = 'Debug: Step Out' },
  { "<F5>", dap.continue,  desc = 'Debug: Start/Continue' },
  { "<F7>", dapui.toggle,  desc = 'Debug: See last session result.' },
}, { mode = 'n' })

  -- Registering numeric mappings for selecting Harpoon files
  for i = 1, 9 do
    wk.add({
      {
        "<leader>h" .. i,
        function()
          harpoon:list():select(i)
        end,
        desc = 'Harpoon to File ' .. i
      }
    })
  end
end

return M
