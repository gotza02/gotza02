@echo off
setlocal enabledelayedexpansion
title Windows 11 Ultimate Optimization and Update Script

:: Ensure administrative privileges
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Create a restore point
echo Creating a system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Windows Optimization", 100, 7

:: Enable all performance optimizations
echo Enabling advanced performance optimizations...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0

:: Disable unnecessary services and features
echo Disabling unnecessary services and features...
for %%s in (DiagTrack dmwappushservice MapsBroker TrkWks WbioSrvc) do (
    sc config %%s start= disabled
    sc stop %%s
)
dism /online /disable-feature /featurename:WindowsMediaPlayer /norestart
dism /online /disable-feature /featurename:PrintingWiFiDirect /norestart
dism /online /disable-feature /featurename:Printing-XPSServices-Features /norestart

:: Configure Windows Update settings
echo Configuring Windows Update settings...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallTime" /t REG_DWORD /d 3 /f

:: Check for updates
echo Checking for Windows updates...
powershell -ExecutionPolicy Bypass -Command "Install-Module -Name PSWindowsUpdate -Force -AllowClobber; Get-WindowsUpdate -AcceptAll -Install -AutoReboot | Out-File $env:TEMP\WindowsUpdateLog.txt -Append"

:: Optimize registry settings
echo Optimizing registry settings...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheTtl" /t REG_DWORD /d 86400 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AlwaysUnloadDLL" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f

:: Disable unnecessary visual effects
echo Disabling unnecessary visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012078010000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f

:: Clean up system files
echo Cleaning up system files...
cleanmgr /sagerun:1 /verylowdisk

:: Optimize drives
echo Optimizing drives...
defrag /C /O /U /V

:: Check for latest or beta updates
echo Checking for latest or beta updates...
powershell -ExecutionPolicy Bypass -Command "Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -Install -IgnoreReboot | Out-File $env:TEMP\WindowsUpdateLog.txt -Append"

:: Update Microsoft Store apps
echo Updating Microsoft Store apps...
powershell -ExecutionPolicy Bypass -Command "Get-CimInstance -Namespace Root/CIMV2/mdm/dmmap -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 | Invoke-CimMethod -MethodName UpdateScanMethod"

:: Optimize network settings
echo Optimizing network settings...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled

:: Disable telemetry
echo Disabling telemetry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disable Cortana
echo Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f

:: Optimize SSD if present
echo Checking for SSD and optimizing if found...
for /f "tokens=*" %%i in ('wmic diskdrive get interfacetype ^| findstr /i "SSD"') do (
    fsutil behavior set DisableLastAccess 1
    fsutil behavior set EncryptPagingFile 0
)

:: Restart Windows Explorer
echo Restarting Windows Explorer...
taskkill /F /IM explorer.exe
start explorer.exe

echo Script completed. It is recommended to restart your computer for all changes to take effect.
echo Update logs can be found at %TEMP%\WindowsUpdateLog.txt
pause
