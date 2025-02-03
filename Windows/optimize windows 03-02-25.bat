@echo off
setlocal enabledelayedexpansion

:: --- Configuration ---
set SCRIPT_VERSION=v3.1 - Advanced Edition (Improved)
set LOG_FILE=optimization_script_log.txt
set SFC_LOG_FILE=%USERPROFILE%\Desktop\sfcdetails.txt

:: --- Function Definitions ---

:log_error
    echo ERROR: %~1
    echo [%DATE% %TIME%] ERROR: %~1 >> "%LOG_FILE%"
    exit /b 1

:log_message
    echo %~1
    echo [%DATE% %TIME%] %~1 >> "%LOG_FILE%"

:check_admin
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        echo Error: This script requires administrator privileges.
        echo Please run as administrator and try again.
        pause
        exit /b 1
    )
    goto :menu

:validate_choice
    set "choice=%~1"
    set "min_choice=%~2"
    set "max_choice=%~3"
    if not defined choice (
        echo Error: No input provided. Please try again.
        pause
        goto %~4
    )
    if not "%choice%"=="" (
        echo %choice%| findstr /r "^[0-9]*$" >nul
        if errorlevel 1 (
            echo Error: Invalid input. Please enter a number between %min_choice% and %max_choice%.
            pause
            goto %~4
        )
        if %choice% GEQ %min_choice% if %choice% LEQ %max_choice% (
            goto option_%choice%
        )
    )
    echo Error: Invalid choice. Please enter a number between %min_choice% and %max_choice%.
    pause
    goto %~4

:modify_registry
    setlocal
    set regPath=%~1
    set regName=%~2
    set regType=%~3
    set regValue=%~4
    set forceOption=
    if "%~5"=="/f" set forceOption=/f

    echo Setting Registry: "%regName%" in "%regPath%" to "%regValue%" (Type: %regType%)...
    reg add "%regPath%" /v "%regName%" /t %regType% /d "%regValue%" %forceOption%
    if %errorlevel% neq 0 (
        echo Error setting registry value. Error Code: %errorlevel%
        echo Check permissions and syntax.
        endlocal
        exit /b %errorlevel%
    )
    echo Registry value set successfully.
    endlocal
    exit /b 0

:set_ultimate_or_high_performance_power_plan
    powercfg /list | findstr /C:"Ultimate Performance" > nul
    if %errorlevel% equ 0 (
        goto set_ultimate_performance
    ) else (
        goto set_high_performance
    )
    exit /b 0

:netsh_set_global
    netsh int tcp set global %*
    if %errorlevel% neq 0 exit /b %errorlevel%
    exit /b 0

:powershell_command
    powershell -Command "%~1"
    if %errorlevel% neq 0 exit /b %errorlevel%
    exit /b 0

:bcdedit_command
    bcdedit %*
    if %errorlevel% neq 0 exit /b %errorlevel%
    exit /b 0

:sc_config_command
    sc config %*
    if %errorlevel% neq 0 exit /b %errorlevel%
    exit /b 0

:sc_start_stop_command
    sc %*
    if %errorlevel% neq 0 exit /b %errorlevel%
    exit /b 0


:: --- Main Menu ---

