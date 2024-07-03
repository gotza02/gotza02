@echo off
setlocal enabledelayedexpansion

REM === Script Information ===
TITLE Windows Optimization Script v3.1
ECHO.
ECHO  ==================================================
ECHO  Windows Optimization Script v3.1
ECHO  ==================================================
ECHO.
ECHO  This script will optimize your Windows system
ECHO  for better performance.
ECHO.

REM === Check for administrator privileges ===
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    ECHO  Error: This script requires administrator privileges.
    ECHO  Please run as administrator and try again.
    ECHO.
    PAUSE
    exit /b 1
)

REM === Function Library ===

:CheckDefenderStatus
    ECHO  Checking Windows Defender status...
    sc query windefend | findstr /i "RUNNING" > nul
    if %errorlevel% == 0 (
        ECHO  Windows Defender is RUNNING.
    ) else (
        ECHO  Windows Defender is NOT running.
    )
    ECHO.
    pause
    goto :eof

:EnableDefender
    ECHO  Enabling Windows Defender and Real-Time Protection...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 1 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 1 /f > nul
    ECHO  Windows Defender enabled.
    ECHO.
    pause
    goto :eof

:DisableDefender
    ECHO  WARNING: Disabling Windows Defender may leave your system vulnerable.
    ECHO  Are you sure you want to continue? (Y/N)
    set /p "confirmDisable="
    if /i "!confirmDisable!" EQU "Y" (
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f > nul
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f > nul
        ECHO  Windows Defender disabled.
    ) else (
        ECHO  Operation cancelled.
    )
    ECHO.
    pause
    goto :eof

:UpdateDefender
    ECHO  Updating Windows Defender...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    if %errorlevel% equ 0 (
        ECHO  Windows Defender updated successfully.
    ) else (
        ECHO  Failed to update Windows Defender. Please check your internet connection.
    )
    ECHO.
    pause
    goto :eof

:QuickScan
    ECHO  Running quick scan...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    ECHO  Quick scan completed. 
    ECHO.
    pause
    goto :eof

:FullScan
    ECHO  Running full scan...
    ECHO  This may take a while. You can check the progress in Windows Security.
    start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    ECHO.
    pause
    goto :eof

:ManageRealtimeProtection
    ECHO  Current real-time protection status:
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
    ECHO.
    set /p "rtp_choice=Do you want to enable (E) or disable (D) real-time protection? (E/D): "
    if /i "!rtp_choice!"=="E" (
        reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f > nul
        ECHO  Real-time protection enabled.
    ) else if /i "!rtp_choice!"=="D" (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f > nul
        ECHO  Real-time protection disabled. It is recommended to keep it enabled.
    ) else (
        ECHO  Invalid choice.
    )
    ECHO.
    pause
    goto :eof

:ManageCloudProtection
    ECHO  Current cloud-delivered protection status:
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
    ECHO.
    set /p "cloud_choice=Do you want to enable (E) or disable (D) cloud-delivered protection? (E/D): "
    if /i "!cloud_choice!"=="E" (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 2 /f > nul
        ECHO  Cloud-delivered protection enabled.
    ) else if /i "!cloud_choice!"=="D" (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f > nul
        ECHO  Cloud-delivered protection disabled. It is recommended to keep it enabled for better protection.
    ) else (
        ECHO  Invalid choice.
    )
    ECHO.
    pause
    goto :eof


:ManageSampleSubmission
    ECHO  Current automatic sample submission status:
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
    ECHO.
    set /p "sample_choice=Do you want to enable (E) or disable (D) automatic sample submission? (E/D): "
    if /i "!sample_choice!"=="E" (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 1 /f > nul
        ECHO  Automatic sample submission enabled.
    ) else if /i "!sample_choice!"=="D" (
        reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 0 /f > nul
        ECHO  Automatic sample submission disabled.
    ) else (
        ECHO  Invalid choice.
    )
    ECHO.
    pause
    goto :eof

:ViewThreatHistory
    ECHO  Viewing threat history...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
    ECHO  Threat history displayed above. Check the output for details.
    ECHO.
    pause
    goto :eof

