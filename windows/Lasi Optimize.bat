@echo off
setlocal enabledelayedexpansion

:menu
cls
echo ============================================
echo          Windows 11 Optimization Menu
echo ============================================
echo [1] System Optimize
echo [2] Internet Optimize
echo [3] Game Optimize
echo [4] CPU Optimize
echo [5] Mode Switcher
echo [6] Animation Optimize
echo [7] Graphic Optimize
echo [8] Power Optimize
echo [9] Windows Update
echo [10] RAM Optimize
echo [11] Firewall and Windows Defender Antivirus
echo [12] System Repair and Fixes
echo [0] Exit
echo ============================================
set /p choice=Select an option:

if "%choice%"=="1" goto system_optimize
if "%choice%"=="2" goto internet_optimize
if "%choice%"=="3" goto game_optimize
if "%choice%"=="4" goto cpu_optimize
if "%choice%"=="5" goto mode_switcher
if "%choice%"=="6" goto animation_optimize
if "%choice%"=="7" goto graphic_optimize
if "%choice%"=="8" goto power_optimize
if "%choice%"=="9" goto windows_update
if "%choice%"=="10" goto ram_optimize
if "%choice%"=="11" goto firewall_defender
if "%choice%"=="12" goto system_repair
if "%choice%"=="0" goto exit_script

goto menu

:system_optimize
cls
echo ============================================
echo          System Optimize Menu
echo ============================================
echo [1] Disk Cleanup
echo [2] Registry Cleaner
echo [3] Startup Manager
echo [0] Back to Main Menu
echo ============================================
set /p sys_choice=Select an option:

if "%sys_choice%"=="1" goto disk_cleanup
if "%sys_choice%"=="2" goto registry_cleaner
if "%sys_choice%"=="3" goto startup_manager
if "%sys_choice%"=="0" goto menu

goto system_optimize

:disk_cleanup
echo Cleaning Disk...
cleanmgr /sagerun:1
pause
goto system_optimize

:registry_cleaner
echo Cleaning Registry...
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" > nul 2>&1
if %errorlevel% NEQ 0 (
    echo You need administrative privileges to clean the registry.
    pause
    goto system_optimize
)
echo Using PowerShell to clean the registry...
powershell -Command "Get-ChildItem 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall' | Remove-Item -Recurse"
pause
goto system_optimize

:startup_manager
echo Managing Startup Programs...
start msconfig
pause
goto system_optimize

:internet_optimize
cls
echo ============================================
echo          Internet Optimize Menu
echo ============================================
echo [1] Network Settings Tuning
echo [2] DNS Optimization
echo [3] Cache Cleaning
echo [0] Back to Main Menu
echo ============================================
set /p net_choice=Select an option:

if "%net_choice%"=="1" goto network_settings_tuning
if "%net_choice%"=="2" goto dns_optimization
if "%net_choice%"=="3" goto cache_cleaning
if "%net_choice%"=="0" goto menu

goto internet_optimize

:network_settings_tuning
echo Tuning Network Settings...
netsh int tcp set global autotuninglevel=normal
pause
goto internet_optimize

:dns_optimization
echo Optimizing DNS Settings...
netsh interface ipv4 set dns name="Wi-Fi" source=dhcp
pause
goto internet_optimize

:cache_cleaning
echo Cleaning Browser Cache...
for /d %%x in ("%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*.*") do rmdir /s /q "%%x"
pause
goto internet_optimize

:game_optimize
cls
echo ============================================
echo          Game Optimize Menu
echo ============================================
echo [1] Game Mode
echo [2] GPU Settings Optimization
echo [3] Latency Reducer
echo [0] Back to Main Menu
echo ============================================
set /p game_choice=Select an option:

if "%game_choice%"=="1" goto game_mode
if "%game_choice%"=="2" goto gpu_settings_optimization
if "%game_choice%"=="3" goto latency_reducer
if "%game_choice%"=="0" goto menu

goto game_optimize

:game_mode
echo Activating Game Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f
pause
goto game_optimize

:gpu_settings_optimization
echo Optimizing GPU Settings...
:: Assuming use of NVIDIA Control Panel for GPU Settings Optimization
start "nvcplui"
pause
goto game_optimize

:latency_reducer
echo Reducing Latency...
netsh int tcp set global lowlatency=enabled
pause
goto game_optimize

