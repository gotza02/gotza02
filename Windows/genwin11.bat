@echo off
setlocal

REM ============================================================================
REM AIO Windows 11 Optimization Batch Script
REM Version: 1.1 (Batch Equivalent)
REM Date:    %DATE%
REM WARNING: RUN THIS SCRIPT AS ADMINISTRATOR!
REM WARNING: USE AT YOUR OWN RISK. Backup data and create restore point first.
REM WARNING: Review script carefully. Commented sections are disabled by default.
REM ============================================================================

REM --- Script Initialization ---
cls
echo ==================================================
echo AIO Windows 11 Optimization Batch Script
echo ==================================================
echo.

REM --- Administrator Check ---
echo Checking for Administrator privileges...
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERROR: Administrator privileges are required!
    echo Please re-run this script as an Administrator.
    echo.
    pause
    goto :EOF
)
echo Administrator privileges confirmed.
timeout /t 2 /nobreak > nul

REM --- Section 0: IMPORTANT Pre-Checks & Reminders (Manual Steps) ---
echo.
echo --- Section 0: IMPORTANT Pre-Checks & Reminders (Manual Steps) ---
echo IMPORTANT: This script focuses on software tweaks. For MAXIMUM performance, ensure:
echo 1. BIOS/UEFI is UP-TO-DATE (Check manufacturer's website).
echo 2. XMP (Intel) / EXPO or DOCP (AMD) is ENABLED in BIOS/UEFI for full RAM speed.
echo 3. Resizable BAR / Smart Access Memory is ENABLED in BIOS/UEFI (if supported).
echo 4. Virtualization (Intel VT-x / AMD-V) is ENABLED in BIOS/UEFI if needed.
echo 5. LATEST Chipset drivers are installed (Motherboard/Laptop manufacturer).
echo 6. LATEST GPU drivers (NVIDIA/AMD/Intel) are installed (GPU manufacturer).
echo 7. Other essential drivers (Audio, LAN, Wi-Fi) are up-to-date.
echo 8. Windows is fully updated (Settings ^> Windows Update).
echo.
echo Press any key to continue after reviewing the manual steps...
pause > nul
timeout /t 2 /nobreak > nul

REM --- Section 1: Remove Common Bloatware (UWP Apps) ---
echo.
echo --- Section 1: Removing Common Bloatware (UWP Apps) ---
echo NOTE: Native UWP App removal is NOT FEASIBLE with pure Batch script.
echo Please use PowerShell or third-party tools (like WingetUI, OOSU10, etc.)
echo to remove unwanted Microsoft Store apps (Cortana, Maps, Your Phone, etc.).
echo This section is skipped.
echo.
timeout /t 5 /nobreak > nul

REM --- Section 2: Performance Tuning ---
echo.
echo --- Section 2: Applying Performance Settings ---
timeout /t 1 /nobreak > nul

echo Setting Power Plan...
REM Attempt to activate Ultimate Performance (GUID may vary slightly or not exist)
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
REM Always attempt to set High Performance as fallback or primary if Ultimate failed/not present
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > nul 2>&1
echo Power Plan set to High Performance or Ultimate Performance (if available).
timeout /t 1 /nobreak > nul

echo Adjusting Visual Effects for Performance...
REM Set global setting to 'Adjust for best performance'
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f > nul
REM Disable taskbar animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f > nul
REM Disable minimize/maximize window animations
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f > nul
REM Faster menu show delay
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f > nul
REM Disable Transparency effects (Windows 11)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f > nul
REM Disable Animation effects (Windows 11)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AnimationsEnabled /t REG_DWORD /d 0 /f > nul
REM NOTE: UserPreferencesMask binary value is omitted due to Batch limitations.
echo Visual Effects adjusted.
timeout /t 1 /nobreak > nul

echo Enabling Hardware-Accelerated GPU Scheduling (Requires Reboot)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f > nul
echo HAGS setting applied (Reboot needed).
timeout /t 1 /nobreak > nul

REM echo Disabling Game DVR / Game Bar features...
REM reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f > nul
REM reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f > nul
REM echo Game DVR / Game Bar features disabled.
REM timeout /t 1 /nobreak > nul

REM --- Section 3: Privacy & Telemetry Settings ---
echo.
echo --- Section 3: Adjusting Privacy & Telemetry Settings ---
timeout /t 1 /nobreak > nul

echo Disabling Telemetry Service (DiagTrack)...
sc stop "DiagTrack" > nul 2>&1
sc config "DiagTrack" start= disabled > nul 2>&1
echo Telemetry Service (DiagTrack) status set to Disabled.
timeout /t 1 /nobreak > nul

echo Setting Telemetry level to Basic (Security)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > nul
echo Telemetry level set.
timeout /t 1 /nobreak > nul

echo Disabling Advertising ID for current user...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f > nul
echo Advertising ID disabled.
timeout /t 1 /nobreak > nul

echo Disabling Suggested Content / Tips...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f > nul
echo Suggested content disabled.
timeout /t 1 /nobreak > nul

REM --- Section 4: System Cleanup ---
echo.
echo --- Section 4: Performing System Cleanup ---
timeout /t 1 /nobreak > nul

echo Clearing Temporary Files (User & System)...
if exist "%TEMP%\*" del /f /s /q "%TEMP%\*.*" > nul 2>&1
if exist "C:\Windows\Temp\*" del /f /s /q "C:\Windows\Temp\*.*" > nul 2>&1
echo Temporary files clearing attempted.
timeout /t 1 /nobreak > nul

REM echo Clearing Windows Update cache (SoftwareDistribution\Download)...
REM echo Stopping Update services...
REM net stop wuauserv /y > nul 2>&1
REM net stop bits /y > nul 2>&1
REM echo Removing cache files...
REM if exist "C:\Windows\SoftwareDistribution\Download\*" (
REM     takeown /f "C:\Windows\SoftwareDistribution\Download" /r /d y > nul 2>&1
REM     icacls "C:\Windows\SoftwareDistribution\Download" /grant administrators:F /t > nul 2>&1
REM     del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" > nul 2>&1
REM     rd /s /q "C:\Windows\SoftwareDistribution\Download" > nul 2>&1
REM )
REM echo Starting Update services...
REM net start wuauserv > nul 2>&1
REM net start bits > nul 2>&1
REM echo Windows Update cache cleared.
REM timeout /t 1 /nobreak > nul

REM echo Starting Disk Cleanup (cleanmgr) automation...
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 2 /f > nul
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0001 /t REG_DWORD /d 2 /f > nul
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0001 /t REG_DWORD /d 2 /f > nul
REM REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnails" /v StateFlags0001 /t REG_DWORD /d 2 /f > nul
REM cleanmgr.exe /sagerun:1
REM echo Disk Cleanup automation initiated (runs in background).
REM timeout /t 1 /nobreak > nul

REM --- Section 5: File Explorer Tweaks ---
echo.
echo --- Section 5: Applying File Explorer Tweaks ---
timeout /t 1 /nobreak > nul

echo Enabling 'Show File Extensions'...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f > nul
echo 'Show File Extensions' enabled.
timeout /t 1 /nobreak > nul

echo Enabling 'Show Hidden Files, Folders, and Drives'...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f > nul
echo 'Show Hidden Files' enabled.
timeout /t 1 /nobreak > nul

echo Setting Explorer to open to 'This PC'...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f > nul
echo Explorer default view set to 'This PC'.
timeout /t 1 /nobreak > nul

REM echo Enabling Windows 10 style context menu (Requires Explorer restart/Reboot)...
REM reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f > nul
REM echo Windows 10 context menu enabled (Restart Explorer or Reboot).
REM timeout /t 1 /nobreak > nul

REM --- Section 6: Disable Optional/Unnecessary Services (Use with EXTREME CAUTION) ---
echo.
echo --- Section 6: Optional Service Disabling (Use with CAUTION - Currently Disabled) ---
timeout /t 1 /nobreak > nul

REM echo Disabling Fax Service...
REM sc stop "Fax" > nul 2>&1
REM sc config "Fax" start= disabled > nul 2>&1
REM echo Fax Service disabled.
REM timeout /t 1 /nobreak > nul

REM echo Disabling Remote Registry Service...
REM sc stop "RemoteRegistry" > nul 2>&1
REM sc config "RemoteRegistry" start= disabled > nul 2>&1
REM echo Remote Registry Service disabled.
REM timeout /t 1 /nobreak > nul

REM echo Disabling Connected Devices Platform Service (CDPSvc)...
REM sc stop "CDPSvc" > nul 2>&1
REM sc config "CDPSvc" start= disabled > nul 2>&1
REM echo Connected Devices Platform Service disabled.
REM timeout /t 1 /nobreak > nul

REM --- Script Completion ---
echo.
echo ==================================================
echo AIO Windows 11 Optimization Script Completed!
echo ==================================================
echo.
echo Some changes require a RESTART to take full effect (e.g., HAGS, context menu).
echo Remember to perform manual steps (BIOS/UEFI checks, Driver installs).
echo UWP App removal needs PowerShell or other tools.
echo.

REM Optional: Restart Explorer
REM echo Restarting Explorer process...
REM taskkill /f /im explorer.exe > nul
REM timeout /t 3 /nobreak > nul
REM start explorer.exe

echo Script finished. Press any key to exit.
pause > nul

:EOF
endlocal
exit /b