REM === Main Menu ===
:menu
cls
ECHO  ==================================================
ECHO  Windows Optimization Script v3.1
ECHO  ==================================================
ECHO.
ECHO  Please select an option:
ECHO.
ECHO  1. Optimize display performance
ECHO  2. Manage Windows Defender
ECHO  3. Optimize system features
ECHO  4. Optimize CPU performance
ECHO  5. Optimize Internet performance
ECHO  6. Manage Windows Update
ECHO  7. Configure Auto-login 
ECHO  8. Clear system cache
ECHO  9. Optimize disk
ECHO  10. Check and repair system files
ECHO  11. Activate Windows
ECHO  12. Manage power settings
ECHO  13. Enable Dark Mode
ECHO  14. Manage partitions
ECHO  15. Clean up disk space
ECHO  16. Manage startup programs
ECHO  17. Backup and restore settings
ECHO  18. System information
ECHO  19. Optimize privacy settings 
ECHO  20. Manage Windows services
ECHO  21. Network optimization
ECHO  22. Exit
ECHO.
ECHO  ==================================================
set /p "choice=Enter your choice (1-22): "
ECHO.

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
ECHO  Invalid choice. Please try again.
ECHO.
pause
goto menu

:optimize_display
    ECHO Optimizing display performance...
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012078010000000 /f > nul
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f > nul
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f > nul
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f > nul
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f > nul
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f > nul
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f > nul
    ECHO Display performance optimized.
    ECHO.
    pause
    goto menu

:manage_defender
    cls
    ECHO  ===================================================
    ECHO              Windows Defender Management
    ECHO  ===================================================
    ECHO.
    ECHO  1. Check Windows Defender status
    ECHO  2. Enable Windows Defender
    ECHO  3. Disable Windows Defender (Not recommended)
    ECHO  4. Update Windows Defender
    ECHO  5. Run quick scan
    ECHO  6. Run full scan
    ECHO  7. Manage real-time protection
    ECHO  8. Manage cloud-delivered protection
    ECHO  9. Manage automatic sample submission
    ECHO  10. View threat history
    ECHO  11. Return to main menu
    ECHO.
    ECHO  ===================================================
    set /p "def_choice=Enter your choice (1-11): "
    ECHO.

    if "%def_choice%"=="1" call :CheckDefenderStatus
    if "%def_choice%"=="2" call :EnableDefender
    if "%def_choice%"=="3" call :DisableDefender 
    if "%def_choice%"=="4" call :UpdateDefender
    if "%def_choice%"=="5" call :QuickScan
    if "%def_choice%"=="6" call :FullScan
    if "%def_choice%"=="7" call :ManageRealtimeProtection
    if "%def_choice%"=="8" call :ManageCloudProtection
    if "%def_choice%"=="9" call :ManageSampleSubmission
    if "%def_choice%"=="10" call :ViewThreatHistory
    if "%def_choice%"=="11" goto menu

    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto manage_defender 

:optimize_features 
    ECHO  Optimizing system features...

    :: Disable Activity Feed
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f > nul
    ECHO  Activity Feed disabled.

    :: Disable background apps
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f > nul
    ECHO  Background apps disabled.

    :: Disable Cortana 
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f > nul
    ECHO  Cortana disabled.

    :: Disable Game DVR and Game Bar
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f > nul
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f > nul
    ECHO  Game DVR and Game Bar disabled.

    :: Disable Sticky Keys prompt
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f > nul
    ECHO  Sticky Keys prompt disabled.

    :: Disable Windows Tips 
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f > nul
    ECHO  Windows Tips disabled.

    :: Disable Start Menu suggestions 
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f > nul
    ECHO  Start Menu suggestions disabled.

    :: Enable Fast Startup (if applicable)
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f > nul
    ECHO  Fast Startup enabled.

    ECHO  System features optimized.
    ECHO.
    pause
    goto menu 
    :optimize_cpu
    cls
    ECHO  ==================================================
    ECHO  CPU Optimization
    ECHO  ==================================================
    ECHO.
    ECHO  1. Set High Performance power plan
    ECHO  2. Disable CPU throttling (May shorten battery life)
    ECHO  3. Optimize processor scheduling 
    ECHO  4. Disable CPU core parking (May increase power consumption)
    ECHO  5. Adjust processor power management
    ECHO  6. Enable hardware-accelerated GPU scheduling (requires restart)
    ECHO  7. Disable unnecessary system services (advanced users)
    ECHO  8. Adjust visual effects for performance
    ECHO  9. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "cpu_choice=Enter your choice (1-9): "
    ECHO.

    if "%cpu_choice%"=="1" goto :set_high_performance
    if "%cpu_choice%"=="2" goto :disable_throttling
    if "%cpu_choice%"=="3" goto :optimize_scheduling
    if "%cpu_choice%"=="4" goto :disable_core_parking
    if "%cpu_choice%"=="5" goto :adjust_power_management
    if "%cpu_choice%"=="6" goto :enable_gpu_scheduling
    if "%cpu_choice%"=="7" goto :disable_services
    if "%cpu_choice%"=="8" goto :adjust_visual_effects
    if "%cpu_choice%"=="9" goto menu
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto optimize_cpu

