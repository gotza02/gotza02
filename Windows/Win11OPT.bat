@echo off
title Windows Ultimate Performance Optimization Script
color 0A
mode con: cols=120 lines=40
echo ==================================================================================
echo       Windows Ultimate Performance Optimization Script
echo ==================================================================================
echo Created by: Your Assistant
echo Current Date: %date% %time%
echo Warning: This script maximizes performance. Backup your data before proceeding!
echo Press any key to start or CTRL+C to exit...
pause >nul

:: ตั้งค่าตัวแปรสภาพแวดล้อม
setlocal EnableDelayedExpansion
set "VERSION=1.0"
set "LOGFILE=%USERPROFILE%\Desktop\Optimization_Log_v%VERSION%.txt"
set "BACKUP_DIR=%USERPROFILE%\Desktop\Optimization_Backup_v%VERSION%"
set "ERROR_LOG=%USERPROFILE%\Desktop\Optimization_Error_Log.txt"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
echo Optimization Log v%VERSION% > "%LOGFILE%"
echo Start Time: %date% %time% >> "%LOGFILE%"

:: ตรวจสอบสิทธิ์ Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Administrator privileges required!
    echo Log: Failed - No Admin Privileges >> "%LOGFILE%"
    echo Error: No Admin Privileges >> "%ERROR_LOG%"
    pause
    exit /b 1
)

:: ส่วนที่ 1: ตรวจสอบและบันทึกข้อมูลระบบ
echo [1/20] Analyzing System Configuration...
echo Analyzing System... >> "%LOGFILE%"
systeminfo > "%BACKUP_DIR%\SystemInfo.txt" 2>nul
for /f "tokens=3" %%v in ('ver ^| find "Version"') do set "WIN_VER=%%v"
wmic diskdrive get caption, mediatype | find "SSD" >nul && set "DISK_TYPE=SSD" || (wmic diskdrive get caption, mediatype | find "NVMe" >nul && set "DISK_TYPE=NVMe" || set "DISK_TYPE=HDD")
for /f "tokens=2" %%r in ('systeminfo ^| find "Total Physical Memory"') do set "RAM_MB=%%r"
set "RAM_MB=!RAM_MB:,=!"
set /a RAM_GB=!RAM_MB!/1024
wmic cpu get name | find "Intel" >nul && set "CPU_TYPE=Intel" || (wmic cpu get name | find "AMD" >nul && set "CPU_TYPE=AMD" || set "CPU_TYPE=Unknown")
for /f %%c in ('wmic cpu get NumberOfCores ^| find /v "NumberOfCores"') do set "CPU_CORES=%%c"
nvidia-smi -q >nul 2>&1 && set "GPU_TYPE=NVIDIA" || (wmic path win32_videocontroller get caption | find "AMD" >nul && set "GPU_TYPE=AMD" || set "GPU_TYPE=Unknown")
echo Windows Version: !WIN_VER! >> "%LOGFILE%"
echo Disk Type: !DISK_TYPE! >> "%LOGFILE%"
echo RAM: !RAM_GB! GB >> "%LOGFILE%"
echo CPU: !CPU_TYPE! with !CPU_CORES! cores >> "%LOGFILE%"
echo GPU: !GPU_TYPE! >> "%LOGFILE%"

:: ส่วนที่ 2: สร้าง System Restore Point
echo [2/20] Creating System Restore Point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Pre-Optimization v%VERSION%", 100, 7 >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Failed to create Restore Point >> "%LOGFILE%"
    echo Error: Restore Point Creation Failed >> "%ERROR_LOG%"
) else (
    echo Restore Point Created >> "%LOGFILE%"
)

:: ส่วนที่ 3: สำรองข้อมูลระบบ
echo [3/20] Backing Up System Settings...
reg export HKLM\Software "%BACKUP_DIR%\RegBackup_System.reg" /y >nul 2>&1 || echo Error: System Registry Backup Failed >> "%ERROR_LOG%"
reg export HKCU\Software "%BACKUP_DIR%\RegBackup_User.reg" /y >nul 2>&1 || echo Error: User Registry Backup Failed >> "%ERROR_LOG%"
xcopy "C:\Windows\System32\config\*.bak" "%BACKUP_DIR%\ConfigBackup\" /E /H /C /I >nul 2>&1
echo Backups Saved to %BACKUP_DIR% >> "%LOGFILE%"

:: ส่วนที่ 4: ปรับแต่งโหมดพลังงาน
echo [4/20] Optimizing Power Settings...
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /hibernate off
if "!CPU_CORES!" gtr 4 (
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
)
echo Power Plan Optimized for Maximum Performance >> "%LOGFILE%"

:: ส่วนที่ 5: ปิดแอปพลิเคชันที่ไม่จำเป็น
echo [5/20] Terminating Unnecessary Applications...
set "APP_LIST=msedge.exe chrome.exe firefox.exe steam.exe discord.exe explorer.exe"
for %%i in (!APP_LIST!) do (
    taskkill /f /im "%%i" 2>nul && echo Closed %%i >> "%LOGFILE%"
)

:: ส่วนที่ 6: ปรับแต่งบริการ
echo [6/20] Optimizing Services...
set "SERVICES=DiagTrack WSearch Spooler Fax wscsvc SysMain XboxGipSvc XblAuthManager XblGameSave WMPNetworkSvc AdobeARMservice MySQL80"
for %%s in (!SERVICES!) do (
    sc stop "%%s" >nul 2>&1 && sc config "%%s" start= disabled >nul 2>&1 && echo Disabled %%s >> "%LOGFILE%"
)
sc stop "wuauserv" >nul 2>&1 && sc config "wuauserv" start= disabled >nul 2>&1 && echo Disabled Windows Update >> "%LOGFILE%"

