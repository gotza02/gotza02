@echo off
setlocal enabledelayedexpansion

:: Initialize variables
set "logfile=%userprofile%\Desktop\optimization_log.txt"
set "restart_required=0"

:: Check for administrator privileges
:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Right-click the script and select "Run as administrator".
    pause
    exit /b 1
)
echo Script started with admin privileges. >"%logfile%"
echo Started: %date% %time% >>"%logfile%"

:menu
cls
echo ==================================================
echo Windows Optimization Script v3.1
echo Purpose: Optimize and manage Windows settings
echo Version: 3.1 - Enhanced safety and usability
echo ==================================================
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
echo 23. Help - View option descriptions
echo ==================================================
set /p choice=Enter your choice (1-23): 

:: Enhanced input validation
if "!choice!"=="" (
    echo Error: No input provided. Please enter a number between 1 and 23.
    pause
    goto menu
)
echo !choice!| findstr /r "^[0-9][0-9]*$" >nul || (
    echo Error: Invalid input. Please enter a numeric value.
    pause
    goto menu
)
if !choice! lss 1 if !choice! gtr 23 (
    echo Error: Choice out of range. Select 1-23.
    pause
    goto menu
)
goto option_!choice!

:option_1
:optimize_display
cls
echo WARNING: This will disable visual effects to boost performance but may reduce visual quality.
set /p confirm=Proceed? (Y/N): 
if /i "!confirm!" neq "Y" goto menu
echo Optimizing display performance...
echo [%date% %time%] Optimizing display performance >>"%logfile%"
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo Display performance optimized.
echo [%date% %time%] Display optimization completed >>"%logfile%"
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

if "!def_choice!"=="1" goto check_defender
if "!def_choice!"=="2" goto enable_defender
if "!def_choice!"=="3" goto disable_defender
if "!def_choice!"=="4" goto update_defender
if "!def_choice!"=="5" goto quick_scan
if "!def_choice!"=="6" goto full_scan
if "!def_choice!"=="7" goto manage_realtime
if "!def_choice!"=="8" goto manage_cloud
if "!def_choice!"=="9" goto manage_samples
if "!def_choice!"=="10" goto view_history
if "!def_choice!"=="11" goto menu
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
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
echo Enabled Windows Defender.
echo [%date% %time%] Enabled Windows Defender >>"%logfile%"
pause
goto manage_defender

:disable_defender
cls
echo WARNING: Disabling Windows Defender may expose your system to security risks.
echo Are you sure you want to proceed?
set /p confirm=Type YES to confirm: 
if /i "!confirm!" neq "YES" (
    echo Operation cancelled.
    pause
    goto manage_defender
)
echo Disabling Windows Defender...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
echo Disabled Windows Defender.
echo [%date% %time%] Disabled Windows Defender >>"%logfile%"
pause
goto manage_defender

:update_defender
echo Updating Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo Windows Defender updated successfully.
    echo [%date% %time%] Windows Defender updated >>"%logfile%"
) else (
    echo Failed to update Windows Defender. Please check your internet connection.
    echo [%date% %time%] Failed to update Windows Defender >>"%logfile%"
)
pause
goto manage_defender

:quick_scan
echo Running quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo Quick scan completed.
echo [%date% %time%] Quick scan completed >>"%logfile%"
pause
goto manage_defender

:full_scan
echo Running full scan...
echo This may take a while. You can check the progress in Windows Security.
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [%date% %time%] Full scan started >>"%logfile%"
pause
goto manage_defender

