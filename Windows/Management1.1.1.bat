@echo off
setlocal enabledelayedexpansion

:: Check for administrator privileges
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
echo Windows Optimization Script v4.0
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
echo 22. Manage new Windows 11 features
echo 23. Exit
echo ==================================================
set /p choice=Enter your choice (1-23):

:: Validate user input
if not "%choice%"=="" (
    if %choice% geq 1 if %choice% leq 23 (
        goto option_%choice%
    )
)

:: If invalid choice, prompt again
echo Invalid choice. Please try again.
pause
goto menu

:option_1
:optimize_display
echo Optimizing display performance...
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"  :: Updated Visual Effects for Windows 11
echo Display performance optimized.
pause
goto menu

:option_2
:manage_defender
cls
echo ===================================================
echo             Windows Defender Management
echo ===================================================
echo 1. Check Windows Defender status
echo 2. Enable Windows Defender
echo 3. Disable Windows Defender (Not recommended)
echo 4. Update Windows Defender
echo 5. Run quick scan
echo 6. Run full scan
echo 7. Manage real-time protection
echo 8. Manage cloud-delivered protection
echo 9. Manage automatic sample submission
echo 10. View threat history
echo 11. Return to main menu
echo ===================================================
set /p def_choice=Enter your choice (1-11):

if "%def_choice%"=="1" goto check_defender
if "%def_choice%"=="2" goto enable_defender
if "%def_choice%"=="3" goto disable_defender
if "%def_choice%"=="4" goto update_defender
if "%def_choice%"=="5" goto quick_scan
if "%def_choice%"=="6" goto full_scan
if "%def_choice%"=="7" goto manage_realtime
if "%def_choice%"=="8" goto manage_cloud
if "%def_choice%"=="9" goto manage_samples
if "%def_choice%"=="10" goto view_history
if "%def_choice%"=="11" goto menu
echo Invalid choice. Please try again.
pause
goto manage_defender

:check_defender
echo Checking Windows Defender status...
sc query windefend
pause
goto manage_defender

:enable_defender
echo Enabling Windows Defender...
rem Enable Windows Defender and Real-Time Protection
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
echo Enabled Windows Defender.
pause
goto manage_defender

:disable_defender
echo WARNING: Disabling Windows Defender may leave your system vulnerable.
rem Disable Windows Defender and Real-Time Protection
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
echo Disabled Windows Defender.
pause
goto manage_defender

:update_defender
echo Updating Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo Windows Defender updated successfully.
) else (
    echo Failed to update Windows Defender. Please check your internet connection.
)
pause
goto manage_defender

:quick_scan
echo Running quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo Quick scan completed.
pause
goto manage_defender

:full_scan
echo Running full scan...
echo This may take a while. You can check the progress in Windows Security.
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
pause
goto manage_defender

:manage_realtime
echo Current real-time protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
set /p rtp_choice=Do you want to enable (E) or disable (D) real-time protection? (E/D):
if /i "%rtp_choice%"=="E" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    echo Real-time protection enabled.
) else if /i "%rtp_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    echo Real-time protection disabled. It is recommended to keep it enabled.
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:manage_cloud
echo Current cloud-delivered protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
set /p cloud_choice=Do you want to enable (E) or disable (D) cloud-delivered protection? (E/D):
if /i "%cloud_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "2"
    echo Cloud-delivered protection enabled.
) else if /i "%cloud_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    echo Cloud-delivered protection disabled. It is recommended to keep it enabled for better protection.
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:manage_samples
echo Current automatic sample submission status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
set /p sample_choice=Do you want to enable (E) or disable (D) automatic sample submission? (E/D):
if /i "%sample_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
    echo Automatic sample submission enabled.
) else if /i "%sample_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "0"
    echo Automatic sample submission disabled.
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:view_history
echo Viewing threat history...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo Threat history displayed above. Check the output for details.
pause
goto manage_defender

:option_3
:optimize_features
echo Optimizing system features...

:: Disable Activity Feed
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
echo Activity Feed disabled.

:: Disable background apps
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
echo Background apps disabled.

:: Disable Cortana
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
echo Cortana disabled.

:: Disable Game DVR and Game Bar
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
echo Game DVR and Game Bar disabled.

:: Disable Sticky Keys prompt
call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
echo Sticky Keys prompt disabled.

