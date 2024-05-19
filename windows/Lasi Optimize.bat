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
echo [13] Backup and Restore
echo [14] Disk Management
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
if "%choice%"=="13" goto backup_restore
if "%choice%"=="14" goto disk_management
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
echo [4] Defragment and Optimize Drives
echo [5] Temporary Files Cleaner
echo [0] Back to Main Menu
echo ============================================
set /p sys_choice=Select an option:

if "%sys_choice%"=="1" goto disk_cleanup
if "%sys_choice%"=="2" goto registry_cleaner
if "%sys_choice%"=="3" goto startup_manager
if "%sys_choice%"=="4" goto defrag_drives
if "%sys_choice%"=="5" goto temp_files_cleaner
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

:defrag_drives
echo Defragmenting and Optimizing Drives...
defrag C: /O
pause
goto system_optimize

:temp_files_cleaner
echo Cleaning Temporary Files...
del /q/f/s %TEMP%\*
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
echo [4] Flush DNS Cache
echo [5] Internet Speed Test
echo [0] Back to Main Menu
echo ============================================
set /p net_choice=Select an option:

if "%net_choice%"=="1" goto network_settings_tuning
if "%net_choice%"=="2" goto dns_optimization
if "%net_choice%"=="3" goto cache_cleaning
if "%net_choice%"=="4" goto flush_dns
if "%net_choice%"=="5" goto internet_speed_test
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

:flush_dns
echo Flushing DNS Cache...
ipconfig /flushdns
pause
goto internet_optimize

:internet_speed_test
echo Performing Internet Speed Test...
start msedge "https://www.speedtest.net"
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
echo [4] Install Game Boosters
echo [0] Back to Main Menu
echo ============================================
set /p game_choice=Select an option:

if "%game_choice%"=="1" goto game_mode
if "%game_choice%"=="2" goto gpu_settings_optimization
if "%game_choice%"=="3" goto latency_reducer
if "%game_choice%"=="4" goto install_game_boosters
if "%game_choice%"=="0" goto menu

goto game_optimize

:game_mode
echo Activating Game Mode...
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f
pause
goto game_optimize

:gpu_settings_optimization
echo Optimizing GPU Settings...
start "nvcplui"
pause
goto game_optimize

:latency_reducer
echo Reducing Latency...
netsh int tcp set global lowlatency=enabled
pause
goto game_optimize

:install_game_boosters
echo Installing Game Boosters...
start msedge "https://www.iobit.com/en/gamebooster.php"
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
echo [4] Processor Affinity
echo [5] Enable Virtualization
echo [0] Back to Main Menu
echo ============================================
set /p cpu_choice=Select an option:

if "%cpu_choice%"=="1" goto process_priority_manager
if "%cpu_choice%"=="2" goto core_parking
if "%cpu_choice%"=="3" goto power_plan_optimization
if "%cpu_choice%"=="4" goto processor_affinity
if "%cpu_choice%"=="5" goto enable_virtualization
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

:processor_affinity
echo Setting Processor Affinity...
start msconfig
pause
goto cpu_optimize

:enable_virtualization
echo Enabling Virtualization...
dism /online /enable-feature /featurename:VirtualMachinePlatform
pause
goto cpu_optimize

:mode_switcher
cls
echo ============================================
echo          Mode Switcher Menu
echo ============================================
echo [1] Dark Mode
echo [2] Light Mode
echo [3] High Contrast Mode
echo [0] Back to Main Menu
echo ============================================
set /p mode_choice=Select an option:

if "%mode_choice%"=="1" goto dark_mode
if "%mode_choice%"=="2" goto light_mode
if "%mode_choice%"=="3" goto high_contrast_mode
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

:high_contrast_mode
echo Activating High Contrast Mode...
powershell -Command "New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'HighContrast' -Value 1 -PropertyType DWord -Force"
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
echo [4] Disable Transparency
echo [0] Back to Main Menu
echo ============================================
set /p anim_choice=Select an option:

if "%anim_choice%"=="1" goto animation_tuning
if "%anim_choice%"=="2" goto reduce_motion
if "%anim_choice%"=="3" goto frame_rate_adjustment
if "%anim_choice%"=="4" goto disable_transparency
if "%anim_choice%"=="0" goto menu

goto animation_optimize

:animation_tuning
cls
echo Tuning Animations...
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f
echo Animations have been tuned.
pause
goto animation_optimize

:reduce_motion
cls
echo Reducing Motion...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Accessibility" /v "AnimationEffect" /t REG_DWORD /d 0 /f
echo Motion has been reduced.
pause
goto animation_optimize

:frame_rate_adjustment
cls
echo Adjusting Frame Rate...
echo Frame rate adjustment is not implemented yet.
pause
goto animation_optimize

:disable_transparency
cls
echo Disabling Transparency...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f
echo Transparency has been disabled.
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
echo [4] Monitor Calibration
echo [0] Back to Main Menu
echo ============================================
set /p graph_choice=Select an option:

if "%graph_choice%"=="1" goto resolution_optimization
if "%graph_choice%"=="2" goto color_calibration
if "%graph_choice%"=="3" goto driver_update
if "%graph_choice%"=="4" goto monitor_calibration
if "%graph_choice%"=="0" goto menu