:manage_realtime
echo Current real-time protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
set /p rtp_choice=Do you want to enable (E) or disable (D) real-time protection? (E/D): 
if /i "!rtp_choice!"=="E" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    echo Real-time protection enabled.
    echo [%date% %time%] Real-time protection enabled >>"%logfile%"
) else if /i "!rtp_choice!"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    echo Real-time protection disabled. It is recommended to keep it enabled.
    echo [%date% %time%] Real-time protection disabled >>"%logfile%"
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:manage_cloud
echo Current cloud-delivered protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
set /p cloud_choice=Do you want to enable (E) or disable (D) cloud-delivered protection? (E/D): 
if /i "!cloud_choice!"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "2"
    echo Cloud-delivered protection enabled.
    echo [%date% %time%] Cloud-delivered protection enabled >>"%logfile%"
) else if /i "!cloud_choice!"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    echo Cloud-delivered protection disabled. It is recommended to keep it enabled for better protection.
    echo [%date% %time%] Cloud-delivered protection disabled >>"%logfile%"
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:manage_samples
echo Current automatic sample submission status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
set /p sample_choice=Do you want to enable (E) or disable (D) automatic sample submission? (E/D): 
if /i "!sample_choice!"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
    echo Automatic sample submission enabled.
    echo [%date% %time%] Automatic sample submission enabled >>"%logfile%"
) else if /i "!sample_choice!"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "0"
    echo Automatic sample submission disabled.
    echo [%date% %time%] Automatic sample submission disabled >>"%logfile%"
) else (
    echo Invalid choice.
)
pause
goto manage_defender

:view_history
echo Viewing threat history...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo Threat history displayed above. Check the output for details.
echo [%date% %time%] Viewed threat history >>"%logfile%"
pause
goto manage_defender

:option_3
:optimize_features
cls
echo Optimizing system features...
echo This will disable certain features to improve performance. You can choose which ones to disable.
echo.

:: Disable Activity Feed
set /p disable_activity=Disable Activity Feed? (Y/N): 
if /i "!disable_activity!"=="Y" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
    echo Activity Feed disabled.
    echo [%date% %time%] Activity Feed disabled >>"%logfile%"
)

:: Disable background apps
set /p disable_bgapps=Disable background apps? (Y/N): 
if /i "!disable_bgapps!"=="Y" (
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
    echo Background apps disabled.
    echo [%date% %time%] Background apps disabled >>"%logfile%"
)

:: Disable Cortana
set /p disable_cortana=Disable Cortana? (Y/N): 
if /i "!disable_cortana!"=="Y" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
    echo Cortana disabled.
    echo [%date% %time%] Cortana disabled >>"%logfile%"
)

:: Disable Game DVR and Game Bar
set /p disable_gamedvr=Disable Game DVR and Game Bar? (Y/N): 
if /i "!disable_gamedvr!"=="Y" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
    call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
    echo Game DVR and Game Bar disabled.
    echo [%date% %time%] Game DVR and Game Bar disabled >>"%logfile%"
)

:: Disable Sticky Keys prompt
set /p disable_sticky=Disable Sticky Keys prompt? (Y/N): 
if /i "!disable_sticky!"=="Y" (
    call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
    echo Sticky Keys prompt disabled.
    echo [%date% %time%] Sticky Keys prompt disabled >>"%logfile%"
)

:: Disable Windows Tips
set /p disable_tips=Disable Windows Tips? (Y/N): 
if /i "!disable_tips!"=="Y" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
    echo Windows Tips disabled.
    echo [%date% %time%] Windows Tips disabled >>"%logfile%"
)

:: Disable Start Menu suggestions
set /p disable_suggestions=Disable Start Menu suggestions? (Y/N): 
if /i "!disable_suggestions!"=="Y" (
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
    echo Start Menu suggestions disabled.
    echo [%date% %time%] Start Menu suggestions disabled >>"%logfile%"
)

:: Enable Fast Startup
set /p enable_faststartup=Enable Fast Startup? (Y/N): 
if /i "!enable_faststartup!"=="Y" (
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
    echo Fast Startup enabled.
    echo [%date% %time%] Fast Startup enabled >>"%logfile%"
)

echo System features optimized based on your choices.
echo [%date% %time%] System features optimization completed >>"%logfile%"
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

if "!cpu_choice!"=="1" goto set_high_performance
if "!cpu_choice!"=="2" goto disable_throttling
if "!cpu_choice!"=="3" goto optimize_scheduling
if "!cpu_choice!"=="4" goto disable_core_parking
if "!cpu_choice!"=="5" goto adjust_power_management
if "!cpu_choice!"=="6" goto enable_gpu_scheduling
if "!cpu_choice!"=="7" goto disable_services
if "!cpu_choice!"=="8" goto adjust_visual_effects
if "!cpu_choice!"=="9" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_cpu