:menu
    cls
    @echo off
    color 0a

    echo =======================================================================
    echo.
    echo       ___  ____     ____  __  __ _   ___  ____  __   ____   __
    echo      / __)(_  _)  / ___)(  )(  ( \ / __)(_  _)/ _\ (  _ \ /  \
    echo     ( (_ \  )(    \___ \ )( /    /( (_ \  )( /    \ )   /(  O )
    echo      \___/ (__)   (____/(__)\_)__) \___/ (__)\_/\_/(__\_) \__/
    echo.
    echo =======================================================================
    echo.
    echo         Windows Optimization Script %SCRIPT_VERSION%
    echo.
    echo =======================================================================

    timeout /t 3 /nobreak > nul
    title Windows Optimization Script %SCRIPT_VERSION%

    echo ====================================
    echo Windows Optimization Script %SCRIPT_VERSION%
    echo ====================================
    echo Please select an option:
    echo ====================================

    echo 1.  Optimize display performance
    echo 2.  Manage Windows Defender
    echo 3.  Optimize Windows Features (Advanced)
    echo 4.  Optimize CPU (Advanced)
    echo 5.  Optimize Internet (Advanced)
    echo 6.  Manage Windows Update
    echo 7.  Configure Auto-login (Less Secure)
    echo 8.  Clear System Cache (Advanced)
    echo 9.  Optimize Disk (Advanced)
    echo 10. System Check and Repair (Advanced)
    echo 11. Windows Activation (USE WITH CAUTION)
    echo 12. Manage Power Settings (Advanced)
    echo 13. Enable/Disable Dark Mode
    echo 14. Manage Partitions (DISKPART - Advanced)
    echo 15. Clean Up Disk Space (DISKCLEANUP)
    echo 16. Manage Startup Programs (MSCONFIG)
    echo 17. Backup and Restore Settings (Advanced)
    echo 18. System Information (Detailed)
    echo 19. Optimize Privacy Settings (Advanced)
    echo 20. Manage Windows Services (Advanced)
    echo 21. Optimize Network Settings (Advanced)
    echo 22. Exit

    echo ====================================

    set /p choice=Enter your choice (1-22):
    call :validate_choice "%choice%" 1 22 menu
    exit /b

:: --- Option Implementations ---

:option_1
:optimize_display
    call :log_message "Optimizing display performance..."
    call :modify_registry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Display performance optimized."
    pause
    goto menu

:option_2
:manage_defender
    cls
    echo ===================================================================
    echo             Windows Defender Management - Advanced
    echo ===================================================================
    echo 1.  Check Windows Defender Status
    echo 2.  Enable Windows Defender Protection
    echo 3.  Disable Windows Defender Protection (HIGH RISK - NOT RECOMMENDED)
    echo 4.  Update Windows Defender Signatures
    echo 5.  Run Quick Scan for Threats
    echo 6.  Run Full System Scan for Threats (May take time)
    echo 7.  Manage Real-time Protection (Enable/Disable)
    echo 8.  Manage Cloud-delivered Protection (Enable/Disable)
    echo 9.  Manage Automatic Sample Submission (Enable/Disable)
    echo 10. Manage Potentially Unwanted Application (PUA) Protection (Enable/Disable)
    echo 11. View Threat History Log
    echo 12. Manage Exclusions
    echo      12.1. Add File Exclusion
    echo      12.2. Add Folder Exclusion
    echo      12.3. Remove Exclusion (by Path)
    echo      12.4. List All Exclusions
    echo 13. Manage Controlled Folder Access (Enable/Disable)
    echo 14. View Quarantined Threats
    echo 15. Return to Main Menu
    echo ===================================================================
    set /p def_choice=Enter your choice (1-15):
    call :validate_choice "%def_choice%" 1 15 manage_defender
    exit /b

:manage_exclusions_menu
    cls
    echo ==================================================
    echo             Manage Windows Defender Exclusions
    echo ==================================================
    echo 1. Add File Exclusion
    echo 2. Add Folder Exclusion
    echo 3. Remove Exclusion (by Path)
    echo 4. List All Exclusions
    echo 5. Return to Windows Defender Management Menu
    echo ==================================================
    set /p exclusion_choice=Enter your choice (1-5):
    call :validate_choice "%exclusion_choice%" 1 5 manage_exclusions_menu
    exit /b

:add_file_exclusion
    cls
    echo ==================================================
    echo              Add File Exclusion
    echo ==================================================
    set /p exclusion_path=Enter the full path to the file to exclude:
    if not exist "%exclusion_path%" (
        echo Error: File path does not exist. Please enter a valid file path.
        pause
        goto manage_exclusions_menu
    )
    call :powershell_command "Add-MpPreference -ExclusionPath '%exclusion_path%'"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "File exclusion added successfully: '%exclusion_path%'"
    pause
    goto manage_exclusions_menu

:add_folder_exclusion
    cls
    echo ==================================================
    echo              Add Folder Exclusion
    echo ==================================================
    set /p exclusion_path=Enter the full path to the folder to exclude:
    if not exist "%exclusion_path%" (
        echo Error: Folder path does not exist. Please enter a valid folder path.
        pause
        goto manage_exclusions_menu
    )
    call :powershell_command "Add-MpPreference -ExclusionPath '%exclusion_path%'"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Folder exclusion added successfully: '%exclusion_path%'"
    pause
    goto manage_exclusions_menu

:remove_exclusion
    cls
    echo ==================================================
    echo              Remove Exclusion (by Path)
    echo ==================================================
    set /p exclusion_path=Enter the full path of the exclusion to remove:
    call :powershell_command "Remove-MpPreference -ExclusionPath '%exclusion_path%'"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Exclusion removed successfully for path: '%exclusion_path%'"
    pause
    goto manage_exclusions_menu

:list_exclusions
    cls
    echo ==================================================
    echo              List All Exclusions
    echo ==================================================
    call :log_message "Listing all Windows Defender exclusions..."
    call :powershell_command "Get-MpPreference | Select-Object ExclusionPath | Format-List"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Exclusion list displayed above."
    pause
    goto manage_exclusions_menu

:manage_controlled_folder_access
    cls
    echo ==================================================
    echo         Manage Controlled Folder Access
    echo ==================================================
    echo 1. Check Controlled Folder Access Status
    echo 2. Enable Controlled Folder Access
    echo 3. Disable Controlled Folder Access
    echo 4. Return to Windows Defender Management Menu
    echo ==================================================
    set /p cfa_choice=Enter your choice (1-4):
    call :validate_choice "%cfa_choice%" 1 4 manage_controlled_folder_access
    exit /b

:check_cfa_status
    call :log_message "Checking Controlled Folder Access Status..."
    call :powershell_command "Get-MpPreference | Select-Object EnableControlledFolderAccess"
    pause
    goto manage_controlled_folder_access

:enable_cfa
    call :log_message "Enabling Controlled Folder Access..."
    call :powershell_command "Set-MpPreference -EnableControlledFolderAccess Enabled"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Controlled Folder Access Enabled."
    pause
    goto manage_controlled_folder_access

:disable_cfa
    call :log_message "Disabling Controlled Folder Access..."
    echo WARNING: Disabling Controlled Folder Access may reduce ransomware protection.
    set /p disable_cfa_confirm=Are you sure you want to DISABLE Controlled Folder Access? (Type YES to confirm):
    if /i "%disable_cfa_confirm%"=="YES" (
        call :powershell_command "Set-MpPreference -EnableControlledFolderAccess Disabled"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Controlled Folder Access Disabled."
    ) else (
        echo Disabling Controlled Folder Access Cancelled.
    )
    pause
    goto manage_controlled_folder_access

:view_quarantined_threats
    cls
    echo ==================================================
    echo             View Quarantined Threats
    echo ==================================================
    call :log_message "Displaying quarantined threats from Windows Defender..."
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles -path "\ProgramData\Microsoft\Windows Defender\Quarantine"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Quarantined Threats Displayed Above. Check the output for details."
    call :log_message "Note: This may show file paths, not actual file names in some cases."
    pause
    goto manage_defender

:check_defender
    call :log_message "Checking Windows Defender Status..."
    call :sc_start_stop_command query windefend
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Defender Service Status Check Completed."
    call :log_message "Check the output above for detailed service status."
    pause
    goto manage_defender

:enable_defender
    call :log_message "Enabling Windows Defender Protection..."
    call :log_message "Applying settings to enable Windows Defender and Real-Time Protection..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Defender Protection Enabled Successfully."
    pause
    goto manage_defender

:disable_defender
    echo ==========================================================================================
    echo  !!!  WARNING: DISABLING WINDOWS DEFENDER SIGNIFICANTLY INCREASES YOUR SYSTEM'S VULNERABILITY !!!
    echo  It is HIGHLY RECOMMENDED to keep Windows Defender enabled for continuous protection.
    echo  Disabling it should ONLY be done if you have a COMPELLING REASON and ALTERNATIVE SECURITY MEASURES
    echo  are in place and ACTIVELY RUNNING. Proceeding may expose your system to SERIOUS SECURITY RISKS.
    echo ==========================================================================================
    echo.
    set /p disable_confirm=Are you ABSOLUTELY SURE you want to DISABLE Windows Defender Protection? (Type YES to confirm - HIGH RISK):
    if /i "%disable_confirm%"=="YES" (
        call :log_message "Disabling Windows Defender Protection..."
        call :log_message "Applying settings to disable Windows Defender and Real-Time Protection..."
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableBehaviorMonitoring" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableOnAccessProtection" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "DisableScanOnRealtimeEnable" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Windows Defender Protection DISABLED."
        echo !!! YOUR SYSTEM IS NOW AT EXTREME RISK !!!
        echo Re-enable Windows Defender IMMEDIATELY and ensure other security measures are active.
    ) else (
        echo Disabling Windows Defender Protection Cancelled. Windows Defender remains ENABLED and PROTECTING your system.
    )
    pause
    goto manage_defender

:update_defender
    call :log_message "Updating Windows Defender Signatures..."
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Defender Signatures Updated Successfully."
    pause
    goto manage_defender

:quick_scan
    call :log_message "Running Quick Scan for Threats..."
    call :log_message "Starting a quick scan with Windows Defender..."
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Quick Scan Completed. Check the output above for scan results."
    pause
    goto manage_defender

:full_scan
    call :log_message "Running Full System Scan for Threats..."
    call :log_message "Starting a full system scan with Windows Defender in the background. This may take a considerable time."
    call :log_message "You can monitor the scan progress in the Windows Security app."
    start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    call :log_message "Full System Scan Started in the background."
    call :log_message "You can check the scan progress and results in Windows Security."
    pause
    goto manage_defender

:manage_realtime
    call :log_message "Managing Real-time Protection..."
    call :log_message "Current Real-time Protection Status:"
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring
    if %errorlevel% neq 0 (
        echo Warning: Unable to determine current Real-time Protection status.
    )
    set /p rtp_choice=Do you want to ENABLE (E) or DISABLE (D) Real-time Protection? (E/D):
    if /i "%rtp_choice%"=="E" (
        call :log_message "Enabling Real-time Protection..."
        reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /f
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Real-time Protection Enabled Successfully."
    ) else if /i "%rtp_choice%"=="D" (
        call :log_message "Disabling Real-time Protection..."
        call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" "DisableRealtimeMonitoring" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Real-time Protection Disabled."
        echo !!! WARNING: It is HIGHLY RECOMMENDED to keep Real-time Protection ENABLED for security !!!
    ) else (
        echo Error: Invalid choice. Please enter E or D.
    )
    pause
    goto manage_defender

:manage_cloud
    call :log_message "Managing Cloud-delivered Protection..."
    call :log_message "Current Cloud-delivered Protection Status:"
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting
    if %errorlevel% neq 0 (
        echo Warning: Unable to determine current Cloud-delivered Protection status.
    )
    set /p cloud_choice=Do you want to ENABLE (E) or DISABLE (D) Cloud-delivered Protection? (E/D):
    if /i "%cloud_choice%"=="E" (
        call :log_message "Enabling Cloud-delivered Protection..."
        call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "2"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Cloud-delivered Protection Enabled."
    ) else if /i "%cloud_choice%"=="D" (
        call :log_message "Disabling Cloud-delivered Protection..."
        call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Cloud-delivered Protection Disabled."
        call :log_message "Recommendation: It is generally recommended to keep Cloud-delivered Protection ENABLED for enhanced threat detection."
    ) else (
        echo Error: Invalid choice. Please enter E or D.
    )
    pause
    goto manage_defender

:manage_samples
    call :log_message "Managing Automatic Sample Submission..."
    call :log_message "Current Automatic Sample Submission Status:"
    reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent
    if %errorlevel% neq 0 (
        echo Warning: Unable to determine current Automatic Sample Submission status.
    )
    set /p sample_choice=Do you want to ENABLE (E) or DISABLE (D) Automatic Sample Submission? (E/D):
    if /i "%sample_choice%"=="E" (
        call :log_message "Enabling Automatic Sample Submission..."
        call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Automatic Sample Submission Enabled."
    ) else if /i "%sample_choice%"=="D" (
        call :log_message "Disabling Automatic Sample Submission..."
        call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "0"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Automatic Sample Submission Disabled."
    ) else (
        echo Error: Invalid choice. Please enter E or D.
    )
    pause
    goto manage_defender

:manage_pua
    call :log_message "Managing Potentially Unwanted Application (PUA) Protection..."
    call :log_message "Current Potentially Unwanted Application (PUA) Protection Status:"
    reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" /v PUAProtection
    if %errorlevel% neq 0 (
        echo Current PUA Protection Status: Default (likely Disabled if not configured by policy).
    )
    echo Choose PUA Protection Mode:
    echo 1. Enable PUA Protection (Block)
    echo 2. Disable PUA Protection
    set /p pua_choice=Enter your choice (1-2):
    call :validate_choice "%pua_choice%" 1 2 manage_pua
    if %errorlevel% neq 0 exit /b
    if "%pua_choice%"=="1" (
        call :log_message "Enabling PUA Protection (Block Mode)..."
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" "PUAProtection" "REG_DWORD" "1"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Potentially Unwanted Application (PUA) Protection Enabled (Block Mode)."
    ) else if "%pua_choice%"=="2" (
        call :log_message "Disabling PUA Protection..."
        call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\PUAProtection" "PUAProtection" "REG_DWORD" "0"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Potentially Unwanted Application (PUA) Protection Disabled."
    )
    pause
    goto manage_defender

:view_history
    call :log_message "Viewing Threat History Log..."
    call :log_message "Displaying recent threat history from Windows Defender:"
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Threat History Displayed Above. Check the output for details."
    pause
    goto manage_defender

:option_3
:optimize_features
    cls
    echo ======================================================
    echo Windows Features Optimization - Advanced
    echo ======================================================
    echo 1.  Disable Activity Feed (Timeline)
    echo 2.  Disable Background Apps
    echo 3.  Disable Cortana
    echo 4.  Disable Game DVR and Game Bar
    echo 5.  Disable Sticky Keys Prompt
    echo 6.  Disable Windows Tips and Notifications
    echo 7.  Disable Start Menu Suggestions and Ads
    echo 8.  Enable Fast Startup
    echo ------------------------------------------------------
    echo 9.  Disable Lock Screen Ads and Spotlight
    echo 10. Disable Ink Workspace
    echo 11. Disable People Bar (My People)
    echo 12. Disable Web Search in Start Menu
    echo 13. Disable Location Services (System-wide)
    echo 14. Disable Camera Access (For all apps)
    echo 15. Disable Microphone Access (For all apps)
    echo 16. Disable Advertising ID
    echo 17. Disable Telemetry and Data Collection (Basic Level)
    echo ------------------------------------------------------
    echo 18. Uninstall OneDrive (Optional - Requires User Confirmation)
    echo 19. Disable Customer Experience Improvement Program (CEIP)
    echo 20. Disable Error Reporting
    echo 21. Disable Compatibility Telemetry
    echo ------------------------------------------------------
    echo 22. Revert all Feature Optimizations (Undo Changes)
    echo 23. Return to main menu
    echo ======================================================
    set /p feature_choice=Enter your choice (1-23):
    call :validate_choice "%feature_choice%" 1 23 optimize_features
    exit /b

:disable_activity_feed
    call :log_message "Disabling Activity Feed (Timeline)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Activity Feed (Timeline) disabled."
    pause
    goto optimize_features

:disable_background_apps
    call :log_message "Disabling Background Apps..."
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Background Apps disabled."
    pause
    goto optimize_features

:disable_cortana
    call :log_message "Disabling Cortana..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Cortana disabled."
    pause
    goto optimize_features

:disable_game_dvr_bar
    call :log_message "Disabling Game DVR and Game Bar..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Game DVR and Game Bar disabled."
    pause
    goto optimize_features

:disable_sticky_keys_prompt
    call :log_message "Disabling Sticky Keys Prompt..."
    call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Sticky Keys Prompt disabled."
    pause
    goto optimize_features

:disable_windows_tips
    call :log_message "Disabling Windows Tips and Notifications..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Tips and Notifications disabled."
    pause
    goto optimize_features

:disable_startmenu_suggestions
    call :log_message "Disabling Start Menu Suggestions and Ads..."
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Start Menu Suggestions and Ads disabled."
    pause
    goto optimize_features

:enable_fast_startup
    call :log_message "Enabling Fast Startup..."
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Fast Startup enabled."
    pause
    goto optimize_features

:disable_lockscreen_ads
    call :log_message "Disabling Lock Screen Ads and Spotlight..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Lock Screen Ads and Spotlight disabled."
    pause
    goto optimize_features

:disable_ink_workspace
    call :log_message "Disabling Ink Workspace..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Ink Workspace" "AllowInkWorkspace" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Ink Workspace disabled."
    pause
    goto optimize_features

:disable_people_bar
    call :log_message "Disabling People Bar (My People)..."
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "People Bar (My People) disabled."
    pause
    goto optimize_features

:disable_web_search_startmenu
    call :log_message "Disabling Web Search in Start Menu..."
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Web Search in Start Menu disabled."
    pause
    goto optimize_features

:disable_location_services
    call :log_message "Disabling Location Services (System-wide)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Location Services (System-wide) disabled."
    pause
    goto optimize_features

:disable_camera_access
    call :log_message "Disabling Camera Access (For all apps)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" ""
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "*"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Camera Access (For all apps) disabled."
    pause
    goto optimize_features

:disable_microphone_access
    call :log_message "Disabling Microphone Access (For all apps)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" ""
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "*"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Microphone Access (For all apps) disabled."
    pause
    goto optimize_features

:disable_advertising_id
    call :log_message "Disabling Advertising ID..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Advertising ID disabled."
    pause
    goto optimize_features

:disable_telemetry_basic
    call :log_message "Disabling Telemetry and Data Collection (Basic Level)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Telemetry and Data Collection (Basic Level) disabled."
    pause
    goto optimize_features

:uninstall_onedrive
    call :log_message "Uninstalling OneDrive (Optional)..."
    set /p confirm_onedrive=Are you sure you want to uninstall OneDrive? (Y/N - Recommended to choose N if you use OneDrive):
    if /i "%confirm_onedrive%"=="Y" (
        if exist "%ProgramFiles%\OneDrive\setup.exe" (
            call :log_message "Uninstalling OneDrive (per-machine)..."
            "%ProgramFiles%\OneDrive\setup.exe" /uninstall
        ) else if exist "%LocalAppData%\Microsoft\OneDrive\Update\OneDriveSetup.exe" (
            call :log_message "Uninstalling OneDrive (per-user)..."
            "%LocalAppData%\Microsoft\OneDrive\Update\OneDriveSetup.exe" /uninstall
        ) else (
            echo OneDrive uninstaller not found. OneDrive may not be installed or uninstallation method may need to be adjusted.
        )
        call :log_message "OneDrive uninstallation process started. Please check for completion."
        call :log_message "You may need to manually remove OneDrive folders after uninstallation."
    ) else (
        echo OneDrive uninstallation cancelled.
    )
    pause
    goto optimize_features

:disable_ceip
    call :log_message "Disabling Customer Experience Improvement Program (CEIP)..."
    call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Customer Experience Improvement Program (CEIP) disabled."
    pause
    goto optimize_features

:disable_error_reporting
    call :log_message "Disabling Error Reporting..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Error Reporting disabled."
    pause
    goto optimize_features

:disable_compatibility_telemetry
    call :log_message "Disabling Compatibility Telemetry..."
    call :sc_config_command "DiagTrack" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Compatibility Telemetry (Diagnostic Tracking Service) disabled."
    pause
    goto optimize_features

:revert_feature_optimizations
    call :log_message "Reverting All Feature Optimizations..."
    call :log_message "Restoring default settings for optimized features."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "502"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows Ink Workspace" "AllowInkWorkspace" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "DiagTrack" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Feature optimizations reverted to default settings."
    pause
    goto optimize_features

:option_4
:optimize_cpu
    cls
    echo ==============================================================="
    echo "                 CPU Optimization - Advanced & Comprehensive"
    echo "             [ Optimized for Windows 10 & Windows 11 ]"
    echo ==============================================================="
    echo " Advanced CPU optimization for maximum performance on Windows 10 & 11."
    echo ==============================================================="
    echo "WARNING: Incorrect settings can cause system instability."
    echo "         Understand each option before applying."
    echo ==============================================================="

    echo Select an optimization category:
    echo ==============================================================="
    echo 1. Power Management
    echo 2. Scheduling & Responsiveness
    echo 3. Core Parking & Services
    echo 4. Visual Effects
    echo 5. Boot Performance
    echo --------------------------------------------------------------
    echo 6. Comprehensive CPU Optimization (Advanced)
    echo 7. Revert All CPU Optimizations
    echo --------------------------------------------------------------
    echo 8. Display Current CPU Settings
    echo 9. Advanced Performance Tools
    echo --------------------------------------------------------------
    echo 10. Return to Main Menu
    echo ==============================================================="
    set /p cpu_category_choice=Enter choice (1-10):
    call :validate_choice "%cpu_category_choice%" 1 10 optimize_cpu
    exit /b

:cpu_category_option_1
:cpu_power_management
    cls
    echo ==============================================================="
    echo "            CPU Optimization - Power Management"
    echo ==============================================================="
    echo " Optimize CPU power settings for better performance."
    echo ==============================================================="
    echo 1. Set High Performance Plan (Desktops)
    echo 2. Set Ultimate Performance Plan (If Available - Windows 11 Recommended)
    echo 3. Disable CPU Throttling (Max Performance - May Increase Heat)
    echo 4. Aggressive Performance Boost Mode
    echo 5. Adjust Processor State (Min/Max Power)
    echo --------------------------------------------------------------
    echo 6. Revert Power Management Optimizations
    echo 7. Return to CPU Optimization Menu
    echo ==============================================================="
    set /p cpu_power_choice=Enter choice (1-7):
    call :validate_choice "%cpu_power_choice%" 1 7 cpu_power_management
    exit /b

:set_ultimate_performance
    call :log_message "Setting Ultimate Performance Power Plan..."
    powercfg /list | findstr /C:"Ultimate Performance" > nul
    if %errorlevel% neq 0 (
        echo Ultimate Performance plan not found. Creating...
        powercfg -duplicatescheme e9a42b02-d5df-44c8-aa00-0003f1474963
        if %errorlevel% neq 0 goto error_handler
    )
    powercfg -setactive e9a42b02-d5df-44c8-aa00-0003f1474963
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Ultimate Performance plan set."
    pause
    goto cpu_power_management

:set_high_performance
    call :log_message "Setting High Performance Power Plan..."
    powercfg -setactive 8c5e7fda-e8bf-4a96-94b6-fe8dd03c9a8c
    if %errorlevel% neq 0 goto error_handler
    call :log_message "High Performance plan set."
    pause
    goto cpu_power_management

:disable_throttling
    call :log_message "Disabling CPU Throttling..."
    powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMAX -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMIN -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 0
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 0
    if %errorlevel% neq 0 goto error_handler
    powercfg -SetActive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "CPU Throttling disabled."
    pause
    goto cpu_power_management

:adjust_power_management
    call :log_message "Setting Performance Boost Mode to Aggressive..."
    powercfg -attributes SUB_PROCESSOR PERFBOOSTMODE -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR PERFBOOSTMODE aggressive
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PERFBOOSTMODE aggressive
    if %errorlevel% neq 0 goto error_handler
    powercfg -SetActive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Performance Boost Mode set to Aggressive."
    pause
    goto cpu_power_management

:adjust_processor_state
    call :log_message "Adjusting Processor State..."
    call :log_message "Setting Minimum Processor State to 5%..."
    powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMIN -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 5
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMIN 5
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Setting Maximum Processor State to 100%..."
    powercfg -attributes SUB_PROCESSOR PROCTHROTTLEMAX -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR PROCTHROTTLEMAX 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -SetActive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Processor State adjusted."
    pause
    goto cpu_power_management

:revert_power_management_optimizations
    call :log_message "Reverting Power Management Optimizations..."
    call :log_message "Setting active power plan to Balanced..."
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power Management optimizations reverted."
    pause
    goto cpu_power_management

:cpu_category_option_2
:cpu_scheduling_responsiveness
    cls
    echo ==============================================================="
    echo "         CPU Optimization - Scheduling & Responsiveness"
    echo ==============================================================="
    echo " Optimize CPU scheduling for better program responsiveness."
    echo ==============================================================="
    echo 1. Optimize Scheduling for Programs (Responsiveness)
    echo 2. Prioritize Programs over Background Services
    echo 3. Enable Hardware-accelerated GPU Scheduling (Graphics - Win10 2004+/Win11)
    echo --------------------------------------------------------------
    echo 4. Revert Scheduling Optimizations
    echo 5. Return to CPU Optimization Menu
    echo ==============================================================="
    set /p cpu_schedule_choice=Enter choice (1-5):
    call :validate_choice "%cpu_schedule_choice%" 1 5 cpu_scheduling_responsiveness
    exit /b

:optimize_scheduling
    call :log_message "Optimizing Scheduling for Programs..."
    call :log_message "Reduce background task priority for better program responsiveness."
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolHysteresisIntervals" "REG_DWORD" "5"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolMaximumThreads" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolSchedulingPolicy" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Scheduling optimized for programs."
    pause
    goto cpu_scheduling_responsiveness

:adjust_system_responsiveness
    call :log_message "Prioritizing Programs for Responsiveness..."
    call :log_message "Foreground programs prioritized over background services."
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "REG_DWORD" "14"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "REG_SZ" "High"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "PriorityClass" "REG_DWORD" "8"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Program responsiveness prioritized."
    pause
    goto cpu_scheduling_responsiveness

:enable_gpu_scheduling
    call :log_message "Enabling GPU Scheduling..."
    ver | findstr /C:"Version 10.0" > nul
    if %errorlevel% equ 0 (
        call :log_message "Windows 10+ detected. Enabling GPU Scheduling..."
        call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "GPU Scheduling enabled. Restart may be needed."
    ) else (
        echo GPU Scheduling available on Windows 10 2004+ / Windows 11 only.
        echo Your system may not support this.
    )
    pause
    goto cpu_scheduling_responsiveness

:revert_scheduling_optimizations
    call :log_message "Reverting Scheduling Optimizations..."
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "/d 2" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "REG_SZ" "Medium" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "PriorityClass" "REG_DWORD" "/d 4" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolHysteresisIntervals" "REG_DWORD" "/d 10" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolMaximumThreads" "REG_DWORD" "/d 2147483647" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemThreadPool" "ThreadPoolSchedulingPolicy" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Scheduling optimizations reverted."
    pause
    goto cpu_scheduling_responsiveness

:cpu_category_option_3
:cpu_core_services
    cls
    echo ==============================================================="
    echo "           CPU Optimization - Core Parking & Services"
    echo ==============================================================="
    echo " Manage CPU core parking and unnecessary system services."
    echo ==============================================================="
    echo 1. Disable CPU Core Parking (Consistent Performance)
    echo 2. Disable Unnecessary Services (Caution - May Affect Functionality - Windows 11 Notes Below)
    echo "   - Windows 11 Notes: Service behavior may differ from Windows 10."
    echo "     Test after disabling. Disable ""SysMain"" & ""DiagTrack"" cautiously."
    echo "     Disable ""Windows Search"" (WSearch) only if not used."
    echo --------------------------------------------------------------
    echo 3. Revert Core Parking & Services Optimizations
    echo 4. Return to CPU Optimization Menu
    echo ==============================================================="
    set /p cpu_core_choice=Enter choice (1-4):
    call :validate_choice "%cpu_core_choice%" 1 4 cpu_core_services
    exit /b

:disable_core_parking
    call :log_message "Disabling CPU Core Parking..."
    powercfg -attributes SUB_PROCESSOR CPMINCORES -ATTRIB_HIDE
    if %errorlevel% neq 0 goto error_handler
    powercfg -setacvalueindex scheme_current SUB_PROCESSOR CPMINCORES 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current SUB_PROCESSOR CPMINCORES 100
    if %errorlevel% neq 0 goto error_handler
    powercfg -SetActive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "CPU Core Parking disabled."
    pause
    goto cpu_core_services

:disable_services
    cls
    echo ==============================================================="
    echo "          Disable Unnecessary System Services (Caution)"
    echo ==============================================================="
    echo " Disabling services may improve performance but affect system functions."
    echo " Proceed with caution and test your system afterwards."
    echo ==============================================================="
    echo "Select services to disable:"
    echo 1. Disable SysMain (Superfetch) - (May affect app preloading)
    echo 2. Disable Diagnostic Tracking (DiagTrack) - (Telemetry & Diagnostics)
    echo 3. Disable Windows Search (WSearch) - (Disables file indexing - NOT RECOMMENDED for most)
    echo --------------------------------------------------------------
    echo 4. Disable SysMain, DiagTrack, & WSearch (Aggressive - Advanced Users)
    echo 5. Return to Core Parking & Services Menu
    echo ==============================================================="
    set /p disable_service_choice=Enter choice (1-5):
    call :validate_choice "%disable_service_choice%" 1 5 disable_services
    exit /b

:disable_sysmain
    call :log_message "Disabling SysMain (Superfetch) Service..."
    call :sc_config_command "SysMain" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "SysMain"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "SysMain service disabled."
    pause
    goto disable_services

:disable_diagtrack
    call :log_message "Disabling Diagnostic Tracking Service (DiagTrack)..."
    call :sc_config_command "DiagTrack" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Diagnostic Tracking Service disabled."
    pause
    goto disable_services

:disable_wsearch
    echo WARNING: Disabling Windows Search disables file indexing & search.
    echo         Only proceed if you don't use Windows Search.
    pause
    call :log_message "Disabling Windows Search (WSearch) Service..."
    call :sc_config_command "WSearch" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "WSearch"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Search service disabled."
    pause
    goto disable_services

:disable_all_services
    call :log_message "Disabling SysMain, DiagTrack, & Windows Search Services..."
    call :log_message "Disabling SysMain..."
    call :sc_config_command "SysMain" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "SysMain"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling DiagTrack..."
    call :sc_config_command "DiagTrack" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling Windows Search..."
    call :sc_config_command "WSearch" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "WSearch"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "SysMain, DiagTrack, & Windows Search services disabled."
    echo WARNING: System functionality may be affected. Test thoroughly.
    pause
    goto disable_services

:revert_core_services_optimizations
    call :log_message "Reverting Core Parking & Services Optimizations..."
    powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 0
    if %errorlevel% neq 0 goto error_handler
    powercfg -setdcvalueindex scheme_current sub_processor CPMINCORES 0
    if %errorlevel% neq 0 goto error_handler
    powercfg -SetActive scheme_current
    if %errorlevel% neq 0 goto error_handler

    call :sc_config_command "SysMain" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "SysMain"
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "DiagTrack" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "WSearch" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "WSearch"
    if %errorlevel% neq 0 goto error_handler

    call :log_message "Core Parking & Services optimizations reverted."
    pause
    goto cpu_core_services

:cpu_category_option_4
:cpu_visual_effects
    cls
    echo ==============================================================="
    echo "           CPU Optimization - Visual Effects"
    echo ==============================================================="
    echo " Adjust visual effects for better performance."
    echo ==============================================================="
    echo 1. Adjust for Best Performance (Fastest Appearance)
    echo --------------------------------------------------------------
    echo 2. Revert Visual Effects Optimizations
    echo 3. Return to CPU Optimization Menu
    echo ==============================================================="
    set /p cpu_visual_choice=Enter choice (1-3):
    call :validate_choice "%cpu_visual_choice%" 1 3 cpu_visual_effects
    exit /b

:adjust_visual_effects
    call :log_message "Adjusting Visual Effects for Best Performance..."
    call :log_message "Setting visual effects to ""Adjust for best performance""..."
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Visual effects adjusted for best performance."
    pause
    goto cpu_visual_effects

:revert_visual_effects_optimizations
    call :log_message "Reverting Visual Effects Optimizations..."
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Visual Effects optimizations reverted (Windows default)."
    pause
    goto cpu_visual_effects

:cpu_category_option_5
:cpu_boot_performance
    cls
    echo ==============================================================="
    echo "           CPU Optimization - Boot Performance"
    echo ==============================================================="
    echo " Improve boot performance for faster startup."
    echo ==============================================================="
    echo 1. Enable Multi-core Boot (Use all CPU cores - Restart Required)
    echo 2. Disable Memory Limit for Boot (Use all RAM - Restart Required)
    echo --------------------------------------------------------------
    echo 3. Revert Boot Performance Enhancements
    echo 4. Return to CPU Optimization Menu
    echo ==============================================================="
    set /p cpu_boot_choice=Enter choice (1-4):
    call :validate_choice "%cpu_boot_choice%" 1 4 cpu_boot_performance
    exit /b

:enable_multicore_boot
    call :log_message "Enabling Multi-core Boot..."
    call :log_message "Setting Windows to use all processors during startup..."
    call :bcdedit_command /set "{current}" numproc /enum
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Multi-core Boot enabled. Restart for changes."
    pause
    goto cpu_boot_performance

:disable_maxmem_boot
    call :log_message "Disabling Memory Limit for Boot..."
    call :log_message "Ensuring Windows uses all available RAM during startup..."
    call :bcdedit_command /deletevalue "{current}" truncatememory
    if %errorlevel% neq 0 goto error_handler
    call :bcdedit_command /deletevalue "{current}" removememory
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Memory Limit for Boot disabled. Restart for changes."
    pause
    goto cpu_boot_performance

:revert_boot_optimizations
    call :log_message "Reverting Boot Performance Enhancements..."
    call :bcdedit_command /deletevalue "{current}" numproc
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Boot Performance enhancements reverted."
    pause
    goto cpu_boot_performance

:cpu_category_option_6
:cpu_comprehensive_optimize
    cls
    echo ==============================================================="
    echo "         CPU Optimization - Comprehensive (Advanced)"
    echo ==============================================================="
    echo " Comprehensive CPU optimization for maximum performance."
    echo " Includes:"
    echo "- Ultimate/High Performance plan"
    echo "- Disable CPU throttling & core parking"
    echo "- Optimize scheduling & power"
    echo "- Enable GPU scheduling"
    echo "- Disable SysMain & DiagTrack (Caution)"
    echo "- Best performance visual effects"
    echo "- Multi-core & Max Memory Boot"
    echo ==============================================================="
    echo "WARNING: Aggressive optimization. May reduce system stability."
    echo "         Recommended for advanced users only."
    echo ==============================================================="
    pause

    call :log_message "Applying Ultimate or High Performance Power Plan..."
    call :set_ultimate_or_high_performance
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling CPU Throttling..."
    call :disable_throttling
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Optimizing Processor Scheduling..."
    call :optimize_scheduling
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling CPU Core Parking..."
    call :disable_core_parking
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Setting Performance Boost Mode..."
    call :adjust_power_management
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Enabling GPU Scheduling..."
    call :enable_gpu_scheduling
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling SysMain & DiagTrack Services..."
    call :disable_sysmain
    if %errorlevel% neq 0 goto error_handler
    call :disable_diagtrack
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Adjusting Visual Effects..."
    call :adjust_visual_effects
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Enabling Multi-core Boot..."
    call :enable_multicore_boot
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disabling Memory Limit for Boot..."
    call :disable_maxmem_boot
    if %errorlevel% neq 0 goto error_handler

    call :log_message "Comprehensive CPU Optimization Applied."
    echo Restart your computer for full effect.
    pause
    goto optimize_cpu

:cpu_category_option_7
:revert_cpu_optimizations
    cls
    echo ==============================================================="
    echo "             Revert All CPU Optimizations to Default"
    echo ==============================================================="
    echo " Reverting all CPU optimizations applied by this script."
    echo " Includes:"
    echo "- Balanced power plan"
    echo "- Re-enable CPU throttling & core parking"
    echo "- Revert scheduling & power"
    echo "- Disable GPU scheduling"
    echo "- Re-enable system services (SysMain, DiagTrack, WSearch)"
    echo "- Default visual effects"
    echo "- Default Boot settings"
    echo ==============================================================="
    echo Please wait, reverting optimizations...
    pause

    call :log_message "Setting Balanced Power Plan and Reverting Power Management..."
    call :revert_power_management_optimizations
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Reverting Scheduling Optimizations..."
    call :revert_scheduling_optimizations
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Reverting Core Parking & Services Optimizations..."
    call :revert_core_services_optimizations
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Reverting Visual Effects Optimizations..."
    call :revert_visual_effects_optimizations
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Reverting Boot Optimizations..."
    call :revert_boot_optimizations
    if %errorlevel% neq 0 goto error_handler

    call :log_message "All CPU Optimizations Reverted to Default."
    echo Restart your computer for full effect.
    pause
    goto optimize_cpu

:cpu_category_option_8
:cpu_monitoring
    cls
    echo ==============================================================="
    echo "             Display Current CPU Settings & Status"
    echo ==============================================================="
    echo " Displaying current CPU related settings:"
    echo ==============================================================="

    echo.
    echo --- Current Power Plan ---
    powercfg /getactivescheme

    echo.
    echo --- CPU Throttling Status ---
    powercfg /q scheme_current sub_processor PROCTHROTTLEMAX
    powercfg /q scheme_current sub_processor PROCTHROTTLEMIN

    echo.
    echo --- CPU Core Parking Status ---
    powercfg /q scheme_current sub_processor CPMINCORES

    echo.
    echo --- Performance Boost Mode ---
    powercfg /q scheme_current sub_processor PERFBOOSTMODE

    echo.
    echo --- GPU Scheduling ---
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode

    echo.
    echo --- System Services Status (SysMain, DiagTrack, WSearch) ---
    echo SysMain (Superfetch) Service Status:
    sc query SysMain
    echo.
    echo Diagnostic Tracking Service Status:
    sc query DiagTrack
    echo.
    echo Windows Search Service Status:
    sc query WSearch

    echo.
    echo --- Boot Performance Settings ---
    echo Multi-core Boot Status:
    bcdedit /get "{current}" numproc
    echo.
    echo Memory Limit Boot Status (TruncateMemory):
    bcdedit /get "{current}" truncatememory
    echo.
    echo Memory Limit Boot Status (RemoveMemory):
    bcdedit /get "{current}" removememory

    echo.
    echo ==============================================================="
    echo "CPU Settings Displayed. Review output above."
    pause
    goto optimize_cpu

:cpu_category_option_9
:cpu_advanced_tools
    cls
    echo ==============================================================="
    echo "         Advanced Performance Tools & Information"
    echo ==============================================================="
    echo " For in-depth CPU analysis & tuning, consider these tools:"
    echo ==============================================================="

    echo 1. Windows Performance Analyzer (WPA):
    echo "   - Powerful tool from Microsoft for system performance analysis."
    echo "   - Includes CPU usage, bottlenecks, and more."
    echo "   - Part of Windows ADK. Download: [https://developer.microsoft.com/en-us/windows/hardware/windows-assessment-deployment-kit]"

    echo.
    echo 2. Process Lasso:
    echo "   - Third-party tool for real-time CPU optimization & process management."
    echo "   - ProBalance prevents process CPU monopolization."
    echo "   - Website: https://bitsum.com/"

    echo.
    echo 3. Performance Monitor (perfmon.exe):
    echo "   - Built-in Windows tool for real-time monitoring of CPU, memory, disk, network."
    echo "   - Create custom data collector sets for logging."

    echo.
    echo 4. Resource Monitor (resmon.exe):
    echo "   - Built-in Windows tool for real-time resource overview."
    echo "   - Shows CPU, memory, disk, network usage. Identify CPU intensive processes."

    echo ==============================================================="
    echo "These tools offer advanced performance tuning capabilities."
    echo "Recommended for users needing detailed CPU performance insights."
    echo ==============================================================="
    pause
    goto optimize_cpu

:cpu_category_option_10
    goto menu

:option_5
:optimize_internet
    cls
    echo ======================================================
    echo Internet Performance Optimization - Advanced
    echo ======================================================
    echo 1.  Basic TCP Optimizations (Auto-tuning, Congestion Control)
    echo 2.  Advanced TCP Optimizations (Low Latency Focus)
    echo 3.  Enable/Disable TCP Fast Open
    echo 4.  Adjust TCP Window Size (Auto-tuning Normal)
    echo 5.  Optimize for Low Latency Gaming (TCP No Delay, etc.)
    echo 6.  DNS Optimization (Set Custom DNS Servers)
    echo 7.  Flush DNS Resolver Cache
    echo 8.  Optimize Network Adapter Settings (Advanced Tuning)
    echo 9.  Disable Network Adapter Power Saving (For Consistent Performance)
    echo 10. Enable Jumbo Frames (Caution - Compatibility)
    echo 11. Enable QoS Packet Scheduler (Prioritize Network Traffic)
    echo 12. Reset Network Settings (Comprehensive Reset)
    echo 13. Test Internet Speed and Latency (Basic Test)
    echo 14. Revert all Internet Optimizations (Undo Changes)
    echo 15. Return to main menu
    echo ======================================================
    set /p net_choice=Enter your choice (1-15):
    call :validate_choice "%net_choice%" 1 15 optimize_internet
    exit /b

:basic_tcp_optimizations
    call :log_message "Performing Basic TCP Optimizations..."
    call :netsh_set_global autotuninglevel=normal
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global congestionprovider=ctcp
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global timestamps=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=enabled
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Basic TCP optimizations completed."
    pause
    goto optimize_internet

:advanced_tcp_low_latency
    call :log_message "Performing Advanced TCP Optimizations (Low Latency Focus)..."
    call :netsh_set_global congestionprovider=ctcp
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global heuristics=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global fastopen=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global hystart=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global pacingprofile=off
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Advanced TCP optimizations (Low Latency) completed."
    pause
    goto optimize_internet

:toggle_tcp_fastopen
    echo 1. Enable TCP Fast Open
    echo 2. Disable TCP Fast Open
    set /p fastopen_choice=Enter your choice (1-2):
    call :validate_choice "%fastopen_choice%" 1 2 toggle_tcp_fastopen
    if %errorlevel% neq 0 exit /b
    if "%fastopen_choice%"=="1" (
        call :netsh_set_global fastopen=enabled
        if %errorlevel% neq 0 goto error_handler
        call :log_message "TCP Fast Open enabled."
    ) else if "%fastopen_choice%"=="2" (
        call :netsh_set_global fastopen=disabled
        if %errorlevel% neq 0 goto error_handler
        call :log_message "TCP Fast Open disabled."
    )
    pause
    goto optimize_internet

:adjust_tcp_window
    call :log_message "Adjusting TCP Window Size to Auto-tuning Normal..."
    call :netsh_set_global autotuninglevel=normal
    if %errorlevel% neq 0 goto error_handler
    call :log_message "TCP Window Size adjusted to Auto-tuning Normal."
    pause
    goto optimize_internet

:optimize_low_latency_gaming
    call :log_message "Optimizing for Low Latency Gaming..."
    call :netsh_set_global congestionprovider=ctcp
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global heuristics=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global fastopen=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global timestamps=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global initialRto=2000
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global nonsackrttresiliency=disabled
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Low Latency Gaming optimizations applied."
    pause
    goto optimize_internet

:dns_optimization_custom
    call :log_message "Setting Custom DNS Servers..."
    set /p primary_dns=Enter primary DNS server (e.g., 8.8.8.8):
    set /p secondary_dns=Enter secondary DNS server (e.g., 8.8.4.4 - Optional, press Enter to skip):
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
        call :log_message "Setting DNS for interface: ""%%j"""
        netsh interface ip set dns name="%%j" source=static address="%primary_dns%"
        if %errorlevel% neq 0 goto error_handler
        if not "%secondary_dns%"=="" (
            netsh interface ip add dns name="%%j" address="%secondary_dns%" index=2
            if %errorlevel% neq 0 goto error_handler
        )
    )
    call :log_message "Custom DNS servers set."
    pause
    goto optimize_internet

:flush_dns_cache
    call :log_message "Flushing DNS Resolver Cache..."
    ipconfig /flushdns
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DNS Resolver Cache flushed."
    pause
    goto optimize_internet

:adapter_tuning_advanced
    call :log_message "Tuning Network Adapter Settings (Advanced)..."
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        call :log_message "Tuning adapter: ""%%j"""
        netsh int ip set interface "%%j" dadtransmits=0 store=persistent
        if %errorlevel% neq 0 goto error_handler
        netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue 0}"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Network adapter settings tuned (Advanced)."
    pause
    goto optimize_internet

:disable_adapter_powersave
    call :log_message "Disabling Network Adapter Power Saving..."
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        call :powershell_command "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$false"
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Network Adapter Power Saving disabled."
    pause
    goto optimize_internet

:enable_jumbo_frames
    echo WARNING: Enabling Jumbo Frames may cause network issues if not supported by your network.
    set /p confirm_jumbo=Are you sure you want to enable Jumbo Frames? (Y/N):
    if /i "%confirm_jumbo%"=="Y" (
        set /p jumbo_value=Enter Jumbo Frame value in bytes (e.g., 9014 for 9KB):
        for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
            call :powershell_command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*JumboPacket' -RegistryValue %jumbo_value%"
            if %errorlevel% neq 0 goto error_handler
        )
        call :log_message "Jumbo Frames enabled with value %jumbo_value%."
    ) else (
        echo Jumbo Frames enabling cancelled.
    )
    pause
    goto optimize_internet

:enable_qos_scheduler
    call :log_message "Enabling QoS Packet Scheduler..."
    call :netsh_set_global packetcoalescinginbound=disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "Qwave" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "Qwave"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "QoS Packet Scheduler enabled."
    pause
    goto optimize_internet

:reset_network_comprehensive
    call :log_message "Resetting All Network Settings (Comprehensive)..."
    echo This will reset Winsock, IP, Firewall, Routing, and flush DNS.
    echo Please wait, this may take a moment.
    netsh winsock reset
    if %errorlevel% neq 0 goto error_handler
    netsh int ip reset all
    if %errorlevel% neq 0 goto error_handler
    netsh advfirewall reset
    if %errorlevel% neq 0 goto error_handler
    route -f
    ipconfig /release *
    ipconfig /renew *
    ipconfig /flushdns
    call :log_message "Comprehensive Network Settings Reset completed. Please restart your computer."
    pause
    goto optimize_internet

:test_internet_speed
    call :log_message "Testing Internet Speed and Latency (Basic Test)..."
    echo Running ping test to google.com...
    ping -n 3 google.com
    call :log_message "Ping test completed. Check the output above for latency and connectivity status."
    call :log_message "You can use online speed test websites for more accurate results."
    pause
    goto optimize_internet

:revert_net_optimizations
    call :log_message "Reverting All Internet Optimizations..."
    call :log_message "Restoring default network settings."
    call :netsh_set_global autotuninglevel=normal
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global congestionprovider=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global timestamps=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global fastopen=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global heuristics=enabled
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "/d 2" "/f"
    if %errorlevel% neq 0 goto error_handler
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr "Connected"') do (
        call :log_message "Restoring adapter settings for: ""%%j"""
        netsh int ip set interface "%%j" dadtransmits=3 store=persistent
        if %errorlevel% neq 0 goto error_handler
        netsh int ip set interface "%%j" routerdiscovery=enabled store=persistent
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling', '*JumboPacket') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue \$null}"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$true"
        if %errorlevel% neq 0 goto error_handler
        netsh interface ip set dns name="%%j" source=dhcp
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Internet optimizations reverted to default settings. Please restart your computer."
    pause
    goto optimize_internet

:option_6
:windows_update
    cls
    echo Windows Update Management
    echo 1. Enable Windows Update
    echo 2. Disable Windows Update
    echo 3. Check for updates
    set /p update_choice=Enter your choice (1-3):
    call :validate_choice "%update_choice%" 1 3 windows_update
    exit /b

:enable_windows_update
    call :log_message "Enabling Windows Update..."
    call :sc_config_command wuauserv start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start wuauserv
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Update enabled."
    pause
    goto windows_update

:disable_windows_update
    call :log_message "Disabling Windows Update..."
    call :sc_config_command wuauserv start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop wuauserv
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Update disabled."
    pause
    goto windows_update

:check_updates
    call :log_message "Checking for Windows updates..."
    call :powershell_command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Update check initiated. Please check Windows Update in Settings for results."
    pause
    goto windows_update

:option_7
:auto_login
    echo Configuring Auto-login... (Less Secure)
    echo WARNING: Auto-login reduces system security. Use with caution.
    set /p username=Enter username for auto-login:
    set /p password=Enter password for user '%username%':
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Auto-login configured for user '%username%'. System security is reduced."
    pause
    goto menu

:option_8
:clear_cache
    cls
    echo ==================================================
    echo Clearing System Cache - Advanced
    echo ==================================================
    call :log_message "Performing comprehensive system cache cleanup..."
    echo Please wait, this may take a few minutes.

    echo.
    echo --- Clearing Temporary Files ---
    call :log_message "Clearing Temporary Files..."
    del /q /f /s "%TEMP%\*" 2>nul
    rmdir /s /q "%TEMP%\*" 2>nul
    del /q /f /s "C:\Windows\Temp\*" 2>nul
    rmdir /s /q "C:\Windows\Temp\*" 2>nul
    call :log_message "Temporary files cleared."

    echo.
    echo --- Clearing Browser Cache (Internet Explorer & Edge Legacy) ---
    call :log_message "Clearing Browser Cache (Internet Explorer & Edge Legacy)..."
    del /q /f /s "%LocalAppData%\Microsoft\Windows\INetCache\*.*" 2>nul
    del /q /f /s "%LocalAppData%\Microsoft\Internet Explorer\CacheStorage\*.*" 2>nul
    call :log_message "Browser cache (IE & Edge Legacy) cleared."

    echo.
    echo --- Clearing Thumbnail Cache ---
    call :log_message "Clearing Thumbnail Cache..."
    del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
    del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" 2>nul
    taskkill /f /im explorer.exe >nul 2>&1
    start explorer.exe >nul 2>&1
    call :log_message "Thumbnail cache cleared."

    echo.
    echo --- Clearing DNS Cache ---
    call :log_message "Clearing DNS Cache..."
    ipconfig /flushdns
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DNS cache cleared."

    echo.
    echo --- Clearing Software Distribution Folder (Windows Update Cache) ---
    call :log_message "Clearing Software Distribution Folder (Windows Update Cache)..."
    echo Stopping Windows Update service...
    call :sc_start_stop_command stop wuauserv 2>nul
    timeout /t 3 /nobreak >nul
    del /q /f /s "C:\Windows\SoftwareDistribution\Download\*.*" 2>nul
    rmdir /s /q "C:\Windows\SoftwareDistribution\Download" 2>nul
    mkDir "C:\Windows\SoftwareDistribution\Download" 2>nul
    echo Starting Windows Update service...
    call :sc_start_stop_command start wuauserv 2>nul
    call :log_message "Software Distribution folder cleared."

    echo.
    echo --- Clearing System Event Logs ---
    call :log_message "Clearing System Event Logs..."
    for %%L in (Application System Security) DO wevtutil cl "%%L" /qn
    call :log_message "System Event Logs cleared."

    echo.
    echo --- Clearing Prefetch Files (Caution) ---
    echo WARNING: Clearing Prefetch files may slightly slow down application startup temporarily.
    echo Proceeding to clear Prefetch files...
    call :log_message "Clearing Prefetch files..."
    del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul
    call :log_message "Prefetch files cleared."

    call :log_message "System cache cleanup completed."
    pause
    goto menu

:option_9
:optimize_disk
    cls
    echo ==================================================
    echo Disk Optimization - Advanced
    echo ==================================================
    echo 1.  Analyze disk fragmentation
    echo 2.  Optimize/Defragment disk (Full Optimization)
    echo 3.  Optimize/Defragment disk (Quick Optimization - SSD aware)
    echo 4.  Check disk for errors (chkdsk /F /R /X - Requires Restart)
    echo 5.  Check disk health status
    echo 6.  Enable/Verify SSD TRIM
    echo 7.  Clean up system files (Disk Cleanup - Automated)
    echo 8.  Clean up system files (Disk Cleanup - Interactive)
    echo 9.  Return to main menu
    echo ==================================================
    set /p disk_choice=Enter your choice (1-9):
    call :validate_choice "%disk_choice%" 1 9 optimize_disk
    exit /b

:analyze_disk
    call :log_message "Analyzing disk fragmentation..."
    defrag C: /A /V
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk analysis completed. Check output above for fragmentation report."
    pause
    goto optimize_disk

:optimize_defrag_full
    call :log_message "Optimizing/Defragmenting disk (Full Optimization)..."
    echo This may take a long time, especially for large and fragmented disks.
    defrag C: /O /V /H
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk optimization (Full) completed. Check output above for details."
    pause
    goto optimize_disk

:optimize_defrag_quick
    call :log_message "Optimizing/Defragmenting disk (Quick Optimization - SSD aware)..."
    echo This is a quick optimization, suitable for SSDs and regular HDDs.
    defrag C: /L /V
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk optimization (Quick) completed. Check output above for details."
    pause
    goto optimize_disk

:check_disk
    call :log_message "Checking disk for errors (chkdsk /F /R /X)..."
    echo This process will schedule a disk check on the next system restart.
    echo Please save your work and be prepared to restart your computer.
    chkdsk C: /F /R /X
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk check scheduled. Please restart your computer to perform the check."
    pause
    goto optimize_disk

:check_disk_health
    call :log_message "Checking disk health status..."
    wmic diskdrive get status,model,index,size,SerialNumber
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk health check completed. Check status above."
    pause
    goto optimize_disk

:trim_ssd
    call :log_message "Checking and Enabling SSD TRIM..."
    fsutil behavior query DisableDeleteNotify
    if %errorlevel% equ 0 (
        echo SSD TRIM is already enabled.
    ) else (
        echo SSD TRIM is disabled. Enabling TRIM...
        fsutil behavior set disabledeletenotify 0
        if %errorlevel% neq 0 goto error_handler
        call :log_message "SSD TRIM enabled successfully."
    )
    call :log_message "Performing quick TRIM optimization..."
    defrag C: /L /V
    if %errorlevel% neq 0 goto error_handler
    call :log_message "SSD TRIM optimization completed."
    pause
    goto optimize_disk

:cleanup_system_auto
    call :log_message "Cleaning up system files (Disk Cleanup - Automated)..."
    call :log_message "Running Disk Cleanup in automated mode."
    cleanmgr /sagerun:1
    if %errorlevel% neq 0 goto error_handler
    call :log_message "System file cleanup (Automated) completed."
    pause
    goto optimize_disk

:cleanup_system_interactive
    call :log_message "Cleaning up system files (Disk Cleanup - Interactive)..."
    call :log_message "Opening Disk Cleanup utility for interactive selection."
    cleanmgr /d C:
    call :log_message "Disk Cleanup (Interactive) completed after you close the utility."
    pause
    goto optimize_disk

:option_10
:check_repair
    cls
    echo ==============================================================================
    echo                     System Check and Repair - Advanced
    echo ==============================================================================
    echo  **WARNING:** These tools are for advanced system troubleshooting.
    echo  Incorrect usage may impact system stability.
    echo  Please read instructions and warnings carefully before selecting each option.
    echo ==============================================================================
    echo 1.  SFC (System File Checker) - Scan and Repair (Recommended - May require restart)
    echo "   Checks and repairs corrupted system files if errors are found."
    echo 2.  SFC (System File Checker) - Scan only (System Verification)
    echo "   Checks for corrupted system files but will not attempt repairs."
    echo 3.  DISM (Deployment Image Servicing and Management) - Check Health
    echo "   Checks if the Component Store (WinSXS) is in a healthy state."
    echo 4.  DISM (Deployment Image Servicing and Management) - Scan Health
    echo "   Scans the Component Store for potential damage (Takes longer than Check Health)."
    echo 5.  DISM (Deployment Image Servicing and Management) - Restore Health (Requires Internet)
    echo "   Scans and repairs the Component Store using online sources (Internet connection required)."
    echo 6.  DISM (Deployment Image Servicing and Management) - Start Component Cleanup (WinSXS Cleanup)
    echo "   Cleans up outdated data in the WinSxS Folder to reduce Component Store size and free up disk space."
    echo 7.  Check Disk Health Status (SMART Status)
    echo "   Checks the health status of hard drives or SSDs using SMART (Self-Monitoring, Analysis, and Reporting Technology)."
    echo 8.  Check Disk for Errors (chkdsk /F /R /X - Requires Restart)
    echo "   Checks and repairs disk errors (File System Errors, Bad Sectors) - Requires system restart."
    echo 9.  Run Windows Memory Diagnostic (Requires Restart)
    echo "   Checks for RAM memory issues - Requires system restart to perform the test."
    echo 10. Driver Management - Advanced Driver Tools
    echo "    10.1. List all installed drivers - Display all installed drivers"
    echo "    10.2. Search for drivers by keyword - Search drivers using a keyword"
    echo 11. Run Driver Verifier (Advanced - Requires Caution and Restart)
    echo "    **WARNING:** Driver Verifier is an advanced tool, may cause system instability or BSOD if drivers have issues."
    echo "    Use only when necessary and understand the risks."
    echo 12. View SFC Scan Details Log
    echo "    Opens the log file containing details of SFC scan and repair operations."
    echo 13. Return to Main Menu
    echo ==============================================================================
    set /p repair_choice=Enter your choice (1-13):
    call :validate_choice "%repair_choice%" 1 13 check_repair
    exit /b

:driver_management_menu
    cls
    echo ==================================================
    echo                 Driver Management - Advanced
    echo ==================================================
    echo 1. List all installed drivers - Display all installed drivers
    echo 2. Search for drivers by keyword - Search drivers using a keyword
    echo 3. Return to System Check and Repair Menu - Back to System Check and Repair Menu
    echo ==================================================
    set /p driver_mgmt_choice=Enter your choice (1-3):
    call :validate_choice "%driver_mgmt_choice%" 1 3 driver_management_menu
    exit /b

:list_all_drivers_func
    cls
    echo ==================================================
    echo              List All Installed Drivers
    echo ==================================================
    call :log_message "Listing all installed drivers... Please wait..."
    echo ==================================================
    pnputil /enum-drivers
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Driver listing completed. Check the output above for the list of installed drivers."
    pause
    goto driver_management_menu

:search_drivers_func
    cls
    echo ==================================================
    echo              Search Drivers by Keyword
    echo ==================================================
    set /p search_term=Enter keyword to search for drivers (e.g., display, network, vendor name):
    echo ==================================================
    call :log_message "Searching for drivers matching keyword: ""%search_term%""... Please wait..."
    echo ==================================================
    pnputil /enum-drivers | findstr /i "%search_term%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Driver search completed. Check the output above for drivers matching your keyword."
    pause
    goto driver_management_menu

:run_sfc_scan_repair
    echo.
    echo ==============================================================================
    echo           Running System File Checker (SFC) - Scan and Repair
    echo ==============================================================================
    echo This process will scan and repair corrupted system files if found.
    echo Please wait, this process may take some time...
    echo ==============================================================================
    sfc /scannow
    if %errorlevel% neq 0 goto error_handler
    call :log_message "SFC scan completed successfully. Check the output above for details."
    call :log_message "**Recommendation:** If SFC found and repaired errors, a system restart is recommended."
    pause
    goto check_repair

:run_sfc_scanonly
    echo.
    echo ==============================================================================
    echo           Running System File Checker (SFC) - Scan only (Verification)
    echo ==============================================================================
    echo This process will scan for corrupted system files but will not attempt repairs.
    echo Used for system verification only. Please wait...
    echo ==============================================================================
    sfc /verifyonly
    if %errorlevel% neq 0 goto error_handler
    call :log_message "SFC scan (Verification) completed successfully. Check the output above for details."
    pause
    goto check_repair

:run_dism_checkhealth
    echo.
    echo ==============================================================================
    echo     Running DISM - Check Health (Component Store Health Status Check)
    echo ==============================================================================
    echo This process will check if the Component Store (WinSXS) is in a healthy state.
    echo This is a quick preliminary check. Please wait...
    echo ==============================================================================
    DISM /Online /Cleanup-Image /CheckHealth
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DISM CheckHealth completed successfully. Check the output above for details."
    call :log_message "Status ""No component store corruption detected"" indicates a healthy system."
    pause
    goto check_repair

:run_dism_scanhealth
    echo.
    echo ==============================================================================
    echo         Running DISM - Scan Health (Component Store Health Scan)
    echo ==============================================================================
    echo This process will scan the Component Store (WinSXS) for potential damage.
    echo This process may take several minutes. Please wait...
    echo ==============================================================================
    DISM /Online /Cleanup-Image /ScanHealth
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DISM ScanHealth completed successfully. Check the output above for details."
    call :log_message "If corruption is found, it is recommended to run DISM RestoreHealth to repair it."
    pause
    goto check_repair

:run_dism_restorehealth
    echo.
    echo ==============================================================================
    echo       Running DISM - Restore Health (Component Store Health Repair)
    echo ==============================================================================
    echo This process will scan and repair the Component Store (WinSXS) using online sources.
    echo **WARNING:** Internet connection is required, and this process may take a long time. Please wait...
    echo ==============================================================================
    DISM /Online /Cleanup-Image /RestoreHealth
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DISM RestoreHealth completed successfully. Check the output above for details."
    call :log_message "The Component Store has been repaired."
    pause
    goto check_repair

:run_dism_cleanup_component
    echo.
    echo ==============================================================================
    echo     Running DISM - Start Component Cleanup (WinSXS Cleanup)
    echo ==============================================================================
    echo This process will clean up outdated data in the WinSxS Folder to reduce Component Store size.
    echo May help free up disk space. Please wait...
    echo ==============================================================================
    DISM /Online /Cleanup-Image /StartComponentCleanup
    if %errorlevel% neq 0 goto error_handler
    call :log_message "DISM Component Cleanup completed successfully. Check the output above for details."
    call :log_message "Disk space may have been freed up after the cleanup."
    pause
    goto check_repair

:check_disk_health_smart
    echo.
    echo ==============================================================================
    echo                 Checking Disk Health Status (SMART Status)
    echo ==============================================================================
    echo This process will check the health status of hard drives or SSDs using SMART.
    echo Please wait...
    echo ==============================================================================
    wmic diskdrive get status,model,index,size,SerialNumber,PredFail, Caption
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk health check completed. Check the status above."
    call :log_message "PredFail = 'TRUE' indicates potential disk failure. Status = 'OK' is normal."
    pause
    goto check_repair

:check_disk_errors_chkdsk
    echo.
    echo ==============================================================================
    echo         Checking Disk for Errors (chkdsk /F /R /X - Requires Restart)
    echo ==============================================================================
    echo This process will schedule a disk check for errors on the next system restart.
    echo **WARNING:** Please save your work and be prepared to restart your computer.
    echo ==============================================================================
    chkdsk C: /F /R /X
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk check scheduled successfully. Please restart your computer to perform the check."
    pause
    goto check_repair

:run_memory_diagnostic
    echo.
    echo ==============================================================================
    echo             Running Windows Memory Diagnostic (Requires Restart)
    echo ==============================================================================
    echo This process will launch the Windows Memory Diagnostic tool and require a system restart.
    echo **WARNING:** Please save your work before proceeding.
    echo ==============================================================================
    start mdsched.exe
    call :log_message "Windows Memory Diagnostic tool launched. Please restart your computer to begin the memory test."
    pause
    goto check_repair

:run_driver_verifier
    echo.
    echo ==============================================================================
    echo         !!! WARNING - Driver Verifier (Advanced - Requires Caution) !!!
    echo ==============================================================================
    echo **WARNING:** Driver Verifier is an advanced tool for driver debugging.
    echo Incorrect usage may cause system instability or Blue Screen of Death (BSOD).
    echo Proceed only if you understand the risks and have system troubleshooting knowledge.
    echo **Recommendation:** If unsure, please choose "N" to cancel.
    echo ==============================================================================
    set /p confirm_verifier=Are you sure you want to run Driver Verifier? (Y/N - Highly Recommended to choose N if unsure):
    if /i "%confirm_verifier%"=="Y" (
        call :log_message "Launching Driver Verifier Manager..."
        verifier
        call :log_message "Driver Verifier Manager opened. Please configure and run Verifier from the GUI."
        call :log_message "**WARNING:** A system restart will be required after configuring Driver Verifier."
    ) else (
        echo Driver Verifier cancelled.
    )
    pause
    goto check_repair

:view_sfc_log
    echo.
    echo ==============================================================================
    echo             Viewing SFC Scan Details Log (sfcdetails.txt)
    echo ==============================================================================
    echo Opening SFC details log file (%SFC_LOG_FILE%) from your Desktop...
    echo ==============================================================================
    start "" "%SFC_LOG_FILE%"
    if not exist "%SFC_LOG_FILE%" (
        echo SFC log file not found at %SFC_LOG_FILE%. Generating a new log...
        Findstr /c:"[SR]" "%windir%\Logs\CBS\CBS.log" >"%SFC_LOG_FILE%"
        call :log_message "SFC log generated and saved to %SFC_LOG_FILE% on your desktop."
    ) else (
        call :log_message "SFC log file opened from %SFC_LOG_FILE%."
    )
    pause
    goto check_repair

:option_11
:: --- Option 11 - Windows Activation (NO CHANGES MADE AS PER REQUEST) ---
:windows_activate
    cls
    echo ==================================================================
    echo                       Windows Activation Script (Improved)
    echo ==================================================================
    echo 1. Check activation status
    echo 2. Activate using KMS (Volume License - **USE WITH CAUTION**)
    echo 3. Activate Windows (Digital License or KMS if configured)
    echo 4. Input a product key manually
    echo 5. Remove product key
    echo 6. Return to main menu
    echo ==================================================================
    set /p activate_choice=Enter your choice (1-6):
    call :validate_choice "%activate_choice%" 1 6 windows_activate
    exit /b

:check_activation
    cls
    echo ==================================================================
    echo                    Checking Windows Activation Status
    echo ==================================================================
    slmgr /xpr
    pause
    goto windows_activate

:kms_activate_warning
    cls
    echo ====================================================================================
    echo                       !!!  WARNING - KMS ACTIVATION  !!!
    echo ====================================================================================
    echo You have chosen to activate Windows using KMS via an external script.
    echo **THIS METHOD INVOLVES DOWNLOADING AND EXECUTING A SCRIPT FROM:**
    echo.
    echo                  https://get.activated.win
    echo.
    echo ====================================================================================
    echo **SECURITY RISK:**
    echo Executing scripts from the internet can be dangerous.
    echo We **STRONGLY RECOMMEND** reviewing the script's content before execution
    echo to understand what it does. Proceed at your own risk.
    echo ====================================================================================
    echo Do you understand the risks and want to proceed with KMS activation?
    echo ====================================================================================
    echo 1. Proceed with KMS Activation
    echo 2. Return to Activation Menu
    echo ====================================================================================
    set /p kms_choice=Enter your choice (1-2):
    call :validate_choice "%kms_choice%" 1 2 kms_activate_warning
    exit /b

:kms_activate_real
    cls
    echo ==================================================================
    echo                    Attempting KMS Activation (External Script)
    echo ==================================================================
    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Attempting KMS Activation using script from https://get.activated.win ...
        powershell -command "irm https://get.activated.win | iex"
        echo.
        echo KMS Activation Attempted. Please check your activation status.
        slmgr /xpr
    ) else (
        echo Requesting Administrator Privileges for KMS Activation...
        echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
        echo UAC.ShellExecute "cmd.exe", "/c %~s0", "", "runas", 1 >> "%temp%\getadmin.vbs"
        "%temp%\getadmin.vbs"
        del "%temp%\getadmin.vbs"
    )
    pause
    goto windows_activate

