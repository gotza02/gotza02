@echo off
setlocal enabledelayedexpansion

:: Set log file path
set "log_file=%~dp0optimization_log.txt"

:: Function to log actions
:log_action
echo [%date% %time%] %~1>>"%log_file%"
goto :eof

:: Check for administrator privileges
:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

:: Initialize script
call :check_admin
:: Clear log file
break > "%log_file%"

:menu
cls
echo ==================================================
echo      Windows Optimization Script v4.1
echo      Log file: %log_file%
echo ==================================================
echo Please select an option:
echo   1. Optimize display performance
echo   2. Manage Windows Defender
echo   3. Optimize system features
echo   4. Optimize CPU performance
echo   5. Optimize Internet performance
echo   6. Manage Windows Update
echo   7. Configure Auto-login
echo   8. Clear system cache
echo   9. Optimize disk
echo  10. Check and repair system files
echo  11. Activate Windows
echo  12. Manage power settings
echo  13. Enable Dark Mode
echo  14. Manage partitions
echo  15. Clean up disk space
echo  16. Manage startup programs
echo  17. Backup and restore settings
echo  18. System information
echo  19. Optimize privacy settings
echo  20. Manage Windows services
echo  21. Network optimization
echo  22. Exit
echo ==================================================
set /p "choice=Enter your choice (1-22): "

if "%choice%"=="1"  goto optimize_display
if "%choice%"=="2"  goto manage_defender
if "%choice%"=="3"  goto optimize_features
if "%choice%"=="4"  goto optimize_cpu
if "%choice%"=="5"  goto optimize_internet
if "%choice%"=="6"  goto windows_update
if "%choice%"=="7"  goto auto_login
if "%choice%"=="8"  goto clear_cache
if "%choice%"=="9"  goto optimize_disk
if "%choice%"=="10" goto check_repair
if "%choice%"=="11" goto windows_activate
if "%choice%"=="12" goto manage_power
if "%choice%"=="13" goto enable_dark_mode
if "%choice%"=="14" goto manage_partitions
if "%choice%"=="15" goto clean_disk
if "%choice%"=="16" goto manage_startup
if "%choice%"=="17" goto backup_restore
if "%choice%"=="18" goto system_info
if "%choice%"=="19" goto optimize_privacy
if "%choice%"=="20" goto manage_services
if "%choice%"=="21" goto network_optimization
if "%choice%"=="22" goto endexit

:: Invalid choice handling
echo Invalid choice. Please try again.
pause
goto menu

:optimize_display
echo Optimizing display performance...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul
echo Display performance optimized.
call :log_action "Display optimized"
pause
goto menu

:manage_defender
cls
echo ===================================================
echo           Windows Defender Management
echo ===================================================
echo   1. Check Windows Defender status
echo   2. Enable Windows Defender
echo   3. Disable Windows Defender
echo   4. Update Windows Defender
echo   5. Run quick scan
echo   6. Run full scan
echo   7. Manage real-time protection
echo   8. Manage cloud-delivered protection
echo   9. Manage automatic sample submission
echo  10. View threat history
echo  11. Return to main menu
echo ===================================================
set /p "def_choice=Enter your choice (1-11): "

if "%def_choice%"=="1"  goto check_defender
if "%def_choice%"=="2"  goto enable_defender
if "%def_choice%"=="3"  goto disable_defender
if "%def_choice%"=="4"  goto update_defender
if "%def_choice%"=="5"  goto quick_scan
if "%def_choice%"=="6"  goto full_scan
if "%def_choice%"=="7"  goto manage_realtime
if "%def_choice%"=="8"  goto manage_cloud
if "%def_choice%"=="9"  goto manage_samples
if "%def_choice%"=="10" goto manage_defender
if "%def_choice%"=="11" goto menu

echo Invalid choice. Please try again.
pause
goto manage_defender

:check_defender
echo Checking Windows Defender status...
sc query windefend | findstr /i "STATE"
call :log_action "Checked Windows Defender status"
pause
goto manage_defender

:enable_defender
echo Enabling Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f >nul
echo Windows Defender enabled.
call :log_action "Windows Defender enabled"
pause
goto manage_defender

