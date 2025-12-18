@echo off
setlocal enabledelayedexpansion
title Windows God Mode Optimizer v7.0 (Complete Edition)
color 0b

:: ==================================================
:: 0. AUTO-ELEVATE (ADMIN CHECK)
:: ==================================================
:check_admin
fltmc >nul 2>&1 || (
    echo.
    echo [Requesting Administrator Privileges...]
    echo Please click "Yes" in the UAC window.
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:: ==================================================
:: MAIN MENU
:: ==================================================
:menu
cls
echo ==========================================================================
echo   WINDOWS GOD MODE OPTIMIZER v7.0 (The Complete Collection)
echo ==========================================================================
echo   [ PERFORMANCE CENTER ]
echo    1. CPU & Power Plan Manager (Detailed)
echo    2. Gaming Mode & GPU Acceleration
echo    3. RAM & System Refresh
echo    4. Startup Programs Manager
echo    5. Windows Services Manager (Deep Control)
echo.
echo   [ DISK & MAINTENANCE ]
echo    6. Advanced Disk Cleanup (Deep Clean)
echo    7. Disk Drive Optimization (Defrag/Trim/Check)
echo    8. Partition Manager (Create/Delete/Format)
echo    9. System Repair (SFC/DISM)
echo   10. Windows Update & Software Manager (Winget)
echo.
echo   [ NETWORK & INTERNET ]
echo   11. Network Optimization (TCP/DNS/Reset/IPv6/QoS)
echo.
echo   [ SECURITY & PRIVACY ]
echo   12. Windows Defender Security Center
echo   13. Privacy & Telemetry Blocker
echo   14. Windows Activation Hub (GitHub MAS)
echo   15. Backup & Restore (System Restore Point)
echo.
echo   [ PERSONALIZATION & UTILITIES ]
echo   16. Auto-Login Configuration
echo   17. Theme & Visual Effects
echo   18. System Information
echo.
echo   [ ONE-CLICK ]
echo   99. RUN AUTO-PILOT (Safe Optimization)
echo    0. Exit
echo ==========================================================================
set /p choice=Enter your choice [0-99]: 

if "%choice%"=="1" goto manage_power_cpu
if "%choice%"=="2" goto gaming_mode
if "%choice%"=="3" goto refresh_system
if "%choice%"=="4" goto manage_startup
if "%choice%"=="5" goto manage_services
if "%choice%"=="6" goto deep_cleanup
if "%choice%"=="7" goto optimize_disk
if "%choice%"=="8" goto manage_partitions
if "%choice%"=="9" goto system_repair
if "%choice%"=="10" goto windows_update_menu
if "%choice%"=="11" goto optimize_network
if "%choice%"=="12" goto defender_menu
if "%choice%"=="13" goto privacy_tweaks
if "%choice%"=="14" goto activation_menu
if "%choice%"=="15" goto backup_restore
if "%choice%"=="16" goto auto_login_menu
if "%choice%"=="17" goto visual_theme
if "%choice%"=="18" goto system_info
if "%choice%"=="19" goto system_info
if "%choice%"=="99" goto auto_pilot
if "%choice%"=="0" exit

echo Invalid choice.
pause
goto menu

:: ==================================================
:: 1. CPU & POWER MANAGER (COMPLETE)
:: ==================================================
:manage_power_cpu
cls
echo [Power & CPU Manager]
echo 1. Set "Ultimate Performance" Plan
echo 2. Set "High Performance" Plan
echo 3. Disable CPU Throttling & Parking
echo 4. Optimize Processor Scheduling (Programs)
echo 5. Configure Sleep Timeouts
echo 6. Configure Hibernate (On/Off)
echo 7. Configure Lid Close Action
echo 8. Configure Power Button Action
echo 9. Back
set /p p_choice=Choice: 

if "%p_choice%"=="1" (
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    echo Ultimate Plan Active. & pause & goto manage_power_cpu
)
if "%p_choice%"=="2" (
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo High Perf Active. & pause & goto manage_power_cpu
)
if "%p_choice%"=="3" (
    powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
    powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
    powercfg -setactive scheme_current
    echo Throttling Disabled. & pause & goto manage_power_cpu
)
if "%p_choice%"=="4" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
    echo Priority Optimized. & pause & goto manage_power_cpu
)
if "%p_choice%"=="5" (
    set /p t=Enter minutes (0=Never): 
    powercfg /change standby-timeout-ac !t!
    powercfg /change standby-timeout-dc !t!
    echo Sleep timeout set. & pause & goto manage_power_cpu
)
if "%p_choice%"=="6" (
    set /p h=Enable Hibernate? (Y/N): 
    if /i "!h!"=="Y" powercfg /hibernate on
    if /i "!h!"=="N" powercfg /hibernate off
    goto manage_power_cpu
)
if "%p_choice%"=="7" (
    echo 0=Nothing, 1=Sleep, 2=Hibernate, 3=Shutdown
    set /p l=Lid Action (0-3): 
    powercfg /setacvalueindex scheme_current sub_buttons lidaction !l!
    powercfg /setactive scheme_current
    goto manage_power_cpu
)
if "%p_choice%"=="8" (
    echo 0=Nothing, 1=Sleep, 2=Hibernate, 3=Shutdown
    set /p b=Button Action (0-3): 
    powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction !b!
    powercfg /setactive scheme_current
    goto manage_power_cpu
)
if "%p_choice%"=="9" goto menu
goto manage_power_cpu

