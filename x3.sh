+#!/system/bin/sh
# Poco X3 Pro MIUI 13.0.3 Android 12 Ultimate Optimizer

# System Cleanup
rm -rf /cache/*
rm -rf /data/dalvik-cache/*
rm -rf /data/tombstones/*
rm -rf /data/anr/*
rm -rf /data/system/dropbox/*
rm -rf /data/system/usagestats/*
rm -rf /data/log/*
rm -rf /data/media/0/MIUI/debug_log/*

# Fstrim
fstrim -v /cache
fstrim -v /data
fstrim -v /system

# CPU Optimization
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
do
    echo "performance" > $cpu
done
echo "0" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
echo "99" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
echo "2300000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "300000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

# GPU Optimization
echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "650000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
echo "180000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling

# RAM Optimization
echo "0" > /proc/sys/vm/swappiness
echo "100" > /proc/sys/vm/vfs_cache_pressure
echo "10" > /proc/sys/vm/dirty_background_ratio
echo "20" > /proc/sys/vm/dirty_ratio
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "1" > /proc/sys/vm/overcommit_memory
echo "100" > /proc/sys/vm/overcommit_ratio

# Internet and Network Optimization
echo "2" > /proc/sys/net/ipv4/tcp_syncookies
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse
echo "1" > /proc/sys/net/ipv4/tcp_sack
echo "1" > /proc/sys/net/ipv4/tcp_fack
echo "1" > /proc/sys/net/ipv4/tcp_fastopen
echo "3" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1" > /proc/sys/net/ipv4/tcp_low_latency
echo "1" > /proc/sys/net/ipv4/tcp_mtu_probing
echo "1" > /proc/sys/net/ipv4/tcp_timestamps
setprop net.tcp.buffersize.default 4096,87380,704512,4096,16384,110208
setprop net.tcp.buffersize.wifi 262144,524288,1048576,262144,524288,1048576
setprop net.tcp.buffersize.lte 262144,524288,3145728,262144,524288,3145728
setprop net.ipv4.tcp_ecn 0
setprop net.ipv4.route.flush 1

# I/O Optimization for Speed
for block in /sys/block/*/queue
do
    echo "noop" > $block/scheduler
    echo "0" > $block/rotational
    echo "2048" > $block/read_ahead_kb
    echo "0" > $block/add_random
    echo "0" > $block/iostats
done

# Kernel Parameter Optimization
echo "100000" > /proc/sys/kernel/sched_latency_ns
echo "500000" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "5000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "1" > /proc/sys/kernel/sched_autogroup_enabled
echo "0" > /proc/sys/kernel/random/read_wakeup_threshold
echo "0" > /proc/sys/kernel/random/write_wakeup_threshold

# Dalvik VM Optimization
setprop dalvik.vm.heapstartsize 16m
setprop dalvik.vm.heapgrowthlimit 256m
setprop dalvik.vm.heapsize 512m
setprop dalvik.vm.heaptargetutilization 0.75
setprop dalvik.vm.heapminfree 2m
setprop dalvik.vm.heapmaxfree 8m
setprop dalvik.vm.execution-mode int:jit
setprop dalvik.vm.dex2oat-filter everything

# zRAM Setup
swapoff /dev/block/zram0
echo "1" > /sys/block/zram0/reset
echo "2G" > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0

# Enable Dynamic Fsync
echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active

echo "Poco X3 Pro ultimate optimization complete!"
