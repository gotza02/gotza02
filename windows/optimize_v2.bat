@echo off
setlocal EnableDelayedExpansion

rem Check OS version
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" (
set IS_WIN10=1
) else if "%version%" == "11.0" (
set IS_WIN11=1
) else (
set IS_WIN10=0
set IS_WIN11=0
)

rem Get system specs
call :check_ram
call :check_disk
call :check_cpu

cls

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO main_menu
) ELSE (
    echo This script requires administrator privileges. Please run as administrator.
    pause
    exit
)

rem Display main menu
:main_menu
cls
echo Windows System Optimization Script
echo ===================================
echo OS: Windows %version%
echo RAM: %ram% MB
echo Disk: %disksize% MB
echo CPU Cores: %cores%
echo.
echo Select an optimization category:
echo 1. System Performance
echo 2. Network And Internet
echo 3. User Interface And Personalization
echo 4. Privacy And Security
echo 5. Gaming And Multimedia
echo 6. Perform All Optimizations
echo 7. Undo Last Optimization
echo 8. Advanced Power Settings
echo 9. Software Management
echo 10. System Maintenance
echo 11. Exit
echo.
choice /c 12345678910 /m "Enter your choice: "
goto main_option%errorlevel%

:main_option1
call :system_performance_menu
goto main_menu

:main_option2
call :network_menu
goto main_menu

:main_option3
call :ui_personalization_menu
goto main_menu

:main_option4
call :privacy_security_menu
goto main_menu

:main_option5
call :gaming_multimedia_menu
goto main_menu

:main_option6
call :optimize_all
goto main_menu

:main_option7
call :undo_optimization
goto main_menu

:main_option8
call :advanced_power_menu
goto main_menu

:main_option9
call :software_management_menu
goto main_menu

:main_option10
call :system_maintenance_menu  
goto main_menu

:main_option11
echo Exiting script...
pause
exit /b

rem System Performance sub-menu
:system_performance_menu

cls

echo System Performance Optimizations
echo =================================
echo 1. Optimize Power Plan
echo 2. Optimize Page File
echo 3. Disable Unnecessary Services 
echo 4. Clean Up and Optimize Disk
echo 5. Disable Startup Apps
echo 6. Optimize SSD Settings
echo 7. Manage Startup Applications
echo 8. Windows Settings
echo 9. Disable Timeline
echo 10. Disable Background Apps
echo 11. Back to Main Menu
echo.

choice /c 1234567891011 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_power_plan
if %errorlevel% equ 2 call :optimize_pagefile
if %errorlevel% equ 3 call :disable_services 
if %errorlevel% equ 4 call :disk_cleanup
if %errorlevel% equ 5 call :disable_startup_apps
if %errorlevel% equ 6 call :optimize_ssd
if %errorlevel% equ 7 call :manage_startup_apps
if %errorlevel% equ 8 call :windows_settings
if %errorlevel% equ 9 call :disable_timeline
if %errorlevel% equ 10 call :disable_background_apps
if %errorlevel% equ 11 goto :main_menu

goto system_performance_menu

:windows_settings
cls
echo Windows Settings
echo =================================
echo 1. Enable/Disable Windows Update  
echo 2. Enable/Disable Windows Defender
echo 3. Enable/Disable Windows Firewall
echo 4. Customize Privacy Settings
echo 5. Back to Performance Menu 
echo.

choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 call :windows_update_settings
if %errorlevel% equ 2 call :windows_defender_settings
if %errorlevel% equ 3 call :windows_firewall_settings
if %errorlevel% equ 4 call :privacy_settings
if %errorlevel% equ 5 goto system_performance_menu

goto windows_settings

:windows_update_settings
cls
echo Windows Update Settings
echo ========================
echo 1. Enable Windows Update
echo 2. Disable Windows Update  
echo 3. Customize Update Settings
echo 4. Back

choice /c 1234 /m "Enter your choice: "
if %errorlevel% equ 1 (
    REM Enable Windows Update
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f
    echo Windows Update enabled.
) else if %errorlevel% equ 2 (
    REM Disable Windows Update
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f
    echo Windows Update disabled.  
) else if %errorlevel% equ 3 (
    start ms-settings:windowsupdate-options
) else (
    goto windows_settings
)
pause
goto windows_settings

:windows_defender_settings
cls
echo Windows Defender Settings
echo =========================
echo 1. Enable Windows Defender
echo 2. Disable Windows Defender
echo 3. Customize Defender Settings  
echo 4. Back

choice /c 1234 /m "Enter your choice: "

if %errorlevel% equ 1 (
    REM Enable Windows Defender
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /f
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /f
    echo Windows Defender enabled.
) else if %errorlevel% equ 2 (
    REM Disable Windows Defender
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 1 /f 
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f
    echo Windows Defender disabled.
) else if %errorlevel% equ 3 (
    start windowsdefender:
) else (
    goto windows_settings
)

pause
goto windows_settings

:windows_firewall_settings
cls  
echo Windows Firewall Settings
echo =========================
echo 1. Enable Windows Firewall
echo 2. Disable Windows Firewall
echo 3. Customize Firewall Settings
echo 4. Back

choice /c 1234 /m "Enter your choice: "
if %errorlevel% equ 1 (
    REM Enable Windows Firewall 
    NetSh Advfirewall set allprofiles state on
    echo Windows Firewall enabled.
) else if %errorlevel% equ 2 (
    REM Disable Windows Firewall
    NetSh Advfirewall set allprofiles state off
    echo Windows Firewall disabled.
) else if %errorlevel% equ 3 (
    start wf.msc
) else (
    goto windows_settings 
)
pause
goto windows_settings

:privacy_settings
cls
echo Customize Privacy Settings
echo ==========================
echo 1. Disable Telemetry and Data Collection
echo 2. Disable Location Services
echo 3. Disable Advertising ID
echo 4. Disable App Permissions
echo 5. Open Privacy Settings
echo 6. Back

choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    echo Telemetry and data collection disabled.
) else if %errorlevel% equ 2 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
    echo Location services disabled.
) else if %errorlevel% equ 3 (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f
    echo Advertising ID disabled.
) else if %errorlevel% equ 4 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore" /v Value /t REG_SZ /d Deny /f
    echo App permissions disabled.
) else if %errorlevel% equ 5 (
    start ms-settings:privacy
) else (
    goto windows_settings
)
pause
goto windows_settings

:manage_startup_apps
cls
echo Manage Startup Applications  
echo ===========================
echo 1. Enable/Disable Startup Applications
echo 2. Customize Startup Delay
echo 3. Back to System Performance Menu
echo.
choice /c 123 /m "Enter your choice: "

