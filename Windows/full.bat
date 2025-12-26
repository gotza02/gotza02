@echo off
setlocal enabledelayedexpansion
title Ultimate Windows 10/11 AIO Script (Final Edition)
color 1F
mode con: cols=105 lines=45

:: ==================================================
:: 1. AUTO-ADMIN ELEVATION & INITIALIZATION
:: ==================================================
:check_permissions
    echo Administrative permissions required. Detecting permissions...
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        goto :init
    ) else (
        echo Requesting administrative privileges...
        goto :uac_prompt
    )

:uac_prompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:init
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    :: Set working directory to script location
    pushd "%CD%"
    CD /D "%~dp0"
    
:: ==================================================
:: 2. SAFETY CHECK
:: ==================================================
:safety_check
    cls
    echo.
    echo  =============================================================
    echo   SYSTEM SAFETY CHECK (RECOMMENDED)
    echo  =============================================================
    echo.
    set /p restore_confirm="Create Restore Point before starting? (Y/N): "
    if /i "%restore_confirm%"=="Y" (
        echo Creating Restore Point...
        wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "AIO Script Backup", 100, 7 >nul 2>&1
        if !errorlevel! equ 0 ( echo [OK] Restore Point Created. ) else ( echo [SKIP] Failed/Disabled. )
        timeout /t 2 >nul
    )

:: ==================================================
:: 3. MAIN MENU
:: ==================================================
:menu
cls
color 1F
echo.
    echo  =============================================================
    echo   ULTIMATE WINDOWS 10/11 AIO SCRIPT (FINAL EDITION)
    echo  =============================================================
    echo.
    echo  [ ESSENTIAL TWEAKS ]
    echo   1. System Optimization (Display, CPU, Explorer)
    echo   2. Network Boost (DNS: Google, TCP Tweaks)
    echo   3. Disk Cleanup Pro (Deep Clean + Update Cache)
    echo.
    echo  [ WINDOWS 11 SPECIALS ]
    echo   4. Restore Classic Context Menu (Right-click style)
    echo   5. Revert to Modern Context Menu
    echo.
    echo  [ GAMING & BLOATWARE ]
    echo   6. Gaming Mode (Disable SysMain, Xbox Services, etc.)
    echo   7. Safe Debloat (Remove Tips, Maps, Solitaire, Feedback)
    echo.
    echo  [ SECURITY & REPAIR ]
    echo   8. Windows Defender Manager (On/Off)
    echo   9. Repair System (SFC, DISM, Store Fix, Time Sync)
    echo   10. Privacy (Disable Telemetry & Tracking)
    echo.
    echo  [ UTILITIES ]
    echo   11. WINDOWS ACTIVATION (MAS - Permanent)
    echo   12. Network Reset (Fix Connection)
    echo   13. Exit
    echo.
    echo  =============================================================
    set /p choice="Enter Choice (1-13): "

    if "%choice%"=="1" goto opt_optimize
    if "%choice%"=="2" goto opt_network
    if "%choice%"=="3" goto opt_cleanup
    if "%choice%"=="4" goto opt_win11_classic
    if "%choice%"=="5" goto opt_win11_modern
    if "%choice%"=="6" goto opt_gaming
    if "%choice%"=="7" goto opt_debloat
    if "%choice%"=="8" goto opt_defender
    if "%choice%"=="9" goto opt_repair_menu
    if "%choice%"=="10" goto opt_privacy
    if "%choice%"=="11" goto opt_activate
    if "%choice%"=="12" goto opt_netreset
    if "%choice%"=="13" exit
    goto menu

:: ==================================================
:: FUNCTIONS
:: ==================================================

:opt_optimize
    echo.
    echo [1/3] Optimizing Visual Effects...
    call :reg_add "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
    call :reg_add "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
    call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
    echo [2/3] Enabling Ultimate Performance...
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    if %errorlevel% neq 0 powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo [3/3] Restarting Explorer...
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    echo [OK] Optimization Complete.
    pause
    goto menu

:opt_network
    echo.
    echo Setting TCP Global parameters...
    netsh int tcp set global autotuninglevel=normal rss=enabled ecncapability=enabled >nul
    echo Setting DNS to Google (8.8.8.8) via PowerShell...
    powershell -NoProfile -Command "Get-NetAdapter | Where-Object Status -eq 'Up' | Set-DnsClientServerAddress -ServerAddresses '8.8.8.8','8.8.4.4'"
    echo [OK] Network Optimized.
    pause
    goto menu

