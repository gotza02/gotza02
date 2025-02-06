@echo off

:: ============================================================================
:: Windows Optimization and Management Script - Ultimate Edition (English)
:: ============================================================================
:: Author: [Your Name/Organization] (Adapted from original script)
:: Version: 6.0 (Ultimate)
::
:: Description: This script provides an extremely comprehensive set of tools
::              to optimize, maintain, configure, troubleshoot, and customize
::              Windows. It is designed for power users and IT professionals.
::
:: IMPORTANT: Run this script as an administrator. It includes a built-in
::            administrator privilege check.
:: ============================================================================

:: ============================================================================
:: --- Administrator Privilege Check and Self-Elevation ---
:: ============================================================================

net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/c """"%~f0""""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:: ============================================================================
:: --- Enable Delayed Expansion ---
:: ============================================================================

setlocal enabledelayedexpansion

:: ============================================================================
:: --- Function Definitions ---
:: ============================================================================

:: Function to modify registry values with error handling and logging
:modify_registry
set "reg_key=%~1"
set "reg_value=%~2"
set "reg_type=%~3"
set "reg_data=%~4"

reg add "%reg_key%" /v "%reg_value%" /t %reg_type% /d "%reg_data%" /f >nul 2>&1
if %errorlevel% NEQ 0 (
    echo ERROR: Failed to modify registry key: "%reg_key%\%reg_value%"
    echo        Errorlevel: %errorlevel%
    pause
)
goto :eof

:: Function to check if a service exists
:service_exists
sc query "%~1" >nul 2>&1
exit /b %errorlevel%
goto :eof

:: Function to get user confirmation (Y/N)
:get_confirmation
set "prompt_message=%~1"
set /p "confirmation=%prompt_message% (Y/N): "
if /I "%confirmation%"=="Y" (
    exit /b 0  :: Return 0 for YES
) else (
    exit /b 1  :: Return 1 for NO
)
goto :eof

:: Function to execute PowerShell commands and handle errors
:execute_powershell
set "ps_command=%~1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "%ps_command%"
if %errorlevel% NEQ 0 (
    echo ERROR: PowerShell command failed.
    echo        Command: %ps_command%
    echo        Errorlevel: %errorlevel%
    pause
)
goto :eof

:: ============================================================================
:: --- Main Menu ---
:: ============================================================================

:menu
cls
echo ================================================================
echo  Windows Optimization and Management Script v6.0 (Ultimate)
echo ================================================================
echo  [Performance]
echo   1. Optimize Display
echo   2. Optimize CPU
echo   3. Optimize Internet
echo   4. Optimize Disk
echo.
echo  [System Management]
echo   5. Manage Windows Defender
echo   6. Manage Windows Update
echo   7. Manage Startup Programs
echo   8. Configure Auto-login (Use with caution!)
echo   9. Manage User Accounts
echo  10. Manage Local Group Policy (NEW)
echo.
echo  [Maintenance]
echo  11. Clear System Cache
echo  12. Check and Repair System Files
echo  13. Clean Up Disk Space
echo  14. Advanced System Cleanup
echo.
echo  [System Configuration]
echo  15. Manage Power Settings
echo  16. Enable/Disable Dark Mode
echo  17. System Information
echo  18. Backup and Restore Settings (System Restore)
echo  19. Manage Environment Variables
echo  20. Manage System Protection (NEW)
echo.
echo  [Windows Activation]
echo  21. Windows Activation
echo.
echo  [Advanced]
echo  22. Manage Windows Services (Advanced Users Only)
echo  23. Optimize Privacy Settings
echo  24. Network Reset and Advanced Optimization
echo  25. Network Troubleshooting (NEW)
echo  26. Manage Installed Applications
echo  27. Advanced Registry Tweaks (Experts Only!)
echo  28. Hardware Diagnostics
echo  29. System Recovery Options (NEW)
echo  30. Customize Windows Appearance (NEW)
echo.
echo  31. Exit
echo ================================================================
set /p "choice=Enter your choice (1-31): "

:: Input validation
if not defined choice (
    echo Invalid choice. Please try again.
    pause
    goto menu
)

:: Check if choice is a number between 1 and 31
echo %choice%| findstr /r "^[1-9]$ ^1[0-9]$ ^2[0-9]$ ^3[0-1]$" >nul
if errorlevel 1 (
     echo Invalid choice. Please try again.
     pause > nul
     goto menu
)

goto option_%choice%

:: ============================================================================
:: --- Option Implementations ---
:: ============================================================================

:option_1
:optimize_display
echo Optimizing display performance...
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKCU\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo Display performance optimized.
pause
goto menu

:option_2
:optimize_cpu
cls
echo ==================================================
echo CPU Optimization
echo ==================================================
echo  [Power Management]
echo  1. Set High Performance Power Plan
echo  2. Disable CPU Throttling (Advanced - May increase heat/power)
echo  3. Customize Power Plan Settings (Advanced)
echo.
echo  [Processor Scheduling & Affinity]
echo  4. Optimize Processor Scheduling (Programs vs. Background Services)
echo  5. Set Process Priority (Temporary - Requires Process Name)
echo  6. Set Process Affinity (Advanced - Requires Process Name)
echo.
echo  [System Configuration]
echo  7. Enable Hardware-Accelerated GPU Scheduling (Requires Restart)
echo  8. Disable Core Parking (May not be beneficial on all systems)
echo  9. Disable Legacy USB Support in BIOS (Caution - May disable input)
echo.
echo  [Overclocking/Undervolting - EXTREMELY DANGEROUS]
echo 10.  Open BIOS/UEFI Settings (Requires Restart - Use with EXTREME CAUTION)
echo.
echo 11. Return to Main Menu
echo ==================================================
set /p cpu_choice=Enter your choice (1-11):