if %errorlevel% equ 1 call :startup_app_selection
if %errorlevel% equ 2 call :startup_delay_settings
if %errorlevel% equ 3 goto :eof

goto manage_startup_apps

:startup_delay_settings
cls
echo Customize Startup Delay
echo =======================
set /p startup_delay="Enter the desired startup delay in seconds (0 to disable): "

if "%startup_delay%" == "0" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
) else (
    set /a startup_delay_ms=%startup_delay%*1000
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d %startup_delay_ms% /f
)

echo Startup delay set to %startup_delay% seconds.
pause
goto manage_startup_apps

:startup_app_selection
cls
echo Select Startup Applications to Enable/Disable
echo ===============================================
echo Loading startup applications...
timeout 2 >nul
wmic startup get Caption, Command > startup_apps.tmp

type startup_apps.tmp
echo.
set /p app_choice="Enter application number(s) to toggle (e.g., 1,3,5) or 'a' to toggle all: "

if /i "%app_choice%"=="a" (
    for /f "tokens=2 delims=," %%a in (startup_apps.tmp) do (
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%a /t REG_SZ /d "%%#a" /f
    )
    echo All startup applications enabled.
) else (
    for /f "tokens=1,2 delims=," %%a in (startup_apps.tmp) do (
        if "!app_choice!,,"==",%%a,," (
            reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%b /f >nul
            echo %%b disabled.
        ) else (
            reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %%b /t REG_SZ /d "%%#b" /f >nul
            echo %%b enabled.
        )
    )
)

del startup_apps.tmp
pause
goto :eof

goto system_performance_menu

rem Network & Internet sub-menu
:network_menu
cls
echo Network ^& Internet Optimizations
echo =================================
echo 1. Optimize TCP Settings
echo 2. Optimize DNS Settings
echo 3. Flush DNS Cache
echo 4. Optimize Wi-Fi Settings
echo 5. Disable Autotuning
echo 6. Optimize Network Adapter Settings
echo 7. Enable Jumbo Frames
echo 8. Disable IPv6
echo 9. Optimize Proxy Settings  
echo 10. Back to Main Menu
echo.
choice /c 12345678910 /m "Enter your choice: "  

if %errorlevel% equ 1 call :optimize_tcp
if %errorlevel% equ 2 call :optimize_dns
if %errorlevel% equ 3 call :flush_dns_cache
if %errorlevel% equ 4 call :optimize_wifi
if %errorlevel% equ 5 call :disable_autotuning
if %errorlevel% equ 6 call :optimize_network_adapter
if %errorlevel% equ 7 call :enable_jumbo_frames  
if %errorlevel% equ 8 call :disable_ipv6
if %errorlevel% equ 9 call :optimize_proxy
if %errorlevel% equ 10 goto :eof

goto network_menu

rem User Interface & Personalization sub-menu
:ui_personalization_menu
cls

echo User Interface ^& Personalization Optimizations
echo ===============================================
echo 1. Disable Animations and Effects
echo 2. Customize Start Menu Layout
echo 3. Customize Taskbar Settings
echo 4. Customize File Explorer Options
echo 5. Enable Dark Mode
echo 6. Customize Mouse Settings  
echo 7. Customize Desktop Icons
echo 8. Disable Lock Screen
echo 9. Disable Action Center
echo 10. Restore Default Theme
echo 11. Back to Main Menu
echo.
choice /c 12345678910 /m "Enter your choice: "

if %errorlevel% equ 1 call :disable_effects
if %errorlevel% equ 2 call :customize_start_menu
if %errorlevel% equ 3 call :customize_taskbar
if %errorlevel% equ 4 call :customize_file_explorer
if %errorlevel% equ 5 call :enable_dark_mode  
if %errorlevel% equ 6 call :customize_mouse_settings
if %errorlevel% equ 7 call :customize_desktop_icons
if %errorlevel% equ 8 call :disable_lock_screen
if %errorlevel% equ 9 call :disable_action_center
if %errorlevel% equ 10 call :restore_default_theme
if %errorlevel% equ 11 goto :eof

goto ui_personalization_menu

:gaming_multimedia_menu
cls
echo Gaming ^& Multimedia Optimizations
echo ===================================
echo 1. Optimize Visual Effects for Performance
echo 2. Disable Game Bar and Game Mode
echo 3. Disable Fullscreen Optimizations
echo 4. Optimize Sound Settings
echo 5. Optimize GPU Settings
echo 6. Disable Mouse Acceleration
echo 7. Optimize Steam Settings
echo 8. Disable Xbox Game Bar
echo 9. Optimize Nvidia Settings
echo 10. Optimize AMD Settings
echo 11. Back to Main Menu
echo.  
choice /c 12345678910 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_visual_effects
if %errorlevel% equ 2 call :disable_game_bar
if %errorlevel% equ 3 call :disable_fullscreen_opt
if %errorlevel% equ 4 call :optimize_sound
if %errorlevel% equ 5 call :optimize_gpu_settings
if %errorlevel% equ 6 call :disable_mouse_acceleration
if %errorlevel% equ 7 call :optimize_steam_settings
if %errorlevel% equ 8 call :disable_xbox_game_bar
if %errorlevel% equ 9 call :optimize_nvidia_settings
if %errorlevel% equ 10 call :optimize_amd_settings
if %errorlevel% equ 11 goto :eof

goto gaming_multimedia_menu

:privacy_security_menu
cls
echo Privacy ^& Security Optimizations
echo =================================
echo 1. Disable Telemetry and Data Collection
echo 2. Harden System Security Settings
echo 3. Optimize User Account Control (UAC)  
echo 4. Enable Windows Firewall
echo 5. Disable Remote Access
echo 6. Disable Windows Defender
echo 7. Clear Windows Event Logs
echo 8. Disable Wi-Fi Sense
echo 9. Disable SmartScreen Filter
echo 10. Back to Main Menu
echo.
choice /c 12345678910 /m "Enter your choice: "

if %errorlevel% equ 1 call :disable_telemetry
if %errorlevel% equ 2 call :harden_security
if %errorlevel% equ 3 call :optimize_uac
if %errorlevel% equ 4 call :enable_windows_firewall
if %errorlevel% equ 5 call :disable_remote_access
if %errorlevel% equ 6 call :disable_windows_defender  
if %errorlevel% equ 7 call :clear_event_logs
if %errorlevel% equ 8 call :disable_wifi_sense
if %errorlevel% equ 9 call :disable_smartscreen
if %errorlevel% equ 10 goto :eof

goto privacy_security_menu

