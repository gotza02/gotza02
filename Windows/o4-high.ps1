@echo off
:: =============================================================
::   Win11-AIO-Tools.bat  –  All-In-One Windows 11 Maintenance
::   © 2025, Requires Administrator Privileges
:: =============================================================

title Win11 AIO Maintenance & Tweaks
color 0A
setlocal EnableDelayedExpansion

:: --- Administrator Check ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo ==========================================
    echo  Error: Administrator privileges required.
    echo  Please run this script as Administrator.
    echo ==========================================
    pause >nul
    goto :eof
)

:: --- Jump directly to the main menu ---
goto :menu

:: =============================================================
::                       FUNCTION DEFINITIONS
::  (These are called from the menu, execution jumps here)
:: =============================================================

:func_WindowsUpdate
    cls
    echo [Updating Windows...]
    echo   Stopping Windows Update service (wuauserv)...
    net stop wuauserv /y >nul
    echo   Starting Update Scan (UsoClient)...
    UsoClient StartScan
    echo   Forcing Update Detection (wuauclt)...
    wuauclt.exe /detectnow /updatenow
    echo   Restarting Windows Update service (wuauserv)...
    net start wuauserv >nul
    echo.
    echo Done. Windows Update check initiated.
    pause >nul
    goto :menu

:func_DisableWU
    cls
    echo [Disabling Windows Update Service & Related Tasks...]
    echo   Configuring wuauserv (Windows Update Service) to disabled...
    sc config wuauserv start=disabled >nul
    echo   Stopping wuauserv...
    sc stop wuauserv >nul
    echo   Configuring UsoSvc (Update Orchestrator Service) to disabled...
    sc config UsoSvc start=disabled >nul
    echo   Stopping UsoSvc...
    sc stop UsoSvc >nul
    echo   Setting Group Policy to prevent Automatic Updates...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f >nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions     /t REG_DWORD /d 1 /f >nul :: 1 = Never check for updates
    echo.
    echo Done. Windows Update Disabled.
    pause >nul
    goto :menu

:func_EnableWU
    cls
    echo [Enabling Windows Update Service & Related Tasks...]
    echo   Configuring wuauserv (Windows Update Service) to auto...
    sc config wuauserv start=auto >nul
    echo   Starting wuauserv...
    sc start wuauserv >nul
    echo   Configuring UsoSvc (Update Orchestrator Service) to auto...
    sc config UsoSvc start=auto >nul
    echo   Starting UsoSvc...
    sc start UsoSvc >nul
    echo   Removing Group Policy block for Automatic Updates...
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /f >nul 2>nul
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions     /f >nul 2>nul
    echo.
    echo Done. Windows Update Enabled.
    pause >nul
    goto :menu

:func_Defender
    cls
    echo [Updating Defender Signatures & Performing Full Scan...]
    echo   Updating Signatures...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    echo.
    echo   Starting Full Scan (this may take a long time)...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    echo.
    echo Done. Defender update and scan complete.
    pause >nul
    goto :menu

:func_DisableDefender
    cls
    echo [Disabling Defender Real-Time Protection...]
    echo   Setting Registry Policy (may require reboot or GPUpdate)...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f >nul
    echo   Attempting to disable via PowerShell cmdlet...
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    echo.
    echo Done. Real-Time Protection should be disabled (check Security Center). Reboot may be needed.
    pause >nul
    goto :menu

:func_EnableDefender
    cls
    echo [Enabling Defender Real-Time Protection...]
    echo   Removing Registry Policy...
    reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f >nul 2>nul
    echo   Attempting to enable via PowerShell cmdlet...
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    echo.
    echo Done. Real-Time Protection should be enabled (check Security Center).
    pause >nul
    goto :menu

