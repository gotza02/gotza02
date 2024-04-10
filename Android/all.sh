#!/system/bin/sh

cmd notification post -S bigtext -t 'notification' 'Tag' '🚀 Installing maximum performance tweak for Android 13 & MIUI 14. Please wait & enjoy!! 🎉' > /dev/null 2>&1
echo ""
echo ""
echo "███╗   ███╗ █████╗ ██╗  ██╗    ██████╗ ███████╗██████╗ ███████╗"
echo "████╗ ████║██╔══██╗╚██╗██╔╝    ██╔══██╗██╔════╝██╔══██╗██╔════╝"
echo "██╔████╔██║███████║ ╚███╔╝     ██████╔╝█████╗  ██████╔╝█████╗  "
echo "██║╚██╔╝██║██╔══██║ ██╔██╗     ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  "
echo "██║ ╚═╝ ██║██║  ██║██╔╝ ██╗    ██║     ███████╗██║  ██║██║     "
echo "╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     "
sleep 2
echo ""
echo " __  __               _                           _     "
echo "|  \/  |   __ _    __| |   ___     _ __     ___  | | __ "
echo "| |\/| |  / _\` |  / _\` |  / _ \   | '_ \   / _ \ | |/ / "
echo "| |  | | | (_| | | (_| | | (_) |  | |_) | |  __/ |   <  "
echo "|_|  |_|  \__,_|  \__,_|  \___/   | .__/   \___| |_|\_\ "
echo "                                  |_|                   "
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
cmd notification post -S bigtext -t 'notification' 'Tag' '📱 Device information displayed' > /dev/null 2>&1

setprop debug.composition.type c2d
setprop debug.egl.force_context_shared true
setprop debug.egl.force_msaa false
setprop debug.egl.hw 1
setprop debug.egl.profiler 1
setprop debug.enable.gldebug 1
setprop debug.hwui.filter_cache_size 2048
setprop debug.hwui.use_buffer_age false
setprop debug.overlayui.enable 0
setprop debug.overlayui.enable_ime_p 0  
setprop debug.overlayui.min_duration_ms 0
setprop debug.overlayui.showFPSOverlay 1
setprop debug.overlayui.transparency 0
setprop debug.performance.tuning 1
setprop renderthread.skia.reduceopstasksplitting 1
setprop debug.hwui.renderer skiagl 
setprop debug.gr.swapinterval -1
setprop debug.hwui.disabledither false
setprop debug.disable.hwacc 0
setprop debug.javafx.animation.fullspeed true
setprop debug.rs.default-CPU-driver 1
setprop debug.MB.inner.running 36  
setprop debug.MB.running 144
setprop debug.hwui.render_dirty_regions false
setprop debug.hwc.bq_count 4
setprop debug.MB.running 1
setprop debug.low_power 0
setprop debug.low_power_sticky 0
setprop debug.heat_suppression 0
setprop debug.egl.force_fxaa false
setprop debug.egl.force_taa false
setprop debug.egl.force_ssaa false
setprop debug.egl.force_smaa false
setprop debug.egl.swapinterval 0
setprop debug.mdpcomp.mixedmode.disable false
setprop debug.forceAutoTextureCompression 2

cmd notification post -S bigtext -t 'notification' 'Tag' '⚙️ System properties tweaked' > /dev/null 2>&1
 
setprop debug.hwui.use_buffer_flinger true
setprop debug.hwui.vsync true
setprop debug.hwui.map_image_as_rect false
setprop debug.hwui.use_partial_updates true
setprop debug.hwui.disable_draw_defer true
setprop debug.hwui.disable_threaded_hinting false
setprop debug.hwui.use_gpu_pixel_buffers true
setprop debug.hwui.cache_size_kb 20480

cmd notification post -S bigtext -t 'notification' 'Tag' '🖌️ HWUI properties optimized' > /dev/null 2>&1

