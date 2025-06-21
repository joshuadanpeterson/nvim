# Manual Testing Workflow for Maintainers

This document provides a comprehensive manual testing workflow for maintainers to validate Neovim configuration changes. It builds upon the automated testing infrastructure but focuses on manual validation steps and troubleshooting procedures.

## Table of Contents

1. [Pre-Change Testing](#pre-change-testing)
2. [Config Load Validation](#config-load-validation)
3. [Plugin Health Validation](#plugin-health-validation)
4. [Keymap Validation](#keymap-validation)
5. [Post-Change Testing](#post-change-testing)
6. [Error Discovery and Resolution](#error-discovery-and-resolution)
7. [Testing Checklist](#testing-checklist)
8. [Troubleshooting Guide](#troubleshooting-guide)

## Pre-Change Testing

Before making any configuration changes, establish a baseline:

### 1. Document Current State
```bash
# Record current plugin state
:Lazy log > /tmp/lazy-before.log

# Record current LSP state
:LspInfo > /tmp/lsp-before.txt

# Record current health status
:checkhealth > /tmp/health-before.txt
```

### 2. Run Full Test Suite
```lua
-- Run comprehensive test suite
:lua require('test.test_config').run_all_tests()
```

### 3. Test Critical Workflows
- [ ] Open and navigate files with Telescope
- [ ] Trigger LSP functionality (hover, go-to-definition)
- [ ] Use essential keymaps
- [ ] Verify git integration works
- [ ] Test search and replace functionality

## Config Load Validation

### How to Check for Successful Config Load

#### 1. Quick Load Check
```lua
-- Quick validation - should complete without errors
:lua require('test.quick_test')
```

#### 2. Manual Load Verification
```vim
" Start Neovim with verbose output
nvim --headless -c "lua print('Config loaded successfully')" -c "qa"

" Or check for specific errors on startup
nvim -V1 your_file.txt
```

#### 3. Plugin Loading Status
```lua
-- Check lazy.nvim status
:Lazy

-- Get detailed plugin status programmatically
:lua local lazy = require('lazy'); print(vim.inspect(lazy.stats()))

-- Check for failed plugins
:lua require('test.test_config').test_plugin_loading()
```

#### 4. Critical Component Verification
```lua
-- Verify core components are loaded
:lua print("Telescope:", pcall(require, 'telescope'))
:lua print("LSP:", pcall(require, 'lspconfig'))
:lua print("Treesitter:", pcall(require, 'nvim-treesitter'))
:lua print("Mason:", pcall(require, 'mason'))
```

### Success Indicators
- ✅ No error messages during startup
- ✅ All critical plugins show as loaded in `:Lazy`
- ✅ No red error messages in `:messages`
- ✅ Quick test completes without failures

### Failure Indicators
- ❌ Error messages during Neovim startup
- ❌ Plugins marked as failed in `:Lazy`
- ❌ Missing commands (e.g., `:Telescope` not available)
- ❌ Lua errors in `:messages`

## Plugin Health Validation

### Steps for Validating Plugin Health After Changes

#### 1. Comprehensive Health Check
```vim
" Run full health check
:checkhealth

" Check specific plugin health
:checkhealth telescope
:checkhealth lsp
:checkhealth treesitter
:checkhealth mason
```

#### 2. Plugin-Specific Validation

##### LSP Health
```lua
-- Check LSP functionality
:lua require('test.test_config').test_lsp_functionality()

-- Manual LSP checks
:LspInfo
:Mason
:lua print(vim.inspect(vim.lsp.get_active_clients()))
```

##### Telescope Health
```lua
-- Test Telescope functionality
:lua require('test.test_config').test_telescope_functionality()

-- Manual Telescope checks
:Telescope builtin
:checkhealth telescope
```

##### Treesitter Health
```lua
-- Test Treesitter
:lua require('test.test_config').test_treesitter()

-- Manual checks
:TSUpdate
:TSInstallInfo
```

#### 3. Performance Validation
```lua
-- Run performance tests
:lua require('test.test_config').run_performance_test()

-- Profile plugin loading
:Lazy profile
```

### Health Check Interpretation

#### Green (✓) - Healthy
- Component is functioning correctly
- All dependencies are satisfied
- No action required

#### Yellow (⚠) - Warning
- Component works but has non-critical issues
- Optional dependencies missing
- Performance concerns
- Review recommended but not urgent

#### Red (✗) - Error
- Critical component failure
- Missing required dependencies
- Immediate attention required
- May break core functionality

## Keymap Validation

### Steps for Validating Keymaps After Changes

#### 1. Automated Keymap Testing
```lua
-- Test keymap integrity
:lua require('test.test_config').test_keymap_integrity()

-- Run keymap-specific tests
:lua require('test.test_keymaps')
```

#### 2. Manual Keymap Validation

##### Essential Keymaps Test
Test these critical keymaps manually:

```vim
" File operations
<leader>ff  " Find files
<leader>fg  " Live grep
<leader>fb  " Find buffers

" LSP operations
gd         " Go to definition
K          " Hover documentation
<leader>lr " LSP rename
<leader>la " Code actions

" Git operations
<leader>gg " Git status
<leader>gp " Git push
<leader>gl " Git log

" General operations
<leader>e  " File explorer
<space>    " Which-key menu
```

##### Which-Key Integration
```vim
" Test which-key displays
<leader>    " Should show menu
<leader>f   " Should show file menu
<leader>g   " Should show git menu
<leader>l   " Should show LSP menu
```

#### 3. Keymap Conflict Detection
```lua
-- Check for keymap conflicts
:lua require('which-key').show()

-- List all keymaps
:map
:nmap
:imap
:vmap
```

### Keymap Validation Checklist
- [ ] All essential keymaps respond correctly
- [ ] Which-key menus display properly
- [ ] No keymap conflicts detected
- [ ] Custom keymaps work as expected
- [ ] Mode-specific keymaps function correctly

## Post-Change Testing

After making configuration changes:

### 1. Restart and Retest
```bash
# Clean restart
nvim --clean
nvim  # Normal startup

# Or restart within Neovim
:qa
# Then restart normally
```

### 2. Run Full Test Suite
```lua
-- Comprehensive testing
:lua require('test.test_config').run_all_tests()

-- Individual component tests
:lua require('test.test_config').test_plugin_loading()
:lua require('test.test_config').test_lsp_functionality()
:lua require('test.test_config').test_telescope_functionality()
:lua require('test.test_config').test_keymap_integrity()
```

### 3. Compare Before/After State
```bash
# Compare logs
diff /tmp/lazy-before.log <(:Lazy log)
diff /tmp/health-before.txt <(:checkhealth)
```

### 4. Test Changed Functionality
- [ ] Test the specific feature that was modified
- [ ] Verify dependent features still work
- [ ] Check for any new warnings or errors

## Error Discovery and Resolution

### What to Do if New Errors Are Found

#### 1. Immediate Assessment
```lua
-- Check error severity
:messages

-- Run diagnostic tests
:lua require('test.test_config').run_all_tests()
:checkhealth
```

#### 2. Error Classification

##### Critical Errors (Fix Immediately)
- Configuration fails to load
- Essential plugins won't start
- Core functionality broken
- Data loss potential

##### Non-Critical Errors (Fix When Convenient)
- Optional features not working
- Cosmetic issues
- Performance degradation
- Missing optional dependencies

#### 3. Error Resolution Process

##### Step 1: Isolate the Problem
```bash
# Test with minimal config
nvim --clean

# Test specific components
nvim -c ":lua require('problematic_plugin')"
```

##### Step 2: Check Recent Changes
```bash
# Review recent commits
git log --oneline -10

# Check diff of recent changes
git diff HEAD~1
```

##### Step 3: Gather Information
```lua
-- Collect diagnostic information
:lua require('test.test_config').check_log_files()
:checkhealth
:LspInfo
:Lazy
```

##### Step 4: Fix and Validate
```bash
# Make fixes
# Test fixes
nvim -c ":lua require('test.test_config').run_all_tests()" -c "qa"

# Commit fixes
git add .
git commit -m "fix: resolve configuration issues"
```

#### 4. Common Error Types and Solutions

##### Plugin Loading Errors
```lua
-- Check plugin specification
:Lazy

-- Update plugins
:Lazy sync

-- Clear plugin cache
:Lazy clear
```

##### LSP Errors
```lua
-- Check LSP servers
:LspInfo
:Mason

-- Restart LSP
:LspRestart

-- Check Mason installations
:MasonUpdate
```

##### Keymap Errors
```lua
-- Check keymap conflicts
:lua require('which-key').show()

-- Reset keymaps
:mapclear
" Then restart Neovim
```

## Testing Checklist

### Pre-Change Checklist
- [ ] Document current working state
- [ ] Run full test suite (all passing)
- [ ] Record baseline metrics
- [ ] Backup current configuration

### Post-Change Checklist
- [ ] Configuration loads without errors
- [ ] All critical plugins load successfully
- [ ] Essential keymaps work correctly
- [ ] LSP functionality operates normally
- [ ] File navigation works (Telescope)
- [ ] Git integration functions properly
- [ ] No new health check errors
- [ ] Performance remains acceptable
- [ ] All tests pass

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Breaking changes documented
- [ ] Migration guide provided (if needed)

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. "Plugin not found" errors
```lua
-- Check plugin installation
:Lazy

-- Reinstall plugin
:Lazy clean
:Lazy install
```

#### 2. LSP not working
```bash
# Check LSP server installation
:Mason
:LspInfo

# Restart LSP
:LspRestart
```

#### 3. Keymaps not working
```lua
-- Check which-key configuration
:lua require('which-key').show()

-- Test keymap definition
:lua vim.keymap.set('n', '<test>', '<cmd>echo "works"<cr>')
```

#### 4. Performance issues
```lua
-- Profile startup
:Lazy profile

-- Check loading times
:lua require('test.test_config').run_performance_test()
```

### Getting Help

1. **Check Documentation**: Review plugin documentation for known issues
2. **Search Issues**: Look for similar problems in plugin repositories
3. **Test Isolation**: Test with minimal configuration to isolate problems
4. **Community Support**: Ask on Neovim communities with detailed error information

### Emergency Recovery

If configuration is completely broken:

```bash
# Backup broken config
mv ~/.config/nvim ~/.config/nvim.broken

# Restore from git
cd ~/.config
git clone <your-config-repo> nvim

# Or use known good commit
cd ~/.config/nvim
git reset --hard <known-good-commit>
```

## Automated Testing Integration

This manual workflow complements the automated testing infrastructure:

- **Quick Test**: `lua require('test.quick_test')` for rapid validation
- **Full Test Suite**: `lua require('test.test_config').run_all_tests()` for comprehensive testing
- **Shell Script**: `./test/test_nvim_config.sh` for external testing
- **Keymap Tests**: See `test/test_keymaps.lua` for keymap-specific testing

## Maintenance Schedule

### Daily (if actively developing)
- Quick test after any changes
- Monitor error messages
- Check critical functionality

### Weekly
- Full test suite
- Health check review
- Performance assessment

### Monthly
- Plugin updates with testing
- Configuration cleanup
- Documentation updates

---

**Remember**: Always test changes in a safe environment before deploying to your main configuration. The goal is to catch issues early and maintain a stable, functional Neovim setup.
