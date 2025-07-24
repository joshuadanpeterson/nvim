#!/usr/bin/env bash
# profile-nvim.sh - Robust Neovim startup profiling with statistics

set -uo pipefail

# Configuration
RUNS=${1:-10}
MIN_TIME_MS=${2:-10}
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
CSV_FILE="nvim-profile-${TIMESTAMP}.csv"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}🚀 Neovim Startup Profiling${NC}"
echo -e "${BLUE}Configuration:${NC} $RUNS runs | ${MIN_TIME_MS}ms threshold"
echo ""

# Clean up any old temp files
rm -f /tmp/nvim-profile-*.log 2>/dev/null || true

# Collect startup times
echo -n "Collecting data: "
times=()
for i in $(seq 1 $RUNS); do
    echo -n "."
    
    # Run nvim and capture log
    LOG_FILE="/tmp/nvim-profile-$i.log"
    nvim --headless --startuptime "$LOG_FILE" +qa 2>/dev/null
    
    # Extract total time (handle both integer and float)
    time=$(grep "NVIM STARTED" "$LOG_FILE" | awk '{print $1}')
    times+=("$time")
done
echo " Done!"
echo ""

# Sort times for median calculation
IFS=$'\n' sorted_times=($(sort -n <<<"${times[*]}"))
unset IFS

# Calculate statistics
count=${#times[@]}
min="${sorted_times[0]}"
max="${sorted_times[$((count-1))]}"

# Calculate median
if (( count % 2 == 0 )); then
    mid1=$((count / 2 - 1))
    mid2=$((count / 2))
    # Bash doesn't do float math, so we'll use awk
    median=$(awk "BEGIN {print (${sorted_times[$mid1]} + ${sorted_times[$mid2]}) / 2}")
else
    mid=$((count / 2))
    median="${sorted_times[$mid]}"
fi

# Calculate mean
sum=0
for t in "${times[@]}"; do
    sum=$(awk "BEGIN {print $sum + $t}")
done
mean=$(awk "BEGIN {print $sum / $count}")

# Calculate standard deviation
sum_sq_diff=0
for t in "${times[@]}"; do
    diff=$(awk "BEGIN {print $t - $mean}")
    sq_diff=$(awk "BEGIN {print $diff * $diff}")
    sum_sq_diff=$(awk "BEGIN {print $sum_sq_diff + $sq_diff}")
done
variance=$(awk "BEGIN {print $sum_sq_diff / $count}")
stdev=$(awk "BEGIN {print sqrt($variance)}")

# Display statistics
echo -e "${YELLOW}📊 Startup Time Statistics${NC}"
echo "─────────────────────────────"
printf "Runs:     %d\n" "$count"
printf "Mean:     %.1fms\n" "$mean"
printf "Median:   %.1fms\n" "$median"
printf "Min:      %.1fms\n" "$min"
printf "Max:      %.1fms\n" "$max"
printf "Std Dev:  %.1fms\n" "$stdev"
echo ""

# Find the run closest to median for detailed analysis
best_idx=1
best_diff=999999
for i in $(seq 1 $RUNS); do
    time="${times[$((i-1))]}"
    diff=$(awk "BEGIN {d = $time - $median; print (d < 0) ? -d : d}")
    if (( $(awk "BEGIN {print ($diff < $best_diff)}") )); then
        best_diff="$diff"
        best_idx="$i"
    fi
done

DETAIL_LOG="/tmp/nvim-profile-${best_idx}.log"

# Create CSV file
echo "timestamp,time_ms,item,percentage" > "$CSV_FILE"

# Get total time for percentage calculation
total_time=$(grep "NVIM STARTED" "$DETAIL_LOG" | awk '{print $1}')

echo -e "${GREEN}📝 Analyzing items >${MIN_TIME_MS}ms from run closest to median...${NC}"

# Use Python script to parse the log file
SCRIPT_DIR="$(dirname "$0")"
if python3 "$SCRIPT_DIR/parse-nvim-log.py" "$DETAIL_LOG" "$MIN_TIME_MS" > /tmp/parsed-items.csv 2>/tmp/parse-error.log; then
    # Process the parsed items
    item_count=0
    while IFS=',' read -r time percentage description; do
        echo "\"$TIMESTAMP\",$time,\"$description\",${percentage}%" >> "$CSV_FILE"
        ((item_count++))
    done < /tmp/parsed-items.csv
    rm -f /tmp/parsed-items.csv
else
    if [ -s /tmp/parse-error.log ]; then
        echo "Parser error:" >&2
        cat /tmp/parse-error.log >&2
    fi
    echo "Warning: Could not parse log file - falling back to basic parsing" >&2
    # Fallback: look for lines with obvious slow items
    grep -E "sourcing.*\.lua|sourcing.*\.vim|require\(" "$DETAIL_LOG" | while read -r line; do
        if [[ $line =~ ([0-9]+\.[0-9]+)[[:space:]]+([0-9]+\.[0-9]+):[[:space:]]+(.+) ]]; then
            item_time="${BASH_REMATCH[2]}"
            description="${BASH_REMATCH[3]}"
            if (( $(awk "BEGIN {print ($item_time >= $MIN_TIME_MS)}") )); then
                percentage=$(awk "BEGIN {printf \"%.1f\", ($item_time / $total_time) * 100}")
                echo "\"$TIMESTAMP\",$item_time,\"$description\",${percentage}%" >> "$CSV_FILE"
                ((item_count++))
            fi
        fi
    done
fi

# Sort CSV by time (keeping header)
if [ -f "$CSV_FILE" ]; then
    (head -1 "$CSV_FILE" && tail -n +2 "$CSV_FILE" | sort -t',' -k2 -nr) > "${CSV_FILE}.tmp"
    mv "${CSV_FILE}.tmp" "$CSV_FILE"
fi

# Display top slow items
echo ""
echo -e "${YELLOW}🐌 Top Slow Items (>${MIN_TIME_MS}ms)${NC}"
echo "────────────────────────────────────────────"
printf "%-10s | %-8s | %s\n" "Time (ms)" "% Total" "Item"
echo "────────────────────────────────────────────"

displayed=0
tail -n +2 "$CSV_FILE" 2>/dev/null | while IFS=',' read -r timestamp time item percentage; do
    if [ $displayed -ge 10 ]; then break; fi
    
    # Clean up quotes
    item=${item//\"/}
    time=${time// /}
    percentage=${percentage// /}
    
    # Truncate long items
    if [ ${#item} -gt 60 ]; then
        item="${item:0:57}..."
    fi
    
    printf "%-10s | %-8s | %s\n" "$time" "$percentage" "$item"
    ((displayed++))
done

# Add summary statistics to CSV
{
    echo ""
    echo "# Summary Statistics"
    echo "metric,value"
    echo "runs,$count"
    echo "mean,$mean"
    echo "median,$median"
    echo "min,$min"
    echo "max,$max"
    echo "std_dev,$stdev"
    echo "threshold,$MIN_TIME_MS"
    echo "analyzed_run,$best_idx"
    echo "items_found,$item_count"
} >> "$CSV_FILE"

# Clean up temp files
rm -f /tmp/nvim-profile-*.log

echo ""
echo -e "${GREEN}✅ Profiling complete!${NC}"
echo -e "${BLUE}📄 Report saved to:${NC} $CSV_FILE"
echo ""
echo -e "${BLUE}💡 Tips:${NC}"
echo "  • Compare CSV files before/after changes with: diff file1.csv file2.csv"
echo "  • View in spreadsheet app for detailed analysis"
echo "  • Run 'make nvim-profile-detailed' for more thorough analysis"
