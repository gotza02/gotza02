@echo off
setlocal enabledelayedexpansion

:: Script Metadata
set "SCRIPT_NAME=Smart Windows Optimizer"
set "SCRIPT_VERSION=5.1"
set "CONFIG_FILE=%userprofile%\Desktop\smart_opt_config.ini"
set "LOG_FILE=%userprofile%\Desktop\smart_opt_log.txt"
set "RESTART_FLAG=0"
set "COLOR_DEFAULT=0F"  :: White on Black
set "COLOR_ERROR=4F"    :: White on Red
set "COLOR_SUCCESS=2F"  :: White on Green
set "COLOR_WARNING=6F"  :: White on Yellow

:: Initialize
color %COLOR_DEFAULT%
title %SCRIPT_NAME% v%SCRIPT_VERSION%
call :check_admin || exit /b 1
call :init_config
call :log "Started %SCRIPT_NAME% v%SCRIPT_VERSION% on %date% %time%"

:menu
cls
echo.
echo  ╔════════════════════════════════════╗
echo  ║ %SCRIPT_NAME% v%SCRIPT_VERSION%        ║
echo  ║ Intelligent System Optimization    ║
echo  ╚════════════════════════════════════╝
echo  Current Date: %date%  Time: %time%
echo  Log File: %LOG_FILE%
echo.
echo  ╔════ Main Menu ═════════════════════╗
echo  ║ 1. Smart System Analysis           ║
echo  ║ 2. Optimize Display Performance    ║
echo  ║ 3. Manage Windows Defender         ║
echo  ║ 4. Optimize System Features        ║
echo  ║ 5. Boost CPU Performance           ║
echo  ║ 6. Enhance Internet Speed          ║
echo  ║ 7. Windows Update Control          ║
echo  ║ 8. Auto-Login Setup                ║
echo  ║ 9. Clear System Cache              ║
echo  ║ 10. Disk Optimization              ║
echo  ║ 11. System File Repair             ║
echo  ║ 12. Windows Activation             ║
echo  ║ 13. Power Management               ║
echo  ║ 14. Dark Mode Toggle               ║
echo  ║ 15. Partition Manager              ║
echo  ║ 16. Disk Cleanup                   ║
echo  ║ 17. Startup Programs               ║
echo  ║ 18. Backup and Restore             ║
echo  ║ 19. System Information             ║
echo  ║ 20. Privacy Enhancements           ║
echo  ║ 21. Service Management             ║
echo  ║ 22. Network Optimization           ║
echo  ║ 23. Exit                           ║
echo  ║ 24. Help                           ║
echo  ╚════════════════════════════════════╝
echo.
call :prompt "Enter your choice (1-24): " choice
if not defined choice (
    call :error "No input provided."
    goto menu
)
call :validate_input !choice! 1 24 || goto menu
goto option_!choice!

:option_1
:system_analysis
cls
echo === Smart System Analysis ===
echo Analyzing system... Please wait.
call :analyze_system
echo Analysis complete. Press any key to return.
pause >nul
goto menu

:option_2
:optimize_display
cls
echo === Optimize Display Performance ===
echo 1. Max Performance (Disable Effects)
echo 2. Balanced (Minimal Effects)
echo 3. Restore Defaults
echo 4. Back to Menu
call :prompt "Choose (1-4): " disp_choice
if "!disp_choice!"=="1" (
    call :reg_set "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
    call :success "Visual effects disabled."
) else if "!disp_choice!"=="2" (
    call :reg_set "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9E3E078012000000"
    call :success "Minimal effects enabled."
) else if "!disp_choice!"=="3" (
    reg delete "HKCU\Control Panel\Desktop" /v UserPreferencesMask /f >nul 2>&1
    call :success "Defaults restored."
) else if "!disp_choice!"=="4" goto menu
pause
goto optimize_display

:option_3
:manage_defender
cls
echo === Windows Defender Management ===
echo Current Status:
powershell -Command "Get-MpComputerStatus | Select-Object -Property AntivirusEnabled,RealTimeProtectionEnabled" 2>nul || echo Defender not detected.
echo.
echo 1. Enable Defender
echo 2. Disable Defender (Caution)
echo 3. Update Definitions
echo 4. Quick Scan
echo 5. Full Scan
echo 6. Back to Menu
call :prompt "Choose (1-6): " def_choice
if "!def_choice!"=="1" (
    call :reg_set "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
    call :success "Defender enabled."
) else if "!def_choice!"=="2" (
    call :check_third_party_av
    call :confirm "Disable Defender? This may reduce security." && (
        call :reg_set "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
        call :success "Defender disabled."
    )
) else if "!def_choice!"=="3" (
    echo Updating definitions...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate >nul 2>&1
    if !errorlevel! equ 0 (
        call :success "Definitions updated."
    ) else (
        call :error "Update failed. Check internet connection."
    )
) else if "!def_choice!"=="4" (
    echo Running quick scan...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    call :success "Quick scan completed."
) else if "!def_choice!"=="5" (
    echo Starting full scan (this may take a while)...
    start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    call :success "Full scan started."
) else if "!def_choice!"=="6" goto menu
pause
goto manage_defender

