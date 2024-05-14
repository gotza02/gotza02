#!/bin/bash

# Color Definitions
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
NC='\e[0m'

# Clear screen
clear

# Export IP Address Information
IP=$(curl -sS icanhazip.com)

# Banner
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Welcome To B-Liv TUNNELING SCRIPT ${YELLOW}(${NC}${Green} Stable Edition ${NC}${YELLOW})${NC}"
echo -e "  This Will Quickly Setup VPN Server On Your Server"
echo -e "  Author: ${Green}B-Liv TUNNELING ® ${NC}${YELLOW}(${NC} ${Green} YANG NYOLONG YATIM ${NC}${YELLOW})${NC}"
echo -e "  © Recode By Myself B-Liv TUNNELING ${YELLOW}(${NC} 2023 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 2

# Checking Architecture
if [[ $(uname -m) == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported (${Green}$(uname -m)${NC})"
else
    echo -e "${ERROR} Your Architecture Is Not Supported (${YELLOW}$(uname -m)${NC})"
    exit 1
fi

# Checking OS
OS=$(cat /etc/os-release | grep -w ID | head -n1 | cut -d= -f2 | tr -d '"')
PRETTY_NAME=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | cut -d= -f2 | tr -d '"')
if [[ $OS == "ubuntu" || $OS == "debian" ]]; then
    echo -e "${OK} Your OS Is Supported (${Green}$PRETTY_NAME${NC})"
else
    echo -e "${ERROR} Your OS Is Not Supported (${YELLOW}$PRETTY_NAME${NC})"
    exit 1
fi

# IP Address Validation
if [[ -z $IP ]]; then
    echo -e "${ERROR} IP Address (${YELLOW}Not Detected${NC})"
else
    echo -e "${OK} IP Address (${Green}$IP${NC})"
fi

echo ""
read -p "$(echo -e "Press ${GRAY}[${NC}${Green}Enter${NC}${GRAY}]${NC} to Start Installation") "
echo ""
clear

# Ensure script is run as root
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi

# Disable IPv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# Function to display messages
print_ok() { echo -e "${OK} ${BLUE} $1 ${FONT}"; }
print_install() { echo -e "${Green}===============================${FONT}\n${YELLOW} # $1 ${FONT}\n${Green}===============================${FONT}"; sleep 1; }
print_error() { echo -e "${ERROR} ${RED} $1 ${FONT}"; }
print_success() {
    if [[ $? -eq 0 ]]; then
        echo -e "${Green}===============================${FONT}\n${Green} # $1 berhasil dipasang\n${Green}===============================${FONT}"
        sleep 2
    fi
}

# Ensure root user
if [ "$UID" -ne 0 ]; then
    print_error "The current user is not the root user, please switch to the root user and run the script again"
    exit 1
fi

# Create xray directory
print_install "Creating xray directory"
mkdir -p /etc/xray /var/log/xray /var/lib/kyt
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain /var/log/xray/access.log /var/log/xray/error.log
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
print_success "Directory Xray"

# Set timezone and install dependencies
timedatectl set-timezone Asia/Jakarta
apt update -y
apt install -y ruby lolcat wondershaper zip pwgen openssl netcat socat cron bash-completion figlet software-properties-common
print_success "Dependencies installed"

# Setup OS specific dependencies
if [[ $OS == "ubuntu" ]]; then
    add-apt-repository ppa:vbernat/haproxy-2.0 -y
    apt-get -y install haproxy=2.0.*
elif [[ $OS == "debian" ]]; then
    curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
    echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net buster-backports-1.8 main >/etc/apt/sources.list.d/haproxy.list
    apt-get update
    apt-get -y install haproxy=1.8.*
fi
print_success "HAProxy installed"

# Install Nginx
print_install "Installing Nginx"
apt-get install -y nginx
print_success "Nginx installed"

# Create swap file
print_install "Creating 1G swap file"
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
print_success "Swap file created"

# Install and configure SSL
print_install "Installing SSL"
domain=$(cat /root/domain)
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
/root/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key
print_success "SSL installed"

# Install Xray
print_install "Installing Xray"
latest_version=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
print_success "Xray installed"

# Configure Nginx and HAProxy
print_install "Configuring Nginx and HAProxy"
wget -O /etc/haproxy/haproxy.cfg "${REPO}config/haproxy.cfg"
wget -O /etc/nginx/conf.d/xray.conf "${REPO}config/xray.conf"
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
cat /etc/xray/xray.crt /etc/xray/xray.key > /etc/haproxy/hap.pem
print_success "Nginx and HAProxy configured"

# Install and configure other services
print_install "Installing other services"
apt install -y fail2ban vnstat openvpn rclone
wget -O /etc/pam.d/common-password "${REPO}files/password"
chmod +x /etc/pam.d/common-password
wget -O /etc/ssh/sshd_config "${REPO}files/sshd"
chmod 700 /etc/ssh/sshd_config
systemctl restart ssh

wget -O /etc/default/dropbear "${REPO}config/dropbear.conf"
chmod +x /etc/default/dropbear
/etc/init.d/dropbear restart

wget -O /etc/vnstat.conf "${REPO}files/vnstat.conf"
chmod +x /etc/vnstat.conf
systemctl restart vnstat

wget ${REPO}files/openvpn
chmod +x openvpn
./openvpn
systemctl restart openvpn

wget -O /usr/local/bin/block.sh https://raw.githubusercontent.com/gotza02/v1/main/block.sh
chmod +x /usr/local/bin/block.sh
cat > /etc/systemd/system/block.service <<EOL
[Unit]
Description=Block IP Script
After=network.target

[Service]
ExecStart=/usr/local/bin/block.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOL
systemctl daemon-reload
systemctl enable block.service
systemctl start block.service
print_success "Services installed"

# Setup cron jobs
print_install "Setting up cron jobs"
cat > /etc/cron.d/xp_all <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
END

cat > /etc/cron.d/logclean <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/20 * * * * root /usr/local/sbin/clearlog
END

cat > /etc/cron.d/daily_reboot <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END

cat > /etc/cron.d/limit_ip <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/local/sbin/limit-ip
END

cat > /etc/cron.d/limit_ip2 <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/limit-ip
END

echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
service cron restart
print_success "Cron jobs set up"

# Install service monitor
print_install "Installing service monitor"
cat > /etc/systemd/system/service_monitor.service <<EOL
[Unit]
Description=Service Monitor
After=network.target

[Service]
ExecStart=/usr/local/bin/service_monitor.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

cat > /usr/local/bin/service_monitor.sh <<'EOL'
#!/bin/bash
check_and_restart_service() {
  service_name=$1
  service_status=$(systemctl is-active "$service_name")

  if [ "$service_status" = "active" ]; then
    echo "$(date): $service_name is running"
  else
    echo "$(date): $service_name is not running, restarting..."
    sudo systemctl restart "$service_name"
    sleep 5
    
    service_status=$(systemctl is-active "$service_name")
    if [ "$service_status" = "active" ]; then
      echo "$(date): $service_name has been restarted and is now running"
    else
      echo "$(date): $service_name failed to restart"
    fi
  fi
}

while true; do
  check_and_restart_service haproxy
  check_and_restart_service nginx
  check_and_restart_service xray
  sleep 30
done
EOL

chmod +x /usr/local/bin/service_monitor.sh
systemctl daemon-reload
systemctl enable service_monitor.service
systemctl start service_monitor.service
print_success "Service monitor installed"

# Restart all services
print_install "Restarting all services"
systemctl restart nginx
systemctl restart openvpn
systemctl restart ssh
systemctl restart dropbear
systemctl restart fail2ban
systemctl restart vnstat
systemctl restart haproxy
systemctl restart cron
systemctl restart netfilter-persistent
systemctl restart xray
systemctl restart rc-local
systemctl restart ws
print_success "All services restarted"

# Install menu
print_install "Installing menu"
wget ${REPO}menu/menu.zip
unzip menu.zip
chmod +x menu/*
mv menu/* /usr/local/sbin
rm -rf menu menu.zip
print_success "Menu installed"

# Set up user profile
print_install "Setting up user profile"
cat > /root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
menu
EOF
mkdir -p /root/.info
curl -sS "ipinfo.io/org?token=7a814b6263b02c" > /root/.info/.isp
curl -sS "ipinfo.io/city?token=7a814b6263b02c" > /root/.info/.city
print_success "User profile set up"

# Final cleanup
print_install "Cleaning up"
history -c
rm -rf /root/menu /root/*.zip /root/*.sh /root/LICENSE /root/README.md /root/domain
print_success "Cleanup done"

# Display installation time
secs_to_human "$(($(date +%s) - ${start}))"
echo -e "${Green}Script successfully installed${NC}"

# Set hostname
sudo hostnamectl set-hostname $username

# Final reboot prompt
read -p "$(echo -e "Press ${YELLOW}[${NC}${YELLOW}Enter${NC}${YELLOW}]${NC} to reboot") "
reboot
 