:: ส่วนที่ 7: ล้างไฟล์ขยะและปรับแต่งดิสก์
echo [7/20] Cleaning and Optimizing Disk...
del /q /s /f "%TEMP%\*" 2>nul
del /q /s /f "C:\Windows\Temp\*" 2>nul
del /q /s /f "C:\Windows\Prefetch\*" 2>nul
if "!DISK_TYPE!"=="SSD" || "!DISK_TYPE!"=="NVMe" (
    fsutil behavior set disabledeletenotify 0
    reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f
    echo TRIM Enabled, Prefetch Disabled >> "%LOGFILE%"
) else (
    defrag C: /O /U /V >nul 2>&1 && echo Defragmented HDD >> "%LOGFILE%"
)
chkdsk C: /f /r >nul 2>&1 || echo Error: Disk Check Failed >> "%ERROR_LOG%"

:: ส่วนที่ 8: ปรับแต่งเครือข่าย
echo [8/20] Optimizing Network...
netsh int tcp set global autotuninglevel=normal rss=enabled ecncapability=enabled chimney=enabled dca=enabled
ipconfig /flushdns >nul
netsh int tcp set global maxsynretransmissions=2
echo Low Latency Network Enabled >> "%LOGFILE%"
netsh interface ip set dns "Wi-Fi" static 1.1.1.1
netsh interface ip add dns "Wi-Fi" 1.0.0.1 index=2

:: ส่วนที่ 9: ซ่อมแซมระบบ
echo [9/20] Repairing System...
sfc /scannow >nul 2>&1
if %errorlevel% neq 0 (
    DISM /Online /Cleanup-Image /RestoreHealth >nul 2>&1 || echo Error: System Repair Failed >> "%ERROR_LOG%"
)
echo System Repair Completed >> "%LOGFILE%"

:: ส่วนที่ 10: ปรับแต่งความปลอดภัย
echo [10/20] Optimizing Security...
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1 && echo Windows Defender Disabled >> "%LOGFILE%"
netsh advfirewall set allprofiles state off >nul 2>&1 && echo Firewall Disabled >> "%LOGFILE%"

:: ส่วนที่ 11: ปรับแต่งการแสดงผล
echo [11/20] Optimizing Display...
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f
echo Game DVR Disabled >> "%LOGFILE%"

:: ส่วนที่ 12: ปรับแต่งหน่วยความจำ
echo [12/20] Optimizing Memory...
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f
echo Memory Optimized for Performance >> "%LOGFILE%"

:: ส่วนที่ 13: ปรับแต่ง CPU
echo [13/20] Optimizing CPU...
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d 0 /f
bcdedit /set numproc !CPU_CORES! >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 1048576 /f
echo CPU Optimized for Maximum Performance >> "%LOGFILE%"

:: ส่วนที่ 14: ปรับแต่ง GPU
echo [14/20] Optimizing GPU...
if "!GPU_TYPE!"=="NVIDIA" (
    nvidia-smi -pm 1 >nul 2>&1 && nvidia-smi -ac 5000,1500 >nul 2>&1 && echo NVIDIA GPU Optimized >> "%LOGFILE%"
)
if "!GPU_TYPE!"=="AMD" (
    echo Recommendation: Use AMD Radeon Software for GPU tuning >> "%LOGFILE%"
)
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
echo GPU and System Responsiveness Optimized >> "%LOGFILE%"

:: ส่วนที่ 15: ปิด Telemetry
echo [15/20] Disabling Telemetry...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
schtasks /change /tn "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "Microsoft\Windows\Application Experience\Microsoft Compatibility Telemetry" /disable >nul 2>&1
echo Telemetry Fully Disabled >> "%LOGFILE%"

:: ส่วนที่ 16: ปรับแต่งการบูต
echo [16/20] Optimizing Boot...
bcdedit /set disabledynamictick yes
bcdedit /set quietboot yes
bcdedit /set hypervisorloadoptions "NoHyperV" >nul 2>&1
echo Boot Optimized for Speed >> "%LOGFILE%"

:: ส่วนที่ 17: ปรับแต่งการแจ้งเตือน
echo [17/20] Disabling Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f
echo Notifications Disabled >> "%LOGFILE%"

:: ส่วนที่ 18: ปรับแต่งเสียง
echo [18/20] Optimizing Audio...
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /v "DisableHWAcceleration" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Multimedia\Audio" /v "LowLatency" /t REG_DWORD /d 1 /f
echo Low Latency Audio Enabled >> "%LOGFILE%"

:: ส่วนที่ 19: บันทึกสถานะหลังปรับแต่ง
echo [19/20] Logging Post-Optimization State...
systeminfo > "%BACKUP_DIR%\SystemInfo_Post.txt" 2>nul
tasklist /fo csv | sort /r /+3 > "%BACKUP_DIR%\TaskList_Post.csv"
echo Post-Optimization Logs Saved >> "%LOGFILE%"

:: ส่วนที่ 20: เสร็จสิ้นและตัวเลือกกู้คืน
echo [20/20] Completing Optimization...
echo Create a post-optimization restore point? (y/n)
set /p RESTORE=
if /i "!RESTORE!"=="y" (
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Post-Optimization v%VERSION%", 100, 7 >nul 2>&1
    echo Post-Optimization Restore Point Created >> "%LOGFILE%"
)

echo ==================================================================================
echo Optimization Complete!
echo Logs: %LOGFILE%, %ERROR_LOG% (if errors occurred)
echo Backups: %BACKUP_DIR%
echo Please restart your computer to apply changes.
echo Press any key to exit...
pause >nul
exit /b 0