:option_4
:optimize_features
cls
echo === Optimize System Features ===
echo 1. Disable Cortana
echo 2. Enable Fast Startup
echo 3. Disable Game DVR
echo 4. Back to Menu
call :prompt "Choose (1-4): " feat_choice
if "!feat_choice!"=="1" (
    call :reg_set "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0"
    call :success "Cortana disabled."
) else if "!feat_choice!"=="2" (
    call :reg_set "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1"
    call :success "Fast Startup enabled."
) else if "!feat_choice!"=="3" (
    call :reg_set "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
    call :success "Game DVR disabled."
) else if "!feat_choice!"=="4" goto menu
pause
goto optimize_features

:option_5
:boost_cpu
cls
echo === Boost CPU Performance ===
echo 1. Set High Performance Plan
echo 2. Disable Core Parking
echo 3. Back to Menu
call :prompt "Choose (1-3): " cpu_choice
if "!cpu_choice!"=="1" (
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    call :success "High Performance plan activated."
) else if "!cpu_choice!"=="2" (
    powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
    powercfg -setactive scheme_current
    call :success "Core parking disabled."
) else if "!cpu_choice!"=="3" goto menu
pause
goto boost_cpu

:option_6
:enhance_internet
cls
echo === Enhance Internet Speed ===
echo 1. Optimize TCP Settings
echo 2. Flush DNS Cache
echo 3. Back to Menu
call :prompt "Choose (1-3): " net_choice
if "!net_choice!"=="1" (
    netsh int tcp set global autotuninglevel=normal
    netsh int tcp set global rss=enabled
    call :success "TCP settings optimized."
) else if "!net_choice!"=="2" (
    ipconfig /flushdns
    call :success "DNS cache flushed."
) else if "!net_choice!"=="3" goto menu
pause
goto enhance_internet

:option_7
:windows_update
cls
echo === Windows Update Control ===
echo 1. Enable Updates
echo 2. Disable Updates (Caution)
echo 3. Check for Updates
echo 4. Back to Menu
call :prompt "Choose (1-4): " upd_choice
if "!upd_choice!"=="1" (
    sc config wuauserv start= auto
    sc start wuauserv >nul 2>&1
    if !errorlevel! equ 0 (
        call :success "Windows Update enabled."
    ) else (
        call :error "Failed to enable Windows Update. Service may be restricted."
    )
) else if "!upd_choice!"=="2" (
    call :check_third_party_av
    call :confirm "Disable Updates? Ensure security alternatives are active." && (
        sc config wuauserv start= disabled
        sc stop wuauserv >nul 2>&1
        call :success "Windows Update disabled."
    )
) else if "!upd_choice!"=="3" (
    echo Checking for updates...
    powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
    call :success "Update check initiated."
) else if "!upd_choice!"=="4" goto menu
pause
goto windows_update

:option_8
:auto_login
cls
echo === Auto-Login Setup ===
echo WARNING: Password will be stored in plain text (security risk)!
echo 1. Enable Auto-Login
echo 2. Disable Auto-Login
echo 3. Back to Menu
call :prompt "Choose (1-3): " auto_choice
if "!auto_choice!"=="1" (
    call :prompt "Enter username: " username
    call :prompt "Enter password: " password
    call :reg_set "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "!username!"
    call :reg_set "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "!password!"
    call :reg_set "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
    call :success "Auto-Login enabled."
) else if "!auto_choice!"=="2" (
    call :reg_set "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "0"
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v DefaultPassword /f >nul 2>&1
    call :success "Auto-Login disabled."
) else if "!auto_choice!"=="3" goto menu
pause
goto auto_login

