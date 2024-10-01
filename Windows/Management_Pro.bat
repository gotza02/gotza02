@echo off
setlocal enabledelayedexpansion

:: Set console colors (Text: Bright White, Background: Blue)
color 1F

:check_admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please run as administrator and try again.
    pause
    exit /b 1
)

:menu
cls
echo ==================================================
echo.
echo   ██╗    ██╗██╗██╗    ██╗██████╗  █████╗ ████████╗
echo   ██║    ██║██║██║    ██║██╔══██╗██╔══██╗╚══██╔══╝
echo   ██║ █╗ ██║██║██║ █╗ ██║██████╔╝███████║   ██║   
echo   ██║███╗██║██║██║███╗██║██╔══██╗██╔══██║   ██║   
echo   ╚███╔███╔╝██║╚███╔███╔╝██║  ██║██║  ██║   ██║   
echo    ╚══╝╚══╝ ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
echo.
echo ==================================================
echo [ Select an Option ]
echo ==================================================
echo.
echo [1] Optimize Display Performance
echo [2] Optimize CPU Performance
echo [3] Optimize Internet Performance
echo [4] Clear System Cache
echo [5] Check and Repair System Files
echo [6] Manage Power Settings
echo [7] Enable Dark Mode
echo [8] Activate Windows
echo [9] Exit
echo.
echo ==================================================
set /p choice=Please enter your choice (1-9): 

if "%choice%"=="1" goto optimize_display
if "%choice%"=="2" goto optimize_cpu
if "%choice%"=="3" goto optimize_internet
if "%choice%"=="4" goto clear_cache
if "%choice%"=="5" goto check_repair
if "%choice%"=="6" goto manage_power
if "%choice%"=="7" goto enable_dark_mode
if "%choice%"=="8" goto activate_windows
if "%choice%"=="9" goto endexit
echo Invalid choice. Please try again.
pause
goto menu

:optimize_display
cls
echo ==================================================
echo     Optimizing Display Performance for Windows 11...
echo ==================================================

:: ปิดการแสดงผลเอฟเฟ็กต์ที่ไม่จำเป็น เช่น การเคลื่อนไหวและการเฟด
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f
reg add "HKCU\Control Panel\Desktop" /v LowLevelHooksTimeout /t REG_SZ /d 1000 /f

:: ปิดการแสดงภาพเคลื่อนไหวใน UI
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f

:: ปิดการใช้เอฟเฟ็กต์ต่าง ๆ ใน Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f

:: ปิดการแสดง Aero Peek
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f

:: ปิดการแสดงเงาของ Listview
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f

:: ปิดเอฟเฟ็กต์การแสดง Listview แบบ Alpha
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f

:: ปรับการตั้งค่าภาพทั้งหมดให้เน้นประสิทธิภาพ
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: ปิดเอฟเฟ็กต์ใสต่าง ๆ (Transparency effects)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

echo Display performance optimized for maximum responsiveness!
pause
goto menu


:optimize_cpu
cls
echo ==================================================
echo     Optimizing CPU Performance for Windows 11...
echo ==================================================

:: เปิดใช้งานแผนพลังงานที่ให้ประสิทธิภาพสูงสุด
powercfg -setactive SCHEME_MIN

:: ปิดการปรับลดความเร็ว CPU เมื่อใช้งานพลังงานจากปลั๊ก (Disable Throttling)
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_MIN SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setactive SCHEME_MIN

:: ปิดการจอดพักแกนประมวลผล (Disable CPU Core Parking)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CsEnabled /t REG_DWORD /d 0 /f

:: ปิดเอฟเฟ็กต์การลดประสิทธิภาพ CPU จากระบบ (Disable CPU Idle Throttle)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\intelppm" /v Start /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Processor" /v Start /t REG_DWORD /d 4 /f

:: ปรับการจัดสรรการทำงานของ CPU ให้เหมาะสมที่สุด (Optimize CPU Scheduling)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f

:: ปรับการตั้งค่าเพื่อให้ใช้การเร่งประสิทธิภาพ GPU Hardware Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f

echo CPU performance optimized for maximum efficiency and responsiveness!
pause
goto menu


:optimize_internet
cls
echo ==================================================
echo     Optimizing Internet Performance for Windows 11...
echo ==================================================

:: ปรับระดับการปรับจูน TCP (TCP Auto-Tuning)
netsh int tcp set global autotuninglevel=normal

:: เปิดใช้งาน ECN (Explicit Congestion Notification) เพื่อปรับปรุงประสิทธิภาพการเชื่อมต่อ
netsh int tcp set global ecncapability=enabled

:: ปิดการตั้งค่า TCP Chimney Offload (ซึ่งล้าสมัย) เพื่อลดการหน่วง
netsh int tcp set global chimney=disabled

:: เปิดใช้งาน TCP Receive Side Scaling (RSS) เพื่อช่วยกระจายภาระการทำงานใน CPU
netsh int tcp set global rss=enabled

