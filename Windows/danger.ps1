# ==============================================================================
# Windows 11 Performance Optimization Script (Gaming & Advanced Focus)
# Version: 1.0
# Author: AI (Senior Windows Optimization Specialist Persona)
#
# DISCLAIMER:
# This script makes significant changes to your system settings.
# WHILE DESIGNED WITH CARE, USE AT YOUR OWN RISK.
# The author is not responsible for any damage or data loss.
# ALWAYS CREATE A SYSTEM RESTORE POINT BEFORE RUNNING THIS SCRIPT.
# ==============================================================================

# --- Initial Checks ---
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host " Windows 11 Performance Optimization Script " -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "This script will apply advanced performance optimizations." -ForegroundColor Cyan
Write-Host "*** PLEASE CREATE A SYSTEM RESTORE POINT BEFORE PROCEEDING! ***" -ForegroundColor Red -BackgroundColor Black
Write-Host ""

# Check for Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Administrator privileges are required to run this script."
    Write-Warning "Please right-click the script and select 'Run as administrator'."
    Read-Host "Press Enter to exit..."
    exit
}

# Function to prompt user for confirmation
function Confirm-Action {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    $confirm = Read-Host "$Message (Y/N)"
    if ($confirm -match '^[Yy]$') {
        return $true
    } else {
        Write-Host "Skipping this section." -ForegroundColor Yellow
        return $false
    }
}

# --- Create System Restore Point ---
Write-Host "[RECOMMENDED] Create a System Restore Point" -ForegroundColor Green
if (Confirm-Action "Do you want to create a System Restore Point now?") {
    try {
        Write-Host "Creating System Restore Point... Please wait." -ForegroundColor Cyan
        Checkpoint-Computer -Description "Before Performance Optimization Script" -RestorePointType "MODIFY_SETTINGS"
        Write-Host "System Restore Point created successfully." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to create System Restore Point. Error: $($_.Exception.Message)"
        Write-Warning "It is STRONGLY recommended to create one manually before continuing."
        if (-NOT (Confirm-Action "Do you want to continue WITHOUT a new Restore Point? (Not Recommended)")) {
            Write-Host "Exiting script." -ForegroundColor Red
            exit
        }
    }
}

Write-Host "`n--------------------------------------------------"
Write-Host " Starting Optimization Process..."
Write-Host "--------------------------------------------------`n"

# ==================================================
# SECTION 1: Power Plan Optimization
# ==================================================
Write-Host "[Section 1] Power Plan Optimization" -ForegroundColor Green
Write-Host "Setting the power plan to Ultimate Performance (if available) or High Performance."
Write-Host "This helps ensure maximum CPU performance, crucial for gaming and demanding tasks."

if (Confirm-Action "Apply Power Plan optimizations?") {
    # Define High Performance GUID
    $HighPerformanceGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    # Define Ultimate Performance GUID
    $UltimatePerformanceGuid = "e9a42b02-d5df-448d-aa00-03f14749eb61"

    # Check if Ultimate Performance plan exists
    $UltimatePlanExists = powercfg /list | Select-String -Pattern $UltimatePerformanceGuid -Quiet

    if ($UltimatePlanExists) {
        Write-Host "Ultimate Performance plan found. Setting it as active." -ForegroundColor Cyan
        powercfg /setactive $UltimatePerformanceGuid
    } else {
        Write-Host "Ultimate Performance plan not found. Attempting to unhide it..." -ForegroundColor Cyan
        try {
            # Try to duplicate High Performance to create/unhide Ultimate Performance
            powercfg /duplicatescheme $HighPerformanceGuid $UltimatePerformanceGuid
            Write-Host "Attempted to unhide Ultimate Performance. Checking again..." -ForegroundColor Cyan
            # Check again
             $UltimatePlanExists = powercfg /list | Select-String -Pattern $UltimatePerformanceGuid -Quiet
             if ($UltimatePlanExists) {
                 Write-Host "Ultimate Performance plan is now available. Setting it as active." -ForegroundColor Cyan
                 powercfg /setactive $UltimatePerformanceGuid
             } else {
                 Write-Warning "Could not enable Ultimate Performance plan. Setting High Performance as active instead."
                 powercfg /setactive $HighPerformanceGuid
             }
        } catch {
            Write-Warning "Error trying to unhide Ultimate Performance plan: $($_.Exception.Message)"
            Write-Warning "Setting High Performance as active instead."
            powercfg /setactive $HighPerformanceGuid
        }
    }

    # Verify active plan
    $ActivePlan = powercfg /getactivescheme
    Write-Host "Current active power plan:" -ForegroundColor Cyan
    Write-Host $ActivePlan
    Write-Host "Power Plan optimization applied." -ForegroundColor Green
}