:activate_windows
    cls
    echo ==================================================================
    echo          Attempting Windows Activation (Digital License or KMS)
    echo ==================================================================
    echo Attempting Windows activation using digital license or configured KMS...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo Activation failed. Please check your network connection and KMS configuration (if applicable).
    ) else (
        echo Windows activation attempted successfully!
        echo.
        echo Current Activation Status:
        slmgr /xpr
    )
    pause
    goto windows_activate

:manual_key
    cls
    echo ==================================================================
    echo                 Manual Product Key Activation
    echo ==================================================================
    set /p product_key=Enter your 25-character product key (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
    echo.
    echo Installing product key...
    slmgr /ipk %product_key%
    if %errorlevel% neq 0 (
        echo Failed to install product key. The key may be invalid or not applicable to your Windows version.
    ) else (
        echo Product key installed successfully.
        echo.
        echo Attempting activation...
        slmgr /ato
        if %errorlevel% neq 0 (
            echo Activation failed. Please check your product key and try again.
        ) else (
            echo Windows activation attempted successfully!
            echo.
            echo Current Activation Status:
            slmgr /xpr
        )
    )
    pause
    goto windows_activate

:remove_key
    cls
    echo ==================================================================
    echo                     Remove Product Key
    echo ==================================================================
    echo Removing current product key...
    slmgr /upk
    if %errorlevel% neq 0 (
        echo Failed to remove product key. You may not have permission or there's no key to remove.
    ) else (
        echo Product key removed successfully. Windows is now unactivated.
    )
    pause
    goto windows_activate

:option_12
:manage_power
    cls
    echo ======================================================
    echo Power Settings Management - Advanced
    echo ======================================================
    echo 1.  List all power plans
    echo 2.  Set active power plan
    echo 3.  Create custom power plan
    echo 4.  Rename power plan
    echo 5.  Delete power plan
    echo 6.  Export power plan to file
    echo 7.  Import power plan from file
    echo ------------------------------------------------------
    echo 8.  Adjust sleep timeout (Idle sleep)
    echo 9.  Adjust display timeout (Idle display off)
    echo 10. Adjust hibernate timeout (Idle hibernate)
    echo 11. Enable/Disable hibernation
    echo 12. Configure lid close action
    echo 13. Configure power button action
    echo 14. Configure sleep button action
    echo ------------------------------------------------------
    echo 15. Adjust processor power management (Min/Max processor state)
    echo 16. Adjust USB selective suspend setting
    echo 17. Adjust hard disk power down timeout
    echo 18. Adjust wireless adapter power saving mode
    echo ------------------------------------------------------
    echo 19. Battery Settings (For Laptops Only) - Configure Low Battery Action
    echo 20. Battery Settings (For Laptops Only) - Configure Critical Battery Action
    echo ------------------------------------------------------
    echo 21. Open Advanced Power Settings GUI (powercfg.cpl)
    echo 22. Restore Default Power Settings (Reset to Balanced Plan)
    echo 23. Return to main menu
    echo ======================================================
    set /p power_choice=Enter your choice (1-23):
    call :validate_choice "%power_choice%" 1 23 manage_power
    exit /b

:list_power_plans
    call :log_message "Listing all power plans..."
    powercfg /list
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_power

:set_power_plan_active
    echo Available power plans:
    powercfg /list
    set /p plan_guid=Enter the GUID of the power plan you want to set active:
    powercfg /setactive "%plan_guid%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power plan set active successfully."
    pause
    goto manage_power

:create_power_plan_custom
    set /p plan_name=Enter a name for the new power plan:
    powercfg /duplicatescheme scheme_balanced
    if %errorlevel% neq 0 goto error_handler
    for /f "tokens=4" %%i in ('powercfg /list ^| findstr /i "%plan_name%"') do set new_plan_guid=%%i
    if defined new_plan_guid (
        echo Error: Power plan with name "%plan_name%" already exists. Please choose a different name.
        set new_plan_guid=
        pause
        goto create_power_plan_custom
    )
    powercfg /changename "%new_plan_guid%" -name "%plan_name%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power plan created successfully."
    pause
    goto manage_power

:rename_power_plan
    echo Available power plans:
    powercfg /list
    set /p old_plan_guid=Enter the GUID of the power plan you want to rename:
    set /p new_plan_name=Enter the new name for the power plan:
    powercfg /changename "%old_plan_guid%" -name "%new_plan_name%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power plan renamed successfully."
    pause
    goto manage_power

:delete_power_plan
    echo Available power plans:
    powercfg /list
    set /p del_guid=Enter the GUID of the power plan you want to delete:
    echo WARNING: Deleting a power plan is irreversible. Are you sure? (Y/N)
    set /p confirm_delete=Enter your choice (Y/N):
    if /i "%confirm_delete%"=="Y" (
        powercfg /delete "%del_guid%"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Power plan deleted successfully."
    ) else (
        echo Power plan deletion cancelled.
    )
    pause
    goto manage_power

:export_power_plan
    echo Available power plans:
    powercfg /list
    set /p export_guid=Enter the GUID of the power plan you want to export:
    set /p export_file=Enter the file path to export to (e.g., C:\PowerPlans\MyPlan.pow):
    powercfg /export "%export_file%" "%export_guid%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power plan exported successfully to ""%export_file%""."
    pause
    goto manage_power

:import_power_plan
    set /p import_file=Enter the file path of the power plan to import (e.g., C:\PowerPlans\MyPlan.pow):
    powercfg /import "%import_file%"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power plan imported successfully."
    pause
    goto manage_power

:adjust_sleep_timeout
    set /p sleep_time=Enter the number of minutes before the system goes to sleep (0 to never sleep):
    powercfg /change standby-timeout-ac %sleep_time%
    if %errorlevel% neq 0 goto error_handler
    powercfg /change standby-timeout-dc %sleep_time%
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Sleep timeout adjusted."
    pause
    goto manage_power

:adjust_display_timeout
    set /p display_time=Enter the number of minutes before turning off the display (0 to never turn off):
    powercfg /change monitor-timeout-ac %display_time%
    if %errorlevel% neq 0 goto error_handler
    powercfg /change monitor-timeout-dc %display_time%
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Display timeout adjusted."
    pause
    goto manage_power

:adjust_hibernate_timeout
    set /p hibernate_time=Enter the number of minutes before the system hibernates (0 to never hibernate):
    powercfg /change hibernate-timeout-ac %hibernate_time%
    if %errorlevel% neq 0 goto error_handler
    powercfg /change hibernate-timeout-dc %hibernate_time%
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Hibernate timeout adjusted."
    pause
    goto manage_power

:configure_hibernate_enable
    echo 1. Enable hibernation
    echo 2. Disable hibernation
    set /p hib_choice=Enter your choice (1-2):
    call :validate_choice "%hib_choice%" 1 2 configure_hibernate_enable
    exit /b
    if "%hib_choice%"=="1" (
        powercfg /hibernate on
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Hibernation enabled."
    ) else if "%hib_choice%"=="2" (
        powercfg /hibernate off
        if %errorlevel% neq 0 goto error_handler
        call :log_message "Hibernation disabled."
    )
    pause
    goto manage_power

:configure_lid_action
    echo 1. Do nothing
    echo 2. Sleep
    echo 3. Hibernate
    echo 4. Shut down
    set /p lid_choice=Enter your choice for lid close action (1-4):
    call :validate_choice "%lid_choice%" 1 4 configure_lid_action
    exit /b
    if "%lid_choice%"=="1" set action=0
    if "%lid_choice%"=="2" set action=1
    if "%lid_choice%"=="3" set action=2
    if "%lid_choice%"=="4" set action=3
    powercfg /setacvalueindex scheme_current sub_buttons lidaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_buttons lidaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Lid close action configured."
    pause
    goto manage_power

:configure_power_button_action
    echo 1. Do nothing
    echo 2. Sleep
    echo 3. Hibernate
    echo 4. Shut down
    echo 5. Turn off the display
    set /p button_choice=Enter your choice for power button action (1-5):
    call :validate_choice "%button_choice%" 1 5 configure_power_button_action
    exit /b
    if "%button_choice%"=="1" set action=0
    if "%button_choice%"=="2" set action=1
    if "%button_choice%"=="3" set action=2
    if "%button_choice%"=="4" set action=3
    if "%button_choice%"=="5" set action=4
    powercfg /setacvalueindex scheme_current sub_buttons pbuttonaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_buttons pbuttonaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Power button action configured."
    pause
    goto manage_power

:configure_sleep_button_action
    echo 1. Do nothing
    echo 2. Sleep
    echo 3. Hibernate
    echo 4. Shut down
    echo 5. Turn off the display
    set /p sleep_button_choice=Enter your choice for sleep button action (1-5):
    call :validate_choice "%sleep_button_choice%" 1 5 configure_sleep_button_action
    exit /b
    if "%sleep_button_choice%"=="1" set action=0
    if "%sleep_button_choice%"=="2" set action=1
    if "%sleep_button_choice%"=="3" set action=2
    if "%sleep_button_choice%"=="4" set action=3
    if "%sleep_button_choice%"=="5" set action=4
    powercfg /setacvalueindex scheme_current sub_buttons sbuttonaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_buttons sbuttonaction %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Sleep button action configured."
    pause
    goto manage_power

:adjust_processor_power_mgmt
    call :log_message "Adjusting Processor Power Management (Min/Max Processor State)..."
    set /p min_processor_state=Enter minimum processor state in percentage (e.g., 5 for 5%):
    set /p max_processor_state=Enter maximum processor state in percentage (e.g., 100 for 100%):
    powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN %min_processor_state%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN %min_processor_state%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX %max_processor_state%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX %max_processor_state%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Processor power management (Min/Max Processor State) adjusted."
    pause
    goto manage_power

:adjust_usb_suspend
    echo 1. Enable USB selective suspend
    echo 2. Disable USB selective suspend
    set /p usb_suspend_choice=Enter your choice (1-2):
    call :validate_choice "%usb_suspend_choice%" 1 2 adjust_usb_suspend
    exit /b
    if "%usb_suspend_choice%"=="1" (
        powercfg /setacvalueindex scheme_current sub_usb usbidlecycles 8
        if %errorlevel% neq 0 goto error_handler
        powercfg /setdcvalueindex scheme_current sub_usb usbidlecycles 8
        if %errorlevel% neq 0 goto error_handler
        powercfg /setactive scheme_current
        if %errorlevel% neq 0 goto error_handler
        call :log_message "USB selective suspend enabled."
    ) else if "%usb_suspend_choice%"=="2" (
        powercfg /setacvalueindex scheme_current sub_usb usbidlecycles 0
        if %errorlevel% neq 0 goto error_handler
        powercfg /setdcvalueindex scheme_current sub_usb usbidlecycles 0
        if %errorlevel% neq 0 goto error_handler
        powercfg /setactive scheme_current
        if %errorlevel% neq 0 goto error_handler
        call :log_message "USB selective suspend disabled."
    )
    pause
    goto manage_power

:adjust_harddisk_timeout
    set /p disk_timeout=Enter the number of minutes before turning off the hard disk (0 to never turn off):
    powercfg /change disk-timeout-ac %disk_timeout%
    if %errorlevel% neq 0 goto error_handler
    powercfg /change disk-timeout-dc %disk_timeout%
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Hard disk power down timeout adjusted."
    pause
    goto manage_power

:adjust_wireless_powersave
    echo 1. Maximum Performance
    echo 2. Medium Power Saving
    echo 3. Maximum Power Saving
    set /p wireless_powersave_choice=Enter your choice for Wireless Adapter Power Saving Mode (1-3):
    call :validate_choice "%wireless_powersave_choice%" 1 3 adjust_wireless_powersave
    exit /b
    if "%wireless_powersave_choice%"=="1" set power_setting=0
    if "%wireless_powersave_choice%"=="2" set power_setting=1
    if "%wireless_powersave_choice%"=="3" set power_setting=2
    powercfg /setacvalueindex scheme_current sub_wireless wificonnectionmode %power_setting%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setdcvalueindex scheme_current sub_wireless wificonnectionmode %power_setting%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Wireless Adapter Power Saving Mode adjusted."
    pause
    goto manage_power

:configure_low_battery_action
    echo 1. Do nothing
    echo 2. Sleep
    echo 3. Hibernate
    echo 4. Shut down
    set /p low_battery_choice=Enter your choice for Low Battery Action (1-4):
    call :validate_choice "%low_battery_choice%" 1 4 configure_low_battery_action
    exit /b
    if "%low_battery_choice%"=="1" set action=0
    if "%low_battery_choice%"=="2" set action=1
    if "%low_battery_choice%"=="3" set action=2
    if "%low_battery_choice%"=="4" set action=3
    powercfg /setdcvalueindex scheme_current sub_battery batlowact %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Low Battery Action configured. (Battery settings are typically for DC power only)"
    pause
    goto manage_power

:configure_critical_battery_action
    echo 1. Do nothing
    echo 2. Sleep
    echo 3. Hibernate
    echo 4. Shut down
    set /p critical_battery_choice=Enter your choice for Critical Battery Action (1-4):
    call :validate_choice "%critical_battery_choice%" 1 4 configure_critical_battery_action
    exit /b
    if "%critical_battery_choice%"=="1" set action=0
    if "%critical_battery_choice%"=="2" set action=1
    if "%critical_battery_choice%"=="3" set action=2
    if "%critical_battery_choice%"=="4" set action=3
    powercfg /setdcvalueindex scheme_current sub_battery batcritact %action%
    if %errorlevel% neq 0 goto error_handler
    powercfg /setactive scheme_current
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Critical Battery Action configured. (Battery settings are typically for DC power only)"
    pause
    goto manage_power

:open_advanced_power_gui
    call :log_message "Opening Advanced Power Settings GUI (powercfg.cpl)..."
    start powercfg.cpl
    call :log_message "Advanced Power Settings GUI opened. You can configure detailed power settings there."
    pause
    goto manage_power

:restore_default_power_settings
    call :log_message "Restoring Default Power Settings (Balanced Power Plan)..."
    call :log_message "Setting active power plan to Balanced..."
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Resetting all power plan settings to default for Balanced plan..."
    powercfg -restoredefaultschemes
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Default Power Settings restored to Balanced Power Plan."
    pause
    goto manage_power

:option_13
:enable_dark_mode
    call :log_message "Enabling Dark Mode..."
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Dark Mode enabled."
    pause
    goto menu

:option_14
:manage_partitions
    echo Partition Management - Advanced (DISKPART)
    echo WARNING: Incorrect partition management can lead to data loss.
    echo 1. List Partitions
    echo 2. Create Partition
    echo 3. Delete Partition
    echo 4. Format Partition
    set /p part_choice=Enter your choice (1-4):
    call :validate_choice "%part_choice%" 1 4 manage_partitions
    exit /b

:list_partitions
    call :log_message "Listing Partitions..."
    echo list disk > list_disk.txt
    echo list volume >> list_disk.txt
    diskpart /s list_disk.txt
    if %errorlevel% neq 0 goto error_handler
    del list_disk.txt
    pause
    goto manage_partitions

:create_partition
    echo Creating Partition...
    set /p disk_num=Enter disk number:
    set /p part_size=Enter partition size in MB:
    (
    echo select disk %disk_num%
    echo create partition primary size=%part_size%
    ) > create_part.txt
    diskpart /s create_part.txt
    if %errorlevel% neq 0 goto error_handler
    del create_part.txt
    call :log_message "Partition created."
    pause
    goto manage_partitions

:delete_partition
    echo Deleting Partition... WARNING: Data loss possible.
    set /p disk_num=Enter disk number:
    set /p part_num=Enter partition number:
    (
    echo select disk %disk_num%
    echo select partition %part_num%
    echo delete partition override
    ) > delete_part.txt
    diskpart /s delete_part.txt
    if %errorlevel% neq 0 goto error_handler
    del delete_part.txt
    call :log_message "Partition deleted."
    pause
    goto manage_partitions

:format_partition
    echo Formatting Partition... WARNING: Data loss possible.
    set /p disk_num=Enter disk number:
    set /p part_num=Enter partition number:
    set /p fs=Enter file system (NTFS/FAT32):
    (
    echo select disk %disk_num%
    echo select partition %part_num%
    echo format fs=%fs% quick
    ) > format_part.txt
    diskpart /s format_part.txt
    if %errorlevel% neq 0 goto error_handler
    del format_part.txt
    call :log_message "Partition formatted."
    pause
    goto manage_partitions

:option_15
:clean_disk
    call :log_message "Cleaning up disk space..."
    cleanmgr /sagerun:1
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Disk cleanup completed."
    pause
    goto menu

:option_16
:manage_startup
    call :log_message "Managing startup programs..."
    start msconfig
    call :log_message "Please use the System Configuration utility to manage startup programs."
    pause
    goto menu

:option_17
:backup_restore
    cls
    echo ===================================================================
    echo             Backup and Restore Settings - Advanced
    echo ===================================================================
    echo 1.  Create System Restore Point (Improved)
    echo "   Create a manual system restore point for system recovery."
    echo 2.  Restore System from Restore Point
    echo "   Restore your system to a previously created restore point."
    echo 3.  Create System Image Backup (Advanced - wbadmin)
    echo "   Create a full system image backup using wbadmin.exe (requires external storage)."
    echo 4.  Restore System from System Image (Advanced - Recovery Environment)
    echo "   Guide to restoring your system from a system image backup (requires boot to Recovery Environment)."
    echo 5.  Backup Specific Folders (Basic - robocopy)
    echo "   Basic backup of specific folders to a destination folder (using robocopy - no versioning)."
    echo 6.  Guide to File History (Windows Built-in File Backup)
    echo "   Open Windows File History settings for advanced file backup and versioning."
    echo 7.  Return to Main Menu
    echo ===================================================================
    set /p backup_choice=Enter your choice (1-7):
    call :validate_choice "%backup_choice%" 1 7 backup_restore
    exit /b

:create_restore_improved
    cls
    echo ===================================================================
    echo          Create System Restore Point - Improved
    echo ===================================================================
    call :log_message "Creating a system restore point... Please wait..."
    echo ===================================================================
    set restore_description="Manual Restore Point - Created by Optimization Script %SCRIPT_VERSION%"
    wmic.exe /Namespace:"\\root\default" Path SystemRestore Call CreateRestorePoint "%restore_description%", 100, 7
    if %errorlevel% neq 0 goto error_handler
    call :log_message "System restore point created successfully."
    call :log_message "Description: ""%restore_description%"""
    call :log_message "You can use this restore point to revert system changes if needed."
    pause
    goto backup_restore

:restore_point
    echo ===================================================================
    echo          Restore System from Restore Point
    echo ===================================================================
    call :log_message "Launching System Restore..."
    rstrui.exe
    call :log_message "Please follow the on-screen instructions in System Restore to choose a restore point and restore your system."
    call :log_message "**WARNING:** System restore will revert system files and settings to the chosen restore point."
    call :log_message "Ensure you have backed up any important data created after the restore point."
    pause
    goto backup_restore

:create_system_image_backup
    cls
    echo ===================================================================
    echo          Create System Image Backup (Advanced - wbadmin)
    echo ===================================================================
    echo **WARNING:** System image backup creates a full copy of your system drive.
    echo This requires significant disk space on an EXTERNAL STORAGE DEVICE (USB drive, external HDD, network share).
    echo Ensure you have connected and selected the correct external storage device for backup.
    echo ===================================================================
    echo Please specify the DRIVE LETTER of the EXTERNAL STORAGE DEVICE where you want to save the system image backup (e.g., E: or F:):
    set /p backup_target_drive=Enter drive letter:

    if not defined backup_target_drive (
        echo Error: No drive letter entered. System image backup cancelled.
        pause
        goto backup_restore
    )

    echo ===================================================================
    echo Starting System Image Backup to drive %backup_target_drive%... Please wait, this may take a long time.
    echo ===================================================================
    wbadmin start backup -backupTarget:"%backup_target_drive%": -include:C: -allCritical -quiet
    if %errorlevel% neq 0 goto error_handler
    call :log_message "System image backup created successfully on drive %backup_target_drive%."
    call :log_message "**IMPORTANT:** Keep the external storage device safe. You will need it to restore your system image."
    pause
    goto backup_restore

:restore_system_image_guide
    cls
    echo ===================================================================
    echo      Restore System from System Image (Advanced - Recovery Environment)
    echo ===================================================================
    echo **WARNING:** Restoring from a system image will ERASE EVERYTHING on your system drive
    echo and replace it with the contents of the system image.
    echo Ensure you have backed up any important data on your current system drive that is NOT in the system image.
    echo ===================================================================
    echo **Instructions to Restore System Image:**
    echo 1. **Connect the external storage device** containing your system image backup to your computer.
    echo 2. **Restart your computer.**
    echo 3. **Boot into Windows Recovery Environment (WinRE).**
    echo "   - You can usually do this by repeatedly pressing a specific key during startup (e.g., F11, F12, Del, Esc)."
    echo "     The key varies depending on your computer manufacturer. Check your computer's manual or website."
    echo "   - Alternatively, you can boot from Windows installation media (USB or DVD) and choose ""Repair your computer""."
    echo 4. In WinRE, navigate to **Troubleshoot > Advanced options > System Image Recovery.**
    echo 5. **Follow the on-screen instructions** to select your system image backup from the external storage device and restore your system.
    echo ===================================================================
    echo **IMPORTANT:** System image restore is a destructive operation. Proceed with caution and ensure you understand the risks.
    echo This script only provides guidance. The actual restore process is done within Windows Recovery Environment.
    pause
    goto backup_restore

:backup_specific_folders
    cls
    echo ===================================================================
    echo          Backup Specific Folders (Basic - robocopy)
    echo ===================================================================
    echo **WARNING:** This is a BASIC folder backup using robocopy. It does NOT provide versioning or advanced backup features.
    echo It is intended for simple backups of important folders. For more robust backup solutions, consider using File History or System Image Backup.
    echo ===================================================================
    set /p source_folder=Enter the full path of the SOURCE FOLDER to backup:
    if not exist "%source_folder%" (
        echo Error: Source folder does not exist. Please enter a valid folder path.
        pause
        goto backup_restore
    )
    set /p destination_folder=Enter the full path of the DESTINATION FOLDER for backup:
    if not exist "%destination_folder%" (
        echo Destination folder does not exist. Creating destination folder: "%destination_folder%"
        mkdir "%destination_folder%" 2>nul
        if not exist "%destination_folder%" (
            echo Error: Failed to create destination folder. Please check permissions and path.
            pause
            goto backup_restore
        )
    )

    echo ===================================================================
    echo Starting basic folder backup from "%source_folder%" to "%destination_folder%"... Please wait.
    echo ===================================================================
    robocopy "%source_folder%" "%destination_folder%" /MIR /COPYALL /R:2 /W:3 /LOG+:"backup_log_robocopy.txt"
    if %errorlevel% geq 8 goto error_handler
    call :log_message "Basic folder backup completed successfully."
    call :log_message "Source folder: ""%source_folder%"""
    call :log_message "Destination folder: ""%destination_folder%"""
    call :log_message "Log file (robocopy details): ""backup_log_robocopy.txt"" (in script directory)"
    if %errorlevel% equ 0 pause
    goto backup_restore

:guide_file_history
    cls
    echo ===================================================================
    echo      Guide to File History (Windows Built-in File Backup)
    echo ===================================================================
    echo Windows File History is a built-in feature for automatic file backup and versioning.
    echo It is recommended for backing up personal files (documents, pictures, music, videos, etc.).
    echo ===================================================================
    echo **Instructions to Configure File History:**
    echo 1. **Connect an external drive** (USB drive or external HDD) to your computer.
    echo 2. **Open Control Panel.**
    echo 3. Go to **System and Security > File History.**
    echo "   - Alternatively, search for ""File History"" in the Windows Start Menu."
    echo 4. In File History settings:
    echo "   - **Turn on File History** if it's off."
    echo "   - **Select your external drive** as the backup drive."
    echo "   - **Configure folders to backup** (by default, it backs up Libraries, Desktop, Contacts, and Favorites)."
    echo "   - **Adjust advanced settings** (backup frequency, versions to keep, exclusions, etc.) as needed."
    echo ===================================================================
    echo File History will automatically backup your files to the selected drive at regular intervals.
    echo You can restore previous versions of files from File History settings.
    echo This script only provides guidance. You need to configure File History settings manually.
    pause
    goto backup_restore

:option_18
:system_info
    cls
    echo ===================================================================
    echo         Detailed Hardware and System Information - Advanced View
    echo ===================================================================
    call :log_message "Displaying comprehensive hardware and system information... Please wait..."
    echo ===================================================================

    echo.
    echo ========================= Operating System =========================
    systeminfo | findstr /c:"OS Name" /c:"OS Version" /c:"Build Type" /c:"Registered Owner" /c:"Installation Date" /c:"System Boot Time"
    echo.

    echo ============================== CPU ==============================
    echo Processor Information:
    wmic cpu get Name,DeviceID,Manufacturer,CurrentClockSpeed,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors,L2CacheSize,L3CacheSize /format:list
    echo.

    echo ============================ Motherboard ============================
    echo BaseBoard Information:
    wmic baseboard get Manufacturer,Product,Version,SerialNumber /format:list
    echo.

    echo =============================== BIOS ===============================
    echo BIOS Information:
    wmic bios get Manufacturer,Name,SerialNumber,SMBIOSBIOSVersion,Version /format:list
    echo.

    echo =============================== Memory (RAM) ===============================
    echo Memory (RAM) Information:
    call :powershell_command "Get-WmiObject Win32_PhysicalMemory | Format-List BankLabel,Capacity,Caption,ConfiguredClockSpeed,DeviceLocator,Manufacturer,PartNumber,SerialNumber,SMBIOSMemoryType,Speed"
    echo.

    echo ========================== Graphics Card (GPU) ==========================
    echo Graphics Card (GPU) Information:
    call :powershell_command "Get-WmiObject Win32_VideoController | Format-List AdapterCompatibility,AdapterDACType,AdapterRAM,Caption,Description,DriverDate,DriverVersion,InfFilename,InfSection,Manufacturer,Name,PNPDeviceID,VideoProcessor"
    echo.

    echo ========================== Storage Devices (Disks) =========================
    echo Storage Devices (Disks) Information:
    call :powershell_command "Get-WmiObject Win32_DiskDrive | Format-List Caption,DeviceID,Manufacturer,Model,Name,PNPDeviceID,SerialNumber,Size,InterfaceType,MediaType,Partitions"
    echo.

    echo ========================== Audio Devices =========================
    echo Audio Devices Information:
    call :powershell_command "Get-WmiObject Win32_SoundDevice | Format-List Caption,DeviceID,Manufacturer,ProductName,Status"
    echo.

    echo ========================== Network Adapters =========================
    echo Network Adapters Information:
    call :powershell_command "Get-NetAdapter | Where-Object {$_.NetEnabled -eq \$true} | Format-List Name,InterfaceDescription,InterfaceName,MacAddress,Status,LinkSpeed,MediaType,DriverInformation"
    echo.

    echo ========================== Monitor/Display =========================
    echo Monitor/Display Information:
    call :powershell_command "Get-WmiObject WmiMonitorID -Namespace root\wmi | ForEach-Object { \$ManufacturerNameBytes = \$_.ManufacturerName -ne \$null ? \$_.ManufacturerName : @(0) ; \$ProductNameBytes = \$_.ProductName -ne \$null ? \$_.ProductName : @(0) ; \$ManufacturerName = ([System.Text.Encoding]::ASCII).GetString(\$ManufacturerNameBytes).Trim(\"`0`"); \$ProductName = ([System.Text.Encoding]::ASCII).GetString(\$ProductNameBytes).Trim(\"`0`"); Write-Host 'Manufacturer:' \$ManufacturerName; Write-Host 'Product Name:' \$ProductName ; Write-Host 'Serial Number (Raw):' \$_.SerialNumberID ;  Write-Host 'InstanceName:' \$_.InstanceName ; Write-Host '-------------------' }"
    echo.

    echo ========================== Input Devices (Mouse/Keyboard) =========================
    echo Input Devices (Mouse/Keyboard) Information:
    echo --- Mouse Devices ---
    call :powershell_command "Get-WmiObject Win32_PointingDevice | Format-List Caption,DeviceID,Manufacturer,Name,PNPDeviceID"
    echo.
    echo --- Keyboard Devices ---
    call :powershell_command "Get-WmiObject Win32_Keyboard | Format-List Caption,DeviceID,Layout,Manufacturer,Name,PNPDeviceID"
    echo.

    echo ===================================================================
    echo     Detailed Hardware and System Information Display Completed - Check Output Above
    echo ===================================================================
    pause
    goto menu

