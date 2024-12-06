@echo off
setlocal enabledelayedexpansion

REM ==========================================================
REM Check for Administrator Privileges
REM ==========================================================
:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

REM ==========================================================
REM Main Menu Function
REM ==========================================================
:main_menu
cls
echo ==================================================
echo Windows Optimization Script v3.1
echo ==================================================
echo Please select an option:
echo  1. Optimize display performance
echo  2. Manage Windows Defender
echo  3. Optimize system features
echo  4. Optimize CPU performance
echo  5. Optimize Internet performance
echo  6. Manage Windows Update
echo  7. Configure Auto-login
echo  8. Clear system cache
echo  9. Optimize disk
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

REM Validate user input:
if "%choice%"=="" (
    echo Invalid choice. Please try again.
    pause
    goto main_menu
)

REM Check if choice is a number between 1 and 22
for /f "delims=0123456789" %%i in ("%choice%") do (
    echo Invalid choice. Please try again.
    pause
    goto main_menu
)

if %choice% geq 1 if %choice% leq 22 (
    goto option_%choice%
) else (
    echo Invalid choice. Please try again.
    pause
    goto main_menu
)

REM ==========================================================
REM Option 1: Optimize Display Performance
REM ==========================================================
:option_1
echo Optimizing display performance...
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo Display performance optimized.
pause
goto main_menu

REM ==========================================================
REM Option 2: Manage Windows Defender (Sub-menu)
REM ==========================================================
:option_2
call :defender_menu
goto main_menu

:defender_menu
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

if /i "%def_choice%"=="1" goto check_defender
if /i "%def_choice%"=="2" goto enable_defender
if /i "%def_choice%"=="3" goto disable_defender
if /i "%def_choice%"=="4" goto update_defender
if /i "%def_choice%"=="5" goto quick_scan
if /i "%def_choice%"=="6" goto full_scan
if /i "%def_choice%"=="7" goto manage_realtime
if /i "%def_choice%"=="8" goto manage_cloud
if /i "%def_choice%"=="9" goto manage_samples
if /i "%def_choice%"=="10" goto view_history
if /i "%def_choice%"=="11" (
    goto main_menu
) else (
    echo Invalid choice. Please try again.
    pause
    goto defender_menu
)

:check_defender
echo Checking Windows Defender status...
sc query windefend
pause
goto defender_menu

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
pause
goto defender_menu

:disable_defender
echo WARNING: Disabling Windows Defender may leave your system vulnerable.
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
echo Disabled Windows Defender.
pause
goto defender_menu

:update_defender
echo Updating Windows Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo Windows Defender updated successfully.
) else (
    echo Failed to update Windows Defender. Please check your internet connection.
)
pause
goto defender_menu

:quick_scan
echo Running quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo Quick scan completed.
pause
goto defender_menu

:full_scan
echo Running full scan... This may take a while.
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
pause
goto defender_menu

:manage_realtime
echo Current real-time protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
set /p rtp_choice=Enable (E) or Disable (D) real-time protection? (E/D): 
if /i "%rtp_choice%"=="E" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
    echo Real-time protection enabled.
) else if /i "%rtp_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    echo Real-time protection disabled. (Not recommended)
) else (
    echo Invalid choice.
)
pause
goto defender_menu

:manage_cloud
echo Current cloud-delivered protection status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
set /p cloud_choice=Enable (E) or Disable (D) cloud-delivered protection? (E/D): 
if /i "%cloud_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "2"
    echo Cloud-delivered protection enabled.
) else if /i "%cloud_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    echo Cloud-delivered protection disabled. (Not recommended)
) else (
    echo Invalid choice.
)
pause
goto defender_menu

:manage_samples
echo Current automatic sample submission status:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
set /p sample_choice=Enable (E) or Disable (D) automatic sample submission? (E/D): 
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
goto defender_menu

:view_history
echo Viewing threat history...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo Threat history displayed above.
pause
goto defender_menu