:advanced_power_menu
cls
echo Advanced Power Settings
echo =======================
echo 1. Customize Power Plan
echo 2. Disable Fast Startup
echo 3. Disable Hibernation
echo 4. Optimize Battery Settings
echo 5. Optimize Processor Power Management
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :customize_power_plan
if %errorlevel% equ 2 call :disable_fast_startup
if %errorlevel% equ 3 call :disable_hibernation
if %errorlevel% equ 4 call :optimize_battery_settings
if %errorlevel% equ 5 call :optimize_processor_power
if %errorlevel% equ 6 goto :eof

goto advanced_power_menu

:software_management_menu
cls
echo Software Management
echo ===================
echo 1. Uninstall Unnecessary Apps
echo 2. Disable OneDrive
echo 3. Disable Cortana
echo 4. Disable Windows Media Player
echo 5. Disable Internet Explorer
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :uninstall_apps
if %errorlevel% equ 2 call :disable_onedrive
if %errorlevel% equ 3 call :disable_cortana
if %errorlevel% equ 4 call :disable_media_player
if %errorlevel% equ 5 call :disable_internet_explorer  
if %errorlevel% equ 6 goto :eof

goto software_management_menu

:system_maintenance_menu
cls  
echo System Maintenance
echo ==================
echo 1. Disk Cleanup
echo 2. Disk Defragmentation
echo 3. Check Disk for Errors
echo 4. Repair System Files
echo 5. Optimize Delivery Optimization
echo 6. Disable Automatic Maintenance
echo 7. Back to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "

if %errorlevel% equ 1 call :disk_cleanup
if %errorlevel% equ 2 call :disk_defragmentation  
if %errorlevel% equ 3 call :check_disk
if %errorlevel% equ 4 call :repair_system_files
if %errorlevel% equ 5 call :optimize_delivery_optimization
if %errorlevel% equ 6 call :disable_automatic_maintenance
if %errorlevel% equ 7 goto :eof

goto system_maintenance_menu

rem Optimization functions
:optimize_power_plan
cls
echo Optimize Power Plan
echo ====================
echo 1. Balanced
echo 2. High Performance
echo 3. Power Saver  
echo 4. Ultimate Performance
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 (
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    echo Balanced power plan activated.
) else if %errorlevel% equ 2 (
    if %ram% lss 4096 (
        powercfg -setactive a1841308-3541-4fab-bc81-f71556f20b4a
    ) else (
        powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
    )  
    echo High performance power plan activated.
) else if %errorlevel% equ 3 (
    powercfg -setactive a1841308-3541-4fab-bc81-f71556f20b4a
    echo Power saver plan activated.
) else if %errorlevel% equ 4 (
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    echo Ultimate performance power plan activated.
) else if %errorlevel% equ 5 goto :eof

pause  
goto :eof

:optimize_pagefile
cls
echo Optimize Page File
echo ===================
echo 1. Automatic
echo 2. Custom Size
echo 3. Disable Page File  
echo 4. Back to Main Menu
echo.
choice /c 1234 /m "Enter your choice: "

if %errorlevel% equ 1 (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
    echo Page file set to automatic management.
) else if %errorlevel% equ 2 (
    set /p initial_size="Enter initial page file size (MB): "
    set /p max_size="Enter maximum page file size (MB): "  
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
    wmic pagefileset where name="C:\pagefile.sys" set InitialSize=%initial_size%,MaximumSize=%max_size%
    echo Page file size customized.
) else if %errorlevel% equ 3 (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
    wmic pagefileset where name="C:\pagefile.sys" delete
    echo Page file disabled.
) else if %errorlevel% equ 4 goto :eof

pause
goto :eof  

:disable_services
cls
echo Disable Unnecessary Services
echo =============================
echo 1. Disable Diagnostic Tracking Service
echo 2. Disable Windows Push Notifications Service
echo 3. Disable Remote Registry Service
echo 4. Disable Print Spooler Service
echo 5. Disable Fax Service  
echo 6. Disable All
echo 7. Back to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "

if %errorlevel% equ 1 (
    sc config DiagTrack start= disabled
    echo Diagnostic Tracking Service disabled.
) else if %errorlevel% equ 2 (
    sc config dmwappushservice start= disabled
    echo Windows Push Notifications Service disabled.
) else if %errorlevel% equ 3 (
    sc config RemoteRegistry start= disabled  
    echo Remote Registry Service disabled.
) else if %errorlevel% equ 4 (
    sc config Spooler start= disabled
    echo Print Spooler Service disabled.
) else if %errorlevel% equ 5 (
    sc config Fax start= disabled
    echo Fax Service disabled.
) else if %errorlevel% equ 6 (
    sc config DiagTrack start= disabled
    sc config dmwappushservice start= disabled
    sc config RemoteRegistry start= disabled  
    sc config Spooler start= disabled
    sc config Fax start= disabled
    echo All services disabled.
) else if %errorlevel% equ 7 goto :eof

pause
goto :eof

:disk_cleanup
echo Cleaning up and optimizing disk...

if %disksize% lss 51200 (
cleanmgr /sagerun:1
) else (
cleanmgr /sagerun:1 /setup
)

if "%IS_WIN10%" == "1" (
defrag /C /H /V /U
) else if "%IS_WIN11%" == "1" (
defrag /C /H /V /U /X
)  

echo Disk cleaned up and optimized.
pause

goto :eof

:optimize_tcp
cls
echo Optimize TCP Settings
echo ======================
echo 1. Automatic Tuning
echo 2. Custom Tuning
echo 3. Reset to Defaults
echo 4. Back to Main Menu
echo.
choice /c 1234 /m "Enter your choice: "

if %errorlevel% equ 1 (
    netsh int tcp set global autotuninglevel=normal
    netsh int tcp set global rss=enabled
    netsh int tcp set global nonsackrttresiliency=disabled
    netsh int tcp set global timestamps=disabled
    
    if %ram% lss 4096 (
        netsh int tcp set global ecncapability=disabled
        netsh int tcp set global rsc=disabled
    ) else (
        netsh int tcp set global ecncapability=enabled
        netsh int tcp set global rsc=enabled
    )
    
    echo TCP settings optimized with automatic tuning.  
) else if %errorlevel% equ 2 (
    set /p autotune_level="Enter AutoTuning level (normal, restricted, highlyrestricted, constrained): "
    set /p ecn_capability="Enable ECN Capability? (yes/no): "
    set /p rsc_enabled="Enable Receive Segment Coalescing (RSC)? (yes/no): "
    
    netsh int tcp set global autotuninglevel=%autotune_level%
    netsh int tcp set global rss=enabled
    netsh int tcp set global nonsackrttresiliency=disabled
    netsh int tcp set global timestamps=disabled
    
    if /i "%ecn_capability%" == "yes" (
        netsh int tcp set global ecncapability=enabled  
    ) else (
        netsh int tcp set global ecncapability=disabled
    )
    
    if /i "%rsc_enabled%" == "yes" (
        netsh int tcp set global rsc=enabled
    ) else (
        netsh int tcp set global rsc=disabled
    )
    
    echo TCP settings customized.
) else if %errorlevel% equ 3 (
    netsh int tcp set global autotuninglevel=default
    netsh int tcp set global rss=default
    netsh int tcp set global nonsackrttresiliency=default
    netsh int tcp set global timestamps=default
    netsh int tcp set global ecncapability=default
    netsh int tcp set global rsc=default
    
    echo TCP settings reset to defaults.
) else if %errorlevel% equ 4 goto :eof

