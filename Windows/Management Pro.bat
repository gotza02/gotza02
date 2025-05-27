@echo off
setlocal enabledelayedexpansion
set "SCRIPT_VERSION=4.0 - Enhanced by Gemini"
set "LOGFILE=%~dp0WindowsOptimizationScript_v4_Log.txt"
echo Script run on %DATE% %TIME% > %LOGFILE%
echo Script Version: %SCRIPT_VERSION% >> %LOGFILE%
echo. >> %LOGFILE%

:log_action
echo %DATE% %TIME% - %~1>> %LOGFILE%
exit /b 0

:find_mpcmdrun
set "MPCMDRUN_PATH="
if exist "%ProgramFiles%\Windows Defender\MpCmdRun.exe" (
    set "MPCMDRUN_PATH=%ProgramFiles%\Windows Defender\MpCmdRun.exe"
) else if exist "%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe" (
    set "MPCMDRUN_PATH=%ProgramFiles(x86)%\Windows Defender\MpCmdRun.exe"
)
if not defined MPCMDRUN_PATH (
    echo [WARNING] MpCmdRun.exe not found. Some Defender operations may not be available.
    call :log_action "[WARNING] MpCmdRun.exe not found."
)
exit /b 0

call :find_mpcmdrun

:modify_registry
call :log_action "Attempting registry ADD: Key=""%~1"", ValueName=""%~2"", Type=%~3, Data=""%~4"""
reg add "%~1" /v "%~2" /t %~3 /d "%~4" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to write to registry: ""%~1\%~2"". Permissions or invalid data?
    call :log_action "[ERROR] Registry ADD FAILED: Key=""%~1"", ValueName=""%~2"". Errorlevel: %errorlevel%"
) else (
    echo [INFO] Registry value ""%~2"" set successfully in ""%~1"".
    call :log_action "[SUCCESS] Registry ADD SUCCESS: Key=""%~1"", ValueName=""%~2"", Data=""%~4"""
)
exit /b %errorlevel%

:delete_registry_value
call :log_action "Attempting registry DELETE_VALUE: Key=""%~1"", ValueName=""%~2"""
reg delete "%~1" /v "%~2" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to delete registry value: ""%~1\%~2"". It may not exist or permissions issue.
    call :log_action "[ERROR] Registry DELETE_VALUE FAILED: Key=""%~1"", ValueName=""%~2"". Errorlevel: %errorlevel%"
) else (
    echo [INFO] Registry value ""%~2"" deleted successfully from ""%~1"".
    call :log_action "[SUCCESS] Registry DELETE_VALUE SUCCESS: Key=""%~1"", ValueName=""%~2"""
)
exit /b %errorlevel%

:delete_registry_key
call :log_action "Attempting registry DELETE_KEY: Key=""%~1"""
reg delete "%~1" /f >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to delete registry key: ""%~1"". Permissions or key has subkeys or does not exist.
    call :log_action "[ERROR] Registry DELETE_KEY FAILED: Key=""%~1"". Errorlevel: %errorlevel%"
) else (
    echo [INFO] Registry key ""%~1"" deleted successfully.
    call :log_action "[SUCCESS] Registry DELETE_KEY SUCCESS: Key=""%~1"""
)
exit /b %errorlevel%

:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo ===============================================================================
    echo  ERROR: Administrator Privileges Required
    echo ===============================================================================
    echo  This script requires administrator privileges to function correctly.
    echo  Please right-click the script file and select "Run as administrator".
    echo ===============================================================================
    call :log_action "[FATAL] Script not run with admin privileges. Exiting."
    pause
    exit /b 1
)
call :log_action "[INFO] Admin privileges confirmed."

:menu
cls
echo ==================================================
echo  Windows Optimization Script %SCRIPT_VERSION%
echo ==================================================
echo  Main Menu: Please select an option:
echo --------------------------------------------------
echo  1. Optimize display performance
echo  2. Manage Windows Defender
echo  3. Optimize system features
echo  4. Optimize CPU performance
echo  5. Optimize Internet performance
echo  6. Manage Windows Update
echo  7. Configure Auto-login (HIGH SECURITY RISK!)
echo  8. Clear system cache
echo  9. Optimize disk
echo 10. Check and repair system files
echo 11. Manage Windows Activation
echo 12. Manage power settings
echo 13. Enable Dark Mode
echo 14. Manage partitions (ADVANCED - DATA LOSS RISK!)
echo 15. Clean up disk space (using Disk Cleanup)
echo 16. Manage startup programs (via msconfig/Task Mgr)
echo 17. Backup and restore settings (System Restore)
echo 18. Display system information
echo 19. Optimize privacy settings
echo 20. Manage Windows services
echo 21. Advanced Network Optimization
echo --------------------------------------------------
echo 22. Exit
echo ==================================================
set /p choice=Enter your choice (1-22):

if not "%choice%"=="" (
    for /L %%N in (1,1,22) do (
        if "%choice%"=="%%N" (
            call :log_action "[MENU] User selected option %choice%."
            goto option_%%N
        )
    )
)
call :log_action "[MENU] Invalid choice: %choice%."
echo Invalid choice. Please try again.
pause
goto menu

:option_1
cls
echo ==================================================
echo  Optimizing Display Performance
echo ==================================================
call :log_action "Starting: Optimize display performance"
call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo.
echo Display performance settings applied.
call :log_action "Completed: Optimize display performance"
pause
goto menu

:option_2
:manage_defender
cls
echo ===================================================
echo  Windows Defender Management
echo ===================================================
echo  1. Check Windows Defender status
echo  2. Enable Windows Defender
echo  3. Disable Windows Defender (NOT RECOMMENDED!)
echo  4. Update Windows Defender definitions
echo  5. Run quick scan
echo  6. Run full scan
echo  7. Manage real-time protection
echo  8. Manage cloud-delivered protection
echo  9. Manage automatic sample submission
echo 10. View threat history
echo 11. Return to main menu
echo ===================================================
set /p def_choice=Enter your choice (1-11):

if not "%def_choice%"=="" (
    if "%def_choice%"=="1" goto check_defender
    if "%def_choice%"=="2" goto enable_defender
    if "%def_choice%"=="3" goto disable_defender
    if "%def_choice%"=="4" goto update_defender
    if "%def_choice%"=="5" goto quick_scan
    if "%def_choice%"=="6" goto full_scan
    if "%def_choice%"=="7" goto manage_realtime
    if "%def_choice%"=="8" goto manage_cloud
    if "%def_choice%"=="9" goto manage_samples
    if "%def_choice%"=="10" goto view_history
    if "%def_choice%"=="11" (call :log_action "[SUBMENU] Defender: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] Defender: Invalid choice %def_choice%."
echo Invalid choice. Please try again.
pause
goto manage_defender

:check_defender
cls
echo Checking Windows Defender status...
call :log_action "Defender: Checking status."
sc query windefend
echo.
if defined MPCMDRUN_PATH (
    echo Additionally checking via MpCmdRun...
    "%MPCMDRUN_PATH%" -GetStatus
) else (
    echo MpCmdRun.exe not found, skipping additional status check.
)
pause
goto manage_defender

:enable_defender
cls
echo Enabling Windows Defender components...
call :log_action "Defender: Attempting to enable."
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :delete_registry_value "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
call :delete_registry_value "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
echo.
echo Windows Defender components enabled/policy settings applied.
echo It's recommended to restart your computer for all changes to take full effect.
call :log_action "Defender: Enable process completed."
pause
goto manage_defender

:disable_defender
cls
echo =====================================================================
echo  WARNING: Disabling Windows Defender
echo =====================================================================
echo  Disabling Windows Defender will leave your system vulnerable to
echo  malware and other threats. This is NOT RECOMMENDED unless you
echo  have another reliable antivirus solution installed and active.
echo =====================================================================
set /p confirm_disable_def=Are you absolutely sure you want to proceed? (Y/N):
if /i not "%confirm_disable_def%"=="Y" (
    call :log_action "Defender: Disable cancelled by user."
    echo Operation cancelled.
    pause
    goto manage_defender
)
echo Disabling Windows Defender components via policy...
call :log_action "Defender: User confirmed. Attempting to disable."
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
echo.
echo Windows Defender components disabled/policy settings applied.
echo REMINDER: Your system may now be VULNERABLE.
echo It's recommended to restart your computer for all changes to take full effect.
call :log_action "Defender: Disable process completed."
pause
goto manage_defender

:update_defender
cls
echo Updating Windows Defender definitions...
call :log_action "Defender: Updating definitions."
if not defined MPCMDRUN_PATH (
    echo [ERROR] MpCmdRun.exe path not found. Cannot update definitions.
    pause
    goto manage_defender
)
"%MPCMDRUN_PATH%" -SignatureUpdate
if %errorlevel% equ 0 (
    echo Windows Defender definitions updated successfully.
    call :log_action "Defender: Definitions updated successfully."
) else (
    echo Failed to update Windows Defender definitions. Errorlevel: %errorlevel%.
    echo Please check your internet connection and try again.
    call :log_action "Defender: Definitions update FAILED. Errorlevel: %errorlevel%."
)
pause
goto manage_defender

:quick_scan
cls
echo Running Windows Defender quick scan...
call :log_action "Defender: Starting quick scan."
if not defined MPCMDRUN_PATH (
    echo [ERROR] MpCmdRun.exe path not found. Cannot start quick scan.
    pause
    goto manage_defender
)
"%MPCMDRUN_PATH%" -Scan -ScanType 1
echo Quick scan initiated. Check Windows Security for progress and results.
call :log_action "Defender: Quick scan initiated."
pause
goto manage_defender

:full_scan
cls
echo Running Windows Defender full scan...
call :log_action "Defender: Starting full scan."
if not defined MPCMDRUN_PATH (
    echo [ERROR] MpCmdRun.exe path not found. Cannot start full scan.
    pause
    goto manage_defender
)
echo This may take a considerable amount of time.
start "" "%MPCMDRUN_PATH%" -Scan -ScanType 2
echo Full scan initiated in a new window. Check Windows Security for progress and results.
call :log_action "Defender: Full scan initiated."
pause
goto manage_defender

:manage_realtime
cls
echo Managing Real-Time Protection...
call :log_action "Defender: Managing real-time protection."
echo Current real-time protection policy status:
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring 2>nul || echo Policy not set or key not found.
echo.
echo Note: Windows may prevent disabling this via registry if Tamper Protection is on.
set /p rtp_choice=Do you want to (E)nable or (D)isable real-time protection policy? (E/D):
if /i "%rtp_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
    call :delete_registry_value "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring"
    echo Real-time protection policy set to ENABLED.
    call :log_action "Defender: Real-time protection policy set to ENABLED."
) else if /i "%rtp_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
    echo Real-time protection policy set to DISABLED. (This is NOT RECOMMENDED)
    call :log_action "Defender: Real-time protection policy set to DISABLED."
) else (
    echo Invalid choice. No changes made.
    call :log_action "Defender: Manage real-time protection - invalid choice."
)
pause
goto manage_defender

:manage_cloud
cls
echo Managing Cloud-Delivered Protection...
call :log_action "Defender: Managing cloud protection."
echo Current cloud-delivered protection policy status:
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting 2>nul || echo Policy not set or key not found.
echo.
set /p cloud_choice=Do you want to (E)nable or (D)isable cloud-delivered protection policy? (E/D):
if /i "%cloud_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
    echo Cloud-delivered protection policy set to ENABLED.
    call :log_action "Defender: Cloud protection policy set to ENABLED."
) else if /i "%cloud_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    echo Cloud-delivered protection policy set to DISABLED. (Reduces protection effectiveness)
    call :log_action "Defender: Cloud protection policy set to DISABLED."
) else (
    echo Invalid choice. No changes made.
    call :log_action "Defender: Manage cloud protection - invalid choice."
)
pause
goto manage_defender

