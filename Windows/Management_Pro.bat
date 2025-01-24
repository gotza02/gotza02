@echo off
setlocal enabledelayedexpansion

:: -------------------------------------------------------------------------
::                      Windows Optimization Script v3.5
::                      Efficiency & Speed - Enhanced Edition - Optimized
:: -------------------------------------------------------------------------

:: ** คำเตือน ** : Script นี้ปรับให้เหมาะสมสำหรับ Windows 11.
:: Windows 10 หรือเก่ากว่าอาจมีปัญหาความเข้ากันได้.

ver | findstr /i "Version 10.0." >nul 2>&1
if %errorlevel% equ 0 (
    echo.
    echo [!] ======================================================================= [!]
    echo [!] **คำเตือน:** Script นี้ปรับให้เหมาะสมสำหรับ Windows 11. Windows 10    [!]
    echo [!] หรือเก่ากว่าอาจมีปัญหาความเข้ากันได้.                                  [!]
    echo [!] ======================================================================= [!]
    echo.
    pause
)

:: ตรวจสอบสิทธิ์ผู้ดูแลระบบ (ฟังก์ชัน)
call :checkAdmin

:: ฟังก์ชันดึงข้อมูลสถานะระบบ (ปรับปรุงให้มีประสิทธิภาพ)
call :getSystemStatus

:mainMenu
cls
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║                      ** System Status Dashboard **                      ║
echo  ╠══════════════════════════════════════════════════════════════════╣
echo  ║ Windows Defender     : !defender_status!                                 ║
echo  ║ Windows Update       : !update_status!                                   ║
echo  ║ Power Plan           : !powerplan_name!                                  ║
echo  ║ Dark Mode            : !darkmode_status!                                   ║
echo  ║ GPU Scheduling       : !gpu_scheduling_status!                             ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║             Windows Optimization Script v3.5 - Enhanced Edition             ║
echo  ╠══════════════════════════════════════════════════════════════════╣
echo  ║ กรุณาเลือกตัวเลือก:                                                         ║
echo  ║                                                                          ║
echo  ║  [1] ปรับแต่งประสิทธิภาพการแสดงผล       [11] เปิดใช้งาน Windows (KMS - **เสี่ยง!**)  [21] ปรับแต่งเครือข่าย    ║
echo  ║  [2] จัดการ Windows Defender             [12] จัดการการตั้งค่าพลังงาน                [22] ออกจากโปรแกรม        ║
echo  ║  [3] ปรับแต่งคุณสมบัติระบบ                [13] เปิดใช้งาน Dark Mode                     [23] ปิดใช้งานเอฟเฟกต์โปร่งใส   ║
echo  ║  [4] ปรับแต่งประสิทธิภาพ CPU               [14] จัดการพาร์ติชัน (**เสี่ยงข้อมูลหาย!**)    [24] ปิดใช้งาน Animation พิเศษ   ║
echo  ║  [5] ปรับแต่งประสิทธิภาพอินเทอร์เน็ต        [15] ล้างไฟล์ขยะใน Disk                    [25] ปรับแต่ง Storage Sense     ║
echo  ║  [6] จัดการ Windows Update                [16] จัดการโปรแกรม Startup                 [26] ปิดเสียง Startup          ║
echo  ║  [7] ตั้งค่า Auto-login (**เสี่ยงด้านความปลอดภัย!**) [17] สำรองและกู้คืนการตั้งค่า         [27] ปรับแต่ง Paging File (**ขั้นสูง!**) ║
echo  ║  [8] ล้าง System Cache                   [18] ข้อมูลระบบ                              [28] ปิด Widget Features (Win11) ║
echo  ║  [9] ปรับแต่ง Disk                        [19] ปรับแต่งการตั้งค่าความเป็นส่วนตัว       [29] ปรับแต่ง Game Mode Settings  ║
echo  ║  [10] ตรวจสอบและซ่อมแซม System Files      [20] จัดการ Windows Services               [30] กลับสู่เมนูหลัก          ║
echo  ║                                                                          ║
echo  ║ **คำเตือน**:                                                                ║
echo  ║  - ตัวเลือก [11] KMS Activation:  **มีความเสี่ยงด้านความปลอดภัยและกฎหมายสูง!**   ║
echo  ║  - ตัวเลือก [14] จัดการพาร์ติชัน: **มีความเสี่ยงสูงที่จะสูญเสียข้อมูลถาวร! สำรองข้อมูลก่อน!** ║
echo  ║  - ตัวเลือก [7, 27, 4, 20, 21] เป็นตัวเลือกขั้นสูง, ใช้ด้วยความระมัดระวัง.         ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.

set /p choice=  กรุณาเลือกตัวเลือก (1-30):

:: ตรวจสอบการป้อนข้อมูลของผู้ใช้ (ปรับปรุง)
if not defined choice (
    echo.
    echo [!] **ข้อผิดพลาด:** กรุณาป้อนตัวเลือก.
    echo.
    pause
    goto mainMenu
)

if "%choice%"=="?" (
    call :showHelpMenu
    goto mainMenu
)

if %choice% GEQ 1 AND %choice% LEQ 30 (
    goto option_%choice%
) else (
    echo.
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง. กรุณาลองอีกครั้ง.
    echo.
    pause
    goto mainMenu
)

:option_1  & call :optimizeDisplay & goto mainMenu
:option_2  & call :manageDefender & goto mainMenu
:option_3  & call :optimizeFeatures & goto mainMenu
:option_4  & call :optimizeCPU & goto mainMenu
:option_5  & call :optimizeInternet & goto mainMenu
:option_6  & call :windowsUpdate & goto mainMenu
:option_7  & call :autoLogin & goto mainMenu
:option_8  & call :clearCache & goto mainMenu
:option_9  & call :optimizeDisk & goto mainMenu
:option_10 & call :checkRepair & goto mainMenu
:option_11 & call :windowsActivate & goto mainMenu
:option_12 & call :managePower & goto mainMenu
:option_13 & call :enableDarkMode & goto mainMenu
:option_14 & call :managePartitions & goto mainMenu
:option_15 & goto cleanup_system & goto mainMenu
:option_16 & call :manageStartup & goto mainMenu
:option_17 & call :backupRestore & goto mainMenu
:option_18 & call :systemInfo & goto mainMenu
:option_19 & call :optimizePrivacy & goto mainMenu
:option_20 & call :manageServices & goto mainMenu
:option_21 & call :networkOptimization & goto mainMenu
:option_22 & goto endexit
:option_23 & call :disableTransparency & goto mainMenu
:option_24 & call :disableAnimationsExtra & goto mainMenu
:option_25 & call :optimizeStorageSenseMenu & goto mainMenu
:option_26 & call :disableStartupSound & goto mainMenu
:option_27 & call :optimizePagingFileMenu & goto mainMenu
:option_28 & call :disableWidgets & goto mainMenu
:option_29 & call :optimizeGameModeMenu & goto mainMenu
:option_30 & goto mainMenu

:: ========================= Functions =========================

:checkAdmin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [!] **ข้อผิดพลาด:** จำเป็นต้องมีสิทธิ์ผู้ดูแลระบบ. กรุณา Run as administrator.
    echo.
    pause
    exit /b 1
)
exit /b 0

:getSystemStatus
:: ดึงข้อมูลสถานะทั้งหมดในครั้งเดียวเพื่อประสิทธิภาพ
(
    :: Windows Defender Status
    call :getDefenderStatusInternal
    set "defender_status=!defender_internal_status!"

    :: Windows Update Status
    call :getUpdateStatusInternal
    set "update_status=!update_internal_status!"

    :: Power Plan Status
    call :getPowerPlanStatusInternal
    set "powerplan_name=!powerplan_internal_name!"

    :: Dark Mode Status
    call :getDarkModeStatusInternal
    set "darkmode_status=!darkmode_internal_status!"

    :: GPU Scheduling Status
    call :getGPUSchedulingStatusInternal
    set "gpu_scheduling_status=!gpu_scheduling_internal_status!"
)
exit /b 0

:getDefenderStatusInternal
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" 2^>nul ^| find "REG_DWORD"') do set "defender_dword=%%a"
    if "!defender_dword!"=="0x1" ( set "defender_internal_status=Disabled (Policy)" ) else ( set "defender_internal_status=Enabled (Policy)" )
) else if exist "%ProgramFiles%\Windows Defender\MpCmdRun.exe" (
    sc query windefend >nul 2>&1
    if %errorlevel% equ 0 ( set "defender_internal_status=Enabled (Service Running)" ) else ( set "defender_internal_status=Disabled (Service Stopped)" )
) else ( set "defender_internal_status=Not Available" )
exit /b 0

:getUpdateStatusInternal
sc query wuauserv >nul 2>&1
if %errorlevel% equ 0 (
    sc query wuauserv | findstr /i "STATE" | findstr /i "DISABLED" >nul 2>&1
    if %errorlevel% equ 0 ( set "update_internal_status=Disabled" ) else ( set "update_internal_status=Enabled" )
) else ( set "update_internal_status=Unknown" )
exit /b 0

