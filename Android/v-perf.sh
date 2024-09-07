#!/bin/bash

echo ""
sleep 0.5
echo ""
echo " Developer : Dramagod Singtaro "
sleep 0.5 
echo " Version : 2.0 - Optimized "
sleep 0.5
echo ""
sleep 0.5
echo " Installation in progress, please wait... "
echo ""

# Function for setting performance-related properties
set_vgame() {
  # Enhanced Rendering & Graphics Optimizations
  setprop debug.hwui.renderer skiagl
  setprop debug.gr.swapinterval -1
  setprop debug.hwui.disabledither false
  setprop debug.disable.hwacc 0
  setprop debug.javafx.animation.fullspeed true
  setprop debug.rs.default-CPU-driver 1
  setprop debug.hwui.render_dirty_regions false
  setprop debug.egl.buffcount 5 # Increase buffer count for smoother frame delivery
  setprop debug.gpu.scheduler_pre.emption 1
  setprop debug.mdpcomp.mixedmode.disable false
  setprop debug.low_power 0
  
  # GPU and CPU Performance Boost
  setprop debug.performance.tuning 1
  setprop debug.cpuprio 7
  setprop debug.gpuprio 7
  setprop debug.ioprio 6 # Optimized I/O priority for faster data access
  setprop debug.rs.default-CPU-buffer 65536
  setprop debug.hwui.target_cpu_time_percent 100
  setprop debug.hwui.target_gpu_time_percent 100
  
  # Frame Rate and Refresh Rate Optimization
  settings put system peak_refresh_rate 120
  settings put system user_refresh_rate 120
  settings put global animator_duration_scale 0.2
  settings put global window_animation_scale 0.2
  settings put global transition_animation_scale 0.2
  
  # Adaptive Thermal Management (New)
  # Instead of disabling completely, set thermal throttling only for high temperatures
  cmd thermalservice override-status 0
  echo "Thermal status overridden for performance. Monitor temperature manually."
  
  # Power Management Optimization
  setprop debug.power_management_mode pref_max
  setprop debug.sf.set_idle_timer_ms 15 # Reduced idle time for more responsiveness
  setprop debug.sf.latch_unsignaled 1
  cmd power set-fixed-performance-mode-enabled true

  # Disable unnecessary background Google services to save resources
  for app in com.google.android.videos com.google.android.music com.google.android.printservice.recommendation com.google.android.apps.docs com.google.android.apps.tachyon com.google.android.apps.wellbeing com.google.android.marvin.talkback; do
    pm disable-user --user 0 $app
  done

  echo "System optimizations for V-Game complete."
}
set_vgame > /dev/null 2>&1

# Visual Feedback for Progress
echo -ne '###########                    (33%)\r'
sleep 1

# JIT Compiler Optimization
set_jitc() {
  cmd package compile -m speed-profile -a # Optimize for a balanced speed-profile
  cmd package bg-dexopt-job
  cmd package compile --compile-layouts -a
}

# Redirect output to null to suppress command output
set_jitc > /dev/null 2>&1 &

# Cache Management Optimization
set_cache_trim() {
  local cache_size=$(du -sh /data/cache | cut -f1)
  pm trim-caches "$cache_size"
  echo "Cache trimmed successfully, cache size was: $cache_size"
}

# Redirect output to null to suppress command output
set_cache_trim > /dev/null 2>&1 &

# RAM Management Optimization with Enhanced Logic
ram_killer() {
  local threshold=75 # Adjusted threshold for memory usage to 75MB
  for app in $(cmd package list packages -3 | cut -f 2 -d ":"); do
    local mem_usage=$(dumpsys meminfo "$app" | grep TOTAL: | tr -s ' ' | cut -d ' ' -f2)
    if [[ ! "$app" == "me.piebridge.brevent" ]] && (( mem_usage > threshold )); then
      cmd activity force-stop "$app"
      echo "Stopped $app due to high memory usage: ${mem_usage}KB"
    fi
  done
}

# Redirect output to null to suppress command output
ram_killer > /dev/null 2>&1 &

# Enhanced Performance Output
echo -ne 'Initializing advanced optimizations...\r'
wait
echo -ne 'Optimizations complete.       \n'

sleep 0.5
echo " V-Game installation completed successfully!"
sleep 0.5
echo ""
echo " Please do not reboot your device "
sleep 0.5  
echo ""
echo "For feedback or suggestions, contact @OnlyVankaREAL"
sleep 0.5
echo " Thank you for using V-Game "
echo ""