:disable_defender
echo WARNING: Disabling Windows Defender may leave your system vulnerable.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul
echo Windows Defender disabled.
call :log_action "Windows Defender disabled"
pause
goto manage_defender

:update_defender
echo Updating Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo Windows Defender updated successfully.
    call :log_action "Windows Defender updated"
) else (
    echo Failed to update Windows Defender.
    call :log_action "Failed to update Windows Defender"
)
pause
goto manage_defender

:quick_scan
echo Running quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo Quick scan completed.
call :log_action "Quick scan completed"
pause
goto manage_defender

:full_scan
echo Running full scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo Full scan initiated.
call :log_action "Full scan initiated"
pause
goto manage_defender

:optimize_features
echo Optimizing system features...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul
echo System features optimized.
call :log_action "System features optimized"
pause
goto menu

:optimize_cpu
cls
echo ==================================================
echo                CPU Optimization
echo ==================================================
echo   1. Set High Performance power plan
echo   2. Disable CPU throttling
echo   3. Optimize processor scheduling
echo   4. Disable CPU core parking
echo   5. Adjust processor power management
echo   6. Enable hardware-accelerated GPU scheduling
echo   7. Return to main menu
echo ==================================================
set /p "cpu_choice=Enter your choice (1-7): "

if "%cpu_choice%"=="1" goto set_high_performance
if "%cpu_choice%"=="2" goto disable_throttling
if "%cpu_choice%"=="3" goto optimize_scheduling
if "%cpu_choice%"=="4" goto disable_core_parking
if "%cpu_choice%"=="5" goto adjust_power_management
if "%cpu_choice%"=="6" goto enable_gpu_scheduling
if "%cpu_choice%"=="7" goto menu

echo Invalid choice. Please try again.
pause
goto optimize_cpu

:set_high_performance
echo Setting High Performance power plan...
powercfg -setactive SCHEME_MIN
if %errorlevel% neq 0 (
    echo Failed to set High Performance power plan.
    call :log_action "Failed to set High Performance power plan"
) else (
    echo High Performance power plan set.
    call :log_action "High Performance power plan set"
)
pause
goto optimize_cpu

:disable_throttling
echo Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul
powercfg -setactive scheme_current
echo CPU throttling disabled.
call :log_action "CPU throttling disabled"
pause
goto optimize_cpu

:optimize_scheduling
echo Optimizing processor scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul
echo Processor scheduling optimized.
call :log_action "Processor scheduling optimized"
pause
goto optimize_cpu

:disable_core_parking
echo Disabling CPU core parking...
for /f "tokens=2*" %%a in ('powercfg -list ^| findstr /i "scheme_current"') do set "scheme_guid=%%b"
powercfg -setacvalueindex %scheme_guid% sub_processor CPMINCORES 100 >nul
powercfg -setactive %scheme_guid%
echo CPU core parking disabled.
call :log_action "CPU core parking disabled"
pause
goto optimize_cpu

:adjust_power_management
echo Adjusting processor power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul
echo Processor power management adjusted.
call :log_action "Processor power management adjusted"
pause
goto optimize_cpu

:enable_gpu_scheduling
echo Enabling hardware-accelerated GPU scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul
echo Hardware-accelerated GPU scheduling enabled.
call :log_action "Hardware-accelerated GPU scheduling enabled"
pause
goto optimize_cpu

:optimize_internet
cls
echo ==================================================
echo        Internet Performance Optimization
echo ==================================================
echo   1. Basic optimizations
echo   2. Advanced TCP optimizations
echo   3. DNS optimization
echo   4. Network adapter tuning
echo   5. Clear network cache
echo   6. Return to main menu
echo ==================================================
set /p "net_choice=Enter your choice (1-6): "

if "%net_choice%"=="1" goto basic_optimizations
if "%net_choice%"=="2" goto advanced_tcp
if "%net_choice%"=="3" goto dns_optimization
if "%net_choice%"=="4" goto adapter_tuning
if "%net_choice%"=="5" goto clear_network_cache
if "%net_choice%"=="6" goto menu

echo Invalid choice. Please try again.
pause
goto optimize_internet

:basic_optimizations
echo Performing basic Internet optimizations...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global dca=enabled >nul
netsh int tcp set global netdma=enabled >nul
netsh int tcp set global rss=enabled >nul
echo Basic Internet optimizations completed.
call :log_action "Basic Internet optimizations completed"
pause
goto optimize_internet