# ==================================================
# SECTION 2: Visual Effects Optimization
# ==================================================
Write-Host "`n[Section 2] Visual Effects Optimization" -ForegroundColor Green
Write-Host "Adjusting visual effects for best performance. This reduces UI lag."

if (Confirm-Action "Adjust Visual Effects for Performance?") {
    try {
        # Set Visual Effects for Best Performance using SystemPropertiesPerformance
        # This command opens the Performance Options window, preset to 'Adjust for best performance'
        # User interaction is required here to click 'Apply' or 'OK'.
        # An alternative registry method is more complex to set ALL options reliably.

        # Method 1: Registry (Sets the preset option, may require logout/restart)
         Write-Host "Applying 'Adjust for best performance' preset via registry..." -ForegroundColor Cyan
         # This sets the *preset* value, which then influences individual settings upon next Perf Options check.
         Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 3 -Force

         # Method 2: Launching the GUI (More reliable for immediate effect, requires user interaction)
         # Write-Host "Opening Performance Options window. Please select 'Adjust for best performance' and click OK." -ForegroundColor Cyan
         # Start-Process SystemPropertiesPerformance

         Write-Host "Visual Effects setting applied (may require logout/restart for full effect)." -ForegroundColor Green
         Write-Host "If you prefer some effects back (like font smoothing), you can re-enable them manually via 'Adjust the appearance and performance of Windows'." -ForegroundColor Yellow
    } catch {
        Write-Warning "Failed to adjust visual effects: $($_.Exception.Message)"
    }
}

# ==================================================
# SECTION 3: Gaming Optimizations
# ==================================================
Write-Host "`n[Section 3] Gaming Optimizations" -ForegroundColor Green
Write-Host "Enabling Game Mode and disabling features that can interfere with gaming."

if (Confirm-Action "Apply Gaming specific optimizations (Game Mode, etc.)?") {
    try {
        # Enable Game Mode (User Level Setting)
        Write-Host "Enabling Game Mode..." -ForegroundColor Cyan
        # Requires registry manipulation as there's no direct cmdlet.
        $GameBarRegPath = "HKCU:\Software\Microsoft\GameBar"
        if (-not (Test-Path $GameBarRegPath)) { New-Item -Path $GameBarRegPath -Force | Out-Null }
        Set-ItemProperty -Path $GameBarRegPath -Name "UseNexusForGameBarEnabled" -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $GameBarRegPath -Name "AllowAutoGameMode" -Value 1 -Type DWord -Force # Allow Windows to automatically detect and optimize

        # Disable Game DVR Background Recording (Can consume resources) - Policy level
        Write-Host "Disabling Game DVR Background Recording (if enabled by policy)..." -ForegroundColor Cyan
        $GameDVRPolicyPath = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR"
        if (Test-Path $GameDVRPolicyPath) {
            Set-ItemProperty -Path $GameDVRPolicyPath -Name "value" -Value 0 -Type DWord -Force
        } else {
            Write-Host "Game DVR policy key not found, likely not enabled by policy." -ForegroundColor Yellow
        }

        # Disable Game Bar Tips (Optional annoyance reduction)
        # Set-ItemProperty -Path $GameBarRegPath -Name "ShowStartupPanel" -Value 0 -Type DWord -Force

        # Set GPU Preference for Specific Games (Manual Step Recommendation)
        Write-Host "Recommendation: For best performance, manually set specific games to 'High Performance' GPU." -ForegroundColor Yellow
        Write-Host "Go to: Settings > System > Display > Graphics. Add your game executable and set preference." -ForegroundColor Yellow

        Write-Host "Gaming optimizations applied." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to apply some gaming optimizations: $($_.Exception.Message)"
    }
}