:option_19
:optimize_privacy
    cls
    echo ======================================================
    echo              Privacy Optimization - Advanced
    echo ======================================================
    echo Please select a category to optimize privacy settings:
    echo ======================================================

    echo 1.  Telemetry and Data Collection
    echo 2.  Advertising and Personalization
    echo 3.  User Experience and Feedback
    echo 4.  Connected Experiences
    echo ------------------------------------------------------
    echo 5.  Revert all Privacy Optimizations (Undo Changes)
    echo 6.  Return to main menu
    echo ======================================================
    set /p privacy_choice=Enter your choice (1-6):
    call :validate_choice "%privacy_choice%" 1 6 optimize_privacy
    exit /b

:privacy_option_1
:privacy_telemetry
    cls
    echo ======================================================
    echo          Telemetry and Data Collection Settings
    echo ======================================================
    echo 1. Disable Telemetry (Basic Level - Recommended)
    echo 2. Disable Customer Experience Improvement Program (CEIP)
    echo 3. Disable Error Reporting
    echo 4. Disable Compatibility Telemetry
    echo ------------------------------------------------------
    echo 5. Revert Telemetry & Data Collection Optimizations
    echo 6. Return to Privacy Optimization Menu
    echo ======================================================
    set /p telemetry_choice=Enter your choice (1-6):
    call :validate_choice "%telemetry_choice%" 1 6 privacy_telemetry
    exit /b