:set_high_performance
    ECHO Setting High Performance power plan...
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul
    if %errorlevel% neq 0 (
        ECHO  Failed to set High Performance power plan. Creating a new one...
        powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul
        for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set "hp_guid=%%i"
        powercfg -setactive %hp_guid% > nul
    )
    ECHO  High Performance power plan set.
    ECHO.
    pause
    goto :optimize_cpu

:disable_throttling
    ECHO  Disabling CPU throttling...
    powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 > nul
    powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 > nul
    powercfg -setactive scheme_current > nul
    ECHO  CPU throttling disabled.
    ECHO.
    pause
    goto :optimize_cpu

:optimize_scheduling
    ECHO  Optimizing processor scheduling...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f > nul
    ECHO  Processor scheduling optimized for best performance of programs.
    ECHO.
    pause
    goto :optimize_cpu

:disable_core_parking
    ECHO  Disabling CPU core parking...
    powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 > nul
    powercfg -setactive scheme_current > nul
    ECHO  CPU core parking disabled.
    ECHO.
    pause
    goto :optimize_cpu

:adjust_power_management
    ECHO  Adjusting processor power management...
    powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 > nul
    powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 > nul
    powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2 > nul
    powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1 > nul
    powercfg -setactive scheme_current > nul
    ECHO  Processor power management adjusted for maximum performance.
    ECHO.
    pause
    goto :optimize_cpu

:enable_gpu_scheduling
    ECHO  Enabling hardware-accelerated GPU scheduling...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f > nul
    ECHO  Hardware-accelerated GPU scheduling enabled. Please restart your computer for changes to take effect.
    ECHO.
    pause
    goto :optimize_cpu

