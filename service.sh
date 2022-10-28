modpath="/data/adb/modules/GT_STABLE/"

chmod 777 "${modpath}"
chmod 777 "${modpath}system"
chmod 777 "${modpath}system/bin"
# Wait to boot be completed
until [[ "$(getprop sys.boot_completed)" -eq "1" ]] || [[ "$(getprop dev.bootcomplete)" -eq "1" ]]; do
	sleep 3
done

mkdir "${modpath}system/etc"
mkdir "${modpath}system/etc/.nth_fc​"


wget -qO "${modpath}system/bin/trimcache" "https://raw.githubusercontent.com/gotza02/gotza02/main/trimcache"
wget -qO "${modpath}system/bin/tweakgt" "https://raw.githubusercontent.com/gotza02/gotza02/main/gtoptimze"
wget -qO "${modpath}system/bin/updategt" "https://raw.githubusercontent.com/gotza02/gotza02/main/update"
wget -qO "${modpath}system.prop" "https://raw.githubusercontent.com/gotza02/gotza02/main/system.prop"
wget -qO "${modpath}module.prop" "https://raw.githubusercontent.com/gotza02/gotza02/main/version"
wget -qO "${modpath}system/bin/optimize" "https://raw.githubusercontent.com/gotza02/gotza02/main/OPTIMIZE.sh"
wget -qO "${modpath}service.sh" "https://raw.githubusercontent.com/gotza02/gotza02/main/service.sh"
wget -qO "${modpath}system/bin/gt_opt" "https://raw.githubusercontent.com/gotza02/gotza02/main/dex2oat_opt"
wget -qO "${modpath}system/bin/lm_opt" "https://raw.githubusercontent.com/gotza02/gotza02/main/lineman.sh"
wget -qO "${modpath}system/bin/GTSR" "https://raw.githubusercontent.com/gotza02/gotza02/main/super"
wget -qO "${modpath}system/etc/.nth_fc/.fc_main.sh" "https://raw.githubusercontent.com/gotza02/gotza02/main/fastcharge"

chmod 777 "${modpath}"
chmod 777 "${modpath}system"
chmod 777 "${modpath}system/bin"
chmod 777 "${modpath}system/bin/updategt"
chmod 777 "${modpath}system/bin/trimcache"
chmod 777 "${modpath}system/bin/tweakgt"
chmod 777 /data/adb/*/*/*/*/*

rm -rf "/sdcard/GT SQL"

sh /system/bin/updategt
sh /system/bin/GTSR
sh /system/bin/lm_opt
sh /system/bin/gt_opt
sh /system/bin/tweakgt
sh /system/bin/trimcache
sh /system/bin/optimize
wait_until_login() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done
  local test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true > "$test_file"
  while [[ ! -f "$test_file" ]]; do
    true > "$test_file"
    sleep 1
  done
  rm -f "$test_file"
}
wait_until_login
sleep 30
sh /system/etc/.nth_fc/.fc_main.sh
