echo ""
sleep 0.5
echo ""
echo " Developer : Dramagod Singtaro "
sleep 0.5 
echo " Version : 1.0 "
sleep 0.5
echo ""
sleep 0.5
echo " Installation in progress, please wait... "
echo ""

set_vgame() {
  setprop debug.hwui.renderer skiagl
  setprop debug.gr.swapinterval -1
  setprop debug.hwui.disabledither false
  setprop debug.disable.hwacc 0
  setprop debug.disable_sched_boost true
  setprop debug.javafx.animation.fullspeed true
  setprop debug.rs.default-CPU-driver 1
  setprop debug.MB.inner.running 24 
  setprop debug.MB.running 72
  setprop debug.hwui.render_dirty_regions false
  setprop debug.hwc.bq_count 3
  setprop debug.MB.running 1
  setprop debug.low_power 0
  setprop debug.low_power_sticky 0
  setprop debug.heat_suppression 0
  setprop debug.egl.force_msaa false
  setprop debug.egl.force_fxaa false 
  setprop debug.egl.force_taa false
  setprop debug.egl.force_ssaa false
  setprop debug.egl.force_smaa false
  setprop debug.egl.swapinterval 1
  setprop debug.mdpcomp.mixedmode.disable false
  setprop debug.forceAutoTextureCompression 1
  setprop debug.cpurend.vsync false
  setprop debug.gpurend.vsync false
  setprop debug.choreographer.skipwarning 12500000
  setprop debug.egl.buffcount 4
  setprop debug.dev.ssrm.turbo true
  setprop debug.enabletr true
  setprop debug.rs.default-CPU-buffer 65536
  setprop debug.fb.rgb565 1
  setprop debug.disable.computedata true
  setprop debug.lldb-rpc-server 0
  setprop debug.qctwa.preservebuf 1
  setprop debug.app.performance_restricted false
  setprop debug.mdlogger.Running 0
  setprop debug.power.profile high_performance
  setprop debug.performance.tuning 1
  setprop debug.cpuprio 7
  setprop debug.gpuprio 7
  setprop debug.ioprio 7
  setprop debug.performance_schema 1
  setprop debug.performance_schema_max_memory_classes 320
  setprop debug.gpu.scheduler_pre.emption 1
  setprop debug.stagefright.c2inputsurface -1
  setprop debug.stagefright.ccodec 4
  setprop debug.stagefright.omx_default_rank 512
  setprop debug.performance_schema_max_socket_classes 10
  setprop debug.sdm.disable_skip_validate 1
  setprop debug.egl.native_scaling true
  setprop debug.multicore.processing 1
  setprop debug.hwui.target_cpu_time_percent 100
  setprop debug.hwui.target_gpu_time_percent 100
  setprop debug.OVRManager.cpuLevel 1
  setprop debug.OVRManager.gpuLevel 1
  setprop debug.gralloc.gfx_ubwc_disable false
  setprop debug.mdpcomp.mixedmode false
  setprop debug.hwc.fbsize XRESxYRES
  setprop debug.sdm.support_writeback 1
  setprop debug.power_management_mode pref_max
  setprop debug.sf.set_idle_timer_ms 30
  setprop debug.sf.disable_backpressure 1
  setprop debug.sf.latch_unsignaled 1
  setprop debug.sf.enable_hwc_vds 1
  setprop debug.sf.early_phase_offset_ns 500000
  setprop debug.sf.early_app_phase_offset_ns 500000
  setprop debug.sf.early_gl_phase_offset_ns 3000000
  setprop debug.sf.early_gl_app_phase_offset_ns 15000000
  setprop debug.sf.high_fps_early_phase_offset_ns 6100000
  setprop debug.sf.high_fps_late_sf_phase_offset_ns 8000000
  setprop debug.sf.high_fps_early_gl_phase_offset_ns 9000000
  setprop debug.sf.high_fps_late_app_phase_offset_ns 1000000
  setprop debug.sf.high_fps_late_sf_phase_offset_ns 8000000
  setprop debug.sf.high_fps_early_gl_phase_offset_ns 9000000
  setprop debug.sf.phase_offset_threshold_for_next_vsync_ns 6100000
  setprop debug.sf.showupdates 0
  setprop debug.sf.showcpu 0
  setprop debug.sf.showbackground 0
  setprop debug.sf.showfps 0
  setprop debug.sf.hw 1
  settings put system peak_refresh_rate 120
  settings put system user_refresh_rate 120
  settings delete system thermal_limit_refresh_rate
  settings put system pointer_speed 7
  settings put secure refresh_rate_mode 2
  settings put global activity_manager_constants max_cached_processes 1024
  settings put global fstrim_mandatory_interval 864000000
  settings put global window_animation_scale 0.2
  settings put global transition_animation_scale 0.2
  settings put global animator_duration_scale 0.2
  cmd thermalservice override-status 0
  cmd power set-fixed-performance-mode-enabled true
  pm disable-user --user 0 com.google.android.videos
  pm disable-user --user 0 com.google.android.music
  pm disable-user --user 0 com.google.android.printservice.recommendation
  pm disable-user --user 0 com.google.android.apps.docs 
  pm disable-user --user 0 com.google.android.apps.tachyon
  pm disable-user --user 0 com.google.android.apps.wellbeing
  pm disable-user --user 0 com.google.android.marvin.talkback
  pm disable-user --user 0 com.google.android.printservice.recommendation
  pm disable-user --user 0 com.google.android.videos
}
set_vgame > /dev/null 2>&1
echo -ne '###########                    (33%)\r'
sleep 1

#JITGame 
set_jitc() {
  cmd package compile -m everything -a -f
  cmd package bg-dexopt-job
  cmd package compile --compile-layouts -a
}
set_jitc > /dev/null 2>&1
echo -ne '###############                (50%)\r'
sleep 1

#cachetrim
set_cache_trim() {  
  pm trim-caches 999G
}
set_cache_trim > /dev/null 2>&1
echo -ne '#######################        (66%)\r'
sleep 1

#RamKiller
{
  for app in $(cmd package list packages -3 | cut -f 2 -d ":"); do
    if [[ ! "$app" == "me.piebridge.brevent" ]]; then
      cmd activity force-stop "$app"
      cmd activity kill "$app" 
    fi
  done
} > /dev/null 2>&1
echo -ne '############################### (100%)\r'
echo -ne '\n'

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