:disable_services
    ECHO  WARNING: Disabling system services can cause instability. 
    ECHO  Proceed with caution! 
    ECHO.
    ECHO  Commonly disabled services for performance: (Not recommended to disable all)
    ECHO    - SysMain (Superfetch)
    ECHO    - DiagTrack (Connected User Experiences and Telemetry)
    ECHO    - WSearch (Windows Search)
    ECHO    - Print Spooler (if you don't use a printer)
    ECHO. 
    set /p "disableServiceConfirm=Enter the service name you want to disable (or press Enter to skip): "
    if not "!disableServiceConfirm!"=="" (
        sc config "!disableServiceConfirm!" start= disabled > nul
        sc stop "!disableServiceConfirm!" > nul
        ECHO  Service "!disableServiceConfirm!" disabled. 
    ) 
    ECHO.
    pause
    goto :optimize_cpu

:adjust_visual_effects
    ECHO  Adjusting visual effects for best performance...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f > nul
    ECHO  Visual effects adjusted for best performance.
    ECHO.
    pause
    goto :optimize_cpu

:optimize_internet
    cls
    ECHO  ==================================================
    ECHO  Internet Performance Optimization
    ECHO  ==================================================
    ECHO.
    ECHO  1. Basic optimizations
    ECHO  2. Advanced TCP optimizations
    ECHO  3. DNS optimization
    ECHO  4. Network adapter tuning
    ECHO  5. Clear network cache
    ECHO  6. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "net_choice=Enter your choice (1-6): "
    ECHO.

    if "%net_choice%"=="1" goto :basic_optimizations
    if "%net_choice%"=="2" goto :advanced_tcp
    if "%net_choice%"=="3" goto :dns_optimization
    if "%net_choice%"=="4" goto :adapter_tuning
    if "%net_choice%"=="5" goto :clear_network_cache
    if "%net_choice%"=="6" goto menu
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto optimize_internet

:basic_optimizations
    ECHO Performing basic Internet optimizations...
    netsh int tcp set global autotuninglevel=normal > nul
    netsh int tcp set global chimney=enabled > nul
    netsh int tcp set global dca=enabled > nul
    netsh int tcp set global netdma=enabled > nul
    netsh int tcp set global ecncapability=enabled > nul
    netsh int tcp set global timestamps=disabled > nul 
    netsh int tcp set global rss=enabled > nul
    ECHO Basic optimizations completed.
    ECHO.
    pause
    goto :optimize_internet

:advanced_tcp
    ECHO Performing advanced TCP optimizations...
    netsh int tcp set global congestionprovider=ctcp > nul
    netsh int tcp set global ecncapability=enabled > nul
    netsh int tcp set heuristics disabled > nul
    netsh int tcp set global rss=enabled > nul
    netsh int tcp set global fastopen=enabled > nul
    netsh int tcp set global hystart=disabled > nul 
    netsh int tcp set global pacingprofile=off > nul 
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPNoDelay" /t REG_DWORD /d 1 /f > nul
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TCPDelAckTicks" /t REG_DWORD /d 0 /f > nul
    ECHO Advanced TCP optimizations completed.
    ECHO.
    pause
    goto :optimize_internet
    :dns_optimization
    ECHO Optimizing DNS settings...
    ipconfig /flushdns > nul
    ECHO  - Flushed DNS cache.

    ECHO  Do you want to set Google Public DNS (8.8.8.8, 8.8.4.4)? (Y/N)
    set /p "dnsChoice=" 
    if /i "!dnsChoice!"=="Y" (
        for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
            netsh interface ip set dns "%%j" static 8.8.8.8 primary > nul
            netsh interface ip add dns "%%j" 8.8.4.4 index=2 > nul
        )
        ECHO  - Set Google Public DNS as primary and secondary DNS servers. 
    ) 

    ECHO DNS optimized.
    ECHO.
    pause
    goto :optimize_internet

:adapter_tuning
    ECHO Tuning network adapter... 
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        netsh int ip set interface "%%j" dadtransmits=0 store=persistent > nul
        netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent > nul

        REM Using PowerShell to adjust advanced adapter settings
        powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*FlowControl' -RegistryValue 0" > nul
        powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*InterruptModeration' -RegistryValue 0" > nul
        powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3" > nul 
        powershell -Command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0" > nul 
    )
    ECHO Network adapter tuned for optimal performance.
    ECHO.
    pause
    goto :optimize_internet

:clear_network_cache
    ECHO Clearing network cache...
    ipconfig /flushdns > nul
    arp -d * > nul
    nbtstat -R > nul
    nbtstat -RR > nul
    netsh int ip reset resetlog.txt > nul
    netsh winsock reset catalog > nul
    ECHO  - Network cache cleared. 
    ECHO  - You may need to restart your computer for all changes to take effect.
    ECHO.
    pause
    goto :optimize_internet

:windows_update
    ECHO  ==================================================
    ECHO  Windows Update Management
    ECHO  ==================================================
    ECHO.
    ECHO  1. Enable Windows Update
    ECHO  2. Disable Windows Update (Not recommended)
    ECHO  3. Check for updates 
    ECHO  4. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "update_choice=Enter your choice (1-4): "
    ECHO.
    if "%update_choice%"=="1" goto :enable_windows_update
    if "%update_choice%"=="2" goto :disable_windows_update
    if "%update_choice%"=="3" goto :check_updates
    if "%update_choice%"=="4" goto :menu 
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto windows_update

