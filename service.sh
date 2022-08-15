modpath="/data/adb/modules/GT_STABLE/"
chmod 777 "${modpath}"
chmod 777 "${modpath}system"
chmod 777 "${modpath}system/bin"
# Wait to boot be completed
until [[ "$(getprop sys.boot_completed)" -eq "1" ]] || [[ "$(getprop dev.bootcomplete)" -eq "1" ]]; do
	sleep 5
done

wget -qO "${modpath}system/bin/trimcache" "https://raw.githubusercontent.com/gotza02/gotza02/main/trimcache"
wget -qO "${modpath}system/bin/tweakgt" "https://raw.githubusercontent.com/gotza02/gotza02/main/gtoptimze"
wget -qO "${modpath}system/bin/updategt" "https://raw.githubusercontent.com/gotza02/gotza02/main/update"
wget -qO "${modpath}system.prop" "https://raw.githubusercontent.com/gotza02/gotza02/main/system.prop"
wget -qO "${modpath}module.prop" "https://raw.githubusercontent.com/gotza02/gotza02/main/version"
wget -qO "${modpath}system/bin/optimize" "https://raw.githubusercontent.com/gotza02/gotza02/main/OPTIMIZE.sh"
wget -qO "${modpath}service.sh" "https://raw.githubusercontent.com/gotza02/gotza02/main/service.sh"
chmod 777 "${modpath}"
chmod 777 "${modpath}system"
chmod 777 "${modpath}system/bin"
chmod 777 "${modpath}system/bin/updategt"
chmod 777 "${modpath}system/bin/trimcache"
chmod 777 "${modpath}system/bin/tweakgt"
rm -rf "/sdcard/GT LOG"
sleep 30
modpath="/data/adb/modules/GT_STABLE/"
sh "${modpath}system/bin/trimcache"
sh "${modpath}system/bin/tweakgt"
sh "${modpath}system/bin/updategt"
rm -rf "${modpath}/system/bin/*"
swapoff /dev/block/vnswap0
swapoff /dev/block/zram0
swapoff /dev/block/vbswap0
echo "1" > /sys/block/vnswap0/reset
echo "8589934592" > /sys/block/vnswap0/disksize
echo "8192M" > /sys/block/vnswap0/mem_limit
echo "8" > /sys/block/vnswap0/max_comp_streams
mkswap /dev/block/vnswap0
swapon /dev/block/vnswap0 -p 32758
echo "100" > /proc/sys/vm/swappiness
echo "15" > /proc/sys/vm/dirty_background_ratio
echo "200" > /proc/sys/vm/vfs_cache_pressure
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo '3' > /proc/sys/vm/drop_caches
echo '0' > /proc/sys/vm/oom_kill_allocating_task
echo "256,10240,32000,34000,36000,38000" > /sys/module/lowmemorykiller/parameters/minfree
cat /sys/module/lowmemorykiller/parameters/minfree

# Add ZRAM FOR ZRAM0

echo "1" > /sys/block/zram0/reset
echo "8589934592" > /sys/block/zram0/disksize
echo "8192M" > /sys/block/zram0/mem_limit
echo "8" > /sys/block/zram0/max_comp_streams
mkswap /dev/block/zram0
swapon /dev/block/zram0 -p 32758
echo "100" > /proc/sys/vm/swappiness
echo "15" > /proc/sys/vm/dirty_background_ratio
echo "200" > /proc/sys/vm/vfs_cache_pressure
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo '3' > /proc/sys/vm/drop_caches
echo '0' > /proc/sys/vm/oom_kill_allocating_task
echo "256,10240,32000,34000,36000,38000" > /sys/module/lowmemorykiller/parameters/minfree
cat /sys/module/lowmemorykiller/parameters/minfree
#NetSpeed

echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
echo "1" > /proc/sys/net/ipv4/tcp_sack;
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes;
echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl;
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout;
echo "404480" > /proc/sys/net/core/wmem_max;
echo "404480" > /proc/sys/net/core/rmem_max;
echo "256960" > /proc/sys/net/core/rmem_default;
echo "256960" > /proc/sys/net/core/wmem_default;
echo "4096,16384,404480" > /proc/sys/net/ipv4/tcp_wmem;
echo "4096,87380,404480" > /proc/sys/net/ipv4/tcp_rmem; 


# Add ZRAM FOR VBSWAP

echo "1" > /sys/block/vbswap0/reset
echo "8589934592" > /sys/block/vbswap0/disksize
echo "8192M" > /sys/block/vbswap0/mem_limit
echo "8" > /sys/block/vbswap0/max_comp_streams
mkswap /dev/block/vbswap0
swapon /dev/block/vbswap0 -p 32758
echo "100" > /proc/sys/vm/swappiness
echo "15" > /proc/sys/vm/dirty_background_ratio
echo "200" > /proc/sys/vm/vfs_cache_pressure
echo "3000" > /proc/sys/vm/dirty_writeback_centisecs
echo '3' > /proc/sys/vm/drop_caches
echo '0' > /proc/sys/vm/oom_kill_allocating_task
echo "256,10240,32000,34000,36000,38000" > /sys/module/lowmemorykiller/parameters/minfree
cat /sys/module/lowmemorykiller/parameters/minfree
swapon /dev/block/vnswap0 -p 32758
swapon /dev/block/zram0 -p 32758
swapon /dev/block/vbswap0 -p 32758