# ==================================================
# SECTION 4: Network Optimization (Advanced - Use with Caution)
# ==================================================
Write-Host "`n[Section 4] Network Optimization (Advanced)" -ForegroundColor Green
Write-Host "*** WARNING: Network tweaks can potentially cause connectivity issues on some systems. ***" -ForegroundColor Red
Write-Host "These settings aim to reduce latency and improve throughput for gaming/general use."

if (Confirm-Action "Apply ADVANCED Network optimizations? (Potential Risk)") {
    try {
        # --- TCP/IP Tuning ---
        Write-Host "Applying TCP/IP tuning parameters..." -ForegroundColor Cyan

        # Set TCP Auto-Tuning Level to Normal (Often recommended over Disabled/Restricted for modern networks)
        Write-Host "- Setting TCP Auto-Tuning to 'Normal'" -ForegroundColor Cyan
        netsh int tcp set global autotuninglevel=normal
        # Note: Some guides recommend 'disabled' for gaming, but 'normal' is generally better balanced.
        # To reverse: netsh int tcp set global autotuninglevel=normal (default)

        # Set Congestion Control Provider to CTCP (Compound TCP - often better for high-speed/latency)
        Write-Host "- Setting Congestion Control Provider to 'CTCP'" -ForegroundColor Cyan
        netsh int tcp set global congestionprovider=ctcp
        # To reverse: netsh int tcp set global congestionprovider=default (usually CUBIC)

        # Enable ECN Capability (Explicit Congestion Notification - can help reduce latency/jitter)
        Write-Host "- Enabling ECN Capability" -ForegroundColor Cyan
        netsh int tcp set global ecncapability=enabled
        # To reverse: netsh int tcp set global ecncapability=disabled

        # Disable Network Throttling (Prevents Windows from throttling non-multimedia network traffic)
        Write-Host "- Disabling Network Throttling" -ForegroundColor Cyan
        $NetThrottleRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Set-ItemProperty -Path $NetThrottleRegPath -Name "NetworkThrottlingIndex" -Value ([uint32]0xFFFFFFFF) -Type DWord -Force
        # To reverse: Delete the 'NetworkThrottlingIndex' value or set it to '10' (decimal) for default.

        # --- DNS Settings (Optional - Suggesting Cloudflare/Google) ---
        Write-Host "Optionally, consider changing DNS servers for potentially faster lookups." -ForegroundColor Yellow
        if (Confirm-Action "Do you want to change DNS servers to Cloudflare (1.1.1.1, 1.0.0.1)? (Requires identifying network adapter)") {
            Write-Host "Identifying active network adapters..." -ForegroundColor Cyan
            Get-NetAdapter | Where-Object {$_.Status -eq "Up"} | Format-Table Name, InterfaceDescription, Status
            $AdapterName = Read-Host "Enter the 'Name' of the network adapter you want to modify (e.g., Ethernet, Wi-Fi)"
            if ($AdapterName -and (Get-NetAdapter -Name $AdapterName -ErrorAction SilentlyContinue)) {
                Write-Host "Setting DNS for adapter '$AdapterName'..." -ForegroundColor Cyan
                try {
                    Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses ("1.1.1.1", "1.0.0.1")
                    Write-Host "DNS servers set to Cloudflare for $AdapterName." -ForegroundColor Green
                    Write-Host "Run 'ipconfig /flushdns' after script finishes." -ForegroundColor Yellow
                    # To reverse: Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ResetServerAddresses
                } catch {
                    Write-Warning "Failed to set DNS for $AdapterName. Error: $($_.Exception.Message)"
                    Write-Warning "You may need to set DNS manually via Network Adapter properties."
                }
            } else {
                Write-Warning "Invalid adapter name or adapter not found. Skipping DNS change."
            }
        }

        Write-Host "Advanced Network optimizations applied." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to apply some network optimizations: $($_.Exception.Message)"
    }
}

