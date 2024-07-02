@echo off
setlocal enabledelayedexpansion

:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

:menu
cls
echo ==================================================
echo Windows Optimization Script v3.0
echo ==================================================
echo Please select an option:
echo 1. Optimize display performance
echo 2. Manage Windows Defender
echo 3. Optimize system features
echo 4. Optimize CPU performance
echo 5. Optimize Internet performance
echo 6. Manage Windows Update
echo 7. Configure Auto-login
echo 8. Clear system cache
echo 9. Optimize disk
echo 10. Check and repair system files
echo 11. Activate Windows
echo 12. Manage power settings
echo 13. Enable Dark Mode
echo 14. Manage partitions
echo 15. Clean up disk space
echo 16. Manage startup programs
echo 17. Backup and restore settings
echo 18. System information
echo 19. Optimize privacy settings
echo 20. Manage Windows services
echo 21. Network optimization
echo 22. Exit
echo ==================================================
set /p choice=Enter your choice (1-22): 

if "%choice%"=="1" goto optimize_display
if "%choice%"=="2" goto manage_defender
if "%choice%"=="3" goto optimize_features
if "%choice%"=="4" goto optimize_cpu
if "%choice%"=="5" goto optimize_internet
if "%choice%"=="6" goto windows_update
if "%choice%"=="7" goto auto_login
if "%choice%"=="8" goto clear_cache
if "%choice%"=="9" goto optimize_disk
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
echo Invalid choice. Please try again.
pause
goto menu

:optimize_display
echo Optimizing display performance...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo Display performance optimized.
pause
goto menu

:manage_defender
echo Windows Defender Management
echo 1. Disable Windows Defender
echo 2. Enable Windows Defender
echo 3. Update Windows Defender
echo 4. Run quick scan
set /p def_choice=Enter your choice (1-4): 
if "%def_choice%"=="1" goto disable_defender
if "%def_choice%"=="2" goto enable_defender
if "%def_choice%"=="3" goto update_defender
if "%def_choice%"=="4" goto quick_scan
goto menu

:disable_defender
echo Disabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" 2>nul
if %errorlevel% neq 0 (
    echo Failed to disable Windows Defender. Please check your permissions.
) else (
    echo Windows Defender disabled.
)
pause
goto menu

:enable_defender
echo Enabling Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" 2>nul
if %errorlevel% neq 0 (
    echo Failed to enable Windows Defender. Please check your permissions.
) else (
    echo Windows Defender enabled.
)
pause
goto menu

:update_defender
echo Updating Windows Defender...
powershell -Command "Update-MpSignature" 2>nul
if %errorlevel% neq 0 (
    echo Failed to update Windows Defender. Please check your internet connection.
) else (
    echo Windows Defender updated.
)
pause
goto menu

:quick_scan
echo Running quick scan...
powershell -Command "Start-MpScan -ScanType QuickScan" 2>nul
if %errorlevel% neq 0 (
    echo Failed to start quick scan. Please check your permissions.
) else (
    echo Quick scan initiated. Please wait for it to complete.
)
pause
goto menu

:optimize_features
echo Optimizing system features...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f
echo System features optimized.
pause
goto menu

:optimize_cpu
echo Optimizing CPU performance...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setactive scheme_current
echo CPU performance optimized.
pause
goto menu

:optimize_internet
echo Optimizing Internet performance...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global rss=enabled
ipconfig /flushdns
echo Internet performance optimized.
pause
goto menu

:windows_update
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
set /p update_choice=Enter your choice (1-3): 
if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
goto menu

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% neq 0 (
    echo Failed to enable Windows Update. Please check your permissions.
) else (
    echo Windows Update enabled.
)
pause
goto menu

:disable_windows_update
echo Disabling Windows Update...
sc config wuauserv start= disabled
sc stop wuauserv
if %errorlevel% neq 0 (
    echo Failed to disable Windows Update. Please check your permissions.
) else (
    echo Windows Update disabled.
)
pause
goto menu

:check_updates
echo Checking for Windows updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated. Please check Windows Update in Settings for results.
pause
goto menu

:auto_login
echo Configuring Auto-login...
set /p username=Enter username: 
set /p password=Enter password: 
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%username%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%password%" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f
echo Auto-login configured.
pause
goto menu

:clear_cache
echo Clearing system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo System cache cleared.
pause
goto menu

:optimize_disk
echo Optimizing disk...
defrag C: /O
echo Disk optimized.
pause
goto menu

:check_repair
echo Checking and repairing system files...
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
echo System file check and repair completed.
pause
goto menu

:windows_activate
echo Activating Windows...
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
echo Windows activation attempted.
pause
goto menu

:manage_power
echo Power Settings Management
echo 1. Disable Sleep and Hibernate
echo 2. Enable Sleep and Hibernate
echo 3. Set power plan to High Performance
set /p power_choice=Enter your choice (1-3): 
if "%power_choice%"=="1" goto disable_sleep
if "%power_choice%"=="2" goto enable_sleep
if "%power_choice%"=="3" goto high_performance
goto menu

:disable_sleep
echo Disabling Sleep and Hibernate...
powercfg -h off
powercfg -change -monitor-timeout-ac 0
powercfg -change -standby-timeout-ac 0
echo Sleep and Hibernate disabled.
pause
goto menu

:enable_sleep
echo Enabling Sleep and Hibernate...
powercfg -h on
powercfg -change -monitor-timeout-ac 10
powercfg -change -standby-timeout-ac 30
echo Sleep and Hibernate enabled.
pause
goto menu

:high_performance
echo Setting power plan to High Performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Power plan set to High Performance.
pause
goto menu