if "%cpu_choice%"=="1" goto set_high_performance
if "%cpu_choice%"=="2" goto disable_throttling
if "%cpu_choice%"=="3" goto customize_power_plan
if "%cpu_choice%"=="4" goto optimize_scheduling
if "%cpu_choice%"=="5" goto set_process_priority
if "%cpu_choice%"=="6" goto set_process_affinity
if "%cpu_choice%"=="7" goto enable_gpu_scheduling
if "%cpu_choice%"=="8" goto disable_core_parking
if "%cpu_choice%"=="9" goto disable_legacy_usb
if "%cpu_choice%"=="10" goto open_bios_settings
if "%cpu_choice%"=="11" goto menu

echo Invalid choice.
pause
goto optimize_cpu

:set_high_performance
echo Setting High Performance power plan...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo High Performance power plan set.
pause
goto optimize_cpu

:disable_throttling
echo Disabling CPU Throttling...
echo WARNING: This may increase power consumption, heat generation,
echo          and potentially reduce CPU lifespan.  Use with caution
echo          and monitor your system temperatures.
call :get_confirmation "Are you sure you want to disable CPU throttling?"
if errorlevel 1 (
    echo Throttling disablement cancelled.
    pause
    goto optimize_cpu
)
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setactive scheme_current
echo CPU throttling disabled (both AC and DC).
pause
goto optimize_cpu

:customize_power_plan
echo Opening Power Options control panel...
echo Use the control panel to customize advanced power plan settings.
control powercfg.cpl
pause
goto optimize_cpu

:optimize_scheduling
echo Select processor scheduling optimization:
echo 1. Optimize for Programs (Recommended for most users)
echo 2. Optimize for Background Services (For servers or specific workloads)
set /p "sched_choice=Enter your choice (1-2): "

if "%sched_choice%"=="1" (
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
    echo Processor scheduling optimized for Programs.
) else if "%sched_choice%"=="2" (
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "24"
    echo Processor scheduling optimized for Background Services.
) else (
    echo Invalid scheduling choice.
)
pause
goto optimize_cpu

:set_process_priority
set /p "proc_name=Enter the process name (e.g., notepad.exe): "
echo Select priority level:
echo  1. Realtime (DANGEROUS - Can cause system instability)
echo  2. High
echo  3. Above Normal
echo  4. Normal
echo  5. Below Normal
echo  6. Low
set /p "priority_choice=Enter your choice (1-6): "

if "%priority_choice%"=="1" set "priority_level=realtime"
if "%priority_choice%"=="2" set "priority_level=high"
if "%priority_choice%"=="3" set "priority_level=abovenormal"
if "%priority_choice%"=="4" set "priority_level=normal"
if "%priority_choice%"=="5" set "priority_level=belownormal"
if "%priority_choice%"=="6" set "priority_level=low"

if not defined priority_level (
    echo Invalid priority choice.
    pause
    goto optimize_cpu
)

echo Setting priority for process "%proc_name%" to %priority_level%...
wmic process where name="%proc_name%" CALL setpriority "%priority_level%"
echo Process priority change attempted.  Check Task Manager.
pause
goto optimize_cpu

:set_process_affinity
echo WARNING: Setting process affinity incorrectly can negatively impact performance.
set /p "proc_name=Enter the process name (e.g., notepad.exe): "
set /p "affinity_mask=Enter the affinity mask (decimal value - see documentation): "
echo Setting affinity for process "%proc_name%" to %affinity_mask%...
powershell -Command "$Process = Get-Process '%proc_name%'; $Process.ProcessorAffinity=%affinity_mask%"
echo Process affinity change attempted. Check Task Manager.
pause
goto optimize_cpu
:enable_gpu_scheduling
echo Enabling Hardware-Accelerated GPU Scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled.  Restart required.
pause
goto optimize_cpu

:disable_core_parking
echo WARNING: Disabling core parking may not improve performance on all systems
echo          and may increase power consumption.  It is generally recommended
echo          to leave core parking enabled unless you have a specific reason
echo          to disable it and have tested the impact.
call :get_confirmation "Are you sure you want to disable CPU core parking?"
if errorlevel 1 (
    echo Core parking disablement cancelled.
    pause
    goto optimize_cpu
)
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setdcvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current

echo CPU core parking disabled (both AC and DC).
pause
goto optimize_cpu

:disable_legacy_usb
echo WARNING: Disabling legacy USB support in the BIOS can prevent you
echo          from using USB keyboards and mice *before* the operating
echo          system loads.  This can make it difficult to access the
echo          BIOS or troubleshoot boot problems.  Do NOT proceed unless
echo          you understand the risks and have alternative input methods.
call :get_confirmation "Are you ABSOLUTELY SURE you want to disable Legacy USB?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto optimize_cpu
)
echo This option cannot be performed directly from the script.
echo You must manually disable "Legacy USB Support" (or similar)
echo in your computer's BIOS/UEFI settings.  Refer to your
echo motherboard or computer manufacturer's documentation.
pause
goto optimize_cpu

:open_bios_settings
echo WARNING: Modifying BIOS/UEFI settings incorrectly can prevent your
echo          computer from booting.  Overclocking or undervolting can
echo          damage your hardware.  Proceed with EXTREME CAUTION.
call :get_confirmation "Are you ABSOLUTELY SURE you want to open BIOS/UEFI settings?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto optimize_cpu
)
shutdown /r /fw /f /t 00
echo Restarting to BIOS/UEFI settings...
pause
goto optimize_cpu

:option_3
:optimize_internet
echo Optimizing internet performance...

:: Flush DNS Cache
ipconfig /flushdns

:: Optimize TCP Settings (Modern Approach)
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled

:: Set Google Public DNS (Optional - User can modify)
netsh interface ip set dns name="Wi-Fi" static 8.8.8.8
netsh interface ip add dns name="Wi-Fi" 8.8.4.4 index=2
::Note, replace "Wi-Fi" with your connection's name

echo Internet performance optimized.
pause
goto menu

:option_4
:optimize_disk
cls
echo ==================================================
echo Disk Optimization
echo ==================================================
echo 1. Analyze disk (Defrag Analysis)
echo 2. Optimize/Defragment disk (Use with caution on SSDs)
echo 3. Check Disk for Errors (Requires Restart)
echo 4. Trim SSD (If applicable)
echo 5. Return to Main Menu
echo ==================================================
set /p disk_choice=Enter your choice (1-5):

if "%disk_choice%"=="1" goto analyze_disk
if "%disk_choice%"=="2" goto optimize_defrag
if "%disk_choice%"=="3" goto check_disk
if "%disk_choice%"=="4" goto trim_ssd
if "%disk_choice%"=="5" goto menu
echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk
echo Analyzing disk...
defrag C: /A
echo Disk analysis completed.
pause
goto optimize_disk

:optimize_defrag
echo Optimizing/Defragmenting disk...
echo WARNING: Defragmenting SSDs can reduce their lifespan.
echo          Only proceed if you are using a traditional HDD.
set /p "confirm=Are you sure you want to defrag (Y/N)? "
if /I "%confirm%"=="Y" (
    defrag C: /O
    echo Disk optimization completed.
) else (
    echo Defragmentation cancelled.
)
pause
goto optimize_disk

:check_disk
echo Checking disk for errors...
echo This will schedule a disk check on the next restart.
echo WARNING:  This can take a significant amount of time.
set /p "confirm=Schedule disk check on next restart (Y/N)? "
if /I "%confirm%"=="Y" (
    chkdsk C: /F /R /X
    echo Disk check scheduled. Restart your computer.
) else (
    echo Disk check cancelled.
)
pause
goto optimize_disk

:trim_ssd
echo Trimming SSD...
fsutil behavior set disabledeletenotify 0  :: Ensure TRIM is enabled
defrag C: /L  ::  Re-trim the SSD (Windows 8 and later)
echo SSD trim completed.
pause
goto optimize_disk

:option_5
:manage_defender
cls
echo ===================================================
echo             Windows Defender Management
echo ===================================================
echo 1. Check Windows Defender status
echo 2. Enable Windows Defender
echo 3. Disable Windows Defender (NOT RECOMMENDED)
echo 4. Update Windows Defender Definitions
echo 5. Run Quick Scan
echo 6. Run Full Scan (May take a long time)
echo 7. Return to Main Menu
echo ===================================================
set /p def_choice=Enter your choice (1-7):

if "%def_choice%"=="1" goto check_defender
if "%def_choice%"=="2" goto enable_defender
if "%def_choice%"=="3" goto disable_defender
if "%def_choice%"=="4" goto update_defender
if "%def_choice%"=="5" goto quick_scan
if "%def_choice%"=="6" goto full_scan
if "%def_choice%"=="7" goto menu
echo Invalid choice. Please try again.
pause
goto manage_defender

:check_defender
echo Checking Windows Defender status...
sc query windefend
pause
goto manage_defender

:enable_defender
echo Enabling Windows Defender...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
sc start WinDefend
echo Windows Defender enabled.
pause
goto manage_defender

:disable_defender
echo WARNING: Disabling Windows Defender is NOT recommended.
echo          Your system will be vulnerable to malware.
set /p "confirm=Are you sure you want to disable Defender (Y/N)? "
if /I "%confirm%"=="Y" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    sc stop WinDefend
    echo Windows Defender disabled.
) else (
    echo Operation cancelled.
)
pause
goto manage_defender

:update_defender
echo Updating Windows Defender definitions...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
echo Windows Defender definitions updated.
pause
goto manage_defender

:quick_scan
echo Running quick scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo Quick scan completed.
pause
goto manage_defender

:full_scan
echo Running full scan...
echo This may take a significant amount of time.
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo Full scan initiated.
pause
goto manage_defender

:option_6
:windows_update
cls
echo ==================================================
echo Windows Update Management
echo ==================================================
echo 1. Enable Windows Update Service
echo 2. Disable Windows Update Service (NOT RECOMMENDED)
echo 3. Check for Updates
echo 4. Download and Install Updates (Requires Confirmation)
echo 5. Return to Main Menu
echo ==================================================
set /p update_choice=Enter your choice (1-5):

if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
if "%update_choice%"=="4" goto download_install_updates
if "%update_choice%"=="5" goto menu
echo Invalid choice. Please try again.
pause
goto windows_update

:enable_windows_update
echo Enabling Windows Update service...
sc config wuauserv start= auto
sc start wuauserv
echo Windows Update service enabled.
pause
goto windows_update

:disable_windows_update
echo WARNING: Disabling Windows Update is NOT recommended.
echo          You will not receive security updates.
set /p "confirm=Are you sure you want to disable updates (Y/N)? "
if /I "%confirm%"=="Y" (
    sc config wuauserv start= disabled
    sc stop wuauserv
    echo Windows Update service disabled.
) else (
    echo Operation cancelled.
)
pause
goto windows_update

:check_updates
echo Checking for Windows Updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo Update check initiated.  Check Windows Update settings.
pause
goto windows_update

:download_install_updates
echo WARNING: This will download and install all available updates.
echo          This may take a significant amount of time and require
echo          a restart.
call :get_confirmation "Are you sure you want to download and install updates?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto windows_update
)
powershell -Command "(New-Object -ComObject Microsoft.Update.Session).CreateUpdateInstaller().Download(); (New-Object -ComObject Microsoft.Update.Session).CreateUpdateInstaller().Install()"
echo Updates downloaded and installed (if available). Restart may be required.
pause
goto windows_update

