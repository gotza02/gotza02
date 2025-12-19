@echo off
setlocal enabledelayedexpansion

:: ==============================================================================
:: Windows 11 Optimization & Management Script v5.3 (Stable Edition)
:: Updated for Windows 11 23H2/24H2 - Bug Fixed & Safer
:: ==============================================================================

:init
title Windows 11 Management Suite v5.3 (Stable)
set "script_version=5.3"

:: Check for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script requires Administrator privileges.
    echo Please right-click and "Run as administrator".
    pause
    exit /b 1
)

:: Safety First: Prompt for Restore Point
cls
echo ==============================================================================
echo                              SAFETY CHECK
echo ==============================================================================
echo It is highly recommended to create a System Restore Point before proceeding.
set /p create_rp="Create a restore point now? (Y/N): "
if /i "%create_rp%"=="Y" (
    echo Creating restore point...
    powershell -Command "Checkpoint-Computer -Description 'BeforeWin11Optimize_v5_%date%' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
    if %errorlevel% equ 0 (echo [SUCCESS] Restore point created.) else (echo [WARNING] Failed to create restore point. Ensure System Protection is enabled.)
)
timeout /t 2 >nul

:menu
cls
echo ==============================================================================
echo    WINDOWS 11 MANAGEMENT SUITE - v%script_version% (Stable Edition)
echo ==============================================================================
echo  1. Optimize Display & UI Performance   12. Manage Power, Sleep & Actions
echo  2. Windows Defender Management         13. Enable Dark Mode (System-wide)
echo  3. Win 11 Debloat & UI Tweaks          14. Partition Management (Diskpart)
echo  4. CPU, GPU & Gaming Optimization      15. Advanced Cleaning (Update Cache/Logs)
echo  5. Adv. Network & DNS Tuning           16. Startup Programs Manager
echo  6. Windows Update Control              17. Backup & Recovery Options
echo  7. Configure Auto-login                18. Detailed System Info & Disk Health
echo  8. Clear System & Temp Cache           19. Ultimate Privacy & Telemetry Block
echo  9. Disk Defrag & SSD Trim              20. Windows Services & Bloat Removal
echo 10. Repair System Files (SFC/DISM)      21. Advanced Network Reset
echo 11. Windows Activation (MAS)            22. Install Essential Runtimes (Winget)
echo  A. Advanced Context Menu Tools         23. Exit
echo ==============================================================================
set /p choice="Enter selection (1-23, A): "

:: Menu Routing
if /i "%choice%"=="23" exit /b 0
if /i "%choice%"=="A" (call :option_A & goto menu)

:: Simple Validation
set "found_option=0"
for /l %%i in (1,1,22) do if "%choice%"=="%%i" set "found_option=1"
if "%found_option%"=="0" (
    echo [ERROR] Invalid selection.
    timeout /t 2 >nul
    goto menu
)

call :option_%choice%
goto menu

:: ==============================================================================
:: OPTION FUNCTIONS
:: ==============================================================================

:option_1
echo Optimizing display for Windows 11...
call :reg_add "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :reg_add "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :reg_add "HKCU\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo [DONE] Display optimized.
pause
exit /b