:advanced_tcp
echo Performing advanced TCP optimizations...
netsh int tcp set global congestionprovider=ctcp >nul
netsh int tcp set global ecncapability=enabled >nul
netsh int tcp set heuristics disabled >nul
echo Advanced TCP optimizations completed.
call :log_action "Advanced TCP optimizations completed"
pause
goto optimize_internet

:dns_optimization
echo Optimizing DNS settings...
ipconfig /flushdns
netsh int ip set dns name="Local Area Connection" source=static addr=8.8.8.8 register=PRIMARY >nul
netsh int ip add dns name="Local Area Connection" addr=8.8.4.4 index=2 >nul
echo DNS optimization completed.
call :log_action "DNS optimization completed"
pause
goto optimize_internet

:adapter_tuning
echo Tuning network adapter...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent >nul
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent >nul
)
echo Network adapter tuning completed.
call :log_action "Network adapter tuning completed"
pause
goto optimize_internet

:clear_network_cache
echo Clearing network cache...
ipconfig /flushdns
arp -d *
nbtstat -R
nbtstat -RR
netsh int ip reset >nul
netsh winsock reset >nul
echo Network cache cleared.
call :log_action "Network cache cleared"
pause
goto optimize_internet

:windows_update
cls
echo ==================================================
echo          Windows Update Management
echo ==================================================
echo   1. Enable Windows Update
echo   2. Disable Windows Update
echo   3. Check for updates
echo   4. Return to main menu
echo ==================================================
set /p "update_choice=Enter your choice (1-4): "

if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
if "%update_choice%"=="4" goto menu

echo Invalid choice. Please try again.
pause
goto windows_update

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start= auto >nul
sc start wuauserv >nul
if %errorlevel% neq 0 (
    echo Failed to enable Windows Update.
    call :log_action "Failed to enable Windows Update"
) else (
    echo Windows Update enabled.
    call :log_action "Windows Update enabled"
)
pause
goto windows_update

:disable_windows_update
echo Disabling Windows Update...
sc config wuauserv start= disabled >nul
sc stop wuauserv >nul
if %errorlevel% neq 0 (
    echo Failed to disable Windows Update.
    call :log_action "Failed to disable Windows Update"
) else (
    echo Windows Update disabled.
    call :log_action "Windows Update disabled"
)
pause
goto windows_update

:check_updates
echo Checking for Windows updates...
powershell -Command "Get-WindowsUpdate"
echo Update check initiated. Please check Windows Update in Settings.
call :log_action "Windows Update check initiated"
pause
goto windows_update

:auto_login
echo Configuring Auto-login...
set /p "username=Enter username: "
set /p "password=Enter password: "
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%username%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%password%" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f >nul
echo Auto-login configured.
call :log_action "Auto-login configured"
pause
goto menu

:clear_cache
echo Clearing system cache...
del /q /f "%TEMP%\*" 2>nul
del /q /f "C:\Windows\Temp\*" 2>nul
echo System cache cleared.
call :log_action "System cache cleared"
pause
goto menu

:optimize_disk
cls
echo ==================================================
echo               Disk Optimization
echo ==================================================
echo   1. Analyze disk
echo   2. Optimize/Defragment disk
echo   3. Check disk for errors
echo   4. Trim SSD
echo   5. Clean up system files
echo   6. Return to main menu
echo ==================================================
set /p "disk_choice=Enter your choice (1-6): "

if "%disk_choice%"=="1" goto analyze_disk
if "%disk_choice%"=="2" goto optimize_defrag
if "%disk_choice%"=="3" goto check_disk
if "%disk_choice%"=="4" goto trim_ssd
if "%disk_choice%"=="5" goto cleanup_system
if "%disk_choice%"=="6" goto menu

echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk
echo Analyzing disk...
defrag C: /A
echo Disk analysis completed.
call :log_action "Disk analysis completed"
pause
goto optimize_disk

:optimize_defrag
echo Optimizing/Defragmenting disk...
defrag C: /O
echo Disk optimization completed.
call :log_action "Disk optimization completed"
pause
goto optimize_disk

