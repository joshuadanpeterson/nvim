# Neovim Startup Profiling Workflow

This document describes the profiling workflow for analyzing and optimizing Neovim startup times.

## Quick Start

```bash
# Run default profiling (10 runs, 10ms threshold)
make nvim-profile

# Quick profiling (5 runs, 15ms threshold)  
make nvim-profile-quick

# Detailed profiling (20 runs, 5ms threshold)
make nvim-profile-detailed

# Custom profiling
make nvim-profile RUNS=15 MIN_TIME=8
```

## What It Does

The profiling workflow:

1. **Runs Neovim multiple times** with `--startuptime` flag to collect timing data
2. **Calculates statistics** including mean, median, min, max, and standard deviation
3. **Analyzes the median run** for detailed timing breakdown
4. **Generates a CSV report** with:
   - Timestamp for each profiling session
   - Time in milliseconds for each item
   - Description of what's being loaded
   - Percentage of total startup time
5. **Displays top slow items** in the terminal

## Output Files

- **CSV Report**: `nvim-profile-YYYYMMDD-HHMMSS.csv`
  - Can be imported into spreadsheet apps for analysis
  - Includes summary statistics at the end
  - Sorted by time descending

## Interpreting Results

Look for:
- Items taking >50ms (major bottlenecks)
- Items taking >10% of total startup time
- Repeated loading of the same modules
- Unnecessary plugin loading

## Optimization Workflow

1. **Baseline**: Run `make nvim-profile` before changes
2. **Make changes**: Optimize configuration/plugins
3. **Compare**: Run profiling again
4. **Diff CSVs**: Compare before/after results

```bash
# Compare two CSV files
diff nvim-profile-before.csv nvim-profile-after.csv
```

## Technical Details

The workflow consists of:
- **Makefile**: `/Users/joshpeterson/.config/nvim/Makefile` - Easy command interface
- **Bash Script**: `scripts/profile-nvim.sh` - Main profiling logic
- **Python Parser**: `scripts/parse-nvim-log.py` - Robust log parsing

## Tips

- Run profiling after a fresh Neovim restart for consistent results
- Use lower thresholds (5ms) to find all optimization opportunities
- Higher run counts (20+) give more stable statistics
- Save baseline CSV files for future comparison