pause
goto :eof

:optimize_dns
cls  
echo Optimize DNS Settings
echo ======================
echo 1. Automatic (Fastest DNS)
echo 2. Google DNS (8.8.8.8, 8.8.4.4)
echo 3. Cloudflare DNS (1.1.1.1, 1.0.0.1)
echo 4. Quad9 DNS (9.9.9.9, 149.112.112.112)
echo 5. AdGuard DNS (94.140.14.14, 94.140.15.15)
echo 6. OpenDNS (208.67.222.222, 208.67.220.220)
echo 7. Custom DNS  
echo 8. Reset to Default
echo 9. Back to Main Menu
echo.

choice /c 123456789 /m "Enter your choice: "

if %errorlevel% equ 1 (
call :auto_dns
) else if %errorlevel% equ 2 (
netsh interface ipv4 set dnsservers "Wi-Fi" static 8.8.8.8 validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" 8.8.4.4 index=2 validate=no
echo Google DNS configured.
) else if %errorlevel% equ 3 (
netsh interface ipv4 set dnsservers "Wi-Fi" static 1.1.1.1 validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" 1.0.0.1 index=2 validate=no
echo Cloudflare DNS configured.
) else if %errorlevel% equ 4 (  
netsh interface ipv4 set dnsservers "Wi-Fi" static 9.9.9.9 validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" 149.112.112.112 index=2 validate=no
echo Quad9 DNS configured.
) else if %errorlevel% equ 5 (
netsh interface ipv4 set dnsservers "Wi-Fi" static 94.140.14.14 validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" 94.140.15.15 index=2 validate=no
echo AdGuard DNS configured.
) else if %errorlevel% equ 6 (
netsh interface ipv4 set dnsservers "Wi-Fi" static 208.67.222.222 validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" 208.67.220.220 index=2 validate=no
echo OpenDNS configured.
) else if %errorlevel% equ 7 (
set /p primary_dns="Enter primary DNS server: "
set /p secondary_dns="Enter secondary DNS server: "
netsh interface ipv4 set dnsservers "Wi-Fi" static %primary_dns% validate=no
netsh interface ipv4 add dnsservers "Wi-Fi" %secondary_dns% index=2 validate=no
echo Custom DNS configured.
) else if %errorlevel% equ 8 (
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp
echo DNS reset to default.
) else if %errorlevel% equ 9 goto :eof

pause
goto :eof

:auto_dns
echo Checking for fastest DNS...

for /f "tokens=1,2 delims=," %%a in ('PowerShell -Command "& {$res=@();$dns=@('8.8.8.8','1.1.1.1','9.9.9.9','94.140.14.14','208.67.222.222');foreach($d in $dns){$ping=Test-Connection -ComputerName $d -Count 1 -EA 0;if($ping){$res+=@($ping.ResponseTime,$d)}};($res|sort|select -First 2)[-1,-2]-join','}"') do (
set "primary_dns=%%a"
set "secondary_dns=%%b"
)

netsh interface ipv4 set dnsservers "Wi-Fi" static %primary_dns% validate=no
if defined secondary_dns (
netsh interface ipv4 add dnsservers "Wi-Fi" %secondary_dns% index=2 validate=no
)

echo Fastest DNS (%primary_dns%, %secondary_dns%) configured.

pause
goto :eof

:disable_background_apps
echo Disabling background apps...

if "%IS_WIN10%" == "1" (
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /t REG_DWORD /d 1 /f
) else if "%IS_WIN11%" == "1" (
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsRunInBackground /t REG_DWORD /d 2 /f
)

echo Background apps disabled.
pause

goto :eof

:disable_effects
cls
echo Disable Animations and Effects
echo ===============================
echo 1. Disable for Better Performance
echo 2. Disable for Best Performance
echo 3. Disable for Best Appearance
echo 4. Back to Main Menu
echo.
choice /c 1234 /m "Enter your choice: "

if %errorlevel% equ 1 (
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9032078010000000 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f
    echo Animations and effects disabled for better performance.
) else if %errorlevel% equ 2 (
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
    echo Animations and effects disabled for best performance.
) else if %errorlevel% equ 3 (
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9e3e07e325000000 /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f
    echo Animations and effects disabled for best appearance.
) else if %errorlevel% equ 4 goto :eof

pause
goto :eof

:customize_start_menu
echo Customizing Start Menu layout...

if "%IS_WIN11%" == "1" (
REM Customize Start Menu layout for Windows 11
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_Layout /t REG_DWORD /d 1 /f
powershell -command "Import-StartLayout -LayoutPath 'C:\Windows11StartLayout.xml' -MountPath $env:SystemDrive"
) else (

REM Customize Start Menu layout for Windows 10
powershell -command "Import-StartLayout -LayoutPath 'C:\Windows10StartLayout.xml' -MountPath $env:SystemDrive"

)

echo Start Menu layout customized.
pause
goto :eof

:customize_taskbar
echo Customizing taskbar settings...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f

if "%IS_WIN11%" == "1" (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
)

echo Taskbar settings customized.
pause
goto :eof

:customize_file_explorer
echo Customizing File Explorer options...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

if %ram% lss 4096 (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 0 /f
) else (
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /t REG_DWORD /d 1 /f
)

echo File Explorer options customized.
pause

goto :eof

:disable_telemetry
echo Disabling telemetry and data collection...

reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /f

if "%IS_WIN10%" == "1" (
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
) else if "%IS_WIN11%" == "1" (
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat /v AITEnable /t REG_DWORD /d 0 /f
)

echo Telemetry and data collection disabled.
pause
goto :eof

:harden_security
echo Hardening system security settings...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f