:enable_dark_mode
echo Enabling Dark Mode...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
echo Dark Mode enabled.
pause
goto menu

:manage_partitions
echo Partition Management
echo 1. List Partitions
echo 2. Create Partition
echo 3. Delete Partition
echo 4. Format Partition
set /p part_choice=Enter your choice (1-4): 
if "%part_choice%"=="1" goto list_partitions
if "%part_choice%"=="2" goto create_partition
if "%part_choice%"=="3" goto delete_partition
if "%part_choice%"=="4" goto format_partition
goto menu

:list_partitions
echo Listing Partitions...
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
pause
goto manage_partitions

:create_partition
echo Creating Partition...
set /p disk_num=Enter disk number: 
set /p part_size=Enter partition size in MB: 
(
echo select disk %disk_num%
echo create partition primary size=%part_size%
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo Partition created.
pause
goto manage_partitions

:delete_partition
echo Deleting Partition...
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
(
echo select disk %disk_num%
echo select partition %part_num%
echo delete partition override
) > delete_part.txt
diskpart /s delete_part.txt
del delete_part.txt
echo Partition deleted.
pause
goto manage_partitions

:format_partition
echo Formatting Partition...
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
set /p fs=Enter file system (NTFS/FAT32): 
(
echo select disk %disk_num%
echo select partition %part_num%
echo format fs=%fs% quick
) > format_part.txt
diskpart /s format_part.txt
del format_part.txt
echo Partition formatted.
pause
goto manage_partitions

:clean_disk
echo Cleaning up disk space...
cleanmgr /sagerun:1
echo Disk cleanup completed.
pause
goto menu

:manage_startup
echo Managing startup programs...
start msconfig
echo Please use the System Configuration utility to manage startup programs.
pause
goto menu

:backup_restore
echo Backup and Restore Settings
echo 1. Create system restore point
echo 2. Restore from a restore point
set /p backup_choice=Enter your choice (1-2): 
if "%backup_choice%"=="1" goto create_restore
if "%backup_choice%"=="2" goto restore_point
goto menu

:create_restore
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo System restore point created.
pause
goto menu

:restore_point
echo Restoring from a restore point...
rstrui.exe
echo Please follow the on-screen instructions to restore your system.
pause
goto menu

:system_info
echo Displaying system information...
systeminfo
pause
goto menu

:optimize_privacy
echo Optimizing privacy settings...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
echo Privacy settings optimized.
pause
goto menu

:manage_services
cls
echo ==================================================
echo Windows Services Management
echo ==================================================
echo 1. List all services
echo 2. List running services
echo 3. List stopped services
echo 4. Start a service
echo 5. Stop a service
echo 6. Restart a service
echo 7. Change service startup type
echo 8. Search for a service
echo 9. View service details
echo 10. Return to main menu
echo ==================================================
set /p service_choice=Enter your choice (1-10): 

if "%service_choice%"=="1" goto list_all_services
if "%service_choice%"=="2" goto list_running_services
if "%service_choice%"=="3" goto list_stopped_services
if "%service_choice%"=="4" goto start_service
if "%service_choice%"=="5" goto stop_service
if "%service_choice%"=="6" goto restart_service
if "%service_choice%"=="7" goto change_startup_type
if "%service_choice%"=="8" goto search_service
if "%service_choice%"=="9" goto view_service_details
if "%service_choice%"=="10" goto menu
echo Invalid choice. Please try again.
pause
goto manage_services

:list_all_services
echo Listing all services...
sc query type= service state= all
pause
goto manage_services

:list_running_services
echo Listing running services...
sc query type= service state= running
pause
goto manage_services

:list_stopped_services
echo Listing stopped services...
sc query type= service state= stopped
pause
goto manage_services

:start_service
set /p service_name=Enter the name of the service to start: 
sc start %service_name%
if %errorlevel% neq 0 (
    echo Failed to start the service. Please check the service name and your permissions.
) else (
    echo Service start attempted. Please check the status.
)
pause
goto manage_services

:stop_service
set /p service_name=Enter the name of the service to stop: 
sc stop %service_name%
if %errorlevel% neq 0 (
    echo Failed to stop the service. Please check the service name and your permissions.
) else (
    echo Service stop attempted. Please check the status.
)
pause
goto manage_services

:restart_service
set /p service_name=Enter the name of the service to restart: 
sc stop %service_name%
timeout /t 2 >nul
sc start %service_name%
if %errorlevel% neq 0 (
    echo Failed to restart the service. Please check the service name and your permissions.
) else (
    echo Service restart attempted. Please check the status.
)
pause
goto manage_services

:change_startup_type
set /p service_name=Enter the name of the service: 
echo Select startup type:
echo 1. Automatic
echo 2. Manual
echo 3. Disabled
set /p startup_choice=Enter your choice (1-3): 
if "%startup_choice%"=="1" (
    sc config %service_name% start= auto
) else if "%startup_choice%"=="2" (
    sc config %service_name% start= demand
) else if "%startup_choice%"=="3" (
    sc config %service_name% start= disabled
) else (
    echo Invalid choice.
    pause
    goto manage_services
)
if %errorlevel% neq 0 (
    echo Failed to change startup type. Please check the service name and your permissions.
) else (
    echo Startup type changed successfully.
)
pause
goto manage_services

:search_service
set /p search_term=Enter search term for service name: 
sc query state= all | findstr /i "%search_term%"
pause
goto manage_services

:view_service_details
set /p service_name=Enter the name of the service to view details: 
sc qc %service_name%
pause
goto manage_services

network_optimization
echo Optimizing network settings...
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set global rss=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
echo Network settings optimized.
pause
goto menu

:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 3.0
pause
exit