# ==================================================
# SECTION 5: Disable Non-Essential Services (Advanced - High Risk)
# ==================================================
Write-Host "`n[Section 5] Disable Non-Essential Services (Advanced - HIGH RISK)" -ForegroundColor Green
Write-Host "*** WARNING: Disabling services incorrectly can break Windows functionality! ***" -ForegroundColor Red -BackgroundColor Black
Write-Host "Only proceed if you understand the implications. These services are often cited for performance gains,"
Write-Host "but their necessity can vary. Disabling is aimed at freeing up RAM and CPU cycles."

if (Confirm-Action "Apply ADVANCED Service optimizations? (HIGH RISK - Understand the implications!)") {
    # Define services to potentially disable (User choice needed per service ideally, but bulk for script simplicity)
    # Add/Remove services based on research and personal needs. This list is aggressive.
    $ServicesToDisable = @(
        "DiagTrack",         # Connected User Experiences and Telemetry (Telemetry)
        "dmwappushservice",  # Device Management Wireless Application Protocol (WAP) Push message Routing Service (Telemetry/Device Mgmt)
        "DusmSvc",           # Data Usage Service (Network data tracking)
        "MapsBroker",        # Downloaded Maps Manager (If you don't use offline Maps app)
        "RemoteRegistry",    # Remote Registry (Security risk if not needed)
        "RetailDemo",        # Retail Demo Service (Useless unless PC is in retail demo mode)
        "SysMain",           # Superfetch/SysMain (Preloads apps. Disabling *can* help on SSDs/low RAM, but sometimes hurts. Controversial.)
        "TrkWks",            # Distributed Link Tracking Client (Tracks links across NTFS volumes, often unnecessary for home users)
        "lfsvc",             # Geolocation Service (If you don't use location features)
        "WSearch"            # Windows Search (If you don't use Windows search indexing often, frees up CPU/Disk IO)
        # Add more cautiously, e.g., Fax, Print Spooler (if no printer), etc.
    )

    Write-Host "The following services will be set to DISABLED:" -ForegroundColor Yellow
    $ServicesToDisable | ForEach-Object { Write-Host "- $_" }
    Write-Host "*** REVIEW THIS LIST CAREFULLY! ***" -ForegroundColor Red

    if (Confirm-Action "Confirm disabling the services listed above?") {
        foreach ($serviceName in $ServicesToDisable) {
            $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            if ($service) {
                if ($service.Status -eq 'Running') {
                    Write-Host "Stopping service: $serviceName..." -ForegroundColor Cyan
                    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
                }
                Write-Host "Setting service '$serviceName' startup type to Disabled..." -ForegroundColor Cyan
                try {
                    Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
                    Write-Host "'$serviceName' disabled." -ForegroundColor Green
                } catch {
                    Write-Warning "Failed to disable service '$serviceName'. Error: $($_.Exception.Message). It might be protected or already disabled."
                }
            } else {
                Write-Warning "Service '$serviceName' not found. Skipping."
            }
        }
        Write-Host "Service optimizations applied." -ForegroundColor Green
        Write-Host "To RE-ENABLE a service: Open Services (services.msc), find the service, change 'Startup type' back to 'Automatic' or 'Manual', and Start it." -ForegroundColor Yellow
    }
}

