#!/bin/bash
# @ https://medium.com/@bektiaw/6-cron-jobs-you-should-run-on-your-server-1c8df0306280

# Thresholds
LOAD_THRESHOLD=2.0     # adjust based on CPU cores
MEM_THRESHOLD=80       # % used (based on available memory)
SWAP_THRESHOLD=20      # % swap usage
DISK_THRESHOLD=90      # % disk usage
ALERT="you@example.com"
# Load average (1 minute)
LOAD=$(awk '{print $1}' /proc/loadavg)
# Memory usage (based on available memory)
MEM=$(free | awk '/Mem:/ {printf("%.0f"), ($2-$7)/$2 * 100}')
# Swap usage
SWAP=$(free | awk '/Swap:/ {if ($2==0) print 0 ; else printf("%.0f"), $3/$2 * 100}')
# Disk usage (root partition)
DISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
# Check load
if (( $(echo "$LOAD > $LOAD_THRESHOLD" | bc -l) )); then
  echo "High load average: $LOAD (threshold: $LOAD_THRESHOLD)" | mail -s "Load Alert" $ALERT
fi
# Check memory
if [ "$MEM" -gt "$MEM_THRESHOLD" ]; then
  echo "High memory usage: ${MEM}% (threshold: ${MEM_THRESHOLD}%)" | mail -s "Memory Alert" $ALERT
fi
# Check swap
if [ "$SWAP" -gt "$SWAP_THRESHOLD" ]; then
  echo "High swap usage: ${SWAP}% (threshold: ${SWAP_THRESHOLD}%)" | mail -s "Swap Alert" $ALERT
fi
# Check disk
if [ "$DISK" -gt "$DISK_THRESHOLD" ]; then
  echo "High disk usage: ${DISK}% (threshold: ${DISK_THRESHOLD}%)" | mail -s "Disk Alert" $ALERT
fi