:set_high_performance
cls
echo Setting High Performance power plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 (
    echo Failed to set High Performance power plan. Creating a new one...
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid=%%i
    powercfg -setactive !hp_guid!
)
echo High Performance power plan set.
echo [%date% %time%] Set High Performance power plan >>"%logfile%"
pause
goto optimize_cpu

:disable_throttling
echo Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo CPU throttling disabled.
echo [%date% %time%] Disabled CPU throttling >>"%logfile%"
pause
goto optimize_cpu

:optimize_scheduling
echo Optimizing processor scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo Processor scheduling optimized for best performance of programs.
echo [%date% %time%] Optimized processor scheduling >>"%logfile%"
pause
goto optimize_cpu

:disable_core_parking
echo Disabling CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo CPU core parking disabled.
echo [%date% %time%] Disabled CPU core parking >>"%logfile%"
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
echo [%date% %time%] Adjusted processor power management >>"%logfile%"
pause
goto optimize_cpu

:enable_gpu_scheduling
echo Enabling hardware-accelerated GPU scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled. Please restart your computer for changes to take effect.
set restart_required=1
echo [%date% %time%] Enabled hardware-accelerated GPU scheduling >>"%logfile%"
pause
goto optimize_cpu

:disable_services
cls
echo Disabling unnecessary system services...
echo This may affect system functionality. Proceed with caution.
set /p confirm=Continue? (Y/N): 
if /i "!confirm!" neq "Y" goto optimize_cpu
sc config "SysMain" start= disabled
sc stop "SysMain"
sc config "DiagTrack" start= disabled
sc stop "DiagTrack"
sc config "WSearch" start= disabled
sc stop "WSearch"
echo Unnecessary system services disabled.
echo [%date% %time%] Disabled unnecessary system services >>"%logfile%"
pause
goto optimize_cpu

:adjust_visual_effects
echo Adjusting visual effects for best performance...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo Visual effects adjusted for best performance.
echo [%date% %time%] Adjusted visual effects for performance >>"%logfile%"
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

if "!net_choice!"=="1" goto basic_optimizations
if "!net_choice!"=="2" goto advanced_tcp
if "!net_choice!"=="3" goto dns_optimization
if "!net_choice!"=="4" goto adapter_tuning
if "!net_choice!"=="5" goto clear_network_cache
if "!net_choice!"=="6" goto menu
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
echo [%date% %time%] Performed basic Internet optimizations >>"%logfile%"
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
echo [%date% %time%] Performed advanced TCP optimizations >>"%logfile%"
pause
goto optimize_internet

:dns_optimization
echo Optimizing DNS settings...
ipconfig /flushdns
netsh int ip set dns "Local Area Connection" static 8.8.8.8
netsh int ip add dns "Local Area Connection" 8.8.4.4 index=2
echo DNS optimized. Primary: 8.8.8.8, Secondary: 8.8.4.4
echo [%date% %time%] Optimized DNS settings >>"%logfile%"
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
echo [%date% %time%] Tuned network adapter >>"%logfile%"
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
echo [%date% %time%] Cleared network cache >>"%logfile%"
pause
goto optimize_internet

:option_6
:windows_update
cls
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
set /p update_choice=Enter your choice (1-3): 
if "!update_choice!"=="1" goto enable_windows_update
if "!update_choice!"=="2" goto disable_windows_update
if "!update_choice!"=="3" goto check_updates
goto menu

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% neq 0 (
    echo Failed to enable Windows Update. Please check your permissions.
    echo [%date% %time%] Failed to enable Windows Update >>"%logfile%"
) else (
    echo Windows Update enabled.
    echo [%date% %time%] Enabled Windows Update >>"%logfile%"
)
pause
goto windows_update

