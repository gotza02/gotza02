@echo off
setlocal enabledelayedexpansion

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

:: Main menu function
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
choice /c 123456789abcdefghijklv /n /m "Enter your choice (1-22): "

:: Use errorlevel for menu selection
if errorlevel 22 goto endexit
if errorlevel 21 goto network_optimization
if errorlevel 20 goto manage_services
if errorlevel 19 goto optimize_privacy
if errorlevel 18 goto system_info
if errorlevel 17 goto backup_restore
if errorlevel 16 goto manage_startup
if errorlevel 15 goto clean_disk
if errorlevel 14 goto manage_partitions
if errorlevel 13 goto enable_dark_mode
if errorlevel 12 goto manage_power
if errorlevel 11 goto windows_activate
if errorlevel 10 goto check_repair
if errorlevel 9 goto optimize_disk
if errorlevel 8 goto clear_cache
if errorlevel 7 goto auto_login
if errorlevel 6 goto windows_update
if errorlevel 5 goto optimize_internet
if errorlevel 4 goto optimize_cpu
if errorlevel 3 goto optimize_features
if errorlevel 2 goto manage_defender
if errorlevel 1 goto optimize_display
goto menu

:optimize_display
echo Optimizing display performance...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo Display performance optimized.
pause
goto menu

:manage_defender
:: ... (rest of the code for manage_defender)

:optimize_features
echo Optimizing system features...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
echo System features optimized.
pause
goto menu

:: ... (rest of the functions)

:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 3.0
pause
exit

:optimize_display
echo Optimizing display performance...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo Display performance optimized.
pause
goto menu

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
choice /c 123456789ab /n /m "Enter your choice (1-11): "

if errorlevel 11 goto menu
if errorlevel 10 goto view_history
if errorlevel 9 goto manage_samples
if errorlevel 8 goto manage_cloud
if errorlevel 7 goto manage_realtime
if errorlevel 6 goto full_scan
if errorlevel 5 goto quick_scan
if errorlevel 4 goto update_defender
if errorlevel 3 goto disable_defender
if errorlevel 2 goto enable_defender
if errorlevel 1 goto check_defender
goto manage_defender

:check_defender
echo Checking Windows Defender status...
sc query windefend
pause
goto manage_defender

:enable_defender
echo Enabling Windows Defender...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f
echo Enabled Windows Defender.
pause
goto manage_defender

:disable_defender
echo WARNING: Disabling Windows Defender may leave your system vulnerable.
choice /c YN /n /m "Are you sure you want to disable Windows Defender? (Y/N): "
if errorlevel 2 goto manage_defender
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
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
choice /c ED /n /m "Do you want to enable (E) or disable (D) real-time protection? "
if errorlevel 2 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
    echo Real-time protection disabled. It is recommended to keep it enabled.
) else (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    echo Real-time protection enabled.
)
pause
goto manage_defender

:manage_cloud
echo Current cloud-delivered protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
choice /c ED /n /m "Do you want to enable (E) or disable (D) cloud-delivered protection? "
if errorlevel 2 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f
    echo Cloud-delivered protection disabled. It is recommended to keep it enabled for better protection.
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 2 /f
    echo Cloud-delivered protection enabled.
)
pause
goto manage_defender

:manage_samples
echo Current automatic sample submission status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
choice /c ED /n /m "Do you want to enable (E) or disable (D) automatic sample submission? "
if errorlevel 2 (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 0 /f
    echo Automatic sample submission disabled.
) else (
    reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 1 /f
    echo Automatic sample submission enabled.
)
pause
goto manage_defender

:view_history
echo Viewing threat history...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo Threat history displayed above. Check the output for details.
pause
goto manage_defender

:optimize_features
echo Optimizing system features...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
echo System features optimized.
pause
goto menu

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
choice /c 123456789 /n /m "Enter your choice (1-9): "

if errorlevel 9 goto menu
if errorlevel 8 goto adjust_visual_effects
if errorlevel 7 goto disable_services
if errorlevel 6 goto enable_gpu_scheduling
if errorlevel 5 goto adjust_power_management
if errorlevel 4 goto disable_core_parking
if errorlevel 3 goto optimize_scheduling
if errorlevel 2 goto disable_throttling
if errorlevel 1 goto set_high_performance
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
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
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f
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
echo Unnecessary system services disabled.
pause
goto optimize_cpu

:adjust_visual_effects
echo Adjusting visual effects for best performance...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo Visual effects adjusted for best performance.
pause
goto optimize_cpu

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
choice /c 123456 /n /m "Enter your choice (1-6): "