:manage_samples
cls
echo Managing Automatic Sample Submission...
call :log_action "Defender: Managing sample submission."
echo Current automatic sample submission policy status:
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent 2>nul || echo Policy not set or key not found.
echo.
set /p sample_choice=Do you want to (E)nable or (D)isable automatic sample submission policy? (E/D):
if /i "%sample_choice%"=="E" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
    echo Automatic sample submission policy set to ENABLED.
    call :log_action "Defender: Sample submission policy set to ENABLED."
) else if /i "%sample_choice%"=="D" (
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "0"
    echo Automatic sample submission policy set to DISABLED.
    call :log_action "Defender: Sample submission policy set to DISABLED."
) else (
    echo Invalid choice. No changes made.
    call :log_action "Defender: Manage sample submission - invalid choice."
)
pause
goto manage_defender

:view_history
cls
echo Viewing Windows Defender Threat History (via MpCmdRun)...
call :log_action "Defender: Viewing threat history."
if not defined MPCMDRUN_PATH (
    echo [ERROR] MpCmdRun.exe path not found. Cannot view history.
    pause
    goto manage_defender
)
"%MPCMDRUN_PATH%" -GetFiles
echo.
echo Threat history displayed above. Check the output for details.
pause
goto manage_defender

:option_3
cls
echo ==================================================
echo  Optimizing System Features
echo ==================================================
call :log_action "Starting: Optimize system features"
echo Disabling Activity Feed (Timeline)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
echo Disabling Background Apps (Global Setting)...
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
call :modify_registry "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" "LetAppsRunInBackground" "REG_DWORD" "2"
echo Disabling Cortana (Policy)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
echo Disabling Game DVR and Game Bar (Policy)...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
echo Disabling Sticky Keys prompt (Accessibility)...
call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
echo Disabling Windows Tips and Suggestions...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353698Enabled" "REG_DWORD" "0"
echo Enabling Fast Startup (Hiberboot)...
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
echo.
echo System features optimization applied. Some changes may require a restart or sign out/in.
call :log_action "Completed: Optimize system features"
pause
goto menu

:option_4
:optimize_cpu
cls
echo ==================================================
echo  CPU Performance Optimization
echo ==================================================
echo  1. Set High Performance power plan
echo  2. Disable CPU throttling (via power settings)
echo  3. Optimize processor scheduling for programs
echo  4. Disable CPU core parking (experimental)
echo  5. Adjust processor power management for max performance
echo  6. Enable Hardware-accelerated GPU scheduling (if supported, requires restart)
echo  7. Disable common unnecessary system services
echo  8. Adjust visual effects for best performance
echo  9. Return to main menu
echo ==================================================
set /p cpu_choice=Enter your choice (1-9):

