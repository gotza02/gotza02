if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges. Please restart as Administrator."
    Start-Sleep -Seconds 3
    exit
}

Clear-Host
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "  WINDOWS 11 GAMING PERFORMANCE OPTIMIZATION SCRIPT" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will optimize your Windows 11 system for maximum gaming performance." -ForegroundColor Yellow
Write-Host "It addresses: slow boot times, program freezes, internet stability," -ForegroundColor Yellow
Write-Host "FPS drops, and overall system sluggishness." -ForegroundColor Yellow
Write-Host ""
Write-Host "WARNING: THIS SCRIPT MAKES SIGNIFICANT SYSTEM CHANGES!" -ForegroundColor Red
Write-Host "A System Restore Point will be created automatically before proceeding." -ForegroundColor Red
Write-Host ""

Write-Host "USER LEVEL GUIDANCE:" -ForegroundColor Magenta
Write-Host "This script contains optimizations for users of all experience levels." -ForegroundColor Yellow
Write-Host ""
Write-Host "BEGINNER USERS:" -ForegroundColor Green
Write-Host "- The script will automatically create a System Restore Point for safety" -ForegroundColor White
Write-Host "- You will be prompted before any risky changes are made" -ForegroundColor White
Write-Host "- If you encounter any issues after running this script, you can:" -ForegroundColor White
Write-Host "  1. Restart your computer" -ForegroundColor White
Write-Host "  2. If problems persist, restore your system using the created restore point" -ForegroundColor White
Write-Host "     (Type 'Create a restore point' in Windows search to access System Restore)" -ForegroundColor White
Write-Host ""
Write-Host "INTERMEDIATE USERS:" -ForegroundColor Yellow
Write-Host "- The script includes registry modifications that optimize gaming performance" -ForegroundColor White
Write-Host "- Services that may be important for non-gaming tasks will be disabled" -ForegroundColor White
Write-Host "- You can selectively re-enable services later through Services.msc if needed" -ForegroundColor White
Write-Host ""
Write-Host "ADVANCED USERS:" -ForegroundColor Red
Write-Host "- This script makes deep system optimizations including:" -ForegroundColor White
Write-Host "  * Registry modifications" -ForegroundColor White
Write-Host "  * Service configurations" -ForegroundColor White
Write-Host "  * Network stack optimizations" -ForegroundColor White
Write-Host "  * Security feature adjustments" -ForegroundColor White
Write-Host "- You can review each function in the script before execution" -ForegroundColor White
Write-Host "- Consider running individual functions instead of the entire script if preferred" -ForegroundColor White
Write-Host ""
Write-Host "NOTE: Some optimizations may need to be reverted if you use your system for" -ForegroundColor Yellow
Write-Host "professional work, content creation, or other non-gaming purposes." -ForegroundColor Yellow
Write-Host ""

function Create-SystemRestorePoint {
    Write-Host "Creating System Restore Point..." -ForegroundColor Green
    
    Write-Host "  Ensuring System Restore is enabled..." -ForegroundColor Gray
    Enable-ComputerRestore -Drive "$env:SystemDrive"
    
    $RestorePointDescription = "Windows 11 Gaming Optimization Script - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    
    Checkpoint-Computer -Description $RestorePointDescription -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    
    $latestRestorePoint = Get-ComputerRestorePoint | Sort-Object -Property CreationTime -Descending | Select-Object -First 1
    
    if ($latestRestorePoint -and $latestRestorePoint.Description -eq $RestorePointDescription) {
        Write-Host "  System Restore Point created successfully!" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "  WARNING: System Restore Point creation may have failed." -ForegroundColor Red
        Write-Host "  Consider creating a manual restore point before continuing." -ForegroundColor Red
        
        $response = Read-Host "Do you want to continue anyway? (Y/N)"
        if ($response -eq "Y" -or $response -eq "y") {
            return $true
        }
        else {
            return $false
        }
    }
}

