@echo off
setlocal enabledelayedexpansion

:: Function declarations
call :initialize
call :main_menu

:end
echo Exiting the Windows 11 Utility Tool...
pause
exit

:initialize
cls
echo =============================================
echo            Initializing Windows 11 Utility Tool
echo =============================================
:: Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This tool requires administrator privileges. Please run as administrator.
    pause
    exit
)
:: Create a log file
set LOGFILE=%~dp0utility_tool.log
echo Windows 11 Utility Tool Log > %LOGFILE%
echo Initialized on %date% at %time% >> %LOGFILE%
goto :eof

:main_menu
cls
echo =============================================
echo            Windows 11 Utility Tool
echo =============================================
echo 1. Disk Management
echo 2. RAM Optimization
echo 3. Internet Optimization
echo 4. Toggle Dark Mode / Light Mode
echo 5. System Configuration
echo 6. CPU Optimization and Power Management
echo 7. Animation Optimization
echo 8. Antivirus Management
echo 9. Windows Update Control
echo 10. System Status Check
echo 11. Advanced System Cleaning
echo 12. Backup and Restore
echo 13. Driver Management
echo 14. User Account Management
echo 15. Scheduled Task Management
echo 16. Service Management
echo 17. Network Diagnostics
echo 18. Security Settings
echo 19. Software Inventory
echo 20. Hardware Inventory
echo 0. Exit
echo =============================================
set /p choice="Enter your choice: "

if %choice%==1 call :disk_management
if %choice%==2 call :ram_optimization
if %choice%==3 call :internet_optimization
if %choice%==4 call :toggle_mode
if %choice%==5 call :system_configuration
if %choice%==6 call :cpu_optimization
if %choice%==7 call :animation_optimization
if %choice%==8 call :antivirus_management
if %choice%==9 call :windows_update_control
if %choice%==10 call :system_status_check
if %choice%==11 call :advanced_system_cleaning
if %choice%==12 call :backup_and_restore
if %choice%==13 call :driver_management
if %choice%==14 call :user_account_management
if %choice%==15 call :scheduled_task_management
if %choice%==16 call :service_management
if %choice%==17 call :network_diagnostics
if %choice%==18 call :security_settings
if %choice%==19 call :software_inventory
if %choice%==20 call :hardware_inventory
if %choice%==0 goto :end

goto :main_menu

:disk_management
cls
echo =============================================
echo            Disk Management
echo =============================================
echo Running Disk Cleanup...
echo Disk Management started on %date% at %time% >> %LOGFILE%

:: Run Disk Cleanup
powershell -command "Start-Process cleanmgr -ArgumentList '/sagerun:1' -NoNewWindow -Wait"

:: Disk Defragmentation
echo Defragmenting Disk...
powershell -command "Optimize-Volume -DriveLetter C -Defrag -Verbose"

:: Check Disk and repair
echo Checking Disk...
powershell -command "Repair-Volume -DriveLetter C -OfflineScanAndFix"

:: Check Disk Health and Usage
echo Checking Disk Health and Usage...
powershell -command "
$disk = Get-PhysicalDisk | Where-Object OperationalStatus -eq 'OK'
$disk | Select-Object -Property DeviceId, MediaType, OperationalStatus, HealthStatus, Size, AllocatedSize
Get-Volume | Select-Object -Property DriveLetter, FileSystemLabel, FileSystemType, SizeRemaining, Size
Get-Partition | Select-Object -Property DiskNumber, PartitionNumber, DriveLetter, Size, Type"

:: Check Disk Space
echo Checking Disk Space...
powershell -command "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='Used (GB)';Expression={[math]::round($_.Used/1GB,2)}}, @{Name='Free (GB)';Expression={[math]::round($_.Free/1GB,2)}}"

:: Log completion status
if %errorlevel% neq 0 (
    echo Disk Management encountered an error.
    echo Disk Management error on %date% at %time% >> %LOGFILE%
) else (
    echo Disk Management completed.
    echo Disk Management completed on %date% at %time% >> %LOGFILE%
)

pause
goto :main_menu


:ram_optimization
cls
echo =============================================
echo            RAM Optimization
echo =============================================
echo Optimizing RAM...
echo RAM Optimization started on %date% at %time% >> %LOGFILE%
:: Clear memory cache
powershell -command "Remove-Item -Path C:\Windows\Temp\* -Recurse -Force"
:: Increase virtual memory
powershell -command "
$sysInfo = Get-WmiObject -Class Win32_ComputerSystem
$mem = $sysInfo.TotalPhysicalMemory / 1MB
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name='C:\pagefile.sys'; InitialSize=$mem; MaximumSize=$mem*1.5}"
if %errorlevel% neq 0 (
    echo RAM Optimization encountered an error.
    echo RAM Optimization error on %date% at %time% >> %LOGFILE%
) else (
    echo RAM Optimization completed.
    echo RAM Optimization completed on %date% at %time% >> %LOGFILE%
)
:: Additional RAM optimization tasks
echo Performing additional RAM optimization tasks...
powershell -command "Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 -Property ProcessName, WorkingSet"
pause
goto :main_menu

:internet_optimization
cls
echo =============================================
echo            Internet Optimization
echo =============================================
echo Optimizing Internet settings...
echo Internet Optimization started on %date% at %time% >> %LOGFILE%

:: Reset TCP/IP stack
echo Resetting TCP/IP stack...
netsh int ip reset

:: Reset Winsock
echo Resetting Winsock...
netsh winsock reset

:: Flush DNS
echo Flushing DNS...
ipconfig /flushdns

:: Set TCP Window Autotuning
echo Setting TCP Window Autotuning...
netsh interface tcp set global autotuninglevel=normal

:: Disable TCP Chimney Offload
echo Disabling TCP Chimney Offload...
netsh int tcp set global chimney=disabled

