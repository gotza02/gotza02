#!/system/bin/sh

settings put system speed_mode 1
settings put system thermal_limit_refresh_rate 144
settings put secure speed_mode_enable 1
settings put global sem_enhanced_cpu_responsiveness 1
settings put global game_driver_all_apps 1
settings put global GPUTURBO_SWITCH 1
settings put global GPUTUNER_SWITCH 1
settings put global ro.config.hw_fast_dormancy 0,0
settings put global fstrim_mandatory_interval 1
settings put system power_mode high
settings put global zram_enabled 1
settings put global windowsmgr.max_events_per_sec 1000
settings put global window_animation_scale 0
settings put global transition_animation_scale 0
settings put global animator_duration_scale 0
settings put global speed_mode_on 1
settings put global restricted_device_performance 0,0
settings put global private_dns_specifier dns.quad9.net
settings put system peak_refresh_rate 144
settings put system min_refresh_rate 144
settings put system user_refresh_rate 144
settings put secure support_highfps 1
settings put global cached_apps_freezer enabled
settings put global app_standby_enabled 1
settings put global adaptive_battery_management_enabled 0
settings put secure long_press_timeout 250
settings put secure multi_press_timeout 250
settings put global app_restriction_enabled true
settings put system intelligent_sleep_mode 0
settings put secure adaptive_sleep 0
settings put global ram_expand_size_list 0,1,2,4,6,8,12,16