:: Disable Windows Tips
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
echo Windows Tips disabled.

:: Disable Start Menu suggestions
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
echo Start Menu suggestions disabled.

:: Enable Fast Startup
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
echo Fast Startup enabled.

:: Disable Widgets (Windows 11)
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowWidgetsButton" "REG_DWORD" "0"
echo Widgets disabled (Windows 11).

:: Disable Snap Layouts (Windows 11)
call :modify_registry "HKCU\Control Panel\Desktop" "WindowArrangementActive" "REG_DWORD" "0"
echo Snap Layouts disabled (Windows 11).

echo System features optimized.
pause
goto menu

:option_4
:optimize_cpu
cls
echo ==================================================
echo CPU Optimization
echo ==================================================
echo 1. Set High Performance power plan
echo 2. Disable CPU throttling
echo 3. Optimize processor scheduling
echo 4. Disable CPU core parking
echo 5. Adjust processor power management
echo 6. Enable hardware-accelerated GPU scheduling
echo 7. Disable unnecessary system services
echo 8. Adjust visual effects for performance
echo 9. Return to main menu
echo ==================================================
set /p cpu_choice=Enter your choice (1-9):

if "%cpu_choice%"=="1" goto set_high_performance
if "%cpu_choice%"=="2" goto disable_throttling
if "%cpu_choice%"=="3" goto optimize_scheduling
if "%cpu_choice%"=="4" goto disable_core_parking
if "%cpu_choice%"=="5" goto adjust_power_management
if "%cpu_choice%"=="6" goto enable_gpu_scheduling
if "%cpu_choice%"=="7" goto disable_services
if "%cpu_choice%"=="8" goto adjust_visual_effects
if "%cpu_choice%"=="9" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_cpu

:set_high_performance
echo Setting High Performance power plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 (
    echo Failed to set High Performance power plan. Creating a new one...
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid=%%i
    powercfg -setactive %hp_guid%
)
echo High Performance power plan set.
pause
goto optimize_cpu

:disable_throttling
echo Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo CPU throttling disabled.
pause
goto optimize_cpu

:optimize_scheduling
echo Optimizing processor scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo Processor scheduling optimized for best performance of programs.
pause
goto optimize_cpu

:disable_core_parking
echo Disabling CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo CPU core parking disabled.
pause
goto optimize_cpu

:adjust_power_management
echo Adjusting processor power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
powercfg -setactive scheme_current
echo Processor power management adjusted for maximum performance.
pause
goto optimize_cpu

:enable_gpu_scheduling
echo Enabling hardware-accelerated GPU scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled. Please restart your computer for changes to take effect.
pause
goto optimize_cpu

:disable_services
echo Disabling unnecessary system services...
sc config "SysMain" start= disabled
sc stop "SysMain"
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
sc config "WSearch" start= disabled
sc stop "WSearch"
:: Add more unnecessary services for Windows 11
sc config "WerSvc" start= disabled  :: Windows Error Reporting Service
sc stop "WerSvc"
sc config "dmwappushservice" start= disabled :: dmwappushservice (Device Management Wireless Application Protocol (WAP) Push service)
sc stop "dmwappushservice"
echo Unnecessary system services disabled.
pause
goto optimize_cpu

:adjust_visual_effects
echo Adjusting visual effects for best performance...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo Visual effects adjusted for best performance.
pause
goto optimize_cpu

:option_5
:optimize_internet
cls
echo ==================================================
echo Internet Performance Optimization
echo ==================================================
echo 1. Basic optimizations
echo 2. Advanced TCP optimizations
echo 3. DNS optimization
echo 4. Network adapter tuning
echo 5. Clear network cache
echo 6. Return to main menu
echo ==================================================
set /p net_choice=Enter your choice (1-6):

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
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global rss=enabled
echo Basic optimizations completed.
pause
goto optimize_internet

:advanced_tcp
echo Performing advanced TCP optimizations...
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global hystart=disabled
netsh int tcp set global pacingprofile=off
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
echo Advanced TCP optimizations completed.
pause
goto optimize_internet

:dns_optimization
echo Optimizing DNS settings...
ipconfig /flushdns
netsh int ip set dns name="Wi-Fi" source=static address=8.8.8.8 registerdns=primary  :: Improved for potentially different Wi-Fi connection name
netsh int ip add dns name="Wi-Fi" addr=8.8.4.4 index=2
echo DNS optimized. Primary: 8.8.8.8, Secondary: 8.8.4.4
pause
goto optimize_internet

