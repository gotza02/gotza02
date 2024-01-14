
#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi

echo "Starting network optimization..."

# Update System Packages
echo "Updating system packages..."
apt-get update

# Prompt for upgrade
read -p "Do you want to upgrade all system packages? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get upgrade -y
fi

# Install ethtool
echo "Installing ethtool..."
apt-get install -y ethtool

# List Network Interfaces
echo "Scanning for available network interfaces..."
interfaces=$(ip -o link show | awk -F': ' '{print $2}')
echo "Available interfaces:"
select interface in $interfaces; do
    [ -n "$interface" ] && break
    echo "Invalid selection. Please try again."
done

# Configure Network Interface
echo "Configuring network interface $interface..."
ethtool -s $interface speed 10000 duplex full autoneg on

# Tune Network Stack
echo "Tuning network stack..."

# Backup sysctl.conf
echo "Backing up /etc/sysctl.conf to /etc/sysctl.conf.bak..."
cp /etc/sysctl.conf /etc/sysctl.conf.bak

# Modify sysctl settings
cat <<EOF >> /etc/sysctl.conf
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.core.rmem_default=33554432
net.core.wmem_default=33554432
net.core.netdev_max_backlog=250000
net.ipv4.tcp_rmem=4096 87380 67108864
net.ipv4.tcp_wmem=4096 65536 67108864
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_timestamps=1
EOF

# Apply sysctl settings
sysctl -p

# Check for Network Card Updates
echo "Please check your network card drivers and firmware are up to date for optimal performance."

# Completion Message
echo "Network optimization for 10 Gbit/s completed. Please review settings and test the network performance."

# Exit the script
exit 0