:: ==================================================
:: 2. GAMING MODE
:: ==================================================
:gaming_mode
cls
echo [Gaming Optimization]
echo 1. Force Enable Windows Game Mode
echo 2. Set GPU Priority to High
echo 3. Disable Sticky Keys
echo 4. Back
set /p g_choice=Choice: 
if "%g_choice%"=="1" (
    reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f
    echo Game Mode Forced On. & pause & goto gaming_mode
)
if "%g_choice%"=="2" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f
    echo GPU Priority Maxed. & pause & goto gaming_mode
)
if "%g_choice%"=="3" (
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f
    echo Sticky Keys Off. & pause & goto gaming_mode
)
if "%g_choice%"=="4" goto menu
goto gaming_mode

:: ==================================================
:: 3. REFRESH SYSTEM
:: ==================================================
:refresh_system
echo.
echo Cleaning Temp...
del /q /f /s %TEMP%\* >nul 2>&1
del /q /f /s C:\Windows\Temp\* >nul 2>&1
echo Restarting Explorer...
taskkill /f /im explorer.exe >nul
start explorer.exe
echo Flushing DNS...
ipconfig /flushdns
echo [OK] Done.
pause
goto menu

:: ==================================================
:: 4. STARTUP
:: ==================================================
:manage_startup
echo Opening Task Manager Startup tab...
taskmgr /0 /startup
pause
goto menu

:: ==================================================
:: 5. SERVICES MANAGER (COMPLETE)
:: ==================================================
:manage_services
cls
echo [Services Manager]
echo 1. List Running Services
echo 2. Start Service
echo 3. Stop Service
echo 4. Restart Service
echo 5. Change Startup Type (Auto/Manual/Disabled)
echo 6. Search Service
echo 7. Back
set /p s_choice=Choice: 

if "%s_choice%"=="1" sc query type= service state= running | more & pause & goto manage_services
if "%s_choice%"=="2" set /p s=Name: & sc start "!s!" & pause & goto manage_services
if "%s_choice%"=="3" set /p s=Name: & sc stop "!s!" & pause & goto manage_services
if "%s_choice%"=="4" set /p s=Name: & sc stop "!s!" & timeout /t 2 >nul & sc start "!s!" & pause & goto manage_services
if "%s_choice%"=="5" (
    set /p s=Name: 
    echo Types: auto, demand (manual), disabled, delayed-auto
    set /p t=Type: 
    sc config "!s!" start= !t!
    pause & goto manage_services
)
if "%s_choice%"=="6" set /p s=Search: & sc query state= all | findstr /i "!s!" & pause & goto manage_services
if "%s_choice%"=="7" goto menu
goto manage_services