:getPowerPlanStatusInternal
for /f "tokens=3*" %%a in ('powercfg /getactivescheme') do set "active_guid=%%a"
for /f "tokens=2*" %%a in ('powercfg /query %active_guid% /name ^| findstr Scheme name') do set "powerplan_internal_name=%%b"
if not defined powerplan_internal_name set "powerplan_internal_name=Unknown"
exit /b 0

:getDarkModeStatusInternal
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" | find "REG_DWORD" | find "0x0" >nul 2>&1
if %errorlevel% equ 0 (
    reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" | find "REG_DWORD" | find "0x0" >nul 2>&1
    if %errorlevel% equ 0 ( set "darkmode_internal_status=Enabled" ) else ( set "darkmode_internal_status=Disabled" )
) else ( set "darkmode_internal_status=Disabled" )
exit /b 0

:getGPUSchedulingStatusInternal
ver | findstr /i "Version 10.0.19041" >nul 2>&1
if %errorlevel% equ 0 (
    reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" | find "REG_DWORD" | find "0x2" >nul 2>&1
    if %errorlevel% equ 0 ( set "gpu_scheduling_internal_status=Enabled (Supported)" ) else ( set "gpu_scheduling_internal_status=Disabled (Supported)" )
) else ( set "gpu_scheduling_internal_status=Not Supported" )
exit /b 0

:optimizeDisplay
echo.
echo [>] กำลังปรับแต่งการแสดงผล...
call :modifyRegistry "HKCU\Control Panel\Desktop" "UserPreferencesMask" "REG_BINARY" "9012078010000000"
call :modifyRegistry "HKCU\Control Panel\Desktop" "MenuShowDelay" "REG_SZ" "0"
call :modifyRegistry "HKCU\Control Panel\Desktop\WindowMetrics" "MinAnimate" "REG_SZ" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaSelect" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" "REG_DWORD" "0"
call :modifyRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" "EnableAeroPeek" "REG_DWORD" "0"
echo [>] การแสดงผลได้รับการปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:manageDefender
:manageDefenderMenu
cls
echo.
echo  ╔════════════════════════ Windows Defender Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] ตรวจสอบสถานะ         [4] อัปเดต Defender         [7] จัดการ Real-time Protection  [10] ดูประวัติภัยคุกคาม ║
echo  ║  [2] เปิดใช้งาน             [5] สแกนด่วน                [8] จัดการ Cloud Protection      [11] กลับสู่เมนูหลัก        ║
echo  ║  [3] ปิดใช้งาน (**ไม่แนะนำ**) [6] สแกนเต็มรูปแบบ          [9] จัดการ Sample Submission                               ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p def_choice=  กรุณาเลือกตัวเลือก (1-11):
echo.

if "%def_choice%"=="1" ( call :checkDefenderStatus ) else
if "%def_choice%"=="2" ( call :enableDefender ) else
if "%def_choice%"=="3" ( call :disableDefender ) else
if "%def_choice%"=="4" ( call :updateDefender ) else
if "%def_choice%"=="5" ( call :quickScanDefender ) else
if "%def_choice%"=="6" ( call :fullScanDefender ) else
if "%def_choice%"=="7" ( call :manageRealtimeProtection ) else
if "%def_choice%"=="8" ( call :manageCloudProtection ) else
if "%def_choice%"=="9" ( call :manageSampleSubmission ) else
if "%def_choice%"=="10" ( call :viewThreatHistory ) else
if "%def_choice%"=="11" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto manageDefenderMenu
)
goto manageDefenderMenu

:checkDefenderStatus
echo [>] กำลังตรวจสอบสถานะ Defender...
sc query windefend
echo.
pause
goto mainMenu

:enableDefender
echo [>] กำลังเปิดใช้งาน Defender...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "0"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "Disable*" "REG_DWORD" "0"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "1"
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "1"
echo [>] Defender เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:disableDefender
echo.
echo [!] **คำเตือน:** การปิดใช้งาน Defender จะลดความปลอดภัยของระบบ.
set /p confirm_disable=  คุณต้องการดำเนินการต่อหรือไม่? (Y/N):
if /i "%confirm_disable%"=="Y" (
    echo [>] กำลังปิดใช้งาน Defender...
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" "DisableAntiSpyware" "REG_DWORD" "1"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" "Disable*" "REG_DWORD" "1"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" "REG_DWORD" "0"
    call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" "REG_DWORD" "2"
    echo [>] Defender ถูกปิดใช้งานแล้ว. **มีความเสี่ยงด้านความปลอดภัย!**
    echo.
    pause
) else (
    echo [>] การปิดใช้งาน Defender ถูกยกเลิก.
    echo.
    pause
)
goto mainMenu

:updateDefender
echo [>] กำลังอัปเดต Defender...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
if %errorlevel% equ 0 (
    echo [>] Defender อัปเดตแล้ว.
) else (
    echo [!] **ข้อผิดพลาด:** การอัปเดตล้มเหลว. กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต.
)
echo.
pause
goto mainMenu

:quickScanDefender
echo [>] กำลังทำการสแกนด่วน...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo [>] การสแกนด่วนเสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:fullScanDefender
echo [>] กำลังทำการสแกนเต็มรูปแบบ (อาจใช้เวลานาน)...
start "" "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
echo [>] การสแกนเต็มรูปแบบเริ่มทำงานในพื้นหลังแล้ว. กรุณาตรวจสอบ Windows Security สำหรับความคืบหน้า.
echo.
pause
goto mainMenu

:manageRealtimeProtection & call :toggleDefenderFeature "Real-Time Protection" "DisableRealtimeMonitoring" & goto manageDefenderMenu
:manageCloudProtection    & call :toggleDefenderFeature "Cloud-delivered Protection" "SpynetReporting" & goto manageDefenderMenu
:manageSampleSubmission & call :toggleDefenderFeature "Automatic Sample Submission" "SubmitSamplesConsent" & goto manageDefenderMenu
:viewThreatHistory
echo [>] กำลังดูประวัติภัยคุกคาม...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -GetFiles
echo [>] ประวัติภัยคุกคามแสดงแล้ว.
echo.
pause
goto mainMenu

:toggleDefenderFeature
echo.
echo [>] สถานะปัจจุบันของ %~1:
reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v %~2 2>nul || reg query "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v %~2
set /p choice=  คุณต้องการเปิดใช้งาน (E) หรือปิดใช้งาน (D) %~1? (E/D):
if /i "%choice%"=="E" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v %~2 /f 2>nul || reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v %~2 /t REG_DWORD /d "2" /f
    echo [>] %~1 เปิดใช้งานแล้ว.
) else if /i "%choice%"=="D" (
    call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" %~2 "REG_DWORD" "1" || call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" %~2 "REG_DWORD" "0"
    echo [>] %~1 ปิดใช้งานแล้ว.
) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
)
echo.
pause
goto manageDefenderMenu

:optimizeFeatures
echo.
echo [>] กำลังปรับแต่งคุณสมบัติระบบ...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" "REG_DWORD" "0" & echo [>] - Activity Feed ปิดใช้งานแล้ว.
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" "REG_DWORD" "1" & echo [>] - Background apps ปิดใช้งานแล้ว.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" "REG_DWORD" "0" & echo [>] - Cortana ปิดใช้งานแล้ว.
call :disableGameDVRBar  & echo [>] - Game DVR และ Game Bar ปิดใช้งานแล้ว.
call :modifyRegistry "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" "REG_SZ" "506" & echo [>] - Sticky Keys prompt ปิดใช้งานแล้ว.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" "REG_DWORD" "1" & echo [>] - Windows Tips ปิดใช้งานแล้ว.
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" "REG_DWORD" "0" & echo [>] - Start Menu suggestions ปิดใช้งานแล้ว.
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" "1" & echo [>] - Fast Startup เปิดใช้งานแล้ว.
echo [>] คุณสมบัติระบบได้รับการปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:disableGameDVRBar
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowGameDVR" "REG_DWORD" "0"
call :modifyRegistry "HKCU\System\GameConfigStore" "GameDVR_Enabled" "REG_DWORD" "0"
exit /b 0

:optimizeCPU
:optimizeCPUMenu
cls
echo.
echo  ╔══════════════════════════ CPU Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] High Performance Plan       [4] Disable Core Parking    [7] Disable Services (**Advanced**) ║
echo  ║  [2] Disable Throttling          [5] Adjust Power Mgmt       [8] Adjust Visual Effects         ║
echo  ║  [3] Optimize Scheduling         [6] Enable GPU Scheduling   [9] กลับสู่เมนูหลัก                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p cpu_choice=  กรุณาเลือกตัวเลือก (1-9):
echo.

if "%cpu_choice%"=="1" ( call :setHighPerformancePlan ) else
if "%cpu_choice%"=="2" ( call :disableCPUThrottling ) else
if "%cpu_choice%"=="3" ( call :optimizeScheduling ) else
if "%cpu_choice%"=="4" ( call :disableCoreParking ) else
if "%cpu_choice%"=="5" ( call :adjustPowerManagement ) else
if "%cpu_choice%"=="6" ( call :enableGPUScheduling ) else
if "%cpu_choice%"=="7" ( call :disableServicesMenu ) else
if "%cpu_choice%"=="8" ( call :adjustVisualEffects ) else
if "%cpu_choice%"=="9" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizeCPUMenu
)
goto optimizeCPUMenu