:check_disk
echo Checking disk for errors...
echo This operation may require a restart.
chkdsk C: /F /R
echo Disk check scheduled. Please restart your computer.
call :log_action "Disk check scheduled"
pause
goto optimize_disk

:trim_ssd
echo Trimming SSD...
fsutil behavior set disabledeletenotify 0
defrag C: /L
echo SSD trim completed.
call :log_action "SSD trim completed"
pause
goto optimize_disk

:cleanup_system
echo Cleaning up system files...
cleanmgr /sagerun:1
echo System file cleanup completed.
call :log_action "System file cleanup completed"
pause
goto optimize_disk

:check_repair
cls
echo ==================================================
echo         Check and Repair System Files
echo ==================================================
echo   1. Run SFC (System File Checker)
echo   2. Run DISM (Deployment Image Servicing and Management)
echo   3. Check disk health
echo   4. Return to main menu
echo ==================================================
set /p "repair_choice=Enter your choice (1-4): "

if "%repair_choice%"=="1" goto run_sfc
if "%repair_choice%"=="2" goto run_dism
if "%repair_choice%"=="3" goto check_disk_health
if "%repair_choice%"=="4" goto menu

echo Invalid choice. Please try again.
pause
goto check_repair

:run_sfc
echo Running System File Checker...
sfc /scannow
echo SFC scan completed.
call :log_action "SFC scan completed"
pause
goto check_repair

:run_dism
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM repair completed.
call :log_action "DISM repair completed"
pause
goto check_repair

:check_disk_health
echo Checking disk health...
wmic diskdrive get model,status
echo Disk health check completed.
call :log_action "Disk health check completed"
pause
goto check_repair

:windows_activate
:: Activation code remains unchanged as per your request
:: [Activate Windows code here]

:manage_power
cls
echo ==================================================
echo         Power Settings Management
echo ==================================================
echo   1. List all power plans
echo   2. Set power plan
echo   3. Create custom power plan
echo   4. Delete power plan
echo   5. Adjust sleep settings
echo   6. Configure hibernation
echo   7. Adjust display and sleep timeouts
echo   8. Configure lid close action
echo   9. Configure power button action
echo  10. Return to main menu
echo ==================================================
set /p "power_choice=Enter your choice (1-10): "

if "%power_choice%"=="1"  goto list_power_plans
if "%power_choice%"=="2"  goto set_power_plan
if "%power_choice%"=="3"  goto create_power_plan
if "%power_choice%"=="4"  goto delete_power_plan
if "%power_choice%"=="5"  goto adjust_sleep
if "%power_choice%"=="6"  goto configure_hibernate
if "%power_choice%"=="7"  goto adjust_timeouts
if "%power_choice%"=="8"  goto lid_action
if "%power_choice%"=="9"  goto power_button_action
if "%power_choice%"=="10" goto menu

echo Invalid choice. Please try again.
pause
goto manage_power

:list_power_plans
echo Listing all power plans...
powercfg /list
call :log_action "Listed all power plans"
pause
goto manage_power

:set_power_plan
echo Available power plans:
powercfg /list
set /p "plan_guid=Enter the GUID of the power plan you want to set: "
powercfg /setactive %plan_guid%
if %errorlevel% neq 0 (
    echo Failed to set power plan.
    call :log_action "Failed to set power plan"
) else (
    echo Power plan set successfully.
    call :log_action "Power plan set"
)
pause
goto manage_power

:create_power_plan
set /p "plan_name=Enter a name for the new power plan: "
powercfg /duplicatescheme SCHEME_BALANCED "%plan_name%"
if %errorlevel% neq 0 (
    echo Failed to create power plan.
    call :log_action "Failed to create power plan"
) else (
    echo Power plan created successfully.
    call :log_action "Power plan created"
)
pause
goto manage_power

:delete_power_plan
echo Available power plans:
powercfg /list
set /p "del_guid=Enter the GUID of the power plan you want to delete: "
powercfg /delete %del_guid%
if %errorlevel% neq 0 (
    echo Failed to delete power plan.
    call :log_action "Failed to delete power plan"
) else (
    echo Power plan deleted successfully.
    call :log_action "Power plan deleted"
)
pause
goto manage_power