# ==================================================
# SECTION 6: Registry Tweaks (Advanced - Use with Caution)
# ==================================================
Write-Host "`n[Section 6] Registry Tweaks (Advanced)" -ForegroundColor Green
Write-Host "*** WARNING: Incorrect registry changes can cause system instability! ***" -ForegroundColor Red
Write-Host "Applying specific registry tweaks for performance and responsiveness."

if (Confirm-Action "Apply ADVANCED Registry tweaks? (Potential Risk)") {
    try {
        # --- Improve System Responsiveness ---
        Write-Host "Improving System Responsiveness (Favor foreground apps)..." -ForegroundColor Cyan
        $SystemProfilePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        if (-not (Test-Path $SystemProfilePath)) { New-Item -Path $SystemProfilePath -Force | Out-Null }
        # Higher value gives more resources to foreground apps (max FFFFFFFF hex = 4294967295 dec)
        Set-ItemProperty -Path $SystemProfilePath -Name "SystemResponsiveness" -Value ([uint32]0x0000000a) -Type DWord -Force # Using 10 (Decimal) as a common tweak, adjust if needed. Use 0 for pure gaming focus? Maybe too extreme.
        # To reverse: Delete the 'SystemResponsiveness' value.

        # --- Disable Cortana (If desired - Reduces background activity) ---
         Write-Host "Disabling Cortana (Setting via Policy)..." -ForegroundColor Cyan
         $CortanaPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" # Policy path takes precedence
         if (-not (Test-Path $CortanaPolicyPath)) { New-Item -Path $CortanaPolicyPath -Force -Recurse | Out-Null }
         Set-ItemProperty -Path $CortanaPolicyPath -Name "AllowCortana" -Value 0 -Type DWord -Force
         # To reverse: Set 'AllowCortana' value to 1 or delete the value.

        # --- Disable Telemetry (More aggressive than default settings) ---
         Write-Host "Applying stricter Telemetry disabling via registry..." -ForegroundColor Cyan
         $DataCollectionPolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
         if (-not (Test-Path $DataCollectionPolicyPath)) { New-Item -Path $DataCollectionPolicyPath -Force | Out-Null }
         # 0 = Security (Enterprise only), 1 = Basic, 2 = Enhanced, 3 = Full. Setting to 0 might revert on non-Enterprise. 1 is safer.
         Set-ItemProperty -Path $DataCollectionPolicyPath -Name "AllowTelemetry" -Value 0 -Type DWord -Force # Attempting most restricted
         # To reverse: Set 'AllowTelemetry' value to 1 (Basic) or higher, or delete the value to use Windows Settings choice.

         # --- Disable Delivery Optimization Downloads from Peers ---
         Write-Host "Disabling Delivery Optimization downloads from other PCs..." -ForegroundColor Cyan
         $DeliveryOptPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
         Set-ItemProperty -Path $DeliveryOptPath -Name "DownloadMode" -Value 0 -Type DWord -Force # 0 = HTTP Only, no peering
         Set-ItemProperty -Path $DeliveryOptPath -Name "DODownloadMode" -Value 0 -Type DWord -Force # Newer setting name
         # To reverse: Set DownloadMode / DODownloadMode to 1 (LAN Peering) or 2 (Internet Peering), or delete values.

        Write-Host "Registry tweaks applied. A RESTART is required for most registry changes." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to apply some registry tweaks: $($_.Exception.Message)"
    }
}

# ==================================================
# SECTION 7: Disk Optimization & Cleanup
# ==================================================
Write-Host "`n[Section 7] Disk Optimization & Cleanup" -ForegroundColor Green
Write-Host "Running Disk Optimization (TRIM for SSDs, Defrag for HDDs) and launching Disk Cleanup."