REM ==========================================================
REM Option 3: Optimize system features
REM ==========================================================
:option_3
echo Optimizing system features...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
echo System features optimized.
pause
goto main_menu

REM ==========================================================
REM Option 4: Optimize CPU Performance (Sub-menu)
REM ==========================================================
:option_4
call :cpu_menu
goto main_menu

:cpu_menu
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

if /i "%cpu_choice%"=="1" goto set_high_performance
if /i "%cpu_choice%"=="2" goto disable_throttling
if /i "%cpu_choice%"=="3" goto optimize_scheduling
if /i "%cpu_choice%"=="4" goto disable_core_parking
if /i "%cpu_choice%"=="5" goto adjust_power_management
if /i "%cpu_choice%"=="6" goto enable_gpu_scheduling
if /i "%cpu_choice%"=="7" goto disable_services
if /i "%cpu_choice%"=="8" goto adjust_visual_effects
if /i "%cpu_choice%"=="9" goto main_menu

echo Invalid choice. Please try again.
pause
goto cpu_menu

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
goto cpu_menu

:disable_throttling
echo Disabling CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo CPU throttling disabled.
pause
goto cpu_menu

:optimize_scheduling
echo Optimizing processor scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo Processor scheduling optimized for performance.
pause
goto cpu_menu

:disable_core_parking
echo Disabling CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo CPU core parking disabled.
pause
goto cpu_menu

:adjust_power_management
echo Adjusting processor power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
powercfg -setactive scheme_current
echo Processor power management adjusted for maximum performance.
pause
goto cpu_menu

:enable_gpu_scheduling
echo Enabling hardware-accelerated GPU scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled. Restart required.
pause
goto cpu_menu

:disable_services
echo Disabling unnecessary system services...
sc config "SysMain" start= disabled
sc stop "SysMain" >nul 2>&1
sc config "DiagTrack" start= disabled
sc stop "DiagTrack" >nul 2>&1
sc config "WSearch" start= disabled
sc stop "WSearch" >nul 2>&1
echo Unnecessary services disabled.
pause
goto cpu_menu

:adjust_visual_effects
echo Adjusting visual effects for best performance...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo Visual effects adjusted.
pause
goto cpu_menu

REM ==========================================================
REM Option 5: Optimize Internet Performance (Sub-menu)
REM ==========================================================
:option_5
call :internet_menu
goto main_menu

:internet_menu
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

if /i "%net_choice%"=="1" goto basic_optimizations
if /i "%net_choice%"=="2" goto advanced_tcp
if /i "%net_choice%"=="3" goto dns_optimization
if /i "%net_choice%"=="4" goto adapter_tuning
if /i "%net_choice%"=="5" goto clear_network_cache
if /i "%net_choice%"=="6" goto main_menu

echo Invalid choice. Please try again.
pause
goto internet_menu

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
goto internet_menu

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
goto internet_menu

:dns_optimization
echo Optimizing DNS settings...
ipconfig /flushdns
netsh int ip set dns "Local Area Connection" static 8.8.8.8
netsh int ip add dns "Local Area Connection" 8.8.4.4 index=2
echo DNS optimized.
pause
goto internet_menu

:adapter_tuning
echo Tuning network adapter...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "Connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*FlowControl' -RegistryValue 0"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*InterruptModeration' -RegistryValue 0"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
    powershell "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
)
echo Network adapter tuned.
pause
goto internet_menu

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
goto internet_menu

REM ==========================================================
REM Option 6: Windows Update Management
REM ==========================================================
:option_6
cls
echo Windows Update Management
echo 1. Enable Windows Update
echo 2. Disable Windows Update
echo 3. Check for updates
set /p update_choice=Enter your choice (1-3): 
if /i "%update_choice%"=="1" goto enable_windows_update
if /i "%update_choice%"=="2" goto disable_windows_update
if /i "%update_choice%"=="3" goto check_updates
goto main_menu