:disable_telemetry_adv
    call :log_message "Disabling Telemetry and Data Collection (Basic Level)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Telemetry and Data Collection (Basic Level) disabled."
    pause
    goto privacy_telemetry

:disable_ceip_adv
    call :log_message "Disabling Customer Experience Improvement Program (CEIP)..."
    call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Customer Experience Improvement Program (CEIP) disabled."
    pause
    goto privacy_telemetry

:disable_error_reporting_adv
    call :log_message "Disabling Error Reporting..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Error Reporting disabled."
    pause
    goto privacy_telemetry

:disable_compatibility_telemetry_adv
    call :log_message "Disabling Compatibility Telemetry..."
    call :sc_config_command "DiagTrack" start= disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command stop "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Compatibility Telemetry (Diagnostic Tracking Service) disabled."
    pause
    goto privacy_telemetry

:revert_telemetry_optimizations
    call :log_message "Reverting Telemetry & Data Collection Optimizations..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" "CEIPEnable" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "DontConsentPrompt" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "DiagTrack" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "DiagTrack"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Telemetry & Data Collection optimizations reverted."
    pause
    goto privacy_telemetry

:privacy_option_2
:privacy_advertising
    cls
    echo ======================================================
    echo          Advertising and Personalization Settings
    echo ======================================================
    echo 1. Disable Advertising ID
    echo 2. Disable Location Services (System-wide)
    echo 3. Disable Camera Access (For all apps)
    echo 4. Disable Microphone Access (For all apps)
    echo ------------------------------------------------------
    echo 5. Revert Advertising & Personalization Optimizations
    echo 6. Return to Privacy Optimization Menu
    echo ======================================================
    set /p advertising_choice=Enter your choice (1-6):
    call :validate_choice "%advertising_choice%" 1 6 privacy_advertising
    exit /b

