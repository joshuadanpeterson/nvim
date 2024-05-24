-- clean_lsp_log.lua
local log_file_path = '/Users/joshpeterson/.local/state/nvim/lsp.log'
local days_to_keep = 7

-- Function to parse the date from the log entry
local function parse_date(log_entry)
  local year, month, day = log_entry:match '(%d%d%d%d)-(%d%d)-(%d%d)'
  if year and month and day then
    return os.time { year = year, month = month, day = day }
  end
  return nil
end

-- Function to clean the log file
local function clean_log_file()
  local current_time = os.time()
  local one_month_ago = current_time - (days_to_keep * 24 * 60 * 60)
  local cleaned_log_entries = {}

  for line in io.lines(log_file_path) do
    local log_date = parse_date(line)
    if log_date and log_date >= one_month_ago then
      table.insert(cleaned_log_entries, line)
    end
  end

  -- Write the cleaned log entries back to the log file
  local log_file = io.open(log_file_path, 'w')
  for _, entry in ipairs(cleaned_log_entries) do
    log_file:write(entry .. '\n')
  end
  log_file:close()
  print 'Log file cleaned'
end

clean_log_file()