setprop debug.sf.disable_client_composition_cache 1
setprop debug.sf.disable_triple_buffer 1
setprop debug.sf.enable_gl_backpressure 1
setprop debug.sf.enable_hwc_vds 1
setprop debug.sf.enable_transaction_tracing 1
setprop debug.sf.latch_unsignaled 1
setprop debug.sf.predict_hwc_composition_strategy 1
setprop debug.sf.recomputecrop 1
setprop debug.sf.treat_170m_as_sRGB 1
setprop debug.cpurend.vsync 0
setprop debug.gpurend.vsync false 
setprop debug.choreographer.skipwarning 16666666
setprop debug.egl.buffcount 6
setprop debug.dev.ssrm.turbo true
setprop debug.enabletr true
setprop debug.rs.default-CPU-buffer 131072
setprop debug.fb.rgb565 1
setprop debug.disable.computedata true
setprop debug.lldb-rpc-server 0
setprop debug.qctwa.preservebuf 1
setprop debug.app.performance_restricted false
setprop debug.mdlogger.Running 0
setprop debug.power.profile high_performance
setprop debug.performance.tuning 2
setprop debug.cpuprio 8
setprop debug.gpuprio 8
setprop debug.ioprio 8  
setprop debug.performance_schema 2
setprop debug.performance_schema_max_memory_classes 512
setprop debug.gpu.scheduler_pre.emption 2
setprop debug.stagefright.c2inputsurface -1
setprop debug.stagefright.ccodec 6
setprop debug.stagefright.omx_default_rank 1024
setprop debug.performance_schema_max_socket_classes 16
setprop debug.sdm.disable_skip_validate 1
setprop debug.egl.native_scaling true
setprop debug.multicore.processing 2
setprop debug.hwui.target_cpu_time_percent 150
setprop debug.hwui.target_gpu_time_percent 150
setprop debug.OVRManager.cpuLevel 2
setprop debug.OVRManager.gpuLevel 2
setprop debug.gralloc.gfx_ubwc_disable false   
setprop debug.mdpcomp.mixedmode false
setprop debug.hwc.fbsize XRESxYRES
setprop debug.sdm.support_writeback 2
setprop debug.power_management_mode pref_max
setprop debug.sf.set_idle_timer_ms 10
setprop debug.sf.disable_backpressure 1
setprop debug.sf.early_phase_offset_ns 250000
setprop debug.sf.early_app_phase_offset_ns 250000
setprop debug.sf.early_gl_phase_offset_ns 1500000
setprop debug.sf.early_gl_app_phase_offset_ns 7500000
setprop debug.sf.high_fps_early_phase_offset_ns 3050000
setprop debug.sf.high_fps_late_sf_phase_offset_ns 4000000
setprop debug.sf.high_fps_early_gl_phase_offset_ns 4500000
setprop debug.sf.high_fps_late_app_phase_offset_ns 500000
setprop debug.sf.phase_offset_threshold_for_next_vsync_ns 3050000
setprop debug.sf.showupdates 0
setprop debug.sf.showcpu 0
setprop debug.sf.showbackground 0
setprop debug.sf.showfps 0
setprop debug.sf.hw 1

cmd notification post -S bigtext -t 'notification' 'Tag' '🏎️ CPU properties optimized' > /dev/null 2>&1

setprop ro.sys.fw.bservice_age 5000 
setprop ro.sys.fw.bservice_enable true
setprop ro.sys.fw.bservice_limit 10
setprop ro.vendor.qti.am.reschedule_service true
setprop ro.vendor.qti.sys.fw.bg_apps_limit 128
setprop ro.vendor.qti.sys.fw.bservice_age 5000
setprop ro.vendor.qti.sys.fw.bservice_enable true
setprop ro.vendor.qti.sys.fw.bservice_limit 10

cmd notification post -S bigtext -t 'notification' 'Tag' '🧠 Memory management improved' > /dev/null 2>&1

setprop debug.atrace.tags.enableflags 0
setprop debug.mdpcomp.logs 0
setprop debug.sf.disable_backpressure 1
setprop persist.vendor.verbose_logging_enabled 0
setprop profiler.debugmonitor false  
setprop profiler.force_disable_err_rpt false
setprop profiler.force_disable_ulog false
setprop profiler.hung.dumpdobugreport false