:func_AppDriverUpdate
    cls
    echo [Updating Apps (winget + choco) and Drivers...]
    echo   Updating apps via winget...
    winget upgrade --all --accept-package-agreements --accept-source-agreements --silent
    echo.
    echo   Updating apps via Chocolatey...
    choco upgrade all -y --accept-licenses
    echo.
    echo   Updating drivers found in C:\Drivers\...
    if exist "C:\Drivers\" (
        for /f "delims=" %%i in ('dir /b /s "C:\Drivers\*.inf"') do (
            echo     Adding/Installing driver: "%%i"
            pnputil /add-driver "%%i" /install
        )
        echo   Scanning for hardware changes...
        pnputil /scan-devices
    ) else (
        echo   Directory C:\Drivers\ not found. Skipping driver update.
    )
    echo.
    echo Done. App and Driver update process finished.
    pause >nul
    goto :menu

:func_ImageRepair
    cls
    echo [Running System File Checker, DISM RestoreHealth, and Check Disk...]
    echo   Starting DISM /Online /Cleanup-Image /RestoreHealth...
    DISM /Online /Cleanup-Image /RestoreHealth
    echo.
    echo   Starting SFC /scannow...
    sfc /scannow
    echo.
    echo   Scheduling Check Disk (chkdsk) for C: on next reboot...
    echo Y | chkdsk C: /F /R /X
    echo.
    echo Done. DISM and SFC completed. CHKDSK will run on the next reboot.
    pause >nul
    goto :menu

:func_Cleanup
    cls
    echo [Performing Disk Cleanup and Clearing Temp/Prefetch Folders...]
    echo   Configuring Disk Cleanup presets (runs only once)...
    cleanmgr /sageset:1 >nul
    echo   Running Disk Cleanup with preset 1...
    cleanmgr /sagerun:1
    echo   Clearing Prefetch folder...
    rmdir /s /q C:\Windows\Prefetch 2>nul & mkdir C:\Windows\Prefetch >nul
    echo   Clearing System Temp folder...
    rmdir /s /q "%SystemRoot%\Temp" 2>nul & mkdir "%SystemRoot%\Temp" >nul
    echo   Clearing User Temp folder...
    rmdir /s /q "%USERPROFILE%\AppData\Local\Temp" 2>nul & mkdir "%USERPROFILE%\AppData\Local\Temp" >nul
    echo.
    echo Done. Cleanup finished.
    pause >nul
    goto :menu

:func_EventLogs
    cls
    echo [Clearing All Windows Event Logs...]
    for /f "tokens=*" %%G in ('wevtutil el') do (
        echo   Clearing log: %%G
        wevtutil cl "%%G" /q:true
    )
    echo.
    echo Done. Event Logs cleared.
    pause >nul
    goto :menu

:func_OptimizeDisk
    cls
    echo [Optimizing Drive C: (Defrag for HDD / TRIM for SSD)...]
    defrag C: /O /X
    echo.
    echo Done. Drive optimization complete.
    pause >nul
    goto :menu

:func_RebuildCaches
    cls
    echo [Rebuilding Windows Search Index and Font Cache...]
    echo   Stopping Windows Search service...
    net stop wsearch >nul
    echo   Deleting Search Index database (will be rebuilt)...
    del "%ProgramData%\Microsoft\Search\Data\Applications\Windows\windows.edb" /f /q /s 2>nul
    echo   Starting Windows Search service...
    net start wsearch >nul
    echo   Stopping Font Cache service...
    net stop FontCache >nul
    echo   Deleting Font Cache files...
    del /f /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache*" 2>nul
    echo   Starting Font Cache service...
    net start FontCache >nul
    echo.
    echo Done. Caches will be rebuilt. This might take some time in the background.
    pause >nul
    goto :menu

:func_PowerPlan
    cls
    echo [Activating High-Performance Power Plan...]
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powercfg /getactivescheme
    echo.
    echo Done. High-Performance plan activated.
    pause >nul
    goto :menu