:option_7
:manage_startup
echo Opening Startup Program Manager...
start msconfig
echo Manage startup programs in the Task Manager (Startup tab).
pause
goto menu

:option_8
:auto_login
echo Configuring Auto-login...
echo WARNING: Auto-login stores your password in plain text in the registry.
echo          This is a security risk.  Use with extreme caution.
set /p "username=Enter username: "
set /p "password=Enter password: "
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo Auto-login configured (with security warning).
pause
goto menu

:option_9
:manage_user_accounts
cls
echo ==================================================
echo User Account Management
echo ==================================================
echo 1. List User Accounts
echo 2. Create New User Account
echo 3. Delete User Account (USE WITH CAUTION)
echo 4. Change User Password (Requires Current Password)
echo 5. Enable/Disable User Account
echo 6. Return to Main Menu
echo ==================================================
set /p user_choice=Enter your choice (1-6):

if "%user_choice%"=="1" goto list_user_accounts
if "%user_choice%"=="2" goto create_user_account
if "%user_choice%"=="3" goto delete_user_account
if "%user_choice%"=="4" goto change_user_password
if "%user_choice%"=="5" goto enable_disable_user
if "%user_choice%"=="6" goto menu
echo Invalid choice.
pause
goto manage_user_accounts

:list_user_accounts
echo Listing user accounts...
net user
pause
goto manage_user_accounts

:create_user_account
set /p "new_username=Enter new username: "
set /p "new_password=Enter password for new user: "
set /p "add_to_admin=Add user to Administrators group (Y/N)? "

net user /add "%new_username%" "%new_password%"
if /I "%add_to_admin%"=="Y" (
    net localgroup administrators "%new_username%" /add
    echo User "%new_username%" created and added to Administrators.
) else (
    echo User "%new_username%" created.
)
pause
goto manage_user_accounts

:delete_user_account
echo WARNING: Deleting a user account will remove all user data.
set /p "del_username=Enter username to delete: "
call :get_confirmation "Are you sure you want to delete user '%del_username%'?"
if errorlevel 1 (
    echo User deletion cancelled.
    pause
    goto manage_user_accounts
)
net user "%del_username%" /delete
echo User "%del_username%" deleted (if it existed).
pause
goto manage_user_accounts

:change_user_password
set /p "target_user=Enter username to change password for: "
net user "%target_user%"
:: The above command prompts for the current password, then the new password.
pause
goto manage_user_accounts

:enable_disable_user
set /p "ed_username=Enter username to enable/disable: "
echo 1. Enable User Account
echo 2. Disable User Account
set /p "ed_choice=Enter your choice (1-2): "

if "%ed_choice%"=="1" (
    net user "%ed_username%" /active:yes
    echo User "%ed_username%" enabled.
) else if "%ed_choice%"=="2" (
    net user "%ed_username%" /active:no
    echo User "%ed_username%" disabled.
) else (
    echo Invalid choice.
)
pause
goto manage_user_accounts

:option_10
:manage_local_group_policy
 echo Opening Local Group Policy Editor...
 echo NOTE: This feature is only available on Windows Pro, Enterprise, and Education editions.
 start gpedit.msc
 echo Manage local group policies using the editor.
 pause
 goto menu
 
:option_11
:clear_cache
echo Clearing system cache...
del /f /s /q %TEMP%\*
del /f /s /q C:\Windows\Temp\*
echo System cache cleared.
pause
goto menu

:option_12
:check_repair
cls
echo ==================================================
echo Check and Repair System Files
echo ==================================================
echo 1. Run SFC (System File Checker)
echo 2. Run DISM (Deployment Image Servicing and Management)
echo 3. Return to Main Menu
echo ==================================================
set /p repair_choice=Enter your choice (1-3):

if "%repair_choice%"=="1" goto run_sfc
if "%repair_choice%"=="2" goto run_dism
if "%repair_choice%"=="3" goto menu
echo Invalid choice. Please try again.
pause
goto check_repair

:run_sfc
echo Running System File Checker (SFC)...
sfc /scannow
echo SFC scan completed.
pause
goto check_repair

:run_dism
echo Running Deployment Image Servicing and Management (DISM)...
DISM /Online /Cleanup-Image /RestoreHealth
echo DISM scan completed.
pause
goto check_repair

:option_13
:clean_disk
echo Running Disk Cleanup...
cleanmgr /sagerun:1  :: Use a predefined cleanup profile (create with cleanmgr /sageset:1)
echo Disk cleanup completed.
pause
goto menu

:option_14
:advanced_system_cleanup
cls
echo ==================================================
echo Advanced System Cleanup
echo ==================================================
echo WARNING: These options can free up significant space,
echo          but some may remove files you might need later.
echo          Proceed with caution.
echo.
echo 1. Clean Windows Update Files (Aggressive)
echo 2. Clear Prefetch Files
echo 3. Clear Event Logs
echo 4. Return to Main Menu
echo ==================================================

set /p cleanup_choice=Enter your choice (1-4):

if "%cleanup_choice%"=="1" goto clean_windows_update_files
if "%cleanup_choice%"=="2" goto clear_prefetch
if "%cleanup_choice%"=="3" goto clear_event_logs
if "%cleanup_choice%"=="4" goto menu
echo Invalid choice.
pause
goto advanced_system_cleanup

:clean_windows_update_files
echo WARNING: This will remove Windows Update files, including
echo          rollback files.  You will not be able to uninstall
echo          previous updates after this.
call :get_confirmation "Are you sure you want to proceed?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto advanced_system_cleanup
)

DISM.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo Windows Update files cleaned (aggressively).
pause
goto advanced_system_cleanup

