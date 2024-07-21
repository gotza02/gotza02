#!/bin/bash

# Define constants
readonly DEFAULT_INTERVAL=5

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN_DARK='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly CYAN='\033[0;36m'
readonly RESET='\033[0m'

# Check if required tools are installed
for tool in ping nc curl host; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}Error: $tool is not installed. Please install it and try again.${RESET}"
        exit 1
    fi
done

# Load config file if exists
CONFIG_FILE="$HOME/.server_status_config"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

# Initialize variables
HOST=""
INTERVAL="$DEFAULT_INTERVAL"

# Usage function
usage() {
    echo "Usage: $0 [-h host] [-i interval] [command]"
    echo "  -h host      Specify the host to check"
    echo "  -i interval  Specify the interval in seconds (default: $DEFAULT_INTERVAL)"
    echo "  command      Optional command to check service (ping, netcat, curl)"
    exit 1
}

# Parse command line options
while getopts "h:i:" opt; do
    case $opt in
        h) HOST="$OPTARG" ;;
        i) INTERVAL="$OPTARG" ;;
        *) usage ;;
    esac
done
shift $((OPTIND -1))

# Prompt user for HOST if not provided
if [[ -z "$HOST" ]]; then
    read -p "Please enter the host to check: " HOST
fi

# Get IP address
get_ip() {
    IP=$(host -t A "$HOST" | awk '/has address/ { print $4 }' | head -n1)
    if [ -z "$IP" ]; then
        IP="${RED}Unable to resolve${RESET}"
    fi
}

# Declare associative arrays for status and result
declare -A STATUS
declare -A RESULT

# Function to check service status
check_service() {
    local service=$1
    local command=$2
    if eval $command; then
        STATUS[$service]="${GREEN_DARK}✔ $service to $HOST ($IP) is successful.${RESET}"
        RESULT[$service]="${GREEN_DARK}Very good${RESET}"
    else
        STATUS[$service]="${RED}✘ $service to $HOST ($IP) failed!${RESET}"
        RESULT[$service]="${RED}Bad${RESET}"
    fi
}

# Function to display the status
display_status() {
    clear
    printf "${CYAN}%-50s${RESET}\n" "=================================================="
    printf "${CYAN}%-50s${RESET}\n" "                 Server Status"
    printf "${CYAN}%-50s${RESET}\n" "=================================================="
    printf "Host: ${YELLOW}%s${RESET}\n" "$HOST"
    printf "IP: ${YELLOW}%s${RESET}\n" "$IP"
    printf "Interval: ${YELLOW}%s seconds${RESET}\n" "$INTERVAL"
    printf "${CYAN}%-50s${RESET}\n" "=================================================="
    for service in "${!STATUS[@]}"; do
        echo -e "${STATUS[$service]}"
    done
    printf "${CYAN}%-50s${RESET}\n" "=================================================="
    for service in "${!RESULT[@]}"; do
        printf "${CYAN}%-20s${RESET} : ${RESULT[$service]}\n" "$service Status"
    done
    printf "${CYAN}%-50s${RESET}\n" "=================================================="
    printf "${CYAN}Refreshing status every %s seconds...${RESET}\n" "$INTERVAL"
    printf "${CYAN}Press Ctrl+C to exit${RESET}\n"
}

# Function to log status
log_status() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp - Host: $HOST, IP: $IP, Ping: ${RESULT[Ping]}, Netcat: ${RESULT[Netcat]}, Curl: ${RESULT[Curl]}" >> status_log.txt
}

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}Exiting...${RESET}"
    exit 0
}

# Trap SIGINT (Ctrl+C) and call cleanup
trap cleanup SIGINT

# Main function for running individual commands or main loop
main() {
    get_ip

    if [[ -n $1 ]]; then
        case $1 in
            ping)
                check_service "Ping" "ping -c 1 $HOST > /dev/null"
                ;;
            netcat)
                check_service "Netcat" "echo 'KEEPALIVE' | nc -w 1 $HOST 80 >/dev/null 2>&1"
                ;;
            curl)
                check_service "Curl" "curl -s -o /dev/null --connect-timeout 5 'https://$HOST'"
                ;;
            *)
                usage
                ;;
        esac

        echo -e "${STATUS[$1]}"
    else
        while true; do
            check_service "Ping" "ping -c 1 $HOST > /dev/null"
            check_service "Netcat" "echo 'KEEPALIVE' | nc -w 1 $HOST 80 >/dev/null 2>&1"
            check_service "Curl" "curl -s -o /dev/null --connect-timeout 5 'https://$HOST'"

            display_status
            log_status

            sleep "$INTERVAL"
        done
    fi
}

# Execute the main function with the remaining parameters
main "$@"