:func_NetworkTweaks
    cls
    echo [Applying Network Tweaks (Disabling TCP Auto-Tuning & Flushing DNS)...]
    echo   Disabling TCP Auto-Tuning...
    netsh int tcp set global autotuninglevel=disabled
    echo   Flushing DNS Cache...
    ipconfig /flushdns
    echo.
    echo Done. Network tweaks applied.
    pause >nul
    goto :menu

:func_Debloat
    cls
    echo [Running External Windows 11 Debloater Script...]
    echo   NOTE: This uses a third-party script. Review it first if desired:
    echo   https://git.io/debloat11 redirects to https://github.com/ChrisTitusTech/winutil/blob/main/debloat-windows.ps1
    echo.
    echo   Downloading and executing script...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://git.io/debloat11 | iex"
    echo.
    echo Done. Debloating script finished. Check its output for details.
    pause >nul
    goto :menu

:func_TaskCleanup
    cls
    :TaskCleanupLoop
    cls
    echo [Scheduled Tasks Cleanup Options...]
    echo   1. Delete ALL non-Microsoft scheduled tasks (Use with caution!)
    echo   2. Delete a specific scheduled task by name
    echo   3. Back to main menu
    echo.
    set /p tchoice="Select option [1-3]: "

    if /i "%tchoice%"=="1" (
        echo   WARNING: This will attempt to delete all non-Microsoft tasks.
        set /p confirm="Are you sure? (Y/N): "
        if /i "!confirm!"=="Y" (
            echo   Deleting all non-Microsoft tasks...
            for /f "tokens=1,* skip=2" %%a in ('schtasks /query /nh /fo csv') do (
                set "taskname=%%~b"
                :: Basic check to avoid deleting core Microsoft tasks
                if /i not "!taskname:\Microsoft\=!" == "!taskname!" (
                    echo     Skipping Microsoft task: !taskname!
                ) else if /i not "!taskname:\Windows\=!" == "!taskname!" (
                     echo     Skipping Windows task: !taskname!
                ) else (
                    echo     Deleting task: !taskname!
                    schtasks /delete /tn "!taskname!" /f >nul
                )
            )
            echo.
            echo   Deletion attempt finished.
            pause >nul
        ) else (
            echo   Operation cancelled.
            pause >nul
        )
        goto :TaskCleanupLoop
    )
    if /i "%tchoice%"=="2" (
        echo   Enter the EXACT Task Name including the path (e.g., \MyTasks\MyTask)
        set /p tname="Task Name: "
        if not "%tname%"=="" (
            echo   Deleting task: %tname%
            schtasks /delete /tn "%tname%" /f
            pause >nul
        ) else (
            echo   No task name entered.
            pause >nul
        )
        goto :TaskCleanupLoop
    )
    if /i "%tchoice%"=="3" (
        goto :menu
    )

    echo   Invalid choice.
    pause >nul
    goto :TaskCleanupLoop

:func_Tweaks
    cls
    echo [Applying Visual & System Performance Tweaks...]
    echo   Applying Visual Effects for Best Performance...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
    reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
    echo   Setting Menu Show Delay to Faster (100ms)...
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f >nul
    echo   Disabling Transparency Effects...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul
    echo   Disabling Hibernation (saves disk space)...
    powercfg /hibernate off
    echo   Enabling Clear Page File at Shutdown (Security/Performance)...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f >nul
    echo   Setting Page File to Automatic Management...
    wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True >nul
    echo   Disabling Game DVR...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul
    echo   Enabling Hardware-accelerated GPU Scheduling (Requires Reboot)...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul
    echo   Disabling Telemetry & Related Services...
    sc config DiagTrack start=disabled >nul & sc stop DiagTrack >nul
    sc config dmwappushservice start=disabled >nul & sc stop dmwappushservice >nul
    echo   Disabling Superfetch/SysMain...
    sc config SysMain start=disabled >nul & sc stop SysMain >nul
    echo.
    echo Done. Many changes require a REBOOT to take full effect.
    pause >nul
    goto :menu

