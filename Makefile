# Makefile for Neovim configuration management

.PHONY: help nvim-profile nvim-profile-quick nvim-profile-detailed clean-profile

# Default target
help:
	@echo "Neovim Configuration Management"
	@echo ""
	@echo "Available targets:"
	@echo "  nvim-profile         - Run startup profiling with 10 runs (default)"
	@echo "  nvim-profile-quick   - Quick profiling with 5 runs"
	@echo "  nvim-profile-detailed - Detailed profiling with 20 runs"
	@echo "  clean-profile        - Clean up profiling artifacts"
	@echo ""
	@echo "Usage examples:"
	@echo "  make nvim-profile"
	@echo "  make nvim-profile-quick"
	@echo "  make nvim-profile RUNS=15 MIN_TIME=5"

# Main profiling target - runs profiling with configurable parameters
nvim-profile:
	@./scripts/profile-nvim.sh $(or $(RUNS),10) $(or $(MIN_TIME),10)

# Quick profiling for rapid testing
nvim-profile-quick:
	@./scripts/profile-nvim.sh 5 15

# Detailed profiling for thorough analysis
nvim-profile-detailed:
	@./scripts/profile-nvim.sh 20 5

# Clean up profiling artifacts
clean-profile:
	@echo "Cleaning up profiling artifacts..."
	@rm -rf /tmp/nvim-profiling
	@rm -f nvim-profile-*.csv
	@echo "✓ Cleanup complete"

# Additional useful targets for future expansion
.PHONY: check-health backup restore

# Check Neovim health
check-health:
	@nvim --headless +checkhealth +qa

# Backup current configuration
backup:
	@echo "Creating backup of Neovim configuration..."
	@tar -czf nvim-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz \
		--exclude='*.log' \
		--exclude='*.csv' \
		--exclude='backup' \
		--exclude='.git' \
		.
	@echo "✓ Backup created"
