#!/bin/bash

# ANSI color codes
COLOR_GOLD='\033[1;33m'  # สีทอง
COLOR_RED='\033[0;31m'   # สีแดง
NO_COLOR='\033[0m'       # ปิดการใช้งานสี

# Function to check connection using nc (netcat)
check_nc() {
  local ip=$1
  local port=$2
  if nc -zv -w 3 $ip $port > /dev/null 2>&1; then
    echo -e "${COLOR_GOLD}Online${NO_COLOR}"
  else
    echo -e "${COLOR_RED}Offline${NO_COLOR}"
  fi
}

# Function to check connection using wget
check_wget() {
  local ip=$1
  local port=$2
  if wget --spider --timeout=3 http://$ip:$port > /dev/null 2>&1; then
    echo -e "${COLOR_GOLD}Online${NO_COLOR}"
  else
    echo -e "${COLOR_RED}Offline${NO_COLOR}"
  fi
}

# Prompt user for IP and Port
read -p "Enter IP Address: " IP
read -p "Enter Port: " PORT

# Validate IP and Port input
if [[ -z "$IP" || -z "$PORT" ]]; then
  echo "IP Address and Port are required."
  exit 1
fi

while true; do
  # Get status from nc
  nc_status=$(check_nc $IP $PORT)
  # Get status from wget
  wget_status=$(check_wget $IP $PORT)

  # Print the table header
  clear
  echo "--------------------------------"
  echo " Method | Status               "
  echo "--------------------------------"
  echo " nc     | $nc_status           "
  echo " wget   | $wget_status         "
  echo "--------------------------------"
  
  # Sleep for 5 seconds before checking again
  sleep 5
done