:func_RunAll
    cls
    echo ===== Starting All Maintenance Functions =====
    echo.
    call :func_DisableWU
    call :func_EnableWU
    call :func_WindowsUpdate
    call :func_DisableDefender
    call :func_EnableDefender
    call :func_Defender
    call :func_AppDriverUpdate
    call :func_ImageRepair
    call :func_Cleanup
    call :func_EventLogs
    call :func_OptimizeDisk
    call :func_RebuildCaches
    call :func_PowerPlan
    call :func_NetworkTweaks
    call :func_Debloat
    echo.
    echo   [Skipping Scheduled Task Cleanup in 'Run All' - Run manually if needed]
    echo.
    call :func_Tweaks
    echo ==================================================
    echo  All functions executed. Please REBOOT your system
    echo  for all changes (like chkdsk, HwSchMode, etc.)
    echo  to take full effect.
    echo ==================================================
    pause >nul
    goto :eof

:: =============================================================
::                       MAIN MENU LOOP
:: =============================================================
:menu
    cls
    echo ==============================================
    echo      Windows 11 AIO Maintenance & Tweaks
    echo ==============================================
    echo [System Maintenance]
    echo  1. Run Windows Update (Check & Initiate)
    echo  4. Update Defender & Full Scan
    echo  7. Update Apps (winget/choco) & Drivers (C:\Drivers)
    echo  8. System File Repair (DISM, SFC, CHKDSK)
    echo  9. Disk & Temp File Cleanup
    echo 10. Clear All Event Logs
    echo 11. Optimize Drive C: (Defrag/TRIM)
    echo 12. Rebuild Search Index & Font Cache
    echo.
    echo [Service Toggles]
    echo  2. Disable Windows Update Service
    echo  3. Enable Windows Update Service
    echo  5. Disable Defender Real-Time Protection
    echo  6. Enable Defender Real-Time Protection
    echo.
    echo [System Tweaks]
    echo 13. Activate High-Performance Power Plan
    echo 14. Apply Network Tweaks (TCP/DNS)
    echo 15. Run External Debloater Script (Chris Titus Tech)
    echo 16. Scheduled Tasks Cleanup (Manual Options)
    echo 17. Apply Visual & Performance Tweaks (Reboot Recommended)
    echo.
    echo [Bulk Operations]
    echo 18. Run ALL Maintenance & Tweaks (Reboot Required)
    echo.
    echo  0. Exit Script
    echo ==============================================
    set /p choice="Select option [0-18]: "

    :: --- Menu Choices ---
    if /i "%choice%" == "1"  goto :func_WindowsUpdate
    if /i "%choice%" == "2"  goto :func_DisableWU
    if /i "%choice%" == "3"  goto :func_EnableWU
    if /i "%choice%" == "4"  goto :func_Defender
    if /i "%choice%" == "5"  goto :func_DisableDefender
    if /i "%choice%" == "6"  goto :func_EnableDefender
    if /i "%choice%" == "7"  goto :func_AppDriverUpdate
    if /i "%choice%" == "8"  goto :func_ImageRepair
    if /i "%choice%" == "9"  goto :func_Cleanup
    if /i "%choice%" == "10" goto :func_EventLogs
    if /i "%choice%" == "11" goto :func_OptimizeDisk
    if /i "%choice%" == "12" goto :func_RebuildCaches
    if /i "%choice%" == "13" goto :func_PowerPlan
    if /i "%choice%" == "14" goto :func_NetworkTweaks
    if /i "%choice%" == "15" goto :func_Debloat
    if /i "%choice%" == "16" goto :func_TaskCleanup
    if /i "%choice%" == "17" goto :func_Tweaks
    if /i "%choice%" == "18" goto :func_RunAll
    if /i "%choice%" == "0"  goto :eof

    :: --- Invalid Choice Handling ---
    echo.
    echo Invalid choice '%choice%'. Please try again.
    pause >nul
    goto :menu

:: --- End of Script ---
:eof
echo Exiting script.
endlocal