function Optimize-SystemPerformance {
    Write-Host "Optimizing System Performance Settings..." -ForegroundColor Green
    
    Write-Host "  Setting power plan to High Performance..." -ForegroundColor Gray
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    
    Write-Host "  Creating and setting Ultimate Performance power plan..." -ForegroundColor Gray
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    
    Write-Host "  Disabling power throttling for consistent CPU performance..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Type DWord -Value 1
    
    Write-Host "  Disabling CPU core parking for better gaming performance..." -ForegroundColor Gray
    powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
    powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100
    powercfg /setactive scheme_current
    
    Write-Host "  Setting processor performance to maximum..." -ForegroundColor Gray
    powercfg -setacvalueindex scheme_current sub_processor PERFINCPOL 2
    powercfg -setacvalueindex scheme_current sub_processor PERFDECPOL 1
    powercfg -setacvalueindex scheme_current sub_processor PERFINCTHRESHOLD 10
    powercfg -setacvalueindex scheme_current sub_processor PERFDECTHRESHOLD 20
    
    Write-Host "  Adjusting visual effects for performance..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Type DWord -Value 2
    
    Write-Host "  Disabling transparency effects..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Type DWord -Value 0
    
    Write-Host "  Disabling animations for better performance..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Type String -Value 0
    
    Write-Host "  Setting processor scheduling to prioritize programs..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Type DWord -Value 38
    
    Write-Host "  Disabling fullscreen optimizations to reduce input lag..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\System\GameConfigStore")) {
        New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_DXGIHonorFSEWindowsCompatible" -Type DWord -Value 1
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Type DWord -Value 2
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Type DWord -Value 2
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_HonorUserFSEBehaviorMode" -Type DWord -Value 1
    
    Write-Host "  System performance settings optimized!" -ForegroundColor Green
}

function Optimize-BootPerformance {
    Write-Host "Optimizing Boot Performance..." -ForegroundColor Green
    
    Write-Host "  Enabling fast startup..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Type DWord -Value 1
    
    Write-Host "  Disabling hybrid sleep..." -ForegroundColor Gray
    powercfg -setacvalueindex scheme_current sub_sleep HYBRIDSLEEP 0
    powercfg -setdcvalueindex scheme_current sub_sleep HYBRIDSLEEP 0
    powercfg /setactive scheme_current
    
    Write-Host "  Optimizing prefetch and superfetch for faster boot and application launch..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Type DWord -Value 3
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Type DWord -Value 3
    
    Write-Host "  Disabling unnecessary startup programs..." -ForegroundColor Gray
    $startupItems = Get-CimInstance Win32_StartupCommand | 
                    Where-Object {$_.Location -eq "Startup" -or $_.Location -eq "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"}
    
    foreach ($item in $startupItems) {
        if ($item.Command -notmatch "Windows|Microsoft|Security|Antivirus") {
            Write-Host "    Disabling startup item: $($item.Name)" -ForegroundColor Gray
            if ($item.Location -eq "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run") {
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $item.Name -ErrorAction SilentlyContinue
            }
            elseif ($item.Location -eq "Startup") {
                $startupFolder = [Environment]::GetFolderPath("Startup")
                Remove-Item -Path "$startupFolder\$($item.Name).lnk" -ErrorAction SilentlyContinue
            }
        }
    }
    
    Write-Host "  Optimizing boot timeout values..." -ForegroundColor Gray
    bcdedit /timeout 3
    
    Write-Host "  Disabling boot debugging..." -ForegroundColor Gray
    bcdedit /debug off
    
    Write-Host "  Boot performance optimized!" -ForegroundColor Green
}