:: เปิดใช้งาน TCP Fast Open (ช่วยเพิ่มประสิทธิภาพการเชื่อมต่อครั้งแรก)
netsh int tcp set global fastopen=enabled

:: ล้าง Cache ของ DNS เพื่อป้องกันการเกิดปัญหาจากข้อมูลเก่า
ipconfig /flushdns

:: ปรับการตั้งค่า DNS ให้ใช้ Google DNS เพื่อความเสถียรและความเร็ว
netsh interface ip set dns "Wi-Fi" static 8.8.8.8
netsh interface ip add dns "Wi-Fi" 8.8.4.4 index=2

:: ปรับการตั้งค่าของ Network Adapter เพื่อเพิ่มประสิทธิภาพการทำงาน
for /f "tokens=3*" %%i in ('netsh int show interface ^| findstr /i "connected"') do (
    netsh int ip set interface "%%j" dadtransmits=0 store=persistent
    netsh int ip set interface "%%j" routerdiscovery=disabled store=persistent
)

:: รีเซ็ตการตั้งค่า TCP/IP Stack และ Winsock เพื่อล้างปัญหาเครือข่าย
netsh int ip reset
netsh winsock reset

echo Internet performance optimized successfully!
pause
goto menu


:clear_cache
cls
echo ==================================================
echo       Clearing System Cache for Windows 11...
echo ==================================================

:: ลบไฟล์ชั่วคราวในไดเรกทอรี Temp ของผู้ใช้
del /q /f /s %TEMP%\* 2>nul

:: ลบไฟล์ชั่วคราวใน Temp ของ Windows
del /q /f /s C:\Windows\Temp\* 2>nul

:: ล้างแคชของ Windows Update
del /q /f /s C:\Windows\SoftwareDistribution\Download\* 2>nul

:: ล้าง Recycle Bin
rd /s /q C:\$Recycle.Bin

:: ล้างการตั้งค่า Pagefile.sys (ถ้ามีการกำหนดค่า)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f

:: ล้าง DNS Cache เพื่อลดปัญหาการเชื่อมต่อ
ipconfig /flushdns

:: ล้าง Internet Explorer/Edge Cache (หากใช้งาน)
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255

echo System cache cleared successfully!
pause
goto menu


:check_repair
cls
echo ==================================================
echo     Checking and Repairing System Files...
echo ==================================================

:: ตรวจสอบความสมบูรณ์ของไฟล์ระบบด้วย SFC (System File Checker)
sfc /scannow

:: หากมีปัญหากับไฟล์ระบบ, ใช้ DISM เพื่อล้างและซ่อมแซม
DISM /Online /Cleanup-Image /CheckHealth
DISM /Online /Cleanup-Image /ScanHealth
DISM /Online /Cleanup-Image /RestoreHealth

:: ตรวจสอบสุขภาพของดิสก์
wmic diskdrive get status

echo System check and repair completed successfully!
pause
goto menu


:manage_power
cls
echo ==================================================
echo     Managing Power Settings for Windows 11...
echo ==================================================

:: แสดงแผนพลังงานที่มีทั้งหมด
powercfg /list

echo --------------------------------------------------
echo Please select a power plan:
echo [1] High Performance (สำหรับประสิทธิภาพสูงสุด)
echo [2] Balanced (สำหรับสมดุลระหว่างพลังงานและประสิทธิภาพ)
echo [3] Power Saver (สำหรับการประหยัดพลังงาน)
echo --------------------------------------------------
set /p power_choice=Enter your choice (1-3): 

if "%power_choice%"=="1" goto high_performance
if "%power_choice%"=="2" goto balanced
if "%power_choice%"=="3" goto power_saver
echo Invalid choice. Please try again.
pause
goto manage_power

:high_performance
cls
echo ==================================================
echo     Setting High Performance Power Plan...
echo ==================================================
:: ตั้งค่าแผนพลังงานสำหรับประสิทธิภาพสูงสุด
powercfg /setactive SCHEME_MIN

:: ปรับลดเวลาพักเครื่องและการปิดหน้าจอให้ช้าลงหรือไม่ใช้เลย (ปิดการประหยัดพลังงาน)
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

:: ปิด Hibernation เพื่อประสิทธิภาพ
powercfg /hibernate off

echo High Performance mode enabled!
pause
goto menu

:balanced
cls
echo ==================================================
echo     Setting Balanced Power Plan...
echo ==================================================
:: ตั้งค่าแผนพลังงานแบบ Balanced เพื่อสมดุลระหว่างประสิทธิภาพและการประหยัดพลังงาน
powercfg /setactive SCHEME_BALANCED

:: ตั้งค่าการพักเครื่องและการปิดหน้าจอสำหรับการใช้งานที่สมดุล
powercfg /change monitor-timeout-ac 10
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-ac 20
powercfg /change standby-timeout-dc 10

:: เปิด Hibernation ถ้าต้องการประหยัดพลังงาน
powercfg /hibernate on

echo Balanced Power Plan enabled!
pause
goto menu

