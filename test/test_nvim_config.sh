#!/bin/bash
# test_nvim_config.sh
# Shell script to run Neovim configuration tests

set -e

NVIM_CONFIG_DIR="$HOME/.config/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Neovim Configuration Test Runner"
echo "Configuration directory: $NVIM_CONFIG_DIR"
echo ""

# Check if we're in the right directory
if [[ ! -f "$SCRIPT_DIR/test_config.lua" ]]; then
    echo "❌ Error: test_config.lua not found in $SCRIPT_DIR"
    echo "Please run this script from your Neovim configuration directory."
    exit 1
fi

# Function to run quick test
run_quick_test() {
    echo "Running quick validation test..."
    nvim --headless -c "
        lua local success, result = pcall(function() 
            local test = dofile(vim.fn.stdpath('config') .. '/test/quick_test.lua')
            return test
        end)
        if success then
            print('Test completed')
        else
            print('Test failed: ' .. tostring(result))
        end
        vim.cmd('qa!')
    "
}

# Function to run comprehensive test
run_full_test() {
    echo "Running comprehensive test suite..."
    nvim --headless -c "
        lua local success, result = pcall(function() 
            local test_config = require('test.test_config')
            return test_config.run_all_tests()
        end)
        if success then
            print('Full test suite completed')
        else
            print('Test suite failed: ' .. tostring(result))
        end
        vim.cmd('qa!')
    "
}

# Parse command line arguments
case "${1:-quick}" in
    "quick"|"q")
        run_quick_test
        ;;
    "full"|"f")
        run_full_test
        ;;
    "help"|"h"|"-h"|"--help")
        echo "Usage: $0 [quick|full|help]"
        echo ""
        echo "Options:"
        echo "  quick, q    Run quick validation test (default)"
        echo "  full, f     Run comprehensive test suite"
        echo "  help, h     Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0              # Run quick test"
        echo "  $0 quick        # Run quick test"
        echo "  $0 full         # Run full test suite"
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo "Use '$0 help' for usage information."
        exit 1
        ;;
esac

echo ""
echo "✅ Test execution completed!"
echo ""
echo "💡 You can also run tests from within Neovim:"
echo "   :lua require('test.quick_test')                    -- Quick test"
echo "   :lua require('test.test_config').run_all_tests()   -- Full test"