:option_9
:clear_cache
cls
echo === Clear System Cache ===
echo 1. Clear Temp Files
echo 2. Clear Network Cache
echo 3. Back to Menu
call :prompt "Choose (1-3): " cache_choice
if "!cache_choice!"=="1" (
    del /q /f /s %TEMP%\* 2>nul
    del /q /f /s C:\Windows\Temp\* 2>nul
    call :success "Temp files cleared."
) else if "!cache_choice!"=="2" (
    ipconfig /flushdns
    arp -d *
    call :success "Network cache cleared."
) else if "!cache_choice!"=="3" goto menu
pause
goto clear_cache

:option_10
:disk_opt
cls
echo === Disk Optimization ===
call :detect_disk_type
echo 1. Optimize Disk (Defrag/Trim)
echo 2. Check Disk Health
echo 3. Back to Menu
call :prompt "Choose (1-3): " disk_choice
if "!disk_choice!"=="1" (
    if "!DISK_TYPE!"=="SSD" (
        defrag C: /L >nul 2>&1
        if !errorlevel! equ 0 (
            call :success "SSD trimmed."
        ) else (
            call :error "Trim failed. Disk may be locked."
        )
    ) else (
        defrag C: /O >nul 2>&1
        if !errorlevel! equ 0 (
            call :success "Disk defragmented."
        ) else (
            call :error "Defrag failed. Check disk access."
        )
    )
) else if "!disk_choice!"=="2" (
    wmic diskdrive get status
    call :success "Disk health checked."
) else if "!disk_choice!"=="3" goto menu
pause
goto disk_opt

:option_11
:system_repair
cls
echo === System File Repair ===
echo 1. Run SFC
echo 2. Run DISM
echo 3. Back to Menu
call :prompt "Choose (1-3): " repair_choice
if "!repair_choice!"=="1" (
    echo Running SFC (this may take a few minutes)...
    sfc /scannow
    call :success "SFC scan completed."
) else if "!repair_choice!"=="2" (
    echo Running DISM (please wait)...
    DISM /Online /Cleanup-Image /RestoreHealth
    call :success "DISM repair completed."
) else if "!repair_choice!"=="3" goto menu
pause
goto system_repair

:option_12
:windows_activation
cls
echo === Windows Activation ===
echo 1. Check Status
echo 2. Activate with KMS
echo 3. Activate with Digital License
echo 4. Enter Product Key
echo 5. Back to Menu
call :prompt "Choose (1-5): " act_choice
if "!act_choice!"=="1" (
    slmgr /xpr
    pause
) else if "!act_choice!"=="2" (
    call :confirm "Use KMS activation? Requires internet." && (
        ping 8.8.8.8 -n 1 >nul 2>&1
        if !errorlevel! equ 0 (
            powershell -Command "irm https://get.activated.win | iex" >nul 2>&1
            if !errorlevel! equ 0 (
                call :success "KMS activation attempted."
            ) else (
                call :error "KMS activation failed."
            )
        ) else (
            call :error "No internet connection detected."
        )
    )
) else if "!act_choice!"=="3" (
    slmgr /ato
    call :success "Digital activation attempted."
) else if "!act_choice!"=="4" (
    call :prompt "Enter Product Key: " key
    slmgr /ipk !key!
    slmgr /ato
    call :success "Activation with key attempted."
) else if "!act_choice!"=="5" goto menu
pause
goto windows_activation

:option_13
:power_mgmt
cls
echo === Power Management ===
echo 1. High Performance Plan
echo 2. Balanced Plan
echo 3. Back to Menu
call :prompt "Choose (1-3): " power_choice
if "!power_choice!"=="1" (
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    call :success "High Performance plan set."
) else if "!power_choice!"=="2" (
    powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    call :success "Balanced plan set."
) else if "!power_choice!"=="3" goto menu
pause
goto power_mgmt

:option_14
:dark_mode
cls
echo === Dark Mode Toggle ===
echo 1. Enable Dark Mode
echo 2. Disable Dark Mode
echo 3. Back to Menu
call :prompt "Choose (1-3): " dark_choice
if "!dark_choice!"=="1" (
    call :reg_set "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
    call :reg_set "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
    call :success "Dark Mode enabled."
) else if "!dark_choice!"=="2" (
    call :reg_set "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "1"
    call :reg_set "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "1"
    call :success "Dark Mode disabled."
) else if "!dark_choice!"=="3" goto menu
pause
goto dark_mode