:power_saver
cls
echo ==================================================
echo     Setting Power Saver Power Plan...
echo ==================================================
:: ตั้งค่าแผนพลังงานเพื่อประหยัดพลังงานสูงสุด
powercfg /setactive SCHEME_MAX

:: ตั้งค่าเวลาปิดหน้าจอและเวลาพักเครื่องให้เร็วที่สุด
powercfg /change monitor-timeout-ac 2
powercfg /change monitor-timeout-dc 1
powercfg /change standby-timeout-ac 5
powercfg /change standby-timeout-dc 3

:: เปิด Hibernation เพื่อประหยัดพลังงาน
powercfg /hibernate on

echo Power Saver mode enabled!
pause
goto menu

:activate_windows
cls
cd "C:\Windows\System32"


:start
ECHO WARNING: USE AT YOUR OWN RISK
ECHO I AM NOT RESPONSIBLE FOR ANY DAMAGES
set /p c=Would you like to Continue [Y/N]?
CLS
if /I "%c%" NEQ "Y" exit

ECHO.
ECHO 1. Home	
ECHO 2. Home N	
ECHO 3. Home Home Single Language	
ECHO 4. Home Country Specific	
ECHO 5. Pro	
ECHO 6. Pro N	
ECHO 7. Pro for Workstations	
ECHO 8. Pro for Workstations N	
ECHO 9. Pro Education	
ECHO 10. Pro Education N	
ECHO 11. Education	
ECHO 12. Education N	
ECHO 13. Enterprise
ECHO 14. Enterprise N	
ECHO 15. Enterprise G	
ECHO 16. Enterprise G N	
ECHO 17. Enterprise LTSC 2019	
ECHO 18. Enterprise N LTSC 2019      
ECHO 19. End

set choice=
set /p choice=Select Your Operating System to Continue.

:loop

set "productKey="

if %choice%==1 set productKey=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
if %choice%==2 set productKey=3KHY7-WNT83-DGQKR-F7HPR-844BM 
if %choice%==3 set productKey=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
if %choice%==4 set productKey=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
if %choice%==5 set productKey=W269N-WFGWX-YVC9B-4J6C9-T83GX
if %choice%==6 set productKey=MH37W-N47XK-V7XM9-C7227-GCQG9
if %choice%==7 set productKey=NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J
if %choice%==8 set productKey=9FNHH-K3HBT-3W4TD-6383H-6XYWF
if %choice%==9 set productKey=6TP4R-GNPTD-KYYHQ-7B7DP-J447Y
if %choice%==10 set productKey=YVWGF-BXNMC-HTQYQ-CPQ99-66QFC
if %choice%==11 set productKey=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
if %choice%==12 set productKey=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
if %choice%==13 set productKey=NPPR9-FWDCX-D2C8J-H872K-2YT43
if %choice%==14 set productKey=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
if %choice%==15 set productKey=YYVX9-NTFWV-6MDM3-9PT4T-4M68B
if %choice%==16 set productKey=44RPN-FTY23-9VTTB-MP9BX-T84FV
if %choice%==17 set productKey=M7XTQ-FN8P6-TTKYV-9D4CC-J462D
if %choice%==18 set productKey=92NFX-8DJQP-P6BBQ-THF9C-7CG2H
if %choice%==19 goto end

if "%productKey%"=="" (
    echo "%choice%" is not valid, try again
    goto start
)

rem Now that the productKey variable has been set, 
rem we can proceed to the next step of the process
rem Activating Windows

cscript slmgr.vbs /ipk %productKey%
cscript slmgr.vbs /skms kms8.msguides.com
cscript slmgr.vbs /ato

:end
ECHO THANKS FOR USING A 
ECHO Boss_Man PRODUCT
ECHO.
set /P c=Would You Like to quit[Y/N]?
CLS
if /I "%c%" EQU "Y" goto :endexit
if /I "%c%" EQU "N" goto :menu


:enable_dark_mode
cls
echo ==================================================
echo      Dark Mode Settings for Windows 11
echo ==================================================
echo [1] Enable Dark Mode
echo [2] Disable Dark Mode
echo [3] Return to Main Menu
echo ==================================================
set /p mode_choice=Please enter your choice (1-3): 

if "%mode_choice%"=="1" goto enable_mode
if "%mode_choice%"=="2" goto disable_mode
if "%mode_choice%"=="3" goto menu
echo Invalid choice. Please try again.
pause
goto enable_dark_mode

:enable_mode
cls
echo ==================================================
echo     Enabling Dark Mode...
echo ==================================================
:: เปิดโหมดมืดทั้งในแอปพลิเคชันและระบบ
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
echo Dark Mode enabled successfully!
pause
goto menu

:disable_mode
cls
echo ==================================================
echo     Disabling Dark Mode...
echo ==================================================
:: ปิดโหมดมืดทั้งในแอปพลิเคชันและระบบ
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
echo Dark Mode disabled successfully!
pause
goto menu


:endexit
cls
echo ==================================================
echo   Thank you for using the Windows Optimization Script!
echo ==================================================
pause
exit
