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
echo 8. Exit
echo.
choice /c 12345678 /m "Enter your choice: "
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
echo 9. Back to Main Menu
echo.

choice /c 123456789 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_power_plan
if %errorlevel% equ 2 call :optimize_pagefile
if %errorlevel% equ 3 call :disable_services
if %errorlevel% equ 4 call :disk_cleanup
if %errorlevel% equ 5 call :disable_startup_apps
if %errorlevel% equ 6 call :optimize_ssd
if %errorlevel% equ 7 call :manage_startup_apps
if %errorlevel% equ 8 call :windows_settings
if %errorlevel% equ 9 goto :main_menu

goto system_performance_menu

:windows_settings

cls

echo Windows Settings
echo =================================
echo 1. Enable/Disable Windows Update
echo 2. Enable/Disable Windows Defender
echo 3. Enable/Disable Windows Firewall
echo 4. Back to Performance Menu
echo.

choice /c 1234 /m "Enter your choice: "

if %errorlevel% equ 1 call :windows_update_settings
if %errorlevel% equ 2 call :windows_defender_settings
if %errorlevel% equ 3 call :windows_firewall_settings
if %errorlevel% equ 4 goto system_performance_menu

goto windows_settings

REM Add functions for Windows Update, Defender, and Firewall settings here
REM Example:
:windows_update_settings
cls
echo Windows Update Settings
echo ========================
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Back

choice /c 123 /m "Enter your choice: "
if %errorlevel% equ 1 (
    REM Enable Windows Update
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Update\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f
    echo Windows Update enabled.
) else if %errorlevel% equ 2 (
    REM Disable Windows Update
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Update\Auto Update" /v AUOptions /t REG_DWORD /d 1 /f
    echo Windows Update disabled.
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
echo 3. Back

choice /c 123 /m "Enter your choice: "

if %errorlevel% equ 1 (
    REM Enable Windows Defender
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 0 /f
    sc config WdBoot start= auto
    sc config WdFilter start= auto
    sc config WdNisDrv start= auto
    sc config WdNisSvc start= auto
    sc config WinDefend start= auto
    sc config SecurityHealthService start= auto
    net start WdBoot
    net start WdFilter
    net start WdNisDrv
    net start WdNisSvc
    net start WinDefend
    net start SecurityHealthService
    schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Enable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable
    echo Windows Defender fully enabled, including real-time protection, all services, and scheduled tasks.
) else if %errorlevel% equ 2 (
    REM Disable Windows Defender
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableIOAVProtection /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f
    net stop WdBoot
    net stop WdFilter
    net stop WdNisDrv
    net stop WdNisSvc
    net stop WinDefend
    net stop SecurityHealthService
    sc config WdBoot start= disabled
    sc config WdFilter start= disabled
    sc config WdNisDrv start= disabled
    sc config WdNisSvc start= disabled
    sc config WinDefend start= disabled
    sc config SecurityHealthService start= disabled
    schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
    schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable
    echo Windows Defender fully disabled, including real-time protection, all services, and scheduled tasks. It will remain disabled even after restarting the computer.
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
echo 3. Back

choice /c 123 /m "Enter your choice: "
if %errorlevel% equ 1 (
    REM Enable Windows Firewall
    NetSh Advfirewall set allprofiles state on
    echo Windows Firewall enabled.
) else if %errorlevel% equ 2 (
    REM Disable Windows Firewall
    NetSh Advfirewall set allprofiles state off
    echo Windows Firewall disabled.
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
echo 2. Back to System Performance Menu
echo.
choice /c 12 /m "Enter your choice: "

if %errorlevel% equ 1 call :startup_app_selection
if %errorlevel% equ 2 goto :eof

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
echo 3. Disable Background Apps
echo 4. Flush DNS Cache
echo 5. Optimize Wi-Fi Settings
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_tcp
if %errorlevel% equ 2 call :optimize_dns
if %errorlevel% equ 3 call :disable_background_apps
if %errorlevel% equ 4 call :flush_dns_cache
if %errorlevel% equ 5 call :optimize_wifi
if %errorlevel% equ 6 goto :eof

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
echo 5. Enable Dark Mode And Disable Dark Mode
echo 6. Customize Mouse Settings
echo 7. Back to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "

if %errorlevel% equ 1 call :disable_effects
if %errorlevel% equ 2 call :customize_start_menu
if %errorlevel% equ 3 call :customize_taskbar
if %errorlevel% equ 4 call :customize_file_explorer
if %errorlevel% equ 5 call :enable_dark_mode
if %errorlevel% equ 6 call :customize_mouse_settings
if %errorlevel% equ 7 goto :eof

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
echo 7. Back to Main Menu
echo.
choice /c 1234567 /m "Enter your choice: "

if %errorlevel% equ 1 call :optimize_visual_effects
if %errorlevel% equ 2 call :disable_game_bar
if %errorlevel% equ 3 call :disable_fullscreen_opt
if %errorlevel% equ 4 call :optimize_sound
if %errorlevel% equ 5 call :optimize_gpu_settings
if %errorlevel% equ 6 call :disable_mouse_acceleration
if %errorlevel% equ 7 goto :eof

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
echo 6. Back to Main Menu
echo.
choice /c 123456 /m "Enter your choice: "

if %errorlevel% equ 1 call :disable_telemetry
if %errorlevel% equ 2 call :harden_security
if %errorlevel% equ 3 call :optimize_uac
if %errorlevel% equ 4 call :enable_windows_firewall
if %errorlevel% equ 5 call :disable_remote_access
if %errorlevel% equ 6 goto :eof

goto privacy_security_menu

rem Optimization functions
:optimize_power_plan
cls
echo Optimize Power Plan
echo ====================
echo 1. Balanced
echo 2. High Performance
echo 3. Power Saver
echo 4. Back to Main Menu
echo.
choice /c 1234 /m "Enter your choice: "

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
) else if %errorlevel% equ 4 goto :eof

pause
goto :eof

:optimize_pagefile
cls
echo Optimize Page File
echo ===================
echo 1. Automatic
echo 2. Custom Size
echo 3. Back to Main Menu
echo.
choice /c 123 /m "Enter your choice: "

if %errorlevel% equ 1 (
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
    echo Page file set to automatic management.
) else if %errorlevel% equ 2 (
    set /p initial_size="Enter initial page file size (MB): "
    set /p max_size="Enter maximum page file size (MB): "
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
    wmic pagefileset where name="C:\pagefile.sys" set InitialSize=%initial_size%,MaximumSize=%max_size%
    echo Page file size customized.
) else if %errorlevel% equ 3 goto :eof

pause
goto :eof

:disable_services
cls
echo Disable Unnecessary Services
echo =============================
echo 1. Disable Diagnostic Tracking Service
echo 2. Disable Windows Push Notifications Service
echo 3. Disable Remote Registry Service
echo 4. Disable All
echo 5. Back to Main Menu
echo.
choice /c 12345 /m "Enter your choice: "

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
    sc config DiagTrack start= disabled
    sc config dmwappushservice start= disabled 
    sc config RemoteRegistry start= disabled
    echo All services disabled.
) else if %errorlevel% equ 5 goto :eof

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
defrag /C /H /V
) else if "%IS_WIN11%" == "1" (
defrag /C /H /V /X
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
echo 7. Reset to Default
echo 8. Back to Main Menu
echo.

choice /c 12345678 /m "Enter your choice: "

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
netsh interface ipv4 set dnsservers "Wi-Fi" dhcp
echo DNS reset to default.
) else if %errorlevel% equ 8 goto :eof

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