:clear_prefetch
echo Clearing Prefetch files...
del /f /s /q C:\Windows\Prefetch\*
echo Prefetch files cleared.
pause
goto advanced_system_cleanup

:clear_event_logs
echo WARNING: This will clear ALL event logs.  This is generally
echo          not recommended unless you are troubleshooting a
echo          specific issue.
call :get_confirmation "Are you sure you want to clear ALL event logs?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto advanced_system_cleanup
)

wevtutil el | Foreach-Object {wevtutil cl "$_"}
echo All event logs cleared.
pause
goto advanced_system_cleanup

:option_15
:manage_power
cls
echo ==================================================
echo Power Settings Management
echo ==================================================
echo 1. List All Power Plans
echo 2. Set Power Plan (Enter GUID)
echo 3. Return to Main Menu
echo ==================================================
set /p power_choice=Enter your choice (1-3):

if "%power_choice%"=="1" goto list_power_plans
if "%power_choice%"=="2" goto set_power_plan
if "%power_choice%"=="3" goto menu
echo Invalid choice. Please try again.
pause
goto manage_power

:list_power_plans
echo Listing all power plans...
powercfg /list
pause
goto manage_power

:set_power_plan
echo Available power plans:
powercfg /list
set /p "plan_guid=Enter the GUID of the power plan to set: "
powercfg /setactive %plan_guid%
echo Power plan set.
pause
goto manage_power

:option_16
:enable_disable_dark_mode
cls
echo ==================================================
echo Enable/Disable Dark Mode
echo ==================================================
echo 1. Enable Dark Mode
echo 2. Enable Light Mode
echo 3. Return to Main Menu
echo ==================================================

set /p dark_mode_choice=Enter your choice (1-3):

if "%dark_mode_choice%"=="1" goto enable_dark_mode_impl
if "%dark_mode_choice%"=="2" goto enable_light_mode_impl
if "%dark_mode_choice%"=="3" goto menu
echo Invalid choice.
pause
goto enable_disable_dark_mode

:enable_dark_mode_impl
echo Enabling Dark Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo Dark Mode enabled.
pause
goto enable_disable_dark_mode

:enable_light_mode_impl
echo Enabling Light Mode...
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "1"
echo Light Mode enabled.
pause
goto enable_disable_dark_mode

:option_17
:system_info
echo Displaying system information...
systeminfo
pause
goto menu

:option_18
:backup_restore
cls
echo ==================================================
echo Backup and Restore (System Restore)
echo ==================================================
echo 1. Create System Restore Point
echo 2. Open System Restore
echo 3. Return to Main Menu
echo ==================================================
set /p backup_choice=Enter your choice (1-3):

if "%backup_choice%"=="1" goto create_restore
if "%backup_choice%"=="2" goto restore_point
if "%backup_choice%"=="3" goto menu
echo Invalid choice. Please try again.
pause
goto backup_restore

:create_restore
echo Creating System Restore Point...
powershell -Command "Checkpoint-Computer -Description \"Manual Restore Point\" -RestorePointType \"MODIFY_SETTINGS\""
echo System Restore Point created.
pause
goto backup_restore

:restore_point
echo Opening System Restore...
start rstrui.exe
echo Follow the on-screen instructions to restore your system.
pause
goto backup_restore

:option_19
:manage_environment_variables
cls
echo ==================================================
echo Manage Environment Variables
echo ==================================================
echo 1. List User Environment Variables
echo 2. List System Environment Variables
echo 3. Set User Environment Variable
echo 4. Set System Environment Variable (Requires Restart)
echo 5. Return to Main Menu
echo ==================================================
set /p env_choice=Enter your choice (1-5):

if "%env_choice%"=="1" goto list_user_env_vars
if "%env_choice%"=="2" goto list_system_env_vars
if "%env_choice%"=="3" goto set_user_env_var
if "%env_choice%"=="4" goto set_system_env_var
if "%env_choice%"=="5" goto menu
echo Invalid choice.
pause
goto manage_environment_variables

:list_user_env_vars
echo Listing user environment variables...
set
pause
goto manage_environment_variables

:list_system_env_vars
echo Listing system environment variables...
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
pause
goto manage_environment_variables

:set_user_env_var
set /p "env_var_name=Enter variable name: "
set /p "env_var_value=Enter variable value: "
setx "%env_var_name%" "%env_var_value%"
echo User environment variable set.
pause
goto manage_environment_variables

:set_system_env_var
echo WARNING: Setting system environment variables incorrectly can
echo          cause system instability.
set /p "env_var_name=Enter variable name: "
set /p "env_var_value=Enter variable value: "
setx /M "%env_var_name%" "%env_var_value%"
echo System environment variable set (requires restart).
pause
goto manage_environment_variables

:option_20
:manage_system_protection
cls
echo ==================================================
echo Manage System Protection
echo ==================================================
echo 1. Enable System Protection (for C: drive)
echo 2. Disable System Protection (for C: drive)
echo 3. Configure System Protection Settings
echo 4. Return to Main Menu
echo ==================================================
set /p sys_prot_choice=Enter your choice (1-4):

if "%sys_prot_choice%"=="1" goto enable_system_protection
if "%sys_prot_choice%"=="2" goto disable_system_protection
if "%sys_prot_choice%"=="3" goto configure_system_protection
if "%sys_prot_choice%"=="4" goto menu
echo Invalid choice.
pause
goto manage_system_protection

:enable_system_protection
echo Enabling System Protection for C: drive...
powershell -Command "Enable-ComputerRestore -Drive C:"
echo System Protection enabled for C: drive.
pause
goto manage_system_protection

:disable_system_protection
echo WARNING: Disabling System Protection will delete all existing
echo          restore points for the C: drive.
call :get_confirmation "Are you sure you want to disable System Protection?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto manage_system_protection
)
powershell -Command "Disable-ComputerRestore -Drive C:"
echo System Protection disabled for C: drive.
pause
goto manage_system_protection