:setHighPerformancePlan
echo [>] กำลังตั้งค่าแผน High Performance...
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการตั้งค่า. กำลังสร้างแผนใหม่...
    powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    for /f "tokens=4" %%i in ('powercfg -list ^| findstr /i "High performance"') do set hp_guid=%%i
    if defined hp_guid powercfg -setactive %hp_guid%
)
echo [>] แผน High Performance ถูกตั้งค่าแล้ว.
echo.
pause
goto mainMenu

:disableCPUThrottling
echo [>] กำลังปิดใช้งาน CPU throttling...
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
powercfg -setactive scheme_current
echo [>] CPU throttling ถูกปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:optimizeScheduling
echo [>] กำลังปรับแต่ง processor scheduling...
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" "REG_DWORD" "38"
echo [>] Processor scheduling ถูกปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:disableCoreParking
echo [>] กำลังปิดใช้งาน CPU core parking...
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
powercfg -setactive scheme_current
echo [>] CPU core parking ถูกปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:adjustPowerManagement
echo [>] กำลังปรับแต่ง power management...
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
powercfg -setactive scheme_current
echo [>] Power management ถูกปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:enableGPUScheduling
echo [>] กำลังเปิดใช้งาน GPU scheduling...
ver | findstr /i "Version 10.0.19041" >nul 2>&1
if %errorlevel% equ 0 (
    call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" "REG_DWORD" "2"
    echo [>] GPU scheduling เปิดใช้งานแล้ว. จำเป็นต้อง Restart.
    echo.
    pause
) else (
    echo [!] **ข้อผิดพลาด:** GPU scheduling ไม่รองรับใน Windows version นี้.
    echo.
    pause
)
goto mainMenu

:disableServicesMenu
:disableServicesSubMenu
cls
echo.
echo  ╔══════════ Disable System Services (Advanced) ══════════╗
echo  ║                                                          ║
echo  ║ **คำเตือน:** การปิดใช้งาน services อาจทำให้ระบบไม่เสถียร. ║
echo  ║ โปรดดำเนินการด้วยความระมัดระวัง!                       ║
echo  ║                                                          ║
echo  ║  [1] Disable SysMain (Superfetch)    [3] Disable WSearch (Windows Search)  [5] กลับสู่เมนู CPU ║
echo  ║  [2] Disable DiagTrack (Diagnostics) [4] Disable ALL above (Aggressive)      ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p svc_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%svc_choice%"=="1" ( call :disableService "SysMain" "Superfetch" ) else
if "%svc_choice%"=="2" ( call :disableService "DiagTrack" "Diagnostic Tracking" ) else
if "%svc_choice%"=="3" ( call :disableService "WSearch" "Windows Search" ) else
if "%svc_choice%"=="4" ( call :disableMultipleServices ) else
if "%svc_choice%"=="5" ( goto optimizeCPUMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto disableServicesSubMenu
)
goto disableServicesSubMenu

:disableService
echo [>] กำลังปิดใช้งาน %~2 (%~1)...
sc config "%~1" start= disabled
sc stop "%~1" 2>nul
echo [>] %~2 ปิดใช้งานแล้ว.
echo.
pause
goto disableServicesMenu

:disableMultipleServices
echo [>] กำลังปิดใช้งาน SysMain, DiagTrack, WSearch...
call :disableService "SysMain" "Superfetch"
call :disableService "DiagTrack" "Diagnostic Tracking"
call :disableService "WSearch" "Windows Search"
echo [>] Services หลายรายการถูกปิดใช้งานแล้ว. **กรุณาตรวจสอบระบบหลัง Restart!**
echo.
pause
goto disableServicesMenu

:adjustVisualEffects
echo [>] กำลังปรับแต่ง visual effects เพื่อประสิทธิภาพ...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" "REG_DWORD" "2"
echo [>] Visual effects ถูกปรับแต่งเพื่อประสิทธิภาพแล้ว.
echo.
pause
goto mainMenu

:optimizeInternet
:optimizeInternetMenu
cls
echo.
echo  ╔══════════════════════════ Internet Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Basic Optimizations          [4] Network Adapter Tuning (**Advanced**)      ║
echo  ║  [2] Advanced TCP Optimizations     [5] Clear Network Cache                     ║
echo  ║  [3] DNS Optimization             [6] กลับสู่เมนูหลัก                            ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p net_choice=  กรุณาเลือกตัวเลือก (1-6):
echo.

if "%net_choice%"=="1" ( call :basicInternetOptimizations ) else
if "%net_choice%"=="2" ( call :advancedTCPOptimizations ) else
if "%net_choice%"=="3" ( call :dnsOptimization ) else
if "%net_choice%"=="4" ( call :adapterTuning ) else
if "%net_choice%"=="5" ( call :clearNetworkCache ) else
if "%net_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizeInternetMenu
)
goto optimizeInternetMenu

:basicInternetOptimizations
echo [>] กำลังดำเนินการ basic optimizations...
netsh int tcp set global autotuninglevel=normal & netsh int tcp set global chimney=enabled & netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled & netsh int tcp set global ecncapability=enabled & netsh int tcp set global timestamps=disabled & netsh int tcp set global rss=enabled
echo [>] Basic optimizations เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:advancedTCPOptimizations
echo [>] กำลังดำเนินการ advanced TCP optimizations (**ผู้ใช้ขั้นสูง**)...
netsh int tcp set global congestionprovider=ctcp & netsh int tcp set global ecncapability=enabled & netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled & netsh int tcp set global fastopen=enabled & netsh int tcp set global hystart=disabled & netsh int tcp set global pacingprofile=off
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPNoDelay" "REG_DWORD" "1"
call :modifyRegistry "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" "TCPDelAckTicks" "REG_DWORD" "0"
echo [>] Advanced TCP optimizations เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:dnsOptimization
echo [>] กำลังปรับแต่ง DNS settings...
ipconfig /flushdns
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "Connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set dns name="%interface_name%" source=static address=8.8.8.8 register=primary
    netsh int ip add dns name="%interface_name%" address=8.8.4.4 index=2
    echo [>] DNS optimized (8.8.8.8, 8.8.4.4).
) else (
    echo [!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. DNS ล้มเหลว.
)
echo.
pause
goto mainMenu

:adapterTuning
echo [>] กำลังปรับแต่ง network adapter (**ขั้นสูง - อาจต้องปรับแต่งเพิ่มเติม**)...
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "Connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set interface name="%interface_name%" dadtransmits=0 store=persistent
    netsh int ip set interface name="%interface_name%" routerdiscovery=disabled store=persistent
    powershell -Command "Get-NetAdapter -Name '%interface_name%' | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3; Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
    echo [>] Adapter tuned. **อาจต้องปรับแต่งเพิ่มเติมใน Device Manager.**
) else (
    echo [!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Adapter tuning ล้มเหลว.
)
echo.
pause
goto mainMenu

:clearNetworkCache
echo [>] กำลังล้าง network cache...
ipconfig /flushdns & arp -d * & nbtstat -R & nbtstat -RR & netsh int ip reset & netsh winsock reset
echo [>] Network cache ถูกล้างแล้ว.
echo.
pause
goto mainMenu

:windowsUpdate
:windowsUpdateMenu
cls
echo.
echo  ╔══════════════════════ Windows Update Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Enable Updates                  [3] Check for Updates                    ║
echo  ║  [2] Disable Updates (**Not Recommended**) [4] กลับสู่เมนูหลัก                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p update_choice=  กรุณาเลือกตัวเลือก (1-4):
echo.

if "%update_choice%"=="1" ( call :enableWindowsUpdate ) else
if "%update_choice%"=="2" ( call :disableWindowsUpdate ) else
if "%update_choice%"=="3" ( call :checkWindowsUpdates ) else
if "%update_choice%"=="4" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto windowsUpdateMenu
)
goto windowsUpdateMenu

:enableWindowsUpdate
echo [>] กำลังเปิดใช้งาน Windows Update...
sc config wuauserv start= auto
sc start wuauserv
if %errorlevel% equ 0 (
    echo [>] Updates เปิดใช้งานแล้ว.
) else (
    echo [!] **ข้อผิดพลาด:** การเปิดใช้งานล้มเหลว. กรุณาตรวจสอบสิทธิ์.
)
echo.
pause
goto mainMenu

