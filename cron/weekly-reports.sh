#!/bin/bash

ALERT="you@example.com"
HOST=$(hostname)
REPORT="/tmp/server-report.txt"
echo "Weekly Server Report - $HOST" > "$REPORT"
echo "Generated on: $(date)" >> "$REPORT"
echo "----------------------------------" >> "$REPORT"
# Uptime + Load
echo -e "\nUptime & Load:" >> "$REPORT"
uptime >> "$REPORT"
# Disk usage
echo -e "\nDisk Usage:" >> "$REPORT"
df -h >> "$REPORT"
# Disk hotspots
echo -e "\nTop Disk Usage (/):" >> "$REPORT"
du -h / --max-depth=1 2>/dev/null | sort -hr | head -n 10 >> "$REPORT"
# Memory + Swap
echo -e "\nMemory & Swap:" >> "$REPORT"
free -h >> "$REPORT"
# Top 5 memory consumers
echo -e "\nTop 5 Memory Consumers:" >> "$REPORT"
ps -eo pid,cmd,%mem --sort=-%mem | head -n 6 >> "$REPORT"
# Service restarts (last 7 days)
echo -e "\nService Restarts (Last 7 Days):" >> "$REPORT"
journalctl --since "7 days ago" | grep -i "Started\|Restarted" | tail -n 20 >> "$REPORT"
# Failed SSH login count
echo -e "\nFailed SSH Logins (Last 7 Days):" >> "$REPORT"
grep "Failed password" /var/log/auth.log | wc -l >> "$REPORT"
# Last backup
echo -e "\nLast Backup:" >> "$REPORT"
ls -lh /var/backups | tail -n 1 >> "$REPORT"
# Last 5 cron errors
echo -e "\nLast 5 Cron Errors:" >> "$REPORT"
grep -i "cron" /var/log/syslog 2>/dev/null | grep -i "error" | tail -n 5 >> "$REPORT"
# Reboot required
echo -e "\nReboot Required:" >> "$REPORT"
if [ -f /var/run/reboot-required ]; then
  echo "YES" >> "$REPORT"
else
  echo "NO" >> "$REPORT"
fi
# Send report
mail -s "Weekly Server Report - $HOST" $ALERT < "$REPORT"
# Cleanup
rm -f "$REPORT"