:disable_windows_update
cls
echo WARNING: Disabling Windows Update may leave your system vulnerable to security threats.
echo Are you sure you want to proceed?
set /p confirm=Type YES to confirm: 
if /i "!confirm!" neq "YES" (
    echo Operation cancelled.
    pause
    goto windows_update
)
echo Disabling Windows Update...
sc config wuauserv start= disabled
sc stop wuauserv
if %errorlevel% neq 0 (
    echo Failed to disable Windows Update. Please check your permissions.
    echo [%date% %time%] Failed to disable Windows Update >>"%logfile%"
) else (
    echo Windows Update disabled.
    echo [%date% %time%] Disabled Windows Update >>"%logfile%"
)
pause
goto windows_update

:check_updates
echo Checking for Windows updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated. Please check Windows Update in Settings for results.
echo [%date% %time%] Checked for Windows updates >>"%logfile%"
pause
goto windows_update

:option_7
:auto_login
cls
echo Configuring Auto-login...
echo WARNING: This will store your password in plain text in the registry, which is a security risk.
set /p confirm=Proceed? (Y/N): 
if /i "!confirm!" neq "Y" goto menu
set /p username=Enter username: 
set /p password=Enter password: 
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "!username!"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "!password!"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo Auto-login configured.
echo [%date% %time%] Configured auto-login >>"%logfile%"
pause
goto menu

:option_8
:clear_cache
echo Clearing system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo System cache cleared.
echo [%date% %time%] Cleared system cache >>"%logfile%"
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
echo 6. Return to main menu
echo ==================================================
set /p disk_choice=Enter your choice (1-6): 

if "!disk_choice!"=="1" goto analyze_disk
if "!disk_choice!"=="2" goto optimize_defrag
if "!disk_choice!"=="3" goto check_disk
if "!disk_choice!"=="4" goto trim_ssd
if "!disk_choice!"=="5" goto cleanup_system
if "!disk_choice!"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk
echo Analyzing disk...
defrag C: /A
echo Disk analysis completed.
echo [%date% %time%] Analyzed disk >>"%logfile%"
pause
goto optimize_disk

:optimize_defrag
echo Optimizing/Defragmenting disk...
defrag C: /O
echo Disk optimization completed.
echo [%date% %time%] Optimized/Defragmented disk >>"%logfile%"
pause
goto optimize_disk

:check_disk
echo Checking disk for errors...
echo This process will schedule a disk check on the next system restart.
chkdsk C: /F /R /X
echo Disk check scheduled. Please restart your computer to perform the check.
set restart_required=1
echo [%date% %time%] Scheduled disk check >>"%logfile%"
pause
goto optimize_disk

:trim_ssd
echo Trimming SSD...
fsutil behavior set disabledeletenotify 0
defrag C: /L
echo SSD trim completed.
echo [%date% %time%] Trimmed SSD >>"%logfile%"
pause
goto optimize_disk

:cleanup_system
echo Cleaning up system files...
cleanmgr /sagerun:1
echo System file cleanup completed.
echo [%date% %time%] Cleaned up system files >>"%logfile%"
pause
goto optimize_disk

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

if "!repair_choice!"=="1" goto run_sfc
if "!repair_choice!"=="2" goto run_dism
if "!repair_choice!"=="3" goto check_disk_health
if "!repair_choice!"=="4" goto verify_files
if "!repair_choice!"=="5" goto menu
echo Invalid choice. Please try again.
pause
goto check_repair

:run_sfc
echo Running System File Checker...
sfc /scannow
echo SFC scan completed.
echo [%date% %time%] Ran SFC scan >>"%logfile%"
pause
goto check_repair

:run_dism
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM repair completed.
echo [%date% %time%] Ran DISM repair >>"%logfile%"
pause
goto check_repair

:check_disk_health
echo Checking disk health...
wmic diskdrive get status
echo Disk health check completed.
echo [%date% %time%] Checked disk health >>"%logfile%"
pause
goto check_repair

:verify_files
echo Verifying system files...
Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
echo Verification completed. Results saved to sfcdetails.txt on your desktop.
echo [%date% %time%] Verified system files >>"%logfile%"
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

if "!activate_choice!"=="1" goto check_activation
if "!activate_choice!"=="2" goto kms_activate
if "!activate_choice!"=="3" goto digital_activate
if "!activate_choice!"=="4" goto manual_key
if "!activate_choice!"=="5" goto remove_key
if "!activate_choice!"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows_activate

