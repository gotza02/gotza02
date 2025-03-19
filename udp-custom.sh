#!/bin/bash

# Check for root privileges
[[ $EUID -ne 0 ]] && { echo -e "\033[1;31mError: Root privileges required\033[0m"; exit 1; }

# Constants
readonly UDP_DIR="/etc/UDPCustom"
readonly UDP_BINARY="${UDP_DIR}/udp-custom"
readonly CONFIG_DIR="/root/udp"
readonly LOG_FILE="/var/log/udp-custom.log"
readonly BACKUP_DIR="/root/udp-backups"
readonly VERSION="4.0-intelligent"
readonly BINARY_URL="https://raw.github.com/http-custom/udp-custom/main/bin/udp-custom-linux-amd64"
readonly REQUIRED_PACKAGES="wget curl dos2unix neofetch net-tools jq bc"

# Colors
readonly RED="\033[1;31m"
readonly GREEN="\033[1;32m"
readonly YELLOW="\033[1;33m"
readonly CYAN="\033[1;36m"
readonly RESET="\033[0m"

# Intelligent variables (adjusted dynamically)
CORES=$(nproc)
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MAX_CONNECTIONS=$((CORES * 250))  # 250 connections per core
CONNECTION_POOL=$((CORES * 50))   # 50 connections per core in pool
WORKER_THREADS=$((CORES > 8 ? 8 : CORES))  # Cap at 8 threads for efficiency

# Embedded content
MODULE_CONTENT=$(cat << 'EOF'
#!/bin/bash
print_center() {
    local text="$1" color="$2"
    [[ -z $color ]] || printf "$color"
    printf "%*s\n" $((($(tput cols) + ${#text}) / 2)) "$text"
    printf "\033[0m"
}

log() {
    local level="$1" message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

check_binary_version() {
    if command -v "$UDP_BINARY" >/dev/null 2>&1; then
        "$UDP_BINARY" --version 2>/dev/null || echo "Unknown"
    else
        echo "Not installed"
    fi
}

analyze_performance() {
    local pid=$(pidof udp-custom)
    [ -z "$pid" ] && { echo "Service not running"; return; }
    local cpu=$(ps -p "$pid" -o %cpu | tail -n1)
    local mem=$(ps -p "$pid" -o %mem | tail -n1)
    echo "CPU Usage: $cpu% | Memory Usage: $mem%"
}
EOF
)

LIMITER_CONTENT=$(cat << 'EOF'
#!/bin/bash
LIMIT=$MAX_CONNECTIONS
MONITOR_FILE="/var/log/udp_monitor.log"

check_limit() {
    local active=$(ss -tunlp | grep udp-custom | wc -l)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Active connections: $active" >> "$MONITOR_FILE"
    if [ "$active" -gt "$LIMIT" ]; then
        echo "Warning: Connection limit ($LIMIT) exceeded: $active"
        return 1
    fi
    return 0
}

get_stats() {
    ss -tunlp | grep udp-custom | awk '{print $1 " " $5}' | sort -u
}
EOF
)

UDPGW_CONTENT=$(cat << 'EOF'
#!/bin/bash
exec /usr/sbin/udpgw --listen 0.0.0.0:7300 \
    --max-clients $MAX_CONNECTIONS \
    --health-check-interval 30 \
    --log-file /var/log/udpgw.log
EOF
)

CONFIG_JSON=$(cat << EOF
{
    "listen": ":7300",
    "buffer_size": 65535,
    "timeout": 30,
    "max_connections": $MAX_CONNECTIONS,
    "log_level": "info",
    "monitoring": {
        "enabled": true,
        "interval": 60,
        "metrics": ["connections", "bandwidth", "errors"]
    },
    "security": {
        "allowed_ips": ["0.0.0.0/0"],
        "rate_limit": {
            "connections_per_ip": 10,
            "burst": 20
        },
        "encryption": "none"
    },
    "performance": {
        "worker_threads": $WORKER_THREADS,
        "connection_pool_size": $CONNECTION_POOL
    }
}
EOF
)

UDP_MENU=$(cat << 'EOF'
#!/bin/bash
while true; do
    clear
    echo "UDP Custom Intelligent Menu (v$VERSION)"
    echo "1. Check Status"
    echo "2. Start/Stop Service"
    echo "3. Restart Service"
    echo "4. View Statistics"
    echo "5. View Logs"
    echo "6. Analyze Performance"
    echo "7. Backup Config"
    echo "8. Restore Config"
    echo "9. Update Binary"
    echo "10. Uninstall"
    echo "11. Exit"
    read -p "Select option: " choice
    case $choice in
        1) systemctl status udp-custom ;;
        2) systemctl is-active udp-custom >/dev/null 2>&1 && systemctl stop udp-custom || systemctl start udp-custom ;;
        3) systemctl restart udp-custom ;;
        4) bash /etc/limiter.sh get_stats ;;
        5) less /var/log/udp_monitor.log ;;
        6) bash "$UDP_DIR/module" analyze_performance ;;
        7) mkdir -p "$BACKUP_DIR"; cp "$CONFIG_DIR/config.json" "$BACKUP_DIR/config.json.$(date +%F_%T)" && echo "Config backed up" ;;
        8) ls "$BACKUP_DIR" && read -p "Enter backup file to restore: " file; [ -f "$BACKUP_DIR/$file" ] && cp "$BACKUP_DIR/$file" "$CONFIG_DIR/config.json" && systemctl restart udp-custom && echo "Config restored" ;;
        9) wget -O "$UDP_BINARY" "$BINARY_URL" && chmod 755 "$UDP_BINARY" && systemctl restart udp-custom && echo "Binary updated" ;;
        10) systemctl stop udp-custom; systemctl disable udp-custom; rm -rf "$UDP_DIR" "$CONFIG_DIR" "/usr/bin/udp" "/etc/limiter.sh" "/bin/udpgw" "/etc/systemd/system/udp-custom.service" "$BACKUP_DIR"; echo "Uninstalled" ;;
        11) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
    read -p "Press Enter to continue..."
