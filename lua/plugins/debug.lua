-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
--[[
  kickstart.plugins.debug: Sets up debugging tools within Neovim, possibly using plugins like nvim-dap. This includes configurations for connecting to debuggers, setting breakpoints, watching variables, and navigating through the call stack.
]]

return {
  -- nvim-dap-ui
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    lazy = true,
    keys = {
      { '<leader>dd', desc = 'DAP Continue' },
      { '<leader>db', desc = 'DAP Toggle Breakpoint' },
      { '<leader>dB', desc = 'DAP Set Breakpoint' },
      { '<leader>dr', desc = 'DAP Toggle REPL' },
      { '<leader>du', desc = 'DAP UI Toggle' },
    },
    cmd = { 'DapToggleBreakpoint', 'DapStart', 'DapContinue', 'DapStepInto', 'DapStepOver', 'DapStepOut' },
    config = function()
      require('dapui').setup()
    end,
  },

  -- nvim-dap
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    lazy = true,
    keys = {
      { '<leader>dd', function() require('dap').continue() end, desc = 'DAP Continue' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP Toggle Breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'DAP Set Breakpoint' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'DAP Toggle REPL' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'DAP Run Last' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'DAP Step Into' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'DAP Step Over' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'DAP Step Out' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'DAP UI Toggle' },
    },
    cmd = { 'DapToggleBreakpoint', 'DapStart', 'DapContinue', 'DapStepInto', 'DapStepOver', 'DapStepOut' },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Go debugger
      require('dap-go').setup()

      require('mason-nvim-dap').setup {
        automatic_setup = true,
        handlers = {},
        ensure_installed = {
          'delve',
          'debugpy',
          'bash-debug-adapter',
          'chrome-debug-adapter',
          'codeLLdb',
          'firefox-debug-adapter',
          'go-debug-adapter',
          'js-debug-adapter',
          'node-debug2-adapter',
          'php-debug',
        },
      }

      -- Dap UI setup
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup()
    end,
  },
}