if (Confirm-Action "Run Disk Optimization and launch Disk Cleanup?") {
    # --- Optimize Drives ---
    Write-Host "Optimizing system drive (TRIM/Defrag)..." -ForegroundColor Cyan
    try {
        $SystemDrive = $env:SystemDrive
        $DriveData = Get-Volume -DriveLetter ($SystemDrive -replace ':') | Get-Partition | Get-Disk | Get-PhysicalDisk | Select-Object FriendlyName, MediaType
        $MediaType = $DriveData.MediaType

        Write-Host "System drive ($SystemDrive) detected as: $MediaType" -ForegroundColor Cyan

        if ($MediaType -eq "SSD") {
            Write-Host "Running TRIM (Optimize) on SSD..." -ForegroundColor Cyan
            Optimize-Volume -DriveLetter ($SystemDrive -replace ':') -ReTrim -Verbose
        } elseif ($MediaType -eq "HDD") {
            Write-Host "Running Defrag (Optimize) on HDD..." -ForegroundColor Cyan
            # Note: Full defrag can take a long time. Analyze first? Or just run optimize.
            Optimize-Volume -DriveLetter ($SystemDrive -replace ':') -Defrag -Verbose
        } else {
            Write-Host "Running standard Optimize on unknown or other media type..." -ForegroundColor Cyan
            Optimize-Volume -DriveLetter ($SystemDrive -replace ':') -Verbose
        }
        Write-Host "Disk Optimization completed for $SystemDrive." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to optimize drive $SystemDrive. Error: $($_.Exception.Message)"
    }

    # --- Launch Disk Cleanup ---
    Write-Host "Launching Disk Cleanup utility (cleanmgr.exe)..." -ForegroundColor Cyan
    Write-Host "Please select the items you want to clean and click OK." -ForegroundColor Yellow
    try {
        # Note: /SAGERUN requires prior /SAGESET setup. Launching interactively is safer.
        Start-Process cleanmgr.exe -ArgumentList "/d $env:SystemDrive"
        Write-Host "Disk Cleanup launched. Please review and confirm cleanup actions in the tool." -ForegroundColor Green
    } catch {
        Write-Warning "Failed to launch Disk Cleanup. You can run it manually by searching 'Disk Cleanup'."
    }
}


# ==================================================
# SECTION 8: System File Check & Repair
# ==================================================
Write-Host "`n[Section 8] System File Check & Repair" -ForegroundColor Green
Write-Host "Running System File Checker (SFC) and DISM RestoreHealth to check for and repair system file corruption."
Write-Host "This can take some time and might help with instability or strange issues."

if (Confirm-Action "Run SFC and DISM system checks? (Can take a while)") {
    try {
        Write-Host "Running SFC /scannow... Please wait, this may take 5-15 minutes." -ForegroundColor Cyan
        sfc /scannow
        Write-Host "SFC scan completed." -ForegroundColor Green

        Write-Host "`nRunning DISM /Online /Cleanup-Image /RestoreHealth... Please wait, this may take longer." -ForegroundColor Cyan
        DISM /Online /Cleanup-Image /RestoreHealth
        Write-Host "DISM scan completed." -ForegroundColor Green
    } catch {
        Write-Warning "An error occurred during SFC or DISM execution: $($_.Exception.Message)"
    }
}

# ==================================================
# Completion
# ==================================================
Write-Host "`n--------------------------------------------------"
Write-Host " Optimization Script Completed!" -ForegroundColor Green
Write-Host "--------------------------------------------------`n"
Write-Host "*** A system RESTART is STRONGLY RECOMMENDED for all changes to take full effect! ***" -ForegroundColor Yellow

# Ask user if they want to restart now
if (Confirm-Action "Do you want to restart your computer now?") {
    Write-Host "Restarting computer in 5 seconds..." -ForegroundColor Cyan
    Start-Sleep -Seconds 5
    Restart-Computer -Force
} else {
    Write-Host "Please remember to restart your computer soon." -ForegroundColor Yellow
}

Read-Host "Press Enter to exit the script..."
