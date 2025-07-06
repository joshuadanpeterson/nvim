# nvim-notify Conflict Resolution

This document explains how nvim-notify conflicts with Noice have been resolved and provides troubleshooting steps.

## Changes Made

### 1. Moved nvim-notify Configuration
- **From**: `lua/plugins/utility.lua`
- **To**: `lua/plugins/noice.lua`
- **Reason**: Ensure nvim-notify is configured before Noice loads

### 2. Configuration Order
```lua
-- nvim-notify loads first with higher priority
{
  'rcarriga/nvim-notify',
  priority = 1100, -- Higher than Noice (1000)
  config = function()
    require("notify").setup { stages = "fade", timeout = 3000 }
    vim.notify = require("notify")
  end,
}

-- Noice loads after nvim-notify is configured
{
  'folke/noice.nvim',
  priority = 1000,
  dependencies = { 'rcarriga/nvim-notify' },
  -- ... rest of config
}
```

### 3. Conflict Resolution Route
If conflicts persist, there's a commented route in Noice configuration:
```lua
routes = {
  -- Uncomment this line if conflicts persist:
  -- { filter = { event = "notify" }, opts = { skip = true } },
},
```

## Troubleshooting

### If you still see conflicts:

1. **Use the toggle helper**:
   ```vim
   :lua require('config.toggle-notify-route').toggle()
   ```

2. **Check current status**:
   ```vim
   :lua require('config.toggle-notify-route').status()
   ```

3. **Manual fix**:
   - Open `lua/plugins/noice.lua`
   - Uncomment the line: `{ filter = { event = "notify" }, opts = { skip = true } },`
   - Restart Neovim

### Verification

After making changes:
1. Restart Neovim
2. Check for error messages
3. Test notifications: `:lua vim.notify("Test message")`
4. Verify Noice is working: Use command line (`:`)

## Configuration Details

- **nvim-notify settings**: `stages = "fade"`, `timeout = 3000`
- **Priority**: nvim-notify (1100) > Noice (1000)
- **Loading order**: notify → Noice configuration
- **Fallback**: Route skip if conflicts persist