:: Enable DNS Devolution
echo Enabling DNS Devolution...
netsh int ipv4 set global devolution=enabled

:: Increase network performance
echo Increasing network performance...
netsh interface tcp set global rss=enabled
netsh interface tcp set global autotuninglevel=highlyrestricted

:: Check Internet speed (optional)
echo Checking Internet speed...
powershell -command "Invoke-WebRequest -Uri 'http://www.google.com' -Method Get"

if %errorlevel% neq 0 (
    echo Internet Optimization encountered an error.
    echo Internet Optimization error on %date% at %time% >> %LOGFILE%
) else (
    echo Internet Optimization completed.
    echo Internet Optimization completed on %date% at %time% >> %LOGFILE%
)

:: Additional internet optimization tasks
echo Performing additional Internet optimization tasks...
powershell -command "Test-NetConnection"

pause
goto :main_menu

:toggle_mode
cls
echo =============================================
echo            Toggle Dark Mode / Light Mode
echo =============================================
echo Toggling Dark/Light Mode...
echo Toggle Mode started on %date% at %time% >> %LOGFILE%

:: Check current mode
for /f "tokens=3" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme') do set CurrentTheme=%%A

:: Toggle between modes
if %CurrentTheme%==0x0 (
    echo Switching to Light Mode...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
    echo Switched to Light Mode.
    echo Switched to Light Mode on %date% at %time% >> %LOGFILE%
) else (
    echo Switching to Dark Mode...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    echo Switched to Dark Mode.
    echo Switched to Dark Mode on %date% at %time% >> %LOGFILE%
)

if %errorlevel% neq 0 (
    echo Toggle Mode encountered an error.
    echo Toggle Mode error on %date% at %time% >> %LOGFILE%
) else (
    echo Toggle Mode completed on %date% at %time% >> %LOGFILE%
)

pause
goto :main_menu


:system_configuration
cls
echo =============================================
echo            System Configuration
echo =============================================
echo Configuring System Settings...
echo System Configuration started on %date% at %time% >> %LOGFILE%

:: Adjust visual effects for best performance
echo Adjusting visual effects for best performance...
powershell -command "
$performanceOptions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
Set-ItemProperty -Path $performanceOptions -Name VisualFXSetting -Value 2
$regPath = 'HKCU:\Control Panel\Desktop'
Set-ItemProperty -Path $regPath -Name AutoEndTasks -Value 1
Set-ItemProperty -Path $regPath -Name WaitToKillAppTimeout -Value 2000
Set-ItemProperty -Path $regPath -Name HungAppTimeout -Value 2000"

:: Configure startup programs
echo Configuring startup programs...
powershell -command "
$startup = Get-CimInstance -ClassName Win32_StartupCommand
$startup | Select-Object Name, Command, Location"

:: Disable unnecessary startup programs
echo Disabling unnecessary startup programs...
powershell -command "
$startup = Get-CimInstance -Class Win32_StartupCommand
$unnecessaryPrograms = $startup | Where-Object { $_.Name -like '*OneDrive*' -or $_.Name -like '*Skype*' }
foreach ($program in $unnecessaryPrograms) {
    Remove-Item -Path $program.Command -Force
}"

:: Disable hibernation to save disk space
echo Disabling hibernation...
powercfg /hibernate off

:: Optimize paging file
echo Optimizing paging file...
powershell -command "
$sysInfo = Get-WmiObject -Class Win32_ComputerSystem
$mem = $sysInfo.TotalPhysicalMemory / 1MB
Set-WmiInstance -Class Win32_PageFileSetting -Arguments @{Name='C:\pagefile.sys'; InitialSize=$mem; MaximumSize=$mem*1.5}"

:: Configure system restore settings
echo Configuring system restore settings...
powershell -command "
$drive = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 10GB }
Enable-ComputerRestore -Drive $drive.Name
vssadmin resize shadowstorage /for=$drive.Name /on=$drive.Name /maxsize=15%"

if %errorlevel% neq 0 (
    echo System Configuration encountered an error.
    echo System Configuration error on %date% at %time% >> %LOGFILE%
) else (
    echo System Configuration completed.
    echo System Configuration completed on %date% at %time% >> %LOGFILE%
)

:: Additional system configuration tasks
echo Performing additional system configuration tasks...
powershell -command "Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 -Property ProcessName, CPU"

:: Ensure the screen stays on
echo Preventing screen from turning off...
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0

:: Wait for 5 seconds to ensure all commands complete
timeout /t 5 /nobreak >nul

pause
goto :main_menu



:cpu_optimization
cls
echo =============================================
echo            CPU Optimization and Power Management
echo =============================================
echo 1. Max Speed and Performance
echo 2. Power Save Mode
echo 0. Return to Main Menu
echo =============================================
set /p cpu_choice="Enter your choice: "

if %cpu_choice%==1 goto :max_performance
if %cpu_choice%==2 goto :power_save
if %cpu_choice%==0 goto :main_menu

goto :cpu_optimization

:max_performance
cls
echo =============================================
echo            Max Speed and Performance
echo =============================================
echo Setting Max Speed and Performance...
echo CPU Optimization for Max Speed started on %date% at %time% >> %LOGFILE%

:: Set power management settings for maximum performance
echo Setting power management settings for maximum performance...
powercfg -setactive SCHEME_MIN
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setdcvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setdcvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PERFINCTHRESHOLD 100
powercfg -setdcvalueindex SCHEME_MIN SUB_PROCESSOR PERFINCTHRESHOLD 100

:: Disable CPU idle states for performance
echo Disabling CPU idle states...
bcdedit /set disabledynamictick yes
bcdedit /set useplatformclock true

:: Configure power options for CPU performance
echo Configuring power options for CPU performance...
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

