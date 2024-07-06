@echo off
echo Running Comprehensive Network, Wi-Fi, and Driver Optimization Script
echo Please run this script as Administrator

REM Reset TCP/IP stack
netsh int ip reset

REM Reset Winsock catalog
netsh winsock reset

REM Flush DNS cache
ipconfig /flushdns

REM Release and renew IP address
ipconfig /release
ipconfig /renew

REM Reset firewall settings
netsh advfirewall reset

REM Reset Wi-Fi settings
netsh wlan delete profile name=* i=*
netsh wlan reset

REM Disable and re-enable network adapters (including Wi-Fi)
for /f "skip=3 tokens=3*" %%i in ('netsh interface show interface') do (
    netsh interface set interface "%%j" disabled
    timeout /t 5
    netsh interface set interface "%%j" enabled
)

REM Update all drivers (including network and Wi-Fi)
pnputil /scan-devices
pnputil /add-driver *.inf /subdirs /install

REM Reset Network Stack
netsh int ip reset c:\resetlog.txt
netsh winsock reset catalog
netsh int ipv4 reset reset.log
netsh int ipv6 reset reset.log

REM Set DNS servers to Google's public DNS
netsh interface ipv4 set dns name="Wi-Fi" static 8.8.8.8
netsh interface ipv4 add dns name="Wi-Fi" 8.8.4.4 index=2

REM Optimize TCP settings
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global chimney=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global congestionprovider=ctcp

REM Clear browser caches (for major browsers)
taskkill /F /IM "chrome.exe" /T
taskkill /F /IM "firefox.exe" /T
taskkill /F /IM "iexplore.exe" /T
taskkill /F /IM "microsoftedge.exe" /T

RD /S /Q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache"
RD /S /Q "%LOCALAPPDATA%\Mozilla\Firefox\Profiles"
RD /S /Q "%LOCALAPPDATA%\Microsoft\Windows\INetCache"
RD /S /Q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache"

REM Restart the Windows Update service
net stop wuauserv
net start wuauserv

REM Reset Windows Store cache
wsreset

REM Reset and restart WLAN AutoConfig service
net stop wlansvc
net start wlansvc

REM Power cycle the Wi-Fi adapter
powershell -Command "Get-NetAdapter -Name 'Wi-Fi' | Disable-NetAdapter -Confirm:$false; Start-Sleep -Seconds 5; Get-NetAdapter -Name 'Wi-Fi' | Enable-NetAdapter -Confirm:$false"

REM Update Windows (this may take a while)
powershell -Command "Install-Module PSWindowsUpdate -Force; Import-Module PSWindowsUpdate; Get-WindowsUpdate -Install -AcceptAll -AutoReboot"

echo Script completed. Please restart your computer for changes to take effect.
pause