:enable_windows_update
echo Enabling Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% neq 0 (
    echo Failed to enable Windows Update.
) else (
    echo Windows Update enabled.
)
pause
goto option_6

:disable_windows_update
echo Disabling Windows Update...
sc config wuauserv start= disabled
sc stop wuauserv
if %errorlevel% neq 0 (
    echo Failed to disable Windows Update.
) else (
    echo Windows Update disabled.
)
pause
goto option_6

:check_updates
echo Checking for Windows updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated.
pause
goto option_6

REM ==========================================================
REM Option 7: Configure Auto-login
REM ==========================================================
:option_7
echo Configuring Auto-login...
set /p username=Enter username: 
set /p password=Enter password: 
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo Auto-login configured.
pause
goto main_menu

REM ==========================================================
REM Option 8: Clear system cache
REM ==========================================================
:option_8
echo Clearing system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo System cache cleared.
pause
goto main_menu

REM ==========================================================
REM Option 9: Optimize disk (Sub-menu)
REM ==========================================================
:option_9
call :disk_menu
goto main_menu

:disk_menu
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

if /i "%disk_choice%"=="1" goto analyze_disk
if /i "%disk_choice%"=="2" goto optimize_defrag
if /i "%disk_choice%"=="3" goto check_disk
if /i "%disk_choice%"=="4" goto trim_ssd
if /i "%disk_choice%"=="5" goto cleanup_system
if /i "%disk_choice%"=="6" goto main_menu

echo Invalid choice. Please try again.
pause
goto disk_menu

:analyze_disk
echo Analyzing disk...
defrag C: /A
pause
goto disk_menu

:optimize_defrag
echo Optimizing disk...
defrag C: /O
pause
goto disk_menu

:check_disk
echo Scheduling disk check...
chkdsk C: /F /R /X
echo Disk check scheduled on next restart.
pause
goto disk_menu

:trim_ssd
echo Trimming SSD...
fsutil behavior set disabledeletenotify 0
defrag C: /L
pause
goto disk_menu

:cleanup_system
echo Cleaning up system files...
cleanmgr /sagerun:1
pause
goto disk_menu

REM ==========================================================
REM Option 10: Check and repair system files (Sub-menu)
REM ==========================================================
:option_10
call :repair_menu
goto main_menu

:repair_menu
cls
echo ==================================================
echo Check and Repair System Files
echo ==================================================
echo 1. Run SFC (System File Checker)
echo 2. Run DISM
echo 3. Check disk health
echo 4. Verify system files (SFC details)
echo 5. Return to main menu
echo ==================================================
set /p repair_choice=Enter your choice (1-5): 

if /i "%repair_choice%"=="1" goto run_sfc
if /i "%repair_choice%"=="2" goto run_dism
if /i "%repair_choice%"=="3" goto check_disk_health
if /i "%repair_choice%"=="4" goto verify_files
if /i "%repair_choice%"=="5" goto main_menu

echo Invalid choice. Please try again.
pause
goto repair_menu

:run_sfc
echo Running SFC...
sfc /scannow
pause
goto repair_menu

:run_dism
echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto repair_menu

:check_disk_health
echo Checking disk health...
wmic diskdrive get status
pause
goto repair_menu

:verify_files
echo Saving SFC details to Desktop...
Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
pause
goto repair_menu

REM ==========================================================
REM Option 11: Activate Windows (Sub-menu)
REM ==========================================================
:option_11
call :activation_menu
goto main_menu

:activation_menu
cls
echo ==================================================
echo Windows Activation
echo ==================================================
echo 1. Check activation status
echo 2. Activate using KMS (Volume License)
echo 3. Activate using digital license
echo 4. Input a product key manually
echo 5. Remove product key
echo 6. Return to main menu
echo ==================================================
set /p activate_choice=Enter your choice (1-6): 

