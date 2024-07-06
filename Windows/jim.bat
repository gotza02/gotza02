@echo off
setlocal enabledelayedexpansion

:: Run as administrator
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:: Create a restore point
echo Creating system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Extreme Optimization", 100, 7

:: Update drivers
echo Updating drivers...
pnputil /add-driver "%WINDIR%\INF\*.inf" /subdirs /install
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

:: Prepare for Windows 11 upgrade (if possible)
echo Preparing for Windows 11 upgrade...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v AllowOSUpgrade /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" /v ReservationsAllowed /t REG_DWORD /d 1 /f

:: Extreme performance optimizations
echo Optimizing for maximum performance...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 88888888-8888-8888-8888-888888888888
powercfg -setactive 88888888-8888-8888-8888-888888888888
powercfg -changename 88888888-8888-8888-8888-888888888888 "Extreme Performance" "Custom power plan for maximum performance"
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 sub_processor PERFEPP 0
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 SUB_VIDEO VIDEOADAPT 0
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 SUB_VIDEO VIDEOCONLOCK 0

:: Disable unnecessary services and features
echo Disabling unnecessary services and features...
for %%s in (DiagTrack dmwappushservice RetailDemo wuauserv SysMain) do (
    sc config "%%s" start= disabled
    sc stop "%%s"
)
dism /online /disable-feature /featurename:WindowsMediaPlayer /norestart
dism /online /disable-feature /featurename:PrintingWin32 /norestart
dism /online /disable-feature /featurename:Printing-PrintToPDFServices-Features /norestart

:: Advanced registry tweaks
echo Applying advanced registry tweaks...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 983040 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DisableExceptionChainValidation /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v EnableCfg /t REG_DWORD /d 0 /f

:: NVIDIA GPU optimizations
echo Optimizing NVIDIA GPU settings...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 20 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDdiDelay /t REG_DWORD /d 20 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PerfLevelSrc /t REG_DWORD /d 2222 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PowerMizerEnable /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PowerMizerLevel /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v PowerMizerLevelAC /t REG_DWORD /d 1 /f

:: Pagefile optimization
echo Optimizing pagefile...
wmic computersystem set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=8192,MaximumSize=16384

:: System cleanup and optimization
echo Performing system cleanup and optimization...
cleanmgr /sagerun:1
defrag C: /O /U /V
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

:: Disable Windows telemetry and data collection
echo Enhancing privacy settings...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f

:: Network optimization
echo Optimizing network settings...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
netsh interface tcp set heuristics disabled
netsh interface tcp set global rss=enabled
netsh interface tcp set global maxsynretransmissions=2
netsh interface tcp set global fastopen=enabled
netsh advfirewall firewall add rule name="latency optimization for outbound" dir=out action=allow protocol=udp remoteport=27015-27030,27036-27037
netsh advfirewall firewall add rule name="latency optimization for inbound" dir=in action=allow protocol=udp remoteport=27015-27030,27036-27037

:: CPU Optimization (Note: Overclocking requires BIOS support and may not be applicable)
echo Optimizing CPU settings...
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex 88888888-8888-8888-8888-888888888888 SUB_PROCESSOR PROCTHROTTLEMAX 100
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMax /t REG_DWORD /d 100 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v ValueMin /t REG_DWORD /d 100 /f

:: GPU Optimization (Note: Overclocking requires compatible software and may not be applicable)
echo Optimizing GPU settings...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v KMD_EnableComputePreemption /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" /v DisableDrmdmaPowerGating /t REG_DWORD /d 1 /f

:: RAM Optimization
echo Optimizing RAM usage...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f

:: SSD Optimization (if applicable)
echo Optimizing for SSD (if present)...
fsutil behavior set disabledeletenotify 0
powercfg -setactive 88888888-8888-8888-8888-888888888888

:: Disable Windows Search Indexing
echo Disabling Windows Search Indexing...
sc config WSearch start= disabled
net stop WSearch

:: Disable Superfetch
echo Disabling Superfetch...
sc config SysMain start= disabled
net stop SysMain

:: Update Windows
echo Updating Windows...
wuauclt /detectnow /updatenow

echo Script execution completed. Please restart your computer for changes to take effect.
echo WARNING: Some changes may cause system instability. Use at your own risk.
pause