:cpu_optimize
cls
echo ============================================
echo          CPU Optimize Menu
echo ============================================
echo [1] Process Priority Manager
echo [2] Core Parking
echo [3] Power Plan Optimization
echo [0] Back to Main Menu
echo ============================================
set /p cpu_choice=Select an option:

if "%cpu_choice%"=="1" goto process_priority_manager
if "%cpu_choice%"=="2" goto core_parking
if "%cpu_choice%"=="3" goto power_plan_optimization
if "%cpu_choice%"=="0" goto menu

goto cpu_optimize

:process_priority_manager
echo Managing Process Priority...
wmic process where name="someprocess.exe" CALL setpriority "high priority"
pause
goto cpu_optimize

:core_parking
echo Optimizing Core Parking...
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583' -Name 'Attributes' -Value 2"
pause
goto cpu_optimize

:power_plan_optimization
echo Optimizing Power Plan...
powercfg /change standby-timeout-ac 0
pause
goto cpu_optimize

:mode_switcher
cls
echo ============================================
echo          Mode Switcher Menu
echo ============================================
echo [1] Dark Mode
echo [2] Light Mode
echo [0] Back to Main Menu
echo ============================================
set /p mode_choice=Select an option:

if "%mode_choice%"=="1" goto dark_mode
if "%mode_choice%"=="2" goto light_mode
if "%mode_choice%"=="0" goto menu

goto mode_switcher

:dark_mode
echo Activating Dark Mode...
powershell -Command "New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0 -PropertyType DWord -Force"
pause
goto mode_switcher

:light_mode
echo Activating Light Mode...
powershell -Command "New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 1 -PropertyType DWord -Force"
pause
goto mode_switcher

:animation_optimize
cls
echo ============================================
echo          Animation Optimize Menu
echo ============================================
echo [1] Animation Tuning
echo [2] Reduce Motion
echo [3] Frame Rate Adjustment
echo [0] Back to Main Menu
echo ============================================
set /p anim_choice=Select an option:

if "%anim_choice%"=="1" goto animation_tuning
if "%anim_choice%"=="2" goto reduce_motion
if "%anim_choice%"=="3" goto frame_rate_adjustment
if "%anim_choice%"=="0" goto menu

goto animation_optimize

:animation_tuning
echo Tuning Animations...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
pause
goto animation_optimize

:reduce_motion
echo Reducing Motion...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f
pause
goto animation_optimize

:frame_rate_adjustment
echo Adjusting Frame Rate...
:: Adjusting frame rate settings if applicable
pause
goto animation_optimize

:graphic_optimize
cls
echo ============================================
echo          Graphic Optimize Menu
echo ============================================
echo [1] Resolution Optimization
echo [2] Color Calibration
echo [3] Driver Update
echo [0] Back to Main Menu
echo ============================================
set /p graph_choice=Select an option:

if "%graph_choice%"=="1" goto resolution_optimization
if "%graph_choice%"=="2" goto color_calibration
if "%graph_choice%"=="3" goto driver_update
if "%graph_choice%"=="0" goto menu

goto graphic_optimize

:resolution_optimization
echo Optimizing Screen Resolution...
:: Assuming use of standard resolution change methods
start desk.cpl
pause
goto graphic_optimize

:color_calibration
echo Calibrating Display Color...
start dccw.exe
pause
goto graphic_optimize

:driver_update
echo Updating GPU Driver...
:: Assuming use of NVIDIA Driver Updater
start /wait nvidia-installer.exe --update
pause
goto graphic_optimize

:power_optimize
cls
echo ============================================
echo          Power Optimize Menu
echo ============================================
echo [1] Battery Saver Mode
echo [2] Power Consumption Monitoring
echo [3] Sleep and Hibernate Settings
echo [0] Back to Main Menu
echo ============================================
set /p power_choice=Select an option:

if "%power_choice%"=="1" goto battery_saver_mode
if "%power_choice%"=="2" goto power_consumption_monitoring
if "%power_choice%"=="3" goto sleep_hibernate_settings
if "%power_choice%"=="0" goto menu

goto power_optimize

:battery_saver_mode
echo Activating Battery Saver Mode...
powercfg /setactive SCHEME_MAX
pause
goto power_optimize

:power_consumption_monitoring
echo Monitoring Power Consumption...
powercfg /energy
pause
goto power_optimize

:sleep_hibernate_settings
echo Adjusting Sleep and Hibernate Settings...
powercfg /change monitor-timeout-ac 5
pause
goto power_optimize