:disableWindowsUpdate
echo.
echo [!] **คำเตือน:** การปิดใช้งาน updates เป็นความเสี่ยงด้านความปลอดภัย.
set /p confirm_disable_update=  คุณต้องการดำเนินการต่อหรือไม่? (Y/N):
if /i "%confirm_disable_update%"=="Y" (
    echo [>] กำลังปิดใช้งาน Windows Update...
    sc config wuauserv start= disabled
    sc stop wuauserv
    if %errorlevel% equ 0 (
        echo [>] Updates ถูกปิดใช้งานแล้ว. **ความเสี่ยงด้านความปลอดภัย!**
    ) else (
        echo [!] **ข้อผิดพลาด:** การปิดใช้งานล้มเหลว. กรุณาตรวจสอบสิทธิ์.
    )
    echo.
    pause
) else (
    echo [>] การปิดใช้งาน Updates ถูกยกเลิก.
    echo.
    pause
)
goto mainMenu

:checkWindowsUpdates
echo [>] กำลังตรวจสอบ updates...
powershell -Command "(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()"
echo [>] การตรวจสอบ Update เริ่มต้นแล้ว. กรุณาดูที่ Settings > Windows Update.
echo.
pause
goto mainMenu

:autoLogin
echo.
echo [>] กำลังตั้งค่า Auto-login (**เสี่ยงด้านความปลอดภัย!**)...
echo [!] **คำเตือนด้านความปลอดภัย:** Auto-login ข้ามหน้าจอ login, ลดความปลอดภัย.
echo [!] กรุณาใช้บนเครื่องส่วนตัวที่ปลอดภัยเท่านั้น.
set /p username=  กรุณาป้อน username:
set /p password=  กรุณาป้อน password:
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultUserName" "REG_SZ" "%username%"
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "DefaultPassword" "REG_SZ" "%password%"
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" "AutoAdminLogon" "REG_SZ" "1"
echo [>] Auto-login ถูกตั้งค่าแล้ว. **ความเสี่ยงด้านความปลอดภัย!**
echo.
pause
goto mainMenu

:clearCache
echo [>] กำลังล้าง system cache...
del /q /f /s %TEMP%\* 2>nul
del /q /f /s C:\Windows\Temp\* 2>nul
echo [>] System cache ถูกล้างแล้ว.
echo.
pause
goto mainMenu

:optimizeDisk
:optimizeDiskMenu
cls
echo.
echo  ╔══════════════════════════ Disk Optimization ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Analyze Disk              [3] Check Disk Errors         [5] Clean Up System Files        ║
echo  ║  [2] Optimize/Defrag           [4] Trim SSD                  [6] กลับสู่เมนูหลัก                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p disk_choice=  กรุณาเลือกตัวเลือก (1-6):
echo.

if "%disk_choice%"=="1" ( call :analyzeDisk ) else
if "%disk_choice%"=="2" ( call :optimizeDefrag ) else
if "%disk_choice%"=="3" ( call :checkDiskErrors ) else
if "%disk_choice%"=="4" ( call :trimSSD ) else
if "%disk_choice%"=="5" ( goto cleanup_system ) else
if "%disk_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizeDiskMenu
)
goto optimizeDiskMenu

:analyzeDisk
echo [>] กำลังวิเคราะห์ disk...
defrag C: /A
echo [>] Disk analysis เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:optimizeDefrag
echo [>] กำลัง Optimize/Defragment disk...
defrag C: /O
echo [>] Disk optimization เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:checkDiskErrors
echo [>] กำลังกำหนดเวลา disk check สำหรับการ restart ครั้งถัดไป...
echo [!] **Disk check จะทำงานในการ restart ระบบครั้งถัดไป.**
chkdsk C: /F /R /X
echo.
pause
goto mainMenu

:trimSSD
echo [>] กำลังเปิดใช้งาน SSD TRIM...
fsutil behavior set disabledeletenotify 0
echo [>] SSD TRIM เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:cleanup_system
echo [>] กำลังล้างไฟล์ขยะใน system files...
if not exist "%USERPROFILE%\AppData\Local\Microsoft\CleanMgr\StateMgr\CustomState_1.ini" (
    echo [>] Disk Cleanup settings ไม่พบ. กำลังตั้งค่าเริ่มต้น...
    cleanmgr /sageset:1
    echo [!] กรุณาเลือก items ที่ต้องการล้างและคลิก OK.
    pause
)
echo [>] กำลัง Run Disk Cleanup...
cleanmgr /sagerun:1
echo [>] System file cleanup เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:checkRepair
:checkRepairMenu
cls
echo.
echo  ╔══════════════ Check & Repair System Files ══════════════╗
echo  ║                                                            ║
echo  ║  [1] Run SFC                 [3] Check Disk Health          [5] กลับสู่เมนูหลัก ║
echo  ║  [2] Run DISM                [4] Verify System Files                         ║
echo  ║                                                            ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p repair_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%repair_choice%"=="1" ( call :runSFC ) else
if "%repair_choice%"=="2" ( call :runDISM ) else
if "%repair_choice%"=="3" ( call :checkDiskHealth ) else
if "%repair_choice%"=="4" ( call :verifySFCFiles ) else
if "%repair_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto checkRepairMenu
)
goto checkRepairMenu

:runSFC
echo [>] กำลัง Run System File Checker...
sfc /scannow
echo [>] SFC scan เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:runDISM
echo [>] กำลัง Run DISM...
DISM /Online /Cleanup-Image /RestoreHealth
echo [>] DISM repair เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:checkDiskHealth
echo [>] กำลังตรวจสอบ disk health...
wmic diskdrive get status
echo [>] Disk health check เสร็จสมบูรณ์.
echo.
pause
goto mainMenu

:verifySFCFiles
echo [>] กำลัง Verify system files (sfcdetails.txt บน Desktop)...
Findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log >"%userprofile%\Desktop\sfcdetails.txt"
echo [>] Verification เสร็จสมบูรณ์. ผลลัพธ์อยู่ใน sfcdetails.txt บน Desktop.
echo.
pause
goto mainMenu

:windowsActivate
:windowsActivateMenu
cls
echo.
echo  ╔══════════ Windows Activation (KMS - **RISKY!**) ══════════╗
echo  ║                                                                 ║
echo  ║ **คำเตือนความเสี่ยงสูงด้านความปลอดภัยและกฎหมาย:** KMS Activators  ║
echo  ║ เป็นแหล่งที่ไม่น่าเชื่อถือ. การใช้งาน **ไม่แนะนำอย่างยิ่ง**          ║
echo  ║ เนื่องจากภัยคุกคามด้านความปลอดภัยและการละเมิดลิขสิทธิ์ซอฟต์แวร์.   ║
echo  ║                                                                 ║
echo  ║ **โปรดดำเนินการด้วยความเสี่ยงของคุณเอง!** โดยการดำเนินการต่อ,      ║
echo  ║ คุณรับทราบและยอมรับความเสี่ยงที่อาจเกิดขึ้นทั้งหมด.              ║
echo  ║                                                                 ║
echo  ║  [1] Check Activation Status         [4] Input Product Key         [6] กลับสู่เมนูหลัก ║
echo  ║  [2] Activate using KMS (**HIGH RISK!**) [5] Remove Product Key                    ║
echo  ║  [3] Activate Digital License                                    ║
echo  ║                                                                 ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p activate_choice=  กรุณาเลือกตัวเลือก (1-6):
echo.

if "%activate_choice%"=="1" ( call :checkActivationStatus ) else
if "%activate_choice%"=="2" ( call :kmsActivateWarn ) else
if "%activate_choice%"=="3" ( call :digitalActivate ) else
if "%activate_choice%"=="4" ( call :manualProductKey ) else
if "%activate_choice%"=="5" ( call :removeProductKey ) else
if "%activate_choice%"=="6" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto windowsActivateMenu
)
goto windowsActivateMenu

:checkActivationStatus
echo [>] กำลังตรวจสอบ activation status...
slmgr /xpr
echo.
pause
goto mainMenu

:kmsActivateWarn
cls
echo.
echo  ╔══════════ KMS Activation - **CONFIRM RISK!** ══════════╗
echo  ║                                                          ║
echo  ║ **คุณกำลังจะใช้ KMS ACTIVATION - มีความเสี่ยงสูง!**         ║
echo  ║ **โปรดยืนยันว่าคุณเข้าใจและยอมรับความเสี่ยงด้านความปลอดภัย   ║
echo  ║ และกฎหมาย (Y/N):**                                     ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════════╝
echo.
set /p confirm_kms_risk=  ยืนยันการดำเนินการต่อ (Y/N):
if /i "%confirm_kms_risk%"=="Y" ( call :kmsActivate ) else (
    echo [>] KMS Activation ถูกยกเลิก.
    echo.
    pause
    goto windowsActivateMenu
)
goto windowsActivateMenu

:kmsActivate
echo [>] กำลังพยายาม KMS activation (**HIGH RISK!**)...
net session >nul 2>&1 || (
    echo [!] **ข้อผิดพลาด:** จำเป็นต้องมีสิทธิ์ผู้ดูแลระบบ.
    pause
    exit /b 1
)
powershell -command "irm https://get.activated.win | iex"
echo.
pause
goto mainMenu

:digitalActivate
echo [>] กำลังพยายาม digital license activation...
slmgr /ato
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** Digital license activation ล้มเหลว.
) else (
    echo [>] Digital license activation ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ.
)
echo.
pause
goto mainMenu

