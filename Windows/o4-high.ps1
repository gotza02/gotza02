if (-not ([Security.Principal.WindowsPrincipal]
        [Security.Principal.WindowsIdentity]::GetCurrent()
     ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {

    Write-Host "Requesting elevated rights..." -ForegroundColor Yellow
    Start-Process pwsh -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}
#endregion

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

#== LOGGING ====================================================================
$LogFile = "$PSScriptRoot\Win11AIO-$(Get-Date -Format yyyyMMdd_HHmmss).log"
Start-Transcript -Path $LogFile -Append | Out-Null

#== UTILITY FUNCTIONS ==========================================================
function Write-Section ($Title) {
    Write-Host "`n=== $Title ===" -ForegroundColor Cyan
}

function Require-Module ($Name) {
    if (-not (Get-Module -ListAvailable -Name $Name)) {
        Write-Host "Installing module $Name..."
        Install-Module -Name $Name -Force -Repository PSGallery -Scope AllUsers
    }
    Import-Module $Name -Force
}

#== MAINTENANCE TASKS ==========================================================
function Invoke-WindowsUpdate {
    Write-Section "Windows Update"
    Require-Module PSWindowsUpdate      # Modern replacement for UsoClient 0
    Get-WindowsUpdate -AcceptAll -Install -MicrosoftUpdate `
                      -IgnoreReboot | Out-Host
    if (Get-WURebootStatus) { Restart-Computer -Force }
}

function Disable-WindowsUpdate {
    Write-Section "Disable Windows Update"
    Stop-Service wuauserv, usosvc -Force
    Set-Service  wuauserv, usosvc -StartupType Disabled
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
             -Force | Out-Null
    Set-ItemProperty -Path $_ -Name NoAutoUpdate -Value 1 -Type DWord
    Set-ItemProperty -Path $_ -Name AUOptions     -Value 2 -Type DWord
}

function Enable-WindowsUpdate {
    Write-Section "Enable Windows Update"
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" `
                        -Name NoAutoUpdate, AUOptions -ErrorAction SilentlyContinue
    Set-Service wuauserv, usosvc -StartupType Automatic
    Start-Service wuauserv, usosvc
}

function Update-DefenderAndScan {
    Write-Section "Microsoft Defender (update + full scan)"
    Update-MpSignature                       # Built‑in AV update
    Start-MpScan -ScanType FullScan          # Full system scan 1
}

function Set-DefenderRealtime ($Enable) {
    Write-Section "Defender Real‑Time Protection"
    $state = -not $Enable
    try {
        Set-MpPreference -DisableRealtimeMonitoring $state
        Write-Host "Real‑Time Protection set to $Enable"
    } catch {
        Write-Warning "Failed – Tamper Protection may be enabled."
    }
}

function Update-AppsAndDrivers {
    Write-Section "Winget / Chocolatey / Drivers"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
    }
    if (Get-Command choco  -ErrorAction SilentlyContinue) {
        choco upgrade all -y --no-progress
    }

    if (Test-Path 'C:\Drivers') {
        Get-ChildItem 'C:\Drivers' -Recurse -Filter *.inf |
            ForEach-Object { pnputil /add-driver $_.FullName /install }
        pnputil /scan-devices
    } else {
        Write-Verbose "C:\Drivers not found – driver phase skipped."
    }
}

function Repair-WindowsImage {
    Write-Section "DISM, SFC, CHKDSK"
    Repair-WindowsImage -Online -RestoreHealth      # Alias for DISM /RestoreHealth
    sfc  /scannow
    chkdsk C: /F /R /X | Out-Host
    Write-Host "CHKDSK completed (or scheduled)."
}

function Cleanup-TempAndPrefetch {
    Write-Section "Disk Cleanup & Temp"
    cleanmgr /sagerun:1
    'C:\Windows\Prefetch',
    "$env:TEMP",
    "$env:SystemRoot\Temp" |
        ForEach-Object {
            if (Test-Path $_) { Get-ChildItem $_ -Recurse -Force | Remove-Item -Force -Recurse -EA SilentlyContinue }
        }
}

function Clear-EventLogs {
    Write-Section "Clear ALL Event Logs – USE WITH CAUTION"
    Get-WinEvent -ListLog * |
        ForEach-Object { Clear-EventLog -LogName $_.LogName }   # Classic logs 2
}

function Optimize-Disks {
    Write-Section "Defrag / TRIM (all data volumes)"
    Get-Volume | Where-Object DriveType -in 'Fixed','Removable' |
        Optimize-Volume -Verbose -Analyze -Defrag -ReTrim        3
}

function Rebuild-SearchAndFontCache {
    Write-Section "Rebuild Search & Font caches"
    Stop-Service WSearch -Force
    Remove-Item "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\windows.edb" -EA SilentlyContinue
    Start-Service WSearch
    Stop-Service FontCache -Force
    Remove-Item "$env:WinDir\ServiceProfiles\LocalService\AppData\Local\FontCache*" -Force -EA SilentlyContinue
    Start-Service FontCache
}

function Set-HighPerformancePlan { powercfg /setactive SCHEME_MIN }   # SCHEME_MIN is the built‑in GUID

function Network-Tweaks {
    Write-Section "Network Tweaks"
    netsh interface tcp set global autotuninglevel=disabled
    Clear-DnsClientCache
}

function Windows-Debloat {
    Write-Section "Debloat – external script"
    $url = 'https://git.io/debloat11'
    Read-Host "About to run $url – **RISK**. Press <Enter> to continue or ^C to abort."
    irm $url | iex
}

function ScheduledTask-Cleanup {
    Write-Section "Scheduled Tasks Cleanup"
    Get-ScheduledTask | Where-Object { $_.Author -notmatch '^Microsoft' } |
        Unregister-ScheduledTask -Confirm:$false
}

function Apply-Tweaks {
    Write-Section "Visual & System Tweaks"
    # Visual tweaks
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name MenuShowDelay  -Value 100 -Type String
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name MinAnimate     -Value 0   -Type String
    # Power & pagefile
    powercfg /hibernate off
    Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' `
                     -Name ClearPageFileAtShutdown -Value 1 -Type DWord
    # Gaming
    New-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' `
                     -Name HwSchMode -Value 2 -PropertyType DWord -Force | Out-Null
    # Telemetry & SysMain
    'DiagTrack','dmwappushservice','SysMain' | ForEach-Object {
        Stop-Service $_ -Force -ErrorAction SilentlyContinue
        Set-Service  $_ -StartupType Disabled
    }
}

function Run-All {
    Enable-WindowsUpdate
    Invoke-WindowsUpdate
    Set-DefenderRealtime $true
    Update-DefenderAndScan
    Update-AppsAndDrivers
    Repair-WindowsImage
    Cleanup-TempAndPrefetch
    Clear-EventLogs
    Optimize-Disks
    Rebuild-SearchAndFontCache
    Set-HighPerformancePlan
    Network-Tweaks
    # Windows-Debloat         # HIGH‑RISK – uncomment if desired
    # ScheduledTask-Cleanup   # HIGH‑RISK – uncomment if desired
    Apply-Tweaks
    Write-Host "`n=== ALL DONE – reboot recommended. ===" -ForegroundColor Green
}

#== INTERACTIVE MENU ===========================================================
while ($true) {
    Write-Host @'
╔══════════════════════════════════════════════════════════════╗
║           Windows 11 AIO Maintenance  (PowerShell)           ║
╠══════════════════════════════════════════════════════════════╣
║ 1  Windows Update                  11 Rebuild Search & Font  ║
║ 2  Disable Windows Update          12 Set High‑Perf Power    ║
║ 3  Enable  Windows Update          13 Network Tweaks         ║
║ 4  Defender Update + Full Scan     14 Debloat (High Risk)    ║
║ 5  Disable Defender Real‑Time      15 Scheduled‑Task Cleanup ║
║ 6  Enable  Defender Real‑Time      16 Apply System Tweaks    ║
║ 7  Update Apps & Drivers           17 **RUN ALL**            ║
║ 8  DISM / SFC / CHKDSK             0  Exit                   ║
║ 9  Disk Cleanup + Temp                                             ║
║10 Clear ALL Event Logs                                         ║
╚══════════════════════════════════════════════════════════════╝
'@
    $choice = Read-Host "Select option"
    switch ($choice) {
        '1'  { Invoke-WindowsUpdate }
        '2'  { Disable-WindowsUpdate }
        '3'  { Enable-WindowsUpdate  }
        '4'  { Update-DefenderAndScan }
        '5'  { Set-DefenderRealtime $false }
        '6'  { Set-DefenderRealtime $true  }
        '7'  { Update-AppsAndDrivers }
        '8'  { Repair-WindowsImage }
        '9'  { Cleanup-TempAndPrefetch }
        '10' { Clear-EventLogs }
        '11' { Optimize-Disks }
        '12' { Rebuild-SearchAndFontCache }
        '13' { Set-HighPerformancePlan }
        '14' { Windows-Debloat }
        '15' { ScheduledTask-Cleanup }
        '16' { Apply-Tweaks }
        '17' { Run-All }
        '0'  { break }
        default { Write-Warning "Invalid choice." }
    }
}

Stop-Transcript