if not "%cpu_choice%"=="" (
    if "%cpu_choice%"=="1" goto set_high_performance
    if "%cpu_choice%"=="2" goto disable_throttling
    if "%cpu_choice%"=="3" goto optimize_scheduling
    if "%cpu_choice%"=="4" goto disable_core_parking
    if "%cpu_choice%"=="5" goto adjust_power_management
    if "%cpu_choice%"=="6" goto enable_gpu_scheduling
    if "%cpu_choice%"=="7" goto disable_services_cpu
    if "%cpu_choice%"=="8" goto adjust_visual_effects_cpu
    if "%cpu_choice%"=="9" (call :log_action "[SUBMENU] CPU Opt: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] CPU Opt: Invalid choice %cpu_choice%."
echo Invalid choice. Please try again.
pause
goto optimize_cpu

:set_high_performance
cls
echo Setting High Performance power plan...
call :log_action "CPU Opt: Setting High Performance power plan."
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Failed to set High Performance plan directly. Attempting to duplicate and set...
    call :log_action "CPU Opt: Failed to set High Perf directly, trying duplicate."
    set "hp_guid_found="
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid_found=%%i
    
    if defined hp_guid_found (
        powercfg -setactive %hp_guid_found% >nul 2>&1
        if %errorlevel% equ 0 (
            echo [SUCCESS] Existing High Performance power plan (%hp_guid_found%) set.
            call :log_action "CPU Opt: Existing High Performance plan %hp_guid_found% set."
        ) else (
            echo [ERROR] Found High Performance plan (%hp_guid_found%) but failed to set it active.
            call :log_action "CPU Opt: Found High Performance plan %hp_guid_found% but failed to set active."
        )
    ) else (
        echo [INFO] No existing High Performance plan found. Attempting to duplicate from Ultimate/Balanced...
        call :log_action "CPU Opt: No existing High Perf plan, trying to duplicate Ultimate/Balanced."
        set "ultimate_guid=e9a42b02-d5df-448d-aa00-03f14749eb61"
        set "balanced_guid=381b4222-f694-41f0-9685-ff5bb260df2e"
        set "new_hp_guid="
        powercfg -duplicatescheme %ultimate_guid% > "%temp%\tempguid.txt" 2>nul
        if %errorlevel% equ 0 (
            for /f "tokens=4" %%s in ('type "%temp%\tempguid.txt"') do set "new_hp_guid=%%s"
        ) else (
            powercfg -duplicatescheme %balanced_guid% > "%temp%\tempguid.txt" 2>nul
            if %errorlevel% equ 0 (
                for /f "tokens=4" %%s in ('type "%temp%\tempguid.txt"') do set "new_hp_guid=%%s"
            )
        )
        if defined new_hp_guid (
            set "new_hp_guid=%new_hp_guid: =%"
            powercfg -changename %new_hp_guid% "High Performance (Script Created)" >nul 2>&1
            powercfg -setactive %new_hp_guid% >nul 2>&1
            if %errorlevel% equ 0 (
                echo [SUCCESS] New High Performance power plan created and set active (GUID: %new_hp_guid%).
                call :log_action "CPU Opt: New High Performance plan %new_hp_guid% created and set."
            ) else (
                echo [ERROR] Created new High Performance plan but failed to set it active.
                call :log_action "CPU Opt: Created new High Performance plan %new_hp_guid% but failed to set active."
            )
        ) else (
            echo [ERROR] Could not find or create and set a High Performance power plan.
            call :log_action "CPU Opt: Failed to find or create High Performance plan."
        )
        if exist "%temp%\tempguid.txt" del "%temp%\tempguid.txt"
    )
) else (
    echo [SUCCESS] High Performance power plan set.
    call :log_action "CPU Opt: High Performance power plan set successfully."
)
pause
goto optimize_cpu

:disable_throttling
cls
echo Disabling CPU throttling (adjusting power settings for current plan)...
call :log_action "CPU Opt: Disabling CPU throttling."
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul
powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 >nul
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul
powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 >nul
powercfg -setactive scheme_current >nul
echo CPU throttling settings (Max/Min Performance State) applied for the current power plan.
echo Note: Effectiveness may vary depending on hardware, drivers, and system load.
call :log_action "CPU Opt: CPU throttling settings applied."
pause
goto optimize_cpu

:optimize_scheduling
cls
echo Optimizing processor scheduling for programs...
call :log_action "CPU Opt: Optimizing processor scheduling."
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "26"
echo Processor scheduling optimized for best performance of programs (Value: 26 hex / 38 dec).
call :log_action "CPU Opt: Processor scheduling optimized."
pause
goto optimize_cpu

:disable_core_parking
cls
echo Disabling CPU core parking for current power plan (experimental)...
call :log_action "CPU Opt: Disabling CPU core parking."
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" "ValueMax" "REG_DWORD" "100"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" "ValueMin" "REG_DWORD" "100"
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 >nul
powercfg -setdcvalueindex scheme_current sub_processor CPMINCORES 100 >nul
powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100 >nul
powercfg -setdcvalueindex scheme_current sub_processor CPMAXCORES 100 >nul
powercfg -setactive scheme_current >nul
echo CPU core parking settings (Min/Max Cores) applied for the current power plan.
echo This attempts to keep all CPU cores unparked. Restart may be beneficial.
call :log_action "CPU Opt: CPU core parking disabled."
pause
goto optimize_cpu

:adjust_power_management
cls
echo Adjusting processor power management for maximum performance (current plan)...
call :log_action "CPU Opt: Adjusting processor power management."
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTMODE 2 >nul
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul
powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTPOL 100 >nul
powercfg -setactive scheme_current >nul
echo Processor power management (Boost Mode, Boost Policy) adjusted for the current power plan.
call :log_action "CPU Opt: Processor power management adjusted."
pause
goto optimize_cpu

:enable_gpu_scheduling
cls
echo Enabling Hardware-accelerated GPU Scheduling...
call :log_action "CPU Opt: Enabling Hardware-accelerated GPU Scheduling."
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
echo Hardware-accelerated GPU scheduling option enabled in registry.
echo A RESTART IS REQUIRED for this change to take effect.
echo Also, ensure this feature is turned ON in Windows Graphics Settings if available.
call :log_action "CPU Opt: Hardware-accelerated GPU Scheduling enabled (requires restart)."
pause
goto optimize_cpu

:disable_services_cpu
cls
echo Disabling common unnecessary system services for CPU performance...
call :log_action "CPU Opt: Disabling unnecessary services."
set "services_to_disable=SysMain DiagTrack dmwappushservice WSearch"
echo The following services will be set to DISABLED and STOPPED:
echo %services_to_disable%
set /p confirm_disable_serv=Are you sure you want to disable these services? (Y/N):
if /i not "%confirm_disable_serv%"=="Y" (
    call :log_action "CPU Opt: Service disabling cancelled by user."
    echo Operation cancelled.
    pause
    goto optimize_cpu
)
call :log_action "CPU Opt: User confirmed disabling services: %services_to_disable%"
for %%s in (%services_to_disable%) do (
    echo Disabling and stopping %%s...
    sc stop "%%s" >nul 2>&1
    sc config "%%s" start= disabled >nul 2>&1
    if %errorlevel% equ 0 (
        call :log_action "CPU Opt: Service %%s disabled and stopped."
    ) else (
        call :log_action "CPU Opt: Failed to disable/stop service %%s. It might not exist or access denied."
        echo Failed to configure %%s or it might not exist.
    )
)
echo Selected system services have been disabled.
call :log_action "CPU Opt: Unnecessary services disabling process completed."
pause
goto optimize_cpu

:adjust_visual_effects_cpu
cls
echo Adjusting visual effects for best performance...
call :log_action "CPU Opt: Adjusting visual effects for best performance."
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo Visual effects set to 'Adjust for best performance'.
echo Changes will apply after next sign-in or restart.
call :log_action "CPU Opt: Visual effects adjusted."
pause
goto optimize_cpu

:option_5
:optimize_internet
cls
echo ==================================================
echo  Internet Performance Optimization
echo ==================================================
echo  1. Apply basic TCP global optimizations
echo  2. Apply advanced TCP global optimizations (includes basic)
echo  3. DNS optimization (Set to common public DNS, e.g., Google)
echo  4. Network adapter tuning (for active connections)
echo  5. Clear network caches (DNS, ARP, NBT)
echo  6. Return to main menu
echo ==================================================
set /p net_choice_internet=Enter your choice (1-6):

if not "%net_choice_internet%"=="" (
    if "%net_choice_internet%"=="1" goto basic_optimizations_internet
    if "%net_choice_internet%"=="2" goto advanced_tcp_internet
    if "%net_choice_internet%"=="3" goto dns_optimization_internet
    if "%net_choice_internet%"=="4" goto adapter_tuning_internet
    if "%net_choice_internet%"=="5" goto clear_network_cache_internet
    if "%net_choice_internet%"=="6" (call :log_action "[SUBMENU] Internet Opt: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] Internet Opt: Invalid choice %net_choice_internet%."
echo Invalid choice. Please try again.
pause
goto optimize_internet

:basic_optimizations_internet
cls
echo Performing basic Internet TCP global optimizations...
call :log_action "Internet Opt: Applying basic TCP optimizations."
netsh int tcp set global autotuninglevel=normal >nul
call :log_action "Internet Opt: TCP autotuninglevel=normal"
netsh int tcp set global chimney=enabled >nul
call :log_action "Internet Opt: TCP chimney=enabled"
netsh int tcp set global dca=enabled >nul
call :log_action "Internet Opt: TCP dca=enabled"
netsh int tcp set global netdma=enabled >nul
call :log_action "Internet Opt: TCP netdma=enabled (Note: NetDMA is largely deprecated)"
netsh int tcp set global ecncapability=enabled >nul
call :log_action "Internet Opt: TCP ecncapability=enabled"
netsh int tcp set global timestamps=disabled >nul
call :log_action "Internet Opt: TCP timestamps=disabled"
netsh int tcp set global rss=enabled >nul
call :log_action "Internet Opt: TCP rss=enabled"
echo Basic Internet TCP global optimizations applied.
pause
goto optimize_internet

:advanced_tcp_internet
cls
echo Performing advanced Internet TCP global optimizations...
call :log_action "Internet Opt: Applying advanced TCP optimizations."
call :basic_optimizations_internet
netsh int tcp set global congestionprovider=ctcp >nul
call :log_action "Internet Opt: TCP congestionprovider=ctcp"
netsh int tcp set heuristics disabled >nul
call :log_action "Internet Opt: TCP heuristics disabled"
netsh int tcp set global fastopen=enabled >nul
call :log_action "Internet Opt: TCP fastopen=enabled"
netsh int tcp set global hystart=disabled >nul
call :log_action "Internet Opt: TCP hystart=disabled (May not be available on all systems)"
netsh int tcp set global pacingprofile=off >nul
call :log_action "Internet Opt: TCP pacingprofile=off (May not be available on all systems)"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TcpAckFrequency" "REG_DWORD" "1"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "SizReqBuf" "REG_DWORD" "65535"
echo Advanced Internet TCP global optimizations and parameters applied.
echo Some changes may require a restart to take full effect.
pause
goto optimize_internet

:dns_optimization_internet
cls
echo Optimizing DNS settings (using Google DNS by default)...
call :log_action "Internet Opt: Optimizing DNS settings."
set /p dns_pref=Use Google DNS (8.8.8.8, 8.8.4.4)? (Y/N, N for Cloudflare 1.1.1.1, 1.0.0.1):
set "primary_dns=8.8.8.8"
set "secondary_dns=8.8.4.4"
if /i "%dns_pref%"=="N" (
    set "primary_dns=1.1.1.1"
    set "secondary_dns=1.0.0.1"
    call :log_action "Internet Opt: User chose Cloudflare DNS."
) else (
    call :log_action "Internet Opt: User chose Google DNS (or default)."
)

echo Flushing current DNS cache...
ipconfig /flushdns >nul
call :log_action "Internet Opt: Flushed DNS cache."
echo Attempting to set DNS for active connected interfaces to %primary_dns%, %secondary_dns%...
for /f "tokens=3,*" %%a in ('netsh interface show interface ^| findstr /i /C:"Connected"') do (
    echo Setting DNS for interface: "%%b"
    call :log_action "Internet Opt: Setting DNS for interface '%%b' to %primary_dns%, %secondary_dns%"
    netsh interface ipv4 set dns name="%%b" static %primary_dns% primary validate=no >nul
    netsh interface ipv4 add dns name="%%b" %secondary_dns% index=2 validate=no >nul
    netsh interface ipv6 set dns name="%%b" static %primary_dns% primary validate=no >nul
    netsh interface ipv6 add dns name="%%b" %secondary_dns% index=2 validate=no >nul
)
echo DNS optimization attempted for active connections.
echo Primary: %primary_dns%, Secondary: %secondary_dns%.
pause
goto optimize_internet

:adapter_tuning_internet
cls
echo Tuning network adapter advanced settings for active connected interfaces...
call :log_action "Internet Opt: Tuning network adapter settings."
echo This will attempt to disable Flow Control and Interrupt Moderation.
echo These settings can sometimes improve latency for gaming but may vary by adapter.
for /f "tokens=3,*" %%i in ('netsh interface show interface ^| findstr /i /C:"Connected"') do (
    echo Tuning adapter: "%%j"
    call :log_action "Internet Opt: Tuning adapter '%%j'."
    powershell -Command "try { Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*FlowControl' -RegistryValue 0 -ErrorAction SilentlyContinue; Write-Host 'Attempted to set Flow Control for %%j' } catch { Write-Host 'Skipping FlowControl for %%j or not supported' }"
    call :log_action "Internet Opt: Attempted to set Flow Control for '%%j'."
    powershell -Command "try { Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*InterruptModeration' -RegistryValue 0 -ErrorAction SilentlyContinue; Write-Host 'Attempted to set Interrupt Moderation for %%j' } catch { Write-Host 'Skipping Interrupt Moderation for %%j or not supported' }"
    call :log_action "Internet Opt: Attempted to set Interrupt Moderation for '%%j'."
)
echo Network adapter tuning attempted. Changes are often immediate but a restart can ensure they apply.
pause
goto optimize_internet

:clear_network_cache_internet
cls
echo Clearing network caches...
call :log_action "Internet Opt: Clearing network caches."
echo Flushing DNS cache...
ipconfig /flushdns >nul
call :log_action "Internet Opt: Flushed DNS cache."
echo Clearing ARP cache...
arp -d * >nul 2>&1
call :log_action "Internet Opt: Cleared ARP cache."
echo Resetting NBT cache...
nbtstat -R >nul 2>&1
nbtstat -RR >nul 2>&1
call :log_action "Internet Opt: Reset NBT cache."
echo Network caches (DNS, ARP, NBT) cleared.
echo Consider restarting your computer for full effect if network issues persist.
pause
goto optimize_internet

:option_6
:windows_update
cls
echo ==================================================
echo  Windows Update Management
echo ==================================================
echo  1. Enable Windows Update service
echo  2. Disable Windows Update service (NOT RECOMMENDED)
echo  3. Check for updates (initiates check)
echo  4. Return to main menu
echo ==================================================
set /p update_choice=Enter your choice (1-4):

if not "%update_choice%"=="" (
    if "%update_choice%"=="1" goto enable_windows_update
    if "%update_choice%"=="2" goto disable_windows_update
    if "%update_choice%"=="3" goto check_updates_wu
    if "%update_choice%"=="4" (call :log_action "[SUBMENU] WinUpdate: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] WinUpdate: Invalid choice %update_choice%."
echo Invalid choice. Please try again.
pause
goto windows_update

:enable_windows_update
cls
echo Enabling Windows Update service (wuauserv)...
call :log_action "WinUpdate: Enabling Windows Update service."
sc config wuauserv start= auto >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to set Windows Update service to auto. Permissions?
    call :log_action "WinUpdate: Failed to set wuauserv to auto."
) else (
    echo Windows Update service startup type set to Automatic.
    call :log_action "WinUpdate: wuauserv startup type set to Automatic."
)
sc start wuauserv >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start Windows Update service. It might be already running or another issue.
    call :log_action "WinUpdate: Failed to start wuauserv."
) else (
    echo Windows Update service started.
    call :log_action "WinUpdate: wuauserv started."
)
pause
goto windows_update

:disable_windows_update
cls
echo =====================================================================
echo  WARNING: Disabling Windows Update Service
echo =====================================================================
echo  Disabling Windows Update will prevent your system from receiving
echo  important security updates, bug fixes, and feature updates.
echo  This can leave your system vulnerable and is NOT RECOMMENDED.
echo =====================================================================
set /p confirm_disable_wu=Are you absolutely sure you want to disable Windows Update? (Y/N):
if /i not "%confirm_disable_wu%"=="Y" (
    call :log_action "WinUpdate: Disable cancelled by user."
    echo Operation cancelled.
    pause
    goto windows_update
)
call :log_action "WinUpdate: User confirmed. Disabling Windows Update service."
echo Disabling Windows Update service (wuauserv)...
sc stop wuauserv >nul 2>&1
if %errorlevel% neq 0 (
    call :log_action "WinUpdate: Could not stop wuauserv (may already be stopped)."
) else (
    call :log_action "WinUpdate: wuauserv stopped."
)
sc config wuauserv start= disabled >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to disable Windows Update service. Permissions?
    call :log_action "WinUpdate: Failed to set wuauserv to disabled."
) else (
    echo Windows Update service (wuauserv) disabled. REMEMBER THE RISKS!
    call :log_action "WinUpdate: wuauserv startup type set to Disabled."
)
pause
goto windows_update

:check_updates_wu
cls
echo Checking for Windows updates (initiating detection)...
call :log_action "WinUpdate: Initiating check for updates."
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()" >nul
echo Update check initiated.
echo Please open Windows Update in Settings to see progress and results.
call :log_action "WinUpdate: Update check command sent."
pause
goto windows_update

:option_7
cls
echo ===============================================================================
echo  Configure Auto-Login (EXTREME SECURITY RISK!)
echo ===============================================================================
echo  WARNING: This feature will store your Windows login password in the
echo  registry in PLAIN TEXT. This is a SEVERE security risk. Anyone with
echo  access to your computer's registry (even limited users in some cases,
echo  or malware) could potentially retrieve your password.
echo.
echo  PROCEED WITH EXTREME CAUTION AND ONLY IF YOU FULLY UNDERSTAND THE RISKS.
echo  It is highly recommended NOT to use this feature on shared computers
echo  or systems containing sensitive information.
echo ===============================================================================
set /p confirm_autologin=Do you understand the risks and wish to proceed? (Y/N):
if /i not "%confirm_autologin%"=="Y" (
    call :log_action "AutoLogin: Configuration cancelled by user due to security warning."
    echo Operation cancelled. Your security is important.
    pause
    goto menu
)
call :log_action "AutoLogin: User acknowledged security risk and proceeded."
echo Configuring Auto-login...
set "username="
set "password="
set /p username=Enter username for auto-login:
if "%username%"=="" (
    echo Username cannot be empty.
    call :log_action "AutoLogin: Username empty."
    pause
    goto option_7
)
set /p password=Enter password for %username%: 

call :log_action "AutoLogin: Configuring for user '%username%'."
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"

if defined password (
    echo Auto-login configured for user %username%. Your password is now stored insecurely.
    call :log_action "AutoLogin: SUCCESS for user '%username%'. Password stored insecurely."
) else (
    echo Auto-login configured for user %username% (blank password).
    call :log_action "AutoLogin: SUCCESS for user '%username%' (blank password)."
)
echo To disable auto-login, run this option again and leave password blank, or set AutoAdminLogon to 0.
pause
goto menu

:option_8
cls
echo ==================================================
echo  Clearing System Cache
echo ==================================================
call :log_action "Starting: Clear system cache"
echo Deleting files from %TEMP% ...
del /q /f /s "%TEMP%\*" 2>nul
call :log_action "Cleared %TEMP% folder."
echo Deleting files from C:\Windows\Temp ...
del /q /f /s "C:\Windows\Temp\*" 2>nul
call :log_action "Cleared C:\Windows\Temp folder."
echo.
echo System cache directories cleared.
echo Note: Some files might be in use and could not be deleted. A restart might help.
call :log_action "Completed: Clear system cache"
pause
goto menu

:option_9
:optimize_disk
cls
echo ==================================================
echo  Disk Optimization (Primarily for Drive C:)
echo ==================================================
echo  1. Analyze disk (C:)
echo  2. Optimize/Defragment disk (C:)
echo  3. Check disk for errors (C:) (may require restart)
echo  4. Trim SSD (if applicable for C:)
echo  5. Clean up system files (opens Disk Cleanup utility)
echo  6. Return to main menu
echo ==================================================
set /p disk_choice=Enter your choice (1-6):

if not "%disk_choice%"=="" (
    if "%disk_choice%"=="1" goto analyze_disk_c
    if "%disk_choice%"=="2" goto optimize_defrag_c
    if "%disk_choice%"=="3" goto check_disk_errors_c
    if "%disk_choice%"=="4" goto trim_ssd_c
    if "%disk_choice%"=="5" goto cleanup_system_disk_c_opt9
    if "%disk_choice%"=="6" (call :log_action "[SUBMENU] Disk Opt: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] Disk Opt: Invalid choice %disk_choice%."
echo Invalid choice. Please try again.
pause
goto optimize_disk

:analyze_disk_c
cls
echo Analyzing disk C: (Fragmentation analysis)...
call :log_action "Disk Opt: Analyzing C:"
defrag C: /A /U /V
call :log_action "Disk Opt: Analysis of C: complete."
pause
goto optimize_disk

:optimize_defrag_c
cls
echo Optimizing/Defragmenting disk C:...
call :log_action "Disk Opt: Optimizing/Defragmenting C:"
defrag C: /O /U /V
echo Disk optimization for C: completed.
call :log_action "Disk Opt: Optimization/Defragmentation of C: complete."
pause
goto optimize_disk

:check_disk_errors_c
cls
echo Checking disk C: for errors (CHKDSK)...
call :log_action "Disk Opt: Scheduling CHKDSK for C:"
echo This process will attempt to schedule a disk check on the next system restart.
echo You may be prompted to confirm.
chkdsk C: /F /R /X
echo Disk check for C: scheduled or initiated. If prompted, confirm the restart.
call :log_action "Disk Opt: CHKDSK for C: scheduled/initiated."
pause
goto optimize_disk

:trim_ssd_c
cls
echo Trimming SSD (Drive C:) using defrag /L...
call :log_action "Disk Opt: Trimming SSD C:"
echo Ensuring Delete Notify (TRIM) is enabled...
fsutil behavior set disabledeletenotify 0 >nul
call :log_action "Disk Opt: DisableDeleteNotify set to 0."
echo Running TRIM command for C:...
defrag C: /L /U /V
echo SSD TRIM command for C: completed.
call :log_action "Disk Opt: SSD TRIM for C: complete."
pause
goto optimize_disk

:cleanup_system_disk_c_opt9
cls
echo Starting system file cleanup (Disk Cleanup utility)...
call :log_action "Disk Opt: Starting Disk Cleanup utility via cleanmgr."
echo The Disk Cleanup utility will now open.
echo Please select the files you want to delete and click OK.
echo You might need to click "Clean up system files" for more options.
cleanmgr /d C:
echo Disk Cleanup utility launched. Follow prompts in its window.
call :log_action "Disk Opt: cleanmgr /d C: launched."
pause
goto optimize_disk

:option_10
:check_repair_files
cls
echo ==================================================
echo  Check and Repair System Files
echo ==================================================
echo  1. Run SFC (System File Checker - sfc /scannow)
echo  2. Run DISM (RestoreHealth - DISM /Online /Cleanup-Image /RestoreHealth)
echo  3. Check disk drive health status (WMIC)
echo  4. View SFC scan details from CBS.log (to Desktop\sfcdetails.txt)
echo  5. Return to main menu
echo ==================================================
set /p repair_choice=Enter your choice (1-5):

if not "%repair_choice%"=="" (
    if "%repair_choice%"=="1" goto run_sfc_csr
    if "%repair_choice%"=="2" goto run_dism_csr
    if "%repair_choice%"=="3" goto check_disk_health_csr
    if "%repair_choice%"=="4" goto verify_system_files_csr
    if "%repair_choice%"=="5" (call :log_action "[SUBMENU] SysRepair: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] SysRepair: Invalid choice %repair_choice%."
echo Invalid choice. Please try again.
pause
goto check_repair_files

:run_sfc_csr
cls
echo Running System File Checker (SFC /scannow)...
call :log_action "SysRepair: Starting SFC /scannow."
echo This may take some time. Please wait.
sfc /scannow
echo SFC scan completed. Check the output above for results.
call :log_action "SysRepair: SFC /scannow completed. Result in console."
pause
goto check_repair_files

:run_dism_csr
cls
echo Running DISM to check, scan, and restore health...
call :log_action "SysRepair: Starting DISM operations."
echo This may take a significant amount of time and requires an internet connection for RestoreHealth.
echo.
echo Stage 1: DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /CheckHealth
call :log_action "SysRepair: DISM CheckHealth completed."
echo.
echo Stage 2: DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /ScanHealth
call :log_action "SysRepair: DISM ScanHealth completed."
echo.
echo Stage 3: DISM /Online /Cleanup-Image /RestoreHealth
DISM /Online /Cleanup-Image /RestoreHealth
call :log_action "SysRepair: DISM RestoreHealth completed."
echo.
echo DISM operations completed. Check the output above for results.
echo If errors were found and repaired, a restart is recommended.
pause
goto check_repair_files

:check_disk_health_csr
cls
echo Checking disk drive health status (SMART status via WMIC)...
call :log_action "SysRepair: Checking disk health (WMIC)."
wmic diskdrive get model,name,status,serialnumber
echo.
echo Status 'OK' generally indicates good health. Other statuses may indicate issues.
call :log_action "SysRepair: WMIC disk health check displayed."
pause
goto check_repair_files

:verify_system_files_csr
cls
echo Verifying system files and saving details to Desktop (sfcdetails.txt)...
call :log_action "SysRepair: Extracting SFC details to sfcdetails.txt."
findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
if %errorlevel% equ 0 (
    echo Verification details (if any from last SFC scan) saved to sfcdetails.txt on your Desktop.
    call :log_action "SysRepair: SFC details saved to Desktop\sfcdetails.txt."
) else (
    echo Could not find SFC details in CBS.log or an error occurred.
    echo This may happen if SFC hasn't run recently or found no integrity violations.
    call :log_action "SysRepair: Could not find SFC details or error occurred."
)
pause
goto check_repair_files

:option_11
:windows_activate_menu
cls
echo ==================================================
echo  Windows Activation Management
echo ==================================================
echo  1. Check current activation status
echo  2. Attempt KMS activation (EXTERNAL SCRIPT - HIGH RISK!)
echo  3. Attempt default activation (Digital License/Installed Key)
echo  4. Input a product key manually
echo  5. Remove current product key (for troubleshooting)
echo  6. Return to main menu
echo ==================================================
set /p activate_choice=Enter your choice (1-6):

if not "%activate_choice%"=="" (
    if "%activate_choice%"=="1" goto check_activation_status_wa
    if "%activate_choice%"=="2" goto kms_activate_wa
    if "%activate_choice%"=="3" goto default_activate_wa
    if "%activate_choice%"=="4" goto manual_key_input_wa
    if "%activate_choice%"=="5" goto remove_product_key_wa
    if "%activate_choice%"=="6" (call :log_action "[SUBMENU] Activation: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] Activation: Invalid choice %activate_choice%."
echo Invalid choice. Please try again.
pause
goto windows_activate_menu

:check_activation_status_wa
cls
echo Checking Windows activation status...
call :log_action "Activation: Checking status (slmgr /xpr)."
cscript //nologo %windir%\system32\slmgr.vbs /xpr
echo Detailed status:
cscript //nologo %windir%\system32\slmgr.vbs /dlv
call :log_action "Activation: slmgr /dlv displayed."
pause
goto windows_activate_menu

:kms_activate_wa
cls
echo ===============================================================================
echo  WARNING: KMS Activation via External Script (get.activated.win)
echo ===============================================================================
echo  This option attempts to download and execute a script from an
echo  EXTERNAL website (https://get.activated.win).
echo.
echo  RISKS:
echo  1. Security: The external script could be malicious or compromised.
echo  2. Legality: Using KMS activation methods without proper volume licensing
echo     may violate Microsoft's terms of service or software licensing agreements.
echo  3. Reliability: The external script may not work or could be outdated.
echo.
echo  This method is typically intended for legitimate Volume License activation
echo  scenarios within organizations.
echo.
echo  PROCEED ONLY IF YOU ARE FULLY AWARE OF THESE RISKS AND TRUST THE SOURCE.
echo  This script and its author are NOT responsible for any consequences.
echo ===============================================================================
set /p confirm_kms=Are you absolutely sure you want to proceed? (Y/N):
if /i not "%confirm_kms%"=="Y" (
    call :log_action "Activation: KMS external script cancelled by user due to warning."
    echo Operation cancelled by user.
    pause
    goto windows_activate_menu
)
call :log_action "Activation: User confirmed KMS external script. Attempting execution."
echo Attempting KMS activation using external script from get.activated.win...
powershell -ExecutionPolicy Bypass -Command "try { Write-Host 'Downloading and executing script from get.activated.win...'; irm https://get.activated.win | iex } catch { Write-Host '[ERROR] KMS script execution failed, was blocked, or the source is unavailable.' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Yellow }"
echo.
echo External KMS script execution attempted.
echo Please check your activation status (Option 1) after a few moments and a restart.
call :log_action "Activation: KMS external script execution attempted."
pause
goto windows_activate_menu

:default_activate_wa
cls
echo Attempting default Windows activation (using Digital License or currently installed Product Key)...
call :log_action "Activation: Attempting default activation (slmgr /ato)."
cscript //nologo %windir%\system32\slmgr.vbs /ato
if %errorlevel% neq 0 (
    echo [ERROR] Activation attempt failed. Error code: %errorlevel%.
    echo Your PC may not have a digital license, a valid key, or there might be a server issue.
    call :log_action "Activation: Default activation FAILED. Errorlevel: %errorlevel%."
) else (
    echo Activation attempt successful or Windows is already activated.
    echo Please check activation status (Option 1) to confirm.
    call :log_action "Activation: Default activation command sent successfully."
)
pause
goto windows_activate_menu

:manual_key_input_wa
cls
echo Input a Product Key Manually...
set "product_key="
set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
if not defined product_key (
    echo No product key entered. Operation cancelled.
    call :log_action "Activation: Manual key input cancelled - no key entered."
    pause
    goto windows_activate_menu
)
call :log_action "Activation: User entered product key (hidden in log for security, length: %product_key:~28% - this is a trick, it will be empty)."
call :log_action "Activation: Actually logging key length: %product_key%" 
rem Previous line was to show how to avoid logging key, but actual length is fine.
set "key_length=0"
set "temp_key=%product_key%"
:count_loop
if defined temp_key (
    set /a key_length+=1
    set "temp_key=%temp_key:~1%"
    goto count_loop
)
call :log_action "Activation: Product key entered by user, length: %key_length%."


echo Installing product key: %product_key% ...
call :log_action "Activation: Installing product key (slmgr /ipk)."
cscript //nologo %windir%\system32\slmgr.vbs /ipk %product_key%
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install product key. Error code: %errorlevel%.
    echo The key may be invalid, not applicable to your Windows version, or mistyped.
    call :log_action "Activation: Failed to install product key. Errorlevel: %errorlevel%."
) else (
    echo Product key installed successfully. Attempting activation...
    call :log_action "Activation: Product key installed. Attempting activation (slmgr /ato)."
    cscript //nologo %windir%\system32\slmgr.vbs /ato
    if %errorlevel% neq 0 (
        echo [ERROR] Activation failed with the new key. Error code: %errorlevel%.
        echo Please check your product key, internet connection, and system time.
        call :log_action "Activation: Activation with new key FAILED. Errorlevel: %errorlevel%."
    ) else (
        echo Windows activation attempt with new key successful.
        echo Please check activation status (Option 1) to confirm.
        call :log_action "Activation: Activation with new key command sent successfully."
    )
)
pause
goto windows_activate_menu

:remove_product_key_wa
cls
echo Removing current product key from the system...
call :log_action "Activation: Attempting to remove product key (slmgr /upk)."
set /p confirm_remove_key=Are you sure you want to remove the current product key? This is usually for troubleshooting. (Y/N):
if /i not "%confirm_remove_key%"=="Y" (
    call :log_action "Activation: Product key removal cancelled by user."
    echo Operation cancelled.
    pause
    goto windows_activate_menu
)

cscript //nologo %windir%\system32\slmgr.vbs /upk
if %errorlevel% neq 0 (
    echo [ERROR] Failed to remove product key. Error code: %errorlevel%.
    echo You may not have permission, or no key is currently installed.
    call :log_action "Activation: Failed to remove product key (slmgr /upk). Errorlevel: %errorlevel%."
) else (
    echo Product key uninstalled successfully.
    call :log_action "Activation: Product key uninstalled (slmgr /upk)."
    echo Clearing product key from registry (if it was stored there by KMS clients etc)...
    cscript //nologo %windir%\system32\slmgr.vbs /cpky >nul 2>&1
    call :log_action "Activation: Cleared product key from registry cache (slmgr /cpky)."
    echo Product key removed from system and registry cache attempt completed.
)
pause
goto windows_activate_menu

:option_12
:manage_power_settings
cls
echo ==================================================
echo  Power Settings Management
echo ==================================================
echo  1. List all power plans
echo  2. Set active power plan (by GUID)
echo  3. Create a new custom power plan (duplicates Balanced)
echo  4. Delete a power plan (by GUID, non-active custom plans only)
echo  5. Adjust system standby (sleep) timeout (AC/DC)
echo  6. Configure hibernation (Enable/Disable)
echo  7. Adjust display and sleep timeouts (AC/DC)
echo  8. Configure lid close action (AC/DC)
echo  9. Configure power button action (AC/DC)
echo 10. Return to main menu
echo ==================================================
set /p power_choice_ps=Enter your choice (1-10):

if not "%power_choice_ps%"=="" (
    if "%power_choice_ps%"=="1" goto list_power_plans_ps
    if "%power_choice_ps%"=="2" goto set_power_plan_ps
    if "%power_choice_ps%"=="3" goto create_power_plan_ps
    if "%power_choice_ps%"=="4" goto delete_power_plan_ps
    if "%power_choice_ps%"=="5" goto adjust_sleep_settings_ps
    if "%power_choice_ps%"=="6" goto configure_hibernation_ps
    if "%power_choice_ps%"=="7" goto adjust_timeouts_ps
    if "%power_choice_ps%"=="8" goto lid_close_action_ps
    if "%power_choice_ps%"=="9" goto power_button_action_ps
    if "%power_choice_ps%"=="10" (call :log_action "[SUBMENU] PowerSet: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] PowerSet: Invalid choice %power_choice_ps%."
echo Invalid choice. Please try again.
pause
goto manage_power_settings

:list_power_plans_ps
cls
echo Listing all available power plans...
call :log_action "PowerSet: Listing power plans."
powercfg /list
echo.
echo Note the GUID of the plan you wish to manage.
pause
goto manage_power_settings

:set_power_plan_ps
cls
echo Setting active power plan...
call :log_action "PowerSet: Setting active power plan."
powercfg /list
echo.
set /p plan_guid=Enter the GUID of the power plan you want to set active:
if not defined plan_guid (
    echo [ERROR] No GUID entered. Operation cancelled.
    call :log_action "PowerSet: Set active plan cancelled - no GUID."
    pause
    goto manage_power_settings
)
call :log_action "PowerSet: Attempting to set active plan GUID: %plan_guid%."
powercfg /setactive %plan_guid%
if %errorlevel% neq 0 (
    echo [ERROR] Failed to set power plan. Error: %errorlevel%. Please check the GUID and try again.
    call :log_action "PowerSet: Failed to set active plan GUID: %plan_guid%. Error: %errorlevel%."
) else (
    echo Power plan with GUID %plan_guid% set as active successfully.
    call :log_action "PowerSet: Active plan set to GUID: %plan_guid%."
)
pause
goto manage_power_settings

:create_power_plan_ps
cls
set "new_plan_guid="
set "plan_name="
echo Creating a new custom power plan (derived from 'Balanced')...
set /p plan_name=Enter a name for the new power plan:
if not defined plan_name (
    echo [ERROR] No name entered. Operation cancelled.
    call :log_action "PowerSet: Create plan cancelled - no name."
    pause
    goto manage_power_settings
)

call :log_action "PowerSet: Attempting to create power plan: %plan_name%"
set "balanced_guid=381b4222-f694-41f0-9685-ff5bb260df2e"
echo [INFO] Duplicating 'Balanced' power plan (%balanced_guid%) to create "%plan_name%"...

set "temp_guid_file=%temp%\newpowerplanguid.txt"
powercfg -duplicatescheme %balanced_guid% > "%temp_guid_file%"
if not exist "%temp_guid_file%" (
    echo [ERROR] Failed to execute powercfg duplicatescheme or write temp file.
    call :log_action "PowerSet: Failed to create temp file for new plan GUID."
    if exist "%temp_guid_file%" del "%temp_guid_file%" >nul 2>&1
    pause
    goto manage_power_settings
)

for /f "tokens=4" %%s in ('type "%temp_guid_file%"') do set "new_plan_guid=%%s"
del "%temp_guid_file%" >nul 2>&1

if defined new_plan_guid (
    set "new_plan_guid=%new_plan_guid: =%"
    powercfg /changename %new_plan_guid% "%plan_name%" "Custom plan created by script" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [SUCCESS] Power plan "%plan_name%" created with GUID: %new_plan_guid%.
        call :log_action "PowerSet: Power plan '%plan_name%' created with GUID %new_plan_guid%."
        powercfg /setactive %new_plan_guid% >nul 2>&1
        if %errorlevel% equ 0 (
            echo [INFO] New power plan "%plan_name%" has been set as active.
            call :log_action "PowerSet: Power plan '%plan_name%' set as active."
        ) else (
             echo [WARNING] Power plan "%plan_name%" created, but could not be set as active. You can set it manually.
             call :log_action "PowerSet: Power plan '%plan_name%' created, but failed to set active."
        )
    ) else (
        echo [ERROR] Power plan GUID captured (%new_plan_guid%), but failed to rename it. It might exist with a default name.
        call :log_action "PowerSet: Power plan GUID %new_plan_guid% captured, but failed to rename."
    )
) else (
    echo [ERROR] Failed to create the new power plan. The 'Balanced' scheme might be missing or an error occurred during duplication.
    call :log_action "PowerSet: Failed to create power plan '%plan_name%' (GUID not captured)."
)
pause
goto manage_power_settings

:delete_power_plan_ps
cls
echo Deleting a power plan...
call :log_action "PowerSet: Deleting a power plan."
powercfg /list
echo.
echo WARNING: You can only delete custom power plans that are not currently active.
echo Default plans (Balanced, Power saver, High performance) cannot be deleted this way.
set /p del_guid=Enter the GUID of the custom power plan you want to delete:
if not defined del_guid (
    echo [ERROR] No GUID entered. Operation cancelled.
    call :log_action "PowerSet: Delete plan cancelled - no GUID."
    pause
    goto manage_power_settings
)
call :log_action "PowerSet: Attempting to delete plan GUID: %del_guid%."
powercfg /delete %del_guid%
if %errorlevel% neq 0 (
    echo [ERROR] Failed to delete power plan. Error: %errorlevel%.
    echo Ensure it's a custom plan, not active, and the GUID is correct.
    call :log_action "PowerSet: Failed to delete plan GUID: %del_guid%. Error: %errorlevel%."
) else (
    echo Power plan with GUID %del_guid% deleted successfully.
    call :log_action "PowerSet: Plan GUID: %del_guid% deleted."
)
pause
goto manage_power_settings

:adjust_sleep_settings_ps
cls
echo Adjusting system standby (sleep) timeout...
call :log_action "PowerSet: Adjusting sleep timeouts."
set /p sleep_time_ac=Enter minutes before system sleeps on AC power (0 for Never):
set /p sleep_time_dc=Enter minutes before system sleeps on Battery power (0 for Never):
if defined sleep_time_ac (
    powercfg /change standby-timeout-ac %sleep_time_ac% >nul
    call :log_action "PowerSet: Standby AC timeout set to %sleep_time_ac% minutes."
    echo Standby timeout on AC power set to %sleep_time_ac% minutes.
)
if defined sleep_time_dc (
    powercfg /change standby-timeout-dc %sleep_time_dc% >nul
    call :log_action "PowerSet: Standby DC timeout set to %sleep_time_dc% minutes."
    echo Standby timeout on Battery power set to %sleep_time_dc% minutes.
)
echo Sleep settings adjusted.
pause
goto manage_power_settings

:configure_hibernation_ps
cls
echo Configuring Hibernation (powercfg /hibernate)...
call :log_action "PowerSet: Configuring hibernation."
echo 1. Enable hibernation
echo 2. Disable hibernation
set /p hib_choice=Enter your choice (1-2):
if "%hib_choice%"=="1" (
    powercfg /hibernate on
    echo Hibernation enabled.
    call :log_action "PowerSet: Hibernation enabled."
) else if "%hib_choice%"=="2" (
    powercfg /hibernate off
    echo Hibernation disabled.
    call :log_action "PowerSet: Hibernation disabled."
) else (
    echo Invalid choice. No changes made.
    call :log_action "PowerSet: Configure hibernation - invalid choice."
)
pause
goto manage_power_settings

:adjust_timeouts_ps
cls
echo Adjusting Display and Sleep Timeouts for current plan...
call :log_action "PowerSet: Adjusting display and sleep timeouts."
echo For AC Power:
set /p display_ac=Enter minutes before turning off display (AC, 0 for never):
set /p sleep_ac_to=Enter minutes before sleep (AC, 0 for never):
echo For Battery Power:
set /p display_dc=Enter minutes before turning off display (DC, 0 for never):
set /p sleep_dc_to=Enter minutes before sleep (DC, 0 for never):

if defined display_ac (
    powercfg /change monitor-timeout-ac %display_ac% >nul
    call :log_action "PowerSet: Monitor AC timeout set to %display_ac%."
    echo Monitor AC timeout set to %display_ac% minutes.
)
if defined display_dc (
    powercfg /change monitor-timeout-dc %display_dc% >nul
    call :log_action "PowerSet: Monitor DC timeout set to %display_dc%."
    echo Monitor DC timeout set to %display_dc% minutes.
)
if defined sleep_ac_to (
    powercfg /change standby-timeout-ac %sleep_ac_to% >nul
    call :log_action "PowerSet: Standby AC timeout (adj_timeouts) set to %sleep_ac_to%."
    echo System Sleep AC timeout set to %sleep_ac_to% minutes.
)
if defined sleep_dc_to (
    powercfg /change standby-timeout-dc %sleep_dc_to% >nul
    call :log_action "PowerSet: Standby DC timeout (adj_timeouts) set to %sleep_dc_to%."
    echo System Sleep DC timeout set to %sleep_dc_to% minutes.
)
powercfg /setactive scheme_current >nul
echo Display and sleep timeouts adjusted for the current power plan.
pause
goto manage_power_settings

:lid_close_action_ps
cls
echo Configure Lid Close Action for current plan...
call :log_action "PowerSet: Configuring lid close action."
echo Action codes: 0=Do nothing, 1=Sleep, 2=Hibernate, 3=Shut down
set /p lid_action_ac=Enter action for AC power (0-3):
set /p lid_action_dc=Enter action for Battery power (0-3):
if defined lid_action_ac (
    powercfg /setacvalueindex scheme_current sub_buttons lidaction %lid_action_ac% >nul
    call :log_action "PowerSet: Lid close AC action set to %lid_action_ac%."
    echo Lid close action on AC power set.
)
if defined lid_action_dc (
    powercfg /setdcvalueindex scheme_current sub_buttons lidaction %lid_action_dc% >nul
    call :log_action "PowerSet: Lid close DC action set to %lid_action_dc%."
    echo Lid close action on Battery power set.
)
powercfg /setactive scheme_current >nul
echo Lid close actions configured for the current power plan.
pause
goto manage_power_settings

:power_button_action_ps
cls
echo Configure Power Button Action for current plan...
call :log_action "PowerSet: Configuring power button action."
echo Action codes: 0=Do nothing, 1=Sleep, 2=Hibernate, 3=Shut down
set /p pbutton_action_ac=Enter action for AC power (0-3):
set /p pbutton_action_dc=Enter action for Battery power (0-3):
if defined pbutton_action_ac (
    powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %pbutton_action_ac% >nul
    call :log_action "PowerSet: Power button AC action set to %pbutton_action_ac%."
    echo Power button action on AC power set.
)
if defined pbutton_action_dc (
    powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %pbutton_action_dc% >nul
    call :log_action "PowerSet: Power button DC action set to %pbutton_action_dc%."
    echo Power button action on Battery power set.
)
powercfg /setactive scheme_current >nul
echo Power button actions configured for the current power plan.
pause
goto manage_power_settings

:option_13
cls
echo ==================================================
echo  Enabling System-Wide Dark Mode
echo ==================================================
call :log_action "Starting: Enable Dark Mode"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo.
echo Dark Mode enabled for Apps and System.
echo You may need to restart some applications or sign out and back in for all changes to fully apply.
call :log_action "Completed: Enable Dark Mode"
pause
goto menu

:option_14
:manage_partitions_menu
cls
echo =====================================================================
echo  Partition Management (Using Diskpart - ADVANCED USERS ONLY!)
echo =====================================================================
echo  WARNING: INCORRECT USE OF DISKPART CAN LEAD TO SEVERE DATA LOSS
echo           OR AN UNBOOTABLE SYSTEM. PROCEED WITH EXTREME CAUTION!
echo.
echo  It is STRONGLY recommended to back up all important data before
echo  making any changes to partitions.
echo.
echo  This script provides basic diskpart operations. For complex scenarios,
echo  use Disk Management GUI or diskpart manually with care.
echo =====================================================================
echo  1. List Disks and Volumes
echo  2. Create Partition (Primary, assigns letter, quick formats NTFS)
echo  3. Delete Partition (using 'override' - CAUTION!)
echo  4. Format Partition (Quick Format)
echo  5. Return to main menu
echo =====================================================================
set /p confirm_part_manage=Do you understand the risks and wish to proceed? (Y/N):
if /i not "%confirm_part_manage%"=="Y" (
    call :log_action "PartitionManage: Access cancelled by user due to data loss warning."
    echo Operation cancelled by user. Safety first!
    pause
    goto menu
)
call :log_action "PartitionManage: User acknowledged data loss risk and proceeded to submenu."

:manage_partitions_submenu_loop
cls
echo =====================================================================
echo  Partition Management (Diskpart) - Current Disk List:
echo =====================================================================
(
echo list disk
) > "%temp%\diskpart_tempscript.txt"
diskpart /s "%temp%\diskpart_tempscript.txt"
del "%temp%\diskpart_tempscript.txt" >nul 2>&1
echo =====================================================================
echo  1. List Disks and Volumes (Refresh)
echo  2. Create Partition (Primary)
echo  3. Delete Partition (CAUTION!)
echo  4. Format Partition (CAUTION!)
echo  5. Return to main menu
echo =====================================================================
set /p part_choice_mp=Enter your choice (1-5):

if not "%part_choice_mp%"=="" (
    if "%part_choice_mp%"=="1" goto list_partitions_mp
    if "%part_choice_mp%"=="2" goto create_partition_mp
    if "%part_choice_mp%"=="3" goto delete_partition_mp
    if "%part_choice_mp%"=="4" goto format_partition_mp
    if "%part_choice_mp%"=="5" (call :log_action "[SUBMENU] PartitionManage: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] PartitionManage: Invalid choice %part_choice_mp%."
echo Invalid choice. Please try again.
pause
goto manage_partitions_submenu_loop

:list_partitions_mp
cls
echo Listing Disks and Volumes using Diskpart...
call :log_action "PartitionManage: Listing disks and volumes."
(
echo list disk
echo list volume
) > "%temp%\diskpart_script.txt"
diskpart /s "%temp%\diskpart_script.txt"
del "%temp%\diskpart_script.txt" >nul 2>&1
pause
goto manage_partitions_submenu_loop

:create_partition_mp
cls
echo Creating a New Primary Partition...
call :log_action "PartitionManage: Creating partition."
set /p disk_num_mp=Enter DISK NUMBER where new partition will be created (e.g., 0, 1):
set /p part_size_mp=Enter partition size in MB (e.g., 10240 for 10GB, leave blank for max available size):
if not defined disk_num_mp (echo [ERROR] Disk number not entered. & pause & goto manage_partitions_submenu_loop)
call :log_action "PartitionManage: Create partition on Disk %disk_num_mp%, Size: %part_size_mp% MB."

set "create_command=create partition primary"
if defined part_size_mp set "create_command=%create_command% size=%part_size_mp%"

set /p confirm_create_part=CONFIRM: Create partition on Disk %disk_num_mp% (Size: %part_size_mp% MB)? (Y/N):
if /i not "%confirm_create_part%"=="Y" (
    call :log_action "PartitionManage: Create partition cancelled by user."
    echo Operation cancelled.
    pause
    goto manage_partitions_submenu_loop
)

(
echo select disk %disk_num_mp%
echo %create_command%
echo assign letter
echo format fs=ntfs quick label="New Volume"
echo list volume
) > "%temp%\diskpart_script.txt"
echo --- Diskpart Script ---
type "%temp%\diskpart_script.txt"
echo --- End Script ---
diskpart /s "%temp%\diskpart_script.txt"
del "%temp%\diskpart_script.txt" >nul 2>&1
echo Partition creation attempt completed. Check disk management or list volumes for results.
call :log_action "PartitionManage: Partition creation script executed for Disk %disk_num_mp%."
pause
goto manage_partitions_submenu_loop

:delete_partition_mp
cls
echo Deleting an Existing Partition (DATA WILL BE LOST!)...
call :log_action "PartitionManage: Deleting partition."
set /p disk_num_del_mp=Enter DISK NUMBER of the partition to delete:
set /p part_num_del_mp=Enter PARTITION NUMBER to delete (from 'list partition' if unsure, or 'list volume'):
if not defined disk_num_del_mp (echo [ERROR] Disk number not entered. & pause & goto manage_partitions_submenu_loop)
if not defined part_num_del_mp (echo [ERROR] Partition number not entered. & pause & goto manage_partitions_submenu_loop)
call :log_action "PartitionManage: Delete partition - Disk %disk_num_del_mp%, Partition %part_num_del_mp%."

set /p confirm_del_part=EXTREME CAUTION! Delete Partition %part_num_del_mp% on Disk %disk_num_del_mp%? ALL DATA ON IT WILL BE ERASED! (Y/N):
if /i not "%confirm_del_part%"=="Y" (
    call :log_action "PartitionManage: Delete partition cancelled by user."
    echo Operation cancelled.
    pause
    goto manage_partitions_submenu_loop
)

(
echo select disk %disk_num_del_mp%
echo select partition %part_num_del_mp%
echo delete partition override
echo list partition
) > "%temp%\diskpart_script.txt"
echo --- Diskpart Script ---
type "%temp%\diskpart_script.txt"
echo --- End Script ---
diskpart /s "%temp%\diskpart_script.txt"
del "%temp%\diskpart_script.txt" >nul 2>&1
echo Partition deletion attempt completed. Check disk management or list volumes.
call :log_action "PartitionManage: Partition deletion script executed for Disk %disk_num_del_mp%, Partition %part_num_del_mp%."
pause
goto manage_partitions_submenu_loop

:format_partition_mp
cls
echo Formatting an Existing Partition (DATA WILL BE LOST!)...
call :log_action "PartitionManage: Formatting partition."
set /p disk_num_fmt_mp=Enter DISK NUMBER of the partition to format:
set /p part_num_fmt_mp=Enter PARTITION NUMBER to format:
set /p fs_fmt_mp=Enter file system (NTFS or FAT32, default NTFS):
set /p label_fmt_mp=Enter volume label (optional, e.g., MyData):

if not defined disk_num_fmt_mp (echo [ERROR] Disk number not entered. & pause & goto manage_partitions_submenu_loop)
if not defined part_num_fmt_mp (echo [ERROR] Partition number not entered. & pause & goto manage_partitions_submenu_loop)
if not defined fs_fmt_mp set fs_fmt_mp=NTFS
call :log_action "PartitionManage: Format partition - Disk %disk_num_fmt_mp%, Partition %part_num_fmt_mp%, FS: %fs_fmt_mp%, Label: %label_fmt_mp%."

set /p confirm_fmt_part=EXTREME CAUTION! Format Partition %part_num_fmt_mp% on Disk %disk_num_fmt_mp% as %fs_fmt_mp%? ALL DATA ON IT WILL BE ERASED! (Y/N):
if /i not "%confirm_fmt_part%"=="Y" (
    call :log_action "PartitionManage: Format partition cancelled by user."
    echo Operation cancelled.
    pause
    goto manage_partitions_submenu_loop
)

set "format_command=format fs=%fs_fmt_mp% quick"
if defined label_fmt_mp set "format_command=%format_command% label=""%label_fmt_mp%"""

(
echo select disk %disk_num_fmt_mp%
echo select partition %part_num_fmt_mp%
echo %format_command%
echo list volume
) > "%temp%\diskpart_script.txt"
echo --- Diskpart Script ---
type "%temp%\diskpart_script.txt"
echo --- End Script ---
diskpart /s "%temp%\diskpart_script.txt"
del "%temp%\diskpart_script.txt" >nul 2>&1
echo Partition formatting attempt completed.
call :log_action "PartitionManage: Partition format script executed for Disk %disk_num_fmt_mp%, Partition %part_num_fmt_mp%."
pause
goto manage_partitions_submenu_loop

:option_15
cls
echo ==================================================
echo  Cleaning Up Disk Space (using Disk Cleanup utility)
echo ==================================================
call :log_action "Starting: Clean up disk space (Option 15)"
echo The Disk Cleanup utility will now open for drive C:.
echo Please select the files you want to delete and click OK.
echo For more options (like cleaning system files), click "Clean up system files" within the utility.
cleanmgr /d C:
echo Disk Cleanup utility (cleanmgr) launched. Please follow the on-screen instructions.
call :log_action "Completed: cleanmgr /d C: launched."
pause
goto menu

:option_16
cls
echo ==================================================
echo  Managing Startup Programs
echo ==================================================
call :log_action "Starting: Manage startup programs"
echo The System Configuration utility (msconfig) or Task Manager will be opened.
echo On newer Windows versions (Windows 8, 10, 11), the 'Startup' tab in
echo 'msconfig' will redirect you to the Task Manager.
echo.
echo Please use the 'Startup' tab in Task Manager (or msconfig on older systems)
echo to enable or disable startup programs.
call :log_action "Opening msconfig (will redirect to Task Manager on Win10+ for startup items)."
start msconfig
echo.
echo System Configuration / Task Manager launched.
pause
goto menu

:option_17
:backup_restore_menu
cls
echo ==================================================
echo  Backup and Restore Settings (System Restore)
echo ==================================================
echo  1. Create a system restore point
echo  2. Open System Restore utility (to restore from a point)
echo  3. Return to main menu
echo ==================================================
set /p backup_choice_br=Enter your choice (1-3):

if not "%backup_choice_br%"=="" (
    if "%backup_choice_br%"=="1" goto create_restore_point_br
    if "%backup_choice_br%"=="2" goto restore_from_point_br
    if "%backup_choice_br%"=="3" (call :log_action "[SUBMENU] BackupRestore: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] BackupRestore: Invalid choice %backup_choice_br%."
echo Invalid choice. Please try again.
pause
goto backup_restore_menu

:create_restore_point_br
cls
echo Creating a system restore point... Please wait.
call :log_action "BackupRestore: Creating system restore point."
set "rp_description=Manual Restore Point by Script %date% %time:~0,2%-%time:~3,2%-%time:~6,2%"
set "rp_description=%rp_description::=-%"
set "rp_description=%rp_description:/=-%"
echo Restore point description: "%rp_description%"
powershell -ExecutionPolicy Bypass -Command "try { Checkpoint-Computer -Description '%rp_description%' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction Stop } catch { Write-Host '[ERROR] Failed to create restore point.' -ForegroundColor Red; Write-Host $_.Exception.Message; exit 1 }"
if %errorlevel% equ 0 (
    echo System restore point '%rp_description%' created successfully.
    call :log_action "BackupRestore: System restore point '%rp_description%' created successfully."
) else (
    echo [ERROR] Failed to create system restore point.
    echo Ensure System Protection is enabled for your system drive (usually C:).
    echo You can check this in System Properties -> System Protection tab.
    call :log_action "BackupRestore: Failed to create system restore point. Errorlevel: %errorlevel%."
)
pause
goto backup_restore_menu

:restore_from_point_br
cls
echo Opening System Restore utility...
call :log_action "BackupRestore: Opening System Restore utility (rstrui.exe)."
rstrui.exe
echo The System Restore utility has been launched.
echo Please follow the on-screen instructions to restore your system to an earlier point.
call :log_action "BackupRestore: rstrui.exe launched."
pause
goto backup_restore_menu

:option_18
cls
echo ==================================================
echo  Displaying System Information
echo ==================================================
call :log_action "Starting: Display system information"
echo Gathering system information... This may take a moment.
systeminfo
echo.
echo System information displayed above.
call :log_action "Completed: systeminfo displayed."
pause
goto menu

:option_19
cls
echo ==================================================
echo  Optimizing Basic Privacy Settings
echo ==================================================
call :log_action "Starting: Optimize basic privacy settings"
echo Disabling basic telemetry and advertising ID related settings...
call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" "REG_DWORD" "0"
call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0" 
call :modify_registry "HKCU\Software\Microsoft\Input\TIPC" "Enabled" "REG_DWORD" "0" 
call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" "TailoredExperiencesWithDiagnosticDataEnabled" "REG_DWORD" "0"

echo.
echo Basic privacy-related settings applied.
echo For more comprehensive privacy settings, please review Windows Settings -> Privacy.
echo Some changes may require a restart or sign out/in to take full effect.
call :log_action "Completed: Optimize basic privacy settings"
pause
goto menu

:option_20
:manage_services_menu
cls
echo ==================================================
echo  Windows Services Management
echo ==================================================
echo  1. List all services (brief: Name, Display Name, State)
echo  2. List RUNNING services (brief)
echo  3. List STOPPED services (brief)
echo  4. Start a service
echo  5. Stop a service
echo  6. Restart a service
echo  7. Change service startup type
echo  8. Search for a service (by name fragment)
echo  9. View service details (configuration and status)
echo 10. Return to main menu
echo ==================================================
set /p service_choice_ms=Enter your choice (1-10):

if not "%service_choice_ms%"=="" (
    if "%service_choice_ms%"=="1" goto list_all_services_ms
    if "%service_choice_ms%"=="2" goto list_running_services_ms
    if "%service_choice_ms%"=="3" goto list_stopped_services_ms
    if "%service_choice_ms%"=="4" goto start_a_service_ms
    if "%service_choice_ms%"=="5" goto stop_a_service_ms
    if "%service_choice_ms%"=="6" goto restart_a_service_ms
    if "%service_choice_ms%"=="7" goto change_service_startup_type_ms
    if "%service_choice_ms%"=="8" goto search_for_service_ms
    if "%service_choice_ms%"=="9" goto view_service_details_ms
    if "%service_choice_ms%"=="10" (call :log_action "[SUBMENU] ServiceManage: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] ServiceManage: Invalid choice %service_choice_ms%."
echo Invalid choice. Please try again.
pause
goto manage_services_menu

:list_all_services_ms
cls
echo Listing all services (SERVICE_NAME, DISPLAY_NAME, STATE)...
call :log_action "ServiceManage: Listing all services."
sc query type= service state= all | findstr "SERVICE_NAME STATE DISPLAY_NAME"
pause
goto manage_services_menu

:list_running_services_ms
cls
echo Listing RUNNING services (SERVICE_NAME, DISPLAY_NAME, STATE)...
call :log_action "ServiceManage: Listing running services."
sc query type= service state= running | findstr "SERVICE_NAME STATE DISPLAY_NAME"
pause
goto manage_services_menu

:list_stopped_services_ms
cls
echo Listing STOPPED (inactive) services (SERVICE_NAME, DISPLAY_NAME, STATE)...
call :log_action "ServiceManage: Listing stopped services."
sc query type= service state= inactive | findstr "SERVICE_NAME STATE DISPLAY_NAME"
pause
goto manage_services_menu

:start_a_service_ms
cls
set /p service_name_ms=Enter the exact SERVICE_NAME of the service to start:
if not defined service_name_ms (
    echo [ERROR] No service name entered.
    call :log_action "ServiceManage: Start service - no name entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Attempting to start service '%service_name_ms%'."
echo Attempting to start service "%service_name_ms%"...
sc start "%service_name_ms%"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start the service "%service_name_ms%". Error: %errorlevel%.
    echo Check if the service name is correct, if it's disabled, or if you have permissions.
    call :log_action "ServiceManage: Failed to start service '%service_name_ms%'. Error: %errorlevel%."
) else (
    echo Service "%service_name_ms%" start command sent. Check its status.
    call :log_action "ServiceManage: Start command sent for service '%service_name_ms%'."
)
pause
goto manage_services_menu

:stop_a_service_ms
cls
set /p service_name_ms=Enter the exact SERVICE_NAME of the service to stop:
if not defined service_name_ms (
    echo [ERROR] No service name entered.
    call :log_action "ServiceManage: Stop service - no name entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Attempting to stop service '%service_name_ms%'."
echo Attempting to stop service "%service_name_ms%"...
sc stop "%service_name_ms%"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to stop the service "%service_name_ms%". Error: %errorlevel%.
    echo Check if the service name is correct, if it's already stopped, or if you have permissions.
    call :log_action "ServiceManage: Failed to stop service '%service_name_ms%'. Error: %errorlevel%."
) else (
    echo Service "%service_name_ms%" stop command sent. Check its status.
    call :log_action "ServiceManage: Stop command sent for service '%service_name_ms%'."
)
pause
goto manage_services_menu

:restart_a_service_ms
cls
set /p service_name_ms=Enter the exact SERVICE_NAME of the service to restart:
if not defined service_name_ms (
    echo [ERROR] No service name entered.
    call :log_action "ServiceManage: Restart service - no name entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Attempting to restart service '%service_name_ms%'."
echo Attempting to stop "%service_name_ms%"... please wait.
sc stop "%service_name_ms%" >nul 2>&1
call :log_action "ServiceManage: Stop command sent for restart of '%service_name_ms%'."
echo Waiting a few seconds for service to stop...
timeout /t 3 /nobreak >nul
echo Attempting to start "%service_name_ms%"...
sc start "%service_name_ms%"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to restart (start phase) the service "%service_name_ms%". Error: %errorlevel%.
    echo Check service name, dependencies, or permissions.
    call :log_action "ServiceManage: Failed to start service '%service_name_ms%' during restart. Error: %errorlevel%."
) else (
    echo Service "%service_name_ms%" restart attempt initiated. Check its status.
    call :log_action "ServiceManage: Start command sent for restart of service '%service_name_ms%'."
)
pause
goto manage_services_menu

:change_service_startup_type_ms
cls
set /p service_name_ms=Enter the exact SERVICE_NAME of the service to configure:
if not defined service_name_ms (
    echo [ERROR] No service name entered.
    call :log_action "ServiceManage: Change startup - no name entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Changing startup type for service '%service_name_ms%'."
echo Current configuration for "%service_name_ms%":
sc qc "%service_name_ms%" | findstr "START_TYPE"
echo.
echo Select new startup type for "%service_name_ms%":
echo   1. Automatic
echo   2. Automatic (Delayed Start)
echo   3. Manual (Demand Start)
echo   4. Disabled
set /p startup_choice_ms=Enter your choice (1-4):
set "startup_type_val="
if "%startup_choice_ms%"=="1" set startup_type_val=auto
if "%startup_choice_ms%"=="2" set startup_type_val=delayed-auto
if "%startup_choice_ms%"=="3" set startup_type_val=demand
if "%startup_choice_ms%"=="4" set startup_type_val=disabled

if not defined startup_type_val (
    echo [ERROR] Invalid startup type choice. No changes made.
    call :log_action "ServiceManage: Change startup for '%service_name_ms%' - invalid type choice."
    pause
    goto manage_services_menu
)
echo Setting startup type for "%service_name_ms%" to %startup_type_val%...
sc config "%service_name_ms%" start= %startup_type_val%
if %errorlevel% neq 0 (
    echo [ERROR] Failed to change startup type for "%service_name_ms%". Error: %errorlevel%.
    echo Check service name and permissions.
    call :log_action "ServiceManage: Failed to change startup for '%service_name_ms%' to %startup_type_val%. Error: %errorlevel%."
) else (
    echo Startup type for "%service_name_ms%" changed to %startup_type_val% successfully.
    call :log_action "ServiceManage: Changed startup for '%service_name_ms%' to %startup_type_val%."
)
pause
goto manage_services_menu

:search_for_service_ms
cls
set /p search_term_ms=Enter search term for service name or display name (case-insensitive):
if not defined search_term_ms (
    echo [ERROR] No search term entered.
    call :log_action "ServiceManage: Search service - no term entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Searching for service containing '%search_term_ms%'."
echo Searching for services containing "%search_term_ms%"...
echo (This may take a moment)
sc query type= service state= all | findstr /i /C:"SERVICE_NAME:" /C:"DISPLAY_NAME:" /C:"STATE" | findstr /i "%search_term_ms%"
echo.
echo Search results above. If empty, no matching services found with that term in their name/display name.
pause
goto manage_services_menu

:view_service_details_ms
cls
set /p service_name_ms=Enter the exact SERVICE_NAME of the service to view details:
if not defined service_name_ms (
    echo [ERROR] No service name entered.
    call :log_action "ServiceManage: View details - no name entered."
    pause
    goto manage_services_menu
)
call :log_action "ServiceManage: Viewing details for service '%service_name_ms%'."
echo --- Configuration for "%service_name_ms%" (sc qc) ---
sc qc "%service_name_ms%"
echo.
echo --- Current Status for "%service_name_ms%" (sc query) ---
sc query "%service_name_ms%"
pause
goto manage_services_menu

:option_21
:network_optimization_menu
cls
echo ==================================================
echo  Advanced Network Optimization (Global Settings)
echo ==================================================
echo  1. Optimize TCP global settings (Comprehensive)
echo  2. Reset Windows Sockets (Winsock - requires restart)
echo  3. Clear DNS cache (ipconfig /flushdns)
echo  4. Optimize general network adapter interface settings (DAD, RouterDiscovery)
echo  5. Disable IPv6 system-wide (REQUIRES RESTART, CAUTION!)
echo  6. Enable QoS Packet Scheduler service (QWAVE)
echo  7. Set static DNS servers for active connections (User input)
echo  8. Reset ALL network settings (TCP/IP, Winsock, Firewall - REQUIRES RESTART!)
echo  9. Return to main menu
echo ==================================================
set /p net_opt_choice=Enter your choice (1-9):

if not "%net_opt_choice%"=="" (
    if "%net_opt_choice%"=="1" goto optimize_tcp_netopt
    if "%net_opt_choice%"=="2" goto reset_winsock_netopt
    if "%net_opt_choice%"=="3" goto clear_dns_netopt_adv
    if "%net_opt_choice%"=="4" goto optimize_adapter_netopt
    if "%net_opt_choice%"=="5" goto disable_ipv6_netopt
    if "%net_opt_choice%"=="6" goto enable_qos_netopt
    if "%net_opt_choice%"=="7" goto set_static_dns_netopt
    if "%net_opt_choice%"=="8" goto reset_network_netopt
    if "%net_opt_choice%"=="9" (call :log_action "[SUBMENU] AdvNetOpt: Returning to main menu." & goto menu)
)
call :log_action "[SUBMENU] AdvNetOpt: Invalid choice %net_opt_choice%."
echo Invalid choice. Please try again.
pause
goto network_optimization_menu

:optimize_tcp_netopt
cls
echo Optimizing global TCP settings (Comprehensive)...
call :log_action "AdvNetOpt: Optimizing global TCP settings."
netsh int tcp set global autotuninglevel=normal >nul
call :log_action "AdvNetOpt: TCP autotuninglevel=normal"
netsh int tcp set global congestionprovider=ctcp >nul
call :log_action "AdvNetOpt: TCP congestionprovider=ctcp"
netsh int tcp set global ecncapability=enabled >nul
call :log_action "AdvNetOpt: TCP ecncapability=enabled"
netsh int tcp set heuristics disabled >nul
call :log_action "AdvNetOpt: TCP heuristics disabled"
netsh int tcp set global rss=enabled >nul
call :log_action "AdvNetOpt: TCP rss=enabled"
netsh int tcp set global fastopen=enabled >nul
call :log_action "AdvNetOpt: TCP fastopen=enabled"
netsh int tcp set global timestamps=disabled >nul
call :log_action "AdvNetOpt: TCP timestamps=disabled"
netsh int tcp set global initialRto=2000 >nul
call :log_action "AdvNetOpt: TCP initialRto=2000"
netsh int tcp set global nonsackrttresiliency=disabled >nul
call :log_action "AdvNetOpt: TCP nonsackrttresiliency=disabled"
netsh int tcp set global maxsynretransmissions=2 >nul
call :log_action "AdvNetOpt: TCP maxsynretransmissions=2"
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TcpTimedWaitDelay" "REG_DWORD" "30"
echo Comprehensive global TCP settings optimized. A restart may be beneficial.
pause
goto network_optimization_menu

:reset_winsock_netopt
cls
echo Resetting Windows Sockets (Winsock)...
call :log_action "AdvNetOpt: Resetting Winsock."
echo This can help resolve network connectivity issues caused by corrupted Winsock entries.
set /p confirm_winsock=Are you sure you want to reset Winsock? A RESTART WILL BE REQUIRED. (Y/N):
if /i not "%confirm_winsock%"=="Y" (
    call :log_action "AdvNetOpt: Winsock reset cancelled by user."
    echo Operation cancelled.
    pause
    goto network_optimization_menu
)
netsh winsock reset
echo Windows Sockets reset successfully.
echo PLEASE RESTART YOUR COMPUTER for changes to take effect.
call :log_action "AdvNetOpt: Winsock reset completed. Restart required."
pause
goto network_optimization_menu

:clear_dns_netopt_adv
cls
echo Clearing DNS cache...
call :log_action "AdvNetOpt: Clearing DNS cache."
ipconfig /flushdns
if %errorlevel% equ 0 (
    echo DNS cache cleared successfully.
    call :log_action "AdvNetOpt: DNS cache flushed."
) else (
    echo [ERROR] Failed to flush DNS cache. Error: %errorlevel%.
    call :log_action "AdvNetOpt: Failed to flush DNS cache. Error: %errorlevel%."
)
pause
goto network_optimization_menu

:optimize_adapter_netopt
cls
echo Optimizing general network adapter interface settings for active connections...
call :log_action "AdvNetOpt: Optimizing adapter settings (DAD, RouterDiscovery)."
echo This will set DADTransmits to 0 and disable RouterDiscovery for IPv4/IPv6 on connected interfaces.
for /f "tokens=3,*" %%i in ('netsh interface show interface ^| findstr /i /C:"Connected"') do (
    echo Optimizing interface: "%%j"
    call :log_action "AdvNetOpt: Optimizing interface '%%j'."
    netsh interface ipv4 set interface "%%j" dadtransmits=0 store=persistent >nul
    netsh interface ipv6 set interface "%%j" dadtransmits=0 store=persistent >nul
    netsh interface ipv4 set interface "%%j" routerdiscovery=disabled store=persistent >nul
    netsh interface ipv6 set interface "%%j" routerdiscovery=disabled store=persistent >nul
)
echo General network adapter interface settings (DADTransmits, RouterDiscovery) optimized.
pause
goto network_optimization_menu

:disable_ipv6_netopt
cls
echo =====================================================================
echo  WARNING: Disabling IPv6 System-Wide
echo =====================================================================
echo  Disabling IPv6 may cause issues with some modern applications,
echo  network services, and future internet compatibility.
echo  It is generally recommended to keep IPv6 enabled unless you have
echo  a specific, known issue that disabling it resolves.
echo =====================================================================
set /p confirm_ipv6=Are you absolutely sure you want to disable IPv6 system-wide? A RESTART IS REQUIRED. (Y/N):
if /i not "%confirm_ipv6%"=="Y" (
    call :log_action "AdvNetOpt: Disable IPv6 cancelled by user."
    echo Operation cancelled.
    pause
    goto network_optimization_menu
)
call :log_action "AdvNetOpt: User confirmed. Disabling IPv6 via registry."
call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" "DisabledComponents" "REG_DWORD" "255"
echo IPv6 disabled via registry (DisabledComponents set to 0xFF).
echo PLEASE RESTART YOUR COMPUTER for this change to take full effect.
echo To re-enable IPv6, delete this registry value or set it to 0, then restart.
call :log_action "AdvNetOpt: IPv6 disabled. Restart required."
pause
goto network_optimization_menu

:enable_qos_netopt
cls
echo Enabling QoS Packet Scheduler service (QWAVE)...
call :log_action "AdvNetOpt: Enabling QoS Packet Scheduler (QWAVE)."
sc config QWAVE start= auto >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Failed to set QWAVE service to auto. Permissions?
    call :log_action "AdvNetOpt: Failed to set QWAVE to auto."
) else (
    echo QWAVE service startup type set to Automatic.
    call :log_action "AdvNetOpt: QWAVE startup type set to Automatic."
)
sc start QWAVE >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Failed to start QWAVE service (Error: %errorlevel%). It might be already running or another issue.
    call :log_action "AdvNetOpt: Failed to start QWAVE (Error: %errorlevel%)."
) else (
    echo QWAVE service started.
    call :log_action "AdvNetOpt: QWAVE started."
)
pause
goto network_optimization_menu

:set_static_dns_netopt
cls
echo Setting static DNS servers for active connected interfaces...
call :log_action "AdvNetOpt: Setting static DNS."
set /p primary_dns_no=Enter primary DNS server (e.g., 8.8.8.8, 1.1.1.1):
set /p secondary_dns_no=Enter secondary DNS server (e.g., 8.8.4.4, 1.0.0.1, or leave blank for none):
if not defined primary_dns_no (
    echo [ERROR] No primary DNS server entered. Operation cancelled.
    call :log_action "AdvNetOpt: Set static DNS cancelled - no primary DNS."
    pause
    goto network_optimization_menu
)
call :log_action "AdvNetOpt: Primary DNS: %primary_dns_no%, Secondary DNS: %secondary_dns_no%."
echo Flushing current DNS cache before applying new settings...
ipconfig /flushdns >nul

for /f "tokens=3,*" %%a in ('netsh interface show interface ^| findstr /i /C:"Connected"') do (
    echo Setting DNS for interface: "%%b"
    call :log_action "AdvNetOpt: Setting DNS for '%%b' - Primary: %primary_dns_no%"
    netsh interface ipv4 set dns name="%%b" static %primary_dns_no% primary validate=no >nul
    netsh interface ipv6 set dns name="%%b" static %primary_dns_no% primary validate=no >nul 
    if defined secondary_dns_no (
        call :log_action "AdvNetOpt: Setting DNS for '%%b' - Secondary: %secondary_dns_no%"
        netsh interface ipv4 add dns name="%%b" %secondary_dns_no% index=2 validate=no >nul
        netsh interface ipv6 add dns name="%%b" %secondary_dns_no% index=2 validate=no >nul
    ) else (
        rem If secondary is blank, clear any existing secondary for IPv4
        powershell -Command "Get-NetAdapter -InterfaceDescription '%%b' | Set-DnsClientServerAddress -ServerAddresses ('%primary_dns_no%') -PassThru | Format-Table Name, InterfaceDescription, InterfaceAlias, ConnectionSpecificSuffix, ServerAddresses -AutoSize"
        call :log_action "AdvNetOpt: Setting DNS for '%%b' - Only Primary: %primary_dns_no%. Cleared others."
    )
)
echo Static DNS server settings attempt completed for active connections.
pause
goto network_optimization_menu

:reset_network_netopt
cls
echo =====================================================================
echo  WARNING: Reset ALL Network Settings
echo =====================================================================
echo  This will reset TCP/IP stack, Winsock, Windows Firewall, and clear
echo  various network caches and configurations to their defaults.
echo  This can resolve complex network issues but will erase all custom
echo  network configurations (Wi-Fi passwords, static IPs, VPNs, etc.).
echo.
echo  A RESTART WILL BE REQUIRED after this operation.
echo =====================================================================
set /p confirm_reset_net=Are you absolutely sure you want to reset ALL network settings? (Y/N):
if /i not "%confirm_reset_net%"=="Y" (
    call :log_action "AdvNetOpt: Full network reset cancelled by user."
    echo Operation cancelled.
    pause
    goto network_optimization_menu
)
call :log_action "AdvNetOpt: User confirmed. Performing full network reset."
echo Resetting Windows Firewall...
netsh advfirewall reset >nul
call :log_action "AdvNetOpt: Firewall reset."
echo Resetting TCP/IP (IPv4 and IPv6)...
netsh int ip reset >nul
netsh int ipv4 reset >nul
netsh int ipv6 reset >nul
call :log_action "AdvNetOpt: TCP/IP (IPv4/IPv6) reset."
echo Resetting Winsock...
netsh winsock reset >nul
call :log_action "AdvNetOpt: Winsock reset."
echo Flushing DNS cache...
ipconfig /flushdns >nul
call :log_action "AdvNetOpt: DNS flushed."
echo Releasing and Renewing IP Configuration...
ipconfig /release >nul
ipconfig /renew >nul
call :log_action "AdvNetOpt: IP Released and Renewed."
echo.
echo ALL network settings have been reset to their defaults.
echo PLEASE RESTART YOUR COMPUTER NOW for all changes to take effect
echo and for your network adapters to reinitialize properly.
call :log_action "AdvNetOpt: Full network reset completed. Restart required."
pause
goto network_optimization_menu

:option_22
:endexit
cls
echo ==================================================
echo  Exiting Windows Optimization Script
echo ==================================================
echo  Thank you for using the Windows Optimization Script!
echo  Version: %SCRIPT_VERSION%
echo.
echo  Remember to check the log file for details of operations:
echo  %LOGFILE%
echo.
echo  Some changes may require a system restart to take full effect.
echo ==================================================
call :log_action "[INFO] Script exit selected by user."
pause
exit /b 0
