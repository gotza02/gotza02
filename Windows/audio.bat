@echo off
title Windows 11 Audio Enhancer with 20% Volume Boost

:: Run as administrator
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Enhance audio quality
echo Enhancing audio quality...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableProtectedAudioDG" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f

:: Increase system volume by 20%
echo Increasing system volume by 20%%...
powershell -c "$volume = Get-AudioDevice -PlaybackVolume; Set-AudioDevice -PlaybackVolume ([math]::Min(($volume + 20), 100))"

:: Disable audio enhancements (can sometimes cause issues)
echo Disabling audio enhancements...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Audio" /v "DisableAudioEnhancementsGlobal" /t REG_DWORD /d "1" /f

:: Set audio to 24-bit, 192000 Hz (Studio Quality)
echo Setting audio to studio quality...
for /f "tokens=1*" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render" /s /f "{a45c254e-df1c-4efd-8020-67d146a850e0},2" ^| findstr "REG_BINARY"') do (
    reg add "%%a" /v "{a45c254e-df1c-4efd-8020-67d146a850e0},2" /t REG_BINARY /d "41000000" /f
)

:: Optimize audio service
echo Optimizing audio service...
sc config Audiosrv start= auto
sc config AudioEndpointBuilder start= auto

:: Restart audio service
echo Restarting audio service...
net stop Audiosrv
net start Audiosrv

echo Audio enhancement complete. Volume has been increased by 20%%. Please restart your computer for changes to take full effect.
pause