:enable_windows_update
    ECHO  Enabling Windows Update...
    sc config wuauserv start= auto > nul
    sc start wuauserv > nul
    if %errorlevel% neq 0 (
        ECHO  Failed to enable Windows Update. Please check your permissions.
    ) else (
        ECHO  Windows Update enabled.
    )
    ECHO.
    pause
    goto :windows_update

:disable_windows_update
    ECHO  Disabling Windows Update (Not Recommended)...
    ECHO  Are you sure you want to continue? (Y/N) 
    set /p "confirmDisableWU=" 
    if /i "!confirmDisableWU!" EQU "Y" (
        sc config wuauserv start= disabled > nul
        sc stop wuauserv > nul
        if %errorlevel% neq 0 (
            ECHO  Failed to disable Windows Update. Please check your permissions.
        ) else (
            ECHO  Windows Update disabled.
        ) 
    ) ELSE (
        ECHO  Operation cancelled. 
    )
    ECHO.
    pause
    goto :windows_update

:check_updates
    ECHO  Checking for Windows updates...
    powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()" > nul
    ECHO  Update check initiated. Please check Windows Update in Settings for results.
    ECHO.
    pause
    goto :windows_update 

:auto_login 
    ECHO  WARNING: Enabling auto-login is a security risk! 
    ECHO  Make sure you are using this on a trusted computer.
    ECHO.
    set /p "autoLoginConfirm=Do you want to enable auto-login? (Y/N): "
    if /i "!autoLoginConfirm!" NEQ "Y" (
        ECHO  Auto-login configuration cancelled.
        ECHO.
        pause
        goto :menu
    )

    set /p "username=Enter username: "
    set /p "password=Enter password: "

    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "%username%" /f > nul
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "%password%" /f > nul
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f > nul

    ECHO  Auto-login configured.
    ECHO.
    pause
    goto :menu

:clear_cache
    ECHO  Clearing system cache...
    del /q /f /s "%TEMP%\*" 2>nul
    del /q /f /s "C:\Windows\Temp\*" 2>nul 
    ECHO  System cache cleared.
    ECHO.
    pause
    goto :menu

:optimize_disk
    cls
    ECHO  ==================================================
    ECHO  Disk Optimization
    ECHO  ==================================================
    ECHO.
    ECHO  1. Analyze disk
    ECHO  2. Optimize/Defragment disk
    ECHO  3. Check disk for errors
    ECHO  4. Trim SSD (if applicable)
    ECHO  5. Clean up system files
    ECHO  6. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "disk_choice=Enter your choice (1-6): "
    ECHO.

    if "%disk_choice%"=="1" goto :analyze_disk
    if "%disk_choice%"=="2" goto :optimize_defrag
    if "%disk_choice%"=="3" goto :check_disk
    if "%disk_choice%"=="4" goto :trim_ssd
    if "%disk_choice%"=="5" goto :cleanup_system
    if "%disk_choice%"=="6" goto :menu 
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto :optimize_disk

:analyze_disk
    ECHO  Analyzing disk...
    defrag C: /A 
    ECHO  Disk analysis completed.
    ECHO.
    pause
    goto :optimize_disk
    :list_partitions
    ECHO  Listing Partitions...
    ECHO  list disk > list_disk.txt
    ECHO  list volume >> list_disk.txt
    diskpart /s list_disk.txt > nul
    type list_disk.txt
    del list_disk.txt > nul
    ECHO.
    pause
    goto :manage_partitions

:create_partition
    ECHO  Creating Partition...
    set /p "disk_num=Enter disk number (refer to the list): "
    set /p "part_size=Enter partition size in MB: "
    (
    ECHO  select disk %disk_num%
    ECHO  create partition primary size=%part_size%
    ) > create_part.txt
    diskpart /s create_part.txt > nul
    del create_part.txt > nul
    ECHO  Partition created.
    ECHO.
    pause
    goto :manage_partitions