if /i "%activate_choice%"=="1" goto check_activation
if /i "%activate_choice%"=="2" goto kms_activate
if /i "%activate_choice%"=="3" goto digital_activate
if /i "%activate_choice%"=="4" goto manual_key
if /i "%activate_choice%"=="5" goto remove_key
if /i "%activate_choice%"=="6" goto main_menu

echo Invalid choice. Please try again.
pause
goto activation_menu

:check_activation
echo Checking activation status...
slmgr /xpr
pause
goto activation_menu

:kms_activate
echo Attempting KMS activation...
net session >nul 2>&1
if %errorLevel% == 0 (
    powershell -command "irm https://get.activated.win | iex"
) else (
    echo Please run script as administrator for KMS activation.
)
slmgr /ato
pause
goto activation_menu

:digital_activate
echo Attempting digital license activation...
slmgr /ato
pause
goto activation_menu

:manual_key
set /p product_key=Enter product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX): 
echo Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo Failed to install product key.
) else (
    echo Product key installed. Attempting activation...
    slmgr /ato
)
pause
goto activation_menu

:remove_key
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key.
) else (
    echo Product key removed.
)
pause
goto activation_menu

REM ==========================================================
REM Option 12: Manage Power Settings (Sub-menu)
REM ==========================================================
:option_12
call :power_menu
goto main_menu

:power_menu
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

if /i "%power_choice%"=="1" goto list_power_plans
if /i "%power_choice%"=="2" goto set_power_plan
if /i "%power_choice%"=="3" goto create_power_plan
if /i "%power_choice%"=="4" goto delete_power_plan
if /i "%power_choice%"=="5" goto adjust_sleep
if /i "%power_choice%"=="6" goto configure_hibernate
if /i "%power_choice%"=="7" goto adjust_timeouts
if /i "%power_choice%"=="8" goto lid_action
if /i "%power_choice%"=="9" goto power_button_action
if /i "%power_choice%"=="10" goto main_menu

echo Invalid choice. Please try again.
pause
goto power_menu

:list_power_plans
powercfg /list
pause
goto power_menu

:set_power_plan
powercfg /list
set /p plan_guid=Enter the GUID of the power plan: 
powercfg /setactive %plan_guid%
if %errorlevel% neq 0 (
    echo Failed to set power plan.
) else (
    echo Power plan set.
)
pause
goto power_menu

:create_power_plan
set /p plan_name=Enter a name for the new power plan: 
powercfg -duplicatescheme scheme_balanced >nul 2>&1
powercfg -changename scheme_balanced "%plan_name%"
if %errorlevel% neq 0 (
    echo Failed to create power plan.
) else (
    echo Power plan created.
)
pause
goto power_menu

:delete_power_plan
powercfg /list
set /p del_guid=Enter the GUID of the power plan to delete: 
powercfg /delete %del_guid%
if %errorlevel% neq 0 (
    echo Failed to delete power plan.
) else (
    echo Power plan deleted.
)
pause
goto power_menu

:adjust_sleep
set /p sleep_time=Enter minutes before sleep (0=never): 
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo Sleep settings adjusted.
pause
goto power_menu

:configure_hibernate
echo 1. Enable hibernation
echo 2. Disable hibernation
set /p hib_choice=Enter choice (1-2): 
if /i "%hib_choice%"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
) else if /i "%hib_choice%"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
) else (
    echo Invalid choice.
)
pause
goto power_menu

:adjust_timeouts
set /p display_ac=Minutes before turn off display (AC): 
set /p display_dc=Minutes before turn off display (DC): 
set /p sleep_ac=Minutes before sleep (AC): 
set /p sleep_dc=Minutes before sleep (DC): 
powercfg /change monitor-timeout-ac %display_ac%
powercfg /change monitor-timeout-dc %display_dc%
powercfg /change standby-timeout-ac %sleep_ac%
powercfg /change standby-timeout-dc %sleep_dc%
echo Timeouts adjusted.
pause
goto power_menu

