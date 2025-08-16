# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This is an advanced Neovim configuration built with lazy.nvim, featuring comprehensive LSP support, optimized startup performance, and extensive customization. The configuration emphasizes performance (targeting <400ms cold start, <150ms cached start) while maintaining rich functionality.

## Common Commands

### Performance Profiling
```bash
# Profile startup time with statistics (10 runs, 10ms threshold)
make nvim-profile

# Quick profiling (5 runs, 15ms threshold)
make nvim-profile-quick

# Detailed profiling (20 runs, 5ms threshold)
make nvim-profile-detailed

# Custom profiling with specific parameters
make nvim-profile RUNS=15 MIN_TIME=8

# Clean profiling artifacts
make clean-profile
```

### Testing
```bash
# Run full test suite from command line
nvim -l test/run_tests.lua

# Run tests from within Neovim
:lua require('test.test_config').run_all_tests()

# Quick validation test
:lua require('test.quick_test')

# Test specific components
:lua require('test.test_config').test_plugin_loading()
:lua require('test.test_config').test_lsp_functionality()
:lua require('test.test_config').test_telescope_functionality()
:lua require('test.test_config').test_keymap_integrity()
```

### Health & Diagnostics
```vim
:checkhealth                " Full health check
:checkhealth telescope      " Check specific plugin health
:LspInfo                   " LSP server status
:Mason                     " LSP server installation manager
:CmpStatus                 " Completion status
:ConformInfo              " Formatter info
:Lazy                     " Plugin manager UI
:Lazy profile             " Plugin loading performance
:Lazy sync                " Update all plugins
```

### Noice & Notifications
```vim
:Noice                    " Noice UI
:NoiceDismiss            " Dismiss current message
:NoiceStats              " Performance statistics
:NoiceErrors             " Show errors
:FuzzyNoice              " Search messages
```

## Code Architecture

### Plugin Organization (`lua/plugins/`)
The plugin configuration is modular and organized by functionality:

- **`ui.lua`**: UI enhancements (dressing.nvim, nvim-nonicons, transparent.nvim)
- **`autocomplete.lua`**: Completion stack (nvim-cmp and all sources) - loads on InsertEnter
- **`lsp.lua`**: LSP configuration with Mason and nvim-lspconfig
- **`treesitter.lua`**: Syntax highlighting and text objects
- **`telescope.lua`** (via finder.lua): Fuzzy finding and search
- **`git.lua`**: Git integration (fugitive, gitsigns, diffview)
- **`noice.lua`**: Command line and notification enhancements
- **`keymaps.lua`**: Global keymap definitions
- **`which-key.lua`**: Keymap discovery UI

### Configuration Modules (`lua/config/`)
Core configuration logic separated from plugin specs:

- **`settings.lua`**: Base Neovim settings (options, autocmds)
- **`keymaps.lua`**: Centralized keymap configuration using which-key
- **`lsp.lua`**: LSP server configurations and handlers
- **`lazy-loading-helpers.lua`**: Utilities for optimizing plugin loading
- **`logging.lua` & `logging-utils.lua`**: Debug logging system for troubleshooting
- **`cmp.lua`**: Completion engine configuration
- **`conform.lua`**: Formatter configurations
- **`nvim-lint.lua`**: Linter configurations

### Testing Infrastructure (`test/`)
Comprehensive testing framework:

- **`test_config.lua`**: Main test suite with component tests
- **`quick_test.lua`**: Rapid validation checks
- **`run_tests.lua`**: Test runner script
- **`test_keymaps.lua`**: Keymap validation tests
- **`TESTING.md`**: Manual testing workflow documentation

### Lazy Loading Strategy
Plugins are loaded on-demand using events and dependencies:

- **InsertEnter**: Completion stack, snippets, autopairs
- **VeryLazy**: Non-critical UI enhancements
- **BufReadPre/BufNewFile**: File-type specific plugins
- **Dependencies**: Related plugins grouped to load together

### Logging System
Custom logging for debugging configuration issues:

- Debug mode configurable via `config.logging`
- Per-plugin log levels
- Log viewing commands integrated with Telescope
- Automatic cleanup of log files

## Development Workflows

### Adding New Plugins
1. **Choose appropriate loading strategy**:
   - Use `event = "VeryLazy"` for non-critical plugins
   - Use specific events (InsertEnter, BufReadPre) for context-specific plugins
   - Group related plugins as dependencies

