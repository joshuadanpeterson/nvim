-- custom_cmp_telescope.lua
-- A custom cmp source to using the Telescope picker as the source

local cmp = require 'cmp'
local telescope = require 'telescope.builtin'
local log_file_path = '/Users/joshpeterson/.local/state/nvim/custom_cmp_telescope.log'

local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  return self
end

source.get_keyword_pattern = function()
  return [[\k\+]]
end

source.complete = function(self, params, callback)
  local items = {}

  local log_file = io.open(log_file_path, 'a')
  if log_file then
    log_file:write 'Telescope source complete function called\n'
    log_file:close()
  else
    print 'Error: Could not open log file for writing'
  end

  telescope.find_files {
    attach_mappings = function(prompt_bufnr, map)
      local action_state = require 'telescope.actions.state'
      local actions = require 'telescope.actions'

      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        table.insert(items, {
          label = selection.value,
          kind = cmp.lsp.CompletionItemKind.File,
        })
        actions.close(prompt_bufnr)
        callback {
          items = items,
          isIncomplete = false,
        }
      end)

      return true
    end,
  }
end

source.is_available = function()
  local buftype = vim.api.nvim_buf_get_option_value(0, 'buftype')
  if buftype == 'prompt' then
    local log_file = io.open(log_file_path, 'a')
    if log_file then
      log_file:write 'Telescope source is available\n'
      log_file:close()
    else
      print 'Error: Could not open log file for writing'
    end
    return true
  end
  return false
end

return source