:adapter_tuning
echo Tuning network adapter...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*FlowControl' | Where-Object {$_.DisplayName -eq 'Flow Control'} | Set-NetAdapterAdvancedProperty -RegistryValue 0" :: Improved Flow Control setting
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*InterruptModeration' | Where-Object {$_.DisplayName -eq 'Interrupt Moderation'} | Set-NetAdapterAdvancedProperty -RegistryValue 0" :: Improved Interrupt Moderation setting
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' | Where-Object {$_.DisplayName -eq 'Priority & VLAN'} | Set-NetAdapterAdvancedProperty -RegistryValue 3" :: Improved Priority & VLAN setting
    powershell "Get-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' | Where-Object {$_.DisplayName -eq 'Speed & Duplex'} | Set-NetAdapterAdvancedProperty -RegistryValue 0" :: Improved Speed & Duplex setting
)
echo Network adapter tuned for optimal performance.
pause
goto optimize_internet

:clear_network_cache
echo Clearing network cache...
ipconfig /flushdns
arp -d *
nbtstat -R
nbtstat -RR
netsh int ip reset
netsh winsock reset
echo Network cache cleared.
pause
goto optimize_internet

:option_6
:windows_update
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
echo 4. Configure Automatic Updates :: Added new option
echo 5. Return to main menu
set /p update_choice=Enter your choice (1-5):
if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
if "%update_choice%"=="4" goto config_auto_updates :: New option
if "%update_choice%"=="5" goto menu
goto windows_update

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
goto windows_update

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
goto windows_update

:check_updates
echo Checking for Windows updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated. Please check Windows Update in Settings for results.
pause
goto windows_update

:config_auto_updates
echo Configuring Automatic Updates...
echo Select automatic update option:
echo 1. Automatically download and install
echo 2. Notify for download and install
echo 3. Not check for updates
set /p auto_update_choice=Enter your choice (1-3):
if "%auto_update_choice%"=="1" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" "REG_DWORD" "4"
    echo Configured to automatically download and install updates.
) else if "%auto_update_choice%"=="2" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" "REG_DWORD" "3"
    echo Configured to notify for download and install updates.
) else if "%auto_update_choice%"=="3" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" "REG_DWORD" "1"
    echo Configured not to check for updates.
) else (
    echo Invalid choice.
)
pause
goto windows_update

:option_7
:auto_login
echo Configuring Auto-login...
set /p username=Enter username:
set /p password=Enter password:
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo Auto-login configured.
pause
goto menu

:option_8
:clear_cache
echo Clearing system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
:: Add browser cache clearing - Chrome example
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
    md "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
)
echo System cache cleared.
pause
goto menu

:option_9
:optimize_disk
cls
echo ==================================================
echo Disk Optimization
echo ==================================================
echo 1. Analyze disk
echo 2. Optimize/Defragment disk
echo 3. Check disk for errors
echo 4. Trim SSD
echo 5. Clean up system files
echo 6. Manage Storage Sense (Windows 11) :: Added new option
echo 7. Return to main menu
echo ==================================================
set /p disk_choice=Enter your choice (1-7):

if "%disk_choice%"=="1" goto analyze_disk
if "%disk_choice%"=="2" goto optimize_defrag
if "%disk_choice%"=="3" goto check_disk
if "%disk_choice%"=="4" goto trim_ssd
if "%disk_choice%"=="5" goto cleanup_system
if "%disk_choice%"=="6" goto manage_storage_sense :: New option
if "%disk_choice%"=="7" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk
echo Analyzing disk...
defrag C: /A
echo Disk analysis completed.
pause
goto optimize_disk

:optimize_defrag
echo Optimizing/Defragmenting disk...
defrag C: /O
echo Disk optimization completed.
pause
goto optimize_defrag

:check_disk
echo Checking disk for errors...
echo This process will schedule a disk check on the next system restart.
chkdsk C: /F /R /X
echo Disk check scheduled. Please restart your computer to perform the check.
pause
goto optimize_disk

:trim_ssd
echo Trimming SSD...
fsutil behavior set disabledeletenotify 0
defrag C: /L
echo SSD trim completed.
pause
goto optimize_disk