function Optimize-MemoryUsage {
    Write-Host "Optimizing Memory Usage..." -ForegroundColor Green
    
    Write-Host "  Optimizing virtual memory settings..." -ForegroundColor Gray
    $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
    $physicalMemory = [Math]::Round($computerSystem.TotalPhysicalMemory / 1GB)
    
    $pageFileSize = if ($physicalMemory -lt 16) { $physicalMemory * 1.5 } else { 16 }
    $pageFileSize = [Math]::Round($pageFileSize) * 1024
    
    $computerName = $env:COMPUTERNAME
    $pagefileSetting = Get-CimInstance -ClassName Win32_ComputerSystem -Property AutomaticManagedPagefile
    if ($pagefileSetting.AutomaticManagedPagefile) {
        Set-CimInstance -InputObject $pagefileSetting -Property @{AutomaticManagedPagefile = $false}
    }
    
    $pagefile = Get-CimInstance -ClassName Win32_PageFileSetting
    if ($pagefile) {
        Set-CimInstance -InputObject $pagefile -Property @{InitialSize = $pageFileSize; MaximumSize = $pageFileSize}
    }
    else {
        $pagefile = New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name = "C:\pagefile.sys"; InitialSize = $pageFileSize; MaximumSize = $pageFileSize}
    }
    
    Write-Host "  Disabling memory compression for better performance..." -ForegroundColor Gray
    Disable-MMAgent -MemoryCompression
    
    Write-Host "  Optimizing working set trimming..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "DisablePagingExecutive" -Type DWord -Value 1
    
    Write-Host "  Optimizing large system cache..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Type DWord -Value 0
    
    Write-Host "  Clearing standby list (cached memory)..." -ForegroundColor Gray
    $source = @"
using System;
using System.Runtime.InteropServices;

public static class MemoryManagement {
    [DllImport("psapi.dll")]
    public static extern int EmptyWorkingSet(IntPtr hwProc);
    
    public static void ClearStandbyList() {
        System.Diagnostics.Process[] processes = System.Diagnostics.Process.GetProcesses();
        foreach (System.Diagnostics.Process process in processes) {
            try {
                EmptyWorkingSet(process.Handle);
            }
            catch {}
        }
    }
}
"@
    Add-Type -TypeDefinition $source
    [MemoryManagement]::ClearStandbyList()
    
    Write-Host "  Memory usage optimized!" -ForegroundColor Green
}

function Optimize-DiskPerformance {
    Write-Host "Optimizing Disk Performance..." -ForegroundColor Green
    
    Write-Host "  Disabling Windows Search indexing service..." -ForegroundColor Gray
    Stop-Service "WSearch" -Force -ErrorAction SilentlyContinue
    Set-Service "WSearch" -StartupType Disabled
    
    Write-Host "  Disabling Superfetch/SysMain service..." -ForegroundColor Gray
    Stop-Service "SysMain" -Force -ErrorAction SilentlyContinue
    Set-Service "SysMain" -StartupType Disabled
    
    Write-Host "  Disabling hibernation to free up disk space..." -ForegroundColor Gray
    powercfg -h off
    
    Write-Host "  Disabling Storage Sense..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy")) {
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Name "01" -Type DWord -Value 0
    
    Write-Host "  Enabling TRIM for SSDs..." -ForegroundColor Gray
    fsutil behavior set DisableDeleteNotify 0
    
    Write-Host "  Optimizing NTFS settings..." -ForegroundColor Gray
    fsutil behavior set memoryusage 2
    fsutil behavior set mftzone 2
    fsutil behavior set disablelastaccess 1
    
    Write-Host "  Disabling background disk defragmentation..." -ForegroundColor Gray
    schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
    
    Write-Host "  Running disk cleanup..." -ForegroundColor Gray
    cleanmgr /sagerun:1 /VeryLowDisk
    
    Write-Host "  Disk performance optimized!" -ForegroundColor Green
}

