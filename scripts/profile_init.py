#!/usr/bin/env python3
"""
Neovim startup profiling script for performance monitoring.
Measures cold start and cached startup times.
"""

import subprocess
import time
import csv
import os
import statistics
from datetime import datetime
import sys
import tempfile

def run_nvim_headless(startuptime_file):
    """Run Neovim in headless mode with startup timing."""
    cmd = [
        'nvim',
        '--headless',
        '--startuptime', startuptime_file,
        '+qa'
    ]
    
    try:
        # Set a timeout to prevent hanging
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        return result.returncode == 0
    except subprocess.TimeoutExpired:
        print("Warning: Neovim startup timed out")
        return False
    except Exception as e:
        print(f"Error running Neovim: {e}")
        return False

def parse_startuptime_log(log_file):
    """Parse the Neovim startuptime log file."""
    try:
        with open(log_file, 'r') as f:
            lines = f.readlines()
        
        total_time = None
        slow_items = []
        
        for line in lines:
            # Find total startup time
            if 'NVIM STARTED' in line:
                parts = line.strip().split()
                if parts:
                    total_time = float(parts[0])
            
            # Parse individual items (looking for lines with timing info)
            # Format: "000.000  000.000: some description"
            parts = line.strip().split(None, 2)
            if len(parts) >= 3 and ':' in parts[2]:
                try:
                    # Extract the incremental time (second column)
                    item_time = float(parts[1])
                    description = parts[2]
                    
                    # Only track items that take more than 10ms
                    if item_time >= 10.0:
                        # Clean up the description
                        if 'sourcing' in description:
                            # Extract just the file being sourced
                            desc_parts = description.split('sourcing')
                            if len(desc_parts) > 1:
                                description = desc_parts[1].strip()
                        elif 'require(' in description:
                            # Extract module name from require statements
                            start = description.find("'")
                            end = description.rfind("'")
                            if start >= 0 and end > start:
                                description = description[start+1:end]
                        
                        slow_items.append({
                            'time': item_time,
                            'description': description
                        })
                except (ValueError, IndexError):
                    continue
        
        return total_time, slow_items
    except Exception as e:
        print(f"Error parsing log file: {e}")
        return None, []

def measure_startup_times(runs=10):
    """Measure Neovim startup times with multiple runs."""
    cold_times = []
    cached_times = []
    all_slow_items = {}
    
    print(f"Measuring Neovim startup performance ({runs} runs)...")
    
    for i in range(runs):
        print(f"Run {i+1}/{runs}", end='', flush=True)
        
        # Create temporary file for startup log
        with tempfile.NamedTemporaryFile(mode='w', suffix='.log', delete=False) as tmp:
            log_file = tmp.name
        
        # Clear caches for cold start measurement (first run only)
        if i == 0:
            print(" (cold start)", end='', flush=True)
            # Clear various caches
            subprocess.run(['sync'], capture_output=True)
            # Note: On macOS, we can't easily clear all caches without sudo
        
        # Measure startup time
        start = time.time()
        success = run_nvim_headless(log_file)
        elapsed = (time.time() - start) * 1000  # Convert to milliseconds
        
        if success:
            # Parse the log file
            total_time, slow_items = parse_startuptime_log(log_file)
            
            if total_time:
                if i == 0:
                    cold_times.append(total_time)
                else:
                    cached_times.append(total_time)
                
                # Aggregate slow items
                for item in slow_items:
                    desc = item['description']
                    if desc not in all_slow_items:
                        all_slow_items[desc] = []
                    all_slow_items[desc].append(item['time'])
        
        # Clean up
        try:
            os.unlink(log_file)
        except:
            pass
        
        print(" ✓")
    
    return cold_times, cached_times, all_slow_items

def generate_report(cold_times, cached_times, slow_items, output_file):
    """Generate CSV report with profiling results."""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    # Calculate statistics
    cold_avg = statistics.mean(cold_times) if cold_times else 0
    cached_avg = statistics.mean(cached_times) if cached_times else 0
    cached_median = statistics.median(cached_times) if cached_times else 0
    
    print(f"\n📊 Performance Summary:")
    print(f"  Cold start:   {cold_avg:.1f} ms")
    print(f"  Cached (avg): {cached_avg:.1f} ms")
    print(f"  Cached (med): {cached_median:.1f} ms")
    
    # Check against targets
    cold_target = 400
    cached_target = 150
    
    cold_status = "✅" if cold_avg < cold_target else "❌"
    cached_status = "✅" if cached_avg < cached_target else "❌"
    
    print(f"\nTarget Status:")
    print(f"  Cold < {cold_target}ms: {cold_status} ({cold_avg:.1f}ms)")
    print(f"  Cached < {cached_target}ms: {cached_status} ({cached_avg:.1f}ms)")
    
    # Write CSV file
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        
        # Header
        writer.writerow(['Neovim Startup Profile Report'])
        writer.writerow(['Timestamp:', timestamp])
        writer.writerow([])
        
        # Summary statistics
        writer.writerow(['Metric', 'Value (ms)', 'Target (ms)', 'Status'])
        writer.writerow(['Cold Start', f'{cold_avg:.1f}', str(cold_target), cold_status])
        writer.writerow(['Cached (Average)', f'{cached_avg:.1f}', str(cached_target), cached_status])
        writer.writerow(['Cached (Median)', f'{cached_median:.1f}', '-', '-'])
        writer.writerow([])
        
        # Slow modules/scripts
        writer.writerow(['Module/Script', 'Average Time (ms)'])
        
        # Sort by average time
        sorted_items = []
        for desc, times in slow_items.items():
            avg_time = statistics.mean(times)
            sorted_items.append((desc, avg_time))
        
        sorted_items.sort(key=lambda x: x[1], reverse=True)
        
        # Write top slow items
        for desc, avg_time in sorted_items[:20]:  # Top 20 slow items
            writer.writerow([desc, f'{avg_time:.1f}'])
    
    print(f"\n📄 Report saved to: {output_file}")

def main():
    """Main function."""
    # Check if we're in the right directory
    if not os.path.exists('init.lua'):
        print("Error: Please run this script from the Neovim config directory (~/.config/nvim)")
        sys.exit(1)
    
    # Create profile directory if it doesn't exist
    os.makedirs('profile', exist_ok=True)
    
    # Output file
    output_file = 'profile/after.csv'
    
    # Run profiling
    cold_times, cached_times, slow_items = measure_startup_times(runs=5)
    
    if not cold_times and not cached_times:
        print("\nError: Could not collect any timing data")
        print("This might be due to Neovim configuration issues.")
        print("Try running: nvim --headless +qa")
        sys.exit(1)
    
    # Generate report
    generate_report(cold_times, cached_times, slow_items, output_file)
    
    # Show comparison with baseline if it exists
    baseline_file = 'profile/baseline.csv'
    if os.path.exists(baseline_file):
        print(f"\n💡 To compare with baseline, run:")
        print(f"   diff {baseline_file} {output_file}")

if __name__ == '__main__':
    main()