:check_activation
echo Checking Windows activation status...
slmgr /xpr
pause
goto windows_activate

:kms_activate
cls
echo NOTE: KMS activation is for Volume License versions only. Ensure you have the proper licensing.
set /p confirm=Proceed with KMS activation? (Y/N): 
if /i "!confirm!" neq "Y" goto windows_activate
net session >nul 2>&1
if %errorlevel% == 0 (
    powershell -command "irm https://get.activated.win | iex"
) else (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
)
echo [%date% %time%] Attempted KMS activation >>"%logfile%"
pause
goto windows_activate

:digital_activate
echo Attempting to activate Windows using digital license...
slmgr /ato
if %errorlevel% neq 0 (
    echo Digital license activation failed. Your PC may not have a digital license.
    echo [%date% %time%] Digital license activation failed >>"%logfile%"
) else (
    echo Digital license activation attempted. Please check the activation status.
    echo [%date% %time%] Attempted digital license activation >>"%logfile%"
)
pause
goto windows_activate

:manual_key
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX): 
echo Installing product key...
slmgr /ipk !product_key!
if %errorlevel% neq 0 (
    echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
    echo [%date% %time%] Failed to install product key >>"%logfile%"
) else (
    echo Product key installed. Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your product key and try again.
        echo [%date% %time%] Activation failed >>"%logfile%"
    ) else (
        echo Windows activation attempted. Please check the activation status.
        echo [%date% %time%] Attempted activation with product key >>"%logfile%"
    )
)
pause
goto windows_activate

:remove_key
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key. You may not have permission or there's no key to remove.
    echo [%date% %time%] Failed to remove product key >>"%logfile%"
) else (
    echo Product key removed successfully.
    echo [%date% %time%] Removed product key >>"%logfile%"
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

if "!power_choice!"=="1" goto list_power_plans
if "!power_choice!"=="2" goto set_power_plan
if "!power_choice!"=="3" goto create_power_plan
if "!power_choice!"=="4" goto delete_power_plan
if "!power_choice!"=="5" goto adjust_sleep
if "!power_choice!"=="6" goto configure_hibernate
if "!power_choice!"=="7" goto adjust_timeouts
if "!power_choice!"=="8" goto lid_action
if "!power_choice!"=="9" goto power_button_action
if "!power_choice!"=="10" goto menu
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
powercfg /setactive !plan_guid!
if %errorlevel% neq 0 (
    echo Failed to set power plan. Please check the GUID and try again.
    echo [%date% %time%] Failed to set power plan >>"%logfile%"
) else (
    echo Power plan set successfully.
    echo [%date% %time%] Set power plan to !plan_guid! >>"%logfile%"
)
pause
goto manage_power

:create_power_plan
set /p plan_name=Enter a name for the new power plan: 
powercfg /duplicatescheme scheme_balanced
powercfg /changename !plan_name!
if %errorlevel% neq 0 (
    echo Failed to create power plan.
    echo [%date% %time%] Failed to create power plan >>"%logfile%"
) else (
    echo Power plan created successfully.
    echo [%date% %time%] Created power plan !plan_name! >>"%logfile%"
)
pause
goto manage_power

:delete_power_plan
echo Available power plans:
powercfg /list
set /p del_guid=Enter the GUID of the power plan you want to delete: 
powercfg /delete !del_guid!
if %errorlevel% neq 0 (
    echo Failed to delete power plan. Please check the GUID and try again.
    echo [%date% %time%] Failed to delete power plan >>"%logfile%"
) else (
    echo Power plan deleted successfully.
    echo [%date% %time%] Deleted power plan !del_guid! >>"%logfile%"
)
pause
goto manage_power

:adjust_sleep
set /p sleep_time=Enter the number of minutes before the system goes to sleep (0 to never sleep): 
powercfg /change standby-timeout-ac !sleep_time!
powercfg /change standby-timeout-dc !sleep_time!
echo Sleep settings adjusted.
echo [%date% %time%] Adjusted sleep settings to !sleep_time! minutes >>"%logfile%"
pause
goto manage_power

:configure_hibernate
echo 1. Enable hibernation
echo 2. Disable hibernation
set /p hib_choice=Enter your choice (1-2): 
if "!hib_choice!"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
    echo [%date% %time%] Enabled hibernation >>"%logfile%"
) else if "!hib_choice!"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
    echo [%date% %time%] Disabled hibernation >>"%logfile%"
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
powercfg /change monitor-timeout-ac !display_ac!
powercfg /change monitor-timeout-dc !display_dc!
powercfg /change standby-timeout-ac !sleep_ac!
powercfg /change standby-timeout-dc !sleep_dc!
echo Display and sleep timeouts adjusted.
echo [%date% %time%] Adjusted display and sleep timeouts >>"%logfile%"
pause
goto manage_power