:: Adjust CPU frequency
echo Adjusting CPU frequency...
powershell -command "
$processors = Get-WmiObject -Class Win32_Processor
foreach ($processor in $processors) {
    $processor.MaxClockSpeed = $processor.CurrentClockSpeed
    Set-WmiInstance -InputObject $processor
}"

:: Set refresh rate to maximum supported
echo Setting refresh rate to maximum supported...
powershell -command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DisplayConfig {
    [DllImport(""User32.dll"")]
    public static extern int SetDisplayConfig(
        uint numPathArrayElements,
        IntPtr pathArray,
        uint numModeInfoArrayElements,
        IntPtr modeInfoArray,
        uint flags
    );
}
'@
$maxRefreshRate = (Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedModes | Select-Object -ExpandProperty RefreshRate).Max()
$targetRefreshRate = if ($maxRefreshRate -ge 240) { 240 } else { $maxRefreshRate }
$success = $false
try {
    Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedModes | Where-Object { $_.RefreshRate -eq $targetRefreshRate } | ForEach-Object { $_.WmiSetDisplayMode() }
    $success = $true
} catch {
    $success = $false
}

if (-not $success) {
    $targetRefreshRate = [math]::Floor($maxRefreshRate / 2)
    Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedModes | Where-Object { $_.RefreshRate -eq $targetRefreshRate } | ForEach-Object { $_.WmiSetDisplayMode() }
}
"

:: Log completion status
if %errorlevel% neq 0 (
    echo CPU Optimization encountered an error.
    echo CPU Optimization error on %date% at %time% >> %LOGFILE%
) else (
    echo CPU and Power Optimization for Max Speed completed.
    echo CPU Optimization for Max Speed completed on %date% at %time% >> %LOGFILE%
)

:: Additional CPU optimization tasks
echo Performing additional CPU optimization tasks...
powershell -command "Get-WmiObject -Class Win32_Processor | Select-Object Name, LoadPercentage, CurrentClockSpeed"

pause
goto :main_menu

:power_save
cls
echo =============================================
echo            Power Save Mode
echo =============================================
echo Setting Power Save Mode...
echo CPU Optimization for Power Save started on %date% at %time% >> %LOGFILE%

:: Set power management settings for power saving
echo Setting power management settings for power saving...
powercfg -setactive SCHEME_BALANCED
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMAX 50
powercfg -setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMAX 50
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PROCTHROTTLEMIN 5
powercfg -setacvalueindex SCHEME_BALANCED SUB_PROCESSOR PERFINCTHRESHOLD 20
powercfg -setdcvalueindex SCHEME_BALANCED SUB_PROCESSOR PERFINCTHRESHOLD 20

:: Enable CPU idle states for power saving
echo Enabling CPU idle states...
bcdedit /set disabledynamictick no
bcdedit /set useplatformclock false

:: Configure power options for CPU power saving
echo Configuring power options for CPU power saving...
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 5
powercfg /change disk-timeout-ac 20
powercfg /change disk-timeout-dc 10
powercfg /change standby-timeout-ac 30
powercfg /change standby-timeout-dc 15

:: Set refresh rate to half of maximum supported
echo Setting refresh rate to half of maximum supported...
powershell -command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class DisplayConfig {
    [DllImport(""User32.dll"")]
    public static extern int SetDisplayConfig(
        uint numPathArrayElements,
        IntPtr pathArray,
        uint numModeInfoArrayElements,
        IntPtr modeInfoArray,
        uint flags
    );
}
'@
$maxRefreshRate = (Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedModes | Select-Object -ExpandProperty RefreshRate).Max()
$targetRefreshRate = [math]::Floor($maxRefreshRate / 2)
Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorListedModes | Where-Object { $_.RefreshRate -eq $targetRefreshRate } | ForEach-Object { $_.WmiSetDisplayMode() }
"

:: Log completion status
if %errorlevel% neq 0 (
    echo CPU Optimization encountered an error.
    echo CPU Optimization error on %date% at %time% >> %LOGFILE%
) else (
    echo CPU and Power Optimization for Power Save completed.
    echo CPU Optimization for Power Save completed on %date% at %time% >> %LOGFILE%
)

:: Additional CPU power save tasks
echo Performing additional CPU power save tasks...
powershell -command "Get-WmiObject -Class Win32_Processor | Select-Object Name, LoadPercentage, CurrentClockSpeed"

pause
goto :main_menu




:animation_optimization
cls
echo =============================================
echo            Animation Optimization
echo =============================================
echo Optimizing Animations...
echo Animation Optimization started on %date% at %time% >> %LOGFILE%
powershell -command "
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MinAnimate' -Value 0
Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MenuShowDelay' -Value 20"
if %errorlevel% neq 0 (
    echo Animation Optimization encountered an error.
    echo Animation Optimization error on %date% at %time% >> %LOGFILE%
) else (
    echo Animation Optimization completed.
    echo Animation Optimization completed on %date% at %time% >> %LOGFILE%
)
:: Additional animation optimization tasks
echo Performing additional animation optimization tasks...
powershell -command "Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'MinAnimate', 'MenuShowDelay'"
pause
goto :main_menu

:antivirus_management
cls
echo =============================================
echo            Antivirus Management
echo =============================================
echo Managing Antivirus...
echo Antivirus Management started on %date% at %time% >> %LOGFILE%
set /p av_choice="Enter 'enable' to enable or 'disable' to disable Windows Defender: "

