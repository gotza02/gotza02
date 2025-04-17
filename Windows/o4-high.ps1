if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "PowerShell 7 ไม่ถูกติดตั้ง กำลังติดตั้ง..." -ForegroundColor Yellow
    winget install --id Microsoft.Powershell --source winget --accept-package-agreements --accept-source-agreements
    Write-Host "ติดตั้งเสร็จแล้ว รอสักครู่ก่อนปิด (10 วินาที)..." -ForegroundColor Green
    Start-Sleep -Seconds 10
    exit
}

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "ขอสิทธิ์ผู้ดูแลระบบ..." -ForegroundColor Yellow
    Start-Process pwsh -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'
$LogFile = "$PSScriptRoot\Win11AIO-$(Get-Date -Format yyyyMMdd_HHmmss).log"
Start-Transcript -Path $LogFile -Append | Out-Null

function Write-Section($t){Write-Host "`n=== $t ===" -ForegroundColor Cyan}

function Require-Module($n){
    if(-not(Get-Module -ListAvailable -Name $n)){
        Install-Module -Name $n -Force -Repository PSGallery -Scope AllUsers
    }
    Import-Module $n -Force
}

function Invoke-WindowsUpdate{
    Write-Section "Windows Update"
    Require-Module PSWindowsUpdate
    Get-WindowsUpdate -AcceptAll -Install -MicrosoftUpdate -IgnoreReboot | Out-Host
    if(Get-WURebootStatus){Restart-Computer -Force}
}

function Disable-WindowsUpdate{
    Write-Section "Disable Windows Update"
    Stop-Service wuauserv, usosvc -Force
    Set-Service wuauserv, usosvc -StartupType Disabled
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name AUOptions     -Value 2 -Type DWord
}

function Enable-WindowsUpdate{
    Write-Section "Enable Windows Update"
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name NoAutoUpdate,AUOptions -ErrorAction SilentlyContinue
    Set-Service wuauserv, usosvc -StartupType Automatic
    Start-Service wuauserv, usosvc
}

function Update-DefenderAndScan{
    Write-Section "Microsoft Defender"
    Update-MpSignature
    Start-MpScan -ScanType FullScan
}

function Set-DefenderRealtime($e){
    Write-Section "Defender Real‑Time Protection"
    try{Set-MpPreference -DisableRealtimeMonitoring (-not $e);Write-Host "Real‑Time Protection set to $e"}catch{Write-Warning "Tamper Protection อาจเปิดใช้งานอยู่"}
}

function Update-AppsAndDrivers{
    Write-Section "Winget/Chocolatey/Drivers"
    if(Get-Command winget -ErrorAction SilentlyContinue){winget upgrade --all --silent --accept-source-agreements --accept-package-agreements}
    if(Get-Command choco  -ErrorAction SilentlyContinue){choco upgrade all -y --no-progress}
    if(Test-Path 'C:\Drivers'){
        Get-ChildItem 'C:\Drivers' -Recurse -Filter *.inf|ForEach-Object{pnputil /add-driver $_.FullName /install}
        pnputil /scan-devices
    }
}

function Repair-WindowsImage{
    Write-Section "DISM/SFC/CHKDSK"
    Repair-WindowsImage -Online -RestoreHealth
    sfc /scannow
    chkdsk C: /F /R /X | Out-Host
    Write-Host "CHKDSK เสร็จสิ้น"
}

function Cleanup-TempAndPrefetch{
    Write-Section "Disk Cleanup & Temp"
    cleanmgr /sagerun:1
    'C:\Windows\Prefetch',"$env:TEMP","$env:SystemRoot\Temp"|ForEach-Object{if(Test-Path $_){Get-ChildItem $_ -Recurse -Force|Remove-Item -Force -Recurse -ErrorAction SilentlyContinue}}
}

function Clear-EventLogs{
    Write-Section "Clear ALL Event Logs"
    Get-WinEvent -ListLog *|ForEach-Object{Clear-EventLog -LogName $_.LogName}
}

function Optimize-Disks{
    Write-Section "Defrag/TRIM"
    Get-Volume|Where-Object DriveType -in 'Fixed','Removable'|Optimize-Volume -Verbose -Analyze -Defrag -ReTrim
}

