@echo off
setlocal

REM URLs ของไฟล์ที่ต้องการดาวน์โหลด
set URL1=https://github.com/gotza02/gotza02/raw/main/Tools.zip
set URL2=https://github.com/gotza02/gotza02/raw/main/Tools.z01
set URL3=https://github.com/gotza02/gotza02/raw/main/Tools.z02
set URL4=https://github.com/gotza02/gotza02/raw/main/Tools.z03
set URL_7ZIP=https://www.7-zip.org/a/7z2407-x64.exe

REM ชื่อไฟล์หลังจากดาวน์โหลดมาแล้ว
set FILE1=Tools.zip
set FILE2=Tools.z01
set FILE3=Tools.z02
set FILE4=Tools.z03
set FILE_7ZIP=7z2407-x64.exe

REM รหัสผ่าน
set PASSWORD=kekkaishi

REM โฟลเดอร์ปลายทางที่จะแตกไฟล์ zip บน Desktop ของผู้ใช้ปัจจุบัน
set DEST_DIR=%USERPROFILE%\Desktop\unzipped_files

REM ตรวจสอบว่ามีการติดตั้ง 7-Zip หรือยัง
if exist "C:\Program Files\7-Zip\7z.exe" (
    echo 7-Zip is already installed.
) else (
    echo 7-Zip is not installed. Downloading 7-Zip...
    powershell -Command "Invoke-WebRequest -Uri %URL_7ZIP% -OutFile %FILE_7ZIP%"
    if %ERRORLEVEL% neq 0 (
        echo Failed to download 7-Zip installer.
        exit /b 1
    )
    echo Installing 7-Zip...
    start /wait %FILE_7ZIP% /S
    if %ERRORLEVEL% neq 0 (
        echo Failed to install 7-Zip.
        exit /b 1
    )
    echo 7-Zip installation complete.
    del %FILE_7ZIP%
)

REM ดาวน์โหลดไฟล์จาก URL
echo Downloading file from %URL1%...
powershell -Command "Invoke-WebRequest -Uri %URL1% -OutFile %FILE1%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download file %FILE1%.
    exit /b 1
)

echo Downloading file from %URL2%...
powershell -Command "Invoke-WebRequest -Uri %URL2% -OutFile %FILE2%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download file %FILE2%.
    exit /b 1
)

echo Downloading file from %URL3%...
powershell -Command "Invoke-WebRequest -Uri %URL3% -OutFile %FILE3%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download file %FILE3%.
    exit /b 1
)

echo Downloading file from %URL4%...
powershell -Command "Invoke-WebRequest -Uri %URL4% -OutFile %FILE4%"
if %ERRORLEVEL% neq 0 (
    echo Failed to download file %FILE4%.
    exit /b 1
)

echo Download complete.

REM สร้างโฟลเดอร์ปลายทางบน Desktop ของผู้ใช้ปัจจุบัน
echo Creating destination directory %DEST_DIR%...
mkdir %DEST_DIR%

REM แตกไฟล์ zip ไปยังโฟลเดอร์ปลายทางบน Desktop ของผู้ใช้ปัจจุบัน
echo Unzipping file to %DEST_DIR%...
"C:\Program Files\7-Zip\7z.exe" x %FILE1% -p%PASSWORD% -o%DEST_DIR%

REM ตรวจสอบว่าการแตกไฟล์สำเร็จหรือไม่
if %ERRORLEVEL% neq 0 (
    echo Failed to unzip file.
    exit /b 1
)

echo Unzip complete.

REM ลบไฟล์ zip หลังจากแตกไฟล์เสร็จแล้ว
echo Cleaning up...
del %FILE1%
del %FILE2%
del %FILE3%
del %FILE4%

echo Script completed successfully.
endlocal
pause