:option_15
:partition_mgr
cls
echo === Partition Manager ===
echo WARNING: Backup data before proceeding!
echo 1. List Partitions
echo 2. Create Partition
echo 3. Back to Menu
call :prompt "Choose (1-3): " part_choice
if "!part_choice!"=="1" (
    echo list disk > list_disk.txt
    diskpart /s list_disk.txt
    del list_disk.txt
    pause
) else if "!part_choice!"=="2" (
    call :prompt "Enter disk number: " disk_num
    call :prompt "Enter size in MB: " part_size
    echo select disk !disk_num! > create_part.txt
    echo create partition primary size=!part_size! >> create_part.txt
    diskpart /s create_part.txt
    del create_part.txt
    call :success "Partition created."
) else if "!part_choice!"=="3" goto menu
pause
goto partition_mgr

:option_16
:disk_cleanup
cls
echo === Disk Cleanup ===
echo 1. Standard Cleanup
echo 2. Back to Menu
call :prompt "Choose (1-2): " clean_choice
if "!clean_choice!"=="1" (
    echo Running cleanup...
    cleanmgr /sagerun:1
    call :success "Disk cleanup completed."
) else if "!clean_choice!"=="2" goto menu
pause
goto disk_cleanup

:option_17
:startup_mgr
cls
echo === Startup Programs ===
echo 1. Open msconfig
echo 2. Back to Menu
call :prompt "Choose (1-2): " startup_choice
if "!startup_choice!"=="1" (
    start msconfig
    call :success "msconfig opened."
) else if "!startup_choice!"=="2" goto menu
pause
goto startup_mgr

:option_18
:backup_restore
cls
echo === Backup and Restore ===
echo 1. Create Restore Point
echo 2. Back to Menu
call :prompt "Choose (1-2): " backup_choice
if "!backup_choice!"=="1" (
    echo Creating restore point...
    wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
    call :success "Restore point created."
) else if "!backup_choice!"=="2" goto menu
pause
goto backup_restore

:option_19
:system_info
cls
echo === System Information ===
echo 1. Basic Info
echo 2. Back to Menu
call :prompt "Choose (1-2): " info_choice
if "!info_choice!"=="1" (
    systeminfo
    pause
) else if "!info_choice!"=="2" goto menu
goto system_info

:option_20
:privacy_enh
cls
echo === Privacy Enhancements ===
echo 1. Disable Telemetry
echo 2. Back to Menu
call :prompt "Choose (1-2): " priv_choice
if "!priv_choice!"=="1" (
    call :reg_set "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
    call :success "Telemetry disabled."
) else if "!priv_choice!"=="2" goto menu
pause
goto privacy_enh

:option_21
:service_mgmt
cls
echo === Service Management ===
echo 1. List Running Services
echo 2. Back to Menu
call :prompt "Choose (1-2): " svc_choice
if "!svc_choice!"=="1" (
    sc query type= service state= running
    pause
) else if "!svc_choice!"=="2" goto menu
goto service_mgmt

:option_22
:network_opt
cls
echo === Network Optimization ===
echo 1. Reset Network Settings
echo 2. Back to Menu
call :prompt "Choose (1-2): " net_opt_choice
if "!net_opt_choice!"=="1" (
    netsh winsock reset
    netsh int ip reset
    call :success "Network settings reset. Restart required."
    set "RESTART_FLAG=1"
) else if "!net_opt_choice!"=="2" goto menu
pause
goto network_opt

:option_23
:exit_script
cls
echo === Exit Options ===
echo 1. Save and Exit without Restart
echo 2. Restart Now
echo 3. Shutdown
call :prompt "Choose (1-3): " exit_choice
if "!exit_choice!"=="1" (
    call :save_config
    if !RESTART_FLAG! equ 1 (
        call :confirm "Restart recommended. Restart now?" && shutdown /r /t 0
    )
    call :success "Thank you for using %SCRIPT_NAME%!"
    exit /b 0
) else if "!exit_choice!"=="2" (
    call :save_config
    shutdown /r /t 0
) else if "!exit_choice!"=="3" (
    call :save_config
    shutdown /s /t 0
) else (
    goto menu
)

:option_24
:help
cls
echo === Help ===
echo 1. Smart System Analysis - Analyzes system and suggests optimizations
echo 2. Optimize Display - Adjusts visual effects
echo 3. Manage Defender - Controls Windows Defender
echo ... (add more as needed)
echo 24. Help - This menu
pause
goto menu

:: Utility Functions
:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    call :error "This script requires administrator privileges."
    echo Right-click and select "Run as administrator".
    pause
    exit /b 1
)
call :log "Admin privileges confirmed."
exit /b 0