if "%IS_WIN10%" == "1" (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client" /v DisabledByDefault /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server" /v Enabled /t REG_DWORD /d 1 /f
) else if "%IS_WIN11%" == "1" (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Client" /v DisabledByDefault /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.3\Server" /v Enabled /t REG_DWORD /d 1 /f

)

echo System security settings hardened.
pause
goto :eof

:optimize_uac
echo Optimizing User Account Control settings...

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 5 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 1 /f

echo User Account Control settings optimized.
pause
goto :eof
:optimize_visual_effects
echo Optimizing visual effects for performance...

if %ram% lss 4096 (
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 0 /f
SystemPropertiesPerformance.exe
REM Manually adjust settings for best performance
) else (
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d 1 /f
SystemPropertiesPerformance.exe
REM Manually adjust settings for best appearance
)

echo Visual effects optimized for performance.
pause
goto :eof

:disable_game_bar
echo Disabling Game Bar and Game Mode...

reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f

if "%IS_WIN10%" == "1" (
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
) else if "%IS_WIN11%" == "1" (
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f
)

echo Game Bar and Game Mode disabled.
pause
goto :eof

:disable_fullscreen_opt
echo Disabling fullscreen optimizations...

reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v Win32_AutoGameModeDefaultProfile /t REG_BINARY /d 01000100000000000000000000000000000000000000000000000000000000000000000000000000 /f
reg add "HKCU\System\GameConfigStore" /v Win32_GameModeRelatedProcesses /t REG_BINARY /d 010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 /f

echo Fullscreen optimizations disabled.
pause

goto :eof

:optimize_sound
echo Optimizing sound settings...

if %ram% lss 4096 (
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v UserDuckingPreference /t REG_DWORD /d 3 /f
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v EnableAudioDucking /t REG_DWORD /d 0 /f
) else (
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v UserDuckingPreference /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v EnableAudioDucking /t REG_DWORD /d 1 /f

)

echo Sound settings optimized.
pause
goto :eof

:optimize_all
echo Performing all system optimizations...
call :optimize_power_plan
call :optimize_pagefile
call :disable_services
call :disk_cleanup
call :disable_startup_apps
call :optimize_ssd
call :optimize_tcp
call :optimize_dns
call :disable_background_apps
call :flush_dns_cache
call :optimize_wifi
call :disable_effects
call :customize_start_menu
call :customize_taskbar
call :customize_file_explorer
call :enable_dark_mode
call :customize_mouse_settings
call :disable_telemetry
call :harden_security
call :optimize_uac
call :enable_windows_firewall
call :disable_remote_access
call :optimize_visual_effects
call :disable_game_bar
call :disable_fullscreen_opt
call :optimize_sound
call :optimize_gpu_settings
call :disable_mouse_acceleration
echo All system optimizations completed.
pause
goto :eof

:undo_optimization
echo Undoing last system optimization...

REM Undo power plan optimization
powercfg -restoredefaultschemes

REM Undo page file optimization

wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True

REM Undo service disabling
sc config DiagTrack start= demand
sc config dmwappushservice start= demand
sc config RemoteRegistry start= demand

REM Undo TCP optimization
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global ecncapability=default
netsh int tcp set global rsc=default

REM Undo DNS optimization
netsh interface ip set dnsservers name="Wi-Fi" source=dhcp

REM Undo background apps disabling
reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications /v GlobalUserDisabled /f
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsRunInBackground /f

REM Undo effects disabling

reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9e3e078012000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f

REM Undo File Explorer customization
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SeparateProcess /f

REM Undo telemetry disabling
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /f
sc config DiagTrack start= auto
sc config dmwappushservice start= auto
reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat /v AITEnable /f

REM Undo security hardening
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols" /f

REM Undo visual effects optimization
reg delete "HKCU\Control Panel\Desktop" /v FontSmoothing /f

reg delete "HKCU\Control Panel\Desktop" /v DragFullWindows /f

REM Undo game optimizations
reg delete "HKCU\Software\Microsoft\GameBar" /f
reg delete "HKCU\System\GameConfigStore" /f

REM Undo sound optimizations
reg delete "HKCU\Software\Microsoft\Multimedia\Audio" /v UserDuckingPreference /f
reg delete "HKCU\Software\Microsoft\Multimedia\Audio" /v EnableAudioDucking /f

REM Undo mouse customizations
reg delete "HKCU\Control Panel\Mouse" /v MouseSensitivity /f
reg delete "HKCU\Control Panel\Mouse" /v MouseSpeed /f

reg delete "HKCU\Control Panel\Mouse" /v MouseThreshold1 /f
reg delete "HKCU\Control Panel\Mouse" /v MouseThreshold2 /f

REM Undo GPU optimizations
reg delete "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /f

echo Last system optimization undone.
pause
goto :eof

rem System spec check functions
:check_ram
for /f "tokens=2 delims==" %%a in ('wmic memorychip get capacity /value ^| findstr Capacity') do set ram=%%a
set /a ram=%ram:~0,-6%
goto :eof
:check_disk
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where "DeviceID='C:'" get Size /value ^| findstr Size') do set disksize=%%a
set /a disksize=%disksize:~0,-6%

goto :eof

:check_cpu
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfCores /value ^| findstr NumberOfCores') do set cores=%%a
goto :eof

rem Additional functions
:disable_startup_apps
echo Disabling unnecessary startup apps...

if "%IS_WIN10%" == "1" (
REM Disable unnecessary startup apps for Windows 10
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype for Desktop" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Spotify /f
) else if "%IS_WIN11%" == "1" (

REM Disable unnecessary startup apps for Windows 11
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "Skype for Desktop" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Spotify /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v SecurityHealthSystray /t REG_BINARY /d 030000000000000000000000 /f
)

echo Unnecessary startup apps disabled.
pause
goto :eof

:optimize_ssd
echo Optimizing SSD settings...

if "%IS_WIN10%" == "1" (
fsutil behavior set disabledeletenotify 0
) else if "%IS_WIN11%" == "1" (
fsutil behavior set disabledeletenotify 0
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\fssfltr" /v EnableOverride /t REG_DWORD /d 1 /f
)

echo SSD settings optimized.
pause
goto :eof

:flush_dns_cache
echo Flushing DNS cache...
ipconfig /flushdns
echo DNS cache flushed.
pause
goto :eof

:optimize_wifi
echo Optimizing Wi-Fi settings...

REM Get the Wi-Fi interface name
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interfaces ^| findstr /r /c:"[ ]*Name"') do set "wifi_name=%%a"
set "wifi_name=%wifi_name:~1%"

REM Disable auto configuration for the Wi-Fi interface
netsh wlan set autoconfig enabled=no interface="%wifi_name%"