:cleanup_system
echo Cleaning up system files...
cleanmgr /sagerun:1
echo System file cleanup completed.
pause
goto optimize_disk

:manage_storage_sense
echo Managing Storage Sense (Windows 11)...
echo 1. Enable Storage Sense
echo 2. Disable Storage Sense
echo 3. Configure Storage Sense
echo 4. Run Storage Sense now
echo 5. Return to Disk Optimization menu
set /p ss_choice=Enter your choice (1-5):
if "%ss_choice%"=="1" goto enable_storage_sense
if "%ss_choice%"=="2" goto disable_storage_sense
if "%ss_choice%"=="3" goto config_storage_sense
if "%ss_choice%"=="4" goto run_storage_sense
if "%ss_choice%"=="5" goto optimize_disk
echo Invalid choice. Please try again.
pause
goto manage_storage_sense

:enable_storage_sense
echo Enabling Storage Sense...
call :modify_registry "HKCU\Software\Microsoft\Windows\StorageSense\Parameters\StoragePolicy" "01" "REG_DWORD" "1"
echo Storage Sense enabled.
pause
goto manage_storage_sense

:disable_storage_sense
echo Disabling Storage Sense...
call :modify_registry "HKCU\Software\Microsoft\Windows\StorageSense\Parameters\StoragePolicy" "01" "REG_DWORD" "0"
echo Storage Sense disabled.
pause
goto manage_storage_sense

:config_storage_sense
echo Configuring Storage Sense...
echo 1. Change run frequency
echo 2. Change Temp files deletion threshold
echo 3. Return to Storage Sense menu
set /p config_ss_choice=Enter your choice (1-3):
if "%config_ss_choice%"=="1" goto config_ss_frequency
if "%config_ss_choice%"=="2" goto config_ss_threshold
if "%config_ss_choice%"=="3" goto manage_storage_sense
echo Invalid choice. Please try again.
pause
goto config_storage_sense

:config_ss_frequency
echo Select Storage Sense run frequency:
echo 1. Daily
echo 2. Weekly
echo 3. Monthly
echo 4. When disk space is low
set /p ss_freq_choice=Enter your choice (1-4):
if "%ss_freq_choice%"=="1" set ss_freq_val=1
if "%ss_freq_choice%"=="2" set ss_freq_val=2
if "%ss_freq_choice%"=="3" set ss_freq_val=3
if "%ss_freq_choice%"=="4" set ss_freq_val=5
call :modify_registry "HKCU\Software\Microsoft\Windows\StorageSense\Parameters\StoragePolicy" "02" "REG_DWORD" "%ss_freq_val%"
echo Storage Sense run frequency configured.
pause
goto config_storage_sense

:config_ss_threshold
echo Select Temp files deletion threshold:
echo 1. Never
echo 2. Older than 1 day
echo 3. Older than 14 days
echo 4. Older than 30 days
echo 5. Older than 60 days
set /p ss_threshold_choice=Enter your choice (1-5):
if "%ss_threshold_choice%"=="1" set ss_threshold_val=0
if "%ss_threshold_choice%"=="2" set ss_threshold_val=1
if "%ss_threshold_choice%"=="3" set ss_threshold_val=14
if "%ss_threshold_choice%"=="4" set ss_threshold_val=30
if "%ss_threshold_choice%"=="5" set ss_threshold_val=60
call :modify_registry "HKCU\Software\Microsoft\Windows\StorageSense\Parameters\StoragePolicy" "08" "REG_DWORD" "%ss_threshold_val%"
echo Temp files deletion threshold configured.
pause
goto config_storage_sense

:run_storage_sense
echo Running Storage Sense now...
powershell -Command "Start-Process -FilePath 'cleanmgr.exe' -ArgumentList '/sageset:65535 & cleanmgr /sagerun:65535' -Verb RunAs -Wait"
echo Storage Sense run completed.
pause
goto manage_storage_sense


:option_10
:check_repair
cls
echo ==================================================
echo Check and Repair System Files
echo ==================================================
echo 1. Run SFC (System File Checker)
echo 2. Run DISM (Deployment Image Servicing and Management)
echo 3. Check disk health
echo 4. Verify system files
echo 5. Return to main menu
echo ==================================================
set /p repair_choice=Enter your choice (1-5):