:option_2
cls
echo --- Windows Defender Management ---
echo Note: To strictly disable Defender, you MUST turn off 'Tamper Protection' 
echo manually in Windows Security settings first.
echo.
echo 1. Check Status  2. Enable  3. Disable (Requires Tamper OFF)  4. Quick Scan  5. Return
set /p def_c="Choice: "
if "%def_c%"=="1" (sc query windefend & pause)
if "%def_c%"=="2" (powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" & echo Enabled. & pause)
if "%def_c%"=="3" (
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
    echo [INFO] Sent disable commands.
    pause
)
if "%def_c%"=="4" (echo Scanning... & "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1 & echo Done. & pause)
exit /b

:option_3
echo Optimizing Windows 11 Features & Debloating...
echo 1. Standard Debloat  2. Classic Context Menu  3. Disable Widgets  4. Disable Chat  5. All
set /p ui_c="Choice (1-5): "
if "%ui_c%"=="1" (call :ui_debloat)
if "%ui_c%"=="2" (call :ui_classic)
if "%ui_c%"=="3" (call :ui_widgets)
if "%ui_c%"=="4" (call :ui_chat)
if "%ui_c%"=="5" (
    call :ui_debloat & call :ui_classic & call :ui_widgets & call :ui_chat
    taskkill /f /im explorer.exe >nul & start explorer.exe
)
echo [DONE]
pause
exit /b

:ui_debloat
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowCopilotButton" "REG_DWORD" "0"
dism /online /Disable-Feature /FeatureName:Recall /NoRestart >nul 2>&1
call :reg_add "HKCU\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" "REG_DWORD" "0"
call :reg_add "HKCU\Software\Microsoft\GameBar" "AllowAutoGameMode" "REG_DWORD" "1"
exit /b

:ui_classic
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul
exit /b

:ui_widgets
call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" "AllowNewsAndInterests" "REG_DWORD" "0"
exit /b

:ui_chat
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" "REG_DWORD" "0"
exit /b


:option_4
echo CPU, GPU & Gaming Optimization...
:: Ultimate Performance Power Plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
:: Gaming Tweaks
echo Disabling HPET...
bcdedit /set useplatformclock false >nul 2>&1
bcdedit /deletevalue useplatformclock >nul 2>&1
echo Disabling Fullscreen Optimizations...
call :reg_add "HKCU\System\GameConfigStore" "GameDVR_FSEBehavior" "REG_DWORD" "2"
:: Hardware-accelerated GPU scheduling
call :reg_add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Clearing DirectX Shader Cache...
if exist "%LocalAppData%\Microsoft\DirectX Shader Cache" del /q /s /f "%LocalAppData%\Microsoft\DirectX Shader Cache\*" >nul 2>&1
echo [DONE] Gaming optimizations applied.
pause
exit /b

:option_5
echo Advanced Network Tuning & DNS...
echo 1. Optimize TCP Stack  2. Cloudflare DNS  3. Google DNS  4. Custom  5. Reset
set /p net_c="Choice (1-5): "
if "%net_c%"=="1" (
    netsh int tcp set global autotuninglevel=normal & netsh int tcp set global rss=enabled
    netsh int tcp set global fastopen=enabled & netsh int tcp set global chimney=enabled
    netsh int tcp set global dca=enabled & netsh int tcp set global netdma=enabled
    netsh int tcp set global ecncapability=enabled & netsh int tcp set global timestamps=disabled
)
if "%net_c%"=="2" (powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-DnsClientServerAddress -ServerAddresses ('1.1.1.1','1.0.0.1')")
if "%net_c%"=="3" (powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-DnsClientServerAddress -ServerAddresses ('8.8.8.8','8.8.4.4')")
if "%net_c%"=="4" (set /p pri="Primary: " & set /p sec="Secondary: " & powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-DnsClientServerAddress -ServerAddresses ('%pri%','%sec%')")
if "%net_c%"=="5" (powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Set-DnsClientServerAddress -ResetServerAddresses")
echo [DONE]
pause
exit /b

:option_6
cls
echo --- Windows Update Control ---
echo 1. Enable  2. Disable  3. Check Now
set /p wu_c="Choice: "
if "%wu_c%"=="1" (sc config wuauserv start= auto & sc start wuauserv)
if "%wu_c%"=="2" (sc stop wuauserv & sc config wuauserv start= disabled)
if "%wu_c%"=="3" (powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()")
echo [DONE]
pause
exit /b

:option_7
echo Configuring Auto-login...
set /p "u=Username: " & set /p "p=Password: "
call :reg_add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%u%"
call :reg_add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%p%"
call :reg_add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo [DONE]
pause
exit /b

:option_8
echo Clearing Cache...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
echo [DONE]
pause
exit /b

:option_9
echo Disk Management...
powershell -Command "Optimize-Volume -DriveLetter C -ReTrim"
echo [DONE]
pause
exit /b

:option_10
echo Repairing System Files...
sfc /scannow & dism /online /cleanup-image /restorehealth
echo [DONE]
pause
exit /b

:option_11
cls
echo --- Activation (MAS) ---
echo 1. Status  2. MAS Recommended  3. Alternative  4. Manual Key
set /p act_c="Choice: "
if "%act_c%"=="1" (slmgr /xpr & pause)
if "%act_c%"=="2" (powershell -Command "irm https://get.activated.win | iex")
if "%act_c%"=="3" (powershell -Command "iex (curl.exe -s --doh-url https://1.1.1.1/dns-query https://get.activated.win | Out-String)")
if "%act_c%"=="4" (set /p "key=Key: " & slmgr /ipk %key% & slmgr /ato & pause)
exit /b

:option_12
cls
echo --- Power & Actions ---
echo 1. Sleep Timeout  2. Lid Action (Do Nothing)  3. Disable Fast Startup
set /p pwr_c="Choice: "
if "%pwr_c%"=="1" (set /p "st=Minutes: " & powercfg /change standby-timeout-ac %st% & powercfg /change standby-timeout-dc %st%)
if "%pwr_c%"=="2" (
    powercfg /setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-4760f11c9364 0
    powercfg /setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-4760f11c9364 0
    powercfg /setactive SCHEME_CURRENT
)
if "%pwr_c%"=="3" (call :reg_add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "0")
echo [DONE]
pause
exit /b

:option_13
call :reg_add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :reg_add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo [DONE]
pause
exit /b

:option_14
diskpart
exit /b

:option_15
echo Advanced Cleaning (Deep Mode)...
net stop wuauserv /y & net stop bits /y
echo Clearing Windows Update Cache...
del /q /s /f "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
echo Clearing Event Logs...
for /F "tokens=*" %%G in ('wevtutil.exe el') do (wevtutil.exe cl "%%G")
net start wuauserv & net start bits
cleanmgr /sagerun:1
echo [DONE]
pause
exit /b

:option_16
start msconfig
exit /b

:option_17
control /name Microsoft.BackupAndRestore
exit /b

:option_18
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type"
powershell -Command "Get-PhysicalDisk | Select-Object DeviceID, FriendlyName, OperationalStatus, HealthStatus | Format-Table -AutoSize"
pause
exit /b

:option_19
echo Ultimate Privacy & Telemetry Block...
:: Registry Tweaks
call :reg_add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :reg_add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
:: Hosts File Block (Improved with Duplicate Check)
echo Blocking Telemetry Domains in Hosts file...
set "HOSTS=%windir%\System32\drivers\etc\hosts"
attrib -r "%HOSTS%"
for %%D in (
    "telemetry.microsoft.com"
    "v10.events.data.microsoft.com"
    "settings-win.data.microsoft.com"
    "diagnostics.office.microsoft.com"
) do (
    findstr /c:"%%~D" "%HOSTS%" >nul || (echo 0.0.0.0 %%~D >> "%HOSTS%")
)
attrib +r "%HOSTS%"
echo [DONE]
pause
exit /b

:option_20
cls
echo --- Services Optimization ---
echo 1. Manual Console  2. Auto-Disable Bloat Services
set /p svc_c="Choice: "
if "%svc_c%"=="1" (services.msc)
if "%svc_c%"=="2" (
    for %%s in (Spooler Fax DiagTrack dmwappushservice MapsBroker XblAuthManager XblGameSave XboxNetApiSvc RemoteRegistry) do (
        echo Optimizing service: %%s
        sc config "%%s" start= disabled >nul 2>&1
        net stop "%%s" /y >nul 2>&1
    )
)
echo [DONE]
pause
exit /b

:option_21
netsh winsock reset & netsh int ip reset & ipconfig /flushdns
echo [DONE] Restart required.
pause
exit /b

:option_22
winget install --id Abbodi1406.VCRedistVisualCPlusPlusRedistributableRuntimesAllInOne --silent --accept-package-agreements
winget install --id Microsoft.DirectX --silent --accept-package-agreements
pause
exit /b

:option_A
cls
echo --- Advanced Context Menu Tools ---
echo 1. Add 'Take Ownership' to Context Menu
echo 2. Remove 'Take Ownership'
set /p ctx_c="Choice: "
if "%ctx_c%"=="1" (
    reg add "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul
    reg add "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%%%1\" && icacls \"%%%%1\" /grant administrators:F" /f >nul
    reg add "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take Ownership" /f >nul
    reg add "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%%%1\" /r /d y && icacls \"%%%%1\" /grant administrators:F /t" /f >nul
    echo [DONE] 
)
if "%ctx_c%"=="2" (
    reg delete "HKCR\*\shell\runas" /f
    reg delete "HKCR\Directory\shell\runas" /f
    echo [DONE]
)
pause
exit /b

:option_23
exit /b

:: UTILITIES
:reg_add
reg add "%~1" /v "%~2" /t %~3 /d "%~4" /f >nul 2>&1
exit /b 0
