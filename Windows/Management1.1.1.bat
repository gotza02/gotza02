@echo off

:: ============================================================================
:: Windows Optimization and Management Script - Comprehensive Edition (English)
:: ============================================================================
:: Author: [Your Name/Organization] (Adapted from original script)
:: Version: 5.0 (Comprehensive)
::
:: Description: This script provides an extensive set of tools to
::              optimize, maintain, configure, and troubleshoot Windows.
::              It is designed for speed, efficiency, and comprehensiveness.
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

:: ============================================================================
:: --- Main Menu ---
:: ============================================================================

:menu
cls
echo ================================================================
echo  Windows Optimization and Management Script v5.0 (Comprehensive)
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
echo   9. Manage User Accounts (NEW)
echo.
echo  [Maintenance]
echo  10. Clear System Cache
echo  11. Check and Repair System Files
echo  12. Clean Up Disk Space
echo  13. Advanced System Cleanup (NEW)
echo.
echo  [System Configuration]
echo  14. Manage Power Settings
echo  15. Enable/Disable Dark Mode
echo  16. System Information
echo  17. Backup and Restore Settings (System Restore)
echo  18. Manage Environment Variables (NEW)
echo.
echo  [Windows Activation]
echo 19. Windows Activation
echo.
echo  [Advanced]
echo  20. Manage Windows Services (Advanced Users Only)
echo  21. Optimize Privacy Settings
echo  22. Network Reset and Advanced Optimization
echo  23. Manage Installed Applications (NEW)
echo  24. Advanced Registry Tweaks (Experts Only!) (NEW)
echo  25. Hardware Diagnostics (NEW)
echo.
echo  26. Exit
echo ================================================================
set /p "choice=Enter your choice (1-26): "

:: Input validation
if not defined choice (
    echo Invalid choice. Please try again.
    pause
    goto menu
)

:: Check if choice is a number between 1 and 26
echo %choice%| findstr /r "^[1-9]$ ^1[0-9]$ ^2[0-6]$" >nul
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
echo 1. Set High Performance power plan
echo 2. Disable CPU Throttling (For advanced users)
echo 3. Optimize Processor Scheduling
echo 4. Enable Hardware-Accelerated GPU Scheduling (Requires Restart)
echo 5. Return to Main Menu
echo ==================================================
set /p cpu_choice=Enter your choice (1-5):

if "%cpu_choice%"=="1" goto set_high_performance
if "%cpu_choice%"=="2" goto disable_throttling
if "%cpu_choice%"=="3" goto optimize_scheduling
if "%cpu_choice%"=="4" goto enable_gpu_scheduling
if "%cpu_choice%"=="5" goto menu
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
echo WARNING: This may increase power consumption and heat.
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setactive scheme_current
echo CPU throttling disabled (both AC and DC).
pause
goto optimize_cpu

:optimize_scheduling
echo Optimizing Processor Scheduling for best performance of programs...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo Processor scheduling optimized.
pause
goto optimize_cpu

:enable_gpu_scheduling
echo Enabling Hardware-Accelerated GPU Scheduling...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling enabled.  Restart required.
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
echo 4. Return to Main Menu
echo ==================================================
set /p update_choice=Enter your choice (1-4):

if "%update_choice%"=="1" goto enable_windows_update
if "%update_choice%"=="2" goto disable_windows_update
if "%update_choice%"=="3" goto check_updates
if "%update_choice%"=="4" goto menu
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
:clear_cache
echo Clearing system cache...
del /f /s /q %TEMP%\*
del /f /s /q C:\Windows\Temp\*
echo System cache cleared.
pause
goto menu

:option_11
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

:option_12
:clean_disk
echo Running Disk Cleanup...
cleanmgr /sagerun:1  :: Use a predefined cleanup profile (create with cleanmgr /sageset:1)
echo Disk cleanup completed.
pause
goto menu

:option_13
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

:option_14
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

:option_15
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

:option_16
:system_info
echo Displaying system information...
systeminfo
pause
goto menu

:option_17
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

:option_18
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

:option_19
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

:option_20
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

:option_21
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

:option_22
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

:option_23
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

:option_24
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
echo 4. Return to Main Menu
echo =========================================================
set /p reg_tweak_choice=Enter your choice (1-4):

if "%reg_tweak_choice%"=="1" goto disable_wer
if "%reg_tweak_choice%"=="2" goto disable_hibernation_tweak
if "%reg_tweak_choice%"=="3" goto enable_long_paths
if "%reg_tweak_choice%"=="4" goto menu
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

:option_25
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

:option_26
:exit
echo Thank you for using the Windows Optimization and Management Script!
echo Script developed by [Your Name/Organization]
echo Version 5.0 (Comprehensive)
pause
exit