:manualProductKey
set /p product_key=  กรุณาป้อน product key 25 ตัวอักษร (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX):
echo [>] กำลังติดตั้ง product key...
slmgr /ipk %product_key%
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** Key install ล้มเหลว. Product key ไม่ถูกต้อง?
) else (
    echo [>] Key ติดตั้งแล้ว. กำลังพยายาม activation...
    slmgr /ato
    if %errorlevel% neq 0 (
        echo [!] **ข้อผิดพลาด:** Activation ล้มเหลว. กรุณาตรวจสอบ key.
    ) else (
        echo [>] Activation ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ.
    )
)
echo.
pause
goto mainMenu

:removeProductKey
echo [>] กำลังลบ product key...
slmgr /upk
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** Key removal ล้มเหลว. สิทธิ์?
) else (
    echo [>] Product key ถูกลบแล้ว.
)
echo.
pause
goto mainMenu

:managePower
:managePowerMenu
cls
echo.
echo  ╔══════════════════════ Power Settings Management ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] List Power Plans             [4] Delete Power Plan (**Caution!**)       [7] Adjust Display/Sleep Timeouts ║
echo  ║  [2] Set Power Plan              [5] Adjust Sleep Settings                 [8] Configure Lid Close Action     ║
echo  ║  [3] Create Power Plan             [6] Configure Hibernation                 [9] Configure Power Button Action║
echo  ║                                                            [10] กลับสู่เมนูหลัก                ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p power_choice=  กรุณาเลือกตัวเลือก (1-10):
echo.

if "%power_choice%"=="1" ( call :listPowerPlans ) else
if "%power_choice%"=="2" ( call :setPowerPlanMenu ) else
if "%power_choice%"=="3" ( call :createPowerPlanMenu ) else
if "%power_choice%"=="4" ( call :deletePowerPlanMenu ) else
if "%power_choice%"=="5" ( call :adjustSleepSettings ) else
if "%power_choice%"=="6" ( call :configureHibernationMenu ) else
if "%power_choice%"=="7" ( call :adjustTimeoutsMenu ) else
if "%power_choice%"=="8" ( call :lidCloseActionMenu ) else
if "%power_choice%"=="9" ( call :powerButtonActionMenu ) else
if "%power_choice%"=="10" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto managePowerMenu
)
goto managePowerMenu

:listPowerPlans
echo [>] กำลัง List power plans...
powercfg /list
echo.
pause
goto mainMenu

:setPowerPlanMenu
echo [>] Available power plans:
powercfg /list
set /p plan_guid=  กรุณาป้อน plan GUID ที่ต้องการตั้งค่า:
call :setPowerPlan "%plan_guid%"
goto managePowerMenu

:setPowerPlan
powercfg /setactive %~1
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการตั้งค่า plan. กรุณาตรวจสอบ GUID.
) else (
    echo [>] Power plan ถูกตั้งค่าแล้ว.
)
echo.
pause
goto managePowerMenu

:createPowerPlanMenu
set /p plan_name=  กรุณาป้อนชื่อ power plan ใหม่:
call :createPowerPlan "%plan_name%"
goto managePowerMenu

:createPowerPlan
powercfg /duplicatescheme scheme_balanced
if %errorlevel% equ 0 (
    powercfg /changename %~1
    echo [>] Power plan ถูกสร้างแล้ว.
) else (
    echo [!] **ข้อผิดพลาด:** Plan creation ล้มเหลว.
)
echo.
pause
goto managePowerMenu

:deletePowerPlanMenu
echo [>] Available power plans:
powercfg /list
set /p del_guid=  กรุณาป้อน plan GUID ที่ต้องการลบ (**Caution!**):
call :deletePowerPlan "%del_guid%"
goto managePowerMenu

:deletePowerPlan
echo.
echo [!] **คำเตือน:** การลบ power plan อาจลบ active plan.
set /p confirm_delete_plan=  คุณต้องการดำเนินการต่อหรือไม่? (Y/N):
if /i "%confirm_delete_plan%"=="Y" (
    powercfg /delete %~1
    if %errorlevel% equ 0 (
        echo [>] Power plan ถูกลบแล้ว.
    ) else (
        echo [!] **ข้อผิดพลาด:** Plan deletion ล้มเหลว. กรุณาตรวจสอบ GUID.
    )
    echo.
    pause
) else (
    echo [>] Plan deletion ถูกยกเลิก.
    echo.
    pause
)
goto managePowerMenu

:adjustSleepSettings
set /p sleep_time=  Minutes before sleep (0=never):
powercfg /change standby-timeout-ac %sleep_time%
powercfg /change standby-timeout-dc %sleep_time%
echo [>] Sleep settings ถูกปรับแต่งแล้ว.
echo.
pause
goto managePowerMenu

:configureHibernationMenu
:configureHibernationSubMenu
cls
echo.
echo  ╔══════════════ Configure Hibernation ══════════════╗
echo  ║                                                      ║
echo  ║  [1] Enable Hibernation      [2] Disable Hibernation  [3] กลับสู่เมนู Power ║
echo  ║                                                      ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p hib_choice=  กรุณาเลือกตัวเลือก (1-3):
echo.

if "%hib_choice%"=="1" ( call :enableHibernation ) else
if "%hib_choice%"=="2" ( call :disableHibernation ) else
if "%hib_choice%"=="3" ( goto managePowerMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto configureHibernationSubMenu
)
goto configureHibernationSubMenu

:enableHibernation
powercfg /hibernate on
echo [>] Hibernation เปิดใช้งานแล้ว.
echo.
pause
goto configureHibernationMenu

:disableHibernation
powercfg /hibernate off
echo [>] Hibernation ปิดใช้งานแล้ว.
echo.
pause
goto configureHibernationMenu

:adjustTimeoutsMenu
set /p display_ac=  Minutes to turn off display (AC):
set /p display_dc=  Minutes to turn off display (Battery):
set /p sleep_ac=    Minutes before sleep (AC):
set /p sleep_dc=    Minutes before sleep (Battery):
call :adjustTimeouts "%display_ac%" "%display_dc%" "%sleep_ac%" "%sleep_dc%"
goto managePowerMenu

:adjustTimeouts
powercfg /change monitor-timeout-ac %~1
powercfg /change monitor-timeout-dc %~2
powercfg /change standby-timeout-ac %~3%
powercfg /change standby-timeout-dc %~4%
echo [>] Display/sleep timeouts ถูกปรับแต่งแล้ว.
echo.
pause
goto managePowerMenu

:lidCloseActionMenu & call :powerActionMenu "lid" "Lid Close" & goto managePowerMenu
:powerButtonActionMenu & call :powerActionMenu "pbutton" "Power Button" & goto managePowerMenu

:powerActionMenu
:powerActionSubMenu_%~1
cls
echo.
echo  ╔══════════ Configure %~2 Action ══════════╗
echo  ║                                              ║
echo  ║  [1] Do Nothing  [2] Sleep  [3] Hibernate  [4] Shut Down  [5] กลับสู่เมนู Power ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p action_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%action_choice%"=="1" ( set action=0 ) else
if "%action_choice%"=="2" ( set action=1 ) else
if "%action_choice%"=="3" ( set action=2 ) else
if "%action_choice%"=="4" ( set action=3 ) else
if "%action_choice%"=="5" ( goto managePowerMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto powerActionSubMenu_%~1
)
if defined action ( call :setPowerAction %~1action% %action% & pause )
goto powerActionMenu

:setPowerAction
powercfg /setacvalueindex scheme_current sub_buttons %~1 %~2
powercfg /setdcvalueindex scheme_current sub_buttons %~1 %~2
powercfg /setactive scheme_current
echo [>] %~1 action ถูกตั้งค่าแล้ว.
echo.
goto powerActionMenu

:enableDarkMode
echo [>] กำลังเปิดใช้งาน Dark Mode...
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" "REG_DWORD" "0"
call :modifyRegistry "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" "REG_DWORD" "0"
echo [>] Dark Mode เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:managePartitions
:managePartitionsMenu
cls
echo.
echo  ╔══════ Partition Management (**DATA LOSS RISK!**) ══════╗
echo  ║                                                          ║
echo  ║ **คำเตือน:** การจัดการ partition อาจทำให้ **ข้อมูลสูญหายถาวร**.   ║
echo  ║ กรุณาสำรองข้อมูลสำคัญทั้งหมด!                             ║
echo  ║                                                          ║
echo  ║  [1] List Partitions        [3] Delete Partition (**DATA LOSS!**)  [5] กลับสู่เมนูหลัก ║
echo  ║  [2] Create Partition (**DATA LOSS RISK!**) [4] Format Partition (**DATA LOSS!**)    ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p part_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%part_choice%"=="1" ( call :listPartitions ) else
if "%part_choice%"=="2" ( call :createPartitionMenu ) else
if "%part_choice%"=="3" ( call :deletePartitionMenu ) else
if "%part_choice%"=="4" ( call :formatPartitionMenu ) else
if "%part_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto managePartitionsMenu
)
goto managePartitionsMenu

