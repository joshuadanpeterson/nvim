#!/usr/bin/env python3
"""Parse Neovim startup log and extract timing information."""

import sys
import re

def parse_log(log_file, min_time_ms):
    """Parse the log file and extract items above the threshold."""
    total_time = 0
    items = []
    
    with open(log_file, 'r') as f:
        for line in f:
            line = line.strip()
            
            # Find total time
            if 'NVIM STARTED' in line:
                match = re.match(r'^(\d+\.\d+)', line)
                if match:
                    total_time = float(match.group(1))
            
            # Skip headers and empty lines
            if not line or line.startswith('---') or 'times in msec' in line or line.startswith('clock'):
                continue
            
            # Parse timing lines - handle various formats
            # Format 1: "000.123  000.045: description"
            # Format 2: "000.123  000.045  000.012  000.033: sourcing file"
            parts = line.split()
            if len(parts) >= 2 and re.match(r'^\d+\.\d+$', parts[0]):
                # Find the colon to separate times from description
                colon_idx = -1
                for i, part in enumerate(parts):
                    if ':' in part:
                        colon_idx = i
                        break
                
                if colon_idx >= 1:
                    # The second number is the item time
                    item_time_str = parts[1]
                    if item_time_str.endswith(':'):
                        item_time_str = item_time_str[:-1]
                    
                    try:
                        item_time = float(item_time_str)
                        # Get description after the colon
                        if colon_idx < len(parts) - 1:
                            description = ' '.join(parts[colon_idx:]).lstrip(': ')
                        else:
                            description = parts[colon_idx].split(':', 1)[1] if ':' in parts[colon_idx] else ''
                        
                        if item_time >= min_time_ms and description:
                            items.append({
                                'time': item_time,
                                'description': description
                            })
                    except ValueError:
                        continue
    
    # Sort by time descending
    items.sort(key=lambda x: x['time'], reverse=True)
    
    # Calculate percentages after we have the total time
    for item in items:
        item['percentage'] = (item['time'] / total_time * 100) if total_time > 0 else 0
    
    return items, total_time

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: parse-nvim-log.py <log_file> <min_time_ms>", file=sys.stderr)
        sys.exit(1)
    
    log_file = sys.argv[1]
    min_time_ms = float(sys.argv[2])
    
    try:
        items, total_time = parse_log(log_file, min_time_ms)
        
        # Output as CSV
        for item in items:
            print(f"{item['time']:.3f},{item['percentage']:.1f},{item['description']}")
            
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