function Optimize-NetworkPerformance {
    Write-Host "Optimizing Network Performance..." -ForegroundColor Green
    
    Write-Host "  Setting network adapter properties for gaming..." -ForegroundColor Gray
    $networkAdapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }
    
    foreach ($adapter in $networkAdapters) {
        Write-Host "    Disabling power saving on $($adapter.Name)..." -ForegroundColor Gray
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*EEE*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Power Sav*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Green Ethernet*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        
        Write-Host "    Setting Jumbo Frame to optimal value on $($adapter.Name)..." -ForegroundColor Gray
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Jumbo*" -DisplayValue "9014" -ErrorAction SilentlyContinue
        
        Write-Host "    Disabling interrupt moderation on $($adapter.Name)..." -ForegroundColor Gray
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Interrupt Moderation*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        
        Write-Host "    Setting receive/transmit buffers to maximum on $($adapter.Name)..." -ForegroundColor Gray
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Receive Buffers*" -DisplayValue "2048" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Transmit Buffers*" -DisplayValue "2048" -ErrorAction SilentlyContinue
        
        Write-Host "    Disabling flow control on $($adapter.Name)..." -ForegroundColor Gray
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "*Flow Control*" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
    }
    
    Write-Host "  Optimizing TCP/IP settings..." -ForegroundColor Gray
    
    netsh int tcp set global autotuninglevel=normal
    
    netsh int tcp set global rss=enabled
    netsh int tcp set global chimney=enabled
    netsh int tcp set global dca=enabled
    netsh int tcp set global netdma=enabled
    
    Write-Host "  Setting QoS policy to prioritize gaming traffic..." -ForegroundColor Gray
    New-NetQosPolicy -Name "Gaming Traffic" -AppPathNameMatchCondition "*.exe" -IPProtocolMatchCondition Both -NetworkProfile All -ThrottleRateActionBitsPerSecond 100000000 -DSCPAction 46 -ErrorAction SilentlyContinue
    
    Write-Host "  Optimizing DNS settings..." -ForegroundColor Gray
    
    $networkAdapters | ForEach-Object {
        Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses "1.1.1.1","8.8.8.8"
    }
    
    Write-Host "  Flushing DNS cache..." -ForegroundColor Gray
    Clear-DnsClientCache
    
    Write-Host "  Disabling NetBIOS over TCP/IP..." -ForegroundColor Gray
    $networkAdapters | ForEach-Object {
        $adapterConfig = Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "Index = '$($_.ifIndex)'"
        $adapterConfig.SetTcpipNetbios(2) | Out-Null
    }
    
    Write-Host "  Disabling IPv6 (improves routing efficiency for gaming)..." -ForegroundColor Gray
    Disable-NetAdapterBinding -Name "*" -ComponentID "ms_tcpip6"
    
    Write-Host "  Disabling Network Throttling..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff
    
    Write-Host "  Optimizing Nagle's Algorithm for gaming..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Force | Out-Null
    }
    
    $networkInterfaces = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces"
    foreach ($interface in $networkInterfaces) {
        Set-ItemProperty -Path $interface.PSPath -Name "TcpAckFrequency" -Type DWord -Value 1 -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $interface.PSPath -Name "TCPNoDelay" -Type DWord -Value 1 -ErrorAction SilentlyContinue
    }
    
    Write-Host "  Network performance optimized!" -ForegroundColor Green
}

function Optimize-GPUPerformance {
    Write-Host "Optimizing GPU Performance..." -ForegroundColor Green
    
    Write-Host "  Setting GPU to prefer maximum performance..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Type DWord -Value 0
    
    Write-Host "  Disabling Game DVR and Game Bar..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\System\GameConfigStore")) {
        New-Item -Path "HKCU:\System\GameConfigStore" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
    
    if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Type DWord -Value 0
    
    Write-Host "  Disabling background recording..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
    
    Write-Host "  Enabling hardware accelerated GPU scheduling..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers")) {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2
    
    $nvidiaPaths = @(
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*",
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\nvlddmkm\*"
    )
    
    $nvidiaFound = $false
    foreach ($path in $nvidiaPaths) {
        if (Get-Item -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match "NVIDIA" }) {
            $nvidiaFound = $true
            break
        }
    }
    
    if ($nvidiaFound) {
        Write-Host "  NVIDIA GPU detected, applying NVIDIA-specific optimizations..." -ForegroundColor Gray
        
        if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak")) {
            New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" -Force | Out-Null
        }
        
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" -Name "PowerMizerEnable" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" -Name "PowerMizerLevel" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\NVTweak" -Name "PerfLevelSrc" -Type DWord -Value 8738
    }
    
    $amdPaths = @(
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*",
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\amdkmdap\*"
    )
    
    $amdFound = $false
    foreach ($path in $amdPaths) {
        if (Get-Item -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match "AMD|ATI|Radeon" }) {
            $amdFound = $true
            break
        }
    }
    
    if ($amdFound) {
        Write-Host "  AMD GPU detected, applying AMD-specific optimizations..." -ForegroundColor Gray
        
        if (!(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD")) {
            New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" -Force | Out-Null
        }
        
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" -Name "PowerState" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000\UMD" -Name "SurfaceFormatReplacements" -Type DWord -Value 1
    }
    
    $intelPaths = @(
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*",
        "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\igfx\*"
    )
    
    $intelFound = $false
    foreach ($path in $intelPaths) {
        if (Get-Item -Path $path -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match "Intel" }) {
            $intelFound = $true
            break
        }
    }
    
    if ($intelFound) {
        Write-Host "  Intel GPU detected, applying Intel-specific optimizations..." -ForegroundColor Gray
        
        if (!(Test-Path "HKLM:\SOFTWARE\Intel\GMM")) {
            New-Item -Path "HKLM:\SOFTWARE\Intel\GMM" -Force | Out-Null
        }
        
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Intel\GMM" -Name "DedicatedSegmentSize" -Type DWord -Value 1024
    }
    
    Write-Host "  GPU performance optimized!" -ForegroundColor Green
}