REM Get the power scheme GUID
for /f "tokens=2 delims==" %%a in ('powercfg /getactivescheme ^| findstr "GUID"') do set "power_scheme_guid=%%a"

if %ram% lss 4096 (
    REM Set the power saving mode to "Maximum Performance"
    powercfg /setacvalueindex "%power_scheme_guid%" 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
    powercfg /setactive "%power_scheme_guid%"
) else (
    REM Disable the power saving mode
    powercfg /setacvalueindex "%power_scheme_guid%" 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 1
    powercfg /setactive "%power_scheme_guid%"
)

echo Wi-Fi settings optimized.
pause
goto :eof

:enable_dark_mode
cls
echo Choose Light or Dark Mode
echo ==========================
echo 1. Enable Dark Mode
echo 2. Enable Light Mode 
echo 3. Back to Main Menu
echo.
choice /c 123 /m "Enter your choice: "

if %errorlevel% equ 1 (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f
    if "%IS_WIN11%" == "1" reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    echo Dark mode enabled.
) else if %errorlevel% equ 2 (
    reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 1 /f  
    if "%IS_WIN11%" == "1" reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
    echo Light mode enabled.  
) else if %errorlevel% equ 3 goto :eof

pause
goto :eof
:customize_mouse_settings
echo Customizing mouse settings...

reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d "10" /f
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f

echo Mouse settings customized.

pause
goto :eof

:enable_windows_firewall
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on
echo Windows Firewall enabled.
pause
goto :eof

:disable_remote_access
echo Disabling remote access...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f

if "%IS_WIN11%" == "1" (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowFullControl /t REG_DWORD /d 0 /f
)

echo Remote access disabled.
pause

goto :eof

:optimize_gpu_settings
cls
echo Optimize GPU Settings
echo =====================
echo 1. High Performance Mode
echo 2. Balanced Mode
echo 3. Power Saving Mode

echo 4. Automatic (Based on system specs)
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

if %errorlevel% equ 1 (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /t REG_DWORD /d 0 /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f
echo High Performance mode set.
) else if %errorlevel% equ 2 (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 0 /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 0 /f
echo Balanced mode set.

) else if %errorlevel% equ 3 (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /t REG_DWORD /d 5000 /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f
echo Power Saving mode set.
) else if %errorlevel% equ 4 (
if %ram% gtr 8192 (
if %cores% gtr 4 (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /t REG_DWORD /d 0 /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f
echo High Performance mode set based on system specs.
) else (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 0 /f

reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 0 /f
echo Balanced mode set based on system specs.
)
) else (
reg add "HKCU\Software\Microsoft\GameBar" /v UseGpuHighPerformance /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v VsyncIdleTimeout /t REG_DWORD /d 5000 /f
if "%IS_WIN11%" == "1" reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f
echo Power Saving mode set based on system specs.
)

) else if %errorlevel% equ 5 goto :eof

pause
goto :eof

:disable_mouse_acceleration
echo Disabling mouse acceleration...

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f

echo Mouse acceleration disabled.
pause
goto :eof

:customize_power_plan
cls
echo Customize Power Plan Settings
echo =============================
echo 1. Processor Power Management
echo 2. Hard Disk Power Management
echo 3. Wireless Adapter Power Management
echo 4. Sleep and Hibernation Settings
echo 5. USB Power Management
echo 6. Back to Main Menu

choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :processor_power_management
if %errorlevel% equ 2 call :hard_disk_power_management
if %errorlevel% equ 3 call :wireless_adapter_power_management
if %errorlevel% equ 4 call :sleep_hibernation_settings
if %errorlevel% equ 5 call :usb_power_management
if %errorlevel% equ 6 goto advanced_power_menu

goto customize_power_plan

REM Processor Power Management
:processor_power_management
cls
echo Processor Power Management Settings
echo ===================================
echo 1. Minimum Processor State: 5%
echo 2. Minimum Processor State: 25%
echo 3. Minimum Processor State: 50%
echo 4. Maximum Processor State: 100%
echo 5. Maximum Processor State: 90%
echo 6. Maximum Processor State: 75%
echo 7. Back to Power Plan Settings

choice /c 1234567 /m "Enter your choice: "
set powerguid=
for /f "tokens=2 delims={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

if %errorlevel% equ 1 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMIN 5
    powercfg /setactive %powerguid%
    echo Minimum processor state set to 5%%.
) else if %errorlevel% equ 2 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMIN 25
    powercfg /setactive %powerguid%
    echo Minimum processor state set to 25%%.
) else if %errorlevel% equ 3 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMIN 50
    powercfg /setactive %powerguid%
    echo Minimum processor state set to 50%%.
) else if %errorlevel% equ 4 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMAX 100
    powercfg /setactive %powerguid%
    echo Maximum processor state set to 100%%.
) else if %errorlevel% equ 5 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMAX 90
    powercfg /setactive %powerguid%
    echo Maximum processor state set to 90%%.
) else if %errorlevel% equ 6 (
    powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMAX 75  
    powercfg /setactive %powerguid%
    echo Maximum processor state set to 75%%.
) else if %errorlevel% equ 7 (
    goto customize_power_plan
)

pause
goto processor_power_management

REM Hard Disk Power Management
:hard_disk_power_management
cls
echo Hard Disk Power Management Settings
echo ===================================
echo 1. Turn off hard disk after 5 minutes
echo 2. Turn off hard disk after 10 minutes
echo 3. Turn off hard disk after 20 minutes
echo 4. Never turn off hard disk
echo 5. Back to Power Plan Settings

choice /c 12345 /m "Enter your choice: "
set powerguid=
for /f "tokens=2 delims={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

if %errorlevel% equ 1 (
    powercfg /setacvalueindex %powerguid% sub_disk DISKIDLE 300
    powercfg /setactive %powerguid%
    echo Hard disk will turn off after 5 minutes of inactivity.
) else if %errorlevel% equ 2 (
    powercfg /setacvalueindex %powerguid% sub_disk DISKIDLE 600
    powercfg /setactive %powerguid%
    echo Hard disk will turn off after 10 minutes of inactivity.
) else if %errorlevel% equ 3 (
    powercfg /setacvalueindex %powerguid% sub_disk DISKIDLE 1200
    powercfg /setactive %powerguid%
    echo Hard disk will turn off after 20 minutes of inactivity.
) else if %errorlevel% equ 4 (
    powercfg /setacvalueindex %powerguid% sub_disk DISKIDLE 0
    powercfg /setactive %powerguid%
    echo Hard disk will never turn off.
) else if %errorlevel% equ 5 (
    goto customize_power_plan
)

pause
goto hard_disk_power_management