:lid_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p lid_choice=Enter your choice for lid close action (1-4): 
if "!lid_choice!"=="1" set action=0
if "!lid_choice!"=="2" set action=1
if "!lid_choice!"=="3" set action=2
if "!lid_choice!"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons lidaction !action!
powercfg /setdcvalueindex scheme_current sub_buttons lidaction !action!
powercfg /setactive scheme_current
echo Lid close action configured.
echo [%date% %time%] Configured lid close action >>"%logfile%"
pause
goto manage_power

:power_button_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p button_choice=Enter your choice for power button action (1-4): 
if "!button_choice!"=="1" set action=0
if "!button_choice!"=="2" set action=1
if "!button_choice!"=="3" set action=2
if "!button_choice!"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction !action!
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction !action!
powercfg /setactive scheme_current
echo Power button action configured.
echo [%date% %time%] Configured power button action >>"%logfile%"
pause
goto manage_power

:option_13
:enable_dark_mode
echo Enabling Dark Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo Dark Mode enabled.
echo [%date% %time%] Enabled Dark Mode >>"%logfile%"
pause
goto menu

:option_14
:manage_partitions
cls
echo Partition Management
echo WARNING: Modifying partitions can lead to data loss. Proceed with caution.
set /p confirm=Continue? (Y/N): 
if /i "!confirm!" neq "Y" goto menu
echo 1. List Partitions
echo 2. Create Partition
echo 3. Delete Partition
echo 4. Format Partition
set /p part_choice=Enter your choice (1-4): 
if "!part_choice!"=="1" goto list_partitions
if "!part_choice!"=="2" goto create_partition
if "!part_choice!"=="3" goto delete_partition
if "!part_choice!"=="4" goto format_partition
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
echo select disk !disk_num!
echo create partition primary size=!part_size!
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo Partition created.
echo [%date% %time%] Created partition on disk !disk_num! >>"%logfile%"
pause
goto manage_partitions

:delete_partition
cls
echo WARNING: Deleting a partition will erase all data on it. This action cannot be undone.
set /p confirm=Type DELETE to confirm: 
if /i "!confirm!" neq "DELETE" (
    echo Operation cancelled.
    pause
    goto manage_partitions
)
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
(
echo select disk !disk_num!
echo select partition !part_num!
echo delete partition override
) > delete_part.txt
diskpart /s delete_part.txt
del delete_part.txt
echo Partition deleted.
echo [%date% %time%] Deleted partition !part_num! on disk !disk_num! >>"%logfile%"
pause
goto manage_partitions

:format_partition
echo Formatting Partition...
set /p disk_num=Enter disk number: 
set /p part_num=Enter partition number: 
set /p fs=Enter file system (NTFS/FAT32): 
(
echo select disk !disk_num!
echo select partition !part_num!
echo format fs=!fs! quick
) > format_part.txt
diskpart /s format_part.txt
del format_part.txt
echo Partition formatted.
echo [%date% %time%] Formatted partition !part_num! on disk !disk_num! with !fs! >>"%logfile%"
pause
goto manage_partitions

:option_15
:clean_disk
echo Cleaning up disk space...
cleanmgr /sagerun:1
echo Disk cleanup completed.
echo [%date% %time%] Cleaned up disk space >>"%logfile%"
pause
goto menu

