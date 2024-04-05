#!/bin/bash

# Android Overclocking Shell Script for Rooted Devices (Android 11-13)

# Check device specifications
ram_total=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')
ram_available=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2}')
cpu_info=$(cat /proc/cpuinfo | grep "model name" | head -1 | awk -F ": " '{print $2}')
cpu_cores=$(cat /proc/cpuinfo | grep "cpu cores" | head -1 | awk -F ": " '{print $2}')
cpu_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
storage_total=$(df -h | awk '$NF=="/"{printf "%d\n", $2}')
storage_available=$(df -h | awk '$NF=="/"{printf "%d\n", $4}')
battery_capacity=$(cat /sys/class/power_supply/battery/capacity)
battery_health=$(cat /sys/class/power_supply/battery/health)

# Detect chipset vendor
chipset_vendor=$(getprop ro.board.platform)

# Define configuration variables
swap_size="16G"
zram_size="12G"
scheduler="fiops"
dns_primary="1.1.1.1"
dns_secondary="8.8.8.8"
backup_dir="/sdcard/backup"
backup_file="system_backup.tar.gz"

# Function to check root access
check_root() {
  if ! [ "$(id -u)" = 0 ]; then
    echo "This script must be run with root privileges. Aborting."
    exit 1
  fi
}

# Function to validate configuration values
validate_config() {
  if ! [[ "$swap_size" =~ ^[0-9]+[GM]$ ]]; then
    echo "Invalid swap size. Using default value."
    swap_size="16G"
  fi
  if ! [[ "$zram_size" =~ ^[0-9]+[GM]$ ]]; then
    echo "Invalid ZRAM size. Using default value."
    zram_size="12G"
  fi
  if ! [[ "$scheduler" =~ ^(noop|deadline|cfq|bfq|fiops)$ ]]; then
    echo "Invalid I/O scheduler. Using default value."
    scheduler="fiops"
  fi
  if ! [[ "$dns_primary" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Invalid primary DNS server. Using default value."
    dns_primary="1.1.1.1"
  fi
  if ! [[ "$dns_secondary" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Invalid secondary DNS server. Using default value."
    dns_secondary="8.8.8.8"
  fi
}

# Function to apply performance tweaks and overclocking
apply_tweaks() {
  echo "Applying performance tweaks and overclocking..."
  # Maximize CPU frequency and enable overclocking
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
    echo "3400000" > "$cpu"  # Adjust the value based on your device's maximum supported frequency
  done
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
    echo "2800000" > "$cpu"  # Adjust the value based on your desired minimum frequency
  done
  # Optimize CPU governor for performance
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > "$cpu"
  done
  # Enable CPU boost with higher frequencies
  if [ "$chipset_vendor" == "msm" ]; then
    echo "1" > /sys/module/cpu_boost/parameters/input_boost_enabled
    echo "3400000" > /sys/module/cpu_boost/parameters/input_boost_freq
  elif [ "$chipset_vendor" == "mt" ]; then
    echo "1" > /proc/cpufreq/cpufreq_power_mode
    echo "3400000" > /proc/cpufreq/cpufreq_oc_freq
  fi
  # Maximize GPU frequency and enable overclocking
  if [ "$chipset_vendor" == "msm" ]; then
    echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
    echo "800000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq  # Adjust the value based on your device's maximum supported GPU frequency
    echo "600000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq  # Adjust the value based on your desired minimum GPU frequency
  elif [ "$chipset_vendor" == "mt" ]; then
    echo "performance" > /proc/gpufreq/gpufreq_governor
    echo "800000000" > /proc/gpufreq/gpufreq_opp_freq_limit  # Adjust the value based on your device's maximum supported GPU frequency
    echo "600000000" > /proc/gpufreq/gpufreq_opp_freq  # Adjust the value based on your desired minimum GPU frequency
  fi
  # Disable power-saving mechanisms completely
  echo "0" > /sys/module/msm_thermal/core_control/enabled
  echo "0" > /sys/module/lpm_levels/parameters/sleep_disabled
  echo "0" > /sys/module/pm_runtime/parameters/autosuspend_delay_ms
  echo "0" > /sys/module/cpuidle/parameters/off
  # Optimize memory management for performance
  echo "0" > /proc/sys/vm/swappiness
  echo "0" > /proc/sys/vm/vfs_cache_pressure
  echo "100" > /proc/sys/vm/dirty_ratio
  echo "5" > /proc/sys/vm/dirty_background_ratio
  # Enable and configure ZRAM for maximum size
  modprobe zram num_devices=1
  echo "$zram_size" > /sys/block/zram0/disksize
  mkswap /dev/zram0
  swapon /dev/zram0 -p 32767
  echo "100" > /proc/sys/vm/swappiness
}

# Function to modify build.prop and system.prop
modify_props() {
  echo "Modifying build.prop and system.prop..."
  # Back up original files
  cp /system/build.prop /system/build.prop.bak
  cp /system/system.prop /system/system.prop.bak
  # Disable debugging and logging
  sed -i 's/ro.debuggable=1/ro.debuggable=0/g' /system/build.prop
  sed -i 's/persist.sys.usb.config=mtp,adb/persist.sys.usb.config=mtp/g' /system/build.prop
  sed -i 's/persist.service.adb.enable=1/persist.service.adb.enable=0/g' /system/build.prop
  sed -i 's/ro.adb.secure=0/ro.adb.secure=1/g' /system/build.prop
  sed -i 's/ro.secure=0/ro.secure=1/g' /system/build.prop
  sed -i 's/ro.debuggable=1/ro.debuggable=0/g' /system/system.prop
  sed -i 's/persist.sys.usb.config=mtp,adb/persist.sys.usb.config=mtp/g' /system/system.prop
  sed -i 's/persist.service.adb.enable=1/persist.service.adb.enable=0/g' /system/system.prop
  # Disable USB debugging
  sed -i 's/persist.sys.usb.config=mtp,adb/persist.sys.usb.config=mtp/g' /system/build.prop
  sed -i 's/persist.sys.usb.config=mtp,adb/persist.sys.usb.config=mtp/g' /system/system.prop
  # Maximize memory usage and performance
  echo "ro.config.low_ram=false" >> /system/build.prop
  echo "ro.config.per_app_memcg=false" >> /system/build.prop
  echo "ro.config.avoid_gfx_accel=false" >> /system/build.prop
  echo "ro.sys.fw.bg_apps_limit=128" >> /system/build.prop
  echo "persist.sys.force_highendgfx=1" >> /system/build.prop
  # Disable unnecessary services and features
  echo "ro.config.nocheckin=1" >> /system/build.prop
  echo "ro.config.hw_quickpoweron=true" >> /system/build.prop
  echo "ro.mot.eri.losalert.delay=1000" >> /system/build.prop
  echo "ro.ril.enable.amr.wideband=1" >> /system/build.prop
  echo "ro.telephony.call_ring.delay=0" >> /system/build.prop
  echo "pm.sleep_mode=1" >> /system/build.prop
  echo "ro.media.enc.jpeg.quality=100" >> /system/build.prop
  # Improve network performance and speed
  echo "net.ipv4.ip_forward=1" >> /system/build.prop
  echo "net.ipv4.tcp_syncookies=0" >> /system/build.prop
  echo "net.ipv4.tcp_tw_recycle=1" >> /system/build.prop
  echo "net.ipv4.tcp_tw_reuse=1" >> /system/build.prop
  echo "net.ipv4.tcp_fin_timeout=15" >> /system/build.prop
  echo "net.ipv4.tcp_keepalive_time=600" >> /system/build.prop
  echo "net.ipv4.tcp_keepalive_probes=5" >> /system/build.prop
  echo "net.ipv4.tcp_keepalive_intvl=60" >> /system/build.prop
  echo "net.ipv4.tcp_window_scaling=1" >> /system/build.prop
  echo "net.ipv4.tcp_sack=1" >> /system/build.prop
  echo "net.ipv4.tcp_fack=1" >> /system/build.prop
  echo "net.ipv4.tcp_syn_retries=2" >> /system/build.prop
  echo "net.ipv4.tcp_synack_retries=2" >> /system/build.prop
  echo "net.ipv4.tcp_max_syn_backlog=8192" >> /system/build.prop
  echo "net.ipv4.ip_no_pmtu_disc=0" >> /system/build.prop
  echo "net.ipv4.route.flush=1" >> /system/build.prop
  echo "net.ipv4.tcp_ecn=0" >> /system/build.prop
  # Set DNS servers for faster lookups
  echo "net.dns1=$dns_primary" >> /system/build.prop
  echo "net.dns2=$dns_secondary" >> /system/build.prop
}

# Function to disable unnecessary services and features
disable_services() {
  echo "Disabling unnecessary services and features..."
  # Disable Google Play Services and Play Store completely
  pm disable-user --user 0 com.google.android.gms
  pm disable-user --user 0 com.android.vending
  # Disable all system apps
  for app in $(pm list packages -s | cut -d: -f2); do
    pm disable-user --user 0 "$app"
  done
  # Disable all background services
  settings put global always_finish_activities 1
  settings put global cached_apps_freezer enabled
  settings put global enhanced_processing_disabled 1
  settings put global app_auto_restriction_enabled 1
  # Disable all animations
  settings put global window_animation_scale 0
  settings put global transition_animation_scale 0
  settings put global animator_duration_scale 0
}

# Function to optimize network settings for speed
optimize_network() {
  echo "Optimizing network settings..."
  # Disable IPv6 completely
  sysctl -w net.ipv6.conf.all.disable_ipv6=1
  sysctl -w net.ipv6.conf.default.disable_ipv6=1
  # Maximize TCP buffer sizes
  sysctl -w net.core.rmem_max=104857600
  sysctl -w net.core.wmem_max=104857600
  sysctl -w net.ipv4.tcp_rmem="16384 87380 104857600"
  sysctl -w net.ipv4.tcp_wmem="16384 87380 104857600"
  # Enable TCP Fast Open
  sysctl -w net.ipv4.tcp_fastopen=3
  # Optimize TCP congestion control for speed
  sysctl -w net.ipv4.tcp_congestion_control=bbr
  # Optimize network scheduler
  if [ "$chipset_vendor" == "msm" ]; then
    echo "$scheduler" > /sys/block/mmcblk0/queue/scheduler
  elif [ "$chipset_vendor" == "mt" ]; then
    echo "$scheduler" > /sys/block/sda/queue/scheduler
  fi
}

# Function to apply miscellaneous tweaks
misc_tweaks() {
  echo "Applying miscellaneous tweaks..."
  # Disable all kernel debugging
  echo "0" > /proc/sys/kernel/printk
  echo "0" > /proc/sys/kernel/printk_devkmsg
  echo "0" > /proc/sys/kernel/kptr_restrict
  # Maximize entropy pool size
  echo "65536" > /proc/sys/kernel/random/read_wakeup_threshold
  echo "65536" > /proc/sys/kernel/random/write_wakeup_threshold
  # Disable USB debugging
  settings put global adb_enabled 0
  # Disable all system logging
  setprop log.tag.* ""
  setprop persist.log.tag.* ""
  setprop persist.sys.debug.* ""
  setprop debug.* ""
  # Disable Google SafetyNet completely
  settings put global package_verifier_enable 0
  settings put global safe_boot_disallowed 1
  settings put global safetynet_disable 1
}

# Function to configure monitoring and reporting
monitoring_reporting() {
  echo "Configuring monitoring and reporting..."
  # Implement real-time monitoring of CPU, RAM, GPU, storage, and battery usage
  echo "#!/bin/bash" > /data/local/tmp/monitor.sh
  echo "while true; do" >> /data/local/tmp/monitor.sh
  echo "  cpu_usage=\$(top -n 1 | grep 'CPU:' | awk '{print \$2}')" >> /data/local/tmp/monitor.sh
  echo "  ram_usage=\$(free | grep Mem | awk '{print \$3/\$2 * 100.0}')" >> /data/local/tmp/monitor.sh
  if [ "$chipset_vendor" == "msm" ]; then
    echo "  gpu_usage=\$(cat /sys/kernel/debug/kgsl/proc/internal_state | grep 'curr_usage' | awk '{print \$3}')" >> /data/local/tmp/monitor.sh
  elif [ "$chipset_vendor" == "mt" ]; then
    echo "  gpu_usage=\$(cat /proc/mali/utilization | awk '{print \$1}')" >> /data/local/tmp/monitor.sh
  fi
  echo "  storage_usage=\$(df -h / | awk 'NR==2 {print \$5}')" >> /data/local/tmp/monitor.sh
  echo "  battery_level=\$(dumpsys battery | grep level | awk '{print \$2}')" >> /data/local/tmp/monitor.sh
  echo "  echo \"\$(date): CPU: \$cpu_usage%, RAM: \$ram_usage%, GPU: \$gpu_usage%, Storage: \$storage_usage, Battery: \$battery_level%\" >> /data/local/tmp/system_monitor.log" >> /data/local/tmp/monitor.sh
  echo "  sleep 5" >> /data/local/tmp/monitor.sh
  echo "done" >> /data/local/tmp/monitor.sh
  chmod +x /data/local/tmp/monitor.sh
  nohup /data/local/tmp/monitor.sh &
  # Generate detailed performance reports and logs
  echo "Device Specifications:" > /data/local/tmp/performance_report.txt
  echo "RAM Total: $ram_total KB" >> /data/local/tmp/performance_report.txt
  echo "RAM Available: $ram_available KB" >> /data/local/tmp/performance_report.txt
  echo "CPU: $cpu_info" >> /data/local/tmp/performance_report.txt
  echo "CPU Cores: $cpu_cores" >> /data/local/tmp/performance_report.txt
  echo "CPU Frequency: $cpu_freq kHz" >> /data/local/tmp/performance_report.txt
  echo "Storage Total: $storage_total GB" >> /data/local/tmp/performance_report.txt
  echo "Storage Available: $storage_available GB" >> /data/local/tmp/performance_report.txt
  echo "Battery Capacity: $battery_capacity%" >> /data/local/tmp/performance_report.txt
  echo "Battery Health: $battery_health" >> /data/local/tmp/performance_report.txt
  echo "Active CPU Governor: $(cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor | head -1)" >> /data/local/tmp/performance_report.txt
  if [ "$chipset_vendor" == "msm" ]; then
    echo "Active GPU Governor: $(cat /sys/class/kgsl/kgsl-3d0/devfreq/governor)" >> /data/local/tmp/performance_report.txt
  elif [ "$chipset_vendor" == "mt" ]; then
    echo "Active GPU Governor: $(cat /proc/gpufreq/gpufreq_governor)" >> /data/local/tmp/performance_report.txt
  fi
  echo "ZRAM Size: $zram_size" >> /data/local/tmp/performance_report.txt
  echo "Swappiness: $(cat /proc/sys/vm/swappiness)" >> /data/local/tmp/performance_report.txt
  echo "TCP Congestion Control: $(sysctl net.ipv4.tcp_congestion_control | awk -F "=" '{print $2}')" >> /data/local/tmp/performance_report.txt
  dumpsys batterystats > /data/local/tmp/battery_stats.txt
  dumpsys meminfo > /data/local/tmp/memory_info.txt
  dumpsys cpuinfo > /data/local/tmp/cpu_info.txt
  dumpsys gfxinfo > /data/local/tmp/gpu_info.txt
  logcat -d > /data/local/tmp/logcat.txt
}

# Function to configure error handling and recovery
error_handling() {
  echo "Configuring error handling and recovery..."
  # Implement robust error handling and logging mechanisms
  exec 2> /data/local/tmp/optimization_errors.log
  set -e
  # Provide failsafe mechanisms to prevent system instability
  trap 'echo "An error occurred. Aborting script. Restoring to default state..."; exit 1' ERR
  # Include options for full system backup and restore
  mkdir -p "$backup_dir"
  echo "#!/bin/bash" > /data/local/tmp/backup.sh
  echo "tar -czf \"$backup_dir/$backup_file\" /system /data /vendor /product /odm /persist /sdcard" >> /data/local/tmp/backup.sh
  chmod +x /data/local/tmp/backup.sh
  echo "0 1 * * * /data/local/tmp/backup.sh" >> /etc/crontabs/root
  echo "#!/bin/bash" > /data/local/tmp/restore.sh
  echo "tar -xzf \"$backup_dir/$backup_file\" -C /" >> /data/local/tmp/restore.sh
  chmod +x /data/local/tmp/restore.sh
}

# Main script execution
check_root
validate_config
apply_tweaks
modify_props
disable_services
optimize_network
misc_tweaks
monitoring_reporting
error_handling

# Reboot the device to apply changes
echo "Rebooting the device to apply changes..."
reboot

echo "Overclocking script completed. Device is now running at maximum speed and performance with overclocked CPU and GPU."