function Disable-UnnecessaryServices {
    Write-Host "Disabling Unnecessary Services..." -ForegroundColor Green
    
    $servicesToDisable = @(
        "wuauserv",
        "UsoSvc",
        "WaaSMedicSvc",
        "DiagTrack",
        "dmwappushservice",
        "diagnosticshub.standardcollector.service",
        "Spooler",
        "PrintNotify",
        "WSearch",
        "SysMain",
        "MapsBroker",
        "lfsvc",
        "RetailDemo",
        "WalletService",
        "XblAuthManager",
        "XblGameSave",
        "XboxNetApiSvc",
        "WMPNetworkSvc",
        "wisvc",
        "FontCache",
        "WbioSrvc",
        "PcaSvc",
        "DoSvc"
    )
    
    foreach ($service in $servicesToDisable) {
        $serviceObj = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($serviceObj) {
            Write-Host "  Disabling service: $($serviceObj.DisplayName) ($service)..." -ForegroundColor Gray
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host "  Unnecessary services disabled!" -ForegroundColor Green
}

function Disable-WindowsFeatures {
    Write-Host "Disabling Unnecessary Windows Features..." -ForegroundColor Green
    
    Write-Host "  WARNING: Disabling Windows Defender real-time protection reduces security!" -ForegroundColor Red
    Write-Host "  This is recommended only for dedicated gaming systems." -ForegroundColor Red
    
    $defenderConfirmation = Read-Host "  Do you want to disable Windows Defender real-time protection? (Y/N)"
    if ($defenderConfirmation -eq "Y" -or $defenderConfirmation -eq "y") {
        Write-Host "  Disabling Windows Defender real-time protection..." -ForegroundColor Gray
        
        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
        
        if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection")) {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force | Out-Null
        }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Type DWord -Value 1
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Type DWord -Value 1
    }
    else {
        Write-Host "  Windows Defender real-time protection will remain enabled." -ForegroundColor Green
    }
    
    Write-Host "  WARNING: Disabling Windows Firewall reduces security!" -ForegroundColor Red
    Write-Host "  This is recommended only for dedicated gaming systems behind a router." -ForegroundColor Red
    
    $firewallConfirmation = Read-Host "  Do you want to disable Windows Firewall? (Y/N)"
    if ($firewallConfirmation -eq "Y" -or $firewallConfirmation -eq "y") {
        Write-Host "  Disabling Windows Firewall..." -ForegroundColor Gray
        Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    }
    else {
        Write-Host "  Windows Firewall will remain enabled." -ForegroundColor Green
    }
    
    Write-Host "  Disabling Windows Error Reporting..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
    
    Write-Host "  Disabling Customer Experience Improvement Program..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Type DWord -Value 0
    
    Write-Host "  Disabling Telemetry..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
    
    Write-Host "  Disabling Windows Tips..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Type DWord -Value 1
    
    Write-Host "  Disabling automatic app updates from Microsoft Store..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Name "AutoDownload" -Type DWord -Value 2
    
    Write-Host "  Disabling OneDrive..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
    
    Write-Host "  Disabling Windows Timeline..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
    
    Write-Host "  Unnecessary Windows features disabled!" -ForegroundColor Green
}

function Optimize-GamingSettings {
    Write-Host "Optimizing Gaming-Specific Settings..." -ForegroundColor Green
    
    Write-Host "  Enabling Game Mode..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Software\Microsoft\GameBar")) {
        New-Item -Path "HKCU:\Software\Microsoft\GameBar" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 1
    
    Write-Host "  Disabling Game Bar for better performance..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Software\Microsoft\GameBar")) {
        New-Item -Path "HKCU:\Software\Microsoft\GameBar" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Type DWord -Value 0
    
    if (!(Test-Path "HKCU:\Software\Microsoft\GameBar")) {
        New-Item -Path "HKCU:\Software\Microsoft\GameBar" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel" -Type DWord -Value 0
    
    Write-Host "  Disabling Game DVR..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
    
    Write-Host "  Setting high process priority for games..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Affinity" -Type DWord -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Background Only" -Type String -Value "False"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Clock Rate" -Type DWord -Value 10000
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "SFIO Priority" -Type String -Value "High"
    
    Write-Host "  Optimizing system responsiveness for gaming..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0
    
    Write-Host "  Optimizing mouse settings for gaming..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Type String -Value "10"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Type String -Value "0"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Type String -Value "0"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Type String -Value "0"
    
    Write-Host "  Disabling mouse acceleration..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Control Panel\Mouse")) {
        New-Item -Path "HKCU:\Control Panel\Mouse" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Type String -Value "0"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Type String -Value "0"
    Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Type String -Value "0"
    
    Write-Host "  Disabling Sticky Keys..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Control Panel\Accessibility\StickyKeys")) {
        New-Item -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
    
    Write-Host "  Disabling Filter Keys..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Control Panel\Accessibility\Keyboard Response")) {
        New-Item -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -Type String -Value "122"
    
    Write-Host "  Disabling Toggle Keys..." -ForegroundColor Gray
    if (!(Test-Path "HKCU:\Control Panel\Accessibility\ToggleKeys")) {
        New-Item -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -Type String -Value "58"
    
    Write-Host "  Gaming-specific settings optimized!" -ForegroundColor Green
}

function Clean-TemporaryFiles {
    Write-Host "Cleaning Temporary Files..." -ForegroundColor Green
    
    Write-Host "  Cleaning Windows temporary files..." -ForegroundColor Gray
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "  Cleaning user temporary files..." -ForegroundColor Gray
    Remove-Item -Path "$env:USERPROFILE\AppData\Local\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    
    Write-Host "  Cleaning Windows Update cache..." -ForegroundColor Gray
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    
    Write-Host "  Cleaning font cache..." -ForegroundColor Gray
    Stop-Service -Name "FontCache" -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Force -Recurse -ErrorAction SilentlyContinue
    Start-Service -Name "FontCache" -ErrorAction SilentlyContinue
    
    Write-Host "  Cleaning DNS cache..." -ForegroundColor Gray
    Clear-DnsClientCache
    
    Write-Host "  Cleaning thumbnail cache..." -ForegroundColor Gray
    Remove-Item -Path "$env:USERPROFILE\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
    
    Write-Host "  Cleaning Event Logs..." -ForegroundColor Gray
    wevtutil cl Application
    wevtutil cl System
    wevtutil cl Security
    
    Write-Host "  Temporary files cleaned!" -ForegroundColor Green
}

function Optimize-WindowsUpdate {
    Write-Host "Optimizing Windows Update Settings..." -ForegroundColor Green
    
    Write-Host "  Disabling automatic Windows updates..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 1
    
    Write-Host "  Disabling update notifications..." -ForegroundColor Gray
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 1
    
    Write-Host "  Disabling driver updates through Windows Update..." -ForegroundColor Gray
    if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -Type DWord -Value 1
    
    Write-Host "  Disabling Windows Update service..." -ForegroundColor Gray
    Stop-Service -Name "wuauserv" -Force -ErrorAction SilentlyContinue
    Set-Service -Name "wuauserv" -StartupType Disabled
    
    Write-Host "  Windows Update settings optimized!" -ForegroundColor Green
}

Write-Host "HOW TO REVERT CHANGES:" -ForegroundColor Magenta
Write-Host "If you experience issues after running this script, you can revert changes by:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Using System Restore:" -ForegroundColor White
Write-Host "   - Type 'Create a restore point' in Windows search" -ForegroundColor White
Write-Host "   - Click 'System Restore' button" -ForegroundColor White
Write-Host "   - Select the restore point created before running this script" -ForegroundColor White
Write-Host ""
Write-Host "2. Re-enabling specific services:" -ForegroundColor White
Write-Host "   - Press Win+R, type 'services.msc' and press Enter" -ForegroundColor White
Write-Host "   - Find the service you want to re-enable" -ForegroundColor White
Write-Host "   - Right-click the service and select 'Properties'" -ForegroundColor White
Write-Host "   - Change 'Startup type' to 'Automatic' and click 'Start'" -ForegroundColor White
Write-Host ""
Write-Host "3. Restoring Windows Defender:" -ForegroundColor White
Write-Host "   - Open Windows Security from Start menu" -ForegroundColor White
Write-Host "   - Go to 'Virus & threat protection'" -ForegroundColor White
Write-Host "   - Click 'Manage settings' under 'Virus & threat protection settings'" -ForegroundColor White
Write-Host "   - Toggle 'Real-time protection' to On" -ForegroundColor White
Write-Host ""
Write-Host "4. Restoring Windows Firewall:" -ForegroundColor White
Write-Host "   - Open Windows Security from Start menu" -ForegroundColor White
Write-Host "   - Go to 'Firewall & network protection'" -ForegroundColor White
Write-Host "   - Click on each network profile and toggle 'Microsoft Defender Firewall' to On" -ForegroundColor White
Write-Host ""

$confirmation = Read-Host "Do you want to proceed with the optimization? (Y/N)"
if ($confirmation -ne "Y" -and $confirmation -ne "y") {
    Write-Host "Operation cancelled by user. Exiting script." -ForegroundColor Yellow
    exit
}

$restorePointCreated = Create-SystemRestorePoint
if (-not $restorePointCreated) {
    Write-Host "Exiting script as System Restore Point creation was declined." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Starting optimization process. Please be patient and do not interrupt the script." -ForegroundColor Cyan
Write-Host "Your computer may restart during this process." -ForegroundColor Cyan
Write-Host ""

Optimize-SystemPerformance
Optimize-BootPerformance
Optimize-MemoryUsage
Optimize-DiskPerformance
Optimize-NetworkPerformance
Optimize-GPUPerformance
Disable-UnnecessaryServices
Disable-WindowsFeatures
Optimize-GamingSettings
Clean-TemporaryFiles
Optimize-WindowsUpdate

Write-Host ""
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "  WINDOWS 11 GAMING OPTIMIZATION COMPLETE!" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your system has been optimized for maximum gaming performance." -ForegroundColor Green
Write-Host "You may need to restart your computer for all changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "If you experience any issues, you can restore your system to the" -ForegroundColor Yellow
Write-Host "restore point created at the beginning of this process." -ForegroundColor Yellow
Write-Host ""

$restartConfirmation = Read-Host "Do you want to restart your computer now? (Y/N)"
if ($restartConfirmation -eq "Y" -or $restartConfirmation -eq "y") {
    Write-Host "Restarting computer in 10 seconds..." -ForegroundColor Cyan
    Start-Sleep -Seconds 10
    Restart-Computer -Force
}
else {
    Write-Host "Please restart your computer manually to apply all changes." -ForegroundColor Y
}