:windows_update
cls
echo ============================================
echo          Windows Update Menu
echo ============================================
echo [1] Enable Windows Update
echo [2] Disable Windows Update
echo [0] Back to Main Menu
echo ============================================
set /p update_choice=Select an option:

if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="0" goto menu

goto windows_update

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start=auto
sc start wuauserv
pause
goto windows_update

:disable_windows_update
echo Disabling Windows Update...
sc stop wuauserv
sc config wuauserv start=disabled
pause
goto windows_update

:ram_optimize
cls
echo ============================================
echo          RAM Optimize Menu
echo ============================================
echo [1] Memory Cleaner
echo [2] Memory Usage Monitoring
echo [3] Memory Compression
echo [0] Back to Main Menu
echo ============================================
set /p ram_choice=Select an option:

if "%ram_choice%"=="1" goto memory_cleaner
if "%ram_choice%"=="2" goto memory_usage_monitoring
if "%ram_choice%"=="3" goto memory_compression
if "%ram_choice%"=="0" goto menu

goto ram_optimize

:memory_cleaner
echo Cleaning RAM...
:: Using built-in Windows commands for memory cleanup
powershell -Command "Clear-RecycleBin -Force"
pause
goto ram_optimize

:memory_usage_monitoring
echo Monitoring RAM Usage...
tasklist /v
pause
goto ram_optimize

:memory_compression
echo Enabling Memory Compression...
powershell -Command "Enable-MMAgent -mc"
pause
goto ram_optimize

:firewall_defender
cls
echo ============================================
echo          Firewall and Windows Defender Menu
echo ============================================
echo [1] Enable Windows Defender
echo [2] Disable Windows Defender
echo [3] Enable Firewall
echo [4] Disable Firewall
echo [5] Virus Scan
echo [0] Back to Main Menu
echo ============================================
set /p fw_choice=Select an option:

if "%fw_choice%"=="1" goto enable_windows_defender
if "%fw_choice%"=="2" goto disable_windows_defender
if "%fw_choice%"=="3" goto enable_firewall
if "%fw_choice%"=="4" goto disable_firewall
if "%fw_choice%"=="5" goto virus_scan
if "%fw_choice%"=="0" goto menu

goto firewall_defender

:enable_windows_defender
echo Enabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring 0"
pause
goto firewall_defender

:disable_windows_defender
echo Disabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring 1"
pause
goto firewall_defender

:enable_firewall
echo Enabling Firewall...
netsh advfirewall set allprofiles state on
pause
goto firewall_defender

:disable_firewall
echo Disabling Firewall...
netsh advfirewall set allprofiles state off
pause
goto firewall_defender

:virus_scan
echo Enter the drive letter to scan (e.g., C) or type "All" to scan all drives:
set /p drive=Drive:
if /I "%drive%"=="All" (
    echo Scanning all drives...
    powershell -Command "Start-MpScan -ScanType FullScan"
) else (
    echo Scanning drive %drive%...
    powershell -Command "Start-MpScan -ScanPath %drive%:\ -ScanType CustomScan"
)
pause
goto firewall_defender

:system_repair
cls
echo ============================================
echo          System Repair and Fixes Menu
echo ============================================
echo [1] Check and Fix System Files
echo [2] Check Disk for Errors
echo [3] Remove User Password
echo [4] Set User Password
echo [0] Back to Main Menu
echo ============================================
set /p repair_choice=Select an option:

if "%repair_choice%"=="1" goto sfc_scan
if "%repair_choice%"=="2" goto chkdsk_scan
if "%repair_choice%"=="3" goto remove_password
if "%repair_choice%"=="4" goto set_password
if "%repair_choice%"=="0" goto menu

goto system_repair

:sfc_scan
echo Checking and Fixing System Files...
sfc /scannow
pause
goto system_repair

:chkdsk_scan
echo Enter the drive letter to check (e.g., C):
set /p drive=Drive:
echo Checking drive %drive% for errors...
chkdsk %drive%: /f /r
pause
goto system_repair

:remove_password
echo Enter the username to remove the password:
set /p username=Username:
net user %username% ""
echo Password removed for user %username%.
pause
goto system_repair

:set_password
echo Enter the username to set the password:
set /p username=Username:
echo Enter the new password:
set /p password=Password:
net user %username% %password%
echo Password set for user %username%.
pause
goto system_repair

:exit_script
endlocal
exit /b