:disable_advertising_id_adv
    call :log_message "Disabling Advertising ID..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Advertising ID disabled."
    pause
    goto privacy_advertising

:disable_location_services_adv
    call :log_message "Disabling Location Services (System-wide)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Location Services (System-wide) disabled."
    pause
    goto privacy_advertising

:disable_camera_access_adv
    call :log_message "Disabling Camera Access (For all apps)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" ""
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "*"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Camera Access (For all apps) disabled."
    pause
    goto privacy_advertising

:disable_microphone_access_adv
    call :log_message "Disabling Microphone Access (For all apps)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" ""
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "*"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Microphone Access (For all apps) disabled."
    pause
    goto privacy_advertising

:revert_advertising_optimizations
    call :log_message "Reverting Advertising & Personalization Optimizations..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "NoGlobalLocationControl" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceAllowTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Camera" "LetAppsAccessCamera_ForceDenyTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceAllowTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Microphone" "LetAppsAccessMicrophone_ForceDenyTheseApps" "REG_SZ" "" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Advertising & Personalization optimizations reverted."
    pause
    goto privacy_advertising

:privacy_option_3
:privacy_ux_feedback
    cls
    echo ======================================================
    echo          User Experience and Feedback Settings
    echo ======================================================
    echo 1. Disable Windows Tips and Notifications
    echo 2. Disable Lock Screen Ads and Spotlight
    echo 3. Disable Start Menu Suggestions and Ads
    echo ------------------------------------------------------
    echo 4. Revert User Experience & Feedback Optimizations
    echo 5. Return to Privacy Optimization Menu
    echo ======================================================
    set /p ux_feedback_choice=Enter your choice (1-5):
    call :validate_choice "%ux_feedback_choice%" 1 5 privacy_ux_feedback
    exit /b