:init_config
if not exist "%CONFIG_FILE%" (
    echo [Settings] >"%CONFIG_FILE%"
    echo LastChoice=1 >>"%CONFIG_FILE%"
    echo FavoriteChoice=1 >>"%CONFIG_FILE%"
    echo AutoRestart=0 >>"%CONFIG_FILE%"
    call :log "Created new config file."
)
for /f "tokens=1,2 delims==" %%a in ('type "%CONFIG_FILE%"') do (
    if "%%a"=="LastChoice" set "LAST_CHOICE=%%b"
    if "%%a"=="FavoriteChoice" set "FAVORITE_CHOICE=%%b"
    if "%%a"=="AutoRestart" set "AUTO_RESTART=%%b"
)
exit /b 0

:save_config
echo [Settings] >"%CONFIG_FILE%"
echo LastChoice=!LAST_CHOICE! >>"%CONFIG_FILE%"
echo FavoriteChoice=!FAVORITE_CHOICE! >>"%CONFIG_FILE%"
echo AutoRestart=!AUTO_RESTART! >>"%CONFIG_FILE%"
call :log "Configuration saved."
exit /b 0

:log
echo [%date% %time%] %~1 >>"%LOG_FILE%"
exit /b 0

:reg_set
reg add "%~1" /v "%~2" /t "%~3" /d "%~4" /f >nul 2>&1
if %errorlevel% neq 0 (
    call :error "Failed to set registry: %~1\%~2"
) else (
    call :log "Set registry: %~1\%~2 to %~4"
)
exit /b 0

:prompt
set "%2="
set /p "%2=%~1"
if not defined %2 (
    call :error "Input cannot be empty."
    exit /b 1
)
call :log "User input: %~1 = !%2!"
exit /b 0

:validate_input
set "input=%~1"
set "min=%~2"
set "max=%~3"
echo !input!| findstr /r "^[0-9][0-9]*$" >nul || (
    call :error "Invalid input. Use numbers only."
    exit /b 1
)
if !input! lss %min% (
    call :error "Input below range (%min%-%max%)."
    exit /b 1
)
if !input! gtr %max% (
    call :error "Input above range (%min%-%max%)."
    exit /b 1
)
set "LAST_CHOICE=!input!"
exit /b 0

:confirm
color %COLOR_WARNING%
set /p "confirm=%~1 (Y/N): "
color %COLOR_DEFAULT%
if /i "!confirm!"=="Y" (
    call :log "User confirmed: %~1"
    exit /b 0
)
call :log "Operation cancelled: %~1"
exit /b 1

:check_third_party_av
powershell -Command "Get-CimInstance -Namespace root\SecurityCenter2 -Class AntiVirusProduct | Where-Object { $_.displayName -notlike '*Windows*' }" >nul 2>&1
if !errorlevel! equ 0 (
    call :log "Third-party AV detected."
) else (
    call :warning "No third-party antivirus detected. Disabling Defender/Update may reduce security."
)
exit /b 0

:detect_disk_type
powershell -Command "if ((Get-PhysicalDisk).MediaType -eq 'SSD') { exit 0 } else { exit 1 }" >nul 2>&1
if !errorlevel! equ 0 (
    set "DISK_TYPE=SSD"
    echo Disk Type: SSD
) else (
    set "DISK_TYPE=HDD"
    echo Disk Type: HDD
)
exit /b 0

:analyze_system
echo CPU:
wmic cpu get name
echo RAM:
wmic memorychip get capacity | findstr /v "Capacity" >nul 2>&1 && (
    for /f "tokens=*" %%a in ('wmic memorychip get capacity ^| findstr /v "Capacity"') do (
        set /a "RAM_TOTAL+=%%a"
    )
    set /a "RAM_GB=RAM_TOTAL / 1073741824"
    echo Total RAM: !RAM_GB! GB
    if !RAM_GB! lss 4 (
        call :warning "Low RAM detected. Consider disabling background apps (Option 4)."
    )
)
echo Disk:
call :detect_disk_type
if "!DISK_TYPE!"=="SSD" (
    echo Recommendation: Trim SSD (Option 10)
) else (
    echo Recommendation: Defragment Disk (Option 10)
)
exit /b 0

:error
color %COLOR_ERROR%
echo ERROR: %~1
call :log "ERROR: %~1"
timeout /t 2 >nul
color %COLOR_DEFAULT%
pause
exit /b 0

:success
color %COLOR_SUCCESS%
echo SUCCESS: %~1
call :log "SUCCESS: %~1"
timeout /t 1 >nul
color %COLOR_DEFAULT%
exit /b 0

:warning
color %COLOR_WARNING%
echo WARNING: %~1
call :log "WARNING: %~1"
timeout /t 2 >nul
color %COLOR_DEFAULT%
exit /b 0