if %av_choice%==enable (
    echo Enabling Windows Defender...
    powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false"
    powershell -command "Set-MpPreference -DisableBehaviorMonitoring $false"
    powershell -command "Set-MpPreference -DisableBlockAtFirstSeen $false"
    powershell -command "Set-MpPreference -DisableIOAVProtection $false"
    powershell -command "Set-MpPreference -DisablePrivacyMode $false"
    powershell -command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $false"
    powershell -command "Set-MpPreference -DisableArchiveScanning $false"
    powershell -command "Set-MpPreference -DisableIntrusionPreventionSystem $false"
    powershell -command "Set-MpPreference -DisableScriptScanning $false"
    powershell -command "Set-MpPreference -SubmitSamplesConsent 1"
    powershell -command "Set-MpPreference -MAPSReporting 2"
    powershell -command "Set-MpPreference -HighThreatDefaultAction 0 -ModerateThreatDefaultAction 0 -LowThreatDefaultAction 0 -SevereThreatDefaultAction 0"
    powershell -command "Set-Service -Name windefend -StartupType Automatic"
    powershell -command "Start-Service -Name windefend"
    if %errorlevel% neq 0 (
        echo Antivirus Management encountered an error.
        echo Antivirus Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Windows Defender enabled.
        echo Windows Defender enabled on %date% at %time% >> %LOGFILE%
    )
) else if %av_choice%==disable (
    echo Disabling Windows Defender...
    powershell -command "Set-MpPreference -DisableRealtimeMonitoring $true"
    powershell -command "Set-MpPreference -DisableBehaviorMonitoring $true"
    powershell -command "Set-MpPreference -DisableBlockAtFirstSeen $true"
    powershell -command "Set-MpPreference -DisableIOAVProtection $true"
    powershell -command "Set-MpPreference -DisablePrivacyMode $true"
    powershell -command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true"
    powershell -command "Set-MpPreference -DisableArchiveScanning $true"
    powershell -command "Set-MpPreference -DisableIntrusionPreventionSystem $true"
    powershell -command "Set-MpPreference -DisableScriptScanning $true"
    powershell -command "Set-MpPreference -SubmitSamplesConsent 2"
    powershell -command "Set-MpPreference -MAPSReporting 0"
    powershell -command "Set-MpPreference -HighThreatDefaultAction 6 -ModerateThreatDefaultAction 6 -LowThreatDefaultAction 6 -SevereThreatDefaultAction 6"
    powershell -command "Set-Service -Name windefend -StartupType Disabled"
    powershell -command "Stop-Service -Name windefend"
    if %errorlevel% neq 0 (
        echo Antivirus Management encountered an error.
        echo Antivirus Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Windows Defender disabled.
        echo Windows Defender disabled on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Invalid choice.
    echo Invalid choice on %date% at %time% >> %LOGFILE%
)
:: Update antivirus definitions
powershell -command "Update-MpSignature"
if %errorlevel% neq 0 (
    echo Antivirus Update encountered an error.
    echo Antivirus Update error on %date% at %time% >> %LOGFILE%
) else (
    echo Antivirus Update completed.
    echo Antivirus Update completed on %date% at %time% >> %LOGFILE%
)
:: Additional antivirus management tasks
echo Performing additional antivirus management tasks...
powershell -command "Get-MpComputerStatus"
pause
goto :main_menu


:windows_update_control
cls
echo =============================================
echo            Windows Update Control
echo =============================================
echo Managing Windows Update...
echo Windows Update Control started on %date% at %time% >> %LOGFILE%
set /p wu_choice="Enter 'enable' to enable or 'disable' to disable Windows Update: "

if %wu_choice%==enable (
    echo Enabling Windows Update...
    powershell -command "Start-Service wuauserv"
    powershell -command "Set-Service -Name wuauserv -StartupType Automatic"
    powershell -command "Start-Service bits"
    powershell -command "Set-Service -Name bits -StartupType Automatic"
    powershell -command "Start-Service cryptsvc"
    powershell -command "Set-Service -Name cryptsvc -StartupType Automatic"
    if %errorlevel% neq 0 (
        echo Windows Update Control encountered an error.
        echo Windows Update Control error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Windows Update services enabled.
        echo Windows Update services enabled on %date% at %time% >> %LOGFILE%
    )
) else if %wu_choice%==disable (
    echo Disabling Windows Update...
    powershell -command "Stop-Service wuauserv"
    powershell -command "Set-Service -Name wuauserv -StartupType Disabled"
    powershell -command "Stop-Service bits"
    powershell -command "Set-Service -Name bits -StartupType Disabled"
    powershell -command "Stop-Service cryptsvc"
    powershell -command "Set-Service -Name cryptsvc -StartupType Disabled"
    if %errorlevel% neq 0 (
        echo Windows Update Control encountered an error.
        echo Windows Update Control error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Windows Update services disabled.
        echo Windows Update services disabled on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Invalid choice.
    echo Invalid choice on %date% at %time% >> %LOGFILE%
)
:: Check Windows Update status
echo Checking Windows Update status...
powershell -command "Get-Service -Name wuauserv, bits, cryptsvc | Select-Object Name, Status, StartType"
if %errorlevel% neq 0 (
    echo Failed to check Windows Update status.
    echo Failed to check Windows Update status on %date% at %time% >> %LOGFILE%
) else (
    echo Windows Update status checked.
    echo Windows Update status checked on %date% at %time% >> %LOGFILE%
)
:: Install available updates
set /p install_updates="Would you like to install available updates now? (y/n): "
if /I "%install_updates%"=="y" (
    echo Installing updates...
    powershell -command "Install-WindowsUpdate -AcceptAll -AutoReboot"
    if %errorlevel% neq 0 (
        echo Update installation encountered an error.
        echo Update installation error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Updates installed successfully.
        echo Updates installed on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Update installation skipped.
    echo Update installation skipped on %date% at %time% >> %LOGFILE%
)
:: Additional Windows update control tasks
echo Performing additional Windows update control tasks...
powershell -command "Get-WindowsUpdateLog"
pause
goto :main_menu


:system_status_check
cls
echo =============================================
echo            System Status Check
echo =============================================
echo Checking System Status...
echo System Status Check started on %date% at %time% >> %LOGFILE%
:: Check disk space
echo Disk Space:
powershell -command "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='Used (GB)';Expression={[math]::round($_.Used/1GB,2)}}, @{Name='Free (GB)';Expression={[math]::round($_.Free/1GB,2)}}"
:: Check RAM usage
echo RAM Usage:
powershell -command "Get-Process | Measure-Object -Property WorkingSet -Sum | Select-Object @{Name='Total RAM Used (MB)';Expression={[math]::round($_.Sum/1MB,2)}}"
:: Check CPU usage
echo CPU Usage:
powershell -command "Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue"
:: Check antivirus status
echo Antivirus Status:
powershell -command "Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled"
if %errorlevel% neq 0 (
    echo System Status Check encountered an error.
    echo System Status Check error on %date% at %time% >> %LOGFILE%
) else (
    echo System Status Check completed.
    echo System Status Check completed on %date% at %time% >> %LOGFILE%
)
:: Additional system status check tasks
echo Performing additional system status check tasks...
powershell -command "Get-EventLog -LogName System -Newest 10"
pause
goto :main_menu

:advanced_system_cleaning
cls
echo =============================================
echo            Advanced System Cleaning
echo =============================================
echo Running Advanced System Cleaning...
echo Advanced System Cleaning started on %date% at %time% >> %LOGFILE%
:: Clean up system files
powershell -command "Start-Process cleanmgr -ArgumentList '/sagerun:1' -NoNewWindow -Wait"
:: Clean up temporary files
powershell -command "Remove-Item -Path $env:TEMP\* -Recurse -Force"
:: Clean up recycle bin
powershell -command "Clear-RecycleBin -Force"
if %errorlevel% neq 0 (
    echo Advanced System Cleaning encountered an error.
    echo Advanced System Cleaning error on %date% at %time% >> %LOGFILE%
) else (
    echo Advanced System Cleaning completed.
    echo Advanced System Cleaning completed on %date% at %time% >> %LOGFILE%
)
:: Additional advanced system cleaning tasks
echo Performing additional advanced system cleaning tasks...
powershell -command "Get-ChildItem -Path 'C:\Windows\Temp' -Recurse"
pause
goto :main_menu

:backup_and_restore
cls
echo =============================================
echo            Backup and Restore
echo =============================================
echo Running Backup and Restore...
echo Backup and Restore started on %date% at %time% >> %LOGFILE%
:: Create a system restore point
powershell -command "Checkpoint-Computer -Description 'Utility Tool Backup' -RestorePointType 'MODIFY_SETTINGS'"
:: Create a backup using File History
powershell -command "Start-Process -FilePath 'control.exe' -ArgumentList 'start filehistory' -NoNewWindow -Wait"
if %errorlevel% neq 0 (
    echo Backup and Restore encountered an error.
    echo Backup and Restore error on %date% at %time% >> %LOGFILE%
) else (
    echo Backup and Restore completed.
    echo Backup and Restore completed on %date% at %time% >> %LOGFILE%
)
:: Additional backup and restore tasks
echo Performing additional backup and restore tasks...
powershell -command "Get-Command -Module Microsoft.PowerShell.Utility"
pause
goto :main_menu

:driver_management
cls
echo =============================================
echo            Driver Management
echo =============================================
echo Managing Drivers...
echo Driver Management started on %date% at %time% >> %LOGFILE%

:: User choice for driver management
echo 1. Backup Current Drivers
echo 2. Update Drivers
echo 3. Install Driver from a Specified Path
echo 0. Return to Main Menu
echo =============================================
set /p driver_choice="Enter your choice: "

if %driver_choice%==1 goto :backup_drivers
if %driver_choice%==2 goto :update_drivers
if %driver_choice%==3 goto :install_driver
if %driver_choice%==0 goto :main_menu

@echo off
:backup_drivers
cls
echo =============================================
echo            Backup Current Drivers
echo =============================================
echo Backing up current drivers...
set LOGFILE=%~dp0driver_backup.log
echo Driver Backup started on %date% at %time% >> %LOGFILE%

set backup_dir=%~dp0driver_backup
mkdir "%backup_dir%" 2>nul

powershell -Command ^
" $backupDir = '%backup_dir%'; ^
  $drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, InfName, DriverProviderName, DriverDate; ^
  foreach ($driver in $drivers) { ^
      $safeDeviceName = $driver.DeviceName -replace '[\\/:*?""<>|]', '_'; ^
      $dest = Join-Path -Path $backupDir -ChildPath $safeDeviceName; ^
      if (-not (Test-Path -Path $dest)) { ^
          New-Item -Path $dest -ItemType Directory | Out-Null; ^
      } ^
      $infPath = $driver.InfName; ^
      $systemDriverPath = Join-Path -Path $env:SystemRoot -ChildPath 'INF'; ^
      $infFilePath = Join-Path -Path $systemDriverPath -ChildPath $infPath; ^
      if (Test-Path -Path $infFilePath) { ^
          Copy-Item -Path $infFilePath -Destination $dest -Force -ErrorAction SilentlyContinue; ^
      } else { ^
          Write-Output 'Driver path not found: ' $infFilePath; ^
      } ^
  }"

if %errorlevel% neq 0 (
    echo Driver Backup encountered an error.
    echo Driver Backup error on %date% at %time% >> %LOGFILE%
) else (
    echo Driver Backup completed.
    echo Driver Backup completed on %date% at %time% >> %LOGFILE%
)

pause
goto :driver_management




:: Update drivers
:update_drivers
cls
echo =============================================
echo            Update Drivers
echo =============================================
echo Checking for driver updates...
echo Driver Update started on %date% at %time% >> %LOGFILE%
powershell -command "Get-WindowsUpdateLog"
powershell -command "Install-WindowsUpdate -AcceptAll -AutoReboot"
if %errorlevel% neq 0 (
    echo Driver Update encountered an error.
    echo Driver Update error on %date% at %time% >> %LOGFILE%
) else (
    echo Driver Update completed.
    echo Driver Update completed on %date% at %time% >> %LOGFILE%
)
pause
goto :driver_management

:: Install driver from a specified path
:install_driver
cls
echo =============================================
echo            Install Driver from Specified Path
echo =============================================
set /p driver_path="Enter the full path to the driver: "
if not exist "%driver_path%" (
    echo The specified path does not exist.
    pause
    goto :driver_management
)
echo Installing driver from %driver_path%...
echo Driver Installation started on %date% at %time% >> %LOGFILE%
pnputil /add-driver "%driver_path%" /install
if %errorlevel% neq 0 (
    echo Driver Installation encountered an error.
    echo Driver Installation error on %date% at %time% >> %LOGFILE%
) else (
    echo Driver Installation completed.
    echo Driver Installation completed on %date% at %time% >> %LOGFILE%
)
pause
goto :driver_management


:user_account_management
cls
echo =============================================
echo            User Account Management
echo =============================================
echo Managing User Accounts...
echo User Account Management started on %date% at %time% >> %LOGFILE%

echo 1. Add a New User
echo 2. Remove an Existing User
echo 3. List All Users
echo 4. Enable a User Account
echo 5. Disable a User Account
echo 6. Change User Password
echo 7. Delete User Password
echo 8. Create User Password
echo 9. Change User Role (Admin/User)
echo 0. Return to Main Menu
echo =============================================
net user
echo =============================================
set /p user_choice="Enter your choice: "

if %user_choice%==1 goto :add_user
if %user_choice%==2 goto :remove_user
if %user_choice%==3 goto :list_users
if %user_choice%==4 goto :enable_user
if %user_choice%==5 goto :disable_user
if %user_choice%==6 goto :change_password
if %user_choice%==7 goto :delete_password
if %user_choice%==8 goto :create_password
if %user_choice%==9 goto :change_role
if %user_choice%==0 goto :main_menu

goto :user_account_management

:add_user
cls
echo =============================================
echo            Add a New User
echo =============================================
net user
echo =============================================
set /p username="Enter the username for the new user: "
set /p password="Enter the password for the new user: "
net user %username% %password% /add
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo User %username% added successfully.
    echo User %username% added on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:remove_user
cls
echo =============================================
echo            Remove an Existing User
echo =============================================
net user
echo =============================================
set /p username="Enter the username to remove: "
net user %username% /delete
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo User %username% removed successfully.
    echo User %username% removed on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:list_users
cls
echo =============================================
echo            List All Users
echo =============================================
net user
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo Listed all users successfully.
    echo Listed all users on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:enable_user
cls
echo =============================================
echo            Enable a User Account
echo =============================================
net user
echo =============================================
set /p username="Enter the username to enable: "
net user %username% /active:yes
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo User %username% enabled successfully.
    echo User %username% enabled on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:disable_user
cls
echo =============================================
echo            Disable a User Account
echo =============================================
net user
echo =============================================
set /p username="Enter the username to disable: "
net user %username% /active:no
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo User %username% disabled successfully.
    echo User %username% disabled on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:change_password
cls
echo =============================================
echo            Change User Password
echo =============================================
net user
echo =============================================
set /p username="Enter the username to change password for: "
set /p password="Enter the new password: "
net user %username% %password%
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo Password for user %username% changed successfully.
    echo Password for user %username% changed on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:delete_password
cls
echo =============================================
echo            Delete User Password
echo =============================================
net user
echo =============================================
set /p username="Enter the username to delete password for: "
net user %username% ""
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo Password for user %username% deleted successfully.
    echo Password for user %username% deleted on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:create_password
cls
echo =============================================
echo            Create User Password
echo =============================================
net user
echo =============================================
set /p username="Enter the username to create password for: "
set /p password="Enter the new password: "
net user %username% %password%
if %errorlevel% neq 0 (
    echo User Account Management encountered an error.
    echo User Account Management error on %date% at %time% >> %LOGFILE%
) else (
    echo Password for user %username% created successfully.
    echo Password for user %username% created on %date% at %time% >> %LOGFILE%
)
pause
goto :user_account_management

:change_role
cls
echo =============================================
echo            Change User Role (Admin/User)
echo =============================================
net user
echo =============================================
set /p username="Enter the username to change role for: "
echo 1. Make User an Administrator
echo 2. Make User a Standard User
set /p role_choice="Enter your choice: "

if %role_choice%==1 (
    net localgroup Administrators %username% /add
    if %errorlevel% neq 0 (
        echo User Account Management encountered an error.
        echo User Account Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo User %username% added to Administrators.
        echo User %username% added to Administrators on %date% at %time% >> %LOGFILE%
    )
) else if %role_choice%==2 (
    net localgroup Administrators %username% /delete
    if %errorlevel% neq 0 (
        echo User Account Management encountered an error.
        echo User Account Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo User %username% removed from Administrators.
        echo User %username% removed from Administrators on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Invalid choice.
    echo Invalid choice on %date% at %time% >> %LOGFILE%
)

pause
goto :user_account_management



:scheduled_task_management
cls
echo =============================================
echo            Scheduled Task Management
echo =============================================
echo Managing Scheduled Tasks...
echo Scheduled Task Management started on %date% at %time% >> %LOGFILE%
:: List all scheduled tasks
powershell -command "Get-ScheduledTask | Select-Object TaskName, State"
:: Enable or disable a scheduled task
set /p task_action="Enter 'enable' to enable or 'disable' to disable a scheduled task: "
set /p task_name="Enter the name of the scheduled task: "
if %task_action%==enable (
    powershell -command "Enable-ScheduledTask -TaskName '%task_name%'"
    if %errorlevel% neq 0 (
        echo Scheduled Task Management encountered an error.
        echo Scheduled Task Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Task %task_name% enabled successfully.
        echo Task %task_name% enabled on %date% at %time% >> %LOGFILE%
    )
) else if %task_action%==disable (
    powershell -command "Disable-ScheduledTask -TaskName '%task_name%'"
    if %errorlevel% neq 0 (
        echo Scheduled Task Management encountered an error.
        echo Scheduled Task Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Task %task_name% disabled successfully.
        echo Task %task_name% disabled on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Invalid choice.
    echo Invalid choice on %date% at %time% >> %LOGFILE%
)
:: Additional scheduled task management tasks
echo Performing additional scheduled task management tasks...
powershell -command "Get-ScheduledTask -TaskName '%task_name%'"
pause
goto :main_menu

:service_management
cls
echo =============================================
echo            Service Management
echo =============================================
echo Managing Services...
echo Service Management started on %date% at %time% >> %LOGFILE%
:: List all services
powershell -command "Get-Service | Select-Object Name, Status"
:: Start or stop a service
set /p service_action="Enter 'start' to start or 'stop' to stop a service: "
set /p service_name="Enter the name of the service: "
if %service_action%==start (
    powershell -command "Start-Service -Name '%service_name%'"
    if %errorlevel% neq 0 (
        echo Service Management encountered an error.
        echo Service Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Service %service_name% started successfully.
        echo Service %service_name% started on %date% at %time% >> %LOGFILE%
    )
) else if %service_action%==stop (
    powershell -command "Stop-Service -Name '%service_name%'"
    if %errorlevel% neq 0 (
        echo Service Management encountered an error.
        echo Service Management error on %date% at %time% >> %LOGFILE%
    ) else (
        echo Service %service_name% stopped successfully.
        echo Service %service_name% stopped on %date% at %time% >> %LOGFILE%
    )
) else (
    echo Invalid choice.
    echo Invalid choice on %date% at %time% >> %LOGFILE%
)
:: Additional service management tasks
echo Performing additional service management tasks...
powershell -command "Get-Service -Name '%service_name%'"
pause
goto :main_menu

:network_diagnostics
cls
echo =============================================
echo            Network Diagnostics
echo =============================================
echo Running Network Diagnostics...
echo Network Diagnostics started on %date% at %time% >> %LOGFILE%

:: Perform basic network diagnostics
echo Testing network connectivity...
powershell -command "Test-NetConnection"

if %errorlevel% neq 0 (
    echo Network Diagnostics encountered an error.
    echo Network Diagnostics error on %date% at %time% >> %LOGFILE%
    goto :fix_network_issues
) else (
    echo Network Diagnostics completed.
    echo Network Diagnostics completed on %date% at %time% >> %LOGFILE%
)

:fix_network_issues
echo Attempting to fix network issues...
echo Fixing Network Issues started on %date% at %time% >> %LOGFILE%

:: Reset TCP/IP stack
echo Resetting TCP/IP stack...
netsh int ip reset

:: Reset Winsock
echo Resetting Winsock...
netsh winsock reset

:: Flush DNS
echo Flushing DNS...
ipconfig /flushdns

:: Restart network adapter
echo Restarting network adapter...
powershell -command "
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
Disable-NetAdapter -Name $adapter.Name -Confirm:$false
Start-Sleep -Seconds 5
Enable-NetAdapter -Name $adapter.Name -Confirm:$false"

:: DNS Benchmark
echo Running DNS Benchmark...
powershell -Command "
$dnsServers = @('8.8.8.8', '8.8.4.4', '1.1.1.1', '1.0.0.1', '9.9.9.9', '149.112.112.112')
$fastestDns = $null
$shortestTime = [System.Double]::MaxValue
foreach ($dns in $dnsServers) {
    $start = Get-Date
    try {
        Resolve-DnsName -Server $dns -Name www.google.com -ErrorAction Stop | Out-Null
        $time = (Get-Date) - $start
        if ($time.TotalMilliseconds -lt $shortestTime) {
            $shortestTime = $time.TotalMilliseconds
            $fastestDns = $dns
        }
    } catch {
        Write-Output "DNS Server $dns failed to respond."
    }
}
if ($fastestDns -ne $null) {
    Write-Output "Fastest DNS Server: $fastestDns"
    Set-DnsClientServerAddress -InterfaceAlias 'Wi-Fi' -ServerAddresses $fastestDns
    Write-Output "DNS Server set to $fastestDns"
} else {
    Write-Output "No DNS Server responded."
}"

:: Check Internet connection
echo Checking Internet connection...
powershell -command "Test-NetConnection"

if %errorlevel% neq 0 (
    echo Network issues could not be resolved automatically.
    echo Network issues not resolved on %date% at %time% >> %LOGFILE%
) else (
    echo Network issues resolved.
    echo Network issues resolved on %date% at %time% >> %LOGFILE%
)

:: Adjust WiFi signal strength
echo Adjusting WiFi signal strength...
powershell -Command "
$wifiProfiles = netsh wlan show profiles
$wifiProfileName = $wifiProfiles -match 'All User Profile.*: (.*)' | ForEach-Object { $_.Matches.Groups[1].Value.Trim() }
if ($wifiProfileName -ne $null) {
    netsh wlan set profileparameter name=$wifiProfileName connectionmode=manual
    netsh wlan set profileparameter name=$wifiProfileName wirelessmode=6
    netsh wlan set profileparameter name=$wifiProfileName autoroconnect=yes
    Write-Output 'WiFi signal strength adjusted.'
} else {
    Write-Output 'No WiFi profiles found to adjust.'
}"

pause
goto :main_menu


:security_settings
cls
echo =============================================
echo            Security Settings
echo =============================================
echo Managing Security Settings...
echo Security Settings started on %date% at %time% >> %LOGFILE%

:: Check and set PowerShell execution policy
echo Checking and setting PowerShell execution policy...
powershell -command "Get-ExecutionPolicy"
powershell -command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force"
if %errorlevel% neq 0 (
    echo Failed to set PowerShell execution policy.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo PowerShell execution policy set to RemoteSigned.
    echo PowerShell execution policy set on %date% at %time% >> %LOGFILE%
)

:: Enable Windows Firewall
echo Enabling Windows Firewall...
powershell -command "Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True"
if %errorlevel% neq 0 (
    echo Failed to enable Windows Firewall.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo Windows Firewall enabled.
    echo Windows Firewall enabled on %date% at %time% >> %LOGFILE%
)

:: Enable User Account Control (UAC)
echo Enabling User Account Control (UAC)...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
if %errorlevel% neq 0 (
    echo Failed to enable UAC.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo UAC enabled.
    echo UAC enabled on %date% at %time% >> %LOGFILE%
)

:: Enable BitLocker (if available)
echo Checking for BitLocker support...
powershell -command "Get-BitLockerVolume -MountPoint C:"
if %errorlevel%==0 (
    echo Enabling BitLocker on drive C:...
    powershell -command "Enable-BitLocker -MountPoint 'C:' -EncryptionMethod XtsAes256 -UsedSpaceOnlyEncryption"
    if %errorlevel% neq 0 (
        echo Failed to enable BitLocker.
        echo Security Settings error on %date% at %time% >> %LOGFILE%
    ) else (
        echo BitLocker enabled on drive C:.
        echo BitLocker enabled on drive C: on %date% at %time% >> %LOGFILE%
    )
) else (
    echo BitLocker not supported or already enabled.
    echo BitLocker status checked on %date% at %time% >> %LOGFILE%
)

:: Disable BitLocker (if enabled)
echo Checking for BitLocker status on drive C:...
powershell -command "Get-BitLockerVolume -MountPoint C:"
if %errorlevel%==0 (
    echo Disabling BitLocker on drive C:...
    powershell -command "Disable-BitLocker -MountPoint 'C:'"
    if %errorlevel% neq 0 (
        echo Failed to disable BitLocker.
        echo Security Settings error on %date% at %time% >> %LOGFILE%
    ) else (
        echo BitLocker disabled on drive C:.
        echo BitLocker disabled on drive C: on %date% at %time% >> %LOGFILE%
    )
) else (
    echo BitLocker not enabled or already disabled.
    echo BitLocker status checked on %date% at %time% >> %LOGFILE%
)

:: Set account lockout policy
echo Setting account lockout policy...
net accounts /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30
if %errorlevel% neq 0 (
    echo Failed to set account lockout policy.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo Account lockout policy set.
    echo Account lockout policy set on %date% at %time% >> %LOGFILE%
)

:: Set password policy
echo Setting password policy...
net accounts /minpwlen:8 /maxpwage:30 /minpwage:1 /uniquepw:5
if %errorlevel% neq 0 (
    echo Failed to set password policy.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo Password policy set.
    echo Password policy set on %date% at %time% >> %LOGFILE%
)

:: Enable Windows Defender Real-time Protection
echo Enabling Windows Defender Real-time Protection...
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false"
if %errorlevel% neq 0 (
    echo Failed to enable Windows Defender Real-time Protection.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo Windows Defender Real-time Protection enabled.
    echo Windows Defender Real-time Protection enabled on %date% at %time% >> %LOGFILE%
)

:: Configure Windows Defender scheduled scans
echo Configuring Windows Defender scheduled scans...
powershell -command "Set-MpPreference -ScanScheduleDay Everyday -ScanScheduleTime 02:00"
if %errorlevel% neq 0 (
    echo Failed to configure Windows Defender scheduled scans.
    echo Security Settings error on %date% at %time% >> %LOGFILE%
) else (
    echo Windows Defender scheduled scans configured.
    echo Windows Defender scheduled scans configured on %date% at %time% >> %LOGFILE%
)

:: Additional security settings tasks
echo Performing additional security settings tasks...
powershell -command "Get-LocalGroup"
pause
goto :main_menu


:software_inventory
cls
echo =============================================
echo            Software Inventory
echo =============================================
echo Running Software Inventory...
echo Software Inventory started on %date% at %time% >> %LOGFILE%
:: List installed software
powershell -command "Get-WmiObject -Class Win32_Product | Select-Object Name, Version"
if %errorlevel% neq 0 (
    echo Software Inventory encountered an error.
    echo Software Inventory error on %date% at %time% >> %LOGFILE%
) else (
    echo Software Inventory completed.
    echo Software Inventory completed on %date% at %time% >> %LOGFILE%
)
:: Additional software inventory tasks
echo Performing additional software inventory tasks...
powershell -command "Get-Package"
pause
goto :main_menu

:hardware_inventory
cls
echo =============================================
echo            Hardware Inventory
echo =============================================
echo Running Hardware Inventory...
echo Hardware Inventory started on %date% at %time% >> %LOGFILE%
:: List hardware components
powershell -command "Get-WmiObject -Class Win32_ComputerSystem"
powershell -command "Get-WmiObject -Class Win32_Processor"
powershell -command "Get-WmiObject -Class Win32_PhysicalMemory"
if %errorlevel% neq 0 (
    echo Hardware Inventory encountered an error.
    echo Hardware Inventory error on %date% at %time% >> %LOGFILE%
) else (
    echo Hardware Inventory completed.
    echo Hardware Inventory completed on %date% at %time% >> %LOGFILE%
)
:: Additional hardware inventory tasks
echo Performing additional hardware inventory tasks...
powershell -command "Get-WmiObject -Class Win32_DiskDrive"
pause
goto :main_menu