:adjust_sleep
set /p "sleep_time=Enter the number of minutes before the system goes to sleep (0 to never sleep): "
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo Sleep settings adjusted.
call :log_action "Sleep settings adjusted"
pause
goto manage_power

:configure_hibernate
echo   1. Enable hibernation
echo   2. Disable hibernation
set /p "hib_choice=Enter your choice (1-2): "
if "%hib_choice%"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
    call :log_action "Hibernation enabled"
) else if "%hib_choice%"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
    call :log_action "Hibernation disabled"
) else (
    echo Invalid choice.
)
pause
goto manage_power

:adjust_timeouts
set /p "display_ac=Enter minutes before turning off the display (AC power): "
set /p "display_dc=Enter minutes before turning off the display (battery): "
set /p "sleep_ac=Enter minutes before sleep (AC power): "
set /p "sleep_dc=Enter minutes before sleep (battery): "
powercfg /change monitor-timeout-ac %display_ac%
powercfg /change monitor-timeout-dc %display_dc%
powercfg /change standby-timeout-ac %sleep_ac%
powercfg /change standby-timeout-dc %sleep_dc%
echo Display and sleep timeouts adjusted.
call :log_action "Display and sleep timeouts adjusted"
pause
goto manage_power

:lid_action
echo   1. Do nothing
echo   2. Sleep
echo   3. Hibernate
echo   4. Shut down
set /p "lid_choice=Enter your choice for lid close action (1-4): "
if "%lid_choice%"=="1" set "action=0"
if "%lid_choice%"=="2" set "action=1"
if "%lid_choice%"=="3" set "action=2"
if "%lid_choice%"=="4" set "action=3"
powercfg /setacvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setactive scheme_current
echo Lid close action configured.
call :log_action "Lid close action configured"
pause
goto manage_power

:power_button_action
echo   1. Do nothing
echo   2. Sleep
echo   3. Hibernate
echo   4. Shut down
set /p "button_choice=Enter your choice for power button action (1-4): "
if "%button_choice%"=="1" set "action=0"
if "%button_choice%"=="2" set "action=1"
if "%button_choice%"=="3" set "action=2"
if "%button_choice%"=="4" set "action=3"
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setactive scheme_current
echo Power button action configured.
call :log_action "Power button action configured"
pause
goto manage_power

:enable_dark_mode
echo Enabling Dark Mode...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f >nul
echo Dark Mode enabled.
call :log_action "Dark Mode enabled"
pause
goto menu

:manage_partitions
cls
echo ==================================================
echo             Partition Management
echo ==================================================
echo   1. List Partitions
echo   2. Create Partition
echo   3. Delete Partition
echo   4. Format Partition
echo   5. Return to main menu
echo ==================================================
set /p "part_choice=Enter your choice (1-5): "

if "%part_choice%"=="1" goto list_partitions
if "%part_choice%"=="2" goto create_partition
if "%part_choice%"=="3" goto delete_partition
if "%part_choice%"=="4" goto format_partition
if "%part_choice%"=="5" goto menu

echo Invalid choice. Please try again.
pause
goto manage_partitions

:list_partitions
echo Listing Partitions...
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
call :log_action "Listed partitions"
pause
goto manage_partitions