:listPartitions
echo [>] กำลัง List Partitions...
echo list disk > list_disk.txt
echo list volume >> list_disk.txt
diskpart /s list_disk.txt
del list_disk.txt
echo.
pause
goto managePartitionsMenu

:createPartitionMenu
echo [!] **Data Loss Risk! กรุณาสำรองข้อมูล!**
set /p disk_num=  กรุณาป้อน disk number:
set /p part_size=  กรุณาป้อน partition size (MB):
call :createPartition "%disk_num%" "%part_size%"
goto managePartitionsMenu

:createPartition
echo [>] กำลังสร้าง Partition (**Data Loss Risk!**)...
(
    echo select disk %~1
    echo create partition primary size=%~2
) > create_part.txt
diskpart /s create_part.txt
del create_part.txt
echo [>] Partition ถูกสร้างแล้ว. **กรุณาตรวจสอบ Disk Management.**
echo.
pause
goto managePartitionsMenu

:deletePartitionMenu
echo [!] **Permanent Data Loss Warning! กรุณาสำรองข้อมูล!**
set /p disk_num=  กรุณาป้อน disk number:
set /p part_num=  กรุณาป้อน partition number:
call :deletePartition "%disk_num%" "%part_num%"
goto managePartitionsMenu

:deletePartition
echo [>] กำลังลบ Partition (**Permanent Data Loss!**)...
echo [!] **คำเตือน: ข้อมูลจะสูญหายอย่างถาวร! คุณต้องการดำเนินการต่อหรือไม่? (Y/N)**
set /p confirm_delete_part=  ยืนยันการลบ partition (Y/N):
if /i "%confirm_delete_part%"=="Y" (
    (
        echo select disk %~1
        echo select partition %~2
        echo delete partition override
    ) > delete_part.txt
    diskpart /s delete_part.txt
    del delete_part.txt
    echo [>] Partition ถูกลบแล้ว. **ข้อมูลสูญหายอย่างถาวร! กรุณาตรวจสอบ Disk Management.**
    echo.
    pause
) else (
    echo [>] Partition deletion ถูกยกเลิก.
    echo.
    pause
)
goto managePartitionsMenu

:formatPartitionMenu
echo [!] **Data Loss Warning! กรุณาสำรองข้อมูล!**
set /p disk_num=  กรุณาป้อน disk number:
set /p part_num=  กรุณาป้อน partition number:
set /p fs=       กรุณาป้อน file system (NTFS/FAT32):
call :formatPartition "%disk_num%" "%part_num%" "%fs%"
goto managePartitionsMenu

:formatPartition
echo [>] กำลัง Format Partition (**Data Loss!**)...
echo [!] **คำเตือน: ข้อมูลจะสูญหาย! คุณต้องการดำเนินการต่อหรือไม่? (Y/N)**
set /p confirm_format_part=  ยืนยันการ format partition (Y/N):
if /i "%confirm_format_part%"=="Y" (
    (
        echo select disk %~1
        echo select partition %~2
        echo format fs=%~3% quick
    ) > format_part.txt
    diskpart /s format_part.txt
    del format_part.txt
    echo [>] Partition ถูก format แล้ว. **ข้อมูลสูญหาย! กรุณาตรวจสอบ Disk Management.**
    echo.
    pause
) else (
    echo [>] Partition formatting ถูกยกเลิก.
    echo.
    pause
)
goto managePartitionsMenu

:manageStartup
echo [>] กำลังจัดการ startup programs...
start msconfig
echo [>] กรุณาใช้ System Configuration utility เพื่อจัดการ startup programs.
echo.
pause
goto mainMenu

:backupRestore
:backupRestoreMenu
cls
echo.
echo  ╔══════════ Backup & Restore Settings ══════════╗
echo  ║                                              ║
echo  ║  [1] Create Restore Point    [2] Restore from Restore Point  [3] กลับสู่เมนูหลัก ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p backup_choice=  กรุณาเลือกตัวเลือก (1-3):
echo.

if "%backup_choice%"=="1" ( call :createRestorePoint ) else
if "%backup_choice%"=="2" ( call :restoreFromPoint ) else
if "%backup_choice%"=="3" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto backupRestoreMenu
)
goto backupRestoreMenu

:createRestorePoint
echo [>] กำลังสร้าง system restore point...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Manual Restore Point", 100, 7
echo [>] System restore point ถูกสร้างแล้ว.
echo.
pause
goto mainMenu

:restoreFromPoint
echo [>] กำลัง Restore from restore point...
rstrui.exe
echo [>] กรุณาทำตามคำแนะนำบนหน้าจอเพื่อ restore system.
echo.
pause
goto mainMenu

:systemInfo
echo [>] กำลังแสดง system information...
systeminfo
echo.
pause
goto mainMenu

:optimizePrivacy
echo [>] กำลังปรับแต่ง privacy settings...
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0" & echo [>] - Telemetry ถูกปิดใช้งานแล้ว.
call :modifyRegistry "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" "REG_DWORD" "1" & echo [>] - Advertising ID ถูกปิดใช้งานแล้ว.
call :modifyRegistry "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" "REG_DWORD" "0" & echo [>] - เพิ่มเติม Telemetry ถูกปิดใช้งานแล้ว.
echo [>] Privacy settings ถูกปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:manageServices
:manageServicesMenu
cls
echo.
echo  ╔══════════ Windows Services Management ══════════╗
echo  ║                                                ║
echo  ║  [1] List All Services         [4] Start Service         [7] Change Startup Type  [10] กลับสู่เมนูหลัก ║
echo  ║  [2] List Running Services     [5] Stop Service          [8] Search for Service                 ║
echo  ║  [3] List Stopped Services     [6] Restart Service       [9] View Service Details               ║
echo  ║                                                ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p service_choice=  กรุณาเลือกตัวเลือก (1-10):
echo.

if "%service_choice%"=="1" ( call :listAllServices ) else
if "%service_choice%"=="2" ( call :listRunningServices ) else
if "%service_choice%"=="3" ( call :listStoppedServices ) else
if "%service_choice%"=="4" ( call :startServiceMenu ) else
if "%service_choice%"=="5" ( call :stopServiceMenu ) else
if "%service_choice%"=="6" ( call :restartServiceMenu ) else
if "%service_choice%"=="7" ( call :changeStartupTypeMenu ) else
if "%service_choice%"=="8" ( call :searchServiceMenu ) else
if "%service_choice%"=="9" ( call :viewServiceDetailsMenu ) else
if "%service_choice%"=="10" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto manageServicesMenu
)
goto manageServicesMenu

:listAllServices
echo [>] กำลัง List all services...
sc query type= service state= all
echo.
pause
goto manageServicesMenu

:listRunningServices
echo [>] กำลัง List running services...
sc query type= service state= running
echo.
pause
goto manageServicesMenu

:listStoppedServices
echo [>] กำลัง List stopped services...
sc query type= service state= stopped
echo.
pause
goto manageServicesMenu

:startServiceMenu
set /p service_name=  กรุณาป้อน service name ที่ต้องการ start:
call :startService "%service_name%"
goto manageServicesMenu

:startService
sc start "%~1"
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการ start service. กรุณาตรวจสอบ name/permissions.
) else (
    echo [>] Service start ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ.
)
echo.
pause
goto manageServicesMenu

:stopServiceMenu
set /p service_name=  กรุณาป้อน service name ที่ต้องการ stop:
call :stopService "%service_name%"
goto manageServicesMenu

:stopService
sc stop "%~1"
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการ stop service. กรุณาตรวจสอบ name/permissions.
) else (
    echo [>] Service stop ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ.
)
echo.
pause
goto manageServicesMenu

:restartServiceMenu
set /p service_name=  กรุณาป้อน service name ที่ต้องการ restart:
call :restartService "%service_name%"
goto manageServicesMenu

:restartService
sc stop "%~1"
timeout /t 2 >nul
sc start "%~1"
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการ restart service. กรุณาตรวจสอบ name/permissions.
) else (
    echo [>] Service restart ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ.
)
echo.
pause
goto manageServicesMenu

:changeStartupTypeMenu
set /p service_name=  กรุณาป้อน service name:
:changeStartupTypeSubMenu
cls
echo.
echo  ╔══════ Change Service Startup Type ══════╗
echo  ║                                        ║
echo  ║  [1] Automatic        [3] Manual        ║
echo  ║  [2] Automatic (Delayed) [4] Disabled     ║
echo  ║                                        ║
echo  ╚══════════════════════════════════════╝
echo.
set /p startup_choice=  กรุณาเลือกตัวเลือก (1-4):
echo.

if "%startup_choice%"=="1" ( set start_type=auto ) else
if "%startup_choice%"=="2" ( set start_type=delayed-auto ) else
if "%startup_choice%"=="3" ( set start_type=demand ) else
if "%startup_choice%"=="4" ( set start_type=disabled ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto changeStartupTypeSubMenu
)
if defined start_type ( call :changeServiceStartup "%service_name%" "%start_type%" )
goto changeStartupTypeMenu