:lid_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p lid_choice=Choice (1-4): 
if "%lid_choice%"=="1" set action=0
if "%lid_choice%"=="2" set action=1
if "%lid_choice%"=="3" set action=2
if "%lid_choice%"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons lidaction %action%
powercfg /setactive scheme_current
echo Lid action set.
pause
goto power_menu

:power_button_action
echo 1. Do nothing
echo 2. Sleep
echo 3. Hibernate
echo 4. Shut down
set /p button_choice=Choice (1-4):
if "%button_choice%"=="1" set action=0
if "%button_choice%"=="2" set action=1
if "%button_choice%"=="3" set action=2
if "%button_choice%"=="4" set action=3
powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
powercfg /setactive scheme_current
echo Power button action set.
pause
goto power_menu

REM ==========================================================
REM Option 13: Enable Dark Mode
REM ==========================================================
:option_13
echo Enabling Dark Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo Dark Mode enabled.
pause
goto main_menu

REM ==========================================================
REM Option 14: Manage partitions (Sub-menu)
REM ==========================================================
:option_14
cls
echo Partition Management
echo 1. List Partitions
echo 2. Create Partition
echo 3. Delete Partition
echo 4. Format Partition
echo 5. Return to main menu
set /p part_choice=Enter your choice (1-5): 
if /i "%part_choice%"=="1" goto list_partitions
if /i "%part_choice%"=="2" goto create_partition
if /i "%part_choice%"=="3" goto delete_partition
if /i "%part_choice%"=="4" goto format_partition
if /i "%part_choice%"=="5" goto main_menu

echo Invalid choice.
pause
goto option_14

:list_partitions
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
pause
goto option_14

:create_partition
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
goto option_14

:delete_partition
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
goto option_14

:format_partition
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
goto option_14

REM ==========================================================
REM Option 15: Clean up disk space
REM ==========================================================
:option_15
echo Cleaning up disk space...
cleanmgr /sagerun:1
pause
goto main_menu

REM ==========================================================
REM Option 16: Manage startup programs
REM ==========================================================
:option_16
echo Managing startup programs...
start msconfig
pause
goto main_menu

REM ==========================================================
REM Option 17: Backup and restore settings
REM ==========================================================
:option_17
echo Backup and Restore Settings
echo 1. Create system restore point
echo 2. Restore from a restore point
set /p backup_choice=Enter your choice (1-2): 
if /i "%backup_choice%"=="1" goto create_restore
if /i "%backup_choice%"=="2" goto restore_point
goto main_menu

:create_restore
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
pause
goto main_menu

:restore_point
echo Launching Restore UI...
rstrui.exe
pause
goto main_menu

REM ==========================================================
REM Option 18: System information
REM ==========================================================
:option_18
systeminfo
pause
goto main_menu

REM ==========================================================
REM Option 19: Optimize privacy settings
REM ==========================================================
:option_19
echo Optimizing privacy settings...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
echo Privacy settings optimized.
pause
goto main_menu

REM ==========================================================
REM Option 20: Manage Windows Services (Sub-menu)
REM ==========================================================
:option_20
call :services_menu
goto main_menu

:services_menu
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

if /i "%service_choice%"=="1" goto list_all_services
if /i "%service_choice%"=="2" goto list_running_services
if /i "%service_choice%"=="3" goto list_stopped_services
if /i "%service_choice%"=="4" goto start_service
if /i "%service_choice%"=="5" goto stop_service
if /i "%service_choice%"=="6" goto restart_service
if /i "%service_choice%"=="7" goto change_startup_type
if /i "%service_choice%"=="8" goto search_service
if /i "%service_choice%"=="9" goto view_service_details
if /i "%service_choice%"=="10" goto main_menu

echo Invalid choice.
pause
goto services_menu

:list_all_services
sc query type= service state= all
pause
goto services_menu

:list_running_services
sc query type= service state= running
pause
goto services_menu

:list_stopped_services
sc query type= service state= stopped
pause
goto services_menu

:start_service
set /p service_name=Enter the name of the service to start: 
sc start "%service_name%"
pause
goto services_menu

