#!/bin/sh

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=100
INTERVAL=5

log_event() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2"
}

trap 'echo "Stopping monitor..."; exit 0' SIGINT SIGTERM

while true; do
    clear
    echo "=========================================="
    echo "      LINUX CONTAINER HEALTH MONITOR      "
    echo "       (Refreshes every ${INTERVAL} seconds)      "
    echo "=========================================="

    # 1. CPU Usage
    CPU_IDLE=$(top -bn1 | grep "CPU:" | awk '{print $8}' | tr -d '%')
    if [ -n "$CPU_IDLE" ]; then
        CPU_USAGE=$((100 - ${CPU_IDLE%.*}))
    else
        CPU_USAGE=0
    fi

    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        log_event "ALERT" "High CPU Usage: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
    else
        log_event "OK" "CPU Usage: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
    fi

    # 2. Memory Usage
    MEM_TOTAL=$(free -m | awk '/Mem:/{print $2}')
    MEM_USED=$(free -m | awk '/Mem:/{print $3}')
    MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))

    if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
        log_event "ALERT" "High Memory Usage: ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)"
    else
        log_event "OK" "Memory Usage: ${MEM_USAGE}% (Threshold: ${MEM_THRESHOLD}%)"
    fi

    # 3. Disk Usage
    DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        log_event "ALERT" "High Disk Usage: ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
    else
        log_event "OK" "Disk Usage: ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
    fi

    # 4. Process Count
    PROC_COUNT=$(ps aux | wc -l)
    if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
        log_event "ALERT" "High Process Count: ${PROC_COUNT} (Threshold: ${PROC_THRESHOLD})"
    else
        log_event "OK" "Process Count: ${PROC_COUNT} (Threshold: ${PROC_THRESHOLD})"
    fi

    echo "=========================================="
    sleep "$INTERVAL"
done