:: ==================================================
:: 6. DEEP CLEANUP
:: ==================================================
:deep_cleanup
cls
echo [Advanced Disk Cleanup]
echo 1. Run Standard Cleanup (Auto-Select All)
echo 2. Clear Windows Update Cache (Fix Updates)
echo 3. Back
set /p c_choice=Choice: 
if "%c_choice%"=="1" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 2 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0001 /t REG_DWORD /d 2 /f
    cleanmgr /sagerun:0001
    pause & goto deep_cleanup
)
if "%c_choice%"=="2" (
    net stop wuauserv
    net stop bits
    rmdir /s /q C:\Windows\SoftwareDistribution\Download
    mkdir C:\Windows\SoftwareDistribution\Download
    net start wuauserv
    net start bits
    echo Cache Cleared. & pause & goto deep_cleanup
)
if "%c_choice%"=="3" goto menu
goto deep_cleanup

:: ==================================================
:: 7. DRIVE OPTIMIZATION
:: ==================================================
:optimize_disk
cls
echo [Drive Optimization]
echo 1. Analyze Disk
echo 2. Optimize/Defrag/Trim (Recommended)
echo 3. Check Disk (Chkdsk - Requires Restart)
echo 4. Back
set /p d_choice=Choice: 
if "%d_choice%"=="1" defrag C: /A & pause & goto optimize_disk
if "%d_choice%"=="2" defrag C: /O /V & pause & goto optimize_disk
if "%d_choice%"=="3" echo Y | chkdsk C: /F /R /X & echo Scheduled for restart. & pause & goto optimize_disk
if "%d_choice%"=="4" goto menu
goto optimize_disk

:: ==================================================
:: 8. PARTITION MANAGER (COMPLETE)
:: ==================================================
:manage_partitions
cls
echo [Partition Manager]
echo 1. Open Disk Management (GUI - Recommended)
echo 2. List all Partitions (CMD)
echo 3. Create Partition (Scripted)
echo 4. Delete Partition (Scripted)
echo 5. Format Partition (Scripted)
echo 6. Back
set /p pt_choice=Choice: 

if "%pt_choice%"=="1" start diskmgmt.msc & goto manage_partitions
if "%pt_choice%"=="2" (
    (echo list disk & echo list volume) > list.txt
    diskpart /s list.txt
    del list.txt
    pause & goto manage_partitions
)
if "%pt_choice%"=="3" (
    set /p d=Disk Num: 
    set /p sz=Size MB: 
    (echo select disk !d! & echo create partition primary size=!sz!) > script.txt
    diskpart /s script.txt
    del script.txt
    pause & goto manage_partitions
)
if "%pt_choice%"=="4" (
    set /p d=Disk Num: 
    set /p p=Part Num: 
    (echo select disk !d! & echo select partition !p! & echo delete partition override) > script.txt
    diskpart /s script.txt
    del script.txt
    pause & goto manage_partitions
)
if "%pt_choice%"=="5" (
    set /p d=Disk Num: 
    set /p p=Part Num: 
    set /p f=FS (NTFS/FAT32): 
    (echo select disk !d! & echo select partition !p! & echo format fs=!f! quick) > script.txt
    diskpart /s script.txt
    del script.txt
    pause & goto manage_partitions
)
if "%pt_choice%"=="6" goto menu
goto manage_partitions

:: ==================================================
:: 9. SYSTEM REPAIR
:: ==================================================
:system_repair
echo 1. SFC Scannow
echo 2. DISM RestoreHealth
echo 3. Back
set /p r_choice=Choice: 
if "%r_choice%"=="1" sfc /scannow & pause & goto system_repair
if "%r_choice%"=="2" dism /online /cleanup-image /restorehealth & pause & goto system_repair
if "%r_choice%"=="3" goto menu
goto system_repair

