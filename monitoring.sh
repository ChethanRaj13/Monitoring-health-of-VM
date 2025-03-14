#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  echo $cpu_usage
}

# Function to get memory usage
get_memory_usage() {
  memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo $memory_usage
}

# Function to get disk usage
get_disk_usage() {
  disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
  echo $disk_usage
}

# Function to check health
check_health() {
  cpu_usage=$(get_cpu_usage)
  memory_usage=$(get_memory_usage)
  disk_usage=$(get_disk_usage)

  if [ $(echo "$cpu_usage > 60" | bc) -eq 1 ] || [ $(echo "$memory_usage > 60" | bc) -eq 1 ] || [ $(echo "$disk_usage > 60" | bc) -eq 1 ]; then
    echo "unhealthy"
  else
    echo "healthy"
  fi
}

# Function to explain the usage
explain_usage() {
  cpu_usage=$(get_cpu_usage)
  memory_usage=$(get_memory_usage)
  disk_usage=$(get_disk_usage)

  echo "CPU Usage: $cpu_usage%"
  echo "Memory Usage: $memory_usage%"
  echo "Disk Usage: $disk_usage%"
}

# Main script
if [ "$1" == "explain" ]; then
  explain_usage
  check_health
else
  check_health
fi