:delete_partition
    ECHO  WARNING: Deleting a partition will erase all data on it!
    ECHO.
    set /p "confirmDelete=Are you sure you want to delete a partition? (Y/N): "
    if /i "!confirmDelete!" NEQ "Y" (
        ECHO  Partition deletion cancelled.
        ECHO.
        pause
        goto :manage_partitions
    )
    set /p "disk_num=Enter disk number: "
    set /p "part_num=Enter partition number: "
    (
    ECHO  select disk %disk_num%
    ECHO  select partition %part_num%
    ECHO  delete partition override 
    ) > delete_part.txt
    diskpart /s delete_part.txt > nul 
    del delete_part.txt > nul
    ECHO  Partition deleted.
    ECHO.
    pause
    goto :manage_partitions

:format_partition
    ECHO  WARNING: Formatting a partition will erase all data on it!
    ECHO.
    set /p "confirmFormat=Are you sure you want to format a partition? (Y/N): "
    if /i "!confirmFormat!" NEQ "Y" (
        ECHO  Partition format cancelled.
        ECHO.
        pause
        goto :manage_partitions
    )
    set /p "disk_num=Enter disk number: "
    set /p "part_num=Enter partition number: "
    set /p "fs=Enter file system (NTFS / FAT32): "
    (
    ECHO  select disk %disk_num%
    ECHO  select partition %part_num%
    ECHO  format fs=%fs% quick
    ) > format_part.txt
    diskpart /s format_part.txt > nul
    del format_part.txt > nul
    ECHO  Partition formatted.
    ECHO.
    pause
    goto :manage_partitions 

:clean_disk
    ECHO  Cleaning up disk space...
    cleanmgr /sagerun:1 > nul
    ECHO  Disk cleanup completed. You may see a popup window for Disk Cleanup. 
    ECHO.
    pause
    goto :menu

:manage_startup
    ECHO  Managing startup programs...
    ECHO.
    ECHO  You can manage startup programs through the Task Manager.
    ECHO  To open the Task Manager, press Ctrl+Shift+Esc.
    ECHO.
    pause
    goto :menu

:backup_restore
    ECHO  ==================================================
    ECHO  Backup and Restore Settings
    ECHO  ==================================================
    ECHO.
    ECHO  1. Create system restore point
    ECHO  2. Restore from a restore point
    ECHO  3. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "backup_choice=Enter your choice (1-3): "
    ECHO.

    if "%backup_choice%"=="1" goto :create_restore
    if "%backup_choice%"=="2" goto :restore_point
    if "%backup_choice%"=="3" goto :menu
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto :backup_restore

:create_restore
    ECHO  Creating a system restore point...
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7 > nul
    if %errorlevel% == 0 (
        ECHO  System restore point created successfully.
    ) else (
        ECHO  Failed to create a restore point. Check your permissions. 
    ) 
    ECHO.
    pause
    goto :backup_restore

:restore_point
    ECHO  Restoring from a restore point...
    rstrui.exe
    ECHO. 
    pause 
    goto :backup_restore

:system_info
    ECHO  Displaying system information...
    systeminfo
    ECHO. 
    pause
    goto :menu

:optimize_privacy
    ECHO  Optimizing privacy settings...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f > nul
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > nul
    ECHO  Privacy settings optimized. Consider reviewing Windows privacy settings.
    ECHO.
    pause
    goto :menu


:manage_services 
    cls 
    ECHO  ==================================================
    ECHO  Windows Services Management (Advanced Users) 
    ECHO  ==================================================
    ECHO.
    ECHO  WARNING: Modifying services can make your system unstable!
    ECHO.
    ECHO  1. List all services
    ECHO  2. List running services
    ECHO  3. List stopped services
    ECHO  4. Start a service 
    ECHO  5. Stop a service
    ECHO  6. Restart a service
    ECHO  7. Change service startup type
    ECHO  8. Search for a service
    ECHO  9. View service details
    ECHO  10. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p service_choice=Enter your choice (or press Enter to go back): 
    if "%service_choice%"=="" goto :menu 
    ECHO.

    if "%service_choice%"=="1" goto :list_all_services
    if "%service_choice%"=="2" goto :list_running_services
    if "%service_choice%"=="3" goto :list_stopped_services
    if "%service_choice%"=="4" goto :start_service
    if "%service_choice%"=="5" goto :stop_service
    if "%service_choice%"=="6" goto :restart_service
    if "%service_choice%"=="7" goto :change_startup_type
    if "%service_choice%"=="8" goto :search_service
    if "%service_choice%"=="9" goto :view_service_details
    if "%service_choice%"=="10" goto :menu 
    ECHO Invalid choice. Please try again.
    ECHO.
    pause
    goto :manage_services