if errorlevel 6 goto menu
if errorlevel 5 goto clear_network_cache
if errorlevel 4 goto adapter_tuning
if errorlevel 3 goto dns_optimization
if errorlevel 2 goto advanced_tcp
if errorlevel 1 goto basic_optimizations
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
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f
echo Advanced TCP optimizations completed.
pause
goto optimize_internet

:dns_optimization
echo Optimizing DNS settings...
ipconfig /flushdns
netsh int ip set dns "Local Area Connection" static 8.8.8.8
netsh int ip add dns "Local Area Connection" 8.8.4.4 index=2
echo DNS optimized. Primary: 8.8.8.8, Secondary: 8.8.4.4
pause
goto optimize_internet

:adapter_tuning
echo Tuning network adapter...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*FlowControl' -RegistryValue 0"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*InterruptModeration' -RegistryValue 0"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
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

:windows_update
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
choice /c 123 /n /m "Enter your choice (1-3): "
if errorlevel 3 goto check_updates
if errorlevel 2 goto disable_windows_update
if errorlevel 1 goto enable_windows_update
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
cls
echo ==================================================
echo Disk Optimization
echo ==================================================
echo 1. Analyze disk
echo 2. Optimize/Defragment disk
echo 3. Check disk for errors
echo 4. Trim SSD
echo 5. Clean up system files
echo 6. Return to main menu
echo ==================================================
choice /c 123456 /n /m "Enter your choice (1-6): "

if errorlevel 6 goto menu
if errorlevel 5 goto cleanup_system
if errorlevel 4 goto trim_ssd
if errorlevel 3 goto check_disk
if errorlevel 2 goto optimize_defrag
if errorlevel 1 goto analyze_disk
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
goto optimize_disk

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
choice /c 12345 /n /m "Enter your choice (1-5): "

if errorlevel 5 goto menu
if errorlevel 4 goto verify_files
if errorlevel 3 goto check_disk_health
if errorlevel 2 goto run_dism
if errorlevel 1 goto run_sfc
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
choice /c 123456 /n /m "Enter your choice (1-6): "

if errorlevel 6 goto menu
if errorlevel 5 goto remove_key
if errorlevel 4 goto manual_key
if errorlevel 3 goto digital_activate
if errorlevel 2 goto kms_activate
if errorlevel 1 goto check_activation
goto windows_activate

:check_activation
echo Checking Windows activation status...
slmgr /xpr
pause
goto windows_activate

:kms_activate
echo Activating Windows using KMS...
slmgr /skms kms.digiboy.ir
slmgr /ato
echo KMS activation attempted. Please check the activation status.
pause
goto windows_activate

:digital_activate
echo Attempting to activate Windows using digital license...
slmgr /ato
echo Digital license activation attempted. Please check the activation status.
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
)
pause
goto windows_activate

:remove_key
echo Removing current product key...
slmgr /upk
echo Product key removed.
pause
goto windows_activate

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
choice /c 1234567890 /n /m "Enter your choice (1-10): "

if errorlevel 10 goto menu
if errorlevel 9 goto power_button_action
if errorlevel 8 goto lid_action
if errorlevel 7 goto adjust_timeouts
if errorlevel 6 goto configure_hibernate
if errorlevel 5 goto adjust_sleep
if errorlevel 4 goto delete_power_plan
if errorlevel 3 goto create_power_plan
if errorlevel 2 goto set_power_plan
if errorlevel 1 goto list_power_plans
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
echo Power plan set.
pause
goto manage_power

:create_power_plan
set /p plan_name=Enter a name for the new power plan: 
powercfg /duplicatescheme scheme_balanced %plan_name%
echo Power plan created.
pause
goto manage_power