REM Wireless Adapter Power Management
:wireless_adapter_power_management
cls
echo Wireless Adapter Power Management Settings
echo ==========================================
echo 1. Maximum Performance mode
echo 2. Low Power Saving mode
echo 3. Medium Power Saving mode 
echo 4. Maximum Power Saving mode
echo 5. Back to Power Plan Settings

choice /c 12345 /m "Enter your choice: "
set powerguid=
for /f "tokens=2 delims={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

if %errorlevel% equ 1 (
    powercfg /setacvalueindex %powerguid% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 0
    powercfg /setactive %powerguid%
    echo Wireless adapter set to Maximum Performance mode.
) else if %errorlevel% equ 2 (
    powercfg /setacvalueindex %powerguid% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 1
    powercfg /setactive %powerguid%
    echo Wireless adapter set to Low Power Saving mode.
) else if %errorlevel% equ 3 (
    powercfg /setacvalueindex %powerguid% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 2
    powercfg /setactive %powerguid%
    echo Wireless adapter set to Medium Power Saving mode.
) else if %errorlevel% equ 4 (
    powercfg /setacvalueindex %powerguid% 19cbb8fa-5279-450e-9fac-8a3d5fedd0c1 12bbebe6-58d6-4636-95bb-3217ef867c1a 3
    powercfg /setactive %powerguid%
    echo Wireless adapter set to Maximum Power Saving mode.
) else if %errorlevel% equ 5 (
    goto customize_power_plan
)

pause
goto wireless_adapter_power_management

REM Sleep and Hibernation Settings
:sleep_hibernation_settings
cls
echo Sleep and Hibernation Settings
echo ==============================
echo 1. Sleep after 15 minutes
echo 2. Sleep after 30 minutes
echo 3. Sleep after 1 hour
echo 4. Never sleep
echo 5. Hibernate after 1 hour
echo 6. Hibernate after 2 hours 
echo 7. Never hibernate
echo 8. Back to Power Plan Settings

choice /c 12345678 /m "Enter your choice: "
set powerguid=
for /f "tokens=2 delims={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

if %errorlevel% equ 1 (
    powercfg /setacvalueindex %powerguid% sub_sleep STANDBYIDLE 900  
    powercfg /setactive %powerguid%
    echo System will sleep after 15 minutes of inactivity.
) else if %errorlevel% equ 2 (
    powercfg /setacvalueindex %powerguid% sub_sleep STANDBYIDLE 1800
    powercfg /setactive %powerguid%
    echo System will sleep after 30 minutes of inactivity.
) else if %errorlevel% equ 3 (
    powercfg /setacvalueindex %powerguid% sub_sleep STANDBYIDLE 3600
    powercfg /setactive %powerguid%
    echo System will sleep after 1 hour of inactivity.
) else if %errorlevel% equ 4 (
    powercfg /setacvalueindex %powerguid% sub_sleep STANDBYIDLE 0  
    powercfg /setactive %powerguid%
    echo System will never sleep.
) else if %errorlevel% equ 5 (
    powercfg /setacvalueindex %powerguid% sub_sleep HIBERNATEIDLE 3600
    powercfg /setactive %powerguid%
    echo System will hibernate after 1 hour of inactivity.
) else if %errorlevel% equ 6 (
    powercfg /setacvalueindex %powerguid% sub_sleep HIBERNATEIDLE 7200
    powercfg /setactive %powerguid%
    echo System will hibernate after 2 hours of inactivity.
) else if %errorlevel% equ 7 (
    powercfg /setacvalueindex %powerguid% sub_sleep HIBERNATEIDLE 0
    powercfg /setactive %powerguid%
    echo System will never hibernate.  
) else if %errorlevel% equ 8 (
    goto customize_power_plan
)

pause
goto sleep_hibernation_settings

REM USB Power Management  
:usb_power_management
cls
echo USB Power Management Settings
echo =============================
echo 1. Disable selective suspend
echo 2. Enable selective suspend
echo 3. Back to Power Plan Settings

choice /c 123 /m "Enter your choice: "
set powerguid=
for /f "tokens=2 delims={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

if %errorlevel% equ 1 (
    powercfg /setacvalueindex %powerguid% 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
    powercfg /setactive %powerguid%
    echo USB selective suspend disabled.
) else if %errorlevel% equ 2 (  
    powercfg /setacvalueindex %powerguid% 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
    powercfg /setactive %powerguid%
    echo USB selective suspend enabled.
) else if %errorlevel% equ 3 (
    goto customize_power_plan
)

pause
goto usb_power_management

:disable_fast_startup
echo Disabling Fast Startup...

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f

echo Fast Startup disabled.
pause
goto advanced_power_menu

:disable_hibernation
echo Disabling Hibernation...

powercfg /hibernate off

echo Hibernation disabled.
pause
goto advanced_power_menu

:optimize_battery_settings
echo Optimizing Battery Settings...

REM Get the power scheme GUID
for /f "tokens=2 delims=={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

REM Balanced Battery Settings
powercfg /setdcvalueindex %powerguid% sub_batterylevel BATFLAGSCRITICAL 10
powercfg /setdcvalueindex %powerguid% sub_batterylevel BATFLAGSLOW 20
powercfg /setdcvalueindex %powerguid% sub_batterylevel BATLEVELCRITICAL 7
powercfg /setdcvalueindex %powerguid% sub_batterylevel BATLEVELLOW 14
powercfg /setactive %powerguid%

echo Battery settings optimized.
pause
goto advanced_power_menu

:optimize_processor_power
echo Optimizing Processor Power Management...

REM Get the power scheme GUID
for /f "tokens=2 delims=={}" %%a in ('powercfg /getactivescheme') do set powerguid=%%a

REM Balanced Processor Power Settings
powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMIN 5
powercfg /setacvalueindex %powerguid% sub_processor PROCTHROTTLEMAX 100
powercfg /setactive %powerguid%

echo Processor power management optimized.
pause
goto advanced_power_menu

:uninstall_apps
echo Uninstalling unnecessary apps...

REM Uninstall some common unnecessary apps
powershell -command "Get-AppxPackage *3DBuilder* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Windows.ContactSupport* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *MixedReality.Portal* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Microsoft.Windows.PeopleExperienceHost* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *Microsoft.Wallet* | Remove-AppxPackage"

echo Unnecessary apps uninstalled.
pause
goto software_management_menu  

:disable_onedrive
echo Disabling OneDrive...

taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
rd "%UserProfile%\OneDrive" /Q /S
rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
rd "%ProgramData%\Microsoft OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f
reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f

echo OneDrive disabled.
pause
goto software_management_menu