:: ==================================================
:: 10. UPDATES & WINGET
:: ==================================================
:windows_update_menu
cls
echo [Updates]
echo 1. Update All Software (Winget)
echo 2. Enable Windows Update Service
echo 3. Disable Windows Update Service
echo 4. Force Check Updates
echo 5. Back
set /p u_choice=Choice: 
if "%u_choice%"=="1" winget upgrade --all --include-unknown --accept-source-agreements --accept-package-agreements & pause & goto windows_update_menu
if "%u_choice%"=="2" sc config wuauserv start= auto & net start wuauserv & pause & goto windows_update_menu
if "%u_choice%"=="3" sc config wuauserv start= disabled & net stop wuauserv & pause & goto windows_update_menu
if "%u_choice%"=="4" usoclient StartScan & echo Checking... & pause & goto windows_update_menu
if "%u_choice%"=="5" goto menu
goto windows_update_menu

:: ==================================================
:: 11. NETWORK (COMPLETE)
:: ==================================================
:optimize_network
cls
echo [Network Optimization]
echo 1. Optimize TCP Global (Speed)
echo 2. Set Cloudflare DNS (1.1.1.1)
echo 3. Set Google DNS (8.8.8.8)
echo 4. Reset Network Stack (Fix Issues)
echo 5. Disable IPv6 (Fix Connection Drops)
echo 6. Enable QoS Packet Scheduler
echo 7. Back
set /p n_choice=Choice: 

if "%n_choice%"=="1" (
    netsh int tcp set global autotuninglevel=normal
    netsh int tcp set global congestionprovider=ctcp
    netsh int tcp set global ecncapability=enabled
    echo TCP Optimized. & pause & goto optimize_network
)
if "%n_choice%"=="2" (
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        netsh interface ip set dns "%%j" static 1.1.1.1 primary
        netsh interface ip add dns "%%j" 1.0.0.1 index=2
    )
    echo Cloudflare DNS Set. & pause & goto optimize_network
)
if "%n_choice%"=="3" (
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        netsh interface ip set dns "%%j" static 8.8.8.8 primary
        netsh interface ip add dns "%%j" 8.8.4.4 index=2
    )
    echo Google DNS Set. & pause & goto optimize_network
)
if "%n_choice%"=="4" (
    netsh winsock reset & netsh int ip reset & ipconfig /flushdns
    echo Network Reset. Restart Required. & pause & goto optimize_network
)
if "%n_choice%"=="5" (
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
    echo IPv6 Disabled. & pause & goto optimize_network
)
if "%n_choice%"=="6" (
    netsh int tcp set global packetcoalescinginbound=disabled
    sc config "Qwave" start= auto
    net start Qwave
    echo QoS Enabled. & pause & goto optimize_network
)
if "%n_choice%"=="7" goto menu
goto optimize_network

:: ==================================================
:: 12. DEFENDER (COMPLETE)
:: ==================================================
:defender_menu
cls
echo [Windows Defender]
echo 1. Enable Real-Time Protection
echo 2. Disable Real-Time Protection (Not Recommended)
echo 3. Update Signatures
echo 4. Quick Scan
echo 5. Full Scan
echo 6. Enable Cloud Protection
echo 7. Disable Cloud Protection
echo 8. View Threat History
echo 9. Back
set /p df_choice=Choice: 

if "%df_choice%"=="1" powershell "Set-MpPreference -DisableRealtimeMonitoring $false" & echo Enabled. & pause & goto defender_menu
if "%df_choice%"=="2" powershell "Set-MpPreference -DisableRealtimeMonitoring $true" & echo Disabled. & pause & goto defender_menu
if "%df_choice%"=="3" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate & pause & goto defender_menu
if "%df_choice%"=="4" start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1 & goto defender_menu
if "%df_choice%"=="5" start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2 & goto defender_menu
if "%df_choice%"=="6" powershell "Set-MpPreference -MAPSReporting 2" & echo Cloud On. & pause & goto defender_menu
if "%df_choice%"=="7" powershell "Set-MpPreference -MAPSReporting 0" & echo Cloud Off. & pause & goto defender_menu
if "%df_choice%"=="8" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles & pause & goto defender_menu
if "%df_choice%"=="9" goto menu
goto defender_menu