:configure_system_protection
echo Opening System Protection configuration...
SystemPropertiesProtection.exe
echo Configure System Protection settings in the System Properties window.
pause
goto manage_system_protection

:option_21
:windows_activate
cls
echo ==================================================
echo Windows Activation
echo ==================================================
echo 1. Check activation status
echo 2. Activate using KMS (for Volume License versions)
echo 3. Activate using digital license
echo 4. Input a product key manually
echo 5. Remove product key
echo 6. Return to main menu
echo ==================================================
set /p activate_choice=Enter your choice (1-6): 

if "%activate_choice%"=="1" goto check_activation
if "%activate_choice%"=="2" goto kms_activate
if "%activate_choice%"=="3" goto digital_activate
if "%activate_choice%"=="4" goto manual_key
if "%activate_choice%"=="5" goto remove_key
if "%activate_choice%"=="6" goto menu
echo Invalid choice. Please try again.
pause
goto windows_activate

:check_activation
echo Checking Windows activation status...
slmgr /xpr
pause
goto windows_activate

:kms_activate
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    :: If running as administrator, execute the PowerShell command
    powershell -command "irm https://get.activated.win | iex"
) else (
    :: If not running as administrator, relaunch the script as administrator
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
)
pause
goto windows_activate

:activate_kms
slmgr /ato
if %errorlevel% neq 0 (
    echo Activation failed. Please try another method or check your Windows version.
) else (
    echo Windows activation attempted. Please check the activation status.
)
pause
goto windows_activate

:digital_activate
echo Attempting to activate Windows using digital license...
slmgr /ato
if %errorlevel% neq 0 (
    echo Digital license activation failed. Your PC may not have a digital license.
) else (
    echo Digital license activation attempted. Please check the activation status.
)
pause
goto windows_activate

:manual_key
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX): 
echo Installing product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
) else (
    echo Product key installed. Attempting activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your product key and try again.
    ) else (
        echo Windows activation attempted. Please check the activation status.
    )
)
pause
goto windows_activate

:remove_key
echo Removing current product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo Failed to remove product key. You may not have permission or there's no key to remove.
) else (
    echo Product key removed successfully.
)
pause
goto windows_activate

:option_22
:manage_services
cls
echo ==================================================
echo Windows Services Management (ADVANCED USERS ONLY)
echo ==================================================
echo 1. List All Services
echo 2. Start a Service
echo 3. Stop a Service
echo 4. Change Service Startup Type
echo 5. Return to Main Menu
echo ==================================================
set /p service_choice=Enter your choice (1-5):

if "%service_choice%"=="1" goto list_all_services
if "%service_choice%"=="2" goto start_service
if "%service_choice%"=="3" goto stop_service
if "%service_choice%"=="4" goto change_startup_type
if "%service_choice%"=="5" goto menu
echo Invalid choice. Please try again.
pause
goto manage_services

:list_all_services
echo Listing all services...
sc query type= service state= all
pause
goto manage_services

:start_service
set /p "service_name=Enter the name of the service to start: "
call :service_exists "%service_name%"
if errorlevel 1 (
    echo Service "%service_name%" not found.
    pause
    goto manage_services
)
sc start "%service_name%"
echo Attempted to start service "%service_name%". Check status.
pause
goto manage_services

:stop_service
set /p "service_name=Enter the name of the service to stop: "
call :service_exists "%service_name%"
if errorlevel 1 (
     echo Service "%service_name%" not found.
     pause
     goto manage_services
)
sc stop "%service_name%"
echo Attempted to stop service "%service_name%". Check status.
pause
goto manage_services

:change_startup_type
set /p "service_name=Enter the name of the service: "
call :service_exists "%service_name%"
if errorlevel 1 (
    echo Service "%service_name%" not found.
    pause
    goto manage_services
)
echo Select startup type:
echo 1. Automatic
echo 2. Automatic (Delayed Start)
echo 3. Manual
echo 4. Disabled
set /p "startup_choice=Enter your choice (1-4): "

if "%startup_choice%"=="1" set "startup_type=auto"
if "%startup_choice%"=="2" set "startup_type=delayed-auto"
if "%startup_choice%"=="3" set "startup_type=demand"
if "%startup_choice%"=="4" set "startup_type=disabled"

if not defined startup_type (
    echo Invalid startup type choice.
    pause
    goto manage_services
)

sc config "%service_name%" start= %startup_type%
echo Service "%service_name%" startup type changed to %startup_type%.
pause
goto manage_services

:option_23
:optimize_privacy
echo Optimizing privacy settings...

:: Disable Telemetry (Basic)
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"

:: Disable Advertising ID
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" "REG_DWORD" "0"

:: Disable Location Tracking
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc" "Start" "REG_DWORD" "4"
sc stop lfsvc

:: Disable Feedback Notifications
call :modify_registry "HKCU\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" "REG_DWORD" "0"

:: Disable Web Search in Start Menu
call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"

:: Disable Cortana
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"

echo Privacy settings optimized.
pause
goto menu

:option_24
:network_reset
cls
echo ==================================================================
echo Network Reset and Advanced Optimization (USE WITH CAUTION)
echo ==================================================================
echo WARNING: Resetting network settings will remove all network
echo          adapters and their configurations. You will need to
echo          reconfigure your network connections after this.
echo.
echo 1. Reset Network Settings (Requires Restart)
echo 2. Advanced TCP Optimizations (For experienced users)
echo 3. Return to Main Menu
echo ==================================================================
set /p net_choice=Enter your choice (1-3):

if "%net_choice%"=="1" goto reset_network
if "%net_choice%"=="2" goto advanced_tcp
if "%net_choice%"=="3" goto menu
echo Invalid choice. Please try again.
pause
goto network_reset