:changeServiceStartup
sc config "%~1" start= %~2
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ล้มเหลวในการ change startup type. กรุณาตรวจสอบ name/permissions.
) else (
    echo [>] Startup type ถูกเปลี่ยนเรียบร้อยแล้ว.
)
echo.
pause
goto changeStartupTypeMenu

:searchServiceMenu
set /p search_term=  กรุณาป้อน service name search term:
call :searchService "%search_term%"
goto manageServicesMenu

:searchService
sc query state= all | findstr /i "%~1"
echo.
pause
goto manageServicesMenu

:viewServiceDetailsMenu
set /p service_name=  กรุณาป้อน service name สำหรับรายละเอียด:
call :viewServiceDetails "%service_name%"
goto manageServicesMenu

:viewServiceDetails
sc qc "%~1"
echo.
echo [>] สถานะปัจจุบัน:
sc query "%~1"
echo.
pause
goto manageServicesMenu

:networkOptimization
:networkOptimizationMenu
cls
echo.
echo  ╔══════════════════════ Network Optimization ══════════════════════╗
echo  ║                                                                              ║
echo  ║  [1] Optimize TCP Settings         [5] Disable IPv6 (**Caution**)           [8] Reset All Network Settings (**Restart Req.**) ║
echo  ║  [2] Reset Winsock (**Restart Req.**) [6] Enable QoS Packet Scheduler       [9] กลับสู่เมนูหลัก                            ║
echo  ║  [3] Clear DNS Cache               [7] Set Static DNS Servers                                   ║
echo  ║  [4] Optimize Adapter (**Advanced**)                                                          ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
set /p net_choice=  กรุณาเลือกตัวเลือก (1-9):
echo.

if "%net_choice%"=="1" ( call :optimizeTCPSettings ) else
if "%net_choice%"=="2" ( call :resetWinsock ) else
if "%net_choice%"=="3" ( call :clearDNSCache ) else
if "%net_choice%"=="4" ( call :optimizeAdapterSettings ) else
if "%net_choice%"=="5" ( call :disableIPv6Menu ) else
if "%net_choice%"=="6" ( call :enableQoSPacketScheduler ) else
if "%net_choice%"=="7" ( call :setStaticDNSMenu ) else
if "%net_choice%"=="8" ( call :resetNetworkSettings ) else
if "%net_choice%"=="9" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto networkOptimizationMenu
)
goto networkOptimizationMenu

:optimizeTCPSettings
echo [>] กำลังปรับแต่ง TCP settings...
netsh int tcp set global autotuninglevel=normal & netsh int tcp set global congestionprovider=ctcp & netsh int tcp set global ecncapability=enabled & netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled & netsh int tcp set global fastopen=enabled & netsh int tcp set global timestamps=disabled & netsh int tcp set global initialRto=2000 & netsh int tcp set global nonsackrttresiliency=disabled
echo [>] TCP settings ถูกปรับแต่งแล้ว.
echo.
pause
goto mainMenu

:resetWinsock
echo [>] กำลัง Reset Winsock...
netsh winsock reset
echo [>] Winsock reset แล้ว. **กรุณา Restart computer!**
echo.
pause
goto mainMenu

:clearDNSCache
echo [>] กำลังล้าง DNS cache...
ipconfig /flushdns
echo [>] DNS cache ถูกล้างแล้ว.
echo.
pause
goto mainMenu

:optimizeAdapterSettings
echo [>] กำลังปรับแต่ง adapter settings (**ขั้นสูง - โปรดระวัง**)...
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh int ip set interface name="%interface_name%" dadtransmits=0 store=persistent
    netsh int ip set interface name="%interface_name%" routerdiscovery=disabled store=persistent
    echo [>] กำลัง Disable TCP Security features (**อาจลดความปลอดภัย**)...
    netsh int tcp set security mpp=disabled & netsh int tcp set security profiles=disabled
    powershell -Command "Get-NetAdapter -Name '%interface_name%' | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0; Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3; Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0"
    echo [>] Adapter settings ถูกปรับแต่งแล้ว. **กรุณาตรวจสอบ connection หลัง tuning.**
) else (
    echo [!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Adapter optimization ล้มเหลว.
)
echo.
pause
goto mainMenu

:disableIPv6Menu
echo.
echo [!] **คำเตือน:** การปิดใช้งาน IPv6 อาจทำให้เกิดปัญหา network.
set /p confirm_ipv6_disable=  คุณต้องการดำเนินการต่อหรือไม่? (Y/N):
if /i "%confirm_ipv6_disable%"=="Y" ( call :disableIPv6 ) else (
    echo [>] IPv6 disabling ถูกยกเลิก.
    echo.
    pause
    goto networkOptimizationMenu
)
goto networkOptimizationMenu

:disableIPv6
echo [>] กำลังปิดใช้งาน IPv6...
netsh interface ipv6 set global randomizeidentifiers=disabled
netsh interface ipv6 set privacy state=disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
echo [>] IPv6 ปิดใช้งานแล้ว. **กรุณา Restart computer! ตรวจสอบ connection.**
echo.
pause
goto mainMenu

:enableQoSPacketScheduler
echo [>] กำลังเปิดใช้งาน QoS Packet Scheduler...
netsh int tcp set global packetcoalescinginbound=disabled
sc config "Qwave" start= auto
net start Qwave
echo [>] QoS Packet Scheduler เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:setStaticDNSMenu
set /p primary_dns=   กรุณาป้อน primary DNS (เช่น, 8.8.8.8):
set /p secondary_dns= กรุณาป้อน secondary DNS (เช่น, 8.8.4.4):
call :setStaticDNS "%primary_dns%" "%secondary_dns%"
goto networkOptimizationMenu

:setStaticDNS
for /f "tokens=3*" %%a in ('netsh int show interface ^| findstr /i "connected"') do set "interface_name=%%b"
if defined interface_name (
    netsh interface ip set dns name="%interface_name%" source=static address=%~1 register=primary
    netsh interface ip add dns name="%interface_name%" address=%~2 index=2
    echo [>] Static DNS ถูกตั้งค่าแล้ว.
) else (
    echo [!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Static DNS ล้มเหลว.
)
echo.
pause
goto mainMenu

:resetNetworkSettings
echo [>] กำลัง Reset all network settings (**Restart Required**)...
netsh winsock reset & netsh int ip reset & netsh advfirewall reset & ipconfig /release & ipconfig /renew & ipconfig /flushdns
echo [>] All network settings reset แล้ว. **กรุณา Restart computer!**
echo.
pause
goto mainMenu

:disableTransparency
echo [>] กำลังปิดใช้งาน Transparency Effects...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" "REG_DWORD" "0"
echo [>] Transparency Effects ปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:disableAnimationsExtra
echo [>] กำลังปิดใช้งาน Extra Animation Effects...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Animations" "REG_DWORD" "0"
call :modifyRegistry "HKCU\Control Panel\Desktop" "DragFullWindows" "REG_SZ" "1"
echo [>] Extra Animations ปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:optimizeStorageSenseMenu
:optimizeStorageSenseSubMenu
cls
echo.
echo  ╔══════════ Storage Sense Optimization ══════════╗
echo  ║                                              ║
echo  ║  [1] Enable Storage Sense      [3] Configure Recycle Bin Cleanup  [5] กลับสู่เมนูหลัก ║
echo  ║  [2] Set Cleanup Frequency     [4] Configure Temp Files Cleanup                  ║
echo  ║                                              ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p ss_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%ss_choice%"=="1" ( call :enableStorageSense ) else
if "%ss_choice%"=="2" ( call :configCleanupFrequencyMenu ) else
if "%ss_choice%"=="3" ( call :configRecycleBinCleanup ) else
if "%ss_choice%"=="4" ( call :configTempFilesCleanup ) else
if "%ss_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizeStorageSenseSubMenu
)
goto optimizeStorageSenseSubMenu

:enableStorageSense
echo [>] กำลังเปิดใช้งาน Storage Sense...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "Enabled" "REG_DWORD" "1"
echo [>] Storage Sense เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:configCleanupFrequencyMenu
:configCleanupFrequencySubMenu
cls
echo.
echo  ╔══════════ Cleanup Frequency ══════════╗
echo  ║                                       ║
echo  ║  [1] Every Day    [3] Every Month      ║
echo  ║  [2] Every Week   [4] Low Disk Space   ║
echo  ║                                       ║
echo  ╚══════════════════════════════════════╝
echo.
set /p freq_choice=  กรุณาเลือกตัวเลือก (1-4):
echo.

if "%freq_choice%"=="1" ( set freq_val=1 ) else
if "%freq_choice%"=="2" ( set freq_val=7 ) else
if "%freq_choice%"=="3" ( set freq_val=30 ) else
if "%freq_choice%"=="4" ( set freq_val=0 ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto configCleanupFrequencySubMenu
)
if defined freq_val ( call :configCleanupFrequency "%freq_val%" )
goto configCleanupFrequencyMenu

:configCleanupFrequency
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "CleanupFrequency" "REG_DWORD" "%~1"
echo [>] Cleanup frequency ถูกตั้งค่าแล้ว.
echo.
pause
goto mainMenu

:configRecycleBinCleanup
set /p rb_days=  Days for Recycle Bin cleanup (0=disable):
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "DaysToRunRecycleBinCleanup" "REG_DWORD" "%rb_days%"
echo [>] Recycle Bin cleanup ถูกตั้งค่าแล้ว.
echo.
pause
goto mainMenu

:configTempFilesCleanup
set /p temp_days=  Days for Temp Files cleanup (0=disable):
call :modifyRegistry "HKCU\Software\Microsoft\Windows\StorageSense" "DaysToRunTempFilesCleanup" "REG_DWORD" "%temp_days%"
echo [>] Temp files cleanup ถูกตั้งค่าแล้ว.
echo.
pause
goto mainMenu

:disableStartupSound
echo [>] กำลังปิดใช้งาน Startup Sound...
call :modifyRegistry "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" ".Default" "REG_SZ" "%SystemRoot%\media\Windows Logon.wav"
call :modifyRegistry "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" "ExcludeFromCPL" "REG_DWORD" "1"
echo [>] Startup Sound ปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:optimizePagingFileMenu
:optimizePagingFileSubMenu
cls
echo.
echo  ╔══════ Paging File (Virtual Memory) Optimization (**Advanced**) ══════╗
echo  ║                                                                      ║
echo  ║ **คำเตือนขั้นสูง:** การตั้งค่า Paging File ที่ไม่ถูกต้องอาจเป็นอันตรายต่อระบบ.   ║
echo  ║ โปรดดำเนินการด้วยความระมัดระวังและศึกษาข้อมูล!                        ║
echo  ║                                                                      ║
echo  ║  [1] System Managed Size (**Recommended**) [3] Disable Paging File (**NOT Recommended!**) [5] กลับสู่เมนูหลัก ║
echo  ║  [2] Custom Size                               [4] กลับสู่เมนู CPU                       ║
echo  ║                                                                      ║
echo  ╚══════════════════════════════════════════════════════════╝
echo.
set /p pf_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%pf_choice%"=="1" ( call :systemManagedPagingFile ) else
if "%pf_choice%"=="2" ( call :customSizePagingFileMenu ) else
if "%pf_choice%"=="3" ( call :disablePagingFileWarn ) else
if "%pf_choice%"=="4" ( goto optimizeCPUMenu ) else
if "%pf_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizePagingFileSubMenu
)
goto optimizePagingFileSubMenu