:: ==================================================
:: 13. PRIVACY
:: ==================================================
:privacy_tweaks
echo.
echo Blocking Telemetry & Ads...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
echo Disabling Activity History...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
echo [OK] Privacy Settings Applied.
pause
goto menu

:: ==================================================
:: 14. ACTIVATION
:: ==================================================
:activation_menu
cls
echo [Activation Hub]
echo 1. Launch GitHub MAS (Best Method)
echo 2. Check Expiration
echo 3. Install Key Manually
echo 4. Uninstall Key
echo 5. Back
set /p a_choice=Choice: 
if "%a_choice%"=="1" powershell "irm https://get.activated.win | iex" & goto activation_menu
if "%a_choice%"=="2" slmgr /xpr & goto activation_menu
if "%a_choice%"=="3" set /p k=Key: & slmgr /ipk !k! & slmgr /ato & pause & goto activation_menu
if "%a_choice%"=="4" slmgr /upk & slmgr /cpky & pause & goto activation_menu
if "%a_choice%"=="5" goto menu
goto activation_menu

:: ==================================================
:: 15. BACKUP
:: ==================================================
:backup_restore
echo Creating Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual_Backup", 100, 7
if %errorlevel%==0 echo Success.
if %errorlevel% neq 0 echo Failed. Enable System Protection first.
pause
goto menu

:: ==================================================
:: 16. AUTO LOGIN (COMPLETE)
:: ==================================================
:auto_login_menu
cls
echo [Auto Login Config]
echo 1. Open Netplwiz (Safe GUI)
echo 2. Configure via Registry (Advanced/Scripted)
echo 3. Back
set /p al_choice=Choice: 
if "%al_choice%"=="1" start netplwiz & pause & goto auto_login_menu
if "%al_choice%"=="2" (
    echo WARNING: Password will be stored in Registry.
    set /p u=Username: 
    set /p p=Password: 
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultUserName /t REG_SZ /d "!u!" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /t REG_SZ /d "!p!" /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /t REG_SZ /d "1" /f
    echo Configured. & pause & goto auto_login_menu
)
if "%al_choice%"=="3" goto menu
goto auto_login_menu

:: ==================================================
:: 17. VISUALS & THEME
:: ==================================================
:visual_theme
cls
echo [Visuals & Theme]
echo 1. Enable Dark Mode
echo 2. Enable Light Mode
echo 3. Speed Up Animations (Menu Delay 0)
echo 4. Back
set /p v_choice=Choice: 
if "%v_choice%"=="1" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    echo Dark Mode On. & goto visual_theme
)
if "%v_choice%"=="2" (
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
    echo Light Mode On. & goto visual_theme
)
if "%v_choice%"=="3" (
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d "0" /f
    echo Animations Optimized. & pause & goto visual_theme
)
if "%v_choice%"=="4" goto menu
goto visual_theme

:: ==================================================
:: 18. SYSTEM INFO
:: ==================================================
:system_info
systeminfo | more
pause
goto menu

:: ==================================================
:: 99. AUTO PILOT
:: ==================================================
:auto_pilot
cls
echo [Auto-Pilot] Running Safe Optimizations...
echo 1. Creating Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "AutoPilot_Backup", 100, 7 >nul
echo 2. Setting Power Plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo 3. Cleaning Junk...
del /q /f /s %TEMP%\* >nul 2>&1
echo 4. Refreshing Network...
ipconfig /flushdns >nul
netsh winsock reset >nul
echo 5. Privacy Tweaks...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
echo.
echo [COMPLETE] Optimization Finished. Restart Recommended.
pause
goto menu