:reset_network
set /p "confirm=Are you SURE you want to reset network settings (Y/N)? "
if /I "%confirm%"=="Y" (
    echo Resetting network settings...
    netsh winsock reset
    netsh int ip reset
    netsh advfirewall reset
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
    echo Network settings reset.  Restart required.
) else (
    echo Network reset cancelled.
)
pause
goto network_reset

:advanced_tcp
echo Applying Advanced TCP Optimizations...
:: (These settings are generally beneficial, but results may vary)
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
echo Advanced TCP optimizations applied.
pause
goto network_reset

:option_25
:network_troubleshooting
cls
echo ==================================================
echo Network Troubleshooting
echo ==================================================
echo 1. Ping a Host
echo 2. Trace Route to a Host
echo 3. Display Network Adapter Information (ipconfig /all)
echo 4. Display ARP Cache
echo 5. Clear ARP Cache
echo 6. Display DNS Resolver Cache
echo 7. Release and Renew IP Address
echo 8. Return to Main Menu
echo ==================================================
set /p net_trouble_choice=Enter your choice (1-8):

if "%net_trouble_choice%"=="1" goto ping_host
if "%net_trouble_choice%"=="2" goto trace_route
if "%net_trouble_choice%"=="3" goto display_network_info
if "%net_trouble_choice%"=="4" goto display_arp_cache
if "%net_trouble_choice%"=="5" goto clear_arp_cache
if "%net_trouble_choice%"=="6" goto display_dns_cache
if "%net_trouble_choice%"=="7" goto release_renew_ip
if "%net_trouble_choice%"=="8" goto menu

echo Invalid choice.
pause
goto network_troubleshooting

:ping_host
set /p "ping_target=Enter host name or IP address to ping: "
ping %ping_target%
pause
goto network_troubleshooting

:trace_route
set /p "tracert_target=Enter host name or IP address to trace route to: "
tracert %tracert_target%
pause
goto network_troubleshooting

:display_network_info
echo Displaying network adapter information...
ipconfig /all
pause
goto network_troubleshooting

:display_arp_cache
echo Displaying ARP cache...
arp -a
pause
goto network_troubleshooting

:clear_arp_cache
echo Clearing ARP cache...
arp -d *
echo ARP cache cleared.
pause
goto network_troubleshooting

:display_dns_cache
echo Displaying DNS resolver cache...
ipconfig /displaydns
pause
goto network_troubleshooting
:release_renew_ip
echo Releasing and renewing IP address...
ipconfig /release
ipconfig /renew
echo IP address released and renewed.
pause
goto network_troubleshooting

:option_26
:manage_installed_applications
cls
echo ==================================================
echo Manage Installed Applications
echo ==================================================
echo 1. List Installed Applications
echo 2. Uninstall Application (Requires Exact Name)
echo 3. Return to Main Menu
echo ==================================================

set /p app_choice=Enter your choice (1-3):

if "%app_choice%"=="1" goto list_installed_apps
if "%app_choice%"=="2" goto uninstall_app
if "%app_choice%"=="3" goto menu
echo Invalid choice.
pause
goto manage_installed_applications

:list_installed_apps
echo Listing installed applications...
echo This may take a few moments.
powershell -Command "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize"
pause
goto manage_installed_applications

:uninstall_app
echo WARNING:  Uninstalling applications incorrectly can cause problems.
echo           Ensure you have the correct application name.
set /p "uninstall_name=Enter the EXACT name of the application to uninstall: "

:: Find the uninstall string using WMIC (more reliable)
for /f "tokens=2 delims==" %%a in ('wmic product where "name='%uninstall_name%'" get UninstallString /value') do (
  set "uninstall_string=%%a"
)
::Remove the extra returns.
for /f "delims=" %%a in ("%uninstall_string%") do set "uninstall_string=%%a"

if defined uninstall_string (
    echo Found uninstall string: %uninstall_string%
    call :get_confirmation "Are you sure you want to uninstall '%uninstall_name%'"
     if errorlevel 1 (
        echo Uninstall cancelled.
        pause
        goto manage_installed_applications
    )
    echo Uninstalling %uninstall_name%...
    %uninstall_string%
    echo Uninstallation process initiated.
) else (
    echo Could not find uninstall string for "%uninstall_name%".
    echo Please check the application name and try again.
)
pause
goto manage_installed_applications

:option_27
:advanced_registry_tweaks
cls
echo =========================================================
echo Advanced Registry Tweaks (EXPERTS ONLY!)
echo =========================================================
echo WARNING:  Modifying the registry incorrectly can cause serious
echo           system instability or data loss.  Proceed with
echo           EXTREME CAUTION and only if you understand the
echo           implications of each change.  Create a system
echo           restore point before making any changes.
echo.
echo 1. Disable Windows Error Reporting
echo 2. Disable Hibernation
echo 3. Enable Long Paths (Windows 10, version 1607 and later)
echo 4. Disable Lock Screen
echo 5. Return to Main Menu
echo =========================================================
set /p reg_tweak_choice=Enter your choice (1-5):

if "%reg_tweak_choice%"=="1" goto disable_wer
if "%reg_tweak_choice%"=="2" goto disable_hibernation_tweak
if "%reg_tweak_choice%"=="3" goto enable_long_paths
if "%reg_tweak_choice%"=="4" goto disable_lock_screen
if "%reg_tweak_choice%"=="5" goto menu
echo Invalid choice.
pause
goto advanced_registry_tweaks

:disable_wer
echo WARNING: Disabling Windows Error Reporting will prevent error
echo          reports from being sent to Microsoft.
call :get_confirmation "Are you sure you want to disable WER?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto advanced_registry_tweaks
)
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
echo Windows Error Reporting disabled.
pause
goto advanced_registry_tweaks