2. **Test performance impact**:
   ```bash
   # Before adding plugin
   make nvim-profile > before.txt
   
   # Add plugin, then test
   make nvim-profile > after.txt
   
   # Compare results
   diff before.txt after.txt
   ```

3. **Verify targets are met**:
   - Cold start: < 400ms
   - Cached start: < 150ms

### Keymap Conventions
- All keymaps defined in `lua/config/keymaps.lua`
- Use which-key for organization and discovery
- Leader key is `<space>`
- Format: `<leader><category><action>`
  - `<leader>f`: Find/Files
  - `<leader>g`: Git
  - `<leader>l`: LSP
  - `<leader>d`: Diagnostics

### Implementation Tracking
Track all changes in `IMPLEMENTATION_STATUS_LOG.md`:

```markdown
#### ISL-XXX: Brief Description 🟢 **DONE** / 🟡 **IN PROGRESS** / 🔴 **TODO**
- **Priority**: High/Medium/Low
- **Description**: Detailed description
- **Status**: Current status
- **Date Started**: YYYY-MM-DD
- **Date Completed**: YYYY-MM-DD (if done)
- **Changes Made**: Bullet list of changes
- **Files Affected**: X files changed, Y insertions(+), Z deletions(-)
- **Commit**: `hash` - "commit message"
```

### Commit Conventions
Use conventional commits with emojis:

```bash
# Format: type(scope): emoji description
git commit -m "feat(lsp): ✨ Add new language server support"
git commit -m "fix(config): 🐛 Fix startup error in transparent.nvim"
git commit -m "perf(plugins): ⚡ Optimize lazy loading for faster startup"
git commit -m "docs(readme): 📚 Update installation instructions"
```

Common types and emojis:
- `feat: ✨` - New feature
- `fix: 🐛` - Bug fix  
- `perf: ⚡` - Performance improvement
- `refactor: ♻️` - Code refactoring
- `docs: 📚` - Documentation
- `test: 🧪` - Tests

## Quick Reference

### Performance Targets
| Metric | Target | Check Command |
|--------|--------|---------------|
| Cold Start | < 400ms | `make nvim-profile` |
| Cached Start | < 150ms | `make nvim-profile` (2nd run) |
| Individual Module | < 20ms | Check CSV report |

### Key Directories
| Directory | Purpose |
|-----------|---------|
| `lua/plugins/` | Plugin specifications |
| `lua/config/` | Configuration modules |
| `test/` | Testing infrastructure |
| `scripts/` | Utility scripts (profiling) |
| `linter_configs/` | External linter configs |

### Important Files
| File | Purpose |
|------|---------|
| `init.lua` | Entry point, loads config and plugins |
| `lazy-lock.json` | Plugin version lock file |
| `IMPLEMENTATION_STATUS_LOG.md` | Development history and task tracking |
| `test/TESTING.md` | Manual testing procedures |
| `docs/profiling.md` | Profiling workflow documentation |

## Debugging Tips

### Enable Debug Logging
```lua
-- In init.lua or config/logging.lua
logging.setup({
  core_plugins_debug = true,
  default_log_level = 'debug'
})
```

### View Logs
```vim
:SearchLogFiles         " Search all log files with Telescope
:SearchChangelogFiles   " Search changelog files
```

### Common Issues

**Slow Startup**:
1. Run `make nvim-profile-detailed`
2. Check CSV report for items > 50ms
3. Consider lazy-loading problematic plugins

**Plugin Not Loading**:
1. Check `:Lazy` for load status
2. Verify event triggers in plugin spec
3. Check `:messages` for errors

**LSP Not Working**:
1. Run `:LspInfo` to check server status
2. Run `:Mason` to verify installation
3. Check `:checkhealth lsp`

**Keymap Conflicts**:
1. Use `:map <key>` to check mapping
2. Run `:lua require('which-key').show()`
3. Check `lua/config/keymaps.lua` for definitions

## Testing Before Commits

Always run these checks before committing:

```bash
# 1. Test configuration loads
nvim -l test/run_tests.lua

# 2. Check performance impact
make nvim-profile

# 3. Verify health
nvim -c "checkhealth" -c "qa"

# 4. Update implementation log
# Add entry to IMPLEMENTATION_STATUS_LOG.md

# 5. Commit with conventional format
git add .
git commit -m "type(scope): emoji description"
```