done
EOF
)

# Utility functions
print_center() {
    local text="$1" color="$2"
    [[ -z $color ]] || printf "$color"
    printf "%*s\n" $((($(tput cols) + ${#text}) / 2)) "$text"
    printf "$RESET"
}

log() {
    local level="$1" message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
}

check_requirements() {
    log "INFO" "Checking system requirements"
    for pkg in $REQUIRED_PACKAGES; do
        dpkg -l "$pkg" >/dev/null 2>&1 || return 1
    done
    if [ "$MEM_TOTAL" -lt 512 ]; then
        log "ERROR" "Insufficient memory: ${MEM_TOTAL}MB (minimum 512MB)"
        echo -e "${RED}Error: Insufficient memory (${MEM_TOTAL}MB)${RESET}"
        exit 1
    fi
    [ "$CORES" -lt 2 ] && log "WARNING" "Low CPU cores detected: $CORES"
}

# Installation functions
cleanup() {
    log "INFO" "Starting cleanup"
    systemctl stop udp-custom 2>/dev/null
    rm -rf "$CONFIG_DIR" "$UDP_DIR" "/usr/bin/udp" "/etc/limiter.sh" "/etc/udpgw.service"
    mkdir -p "$CONFIG_DIR" "$UDP_DIR" "$BACKUP_DIR" /var/log
    chown root:root "$CONFIG_DIR" "$UDP_DIR" "$BACKUP_DIR"
    chmod 700 "$CONFIG_DIR" "$UDP_DIR" "$BACKUP_DIR"
    touch "$LOG_FILE" && chmod 600 "$LOG_FILE"
}

install_packages() {
    log "INFO" "Installing required packages"
    apt update -y && apt upgrade -y && apt install -y $REQUIRED_PACKAGES || {
        log "ERROR" "Package installation failed"
        echo -e "${RED}Package installation failed${RESET}"
        exit 1
    }
}

check_ubuntu_version() {
    local version=$(lsb_release -rs)
    log "INFO" "Checking Ubuntu version: $version"
    case $version in
        8*|9*|10*|11*|16.04*|18.04*)
            print_center "This script requires Ubuntu 20.04+" "$RED"
            exit 1
            ;;
        *) print_center "Compatible OS detected" "$GREEN" ;;
    esac
}

install_binary() {
    log "INFO" "Installing UDP binary"
    wget -qO "$UDP_BINARY" "$BINARY_URL" && chmod 755 "$UDP_BINARY" || {
        log "ERROR" "Binary download failed"
        return 1
    }
    if [ ! -f "$UDP_BINARY" ] || [ ! -x "$UDP_BINARY" ]; then
        log "ERROR" "Binary not found or not executable"
        echo -e "${RED}Binary installation failed${RESET}"
        exit 1
    fi
}

write_files() {
    log "INFO" "Writing configuration files with intelligent settings"
    echo "$MODULE_CONTENT" > "${UDP_DIR}/module" && chmod 755 "${UDP_DIR}/module"
    echo "$LIMITER_CONTENT" > "/etc/limiter.sh" && chmod 755 "/etc/limiter.sh"
    echo "$UDPGW_CONTENT" > "/bin/udpgw" && chmod 755 "/bin/udpgw"
    echo "$CONFIG_JSON" > "${CONFIG_DIR}/config.json" && chmod 600 "${CONFIG_DIR}/config.json"
    echo "$UDP_MENU" > "/usr/bin/udp" && chmod 755 "/usr/bin/udp"
}

install_services() {
    log "INFO" "Configuring systemd service"
    cat > "/etc/systemd/system/udp-custom.service" << EOF
[Unit]
Description=UDP Custom Intelligent Service (v$VERSION)
After=network.target

[Service]
Type=simple
WorkingDirectory=${CONFIG_DIR}
ExecStart=${UDP_BINARY}
Restart=always
RestartSec=5
User=root
LimitNOFILE=65535
OOMScoreAdjust=-1000
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now udp-custom || {
        log "ERROR" "Service setup failed"
        return 1
    }
    sleep 2
    if ! systemctl is-active --quiet udp-custom; then
        log "ERROR" "Service failed to start"
        echo -e "${RED}Service failed to start${RESET}"
        exit 1
    fi
}

# Main execution
main() {
    log "INFO" "Starting intelligent installation v$VERSION"
    print_center "UDP Custom Intelligent Installation (v$VERSION)" "$CYAN"
    print_center "Detected: $CORES cores, $MEM_TOTAL MB RAM" "$YELLOW"
    cleanup
    check_ubuntu_version
    install_packages
    check_requirements || { log "ERROR" "System requirements not met"; echo -e "${RED}Requirements check failed${RESET}"; exit 1; }
    install_binary || { log "ERROR" "Binary installation failed"; exit 1; }
    write_files
    install_services

    print_center "Installation Completed Successfully" "$GREEN"
    print_center "Optimized for $MAX_CONNECTIONS connections, $WORKER_THREADS threads" "$CYAN"
    print_center "Type 'udp' to access the intelligent menu" "$YELLOW"
    log "INFO" "Installation completed with settings: max_connections=$MAX_CONNECTIONS, threads=$WORKER_THREADS"
}

# Error handling
trap 'log "ERROR" "Script interrupted"; echo -e "${RED}Installation interrupted${RESET}"; exit 1' INT TERM

main