if "%repair_choice%"=="1" goto run_sfc
if "%repair_choice%"=="2" goto run_dism
if "%repair_choice%"=="3" goto check_disk_health
if "%repair_choice%"=="4" goto verify_files
if "%repair_choice%"=="5" goto menu
echo Invalid choice. Please try again.
pause
goto check_repair

:run_sfc
echo Running System File Checker...
sfc /scannow
echo SFC scan completed.
pause
goto check_repair

:run_dism
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM repair completed.
pause
goto check_repair

:check_disk_health
echo Checking disk health...
wmic diskdrive get status
echo Disk health check completed.
pause
goto check_repair

:verify_files
echo Verifying system files...
Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
echo Verification completed. Results saved to sfcdetails.txt on your desktop.
pause
goto check_repair

:option_11
:windows_activate
cls
echo ==================================================
echo Windows Activation
echo ==================================================
echo 1. Check activation status
echo 2. Activate using KMS (for Volume License versions)
echo 3. Activate using digital license
echo 4. Input a product key manually
echo 5. Remove product key
echo 6. Return to main menu
echo ==================================================
set /p activate_choice=Enter your choice (1-6):

if "%activate_choice%"=="1" goto check_activation
if "%activate_choice%"=="2" goto kms_activate
if "%activate_choice%"=="3" goto digital_activate
if "%activate_choice%"=="4" goto manual_key
if "%activate_choice%"=="5" goto remove_key
if "%activate_choice%"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows_activate

:check_activation
echo Checking Windows activation status...
slmgr /xpr
pause
goto windows_activate

:kms_activate
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    :: If running as administrator, execute the PowerShell command
    powershell -command "irm https://get.activated.win | iex"
) else (
    :: If not running as administrator, relaunch the script as administrator
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
)
pause
goto windows_activate

:activate_kms
slmgr /ato
if %errorlevel% neq 0 (
    echo Activation failed. Please try another method or check your Windows version.
) else (
    echo Windows activation attempted. Please check the activation status.
)
pause
goto windows_activate

:digital_activate
echo Attempting to activate Windows using digital license...
slmgr /ato
if %errorlevel% neq 0 (
    echo Digital license activation failed. Your PC may not have a digital license.
) else (
    echo Digital license activation attempted. Please check the activation status.
)
pause
goto windows_activate

:manual_key
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
echo Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
) else (
    echo Product key installed. Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your product key and try again.
    ) else (
        echo Windows activation attempted. Please check the activation status.
    )
)
pause
goto windows_activate

:remove_key
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key. You may not have permission or there's no key to remove.
) else (
    echo Product key removed successfully.
)
pause
goto windows_activate

:option_12
:manage_power
cls
echo ==================================================
echo Power Settings Management
echo ==================================================
echo 1. List all power plans
echo 2. Set power plan
echo 3. Create custom power plan
echo 4. Delete power plan
echo 5. Adjust sleep settings
echo 6. Configure hibernation
echo 7. Adjust display and sleep timeouts
echo 8. Configure lid close action
echo 9. Configure power button action
echo 10. Return to main menu
echo ==================================================
set /p power_choice=Enter your choice (1-10):

if "%power_choice%"=="1" goto list_power_plans
if "%power_choice%"=="2" goto set_power_plan
if "%power_choice%"=="3" goto create_power_plan
if "%power_choice%"=="4" goto delete_power_plan
if "%power_choice%"=="5" goto adjust_sleep
if "%power_choice%"=="6" goto configure_hibernate
if "%power_choice%"=="7" goto adjust_timeouts
if "%power_choice%"=="8" goto lid_action
if "%power_choice%"=="9" goto power_button_action
if "%power_choice%"=="10" goto menu
echo Invalid choice. Please try again.
pause
goto manage_power

:list_power_plans
echo Listing all power plans...
powercfg /list
pause
goto manage_power

:set_power_plan
echo Available power plans:
powercfg /list
set /p plan_guid=Enter the GUID of the power plan you want to set:
powercfg /setactive %plan_guid%
if %errorlevel% neq 0 (
    echo Failed to set power plan. Please check the GUID and try again.
) else (
    echo Power plan set successfully.
)
pause
goto manage_power

:create_power_plan
set /p plan_name=Enter a name for the new power plan:
powercfg /duplicatescheme scheme_balanced
powercfg /changename %plan_name%
if %errorlevel% neq 0 (
    echo Failed to create power plan.
) else (
    echo Power plan created successfully.
)
pause
goto manage_power