:disable_windows_tips_adv
    call :log_message "Disabling Windows Tips and Notifications..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Tips and Notifications disabled."
    pause
    goto privacy_ux_feedback

:disable_lockscreen_ads_adv
    call :log_message "Disabling Lock Screen Ads and Spotlight..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Lock Screen Ads and Spotlight disabled."
    pause
    goto privacy_ux_feedback

:disable_startmenu_suggestions_adv
    call :log_message "Disabling Start Menu Suggestions and Ads..."
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Start Menu Suggestions and Ads disabled."
    pause
    goto privacy_ux_feedback

:revert_ux_feedback_optimizations
    call :log_message "Reverting User Experience & Feedback Optimizations..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastApplicationNotification" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" "NoToastNotificationQueue" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsSpotlightFeatures" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableContentDeliveryAds" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableLockScreenSpotlight" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "User Experience & Feedback optimizations reverted."
    pause
    goto privacy_ux_feedback

:privacy_option_4
:privacy_connected_experiences
    cls
    echo ======================================================
    echo          Connected Experiences Settings
    echo ======================================================
    echo 1. Disable Activity Feed (Timeline)
    echo 2. Disable Cortana
    echo 3. Disable Web Search in Start Menu
    echo 4. Disable People Bar (My People)
    echo 5. Uninstall OneDrive (Optional - Requires User Confirmation)
    echo ------------------------------------------------------
    echo 6. Revert Connected Experiences Optimizations
    echo 7. Return to Privacy Optimization Menu
    echo ======================================================
    set /p connected_choice=Enter your choice (1-7):
    call :validate_choice "%connected_choice%" 1 7 privacy_connected_experiences
    exit /b

