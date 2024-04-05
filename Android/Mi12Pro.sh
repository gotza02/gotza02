#!/bin/bash

# Check if the device is Xiaomi 12 Pro
device_model=$(adb shell getprop ro.product.model)
if [ "$device_model" != "12 Pro" ]; then
    echo "This script is intended for Xiaomi 12 Pro only."
    exit 1
fi

# Disable unnecessary packages
packages=(
    "com.android.providers.partnerbookmarks"
    "com.android.bookmarkprovider"
    "com.android.printspooler"
    "com.miui.analytics"
    "com.miui.bugreport"
    "com.miui.cloudbackup"
    "com.miui.cloudservice"
    "com.miui.daemon"
    "com.miui.hybrid"
    "com.miui.powerkeeper"
    "com.miui.msa.global"
    "com.miui.yellowpage"
    "com.xiaomi.glgm"
    "com.xiaomi.payment"
    "com.xiaomi.simactivate.service"
)

for package in "${packages[@]}"; do
    adb shell pm disable-user --user 0 "$package" > /dev/null 2>&1
done

# Enable high performance mode
adb shell settings put global low_power 0
adb shell settings put global stay_on_while_plugged_in 3

# Disable automatic brightness and set it to a high value
adb shell settings put system screen_brightness_mode 0
adb shell settings put system screen_brightness 255

# Disable window animation scale
adb shell settings put global window_animation_scale 0.5

# Disable transition animation scale
adb shell settings put global transition_animation_scale 0.5

# Disable animator duration scale
adb shell settings put global animator_duration_scale 0.5

# Disable background processes limit
adb shell settings put global always_finish_activities 1

# Set high performance GPU rendering
adb shell settings put global gpu_debug_app "*"
adb shell settings put global gpu_debug_layers "SwapBuffersPerf,GpuPerf,GpuMemTotal,FrameCapture"

# Set MIUI optimization settings
adb shell settings put global miui_optimization 0
adb shell settings put system miui_home_double_tap_to_lock 0
adb shell settings put system miui_home_icon_size -2
adb shell settings put system miui_home_icon_text_size -2

# Enable ZRAM for better memory management
adb shell "echo 1 > /sys/block/zram0/reset"
adb shell "echo lz4 > /sys/block/zram0/comp_algorithm"
adb shell "echo 3G > /sys/block/zram0/disksize"
adb shell "mkswap /dev/block/zram0"
adb shell "swapon /dev/block/zram0"

# Check device information
echo "Device Information:"
adb shell getprop ro.product.manufacturer
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell getprop ro.miui.ui.version.name

echo "Performance optimization script completed."