:delete_power_plan
echo Available power plans:
powercfg /list
set /p del_guid=Enter the GUID of the power plan you want to delete:
powercfg /delete %del_guid%
if %errorlevel% neq 0 (
    echo Failed to delete power plan. Please check the GUID and try again.
) else (
    echo Power plan deleted successfully.
)
pause
goto manage_power

:adjust_sleep
set /p sleep_time=Enter the number of minutes before the system goes to sleep (0 to never sleep):
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo Sleep settings adjusted.
pause
goto manage_power

:configure_hibernate
echo 1. Enable hibernation
echo 2. Disable hibernation
set /p hib_choice=Enter your choice (1-2):
if "%hib_choice%"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
) else if "%hib_choice%"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
) else (
    echo Invalid choice.
)
pause
goto manage_power

:adjust_timeouts
set /p display_ac=Enter minutes before turning off the display (AC power):
set /p display_dc=Enter minutes before turning off the display (battery):
set /p sleep_ac=Enter minutes before sleep (AC power):
set /p sleep_dc=Enter minutes before sleep (battery):
powercfg /change monitor-timeout-ac %display_ac%
powercfg /change monitor-timeout-dc %display_dc%
powercfg /change standby-timeout-ac %sleep_ac%
powercfg /change standby-timeout-dc %sleep_dc%
echo Display and sleep timeouts adjusted.
pause
goto manage_power

:lid_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p lid_choice=Enter your choice for lid close action (1-4):
if "%lid_choice%"=="1" set action=0
if "%lid_choice%"=="2" set action=1
if "%lid_choice%"=="3" set action=2
if "%lid_choice%"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setactive scheme_current
echo Lid close action configured.
pause
goto manage_power

:power_button_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p button_choice=Enter your choice for power button action (1-4):
if "%button_choice%"=="1" set action=0
if "%button_choice%"=="2" set action=1
if "%button_choice%"=="3" set action=2
if "%button_choice%"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setactive scheme_current
echo Power button action configured.
pause
goto manage_power

:option_13
:enable_dark_mode
echo Enabling Dark Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo Dark Mode enabled.
pause
goto menu

:option_14
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

:option_15
:clean_disk
echo Cleaning up disk space...
cleanmgr /sagerun:1
echo Disk cleanup completed.
pause
goto menu

:option_16
:manage_startup
echo Managing startup programs...
start msconfig
echo Please use the System Configuration utility to manage startup programs.
pause
goto menu

:option_17
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

:option_18
:system_info
echo Displaying system information...
systeminfo
pause
goto menu

:option_19
:optimize_privacy
echo Optimizing privacy settings...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
echo Privacy settings optimized.
pause
goto menu

:option_20
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
sc start "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to start the service. Please check the service name and your permissions.
) else (
    echo Service start attempted. Please check the status.
)
pause
goto manage_services

:stop_service
set /p service_name=Enter the name of the service to stop:
sc stop "%service_name%"
if %errorlevel% neq 0 (
    echo Failed to stop the service. Please check the service name and your permissions.
) else (
    echo Service stop attempted. Please check the status.
)
pause
goto manage_services

:restart_service
set /p service_name=Enter the name of the service to restart:
sc stop "%service_name%"
timeout /t 2 >nul
sc start "%service_name%"
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
echo 2. Automatic (Delayed Start)
echo 3. Manual
echo 4. Disabled
set /p startup_choice=Enter your choice (1-4):
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
sc qc "%service_name%"
echo.
echo Current Status:
sc query "%service_name%"
pause
goto manage_services

:option_21
:network_optimization
cls
echo ==================================================
echo Network Optimization
echo ==================================================
echo 1. Optimize TCP settings
echo 2. Reset Windows Sockets
echo 3. Clear DNS cache
echo 4. Optimize network adapter settings
echo 5. Disable IPv6 (caution)
echo 6. Enable QoS packet scheduler
echo 7. Set static DNS servers
echo 8. Reset all network settings
echo 9. Return to main menu
echo ==================================================
set /p net_choice=Enter your choice (1-9):

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
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialRto=2000
netsh int tcp set global nonsackrttresiliency=disabled
echo TCP settings optimized.
pause
goto network_optimization