:list_all_services
    ECHO  Listing all services...
    sc query state= all | more
    ECHO.
    pause
    goto :manage_services

:list_running_services
    ECHO  Listing running services...
    sc query state= running | more
    ECHO.
    pause
    goto :manage_services

:list_stopped_services
    ECHO  Listing stopped services...
    sc query state= stopped | more
    ECHO.
    pause
    goto :manage_services

:start_service
    set /p "serviceName=Enter the name of the service to start: "
    sc start "%serviceName%" > nul
    if %errorlevel% neq 0 (
        ECHO  Failed to start the service. Check the name and permissions.
    ) else (
        ECHO  Service start attempted. Check the status.
    )
    ECHO.
    pause
    goto :manage_services

:stop_service
    set /p "serviceName=Enter the name of the service to stop: "
    sc stop "%serviceName%" > nul
    if %errorlevel% neq 0 (
        ECHO  Failed to stop the service. Check the name and permissions.
    ) else (
        ECHO  Service stop attempted. Check the status.
    )
    ECHO.
    pause
    goto :manage_services

:restart_service
    set /p "serviceName=Enter the name of the service to restart: "
    sc stop "%serviceName%" > nul
    timeout /t 2 >nul
    sc start "%serviceName%" > nul
    if %errorlevel% neq 0 (
        ECHO  Failed to restart the service. Check the name and permissions.
    ) else (
        ECHO  Service restart attempted. Check the status.
    )
    ECHO.
    pause
    goto :manage_services

:change_startup_type
    set /p "serviceName=Enter the name of the service: "
    ECHO.
    ECHO  Select startup type:
    ECHO  1. Automatic
    ECHO  2. Automatic (Delayed Start)
    ECHO  3. Manual
    ECHO  4. Disabled
    ECHO.
    set /p "startup_choice=Enter your choice (1-4): "
    ECHO.

    if "%startup_choice%"=="1" (
        sc config "%serviceName%" start= auto > nul
    ) else if "%startup_choice%"=="2" (
        sc config "%serviceName%" start= delayed-auto > nul
    ) else if "%startup_choice%"=="3" (
        sc config "%serviceName%" start= demand > nul
    ) else if "%startup_choice%"=="4" (
        sc config "%serviceName%" start= disabled > nul
    ) else (
        ECHO  Invalid choice.
        ECHO.
        pause
        goto :manage_services
    )

    if %errorlevel% neq 0 (
        ECHO  Failed to change the startup type. Check the name and permissions.
    ) else (
        ECHO  Startup type changed successfully.
    )
    ECHO.
    pause
    goto :manage_services

:search_service
    set /p "searchTerm=Enter search term for service name: "
    ECHO.
    sc query state= all | findstr /i "%searchTerm%" | more
    ECHO.
    pause
    goto :manage_services

:view_service_details
    set /p "serviceName=Enter the name of the service to view details: "
    ECHO.
    sc qc "%serviceName%"
    ECHO.
    ECHO  Current Status:
    sc query "%serviceName%"
    ECHO.
    pause
    goto :manage_services