:opt_cleanup
    echo.
    echo Setting up Deep Cleanup...
    rem Create flags for automatic cleanup
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
    echo Running CleanMgr (This may take a while)...
    cleanmgr /sagerun:1
    echo Deleting Temp files...
    del /q /f /s %TEMP%\* >nul 2>&1
    echo [OK] System Cleaned.
    pause
    goto menu

:opt_win11_classic
    echo.
    echo Applying Classic Context Menu (Windows 11)...
    reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul 2>&1
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    echo [OK] Classic Menu Applied.
    pause
    goto menu

:opt_win11_modern
    echo.
    echo Reverting to Modern Context Menu...
    reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe
    echo [OK] Modern Menu Restored.
    pause
    goto menu

:opt_gaming
    echo.
    echo [GAMING MODE] Disabling heavy background services...
    call :svc_stop "SysMain"
    call :svc_stop "DiagTrack"
    call :svc_stop "MapsBroker"
    call :svc_stop "Fax"
    echo [OK] Gaming Mode ON.
    pause
    goto menu

:opt_debloat
    echo.
    echo [SAFE DEBLOAT] Removing specific useless apps...
    echo Removing: Solitaire, BingNews, GetHelp, FeedbackHub, Maps, People...
    powershell -Command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *gethelp* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *feedbackhub* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"
    powershell -Command "Get-AppxPackage *people* | Remove-AppxPackage"
    echo [OK] Bloatware Removed.
    pause
    goto menu

:opt_defender
    cls
    echo [DEFENDER MANAGER]
    echo 1. Disable (Requires Tamper Protection OFF manually)
    echo 2. Enable
    echo 3. Open Security Settings
    set /p defchoice="Select: "
    if "%defchoice%"=="3" start windowsdefender: && goto menu
    if "%defchoice%"=="1" (
        call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
        call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
        echo [INFO] Restart required.
    )
    if "%defchoice%"=="2" (
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /f >nul 2>&1
        reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /f >nul 2>&1
        echo [OK] Defender Enabled.
    )
    pause
    goto menu

:opt_repair_menu
    cls
    echo [REPAIR MENU]
    echo 1. SFC Scan (System Files)
    echo 2. DISM Restore (System Image)
    echo 3. Sync Windows Time (Fix Date/Time issues)
    echo 4. Reset Windows Store
    echo 5. Back
    set /p rchoice="Select: "
    if "%rchoice%"=="1" sfc /scannow & pause & goto opt_repair_menu
    if "%rchoice%"=="2" DISM /Online /Cleanup-Image /RestoreHealth & pause & goto opt_repair_menu
    if "%rchoice%"=="3" (
        net stop w32time
        w32tm /unregister
        w32tm /register
        net start w32time
        timeout /t 2 >nul
        w32tm /resync
        echo [OK] Time Synced.
        pause & goto opt_repair_menu
    )
    if "%rchoice%"=="4" (
        wsreset.exe
        goto opt_repair_menu
    )
    if "%rchoice%"=="5" goto menu
    goto menu

:opt_privacy
    call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
    call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
    echo [OK] Telemetry Disabled.
    pause
    goto menu

:opt_activate
    cls
    color 0A
    echo [ACTIVATION]
    echo 1. HWID (Permanent - Win 10/11)
    echo 2. KMS38 (Server/LTSC)
    echo 3. Online KMS
    set /p actchoice="Select: "
    set "mas_link=irm https://massgrave.dev/get | iex"
    if "%actchoice%"=="1" powershell -NoProfile -Command "%mas_link%; [Activator]::HWID($null)"
    if "%actchoice%"=="2" powershell -NoProfile -Command "%mas_link%; [Activator]::KMS38($null)"
    if "%actchoice%"=="3" powershell -NoProfile -Command "%mas_link%; [Activator]::Online_KMS($null)"
    pause
    goto menu

:opt_netreset
    ipconfig /flushdns
    netsh winsock reset
    netsh int ip reset
    echo [INFO] Restart required.
    pause
    goto menu

:: ==================================================
:: SHARED FUNCTIONS
:: ==================================================

:reg_add
    reg add %1 /v %2 /t %3 /d %4 /f >nul 2>&1
    exit /b

:svc_stop
    sc config %1 start= disabled >nul 2>&1
    net stop %1 >nul 2>&1
    echo   - Service %1 Disabled.
    exit /b