cmd notification post -S bigtext -t 'notification' 'Tag' '🔇 Disabled unneeded debugging' > /dev/null 2>&1

setprop ro.vendor.perf-hal.cfg.path /vendor/etc/perf/perfboostsconfig.xml
setprop ro.vendor.perf.scroll_opt 1

echo "Setting system properties..."
sleep 0.5

settings put global ram_expand_size 8192000
settings put global hardwareAccelerated true 
settings put global storage_preload 2
settings put global thread_priority urgent
settings put global foreground_mem_priority high
settings put global battery_tip_constans app_restriction_enabled false
settings put global adb_enabled 0
settings put global package_verifier_enable 0  

echo "Applying Global Settings..."
cmd notification post -S bigtext -t 'notification' 'Tag' '🌐 Global settings applied' > /dev/null 2>&1
sleep 1

settings put secure multi_press_timeout 120
settings put secure long_press_timeout 120

echo "Applying Secure Settings..."  
cmd notification post -S bigtext -t 'notification' 'Tag' '🔒 Secure settings applied' > /dev/null 2>&1
sleep 1

settings put system peak_refresh_rate 144
settings put system user_refresh_rate 144
settings put system pointer_speed 10
settings put system refresh_rate_mode 2
settings put system activity_manager_constants max_cached_processes 2048
settings put system fstrim_mandatory_interval 432000000
settings put system window_animation_scale 0
settings put system transition_animation_scale 0
settings put system animator_duration_scale 0

echo "Applying System Settings..."
cmd notification post -S bigtext -t 'notification' 'Tag' '⚙️ System settings optimized' > /dev/null 2>&1
sleep 1

cmd power set-fixed-performance-mode-enabled true
cmd power set-adaptive-power-saver-enabled false
cmd power reset-on-app-killed
cmd power set-thermal-policy 4
cmd power set-inactive-apps-kill-timeout 5000
cmd power enable-timer-migration
cmd activity kill-all
cmd thermalservice override-status 0

echo "Applying Cmd Settings..."
cmd notification post -S bigtext -t 'notification' 'Tag' '⚡ Power & thermal settings optimized' > /dev/null 2>&1  
sleep 1

cmd package bg-dexopt-job
cmd package compile --compile-layouts -a
cmd package compile -r -a
cmd package compile -s -a
cmd package compile -m everything -f -a

cmd notification post -S bigtext -t 'notification' 'Tag' '🚀 Packages optimized via JIT compilation' > /dev/null 2>&1

pm trim-caches 4096M
echo 3 > /proc/sys/vm/drop_caches

cmd notification post -S bigtext -t 'notification' 'Tag' '🧹 Trimmed caches aggressively' > /dev/null 2>&1

for app in $(cmd package list packages -3 | cut -f 2 -d ":"); do
  if [[ "$app" != "flar2.exkernelmanager" ]]; then  
    cmd activity force-stop "$app"
    cmd activity kill "$app"
    am kill all
  fi  
done

sleep 1
echo ""
echo "🎉 Maximum performance tweaks for Android 13 & MIUI 14 successfully installed! [✓]"
echo ""
echo ""
echo "🚀 Your device is now optimized for peak performance on the latest OS!"
echo "🔥 Experience the speed and smoothness like never before!"  
echo ""
cmd notification post -S bigtext -t 'notification' 'Tag' '✅ Max performance tweaks installed successfully!' > /dev/null 2>&1
sleep 1

echo ""
echo "   __|  |  |  __|   __|  __|   __|    | "
echo " \__ \  |  | ((     _|  \__ \   _| "
echo " ____/ \__/ \___| \___| ___| ____/   _) "
echo ""

cmd notification post -S bigtext -t 'notification' 'Tag' '🚀 Maximum performance tweak for Android 13 & MIUI 14 installed successfully. Enjoy!! 🎉' > /dev/null 2>&1
sleep 2  
echo "Done. Your device is now turbocharged for Android 13 & MIUI 14!"