:network_optimization
    cls 
    ECHO  ==================================================
    ECHO  Network Optimization
    ECHO  ==================================================
    ECHO.
    ECHO  1. Optimize TCP settings
    ECHO  2. Reset Windows Sockets (requires restart)
    ECHO  3. Clear DNS cache
    ECHO  4. Optimize network adapter settings
    ECHO  5. Disable IPv6 (may cause issues, requires restart)
    ECHO  6. Enable QoS packet scheduler
    ECHO  7. Set static DNS servers
    ECHO  8. Reset all network settings (requires restart)
    ECHO  9. Return to main menu
    ECHO.
    ECHO  ==================================================
    set /p "net_choice=Enter your choice (1-9): "
    ECHO.

    if "%net_choice%"=="1" goto :optimize_tcp
    if "%net_choice%"=="2" goto :reset_winsock
    if "%net_choice%"=="3" goto :clear_dns
    if "%net_choice%"=="4" goto :optimize_adapter
    if "%net_choice%"=="5" goto :disable_ipv6
    if "%net_choice%"=="6" goto :enable_qos
    if "%net_choice%"=="7" goto :set_static_dns
    if "%net_choice%"=="8" goto :reset_network
    if "%net_choice%"=="9" goto :menu
    ECHO  Invalid choice. Please try again.
    ECHO.
    pause
    goto :network_optimization

:optimize_tcp
    ECHO  Optimizing TCP settings...
    netsh int tcp set global autotuninglevel=normal > nul
    netsh int tcp set global congestionprovider=ctcp > nul
    netsh int tcp set global ecncapability=enabled > nul
    netsh int tcp set heuristics disabled > nul
    netsh int tcp set global rss=enabled > nul
    netsh int tcp set global fastopen=enabled > nul
    netsh int tcp set global timestamps=disabled > nul
    netsh int tcp set global initialRto=2000 > nul
    netsh int tcp set global nonsackrttresiliency=disabled > nul
    ECHO  TCP settings optimized.
    ECHO.
    pause
    goto :network_optimization

:reset_winsock
    ECHO  Resetting Windows Sockets...
    netsh winsock reset > nul
    ECHO  Windows Sockets reset. Please restart your computer.
    ECHO.
    pause
    goto :network_optimization

:clear_dns 
    ECHO  Clearing DNS cache...
    ipconfig /flushdns > nul
    ECHO  DNS cache cleared.
    ECHO.
    pause
    goto :network_optimization

:optimize_adapter
    ECHO  Optimizing network adapter settings...
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
        netsh int ip set interface "%%j" dadtransmits=0 store=persistent > nul
        netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent > nul
        netsh int tcp set security mpp=disabled > nul
        netsh int tcp set security profiles=disabled > nul 
    )
    ECHO  Network adapter settings optimized.
    ECHO.
    pause
    goto :network_optimization

:disable_ipv6
    ECHO  WARNING: Disabling IPv6 may cause network issues!
    set /p "confirmDisableIPv6=Are you sure you want to disable IPv6? (Y/N): "
    if /i "!confirmDisableIPv6!"=="Y" ( 
        netsh interface ipv6 set global randomizeidentifiers=disabled > nul
        netsh interface ipv6 set privacy state=disabled > nul
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f > nul
        ECHO  IPv6 disabled. Please restart your computer.
    ) else (
        ECHO  Operation cancelled.
    )
    ECHO.
    pause
    goto :network_optimization

:enable_qos
    ECHO  Enabling QoS packet scheduler...
    netsh int tcp set global packetcoalescinginbound=disabled > nul
    sc config "Qwave" start= auto > nul
    net start Qwave > nul
    ECHO  QoS packet scheduler enabled.
    ECHO.
    pause
    goto :network_optimization

:set_static_dns
    ECHO  Setting static DNS servers...
    set /p "primary_dns=Enter primary DNS server (e.g., 8.8.8.8): "
    set /p "secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4): "
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
        netsh interface ip set dns "%%j" static %primary_dns% primary > nul
        netsh interface ip add dns "%%j" %secondary_dns% index=2 > nul
    )
    ECHO  Static DNS servers set.
    ECHO.
    pause
    goto :network_optimization

:reset_network
    ECHO  Resetting all network settings...
    netsh winsock reset > nul
    netsh int ip reset > nul
    netsh advfirewall reset > nul
    ipconfig /release > nul
    ipconfig /renew > nul
    ipconfig /flushdns > nul
    ECHO  All network settings reset. Please restart your computer.
    ECHO.
    pause
    goto :network_optimization

:endexit
ECHO  Thank you for using the Windows Optimization Script!
ECHO  Script developed by [Your Name/Organization]
ECHO  Version 3.1 
ECHO.
pause 
exit 