:option_16
:manage_startup
echo Managing startup programs...
start msconfig
echo Please use the System Configuration utility to manage startup programs.
echo [%date% %time%] Opened System Configuration for startup management >>"%logfile%"
pause
goto menu

:option_17
:backup_restore
cls
echo Backup and Restore Settings
echo 1. Create system restore point
echo 2. Restore from a restore point
set /p backup_choice=Enter your choice (1-2): 
if "!backup_choice!"=="1" goto create_restore
if "!backup_choice!"=="2" goto restore_point
goto menu

:create_restore
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo System restore point created.
echo [%date% %time%] Created system restore point >>"%logfile%"
pause
goto menu

:restore_point
echo Restoring from a restore point...
rstrui.exe
echo Please follow the on-screen instructions to restore your system.
echo [%date% %time%] Initiated system restore >>"%logfile%"
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
echo [%date% %time%] Optimized privacy settings >>"%logfile%"
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

if "!service_choice!"=="1" goto list_all_services
if "!service_choice!"=="2" goto list_running_services
if "!service_choice!"=="3" goto list_stopped_services
if "!service_choice!"=="4" goto start_service
if "!service_choice!"=="5" goto stop_service
if "!service_choice!"=="6" goto restart_service
if "!service_choice!"=="7" goto change_startup_type
if "!service_choice!"=="8" goto search_service
if "!service_choice!"=="9" goto view_service_details
if "!service_choice!"=="10" goto menu
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
sc start "!service_name!"
if %errorlevel% neq 0 (
    echo Failed to start the service. Please check the service name and your permissions.
    echo [%date% %time%] Failed to start service !service_name! >>"%logfile%"
) else (
    echo Service start attempted. Please check the status.
    echo [%date% %time%] Attempted to start service !service_name! >>"%logfile%"
)
pause
goto manage_services

:stop_service
set /p service_name=Enter the name of the service to stop: 
sc stop "!service_name!"
if %errorlevel% neq 0 (
    echo Failed to stop the service. Please check the service name and your permissions.
    echo [%date% %time%] Failed to stop service !service_name! >>"%logfile%"
) else (
    echo Service stop attempted. Please check the status.
    echo [%date% %time%] Attempted to stop service !service_name! >>"%logfile%"
)
pause
goto manage_services

:restart_service
set /p service_name=Enter the name of the service to restart: 
sc stop "!service_name!"
timeout /t 2 >nul
sc start "!service_name!"
if %errorlevel% neq 0 (
    echo Failed to restart the service. Please check the service name and your permissions.
    echo [%date% %time%] Failed to restart service !service_name! >>"%logfile%"
) else (
    echo Service restart attempted. Please check the status.
    echo [%date% %time%] Attempted to restart service !service_name! >>"%logfile%"
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
if "!startup_choice!"=="1" (
    sc config "!service_name!" start= auto
) else if "!startup_choice!"=="2" (
    sc config "!service_name!" start= delayed-auto
) else if "!startup_choice!"=="3" (
    sc config "!service_name!" start= demand
) else if "!startup_choice!"=="4" (
    sc config "!service_name!" start= disabled
) else (
    echo Invalid choice.
    pause
    goto manage_services
)
if %errorlevel% neq 0 (
    echo Failed to change startup type. Please check the service name and your permissions.
    echo [%date% %time%] Failed to change startup type for !service_name! >>"%logfile%"
) else (
    echo Startup type changed successfully.
    echo [%date% %time%] Changed startup type for !service_name! >>"%logfile%"
)
pause
goto manage_services

:search_service
set /p search_term=Enter search term for service name: 
sc query state= all | findstr /i "!search_term!"
pause
goto manage_services

:view_service_details
set /p service_name=Enter the name of the service to view details: 
sc qc "!service_name!"
echo.
echo Current Status:
sc query "!service_name!"
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

if "!net_choice!"=="1" goto optimize_tcp
if "!net_choice!"=="2" goto reset_winsock
if "!net_choice!"=="3" goto clear_dns
if "!net_choice!"=="4" goto optimize_adapter
if "!net_choice!"=="5" goto disable_ipv6
if "!net_choice!"=="6" goto enable_qos
if "!net_choice!"=="7" goto set_static_dns
if "!net_choice!"=="8" goto reset_network
if "!net_choice!"=="9" goto menu
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
echo [%date% %time%] Optimized TCP settings >>"%logfile%"
pause
goto network_optimization

:reset_winsock
echo Resetting Windows Sockets...
netsh winsock reset
echo Windows Sockets reset. Please restart your computer for changes to take effect.
set restart_required=1
echo [%date% %time%] Reset Windows Sockets >>"%logfile%"
pause
goto network_optimization

:clear_dns
echo Clearing DNS cache...
ipconfig /flushdns
echo DNS cache cleared.
echo [%date% %time%] Cleared DNS cache >>"%logfile%"
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
echo [%date% %time%] Optimized network adapter settings >>"%logfile%"
pause
goto network_optimization

:disable_ipv6
cls
echo WARNING: Disabling IPv6 may cause issues with some networks.
set /p confirm=Are you sure you want to disable IPv6? (Y/N): 
if /i "!confirm!"=="Y" (
    netsh interface ipv6 set global randomizeidentifiers=disabled
    netsh interface ipv6 set privacy state=disabled
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 disabled. Please restart your computer for changes to take effect.
    set restart_required=1
    echo [%date% %time%] Disabled IPv6 >>"%logfile%"
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
echo [%date% %time%] Enabled QoS packet scheduler >>"%logfile%"
pause
goto network_optimization

:set_static_dns
echo Setting static DNS servers...
set /p primary_dns=Enter primary DNS server (e.g., 8.8.8.8): 
set /p secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4): 
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%j" static !primary_dns! primary
    netsh interface ip add dns "%%j" !secondary_dns! index=2
)
echo Static DNS servers set.
echo [%date% %time%] Set static DNS servers >>"%logfile%"
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
set restart_required=1
echo [%date% %time%] Reset all network settings >>"%logfile%"
pause
goto network_optimization