function Rebuild-SearchAndFontCache{
    Write-Section "Rebuild Search & Font Caches"
    Stop-Service WSearch -Force
    Remove-Item "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\windows.edb" -ErrorAction SilentlyContinue
    Start-Service WSearch
    Stop-Service FontCache -Force
    Remove-Item "$env:WinDir\ServiceProfiles\LocalService\AppData\Local\FontCache*" -Force -ErrorAction SilentlyContinue
    Start-Service FontCache
}

function Set-HighPerformancePlan{powercfg /setactive SCHEME_MIN}

function Network-Tweaks{
    Write-Section "Network Tweaks"
    netsh interface tcp set global autotuninglevel=disabled
    Clear-DnsClientCache
}

function Windows-Debloat{
    Write-Section "Debloat"
    $u='https://git.io/debloat11'
    Read-Host "กำลังจะรัน $u กด Enter หรือ Ctrl+C ยกเลิก"
    irm $u|iex
}

function ScheduledTask-Cleanup{
    Write-Section "Scheduled Tasks Cleanup"
    Get-ScheduledTask|Where-Object{$_​.Author -notmatch '^Microsoft'}|Unregister-ScheduledTask -Confirm:$false
}

function Apply-Tweaks{
    Write-Section "Visual & System Tweaks"
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name MenuShowDelay -Value 100 -Type String
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name MinAnimate     -Value 0   -Type String
    powercfg /hibernate off
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name ClearPageFileAtShutdown -Value 1 -Type DWord
    New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name HwSchMode -Value 2 -PropertyType DWord -Force|Out-Null
    'DiagTrack','dmwappushservice','SysMain'|ForEach-Object{Stop-Service $_ -Force -ErrorAction SilentlyContinue;Set-Service $_ -StartupType Disabled}
}

function Run-All{
    Enable-WindowsUpdate;Invoke-WindowsUpdate;Set-DefenderRealtime $true;Update-DefenderAndScan;Update-AppsAndDrivers
    Repair-WindowsImage;Cleanup-TempAndPrefetch;Clear-EventLogs;Optimize-Disks;Rebuild-SearchAndFontCache
    Set-HighPerformancePlan;Network-Tweaks;Apply-Tweaks
    Write-Host "`n=== ALL DONE – ควร reboot เครื่อง ===" -ForegroundColor Green
}

while($true){
    Write-Host @'
╔══════════════════════════════════════════════════════════════╗
║           Windows 11 AIO Maintenance (PowerShell)           ║
╠══════════════════════════════════════════════════════════════╣
║ 1  Windows Update                  11 Rebuild Caches        ║
║ 2  Disable Windows Update          12 Set High‑Perf Plan    ║
║ 3  Enable  Windows Update          13 Network Tweaks         ║
║ 4  Defender Update + Full Scan     14 Debloat               ║
║ 5  Disable Defender Real‑Time      15 Task Cleanup          ║
║ 6  Enable  Defender Real‑Time      16 Apply Tweaks          ║
║ 7  Update Apps & Drivers           17 **RUN ALL**           ║
║ 8  DISM/SFC/CHKDSK                  0  Exit                   ║
║ 9  Disk Cleanup + Temp                                            ║
║10 Clear ALL Event Logs                                         ║
╚══════════════════════════════════════════════════════════════╝
'@
    $c=Read-Host "Select option"
    switch($c){
        '1'{Invoke-WindowsUpdate}
        '2'{Disable-WindowsUpdate}
        '3'{Enable-WindowsUpdate}
        '4'{Update-DefenderAndScan}
        '5'{Set-DefenderRealtime $false}
        '6'{Set-DefenderRealtime $true}
        '7'{Update-AppsAndDrivers}
        '8'{Repair-WindowsImage}
        '9'{Cleanup-TempAndPrefetch}
        '10'{Clear-EventLogs}
        '11'{Optimize-Disks}
        '12'{Rebuild-SearchAndFontCache}
        '13'{Set-HighPerformancePlan}
        '14'{Windows-Debloat}
        '15'{ScheduledTask-Cleanup}
        '16'{Apply-Tweaks}
        '17'{Run-All}
        '0'{break}
        default{Write-Warning "Invalid choice."}
    }
}

Stop-Transcript