:create_partition
echo Creating Partition...
set /p "disk_num=Enter disk number: "
set /p "part_size=Enter partition size in MB: "
(
    echo select disk %disk_num%
    echo create partition primary size=%part_size%
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo Partition created.
call :log_action "Created partition"
pause
goto manage_partitions

:delete_partition
echo Deleting Partition...
set /p "disk_num=Enter disk number: "
set /p "part_num=Enter partition number: "
(
    echo select disk %disk_num%
    echo select partition %part_num%
    echo delete partition override
) > delete_part.txt
diskpart /s delete_part.txt
del delete_part.txt
echo Partition deleted.
call :log_action "Deleted partition"
pause
goto manage_partitions

:format_partition
echo Formatting Partition...
set /p "disk_num=Enter disk number: "
set /p "part_num=Enter partition number: "
set /p "fs=Enter file system (NTFS/FAT32): "
(
    echo select disk %disk_num%
    echo select partition %part_num%
    echo format fs=%fs% quick
) > format_part.txt
diskpart /s format_part.txt
del format_part.txt
echo Partition formatted.
call :log_action "Formatted partition"
pause
goto manage_partitions

:clean_disk
echo Cleaning up disk space...
cleanmgr /sagerun:1
echo Disk cleanup completed.
call :log_action "Disk cleanup completed"
pause
goto menu

:manage_startup
echo Managing startup programs...
start msconfig
echo Please use the System Configuration utility to manage startup programs.
call :log_action "Startup programs managed"
pause
goto menu

:backup_restore
echo Backup and Restore Settings
echo   1. Create system restore point
echo   2. Restore from a restore point
echo   3. Return to main menu
set /p "backup_choice=Enter your choice (1-3): "
if "%backup_choice%"=="1" goto create_restore
if "%backup_choice%"=="2" goto restore_point
if "%backup_choice%"=="3" goto menu

echo Invalid choice. Please try again.
pause
goto backup_restore

:create_restore
echo Creating system restore point...
powershell -Command "Checkpoint-Computer -Description 'Manual Restore Point' -RestorePointType 'MODIFY_SETTINGS'"
echo System restore point created.
call :log_action "System restore point created"
pause
goto backup_restore

:restore_point
echo Restoring from a restore point...
rstrui.exe
call :log_action "System restored from a restore point"
pause
goto backup_restore

:system_info
echo Displaying system information...
systeminfo | more
call :log_action "Displayed system information"
pause
goto menu

:optimize_privacy
echo Optimizing privacy settings...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
echo Privacy settings optimized.
call :log_action "Privacy settings optimized"
pause
goto menu

:manage_services
cls
echo ==================================================
echo         Windows Services Management
echo ==================================================
echo   1. List all services
echo   2. List running services
echo   3. List stopped services
echo   4. Start a service
echo   5. Stop a service
echo   6. Restart a service
echo   7. Change service startup type
echo   8. Search for a service
echo   9. View service details
echo  10. Return to main menu
echo ==================================================
set /p "service_choice=Enter your choice (1-10): "

if "%service_choice%"=="1"  goto list_all_services
if "%service_choice%"=="2"  goto list_running_services
if "%service_choice%"=="3"  goto list_stopped_services
if "%service_choice%"=="4"  goto start_service
if "%service_choice%"=="5"  goto stop_service
if "%service_choice%"=="6"  goto restart_service
if "%service_choice%"=="7"  goto change_startup_type
if "%service_choice%"=="8"  goto search_service
if "%service_choice%"=="9"  goto view_service_details
if "%service_choice%"=="10" goto menu

echo Invalid choice. Please try again.
pause
goto manage_services

:list_all_services
echo Listing all services...
sc query type= service state= all | more
call :log_action "Listed all services"
pause
goto manage_services

:list_running_services
echo Listing running services...
sc query type= service state= running | more
call :log_action "Listed running services"
pause
goto manage_services

:list_stopped_services
echo Listing stopped services...
sc query type= service state= inactive | more
call :log_action "Listed stopped services"
pause
goto manage_services

:start_service
set /p "service_name=Enter the name of the service to start: "
sc start "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to start the service.
    call :log_action "Failed to start service"
) else (
    echo Service start attempted.
    call :log_action "Service start attempted"
)
pause
goto manage_services

:stop_service
set /p "service_name=Enter the name of the service to stop: "
sc stop "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to stop the service.
    call :log_action "Failed to stop service"
) else (
    echo Service stop attempted.
    call :log_action "Service stop attempted"
)
pause
goto manage_services

:restart_service
set /p "service_name=Enter the name of the service to restart: "
sc stop "%service_name%"
timeout /t 2 >nul
sc start "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to restart the service.
    call :log_action "Failed to restart service"
) else (
    echo Service restart attempted.
    call :log_action "Service restart attempted"
)
pause
goto manage_services