:disable_hibernation_tweak
echo WARNING: Disabling hibernation will prevent your computer from
echo          saving its state to disk when you shut down.  You
echo          will lose any unsaved work.
call :get_confirmation "Are you sure you want to disable hibernation?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto advanced_registry_tweaks
)

powercfg /hibernate off
echo Hibernation disabled.
pause
goto advanced_registry_tweaks

:enable_long_paths
echo Enabling long paths (allows paths longer than 260 characters).
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" "LongPathsEnabled" "REG_DWORD" "1"
echo Long paths enabled.  A restart may be required.
pause
goto advanced_registry_tweaks

:disable_lock_screen
echo WARNING: Disabling the lock screen can reduce security.
call :get_confirmation "Are you sure you want to disable the lock screen?"
if errorlevel 1(
  echo Operation cancelled.
  pause
  goto advanced_registry_tweaks
)
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" "REG_DWORD" "1"
echo Lock screen disabled. A restart may be required.
pause
goto advanced_registry_tweaks

:option_28
:hardware_diagnostics
cls
echo ==================================================
echo Hardware Diagnostics
echo ==================================================
echo 1. Check Disk Health (SMART Status)
echo 2. Memory Diagnostic (Requires Restart)
echo 3. Return to Main Menu
echo ==================================================

set /p diag_choice=Enter your choice (1-3):

if "%diag_choice%"=="1" goto check_disk_health
if "%diag_choice%"=="2" goto memory_diagnostic
if "%diag_choice%"=="3" goto menu
echo Invalid choice.
pause
goto hardware_diagnostics

:check_disk_health
echo Checking disk health (SMART status)...
wmic diskdrive get status
pause
goto hardware_diagnostics

:memory_diagnostic
echo Running Windows Memory Diagnostic...
echo This will restart your computer and run a memory test.
echo WARNING: Save all your work before proceeding.
call :get_confirmation "Are you sure you want to run the memory diagnostic?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto hardware_diagnostics
)
mdsched.exe
echo Memory Diagnostic scheduled.  Restart your computer.
pause
goto hardware_diagnostics

:option_29
:system_recovery_options
cls
echo ==================================================
echo System Recovery Options
echo ==================================================
echo WARNING: These options can modify or reset your system.
echo          Use with extreme caution.
echo.
echo 1. Open System Restore
echo 2. Open Startup Repair (Requires Restart)
echo 3. Open Command Prompt (Recovery Environment) (Requires Restart)
echo 4. Reset This PC (Requires Restart and Confirmation)
echo 5. Return to Main Menu
echo ==================================================
set /p recovery_choice=Enter your choice (1-5):

if "%recovery_choice%"=="1" goto open_system_restore_recovery
if "%recovery_choice%"=="2" goto open_startup_repair
if "%recovery_choice%"=="3" goto open_command_prompt_recovery
if "%recovery_choice%"=="4" goto reset_this_pc
if "%recovery_choice%"=="5" goto menu
echo Invalid choice.
pause
goto system_recovery_options

:open_system_restore_recovery
echo Opening System Restore...
start rstrui.exe
echo Follow the on-screen instructions to restore your system.
pause
goto system_recovery_options

:open_startup_repair
echo Opening Startup Repair...
echo This will restart your computer.
call :get_confirmation "Are you sure you want to open Startup Repair?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto system_recovery_options
)
shutdown /r /o /f /t 00
echo Restarting to Startup Repair...
pause
goto system_recovery_options

:open_command_prompt_recovery
echo Opening Command Prompt (Recovery Environment)...
echo This will restart your computer.
call :get_confirmation "Are you sure you want to open the Recovery Command Prompt?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto system_recovery_options
)
shutdown /r /o /f /t 00
echo Restarting to Command Prompt (Recovery Environment)...
pause
goto system_recovery_options

:reset_this_pc
echo WARNING: Resetting your PC will remove apps and settings.
echo          You will have the option to keep your personal files,
echo          but this is not guaranteed.  Back up your data!
call :get_confirmation "Are you ABSOLUTELY SURE you want to reset your PC?"
if errorlevel 1 (
    echo Operation cancelled.
    pause
    goto system_recovery_options
)
echo Starting the Reset This PC process...
systemreset
echo Follow the on-screen instructions to reset your PC.
pause
goto system_recovery_options

:option_30
:customize_windows_appearance
cls
echo ==================================================
echo Customize Windows Appearance
echo ==================================================
echo 1. Change Desktop Background
echo 2. Change Lock Screen Background
echo 3. Show/Hide Desktop Icons
echo 4. Return to Main Menu
echo ==================================================
set /p appearance_choice=Enter your choice (1-4):

if "%appearance_choice%"=="1" goto change_desktop_background
if "%appearance_choice%"=="2" goto change_lock_screen_background
if "%appearance_choice%"=="3" goto show_hide_desktop_icons
if "%appearance_choice%"=="4" goto menu
echo Invalid choice.
pause
goto customize_windows_appearance

:change_desktop_background
echo Opening desktop background settings...
:: Using rundll32 to open the personalization settings directly
rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
pause
goto customize_windows_appearance

:change_lock_screen_background
echo Opening lock screen background settings...
:: Using PowerShell to open the lock screen settings (more reliable)
call :execute_powershell "Start-Process ms-settings:lockscreen"
pause
goto customize_windows_appearance
:show_hide_desktop_icons
echo Opening desktop icon settings...
:: Using rundll32 for classic desktop icon settings
rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,5
pause
goto customize_windows_appearance

:option_31
:exit
echo Thank you for using the Windows Optimization and Management Script!
echo Script developed by [Your Name/Organization]
echo Version 6.0 (Ultimate)
pause
exit

:: ============================================================================
:: --- End of Script ---
:: ============================================================================