:option_22
:endexit
if !restart_required! equ 1 (
    echo Some changes require a system restart to take effect.
    set /p restart=Restart now? (Y/N): 
    if /i "!restart!"=="Y" shutdown /r /t 0
)
echo Thank you for using the Windows Optimization Script!
echo Log saved to: %logfile%
pause
exit

:modify_registry
reg add %1 /v %2 /t %3 /d %4 /f >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to modify registry: %1\%2 with value %4
    echo [%date% %time%] FAILED: reg add %1 /v %2 /t %3 /d %4 >>"%logfile%"
    pause
) else (
    echo [%date% %time%] SUCCESS: reg add %1 /v %2 /t %3 /d %4 >>"%logfile%"
)
exit /b 0

:option_23
:help
cls
echo === Help: Option Descriptions ===
echo 1. Optimize display performance - Disables visual effects to improve speed.
echo 2. Manage Windows Defender - Controls Defender settings and scans.
echo 3. Optimize system features - Disables unnecessary features for performance.
echo 4. Optimize CPU performance - Tweaks CPU settings for better performance.
echo 5. Optimize Internet performance - Enhances network settings.
echo 6. Manage Windows Update - Controls Windows Update service.
echo 7. Configure Auto-login - Sets up automatic login (security risk).
echo 8. Clear system cache - Removes temporary files.
echo 9. Optimize disk - Analyzes, defrags, or trims disks.
echo 10. Check and repair system files - Runs SFC and DISM.
echo 11. Activate Windows - Manages Windows activation.
echo 12. Manage power settings - Adjusts power plans and settings.
echo 13. Enable Dark Mode - Switches to dark theme.
echo 14. Manage partitions - Lists, creates, deletes, or formats partitions.
echo 15. Clean up disk space - Runs disk cleanup utility.
echo 16. Manage startup programs - Opens System Configuration.
echo 17. Backup and restore settings - Creates or restores system restore points.
echo 18. System information - Displays system details.
echo 19. Optimize privacy settings - Adjusts telemetry and advertising settings.
echo 20. Manage Windows services - Controls system services.
echo 21. Network optimization - Tweaks network settings.
echo 22. Exit - Closes the script.
echo 23. Help - Displays this menu.
pause
goto menu