:change_startup_type
set /p "service_name=Enter the name of the service: "
echo Select startup type:
echo   1. Automatic
echo   2. Automatic (Delayed Start)
echo   3. Manual
echo   4. Disabled
set /p "startup_choice=Enter your choice (1-4): "
if "%startup_choice%"=="1" (
    sc config "%service_name%" start= auto
) else if "%startup_choice%"=="2" (
    sc config "%service_name%" start= delayed-auto
) else if "%startup_choice%"=="3" (
    sc config "%service_name%" start= demand
) else if "%startup_choice%"=="4" (
    sc config "%service_name%" start= disabled
) else (
    echo Invalid choice.
    pause
    goto manage_services
)
if %errorlevel% neq 0 (
    echo Failed to change startup type.
    call :log_action "Failed to change startup type"
) else (
    echo Startup type changed successfully.
    call :log_action "Startup type changed successfully"
)
pause
goto manage_services

:search_service
set /p "search_term=Enter search term for service name: "
sc query state= all | findstr /i "%search_term%"
call :log_action "Searched for service"
pause
goto manage_services

:view_service_details
set /p "service_name=Enter the name of the service to view details: "
sc qc "%service_name%"
echo.
echo Current Status:
sc query "%service_name%"
call :log_action "Viewed service details for %service_name%"
pause
goto manage_services

:network_optimization
cls
echo ==================================================
echo             Network Optimization
echo ==================================================
echo   1. Optimize TCP settings
echo   2. Reset Windows Sockets
echo   3. Clear DNS cache
echo   4. Optimize network adapter settings
echo   5. Disable IPv6 (caution)
echo   6. Enable QoS packet scheduler
echo   7. Set static DNS servers
echo   8. Reset all network settings
echo   9. Return to main menu
echo ==================================================
set /p "net_choice=Enter your choice (1-9): "

if "%net_choice%"=="1" goto optimize_tcp
if "%net_choice%"=="2" goto reset_winsock
if "%net_choice%"=="3" goto clear_dns
if "%net_choice%"=="4" goto optimize_adapter
if "%net_choice%"=="5" goto disable_ipv6
if "%net_choice%"=="6" goto enable_qos
if "%net_choice%"=="7" goto set_static_dns
if "%net_choice%"=="8" goto reset_network
if "%net_choice%"=="9" goto menu

echo Invalid choice. Please try again.
pause
goto network_optimization

:optimize_tcp
echo Optimizing TCP settings...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global congestionprovider=ctcp >nul
netsh int tcp set global ecncapability=enabled >nul
netsh int tcp set heuristics disabled >nul
call :log_action "TCP settings optimized"
echo TCP settings optimized.
pause
goto network_optimization

:reset_winsock
echo Resetting Windows Sockets...
netsh winsock reset
call :log_action "Windows Sockets reset"
echo Windows Sockets reset. Please restart your computer.
pause
goto network_optimization

:clear_dns
echo Clearing DNS cache...
ipconfig /flushdns
call :log_action "DNS cache cleared"
echo DNS cache cleared.
pause
goto network_optimization

:optimize_adapter
echo Optimizing network adapter settings...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ipv4 set subinterface "%%j" mtu=1500 store=persistent
)
call :log_action "Network adapter settings optimized"
echo Network adapter settings optimized.
pause
goto network_optimization

:disable_ipv6
echo WARNING: Disabling IPv6 may cause issues with some networks.
set /p "confirm=Are you sure you want to disable IPv6? (Y/N): "
if /i "%confirm%"=="Y" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0xff /f
    call :log_action "IPv6 disabled"
    echo IPv6 disabled. Please restart your computer for changes to take effect.
) else (
    echo Operation cancelled.
)
pause
goto network_optimization

:enable_qos
echo Enabling QoS packet scheduler...
sc config "QWAVE" start= auto >nul
net start QWAVE >nul
call :log_action "QoS packet scheduler enabled"
echo QoS packet scheduler enabled.
pause
goto network_optimization

:set_static_dns
echo Setting static DNS servers...
set /p "primary_dns=Enter primary DNS server (e.g., 8.8.8.8): "
set /p "secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4): "
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%j" static %primary_dns% primary
    netsh interface ip add dns "%%j" %secondary_dns% index=2
)
call :log_action "Static DNS servers set"
echo Static DNS servers set.
pause
goto network_optimization

:reset_network
echo Resetting all network settings...
netsh winsock reset
netsh int ip reset
netsh advfirewall reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
call :log_action "All network settings reset"
echo All network settings reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:endexit
echo Thank you for using the Windows Optimization Script!
call :log_action "Script terminated by user"
pause
exit