:stop_service
set /p service_name=Enter the name of the service to stop: 
sc stop "%service_name%"
pause
goto services_menu

:restart_service
set /p service_name=Enter the name of the service to restart: 
sc stop "%service_name%" >nul 2>&1
timeout /t 2 >nul
sc start "%service_name%"
pause
goto services_menu

:change_startup_type
set /p service_name=Enter the name of the service: 
echo 1. Automatic
echo 2. Automatic (Delayed Start)
echo 3. Manual
echo 4. Disabled
set /p startup_choice=Enter choice (1-4): 
if "%startup_choice%"=="1" sc config "%service_name%" start= auto
if "%startup_choice%"=="2" sc config "%service_name%" start= delayed-auto
if "%startup_choice%"=="3" sc config "%service_name%" start= demand
if "%startup_choice%"=="4" sc config "%service_name%" start= disabled
pause
goto services_menu

:search_service
set /p search_term=Enter search term: 
sc query state= all | findstr /i "%search_term%"
pause
goto services_menu

:view_service_details
set /p service_name=Enter service name: 
sc qc "%service_name%"
echo.
echo Current Status:
sc query "%service_name%"
pause
goto services_menu

REM ==========================================================
REM Option 21: Network optimization (Sub-menu)
REM ==========================================================
:option_21
call :network_menu
goto main_menu

:network_menu
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

if /i "%net_choice%"=="1" goto optimize_tcp
if /i "%net_choice%"=="2" goto reset_winsock
if /i "%net_choice%"=="3" goto clear_dns
if /i "%net_choice%"=="4" goto optimize_adapter
if /i "%net_choice%"=="5" goto disable_ipv6
if /i "%net_choice%"=="6" goto enable_qos
if /i "%net_choice%"=="7" goto set_static_dns
if /i "%net_choice%"=="8" goto reset_network
if /i "%net_choice%"=="9" goto main_menu

echo Invalid choice.
pause
goto network_menu

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
goto network_menu

:reset_winsock
echo Resetting Windows Sockets...
netsh winsock reset
echo Restart required.
pause
goto network_menu

:clear_dns
echo Clearing DNS cache...
ipconfig /flushdns
pause
goto network_menu

:optimize_adapter
echo Optimizing network adapter settings...
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
    netsh int tcp set security mpp=disabled
    netsh int tcp set security profiles=disabled
)
echo Adapter settings optimized.
pause
goto network_menu

:disable_ipv6
echo WARNING: Disabling IPv6 may cause network issues.
set /p confirm=Are you sure (Y/N)? 
if /i "%confirm%"=="Y" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 disabled. Restart required.
) else (
    echo Operation cancelled.
)
pause
goto network_menu

:enable_qos
echo Enabling QoS packet scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
net start Qwave
echo QoS packet scheduler enabled.
pause
goto network_menu

:set_static_dns
set /p primary_dns=Enter primary DNS (e.g., 8.8.8.8): 
set /p secondary_dns=Enter secondary DNS (e.g., 8.8.4.4): 
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh interface ip set dns "%%j" static %primary_dns% primary
    netsh interface ip add dns "%%j" %secondary_dns% index=2
)
echo Static DNS servers set.
pause
goto network_menu

:reset_network
echo Resetting all network settings...
netsh winsock reset
netsh int ip reset
netsh advfirewall reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
echo Network settings reset. Restart required.
pause
goto network_menu

REM ==========================================================
REM Option 22: Exit
REM ==========================================================
:option_22
echo Thank you for using the Windows Optimization Script!
echo Script developed by [Your Name/Organization]
echo Version 3.1
pause
exit

REM ==========================================================
REM Registry Modification Function
REM ==========================================================
:modify_registry
REM Arguments:
REM %1: Registry key path
REM %2: Value name
REM %3: Value type
REM %4: Value data

reg add %1 /v %2 /t %3 /d %4 /f >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to modify registry key: %1\%2
    pause
)
exit /b 0