goto graphic_optimize

:resolution_optimization
echo Optimizing Screen Resolution...
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
start /wait nvidia-installer.exe --update
pause
goto graphic_optimize

:monitor_calibration
echo Calibrating Monitor...
start msedge "https://www.calibrate-monitor.com/"
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
echo [4] Power Troubleshooter
echo [5] USB Power Management
echo [0] Back to Main Menu
echo ============================================
set /p power_choice=Select an option:

if "%power_choice%"=="1" goto battery_saver_mode
if "%power_choice%"=="2" goto power_consumption_monitoring
if "%power_choice%"=="3" goto sleep_hibernate_settings
if "%power_choice%"=="4" goto power_troubleshooter
if "%power_choice%"=="5" goto usb_power_management
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

:power_troubleshooter
echo Running Power Troubleshooter...
msdt.exe /id PowerDiagnostic
pause
goto power_optimize

:usb_power_management
echo Adjusting USB Power Management...
powershell -Command "powercfg -devicequery wake_armed"
echo Enter the name of the device to disable wake-up feature:
set /p device_name=Device Name:
powershell -Command "powercfg -devicedisablewake '%device_name%'"
pause
goto power_optimize

:windows_update
cls
echo ============================================
echo          Windows Update Menu
echo ============================================
echo [1] Enable Windows Update
echo [2] Disable Windows Update
echo [3] Check for Updates
echo [4] View Update History
echo [0] Back to Main Menu
echo ============================================
set /p update_choice=Select an option:

if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_for_updates
if "%update_choice%"=="4" goto view_update_history
if "%update_choice%"=="0" goto menu

goto windows_update

:enable_windows_update
echo Enabling Windows Update on Windows 11...

sc config wuauserv start= auto
sc start wuauserv

sc config WaaSMedicSvc start= manual
sc start WaaSMedicSvc

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f

sc config UsoSvc start= manual
sc start UsoSvc

schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Enable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Enable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Enable

echo Windows Update has been enabled.
pause
goto windows_update

:disable_windows_update
echo Disabling Windows Update on Windows 11...

sc stop wuauserv
sc config wuauserv start= disabled

sc stop WaaSMedicSvc
sc config WaaSMedicSvc start= disabled

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f

sc stop UsoSvc
sc config UsoSvc start= disabled

schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /Disable
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\sihboot" /Disable

echo Windows Update has been disabled.
pause
goto windows_update

:check_for_updates
echo Checking for Windows Updates...
powershell -Command "Install-Module PSWindowsUpdate -Force -SkipPublisherCheck; Get-WindowsUpdate; Install-WindowsUpdate -AcceptAll -AutoReboot"
pause
goto windows_update

:view_update_history
echo Viewing Update History...
powershell -Command "Get-WindowsUpdateLog"
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
echo [4] Increase Virtual Memory
echo [0] Back to Main Menu
echo ============================================
set /p ram_choice=Select an option:

if "%ram_choice%"=="1" goto memory_cleaner
if "%ram_choice%"=="2" goto memory_usage_monitoring
if "%ram_choice%"=="3" goto memory_compression
if "%ram_choice%"=="4" goto increase_virtual_memory
if "%ram_choice%"=="0" goto menu

goto ram_optimize

:memory_cleaner
echo Cleaning RAM...
powershell -Command "Clear-RecycleBin -Force"
powershell -Command "& {Start-Process 'cleanmgr.exe' -ArgumentList '/sagerun:1' -NoNewWindow -Wait}"
mdsched.exe
echo RAM Cleaned.
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
echo Memory Compression Enabled.
pause
goto ram_optimize

:increase_virtual_memory
echo Increasing Virtual Memory...
echo Enter the initial size (MB):
set /p initial_size=Initial Size:
echo Enter the maximum size (MB):
set /p max_size=Maximum Size:
powershell -Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name 'PagingFiles' -Value 'C:\pagefile.sys %initial_size% %max_size%'"
echo Virtual Memory Increased.
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
echo [6] Firewall Rules Management
echo [0] Back to Main Menu
echo ============================================
set /p fw_choice=Select an option:

if "%fw_choice%"=="1" goto enable_windows_defender
if "%fw_choice%"=="2" goto disable_windows_defender
if "%fw_choice%"=="3" goto enable_firewall
if "%fw_choice%"=="4" goto disable_firewall
if "%fw_choice%"=="5" goto virus_scan
if "%fw_choice%"=="6" goto firewall_rules
if "%fw_choice%"=="0" goto menu

goto firewall_defender

:enable_windows_defender
echo Enabling Windows Defender on Windows 11...

sc config WinDefend start= auto
sc start WinDefend

powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"

schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /f

echo Windows Defender has been enabled.
pause
goto firewall_defender

:disable_windows_defender
echo Disabling Windows Defender on Windows 11...

sc stop WinDefend
sc config WinDefend start= disabled

powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
schtasks /Change /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiVirus /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f

echo Windows Defender has been disabled.
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

