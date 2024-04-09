#!/bin/bash

# Display a notification about script completion
cmd notification post -S bigtext -t 'notification' 'Tag' '🚀 Installing maximum performance tweak for Android 13 & MIUI 14. Please wait & enjoy!! 🎉' > /dev/null 2>&1
echo ""
echo ""

# Display header
echo "███╗   ███╗ █████╗ ██╗  ██╗    ██████╗ ███████╗██████╗ ███████╗"
echo "████╗ ████║██╔══██╗╚██╗██╔╝    ██╔══██╗██╔════╝██╔══██╗██╔════╝"
echo "██╔████╔██║███████║ ╚███╔╝     ██████╔╝█████╗  ██████╔╝█████╗  "
echo "██║╚██╔╝██║██╔══██║ ██╔██╗     ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  "
echo "██║ ╚═╝ ██║██║  ██║██╔╝ ██╗    ██║     ███████╗██║  ██║██║     "
echo "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     "
sleep 2
echo "
 __  __               _                           _     
|  \/  |   __ _    __| |   ___     _ __     ___  | | __ 
| |\/| |  / _\` |  / _\` |  / _ \   | '_ \   / _ \ | |/ / 
| |  | | | (_| | | (_| | | (_) |  | |_) | |  __/ |   <  
|_|  |_|  \__,_|  \__,_|  \___/   | .__/   \___| |_|\_\ 
                                  |_|                   
"

# Display device information
echo ""
echo "🔍📱 Device Information"
echo "-----------------------"
echo "• Baseband Version  ➜ $(getprop gsm.version.baseband)"
echo "• Kernel            ➜ $(uname -r)"
echo "• Android SDK       ➜ $(getprop ro.build.version.sdk)"
echo "• Android Version   ➜ $(getprop ro.build.version.release)"
echo "• MIUI Version      ➜ $(getprop ro.miui.ui.version.name)"
echo "• Device Model      ➜ $(getprop ro.product.model)"
echo "• Brand             ➜ $(getprop ro.product.brand)"
echo "• Model             ➜ $(getprop ro.product.model)"
echo "• Product           ➜ $(getprop ro.build.product)"
echo "• Hardware          ➜ $(getprop ro.hardware)"
echo "• GPU               ➜ $(getprop ro.gfx.driver.0)"
echo "• CPU               ➜ $(getprop ro.product.cpu.abi)"
echo "• Build             ➜ $(getprop ro.build.description)"
echo ""
echo "⚠️ Important: Use at your own risk!"
echo ""

# Function to set system properties
set_props() {
  local properties=(
    # gpu tweaks
    "debug.composition.type c2d"
    "debug.egl.force_context_shared true"
    "debug.egl.force_msaa false"
    "debug.egl.hw 1"
    "debug.egl.profiler 1" 
    "debug.enable.gldebug 1"
    "debug.hwui.filter_cache_size 2048"
    "debug.hwui.use_buffer_age false"
    "debug.overlayui.enable 0"
    "debug.overlayui.enable_ime_p 0"
    "debug.overlayui.min_duration_ms 0"
    "debug.overlayui.showFPSOverlay 1"
    "debug.overlayui.transparency 0"
    "debug.performance.tuning 1"
    "renderthread.skia.reduceopstasksplitting 1"
    "debug.hwui.renderer skiagl"
    "debug.gr.swapinterval -1"
    "debug.hwui.disabledither false"
    "debug.disable.hwacc 0"
    "debug.javafx.animation.fullspeed true"
    "debug.rs.default-CPU-driver 1"
    "debug.MB.inner.running 36"
    "debug.MB.running 144"
    "debug.hwui.render_dirty_regions false"
    "debug.hwc.bq_count 4"
    "debug.MB.running 1"
    "debug.low_power 0"
    "debug.low_power_sticky 0"
    "debug.heat_suppression 0"
    "debug.egl.force_fxaa false"
    "debug.egl.force_taa false"
    "debug.egl.force_ssaa false"
    "debug.egl.force_smaa false"
    "debug.egl.swapinterval 0"
    "debug.mdpcomp.mixedmode.disable false"
    "debug.forceAutoTextureCompression 2"

    # hwui tweaks
    "debug.hwui.use_buffer_flinger true"
    "debug.hwui.vsync true"
    "debug.hwui.map_image_as_rect false"
    "debug.hwui.use_partial_updates true"
    "debug.hwui.disable_draw_defer true"
    "debug.hwui.disable_threaded_hinting false"
    "debug.hwui.use_gpu_pixel_buffers true"
    "debug.hwui.cache_size_kb 20480"

    # cpu tweaks  
    "debug.sf.disable_client_composition_cache 1"
    "debug.sf.disable_triple_buffer 1"
    "debug.sf.enable_gl_backpressure 1"
    "debug.sf.enable_hwc_vds 1"
    "debug.sf.enable_transaction_tracing 1"
    "debug.sf.latch_unsignaled 1"
    "debug.sf.predict_hwc_composition_strategy 1" 
    "debug.sf.recomputecrop 1"
    "debug.sf.treat_170m_as_sRGB 1"
    "debug.cpurend.vsync 0"
    "debug.gpurend.vsync false"
    "debug.choreographer.skipwarning 16666666"
    "debug.egl.buffcount 6"
    "debug.dev.ssrm.turbo true"
    "debug.enabletr true"
    "debug.rs.default-CPU-buffer 131072"
    "debug.fb.rgb565 1"
    "debug.disable.computedata true"
    "debug.lldb-rpc-server 0"
    "debug.qctwa.preservebuf 1"
    "debug.app.performance_restricted false"
    "debug.mdlogger.Running 0"
    "debug.power.profile high_performance"
    "debug.performance.tuning 2"
    "debug.cpuprio 8"
    "debug.gpuprio 8"
    "debug.ioprio 8"
    "debug.performance_schema 2"
    "debug.performance_schema_max_memory_classes 512"
    "debug.gpu.scheduler_pre.emption 2"
    "debug.stagefright.c2inputsurface -1"
    "debug.stagefright.ccodec 6"
    "debug.stagefright.omx_default_rank 1024"
    "debug.performance_schema_max_socket_classes 16"
    "debug.sdm.disable_skip_validate 1"
    "debug.egl.native_scaling true"
    "debug.multicore.processing 2"
    "debug.hwui.target_cpu_time_percent 150"
    "debug.hwui.target_gpu_time_percent 150" 
    "debug.OVRManager.cpuLevel 2"
    "debug.OVRManager.gpuLevel 2"
    "debug.gralloc.gfx_ubwc_disable false"
    "debug.mdpcomp.mixedmode false"
    "debug.hwc.fbsize XRESxYRES"
    "debug.sdm.support_writeback 2"
    "debug.power_management_mode pref_max"
    "debug.sf.set_idle_timer_ms 10"
    "debug.sf.disable_backpressure 1"
    "debug.sf.early_phase_offset_ns 250000"
    "debug.sf.early_app_phase_offset_ns 250000"
    "debug.sf.early_gl_phase_offset_ns 1500000"
    "debug.sf.early_gl_app_phase_offset_ns 7500000"
    "debug.sf.high_fps_early_phase_offset_ns 3050000"
    "debug.sf.high_fps_late_sf_phase_offset_ns 4000000"
    "debug.sf.high_fps_early_gl_phase_offset_ns 4500000"
    "debug.sf.high_fps_late_app_phase_offset_ns 500000"
    "debug.sf.phase_offset_threshold_for_next_vsync_ns 3050000"
    "debug.sf.showupdates 0"
    "debug.sf.showcpu 0"
    "debug.sf.showbackground 0"
    "debug.sf.showfps 0"
    "debug.sf.hw 1"

    # memory tweaks
    "ro.sys.fw.bservice_age 5000"
    "ro.sys.fw.bservice_enable true"
    "ro.sys.fw.bservice_limit 10"
    "ro.vendor.qti.am.reschedule_service true"
    "ro.vendor.qti.sys.fw.bg_apps_limit 128"
    "ro.vendor.qti.sys.fw.bservice_age 5000"
    "ro.vendor.qti.sys.fw.bservice_enable true"
    "ro.vendor.qti.sys.fw.bservice_limit 10"

    # disable unneeded debugging
    "debug.atrace.tags.enableflags 0"
    "debug.mdpcomp.logs 0"
    "debug.sf.disable_backpressure 1"
    "persist.vendor.verbose_logging_enabled 0"
    "profiler.debugmonitor false"
    "profiler.force_disable_err_rpt false"
    "profiler.force_disable_ulog false"
    "profiler.hung.dumpdobugreport false"

    # misc tweaks
    "ro.vendor.perf-hal.cfg.path /vendor/etc/perf/perfboostsconfig.xml"
    "ro.vendor.perf.scroll_opt 1"
  )

  local success_count=0
  local failure_count=0

  for command in "${properties[@]}"; do
    if setprop $command >/dev/null 2>&1; then
      success_count=$((success_count + 1))
    else
      failure_count=$((failure_count + 1)) 
      failed_commands+=("$command")
    fi  
  done

  echo "Setting system properties..."
  sleep 0.5
  
  echo "• Total commands applied successfully: $success_count"
  echo "• Total commands failed to apply: $failure_count"
  echo "" 
}

# Main script starts here

# Global settings
settings_and_cmd() {
  local global_settings=(
    "ram_expand_size 8192000"  
    "hardwareAccelerated true"
    "storage_preload 2"
    "thread_priority urgent" 
    "foreground_mem_priority high"
    "battery_tip_constans app_restriction_enabled false"
    "adb_enabled 0" 
    "package_verifier_enable 0"
  )
  
  local success_count=0
  local failure_count=0

  for command in "${global_settings[@]}"; do
    if settings put global $command >/dev/null 2>&1; then
      success_count=$((success_count + 1))
    else
      failure_count=$((failure_count + 1))
      failed_commands+=("$command")  
    fi
  done

  echo "Applying Global Settings..."
  sleep 1
  
  echo "• Total commands applied successfully: $success_count"
  echo "• Total commands failed to apply: $failure_count"
  echo "" 
  
  # Secure settings
  local secure_settings=(
    "multi_press_timeout 120"  
    "long_press_timeout 120"
  )

  success_count=0
  failure_count=0

  for command in "${secure_settings[@]}"; do  
    if settings put secure $command >/dev/null 2>&1; then
      success_count=$((success_count + 1))
    else 
      failure_count=$((failure_count + 1))
      failed_commands+=("$command")
    fi
  done

  echo "Applying Secure Settings..."
  sleep 1

  echo "• Total commands applied successfully: $success_count" 
  echo "• Total commands failed to apply: $failure_count"
  echo ""

  # System settings
  local system_settings=(
    "peak_refresh_rate 144"
    "user_refresh_rate 144"
    "pointer_speed 10" 
    "refresh_rate_mode 2"
    "activity_manager_constants max_cached_processes 2048" 
    "fstrim_mandatory_interval 432000000"
    "window_animation_scale 0"
    "transition_animation_scale 0"
    "animator_duration_scale 0"   
  )
  
  success_count=0
  failure_count=0
  
  for command in "${system_settings[@]}"; do
    if settings put system $command >/dev/null 2>&1; then 
      success_count=$((success_count + 1))
    else
      failure_count=$((failure_count + 1))
      failed_commands+=("$command")
    fi
  done
  
  echo "Applying System Settings..."
  sleep 1
  
  echo "• Total commands applied successfully: $success_count"
  echo "• Total commands failed to apply: $failure_count"
  echo ""

  # Cmd settings
  local cmd_settings=(
    "power set-fixed-performance-mode-enabled true"
    "power set-adaptive-power-saver-enabled false"   
    "power reset-on-app-killed"
    "power set-thermal-policy 4"
    "power set-inactive-apps-kill-timeout 5000" 
    "power enable-timer-migration"
    "activity kill-all" 
    "thermalservice override-status 0"
  )
  
  success_count=0
  failure_count=0
  
  for command in "${cmd_settings[@]}"; do
    if cmd $command >/dev/null 2>&1; then
      success_count=$((success_count + 1))
    else
      failure_count=$((failure_count + 1))
      failed_commands+=("$command")
    fi
  done
  
  echo "Applying Cmd Settings..."
  sleep 1
  
  echo "• Total commands applied successfully: $success_count"
  echo "• Total commands failed to apply: $failure_count"
  echo ""
}

#JIT compile
jit_compile() {
  cmd package compile -m everything -f -a
}

# Aggressive cache trim
trim_cache() {
  pm trim-caches 4096M
  echo 3 > /proc/sys/vm/drop_caches
}

# RAM killer
ram_killer() {
  for app in $(cmd package list packages -3 | cut -f 2 -d ":"); do
    if [[ "$app" != "flar2.exkernelmanager" ]]; then 
      cmd activity force-stop "$app"
      cmd activity kill "$app"
      am kill all
    fi
  done
}

# Main script execution
set_props
settings_and_cmd
jit_compile
trim_cache
ram_killer

sleep 1   
echo ""
echo "🎉 Maximum performance tweaks for Android 13 & MIUI 14 successfully installed! [✓]"
echo ""  
echo ""
echo "🚀 Your device is now optimized for peak performance on the latest OS!"
echo "🔥 Experience the speed and smoothness like never before!"  
echo "" 
sleep 1

echo ""
echo "   __|  |  |  __|   __|  __|   __|    | "
echo " \__ \  |  | (     (     _|  \__ \   _| "   
echo " ____/ \__/ \___| \___| ___| ____/   _) "                     
echo ""

cmd notification post -S bigtext -t 'notification' 'Tag' '🚀 Maximum performance tweak for Android 13 & MIUI 14 installed successfully. Enjoy!! 🎉' > /dev/null 2>&1
sleep 2
echo "Done. Your device is now turbocharged for Android 13 & MIUI 14!"