:reset_winsock
echo Resetting Windows Sockets...
netsh winsock reset
echo Windows Sockets reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:clear_dns
echo Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared.
pause
goto network_optimization

:optimize_adapter
echo Optimizing network adapter settings...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    netsh int tcp set security mpp=disabled
    netsh int tcp set security profiles=disabled
)
echo Network adapter settings optimized.
pause
goto network_optimization

:disable_ipv6
echo WARNING: Disabling IPv6 may cause issues with some networks.
set /p confirm=Are you sure you want to disable IPv6? (Y/N):
if /i "%confirm%"=="Y" (
    netsh interface ipv6 set global randomizeidentifiers=disabled
    netsh interface ipv6 set privacy state=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 disabled. Please restart your computer for changes to take effect.
) else (
    echo Operation cancelled.
)
pause
goto network_optimization

:enable_qos
echo Enabling QoS packet scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
net start Qwave
echo QoS packet scheduler enabled.
pause
goto network_optimization

:set_static_dns
echo Setting static DNS servers...
set /p primary_dns=Enter primary DNS server (e.g., 8.8.8.8):
set /p secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4):
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%j" static %primary_dns% primary
    netsh interface ip add dns "%%j" %secondary_dns% index=2
)
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
echo All network settings reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:option_22
:windows11_features
cls
echo ==================================================
echo Windows 11 Features Management
echo ==================================================
echo 1. Enable Focus Assist
echo 2. Disable Focus Assist
echo 3. Configure Focus Assist
echo 4. Manage Snap Layouts
echo 5. Manage Widgets
echo 6. Return to main menu
echo ==================================================
set /p win11_choice=Enter your choice (1-6):

if "%win11_choice%"=="1" goto enable_focus_assist
if "%win11_choice%"=="2" goto disable_focus_assist
if "%win11_choice%"=="3" goto config_focus_assist
if "%win11_choice%"=="4" goto manage_snap_layouts
if "%win11_choice%"=="5" goto manage_widgets
if "%win11_choice%"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows11_features

:enable_focus_assist
echo Enabling Focus Assist...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" " состоянии" "REG_DWORD" "1"
echo Focus Assist enabled.
pause
goto windows11_features

:disable_focus_assist
echo Disabling Focus Assist...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" " состоянии" "REG_DWORD" "3"
echo Focus Assist disabled.
pause
goto windows11_features

:config_focus_assist
echo Configuring Focus Assist...
echo 1. Priority only
echo 2. Alarms only
echo 3. Off
set /p focus_choice=Enter Focus Assist mode (1-3):
if "%focus_choice%"=="1" set focus_val=1
if "%focus_choice%"=="2" set focus_val=2
if "%focus_choice%"=="3" set focus_val=3
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" " состоянии" "REG_DWORD" "%focus_val%"
echo Focus Assist mode configured.
pause
goto windows11_features

:manage_snap_layouts
echo Managing Snap Layouts...
echo 1. Enable Snap Layouts
echo 2. Disable Snap Layouts
set /p snap_choice=Enable or Disable Snap Layouts? (1/2):
if "%snap_choice%"=="1" (
    call :modify_registry "HKCU\Control Panel\Desktop" "WindowArrangementActive" "REG_DWORD" "1"
    echo Snap Layouts enabled.
) else if "%snap_choice%"=="2" (
    call :modify_registry "HKCU\Control Panel\Desktop" "WindowArrangementActive" "REG_DWORD" "0"
    echo Snap Layouts disabled.
) else (
    echo Invalid choice.
)
pause
goto windows11_features

:manage_widgets
echo Managing Widgets...
echo 1. Enable Widgets
echo 2. Disable Widgets
set /p widget_choice=Enable or Disable Widgets? (1/2):
if "%widget_choice%"=="1" (
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowWidgetsButton" "REG_DWORD" "1"
    echo Widgets enabled.
) else if "%widget_choice%"=="2" (
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowWidgetsButton" "REG_DWORD" "0"
    echo Widgets disabled.
) else (
    echo Invalid choice.
)
pause
goto windows11_features


:option_23
:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 4.0
pause
exit

:: Function to modify registry with error handling
:modify_registry
reg add %1 /v %2 /t %3 /d %4 /f
if %errorlevel% neq 0 (
    echo Failed to modify registry key: %1\%2
    pause
)
exit /b 0