:disable_activity_feed_adv
    call :log_message "Disabling Activity Feed (Timeline)..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Activity Feed (Timeline) disabled."
    pause
    goto privacy_connected_experiences

:disable_cortana_adv
    call :log_message "Disabling Cortana..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Cortana disabled."
    pause
    goto privacy_connected_experiences

:disable_web_search_startmenu_adv
    call :log_message "Disabling Web Search in Start Menu..."
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "1"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Web Search in Start Menu disabled."
    pause
    goto privacy_connected_experiences

:disable_people_bar_adv
    call :log_message "Disabling People Bar (My People)..."
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "0"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "People Bar (My People) disabled."
    pause
    goto privacy_connected_experiences

:uninstall_onedrive_adv
    call :uninstall_onedrive
    goto privacy_connected_experiences

:revert_connected_optimizations
    call :log_message "Reverting Connected Experiences Optimizations..."
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoInternetOpenWith" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "PeopleBand" "REG_DWORD" "/d 1" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Connected Experiences optimizations reverted."
    pause
    goto privacy_connected_experiences

:privacy_option_5
:revert_privacy_optimizations
    call :log_message "Reverting All Privacy Optimizations..."
    call :log_message "Restoring default privacy settings."
    goto revert_telemetry_optimizations
    goto revert_advertising_optimizations
    goto revert_ux_feedback_optimizations
    goto revert_connected_optimizations
    call :log_message "All privacy optimizations reverted to default settings."
    pause
    goto optimize_privacy

:privacy_option_6
    goto menu

:option_20
:manage_services
    cls
    echo ==================================================
    echo Windows Services Management
    echo ==================================================
    echo 1.  List all services
    echo 2.  List running services
    echo 3.  List stopped services
    echo 4.  Start a service
    echo 5.  Stop a service
    echo 6.  Restart a service
    echo 7.  Change service startup type
    echo 8.  Search for a service
    echo 9.  View service details
    echo 10. Return to main menu
    echo ==================================================
    set /p service_choice=Enter your choice (1-10):
    call :validate_choice "%service_choice%" 1 10 manage_services
    exit /b

:list_all_services
    call :log_message "Listing all services..."
    call :sc_start_stop_command query type= service state= all
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_services

:list_running_services
    call :log_message "Listing running services..."
    call :sc_start_stop_command query type= service state= running
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_services

:list_stopped_services
    call :log_message "Listing stopped services..."
    call :sc_start_stop_command query type= service state= stopped
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_services

:start_service
    set /p service_name=Enter the name of the service to start:
    call :sc_start_stop_command start "%service_name%"
    if %errorlevel% neq 0 (
        echo Error: Failed to start the service. Please check the service name and your permissions.
    ) else (
        echo Service start attempted. Please check the status.
    )
    pause
    goto manage_services

:stop_service
    set /p service_name=Enter the name of the service to stop:
    call :sc_start_stop_command stop "%service_name%"
    if %errorlevel% neq 0 (
        echo Error: Failed to stop the service. Please check the service name and your permissions.
    ) else (
        echo Service stop attempted. Please check the status.
    )
    pause
    goto manage_services

:restart_service
    set /p service_name=Enter the name of the service to restart:
    call :sc_start_stop_command stop "%service_name%"
    timeout /t 2 >nul
    call :sc_start_stop_command start "%service_name%"
    if %errorlevel% neq 0 (
        echo Error: Failed to restart the service. Please check the service name and your permissions.
    ) else (
        echo Service restart attempted. Please check the status.
    )
    pause
    goto manage_services

:change_startup_type
    set /p service_name=Enter the name of the service:
    echo Select startup type:
    echo 1. Automatic
    echo 2. Automatic (Delayed Start)
    echo 3. Manual
    echo 4. Disabled
    set /p startup_choice=Enter your choice (1-4):
    call :validate_choice "%startup_choice%" 1 4 change_startup_type
    exit /b
    if "%startup_choice%"=="1" (
        call :sc_config_command "%service_name%" start= auto
        if %errorlevel% neq 0 goto error_handler
    ) else if "%startup_choice%"=="2" (
        call :sc_config_command "%service_name%" start= delayed-auto
        if %errorlevel% neq 0 goto error_handler
    ) else if "%startup_choice%"=="3" (
        call :sc_config_command "%service_name%" start= demand
        if %errorlevel% neq 0 goto error_handler
    ) else if "%startup_choice%"=="4" (
        call :sc_config_command "%service_name%" start= disabled
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Startup type changed successfully."
    pause
    goto manage_services

:search_service
    set /p search_term=Enter search term for service name:
    call :sc_start_stop_command query state= all | findstr /i "%search_term%"
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_services

:view_service_details
    set /p service_name=Enter the name of the service to view details:
    call :sc_start_stop_command qc "%service_name%"
    if %errorlevel% neq 0 goto error_handler
    echo.
    echo Current Status:
    call :sc_start_stop_command query "%service_name%"
    if %errorlevel% neq 0 goto error_handler
    pause
    goto manage_services

:option_21
:network_optimization
    cls
    echo ======================================================
    echo              Network Optimization - Advanced
    echo ======================================================
    echo 1.  Optimize TCP Settings (General Performance)
    echo 2.  Reset Windows Sockets (Winsock Reset)
    echo 3.  Flush DNS Resolver Cache (Clear DNS Cache)
    echo 4.  Optimize Network Adapter Settings (Advanced Tuning)
    echo 5.  Disable IPv6 (Caution: Compatibility Issues Possible)
    echo 6.  Enable QoS Packet Scheduler (Prioritize Network Traffic)
    echo 7.  Set Static DNS Servers (Custom DNS)
    echo 8.  Reset All Network Settings (Comprehensive Reset - Requires Restart)
    echo 9.  Release and Renew IP Address (DHCP Refresh)
    echo 10. Test Internet Connection (Ping Test)
    echo 11. Revert All Network Optimizations (Undo Changes)
    echo 12. Return to Main Menu
    echo ======================================================
    set /p net_choice=Enter your choice (1-12):
    call :validate_choice "%net_choice%" 1 12 network_optimization
    exit /b

:optimize_tcp
    call :log_message "Optimizing TCP Settings (General Performance)..."
    call :netsh_set_global autotuninglevel=normal
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global congestionprovider=ctcp
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global heuristics=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global fastopen=enabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global timestamps=disabled
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global initialRto=2000
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global nonsackrttresiliency=disabled
    if %errorlevel% neq 0 goto error_handler
    call :log_message "TCP Settings Optimized for General Performance."
    pause
    goto network_optimization

:reset_winsock
    call :log_message "Resetting Windows Sockets (Winsock Reset)..."
    echo This will reset Winsock catalog to default configuration.
    netsh winsock reset
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Windows Sockets Reset Completed Successfully."
    call :log_message "Please restart your computer for changes to take effect."
    pause
    goto network_optimization

:optimize_adapter
    call :log_message "Optimizing Network Adapter Settings (Advanced Tuning)..."
    call :log_message "Applying advanced tuning parameters to connected network adapters..."
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
        call :log_message "Tuning adapter: ""%%j"""
        netsh int ip set interface "%%j" dadtransmits=0 store=persistent
        if %errorlevel% neq 0 goto error_handler
        netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue 0}"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Network Adapter Settings Optimized (Advanced Tuning)."
    pause
    goto network_optimization

:disable_ipv6
    echo ==================================================================================
    echo  !!! WARNING: DISABLING IPv6 MAY CAUSE CONNECTIVITY ISSUES ON SOME NETWORKS !!!
    echo  IPv6 is increasingly important for modern internet functionality.
    echo  Disable IPv6 ONLY if you are certain it is not needed in your network environment.
    echo  Proceeding may limit compatibility with some websites and services.
    echo ==================================================================================
    echo.
    set /p ipv6_confirm=Are you sure you want to DISABLE IPv6? (Type YES to confirm - POTENTIAL ISSUES):
    if /i "%ipv6_confirm%"=="YES" (
        call :log_message "Disabling IPv6..."
        call :netsh_set_global interface ipv6 set global randomizeidentifiers=disabled
        if %errorlevel% neq 0 goto error_handler
        call :netsh_set_global interface ipv6 set privacy state=disabled
        if %errorlevel% neq 0 goto error_handler
        call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" "DisabledComponents" "REG_DWORD" "255" "/f"
        if %errorlevel% neq 0 goto error_handler
        call :log_message "IPv6 Disabled."
        echo Please restart your computer for changes to take effect.
    ) else (
        echo IPv6 Disabling Cancelled. IPv6 remains enabled.
    )
    pause
    goto network_optimization

:enable_qos
    call :log_message "Enabling QoS Packet Scheduler (Prioritize Network Traffic)..."
    call :netsh_set_global packetcoalescinginbound=disabled
    if %errorlevel% neq 0 goto error_handler
    call :sc_config_command "Qwave" start= auto
    if %errorlevel% neq 0 goto error_handler
    call :sc_start_stop_command start "Qwave"
    if %errorlevel% neq 0 goto error_handler
    call :log_message "QoS Packet Scheduler Enabled."
    pause
    goto network_optimization

:set_static_dns
    call :dns_optimization_custom
    goto network_optimization

:reset_network_comprehensive
    call :log_message "Resetting All Network Settings (Comprehensive Reset - Requires Restart)..."
    echo This will reset Winsock, IP configuration, Firewall, Routing, and flush DNS.
    echo Please wait, this may take a moment...
    netsh winsock reset
    if %errorlevel% neq 0 goto error_handler
    netsh int ip reset all
    if %errorlevel% neq 0 goto error_handler
    netsh advfirewall reset
    if %errorlevel% neq 0 goto error_handler
    route -f
    ipconfig /release *
    ipconfig /renew *
    ipconfig /flushdns
    call :log_message "Comprehensive Network Settings Reset Completed."
    call :log_message "Please restart your computer for changes to fully take effect."
    pause
    goto network_optimization

:renew_ip_address
    call :log_message "Releasing and Renewing IP Address (DHCP Refresh)..."
    call :log_message "Releasing current IP configuration..."
    ipconfig /release
    if %errorlevel% neq 0 goto error_handler
    call :log_message "Renewing IP configuration from DHCP server..."
    ipconfig /renew
    if %errorlevel% neq 0 goto error_handler
    call :log_message "IP Address Released and Renewed Successfully. Check the output above for new IP configuration details."
    pause
    goto network_optimization

:test_internet_connection
    call :log_message "Testing Internet Connection (Ping Test)..."
    echo Pinging google.com to test internet connectivity and latency...
    ping -n 3 google.com
    call :log_message "Ping test completed. Check the output above for latency and connectivity status."
    call :log_message "If ping fails, check your internet connection and DNS settings."
    pause
    goto network_optimization

:revert_net_optimizations
    call :log_message "Reverting All Network Optimizations (Undo Changes)..."
    call :log_message "Restoring default network settings..."
    call :netsh_set_global autotuninglevel=normal
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global congestionprovider=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global ecncapability=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global timestamps=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global rss=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global fastopen=default
    if %errorlevel% neq 0 goto error_handler
    call :netsh_set_global heuristics=enabled
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "/d 0" "/f"
    if %errorlevel% neq 0 goto error_handler
    call :modify_registry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "/d 2" "/f"
    if %errorlevel% neq 0 goto error_handler
    for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
        call :log_message "Restoring adapter settings for: ""%%j"""
        netsh int ip set interface "%%j" dadtransmits=3 store=persistent
        if %errorlevel% neq 0 goto error_handler
        netsh int ip set interface "%%j" routerdiscovery=enabled store=persistent
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Get-NetAdapterAdvancedProperty -Name '%%j' | Where-Object {$_.DisplayName -in ('*FlowControl', '*InterruptModeration', '*PriorityVLANTag', '*SpeedDuplex', '*ReceiveSideScaling', '*JumboPacket') } | ForEach-Object {Set-NetAdapterAdvancedProperty -Name '%%j' -RegistryKeyword $_.RegistryKeyword -RegistryValue \$null}"
        if %errorlevel% neq 0 goto error_handler
        call :powershell_command "Set-NetAdapterPowerManagement -Name '%%j' -AllowComputerToTurnOffDevice \$true"
        if %errorlevel% neq 0 goto error_handler
        netsh interface ip set dns name="%%j" source=dhcp
        if %errorlevel% neq 0 goto error_handler
    )
    call :log_message "Network Optimizations Reverted to Default Settings. Please restart your computer."
    pause
    goto network_optimization

:option_22
:endexit
    echo Thank you for using the Windows Optimization Script!
    echo Script developed by [GT Singtaro]
    echo Version %SCRIPT_VERSION%
    pause
    exit

:: --- Error Handler ---
:error_handler
    echo.
    echo !!! CRITICAL ERROR ENCOUNTERED !!!
    echo An error occurred during script execution. Check "%LOG_FILE%" for details.
    echo The script will now exit to prevent further issues.
    echo Please review the log file, ensure you have administrator privileges,
    echo and that your system meets the script's requirements.
    pause
    exit /b 1

:: --- Script Start ---
call :check_admin