:firewall_rules
echo Managing Firewall Rules...
start wf.msc
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
echo [5] System Restore
echo [6] Driver Verification
echo [0] Back to Main Menu
echo ============================================
set /p repair_choice=Select an option:

if "%repair_choice%"=="1" goto sfc_scan
if "%repair_choice%"=="2" goto chkdsk_scan
if "%repair_choice%"=="3" goto remove_password
if "%repair_choice%"=="4" goto set_password
if "%repair_choice%"=="5" goto system_restore
if "%repair_choice%"=="6" goto driver_verification
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

:system_restore
echo Restoring System...
rstrui.exe
pause
goto system_repair

:driver_verification
echo Verifying Drivers...
verifier
pause
goto system_repair

:backup_restore
cls
echo ============================================
echo          Backup and Restore Menu
echo ============================================
echo [1] Backup Files
echo [2] Restore Files
echo [3] Create System Image
echo [4] Restore System Image
echo [0] Back to Main Menu
echo ============================================
set /p backup_choice=Select an option:

if "%backup_choice%"=="1" goto backup_files
if "%backup_choice%"=="2" goto restore_files
if "%backup_choice%"=="3" goto create_system_image
if "%backup_choice%"=="4" goto restore_system_image
if "%backup_choice%"=="0" goto menu

goto backup_restore

:backup_files
echo Backing up Files...
wbadmin start backup -backupTarget:E: -include:C: -quiet
pause
goto backup_restore

:restore_files
echo Restoring Files...
wbadmin start recovery -version:03/10/2024-06:00 -itemType:File -items:C:\Users\YourUserName\Documents -recoveryTarget:C:\Users\YourUserName\Documents -quiet
pause
goto backup_restore

:create_system_image
echo Creating System Image...
wbadmin start backup -backupTarget:E: -include:C: -allCritical -quiet
pause
goto backup_restore

:restore_system_image
echo Restoring System Image...
wbadmin start recovery -version:03/10/2024-06:00 -recoveryTarget:C: -quiet
pause
goto backup_restore

:disk_management
cls
echo ============================================
echo          Disk Management Menu
echo ============================================
echo [1] Disk Cleanup
echo [2] Disk Defragmentation
echo [3] Create Partition
echo [4] Delete Partition
echo [5] Format Partition
echo [6] Shrink Partition
echo [7] Extend Partition
echo [0] Back to Main Menu
echo ============================================
set /p disk_choice=Select an option:

if "%disk_choice%"=="1" goto disk_cleanup
if "%disk_choice%"=="2" goto disk_defragmentation
if "%disk_choice%"=="3" goto create_partition
if "%disk_choice%"=="4" goto delete_partition
if "%disk_choice%"=="5" goto format_partition
if "%disk_choice%"=="6" goto shrink_partition
if "%disk_choice%"=="7" goto extend_partition
if "%disk_choice%"=="0" goto menu

goto disk_management

:disk_cleanup
echo Cleaning Disk...
cleanmgr /sagerun:1
pause
goto disk_management

:disk_defragmentation
echo Defragmenting Disk...
defrag C: /O
pause
goto disk_management

:create_partition
echo Creating Partition...
echo Enter the size of the partition in MB:
set /p size=Size:
echo select disk 0 > create_partition_script.txt
echo create partition primary size=%size% >> create_partition_script.txt
diskpart /s create_partition_script.txt
del create_partition_script.txt
echo Partition created.
pause
goto disk_management

:delete_partition
echo Deleting Partition...
echo Enter the partition number to delete:
set /p part_num=Partition Number:
echo select disk 0 > delete_partition_script.txt
echo select partition %part_num% >> delete_partition_script.txt
echo delete partition >> delete_partition_script.txt
diskpart /s delete_partition_script.txt
del delete_partition_script.txt
echo Partition deleted.
pause
goto disk_management

:format_partition
echo Formatting Partition...
echo Enter the partition number to format:
set /p part_num=Partition Number:
echo select disk 0 > format_partition_script.txt
echo select partition %part_num% >> format_partition_script.txt
echo format fs=ntfs quick >> format_partition_script.txt
diskpart /s format_partition_script.txt
del format_partition_script.txt
echo Partition formatted.
pause
goto disk_management

:shrink_partition
echo Shrinking Partition...
echo Enter the partition number to shrink:
set /p part_num=Partition Number:
echo Enter the amount to shrink in MB:
set /p amount=Amount:
echo select disk 0 > shrink_partition_script.txt
echo select partition %part_num% >> shrink_partition_script.txt
echo shrink desired=%amount% >> shrink_partition_script.txt
diskpart /s shrink_partition_script.txt
del shrink_partition_script.txt
echo Partition shrunk.
pause
goto disk_management

:extend_partition
echo Extending Partition...
echo Enter the partition number to extend:
set /p part_num=Partition Number:
echo Enter the amount to extend in MB:
set /p amount=Amount:
echo select disk 0 > extend_partition_script.txt
echo select partition %part_num% >> extend_partition_script.txt
echo extend size=%amount% >> extend_partition_script.txt
diskpart /s extend_partition_script.txt
del extend_partition_script.txt
echo Partition extended.
pause
goto disk_management

:exit_script
endlocal
exit /b