:systemManagedPagingFile
echo [>] กำลังตั้งค่า Paging File เป็น System Managed Size (**Recommended**)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=True
echo [>] Paging File ถูกตั้งค่าเป็น System Managed.
echo.
pause
goto mainMenu

:customSizePagingFileMenu
set /p initial_size=  กรุณาป้อน initial size (MB):
set /p max_size=      กรุณาป้อน maximum size (MB):
call :customSizePagingFile "%initial_size%" "%max_size%"
goto optimizePagingFileMenu

:customSizePagingFile
wmic pagefileset where name="C:\\pagefile.sys" set InitialSize=%~1,MaximumSize=%~2
echo [>] Paging File ถูกตั้งค่าเป็น Custom Size (Initial: %~1MB, Max: %~2MB).
echo.
pause
goto mainMenu

:disablePagingFileWarn
cls
echo.
echo  ╔══════ Disable Paging File - **CONFIRM RISK!** ══════╗
echo  ║                                                          ║
echo  ║ **คุณกำลังจะ DISABLE PAGING FILE - ไม่แนะนำ!**             ║
echo  ║ **โปรดยืนยันว่าคุณเข้าใจความเสี่ยงด้าน SYSTEM STABILITY (Y/N):** ║
echo  ║                                                          ║
echo  ╚══════════════════════════════════════════════╝
echo.
set /p confirm_pf_disable=  ยืนยันการดำเนินการต่อ (Y/N):
if /i "%confirm_pf_disable%"=="Y" ( call :disablePagingFile ) else (
    echo [>] Paging File disabling ถูกยกเลิก.
    echo.
    pause
    goto optimizePagingFileMenu
)
goto optimizePagingFileMenu

:disablePagingFile
echo [>] กำลังปิดใช้งาน Paging File (**NOT Recommended!**)...
wmic computersystem where name="%computername%" set AutomaticManagedPagefile=False
wmic pagefileset where name="C:\\pagefile.sys" delete
echo [>] Paging File ปิดใช้งานแล้ว. **System instability risk! Restart & test system.**
echo.
pause
goto mainMenu

:disableWidgets
echo [>] กำลังปิดใช้งาน Widget Features (Windows 11)...
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarDa" "REG_DWORD" "0"
call :modifyRegistry "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarMn" "REG_DWORD" "0"
echo [>] Widget Features ปิดใช้งานแล้ว. (**Restart Explorer or PC recommended.**)
echo.
pause
goto mainMenu

:optimizeGameModeMenu
:optimizeGameModeSubMenu
cls
echo.
echo  ╔══════════ Game Mode Optimization ══════════╗
echo  ║                                             ║
echo  ║  [1] Enable Game Mode         [3] Disable Game DVR & Bar (Option 3) [5] กลับสู่เมนูหลัก ║
echo  ║  [2] Disable GameBar Service   [4] กลับสู่เมนู CPU                       ║
echo  ║                                             ║
echo  ╚══════════════════════════════════════════╝
echo.
set /p game_choice=  กรุณาเลือกตัวเลือก (1-5):
echo.

if "%game_choice%"=="1" ( call :enableGameMode ) else
if "%game_choice%"=="2" ( call :disableGameBarService ) else
if "%game_choice%"=="3" ( call :disableGameDVRBar & pause & goto mainMenu ) else
if "%game_choice%"=="4" ( goto optimizeCPUMenu ) else
if "%game_choice%"=="5" ( goto mainMenu ) else (
    echo [!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง.
    pause
    goto optimizeGameModeSubMenu
)
goto optimizeGameModeSubMenu

:enableGameMode
echo [>] กำลังเปิดใช้งาน Game Mode...
call :modifyRegistry "HKCU\Software\Microsoft\GameBar" "AllowAutoGameMode" "REG_DWORD" "1"
echo [>] Game Mode เปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:disableGameBarService
echo [>] กำลังปิดใช้งาน Game Bar Presence Writer Service...
sc config "GameBarSvc" start= disabled
sc stop "GameBarSvc" 2>nul
echo [>] Game Bar Presence Writer Service ปิดใช้งานแล้ว.
echo.
pause
goto mainMenu

:showHelpMenu
cls
echo.
echo  ╔══════════════════════════ Help Menu ══════════════════════════╗
echo  ║                                                                              ║
echo  ║  Windows Optimization Script v3.5 - Enhanced Edition - Help                   ║
echo  ║                                                                              ║
echo  ║  คำแนะนำการใช้งาน:                                                            ║
echo  ║  - ป้อนหมายเลขตัวเลือก (1-30) เพื่อเลือกเมนู.                                  ║
echo  ║  - ตัวเลือกที่มี **คำเตือน** ควรใช้ด้วยความระมัดระวัง.                           ║
echo  ║  - อ่านคำแนะนำและคำเตือนอย่างละเอียดก่อนดำเนินการ.                             ║
echo  ║  - หากพบปัญหา, กรุณาตรวจสอบสิทธิ์ผู้ดูแลระบบและ Restart เครื่อง.                ║
echo  ║                                                                              ║
echo  ║  **ข้อมูลเพิ่มเติม:**                                                          ║
echo  ║  - Script นี้ปรับปรุงประสิทธิภาพและความเร็วของ Windows.                         ║
echo  ║  - เหมาะสำหรับ Windows 11 (อาจมีปัญหาความเข้ากันได้กับ Windows รุ่นเก่า).         ║
echo  ║  - การปรับแต่งบางอย่างอาจต้อง Restart เครื่องเพื่อให้มีผล.                        ║
echo  ║                                                                              ║
echo  ║  **ติดต่อผู้พัฒนา:** [GT Singtaro]                                             ║
echo  ║  **Version:** 3.5 - Enhanced Edition                                          ║
echo  ║                                                                              ║
echo  ║  กดปุ่มใดก็ได้เพื่อกลับสู่เมนูหลัก...                                           ║
echo  ║                                                                              ║
echo  ╚══════════════════════════════════════════════════════════════════════╝
echo.
pause
goto mainMenu


:endexit
echo.
echo  ╔══════════════════════════════════════════════════════════════════╗
echo  ║         ขอบคุณที่ใช้ Windows Optimization Script! - Enhanced Edition         ║
echo  ║               Script พัฒนาโดย [GT Singtaro]                                 ║
echo  ║              Version 3.5 - Enhanced Edition - Main Menu                     ║
echo  ╚══════════════════════════════════════════════════════════════════╝
echo.
pause
exit

:: Function to modify registry with error handling (No changes needed)
:modifyRegistry
reg add %1 /v %2 /t %3 /d %4 /f 2>nul
if %errorlevel% neq 0 (
    echo [!] **ข้อผิดพลาด:** ไม่สามารถแก้ไข registry key: %1\%2
    pause
)
exit /b 0
