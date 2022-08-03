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
wget -qO "${modpath}system/bin/gamimg" "https://raw.githubusercontent.com/gotza02/gotza02/main/gaming"
wget -qO "${modpath}service.sh" "https://raw.githubusercontent.com/gotza02/gotza02/main/service.sh"
chmod 777 "${modpath}"
chmod 777 "${modpath}system"
chmod 777 "${modpath}system/bin"
chmod 777 "${modpath}system/bin/updategt"
chmod 777 "${modpath}system/bin/trimcache"
chmod 777 "${modpath}system/bin/tweakgt"
sh "${modpath}system/bin/trimcache"
sh "${modpath}system/bin/tweakgt"
sh "${modpath}system/bin/updategt"