:disable_cortana
echo Disabling Cortana...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f  
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f

echo Cortana disabled.
pause
goto software_management_menu

:disable_media_player
echo Disabling Windows Media Player...

dism /online /disable-feature /featurename:MediaPlayback /norestart

echo Windows Media Player disabled.  
pause
goto software_management_menu

:disable_internet_explorer
echo Disabling Internet Explorer...

dism /online /disable-feature /featurename:Internet-Explorer-Optional-amd64 /norestart

echo Internet Explorer disabled.
pause
goto software_management_menu

:disk_defragmentation
echo Defragmenting disk...

defrag C: /U /V

echo Disk defragmentation completed.
pause
goto system_maintenance_menu

:check_disk
echo Checking disk for errors...

chkdsk C: /F /R /X

echo Disk check completed.
pause
goto system_maintenance_menu

:repair_system_files
echo Repairing system files...

REM Repair Windows system image
dism /online /cleanup-image /restorehealth

REM Repair Windows system files  
sfc /scannow

echo System files repaired.
pause
goto system_maintenance_menu

:optimize_delivery_optimization
echo Optimizing Delivery Optimization...

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 1 /f

if %ram% lss 4096 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOGroupIdSource /t REG_DWORD /d 3 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOMaxUploadBandwidth /t REG_DWORD /d 512 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOMaxDownloadBandwidth /t REG_DWORD /d 1024 /f
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOGroupIdSource /t REG_DWORD /d 2 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOMaxUploadBandwidth /t REG_DWORD /d 1024 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DOMaxDownloadBandwidth /t REG_DWORD /d 4096 /f
)

echo Delivery Optimization settings optimized.
pause
goto system_maintenance_menu

:disable_automatic_maintenance
echo Disabling Automatic Maintenance...

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f

echo Automatic Maintenance disabled.
pause
goto system_maintenance_menu

:disable_timeline
echo Disabling Timeline...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f

echo Timeline disabled.
pause
goto system_performance_menu

:disable_autotuning
echo Disabling Autotuning...

netsh int tcp set global autotuninglevel=disabled

echo Autotuning disabled.
pause
goto network_menu

:optimize_network_adapter
echo Optimizing Network Adapter settings...

REM Get the network adapter name
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Ethernet adapter"') do set "adapter_name=%%a"
set "adapter_name=%adapter_name:~1%"

REM Disable power saving mode for the network adapter
powercfg -setacvalueindex %powerguid% 7516b95f-f776-4464-8c53-06167f40cc99 5d3e9a59-e9d5-4b00-a6bd-ff34ff516548 0
powercfg -setactive %powerguid%

REM Configure network adapter settings
netsh interface ip set interface "%adapter_name%" forcearpndwolpattern=enabled
netsh interface ip set interface "%adapter_name%" ecncapability=enabled
netsh interface ip set interface "%adapter_name%" rsc=enabled

echo Network Adapter settings optimized.
pause
goto network_menu

:enable_jumbo_frames
echo Enabling Jumbo Frames...

REM Get the network adapter name
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Ethernet adapter"') do set "adapter_name=%%a"
set "adapter_name=%adapter_name:~1%"

REM Enable Jumbo Frames
netsh interface ip set subinterface "%adapter_name%" mtu=9000 store=persistent

echo Jumbo Frames enabled.
pause
goto network_menu

:disable_ipv6
echo Disabling IPv6...

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f

echo IPv6 disabled.
pause
goto network_menu

:optimize_proxy
echo Optimizing Proxy settings...

REM Disable Proxy
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f

REM Disable Proxy Autodetection
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoDetect /t REG_DWORD /d 0 /f

echo Proxy settings optimized.
pause
goto network_menu

:customize_desktop_icons
echo Customizing Desktop Icons...

REM Customize Desktop Icons
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 0 /f

echo Desktop Icons customized.
pause
goto ui_personalization_menu

:disable_lock_screen
echo Disabling Lock Screen...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f

echo Lock Screen disabled.
pause
goto ui_personalization_menu

:disable_action_center
echo Disabling Action Center...

reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f

echo Action Center disabled.
pause
goto ui_personalization_menu

:restore_default_theme
echo Restoring Default Theme...

REM Restore Default Theme
dism /online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsDefaultThemesPack_10.0.19041.2075_neutral_~_8wekyb3d8bbwe

echo Default Theme restored.
pause
goto ui_personalization_menu

:optimize_steam_settings
echo Optimizing Steam settings...

REM Optimize Steam settings
reg add "HKCU\Software\Valve\Steam" /v DWriteEnable /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Valve\Steam" /v DPIScaling /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Valve\Steam" /v ForceFloatV2Shaders /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Valve\Steam" /v OverlayRenderMode /t REG_DWORD /d 1 /f

echo Steam settings optimized.
pause
goto gaming_multimedia_menu

:disable_xbox_game_bar
echo Disabling Xbox Game Bar...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f

echo Xbox Game Bar disabled.
pause
goto gaming_multimedia_menu

:optimize_nvidia_settings
echo Optimizing NVIDIA settings...

REM Optimize NVIDIA settings
reg add "HKCU\Software\NVIDIA Corporation\Global\NVTweak\Devices\509901423-0\Color" /v NvCplUseColorCorrection /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v PlatformSupportMiracast /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" /v DisplayPowerSaving /t REG_DWORD /d 0 /f

echo NVIDIA settings optimized.
pause
goto gaming_multimedia_menu

:optimize_amd_settings
echo Optimizing AMD settings...

REM Optimize AMD settings
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v AreaAniso_DEF /t REG_SZ /d 8 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v EnableUlps_DEF /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DisableDMACopy /t REG_SZ /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DisableBlockWrite /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v StutterMode /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v EnableUlps /t REG_SZ /d 0 /f

echo AMD settings optimized.
pause
goto gaming_multimedia_menu

:clear_event_logs
echo Clearing Windows Event Logs...

REM Clear Windows Event Logs
for /F "tokens=*" %%1 in ('wevtutil.exe el') DO wevtutil.exe cl "%%1"

echo Windows Event Logs cleared.
pause
goto privacy_security_menu

:disable_wifi_sense
echo Disabling Wi-Fi Sense...

reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f

echo Wi-Fi Sense disabled.
pause
goto privacy_security_menu

:disable_smartscreen
echo Disabling SmartScreen Filter...

reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v EnabledV9 /t REG_DWORD /d 0 /f

echo SmartScreen Filter disabled.
pause
goto privacy_security_menu

:disable_windows_defender
echo Disabling Windows Defender...

reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f

echo Windows Defender disabled.
pause
goto privacy_security_menu