:delete_power_plan
echo Available power plans:
powercfg /list
set /p del_guid=Enter the GUID of the power plan you want to delete: 
powercfg /delete %del_guid%
echo Power plan deleted.
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
choice /c ED /n /m "Do you want to enable (E) or disable (D) hibernation? "
if errorlevel 2 (
    powercfg /hibernate off
    echo Hibernation disabled.
) else (
    powercfg /hibernate on
    echo Hibernation enabled.
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
choice /c 1234 /n /m "Enter your choice for lid close action: "
set action=%errorlevel%
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
choice /c 1234 /n /m "Enter your choice for power button action: "
set action=%errorlevel%
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setactive scheme_current
echo Power button action configured.
pause
goto manage_power

:enable_dark_mode
echo Enabling Dark Mode...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
echo Dark Mode enabled.
pause
goto menu

:manage_partitions
cls
echo ==================================================
echo Partition Management
echo ==================================================
echo 1. List Partitions
echo 2. Create Partition
echo 3. Delete Partition
echo 4. Format Partition
echo 5. Return to main menu
echo ==================================================
choice /c 12345 /n /m "Enter your choice (1-5): "

if errorlevel 5 goto menu
if errorlevel 4 goto format_partition
if errorlevel 3 goto delete_partition
if errorlevel 2 goto create_partition
if errorlevel 1 goto list_partitions
goto manage_partitions

:list_partitions
echo Listing Partitions...
echo list disk > diskpart_script.txt
echo list volume >> diskpart_script.txt
diskpart /s diskpart_script.txt
del diskpart_script.txt
pause
goto manage_partitions

:create_partition
set /p disk_num=Enter disk number: 
set /p part_size=Enter partition size in MB: 
(
echo select disk %disk_num%
echo create partition primary size=%part_size%
) > diskpart_script.txt
diskpart /s diskpart_script.txt
del diskpart_script.txt
echo Partition created.
pause
goto manage_partitions

:delete_partition
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
(
echo select disk %disk_num%
echo select partition %part_num%
echo delete partition override
) > diskpart_script.txt
diskpart /s diskpart_script.txt
del diskpart_script.txt
echo Partition deleted.
pause
goto manage_partitions

:format_partition
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
set /p fs=Enter file system (NTFS/FAT32): 
(
echo select disk %disk_num%
echo select partition %part_num%
echo format fs=%fs% quick
) > diskpart_script.txt
diskpart /s diskpart_script.txt
del diskpart_script.txt
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
cls
echo ==================================================
echo Backup and Restore Settings
echo ==================================================
echo 1. Create system restore point
echo 2. Restore from a restore point
echo 3. Return to main menu
echo ==================================================
choice /c 123 /n /m "Enter your choice (1-3): "

if errorlevel 3 goto menu
if errorlevel 2 goto restore_point
if errorlevel 1 goto create_restore
goto backup_restore

:create_restore
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo System restore point created.
pause
goto backup_restore

:restore_point
echo Restoring from a restore point...
rstrui.exe
echo Please follow the on-screen instructions to restore your system.
pause
goto backup_restore

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
echo 2. Start a service
echo 3. Stop a service
echo 4. Change service startup type
echo 5. Return to main menu
echo ==================================================
choice /c 12345 /n /m "Enter your choice (1-5): "

if errorlevel 5 goto menu
if errorlevel 4 goto change_startup_type
if errorlevel 3 goto stop_service
if errorlevel 2 goto start_service
if errorlevel 1 goto list_all_services
goto manage_services

:list_all_services
sc query type= service state= all
pause
goto manage_services

:start_service
set /p service_name=Enter the name of the service to start: 
sc start "%service_name%"
pause
goto manage_services

:stop_service
set /p service_name=Enter the name of the service to stop: 
sc stop "%service_name%"
pause
goto manage_services

:change_startup_type
set /p service_name=Enter the name of the service: 
echo Select startup type:
echo 1. Automatic
echo 2. Manual
echo 3. Disabled
choice /c 123 /n /m "Enter your choice: "
if errorlevel 3 (
    sc config "%service_name%" start= disabled
) else if errorlevel 2 (
    sc config "%service_name%" start= demand
) else (
    sc config "%service_name%" start= auto
)
echo Service startup type changed.
pause
goto manage_services

:network_optimization
cls
echo ==================================================
echo Network Optimization
echo ==================================================
echo 1. Reset TCP/IP stack
echo 2. Clear DNS cache
echo 3. Reset Winsock catalog
echo 4. Enable/Disable IPv6
echo 5. Return to main menu
echo ==================================================
choice /c 12345 /n /m "Enter your choice (1-5): "

if errorlevel 5 goto menu
if errorlevel 4 goto toggle_ipv6
if errorlevel 3 goto reset_winsock
if errorlevel 2 goto clear_dns_cache
if errorlevel 1 goto reset_tcpip
goto network_optimization

:reset_tcpip
echo Resetting TCP/IP stack...
netsh int ip reset
echo TCP/IP stack reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:clear_dns_cache
echo Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared.
pause
goto network_optimization

:reset_winsock
echo Resetting Winsock catalog...
netsh winsock reset
echo Winsock catalog reset. Please restart your computer for changes to take effect.
pause
goto network_optimization

:toggle_ipv6
echo Current IPv6 status:
netsh interface ipv6 show global
choice /c ED /n /m "Do you want to enable (E) or disable (D) IPv6? "
if errorlevel 2 (
    netsh interface ipv6 set global randomizeidentifiers=disabled
    netsh interface ipv6 set privacy state=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 disabled.
) else (
    netsh interface ipv6 set global randomizeidentifiers=enabled
    netsh interface ipv6 set privacy state=enabled
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /f
    echo IPv6 enabled.
)
echo Please restart your computer for changes to take effect.
pause
goto network_optimization

:endexit
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 3.0
pause
exit
