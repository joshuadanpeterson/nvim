-- Configuration for using Tmux with Telescope inside Neovim

-- List of Tmux commands
local tmux_menu = {
  { description = "New Window (n)",            command = "new-window" },
  { description = "New Session (NS)",          command = "new-session" },
  { description = "Split Horizontally (H)",    command = "split-window -h" },
  { description = "Split Vertically (V)",      command = "split-window -v" },
  { description = "Kill Pane (KP)",            command = "confirm-before -p 'kill-pane #P? (y/n)' kill-pane" },
  { description = "Kill Window (KW)",          command = "confirm-before -p 'kill-window #W? (y/n)' kill-window" },
  { description = "Kill Server (KS)",          command = "confirm-before -p 'kill-server? (y/n)' kill-server" },
  { description = "Detach Client (d)",         command = "detach-client" },
  { description = "Next Window (W)",           command = "next-window" },
  { description = "Previous Window (P)",       command = "previous-window" },
  { description = "Rename Window (r)",         command = "command-prompt -I '#W' 'rename-window %%'" },
  { description = "Rename Session (s)",        command = "command-prompt -I '#S' 'rename-session %%'" },
  { description = "List Sessions (LS)",        command = "choose-tree -Zs" },
  { description = "List Windows (LW)",         command = "choose-tree -Zw" },
  { description = "Select Window (SW)",        command = "command-prompt -T window-target -p index 'select-window -t :%%'" },
  { description = "Rotate Window (RO)",        command = "rotate-window" },
  { description = "Next Layout (XL)",          command = "next-layout" },
  { description = "Show Time (ST)",            command = "clock-mode" },
  { description = "Display Pane Numbers (DP)", command = "display-panes" },
  { description = "Select Pane # (SP)",        command = "command-prompt -p 'Enter pane #: ' 'select-pane -t :%%'" },
  { description = "Resize Pane Left (RL)",     command = "resize-pane -L 5" },
  { description = "Resize Pane Down (RD)",     command = "resize-pane -D 5" },
  { description = "Resize Pane Up (RU)",       command = "resize-pane -U 5" },
  { description = "Resize Pane Right (RR)",    command = "resize-pane -R 5" },
  { description = "Select Pane Left (PL)",     command = "select-pane -L" },
  { description = "Select Pane Down (PD)",     command = "select-pane -D" },
  { description = "Select Pane Up (PU)",       command = "select-pane -U" },
  { description = "Select Pane Right (PR)",    command = "select-pane -R" },
  { description = "Launch Ranger (LR)",        command = "run-shell 'tmux split-window -vb -c \"#{pane_current_path}\" ranger'" },
}

-- Open File in Neovim Pane
local function open_file_in_neovim(file_path)
  local path, line = file_path:match("(.*):(%d+)$")
  if path and vim.fn.filereadable(path) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    if line then
      vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
    end
  else
    print("File does not exist or cannot be read: " .. file_path)
  end
end


-- Capture Tmux panes
local function capture_tmux_panes()
  local list_panes_cmd = "tmux list-panes -F '#{pane_id}'"
  local panes_output = vim.fn.system(list_panes_cmd)
  local panes = vim.split(panes_output, "\n")

  local captured_files = {}
  for _, pane_id in ipairs(panes) do
    if pane_id ~= "" then
      local capture_cmd = string.format("tmux capture-pane -pJ -t %s", pane_id)
      local pane_content = vim.fn.system(capture_cmd)
      for file_path in pane_content:gmatch("[^%s]+%.[%w]+") do
        if file_path ~= "" then
          table.insert(captured_files, file_path)
        end
      end
    end
  end

  return captured_files
end

local M = {}

-- Switch Tmux Sessions
M.switch_to_tmux_session = function()
  local handle = io.popen("tmux list-sessions -F '#{session_name}'", "r")
  local tmux_sessions = handle:read("*a")
  handle:close()

  local sessions = {}
  for session in tmux_sessions:gmatch("[^\r\n]+") do
    table.insert(sessions, session)
  end

  vim.schedule(function()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local conf = require('telescope.config').values

    pickers.new({}, {
      prompt_title = "Tmux Sessions",
      finder = finders.new_table({
        results = sessions,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(_, map)
        map('i', '<CR>', function(bufnr)
          local selection = action_state.get_selected_entry()
          actions.close(bufnr)
          vim.fn.system("tmux switch-client -t " .. selection.value)
        end)
        return true
      end,
    }):find()
  end)
end

-- Switch Tmux Windows
M.switch_tmux_window = function()
  local Job = require 'plenary.job'
  Job:new({
    command = 'tmux',
    args = { 'list-windows', '-F', '#I:#W' },
    on_exit = function(j, return_val)
      local windows = j:result()

      vim.schedule(function()
        local pickers = require('telescope.pickers')
        local finders = require('telescope.finders')
        local conf = require('telescope.config').values
        local actions = require('telescope.actions')
        local action_state = require('telescope.actions.state')

        pickers.new({}, {
          prompt_title = 'Tmux Windows',
          finder = finders.new_table({
            results = windows,
            entry_maker = function(entry)
              -- Assuming entry format is 'window_index:window_name'
              local window_index, window_name = entry:match('(%d+):(.+)')
              return {
                value = window_index,  -- The window index is used for tmux command
                display = window_name, -- The window name is shown in the picker
                ordinal = window_name,
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
              local selection = action_state.get_selected_entry()
              require('telescope.actions').close(prompt_bufnr)
              -- Use the window index to select the window in tmux
              vim.fn.system('tmux select-window -t ' .. selection.value)
            end)
            return true
          end,
        }):find()
      end)
    end,
  }):start()
end

-- Switch Tmux Panes
M.switch_tmux_pane = function()
  local captured_files = capture_tmux_panes()

  if #captured_files == 0 then
    print("No valid file paths captured from tmux panes.")
    return
  end

  vim.schedule(function()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local action_state = require('telescope.actions.state')
    local actions = require('telescope.actions')

    pickers.new({}, {
      prompt_title = 'Select a file from tmux panes',
      finder = finders.new_table({
        results = captured_files,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,             -- Display the file path directly
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local selection = action_state.get_selected_entry(prompt_bufnr)
          actions.close(prompt_bufnr)
          open_file_in_neovim(selection.value)
        end)
        return true
      end,
    }):find()
  end)
end

M.tmux_menu_picker = function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values

  pickers.new({}, {
    prompt_title = "Tmux Command Menu",
    finder = finders.new_table({
      results = tmux_menu,
      entry_maker = function(entry)
        return {
          value = entry.command,
          display = entry.description,
          ordinal = entry.description,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        -- Execute the Tmux command for the selected menu item
        vim.fn.system("tmux " .. selection.value)
      end)
      return true
    end,
  }):find()
end

return M
