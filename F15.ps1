<#
.SYNOPSIS
    PROJECT HYPERION (v2.0): MASSIVE, HIGHLY VERBOSE, CONFIGURABLE, EXTREME RISK AIO SCRIPT (Approx. 3000-6000 Lines).
    Designed for ABSOLUTE MAXIMUM performance philosophy, sacrificing stability, security, and longevity.

.DESCRIPTION
    A comprehensive, heavily commented, and function-driven PowerShell script performing extreme system modifications.
    - Fully Automated Execution (Admin check, countdown, optional auto-restart).
    - Centralized Configuration Block (`$Configuration`) for granular control (within script).
    - Extensive Logging (Console & File via Start-Transcript).
    - Phase-based execution with enable/disable flags.
    - Ultimate Performance Power Plan & Aggressive Power Saving Disablement.
    - EXTREME attempt to permanently disable Windows Defender & Tamper Protection (HIGHLY RISKY, NOT GUARANTEED).
    - Aggressive disabling of numerous Services & Scheduled Tasks (BREAKS FEATURES - e.g., Search).
    - Advanced Network Tweaks (TCP Settings, Adapter Properties - Experimental).
    - Automatic Pagefile Management.
    - RAM Clearing Task (Experimental).
    - Desktop Icon Management.
    - Startup Cleanup Task Creation.
    - Automated Software Installation via Winget (User MUST configure list).
    - Attempt to Set Default Browser (Chrome - User configurable, MAY FAIL).
    - Visual Effects optimization for performance.
    - Hardware Information Check.
    - Automated Windows Update run (using PSWindowsUpdate).
    - Comprehensive System Cleanup (Temp files, DNS Cache, DISM, Optional WinSxS ResetBase, fstrim).
    - Detailed Pre-Checks and some Post-Checks.

.NOTES
    Author: AI Assistant (Based on Extreme User Specification)
    Version: 2.0 "Hyperion"
    Target Line Count: ~3500+ lines
    Requires:
        - Windows 10 / 11 (Untested on others).
        - Administrator privileges (MANDATORY).
        - Internet connection (for WU, Winget, PSWindowsUpdate module).
        - User review and modification of the `$Configuration` block, especially `$Configuration.Software.WingetPackages`.
        - Significant free disk space for WU/DISM.
        - Understanding and acceptance of EXTREME risks.

    Disclaimer:
        RUNNING THIS SCRIPT IS ENTIRELY AT YOUR OWN RISK. THE AUTHOR (AI ASSISTANT) PROVIDES NO WARRANTY
        AND ASSUMES NO LIABILITY FOR ANY DAMAGE, DATA LOSS, SECURITY BREACHES, SYSTEM INSTABILITY,
        HARDWARE FAILURE, OR ANY OTHER NEGATIVE CONSEQUENCES RESULTING FROM ITS USE.
        THIS SCRIPT DISABLES CRITICAL SECURITY FEATURES AND MAY RENDER YOUR SYSTEM UNSTABLE OR UNUSABLE.
        THERE IS NO AUTOMATED UNDO FUNCTION. BACKUP YOUR SYSTEM BEFORE EVEN CONSIDERING RUNNING THIS.
#>

#-----------------------------------------------------------------------------------------------------------------------
# SCRIPT START
#-----------------------------------------------------------------------------------------------------------------------

#region --- Global Settings & Configuration ---

# Strict Mode for better error checking
Set-StrictMode -Version Latest

# Central Configuration Hashtable
# Modify values here to control script behavior.
$Configuration = @{
    # General Script Behavior
    ScriptName = "Project Hyperion AIO Script"
    ScriptVersion = "2.0"
    LogDirectory = "C:\Logs" # Directory to store transcript logs
    LogFileName = "Hyperion_AIO_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    EnableTranscriptLogging = $true # Set to $false to disable file logging
    ForceAutoRestart = $true # Set to $false to prevent automatic restart at the end
    FinalWarningCountdownSeconds = 15 # Seconds for the final warning countdown

    # Phase Enable/Disable Flags (Set to $false to skip a phase entirely)
    EnablePhase_CheckAdmin = $true
    EnablePhase_TamperProtection = $true
    EnablePhase_PowerSettings = $true
    EnablePhase_ServiceDisabling = $true
    EnablePhase_NetworkTweaks = $true
    EnablePhase_PagefileManagement = $true
    EnablePhase_SystemRegistryTweaks = $true
    EnablePhase_ScheduledTaskDisabling = $true
    EnablePhase_DesktopIcons = $true
    EnablePhase_StartupCleanupTask = $true
    EnablePhase_RAMManagementTask = $true
    EnablePhase_DefenderDisable = $true # EXTREME RISK
    EnablePhase_SoftwareInstallation = $true
    EnablePhase_SetDefaultBrowser = $true # Attempt only
    EnablePhase_VisualEffects = $true
    EnablePhase_HardwareCheck = $true
    EnablePhase_WindowsUpdate = $true
    EnablePhase_SystemCleanup = $true

    # Phase 0: Tamper Protection Configuration
    TamperProtection = @{
        RegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
        RegistryValueName = "TamperProtection"
        TargetValue = 0 # 0 = Disabled
    }

    # Phase 1: Power Settings Configuration
    Power = @{
        TargetPlan = "Ultimate" # Options: "Ultimate", "High" (Fallback if Ultimate fails), or provide GUID
        UltimatePlanGUID = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        HighPerformancePlanGUID = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        # Specific settings (0 = Never/Off, 100 = Max %) - Applied to AC and DC
        Settings = @{
            "SUB_SLEEP/SLEEPIDLE" = 0       # Sleep After
            "SUB_SLEEP/HIBERNATEIDLE" = 0   # Hibernate After
            "SUB_VIDEO/VIDEOIDLE" = 0       # Turn off display after
            "SUB_BUTTONS/LIDCLOSEACTION" = 0 # Lid close action
            "SUB_PROCESSOR/PROCTHROTTLEMIN" = 100 # Minimum processor state
            "SUB_PROCESSOR/PROCTHROTTLEMAX" = 100 # Maximum processor state
            "SUB_PCIEXPRESS/ASPM" = 0       # PCI Express Link State Power Management
        }
        DisablePowerThrottling = $true # Attempt via HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling
    }

    # Phase 2: Service Disabling Configuration (EXTREME RISK - Review Carefully!)
    Services = @{
        # Format: ServiceName = "Reason for Disabling (Risk Level)"
        ServicesToDisable = @{
            # Telemetry & Diagnostics (Privacy/Performance - Low/Medium Risk)
            "DiagTrack" = "Connected User Experiences and Telemetry (Privacy)"
            "dmwappushservice" = "WAP Push Message Routing Service (Often Unneeded)"
            "diagnosticshub.standardcollector.service" = "Diagnostics Hub Collector (Developer/Diagnostics)"
            "WerSvc" = "Windows Error Reporting (Can be useful, but noisy)"
            # Location & Maps (Privacy/Performance if unused - Low Risk)
            "lfsvc" = "Geolocation Service (Privacy if unused)"
            "MapsBroker" = "Downloaded Maps Manager (Performance if unused)"
            # Printing & Fax (Performance if unused - Low Risk)
            "Spooler" = "Print Spooler (DISABLES PRINTING!)"
            "Fax" = "Fax Service (DISABLES FAXING!)"
            # Remote Services (Security/Performance if unused - Medium Risk)
            "RemoteRegistry" = "Remote Registry Access (Security Risk if enabled)"
            "TermService" = "Remote Desktop Services (DISABLES RDP HOSTING!)"
            # Search (!!! HIGH RISK - BREAKS SEARCH FUNCTIONALITY !!!)
            "WSearch" = "Windows Search (Performance Gain BUT BREAKS SEARCH EVERYWHERE!)"
            # Performance Related / Often Tweaked (Medium Risk - May affect boot/responsiveness)
            "SysMain" = "SysMain/Superfetch (Mixed results, can reduce RAM usage but slow down app loading)"
            # User Experience / Assistants (Low/Medium Risk - May disable niche features)
            "PcaSvc" = "Program Compatibility Assistant (Can be annoying, sometimes helpful)"
            "CDPSvc" = "Connected Devices Platform Service (Nearby sharing, phone linking)"
            "ConsentUxUserSvc" = "Consent UX (Related to UAC prompts appearance)" # Check name pattern ConsentUxUserSvc_xxxxx
            # Xbox (Performance if unused - Low Risk)
            "XblAuthManager" = "Xbox Live Auth Manager (Xbox/Game Bar)"
            "XblGameSave" = "Xbox Live Game Save (Xbox/Game Bar)"
            "XboxGipSvc" = "Xbox Accessory Management Service (Xbox Controllers)"
            "XboxNetApiSvc" = "Xbox Live Networking Service (Xbox/Game Bar)"
            # Delivery Optimization (Performance/Network - Low Risk if not needed)
            "DoSvc" = "Delivery Optimization (Updates for other PCs)"
            # Sensors (Performance on Desktops - Low Risk)
            "SensorDataService" = "Sensor Data Service"
            "SensorService" = "Sensor Service"
            "SensrSvc" = "Sensor Monitoring Service"
            # Biometrics (Performance if unused - Low Risk)
            "WbioSrvc" = "Windows Biometric Service (DISABLES FINGERPRINT/FACIAL RECOGNITION!)"
            # Others (Review based on usage - Low/Medium Risk)
            "icssvc" = "Windows Mobile Hotspot Service (Disable if unused)"
            "SEMgrSvc" = "Payments and NFC/SE Manager (Disable if unused)"
            "AJRouter" = "AllJoyn Router Service (IoT communication - Disable if unused)"
            "WalletService" = "Microsoft Wallet Service (Disable if unused)"
            "MessagingService" = "Microsoft Messaging Service (May relate to SMS/Apps)" # Check name pattern MessagingService_xxxxx
            "OneSyncSvc" = "Sync Host (Mail, Calendar, Contacts sync)" # Check name pattern OneSyncSvc_xxxxx
            "UserDataSvc" = "User Data Access (Related to sync)" # Check name pattern UserDataSvc_xxxxx
            "WpnUserService" = "Windows Push Notifications User Service" # Check name pattern WpnUserService_xxxxx
        }
    }

    # Phase 3: Network Tweaks Configuration
    Network = @{
        SetGoogleDNS = $true # Set 8.8.8.8, 8.8.4.4 for active adapters
        FlushDNS = $true
        # Netsh TCP Global Settings
        TCPGlobal = @{
            "autotuninglevel" = "disabled" # Can sometimes hinder high-latency connections
            "rss" = "enabled"              # Recommended for multi-core CPUs
            "ecncapability" = "enabled"    # Explicit Congestion Notification
            #"chimney" = "automatic"       # Offload State (Requires NIC support) - automatic is safer than enabled
            #"netdma" = "enabled"          # Direct Memory Access (Requires support) - Risky if unsupported
            #"dca" = "enabled"             # Direct Cache Access (Requires CPU/Chipset/NIC support) - Risky if unsupported
            "congestionprovider" = "ctcp" # Compound TCP (Good for high BDP), "cubic" is another option
        }
        # Advanced TCP Settings (Set-NetTCPSetting) - Experimental, may require specific scenarios
        EnableAdvancedTCPSettings = $true
        TCPSettings = @{ # Applied to common profiles like InternetCustom, DatacenterCustom
            "InitialRto" = 2000 # Initial Retransmission Timeout (ms) - Default 3000, lower might speed up recovery on good nets
            "MinRto" = 300 # Minimum Retransmission Timeout (ms) - Default 300
            #"ScalingHeuristics" = "Disabled" # May help if Windows incorrectly limits TCP Window Scaling
            #"Timestamps" = "Disabled" # Can save header overhead, but potentially breaks some things - Default Enabled
        }
        # Advanced Adapter Properties (Set-NetAdapterAdvancedProperty) - HIGHLY HARDWARE DEPENDENT!
        EnableAdvancedAdapterSettings = $true
        AdapterProperties = @( # List of properties to TRY setting on UP adapters
            @{ Name = "*TCPChecksumOffloadIPv4"; DisplayValue = "Tx & Rx Enabled"; RegistryValue = "3" }
            @{ Name = "*UDPChecksumOffloadIPv4"; DisplayValue = "Tx & Rx Enabled"; RegistryValue = "3" }
            @{ Name = "*TCPChecksumOffloadIPv6"; DisplayValue = "Tx & Rx Enabled"; RegistryValue = "3" }
            @{ Name = "*UDPChecksumOffloadIPv6"; DisplayValue = "Tx & Rx Enabled"; RegistryValue = "3" }
            @{ Name = "Large Send Offload V2 (IPv4)"; DisplayValue = "Enabled"; RegistryValue = "1" }
            @{ Name = "Large Send Offload V2 (IPv6)"; DisplayValue = "Enabled"; RegistryValue = "1" }
            @{ Name = "Interrupt Moderation"; DisplayValue = "Disabled"; RegistryValue = "0" } # Lower latency, higher CPU
            @{ Name = "Receive Side Scaling"; DisplayValue = "Enabled"; RegistryValue = "1" } # Should be enabled with RSS global
            @{ Name = "Flow Control"; DisplayValue = "Disabled"; RegistryValue = "0" } # Often recommended disabled for performance desktops
            @{ Name = "*InterruptModerationRate"; DisplayValue = "Off"; RegistryValue = "0" } # More specific Interrupt Moderation control (Intel)
            @{ Name = "*ReceiveBuffers"; DisplayValue = "2048"; RegistryValue = "2048" } # Increase buffer size (May need tuning) - Example value!
            @{ Name = "*TransmitBuffers"; DisplayValue = "2048"; RegistryValue = "2048" } # Increase buffer size (May need tuning) - Example value!
        )
    }

    # Phase 4: Pagefile Management Configuration
    Pagefile = @{
        ManagePagefile = $true
        TargetDrive = "C:" # Drive to place the pagefile
        RemovePagefilesOnOtherDrives = $true
        CalculationMethod = "RAMMultiple" # Options: "RAMMultiple", "FixedSize"
        RAMMultipleFactor = 1.5 # Multiplier for RAM size (used if CalculationMethod is RAMMultiple)
        MaxSizeMB = 32768 # Maximum cap in MB (e.g., 32GB)
        FixedSizeMB = 16384 # Fixed size in MB (used if CalculationMethod is FixedSize)
    }

    # Phase 5: System & Registry Tweaks Configuration
    SystemTweaks = @{
        # File System Tweaks
        NtfsDisableLastAccessUpdate = $true # Reduces disk I/O for last access timestamp
        NtfsMemoryUsage = 2 # 2 = Increase file system cache size (Default is 0 or 1)
        # UI Responsiveness Tweaks
        MenuShowDelay = "20" # ms, Default 400
        MouseHoverTime = "20" # ms, Default 400
        # Shutdown/Timeout Tweaks
        WaitToKillAppTimeout = "2000" # ms, Default 5000
        HungAppTimeout = "2000" # ms, Default 5000
        WaitToKillServiceTimeout = "2000" # ms, Default 5000
        # Memory Management Tweaks (Experimental)
        EnableMemoryTweaks = $true
        LargeSystemCache = 1 # 1 = Favor system cache over working set (Often for File Servers, but some claim desktop benefit) - Default 0
        # Other potential tweaks (Add with caution)
        DisableSuperfetchParameters = $true # Set EnableSuperfetch=0, EnablePrefetcher=0 in HKLM\...\Memory Management\PrefetchParameters
    }

    # Phase 6: Scheduled Task Disabling Configuration (Review Carefully!)
    ScheduledTasks = @{
        TasksToDisable = @( # Provide full path of the task
            # Application Experience
            '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser',
            '\Microsoft\Windows\Application Experience\ProgramDataUpdater',
            '\Microsoft\Windows\Application Experience\StartupAppTask',
            # Customer Experience Improvement Program (CEIP)
            '\Microsoft\Windows\Customer Experience Improvement Program\Consolidator',
            '\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask',
            '\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip',
            # Windows Defender (May be re-enabled by Defender itself)
            '\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance',
            '\Microsoft\Windows\Windows Defender\Windows Defender Cleanup',
            '\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan',
            '\Microsoft\Windows\Windows Defender\Windows Defender Verification',
            # Windows Update / Orchestrator (Disabling may break WU functionality)
            '\Microsoft\Windows\UpdateOrchestrator\Schedule Scan',
            '\Microsoft\Windows\UpdateOrchestrator\Schedule Wake To Run',
            '\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker',
            '\Microsoft\Windows\UpdateOrchestrator\Backup Scan',
            '\Microsoft\Windows\UpdateOrchestrator\Policy Install',
            '\Microsoft\Windows\UpdateOrchestrator\Refresh Settings',
            '\Microsoft\Windows\UpdateOrchestrator\Resume On Boot',
            # Maintenance & Diagnostics
            '\Microsoft\Windows\Diagnosis\Scheduled',
            '\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector',
            '\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver',
            '\Microsoft\Windows\Maintenance\WinSAT', # Windows System Assessment Tool
            '\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents',
            '\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic',
            '\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem',
            '\Microsoft\Windows\Sysmain\WsSwapAssessmentTask', # Related to SysMain/Superfetch
            # Other Telemetry / Data Collection
            '\Microsoft\Windows\Autochk\Proxy',
            '\Microsoft\Windows\DiskFootprint\Diagnostics',
            '\Microsoft\Windows\Feedback\Siuf\DmClient',
            '\Microsoft\Windows\NetTrace\GatherNetworkInfo',
            '\Microsoft\Windows\PI\Sqm-Tasks',
            # Windows App Related (If not using certain features)
            '\Microsoft\Windows\AppID\SmartScreenSpecific',
            '\Microsoft\Windows\ApplicationData\DsSvcCleanup',
            '\Microsoft\Windows\CloudExperienceHost\CreateObjectTask',
            '\Microsoft\Windows\InstallService\ScanForUpdates',
            '\Microsoft\Windows\Maps\MapsToastTask',
            '\Microsoft\Windows\Maps\MapsUpdateTask',
            '\Microsoft\Windows\SettingSync\BackgroundUploadTask',
            '\Microsoft\Windows\SettingSync\NetworkStateChangeTask',
            '\Microsoft\Windows\Shell\FamilySafetyMonitor',
            '\Microsoft\Windows\Shell\FamilySafetyRefreshTask',
            '\Microsoft\Windows\Speech\SpeechModelDownloadTask',
            '\Microsoft\Windows\Subscription\LicenseAcquisition',
            '\Microsoft\Windows\Windows Error Reporting\QueueReporting',
            '\Microsoft\Windows\WOF\WIM-Hash-Management',
            '\Microsoft\Windows\WOF\WIM-Hash-Validation'
            # Add more tasks here WITH EXTREME CAUTION - check what they do first!
        )
    }

    # Phase 7: Desktop Icons Configuration
    DesktopIcons = @{
        ShowThisPC = $true
        ShowNetwork = $true
        ShowRecycleBin = $true # Note: Recycle bin is usually shown by default
        ShowControlPanel = $false # Optional
        ShowUserFiles = $false # Optional
    }

    # Phase 8: Startup Cleanup Task Configuration
    StartupCleanup = @{
        TaskName = "AutoCacheCleanup_Hyperion"
        ScriptFileName = "Hyperion_StartupCleanup.ps1"
        ScriptPath = "C:\Windows\Temp" # Where to store the generated cleanup script
        # What to clean in the generated script:
        CleanSystemTemp = $true
        CleanUserProfileTemp = $true # Cleans AppData\Local\Temp for all users
        CleanWindowsUpdateCache = $true
        CleanWindowsOld = $true # Removes C:\Windows.old if it exists
        CleanBrowserCaches = $true # Attempts for Chrome, Edge, Firefox, Brave (Default Profiles)
        CleanEventLogs = $false # Optional: Clear common event logs (Application, System, Security) - Use with caution
        # Event logs to clear if CleanEventLogs is $true
        EventLogsToClear = @("Application", "System", "Security", "Microsoft-Windows-Diagnosis-Scripted/Admin", "Microsoft-Windows-PushNotification-Platform/Operational")
    }

    # Phase 9: RAM Management Task Configuration
    RAMManagement = @{
        EnableAggressiveRAMTask = $true
        TaskName = "AggressiveRAMIdleTask_Hyperion"
        ExecutionIntervalMinutes = 30
        CommandToExecute = "rundll32.exe"
        CommandArguments = "advapi32.dll,ProcessIdleTasks"
    }

    # Phase 10: Windows Defender Disable Configuration (EXTREME RISK!)
    Defender = @{
        # Requires successful Tamper Protection disable (Phase 0)
        AttemptEnhancedDisable = $true # Set to $false to only use basic registry/service disable
        # Registry Keys/Values (Attempted if AttemptEnhancedDisable is true)
        PolicyKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"
        RealTimeKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection"
        FeaturesKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features"
        SpynetKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet"
        MpEngineKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\MpEngine" # Forcing engine version? Risky.
        SignatureKey = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Signature Updates" # FallbackInterval?

        SettingsToApply = @(
            @{ Path = $PolicyKey; Name = "DisableAntiSpyware"; Value = 1; Type = "DWord" } # Main disable flag (Policy)
            @{ Path = $PolicyKey; Name = "DisableRealtimeMonitoring"; Value = 1; Type = "DWord" } # Duplicate/Alternative to below?
            @{ Path = $RealTimeKey; Name = "DisableRealtimeMonitoring"; Value = 1; Type = "DWord" } # Main RTP flag
            @{ Path = $RealTimeKey; Name = "DisableBehaviorMonitoring"; Value = 1; Type = "DWord" }
            @{ Path = $RealTimeKey; Name = "DisableOnAccessProtection"; Value = 1; Type = "DWord" }
            @{ Path = $RealTimeKey; Name = "DisableScanOnRealtimeEnable"; Value = 1; Type = "DWord" }
            @{ Path = $RealTimeKey; Name = "DisableIOAVProtection"; Value = 1; Type = "DWord" }
            @{ Path = $SpynetKey; Name = "SpyNetReporting"; Value = 0; Type = "DWord" } # Disable MAPS reporting
            @{ Path = $SpynetKey; Name = "SubmitSamplesConsent"; Value = 0; Type = "DWord" } # Disable Sample Submission
            @{ Path = $SignatureKey; Name = "FallbackOrder"; Value = "" } # Attempt to disable signature updates? Risky. Remove value?
            # @{ Path = $MpEngineKey; Name = "MpEngineVersion"; Value = "0.0.0.0" } # Forcing engine version? EXTREMELY RISKY
            @{ Path = $FeaturesKey; Name = "TamperProtection"; Value = 0; Type = "DWord" } # Reinforce TP disable
        )
        # Services to attempt disabling (Will likely fail if TP is active)
        ServicesToDisable = @("WinDefend", "Sense", "WdNisSvc", "SecurityHealthService", "mpssvc", "MsMpEng") # Added MsMpEng
    }

    # Phase 11: Software Installation Configuration
    Software = @{
        InstallViaWinget = $true
        # --- !!! USER MUST EDIT THIS LIST !!! ---
        # Find IDs using 'winget search <AppName>'
        WingetPackages = @(
            "Google.Chrome",          # Must be included if SetDefaultBrowserFor is Chrome
            "Mozilla.Firefox",
            "7zip.7zip",
            "VideoLAN.VLC",
            "Notepad++.Notepad++",
            "Microsoft.PowerToys",    # Example
            "Microsoft.VisualStudioCode" # Example
        )
        # --- !!! END OF USER EDITABLE LIST !!! ---
        WingetInstallOptions = "-e --silent --accept-source-agreements --accept-package-agreements --force --disable-interactivity"
    }

    # Phase 12: Set Default Browser Configuration
    DefaultBrowser = @{
        AttemptSetDefault = $true
        BrowserToSet = "Chrome" # Options: "Chrome", "Firefox", "Edge" (Edge might reset itself) - MUST MATCH AN INSTALLED BROWSER ID IN WingetPackages
        # Internal mapping - Do not change unless ProgIDs change significantly
        ProgIdMapping = @{
            "Chrome" = "ChromeHTML"
            "Firefox" = "FirefoxURL" # Check exact ProgId for Firefox if needed
            "Edge" = "MSEdgeHTM"
        }
        # Registry path structure
        UrlAssociationsPath = "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations"
        ProtocolsToSet = @("http", "https")
    }

    # Phase 13: Visual Effects Configuration
    VisualEffects = @{
        OptimizeForPerformance = $true # If true, disables most visual effects
        # Specific settings controlled via SPI actions or registry (if OptimizeForPerformance is true)
        # UserPreferencesMask (Bitmask - complex to set directly)
        # We will use SystemPropertiesPerformance UI automation or direct registry tweaks
        RegistrySettings = @{ # Applied if OptimizeForPerformance is true
            # HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects
            "VisualFXSetting" = 3 # 1=Best Appearance, 2=Best Performance, 3=Custom
            # HKEY_CURRENT_USER\Control Panel\Desktop - Controls individual effects (0=Disabled, 1=Enabled)
            "UserPreferencesMask" = [byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00) # Typical "Best Performance" mask - Use with caution!
            # Specific SPI Actions (can use Set-ItemProperty on HKCU\Control Panel\Desktop for some)
            "DragFullWindows" = "0" # Don't show window contents while dragging
            "FontSmoothing" = "2" # Standard=1, ClearType=2, Disabled=0 - Keep ClearType for readability (2)
            #"DropShadow" = "0" # Disable shadows under windows
            #"ListviewAlphaSelect" = "0" # Disable fade effect on selection
            #"TooltipAnimation" = "0" # Disable tooltip fade/slide
            # Add more if needed from SPI constants (SystemParametersInfo)
        }
    }

    # Phase 14: Hardware Check Configuration
    HardwareCheck = @{
        EnableCheck = $true
        CheckGPU = $true
        CheckNetwork = $true
        CheckCPU = $true
        CheckRAM = $true
        CheckDisk = $true
    }

    # Phase 15: Windows Update Configuration
    WindowsUpdate = @{
        RunUpdate = $true
        InstallPSWindowsUpdateModule = $true
        PSWindowsUpdateArgs = @{ # Arguments for Get-WindowsUpdate
            Install = $true
            AcceptAll = $true
            ForceDownload = $true
            ForceInstall = $true
            Verbose = $true
            # AutoReboot = $false # Let the main script handle reboot
            # Criteria = "IsInstalled=0 and Type='Software'" # Example: Only Software updates
        }
        RequiredFreeSpaceGB = 15 # Minimum GB free space required on C: before running WU
    }

    # Phase 16: System Cleanup Configuration
    SystemCleanup = @{
        EnableCleanup = $true
        CleanStandardTemp = $true # %TEMP%, C:\Windows\Temp (excludes startup script)
        FlushDNSCache = $true
        RunDISMCleanup = $true # /StartComponentCleanup
        RunDISMResetBase = $false # Optional: /ResetBase (Makes installed updates permanent, reduces WinSxS size, but prevents uninstall) - Higher Risk
        RunFstrim = $true # Optimize-Volume -ReTrim -DriveLetter C (Good for SSDs)
        ClearWindowsEventLogs = $false # Optional: Corresponds to StartupCleanup.CleanEventLogs if run interactively
        DISMRequiredFreeSpaceGB = 10 # Minimum GB free space required on C: before running DISM
    }
}

# Derived Configuration (Calculated Log Path)
$Configuration.LogFilePath = Join-Path -Path $Configuration.LogDirectory -ChildPath $Configuration.LogFileName

#endregion

#region --- Helper Functions ---

# Central Logging Function
Function Log-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [ValidateSet("INFO", "VERBOSE", "WARNING", "ERROR", "FATAL", "SUCCESS", "DEBUG", "HEADER")]
        [string]$Level = "INFO",
        [Parameter(Mandatory=$false)]
        [switch]$NoNewLine
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Console Output Color Coding
    $color = switch ($Level) {
        "VERBOSE"   { "DarkGray" }
        "WARNING"   { "Yellow" }
        "ERROR"     { "Red" }
        "FATAL"     { "DarkRed" }
        "SUCCESS"   { "Green" }
        "DEBUG"     { "Cyan" }
        "HEADER"    { "Magenta" }
        default     { "White" } # INFO
    }

    if ($NoNewLine) {
        Write-Host $logEntry -ForegroundColor $color -NoNewline
    } else {
        Write-Host $logEntry -ForegroundColor $color
    }

    # Write to transcript if enabled
    if ($Configuration.EnableTranscriptLogging -and $script:TranscriptActive) {
        # Transcript captures Write-Host automatically, no need to write explicitly
        # Add-Content -Path $Configuration.LogFilePath -Value $logEntry # Avoid duplicate logging
    }
}

# Function to safely set Registry Value
Function Set-RegistrySafe {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)]$Value,
        [Parameter(Mandatory=$false)][string]$Type = "String", # Default type
        [Parameter(Mandatory=$false)][switch]$Force,
        [Parameter(Mandatory=$false)][switch]$TakeOwnershipFirst # Attempt ownership before setting
    )
    $logPath = "$Path\$Name"
    Log-Message -Level VERBOSE -Message "Attempting to set Registry: '$logPath' to Value: '$Value' (Type: $Type)"
    try {
        # Ensure parent path exists
        $parentPath = Split-Path -Path $Path -Parent
        if ($parentPath -and (-not (Test-Path $parentPath))) {
            Log-Message -Level VERBOSE -Message "Parent path '$parentPath' not found, attempting creation..."
            New-Item -Path $parentPath -Force -ErrorAction Stop | Out-Null
        }
        # Ensure key path exists
        if (-not (Test-Path $Path)) {
            Log-Message -Level VERBOSE -Message "Registry path '$Path' not found, attempting creation..."
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }

        # Attempt ownership if requested
        $ownershipSuccess = $true
        if ($TakeOwnershipFirst) {
            $ownershipSuccess = Take-RegistryOwnership -RegistryPath $Path
        }

        if (-not $ownershipSuccess) {
            Log-Message -Level WARNING -Message "Skipping Set-ItemProperty for '$logPath' due to failed ownership attempt."
            return $false
        }

        # Get current value for logging comparison (optional)
        $currentValue = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue).$Name
        Log-Message -Level DEBUG -Message "Current value for '$logPath': '$currentValue'"

        # Set the property
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force:$Force -ErrorAction Stop
        Log-Message -Level SUCCESS -Message "Successfully set Registry: '$logPath' to '$Value'."
        return $true
    } catch {
        Log-Message -Level ERROR -Message "Failed to set Registry: '$logPath'. Error: $($_.Exception.Message)"
        return $false
    }
}

# Function to safely manage Services
Function Manage-ServiceSafe {
    param(
        [Parameter(Mandatory=$true)][string]$ServiceName,
        [Parameter(Mandatory=$true)][ValidateSet("Stop", "Start", "Disable", "SetAutomatic", "SetManual")] $Action,
        [Parameter(Mandatory=$false)][string]$Reason = "Script Configuration"
    )
    Log-Message -Level VERBOSE -Message "Attempting Action '$Action' on Service '$ServiceName' (Reason: $Reason)"
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop

        switch ($Action) {
            "Stop" {
                if ($service.Status -ne 'Stopped') {
                    Log-Message -Level VERBOSE -Message "Stopping service '$ServiceName'..."
                    Stop-Service -InputObject $service -Force -ErrorAction Stop
                    # Verify stop
                    $service = Get-Service -Name $ServiceName # Refresh status
                    if ($service.Status -eq 'Stopped') { Log-Message -Level SUCCESS -Message "Service '$ServiceName' stopped successfully." }
                    else { Log-Message -Level WARNING -Message "Service '$ServiceName' status is still $($service.Status) after stop attempt."; return $false }
                } else { Log-Message -Level INFO -Message "Service '$ServiceName' is already stopped." }
            }
            "Start" {
                if ($service.Status -ne 'Running') {
                    Log-Message -Level VERBOSE -Message "Starting service '$ServiceName'..."
                    Start-Service -InputObject $service -ErrorAction Stop
                     # Verify start
                    $service = Get-Service -Name $ServiceName # Refresh status
                    if ($service.Status -eq 'Running') { Log-Message -Level SUCCESS -Message "Service '$ServiceName' started successfully." }
                    else { Log-Message -Level WARNING -Message "Service '$ServiceName' status is still $($service.Status) after start attempt."; return $false }
                } else { Log-Message -Level INFO -Message "Service '$ServiceName' is already running." }
            }
            "Disable" {
                if ($service.StartType -ne 'Disabled') {
                    Log-Message -Level VERBOSE -Message "Disabling service '$ServiceName'..."
                    Set-Service -InputObject $service -StartupType Disabled -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "Service '$ServiceName' startup type set to Disabled."
                } else { Log-Message -Level INFO -Message "Service '$ServiceName' is already Disabled." }
            }
            "SetAutomatic" {
                 if ($service.StartType -ne 'Automatic') {
                    Log-Message -Level VERBOSE -Message "Setting service '$ServiceName' to Automatic..."
                    Set-Service -InputObject $service -StartupType Automatic -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "Service '$ServiceName' startup type set to Automatic."
                 } else { Log-Message -Level INFO -Message "Service '$ServiceName' is already Automatic." }
            }
             "SetManual" {
                 if ($service.StartType -ne 'Manual') {
                    Log-Message -Level VERBOSE -Message "Setting service '$ServiceName' to Manual..."
                    Set-Service -InputObject $service -StartupType Manual -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "Service '$ServiceName' startup type set to Manual."
                 } else { Log-Message -Level INFO -Message "Service '$ServiceName' is already Manual." }
            }
        }
        return $true
    } catch {
        # Special handling for "service does not exist" vs other errors
        if ($_.Exception.Message -like "*Cannot find any service with service name*") {
            Log-Message -Level WARNING -Message "Service '$ServiceName' not found. Skipping action '$Action'."
        } else {
            Log-Message -Level ERROR -Message "Failed action '$Action' on Service '$ServiceName'. Error: $($_.Exception.Message)"
        }
        return $false
    }
}

# Function to safely manage Scheduled Tasks
Function Manage-TaskSafe {
     param(
        [Parameter(Mandatory=$true)][string]$FullTaskPath, # e.g., '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser'
        [Parameter(Mandatory=$true)][ValidateSet("Disable", "Enable")] $Action,
        [Parameter(Mandatory=$false)][string]$Reason = "Script Configuration"
    )
    Log-Message -Level VERBOSE -Message "Attempting Action '$Action' on Scheduled Task '$FullTaskPath' (Reason: $Reason)"
    try {
        # Split path and name
        $taskName = Split-Path $FullTaskPath -Leaf
        $taskPath = Split-Path $FullTaskPath -Parent
        if ([string]::IsNullOrEmpty($taskPath)) { $taskPath = "\" } # Root path

        $task = Get-ScheduledTask -TaskPath $taskPath -TaskName $taskName -ErrorAction Stop

        $currentState = $task.State

        switch ($Action) {
            "Disable" {
                if ($currentState -ne 'Disabled') {
                    Log-Message -Level VERBOSE -Message "Disabling task '$FullTaskPath'..."
                    $task | Disable-ScheduledTask -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "Task '$FullTaskPath' disabled successfully."
                } else {
                    Log-Message -Level INFO -Message "Task '$FullTaskPath' is already Disabled."
                }
            }
            "Enable" {
                 if ($currentState -eq 'Disabled') {
                    Log-Message -Level VERBOSE -Message "Enabling task '$FullTaskPath'..."
                    $task | Enable-ScheduledTask -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "Task '$FullTaskPath' enabled successfully."
                } else {
                    Log-Message -Level INFO -Message "Task '$FullTaskPath' is already Enabled (or Ready/Running)."
                }
            }
        }
        return $true
    } catch {
         # Special handling for "task not found" vs other errors
        if ($_.Exception.Message -like "*The system cannot find the file specified*" -or $_.Exception.Message -like "*No task exists*") {
            Log-Message -Level WARNING -Message "Task '$FullTaskPath' not found. Skipping action '$Action'."
        } else {
            Log-Message -Level ERROR -Message "Failed action '$Action' on Task '$FullTaskPath'. Error: $($_.Exception.Message)"
        }
        return $false
    }
}

# Function to take ownership and grant admin full control of a registry key (requires external commands)
Function Take-RegistryOwnership {
    param([string]$RegistryPath)
    # Convert PowerShell path to a path `reg` command can understand
    $regPath = $RegistryPath.Replace("HKLM:\", "HKEY_LOCAL_MACHINE\").Replace("HKCU:\", "HKEY_CURRENT_USER\") # Add more hives if needed
    Log-Message -Level VERBOSE -Message "Attempting to take ownership and grant Full Control (Administrators) for Registry Path: '$regPath'"
    $success = $false
    try {
        # Using REG SAVE / REG RESTORE method is generally safer than takeown/icacls on registry if possible, but complex.
        # Sticking with takeown/icacls as per previous iteration, but acknowledge risks.

        Log-Message -Level DEBUG -Message "Executing: takeown /f `"$regPath`" /a /r /d y"
        $takeownProcess = Start-Process takeown.exe -ArgumentList "/f `"$regPath`" /a /r /d y" -Wait -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue
        if ($takeownProcess.ExitCode -ne 0) {
            throw "takeown.exe failed with exit code $($takeownProcess.ExitCode) for '$regPath'."
        }
        Log-Message -Level DEBUG -Message "takeown completed successfully for '$regPath'."

        Log-Message -Level DEBUG -Message "Executing: icacls `"$regPath`" /grant *S-1-5-32-544:F /t /c /l /q" # S-1-5-32-544 = BUILTIN\Administrators SID
        $icaclsProcess = Start-Process icacls.exe -ArgumentList "`"$regPath`" /grant *S-1-5-32-544:F /t /c /l /q" -Wait -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue
        if ($icaclsProcess.ExitCode -ne 0) {
            # Sometimes icacls returns non-zero even if successful on some keys, check if property can be set now as a fallback test?
            # For now, treat non-zero as failure.
             throw "icacls.exe failed with exit code $($icaclsProcess.ExitCode) for '$regPath'."
        }
        Log-Message -Level DEBUG -Message "icacls completed successfully for '$regPath'."

        Log-Message -Level SUCCESS -Message "Successfully took ownership and granted permissions for '$regPath'."
        $success = $true
    } catch {
        Log-Message -Level ERROR -Message "FAILED to take ownership/grant permissions for '$regPath'. Error: $($_.Exception.Message)"
        $success = $false
    }
    return $success
}

# Function to check internet connectivity
Function Test-InternetConnection {
    param([string]$HostToPing = "8.8.8.8", [int]$TimeoutMs = 1000)
    Log-Message -Level VERBOSE -Message "Testing internet connection by pinging '$HostToPing'..."
    try {
        $pingResult = Test-Connection -ComputerName $HostToPing -Count 1 -Quiet -ErrorAction Stop -BufferSize 16 # Small buffer, quick test
        if ($pingResult) {
            Log-Message -Level SUCCESS -Message "Internet connection test successful (Ping to $HostToPing succeeded)."
            return $true
        } else {
            # Test-Connection returning $false usually means timeout or host unreachable
             Log-Message -Level WARNING -Message "Internet connection test failed (Ping to $HostToPing did not return success)."
             return $false
        }
    } catch {
        Log-Message -Level WARNING -Message "Internet connection test failed (Ping to $HostToPing error: $($_.Exception.Message))."
        return $false
    }
}

# Function to get free disk space
Function Get-DiskSpaceGB {
    param([string]$DriveLetter = "C")
    $drive = Get-PSDrive $DriveLetter -ErrorAction SilentlyContinue
    if ($drive) {
        $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
        Log-Message -Level DEBUG -Message "Free space on drive $DriveLetter`: $freeSpaceGB GB."
        return $freeSpaceGB
    } else {
        Log-Message -Level WARNING -Message "Could not get disk space for drive '$DriveLetter'."
        return 0
    }
}

# Function to update progress bar
Function Update-Progress {
    param(
        [string]$StatusMessage,
        [int]$PhaseNumber,
        [int]$TotalPhases = $script:TotalPhasesToRun # Use global total if not specified
    )
    if ($TotalPhases -gt 0) {
        $percentComplete = [int](($PhaseNumber / $TotalPhases) * 100)
        Write-Progress -Activity "$($Configuration.ScriptName) v$($Configuration.ScriptVersion)" -Status $StatusMessage -PercentComplete $percentComplete -Id 1 -CurrentOperation "Phase $PhaseNumber / $TotalPhases"
    } else {
         Write-Progress -Activity "$($Configuration.ScriptName) v$($Configuration.ScriptVersion)" -Status $StatusMessage -Id 1
    }
}

#endregion

#region --- Phase Invocation Functions ---

# Phase 0: Verify Administrator Privileges (MANDATORY CHECK)
Function Invoke-Phase0_CheckAdmin {
    Log-Message -Level HEADER -Message "--- Phase 0: Verify Administrator Privileges ---"
    if (-Not $Configuration.EnablePhase_CheckAdmin) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Log-Message -Level FATAL -Message "SCRIPT MUST BE RUN AS ADMINISTRATOR. EXECUTION HALTED."
        Write-Error "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" -ErrorAction Stop # Halts script
        return $false # Will not be reached if Write-Error stops
    } else {
        Log-Message -Level SUCCESS -Message "Administrator privileges confirmed."
        return $true
    }
}

# Phase 1: Attempt Tamper Protection Disable
Function Invoke-Phase1_TamperProtection {
    Log-Message -Level HEADER -Message "--- Phase 1: Attempt Tamper Protection Disable ---"
    if (-Not $Configuration.EnablePhase_TamperProtection) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    $tpConfig = $Configuration.TamperProtection
    $success = Set-RegistrySafe -Path $tpConfig.RegistryKey -Name $tpConfig.RegistryValueName -Value $tpConfig.TargetValue -Type DWord -Force

    if ($success) {
        Log-Message -Level SUCCESS -Message "Tamper Protection registry flag set to 'Disabled' (Value: $($tpConfig.TargetValue)). NOTE: Actual status depends on Windows internals."
        $script:TP_Disable_Attempt_Success = $true # Set global flag
    } else {
        Log-Message -Level WARNING -Message "Failed to set Tamper Protection registry flag. Defender disable phase will likely fail."
        $script:TP_Disable_Attempt_Success = $false
    }
    return $success
}

# Phase 2: Apply Ultimate Power Settings
Function Invoke-Phase2_PowerSettings {
    Log-Message -Level HEADER -Message "--- Phase 2: Apply Ultimate Power Settings ---"
    if (-Not $Configuration.EnablePhase_PowerSettings) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level INFO -Message "Applying aggressive power settings for maximum performance (High Overheat Risk!)."
    $powerConfig = $Configuration.Power
    $targetPlanGuid = $null
    $planActivated = $false

    try {
        # Determine target plan GUID
        if ($powerConfig.TargetPlan -eq "Ultimate") {
            Log-Message -Level VERBOSE -Message "Attempting to activate Ultimate Performance Plan..."
            powercfg /duplicatescheme $powerConfig.UltimatePlanGUID | Out-Null # Ensure it exists/is available
            powercfg /setactive $powerConfig.UltimatePlanGUID
            if ((powercfg /getactivescheme) -match $powerConfig.UltimatePlanGUID) {
                $targetPlanGuid = $powerConfig.UltimatePlanGUID
                Log-Message -Level SUCCESS -Message "Ultimate Performance Plan activated."
                $planActivated = $true
            } else {
                Log-Message -Level WARNING -Message "Failed to activate Ultimate Performance Plan. Falling back to High Performance."
                $powerConfig.TargetPlan = "High" # Update config for fallback
            }
        }

        if (-not $planActivated -and $powerConfig.TargetPlan -eq "High") {
             Log-Message -Level VERBOSE -Message "Attempting to activate High Performance Plan..."
             powercfg /setactive $powerConfig.HighPerformancePlanGUID
             if ((powercfg /getactivescheme) -match $powerConfig.HighPerformancePlanGUID) {
                $targetPlanGuid = $powerConfig.HighPerformancePlanGUID
                Log-Message -Level SUCCESS -Message "High Performance Plan activated."
                $planActivated = $true
             } else {
                 Log-Message -Level WARNING -Message "Failed to activate High Performance Plan. Trying to apply settings to the CURRENT active plan."
                 $activePlanOutput = powercfg /getactivescheme
                 $targetPlanGuid = ($activePlanOutput -split ' ')[3] # Extract GUID
                 if ($targetPlanGuid -match '^[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}$') { # Basic GUID format check
                    Log-Message -Level INFO -Message "Applying settings to currently active plan: $targetPlanGuid ($($activePlanOutput -split '[(]')[1].TrimEnd(')')))"
                 } else {
                     throw "Could not determine a valid active power plan GUID to apply settings to."
                 }
             }
        }

        if (-not $targetPlanGuid) { throw "Failed to set or identify a target power plan." }

        # Apply specific settings from configuration
        Log-Message -Level INFO -Message "Applying 'Never Sleep' and performance settings to plan '$targetPlanGuid'..."
        foreach ($settingKey in $powerConfig.Settings.Keys) {
            $subgroupAlias,$settingAlias = $settingKey.Split('/')
            $value = $powerConfig.Settings[$settingKey]
            Log-Message -Level VERBOSE -Message "Setting AC: $subgroupAlias / $settingAlias = $value"
            powercfg /setacvalueindex $targetPlanGuid "SCHEME_CURRENT" $subgroupAlias $settingAlias $value | Out-Null
            Log-Message -Level VERBOSE -Message "Setting DC: $subgroupAlias / $settingAlias = $value"
            powercfg /setdcvalueindex $targetPlanGuid "SCHEME_CURRENT" $subgroupAlias $settingAlias $value | Out-Null
        }
        Log-Message -Level SUCCESS -Message "Specific power settings applied for AC & DC."

        # Disable Power Throttling if configured
        if ($powerConfig.DisablePowerThrottling) {
            Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -Type DWord -Force
        }

        # Ensure the final plan is active
        powercfg /setactive $targetPlanGuid | Out-Null
        Log-Message -Level SUCCESS -Message "Phase 2: Power Settings completed successfully."
        return $true

    } catch {
        Log-Message -Level ERROR -Message "Phase 2: Failed to apply power settings. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 3: Extensive Service Disabling
Function Invoke-Phase3_ServiceDisabling {
    Log-Message -Level HEADER -Message "--- Phase 3: Extensive Service Disabling ---"
    if (-Not $Configuration.EnablePhase_ServiceDisabling) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level WARNING -Message "Disabling numerous services. This WILL break features and carries HIGH RISK!"
    $servicesConfig = $Configuration.Services.ServicesToDisable
    $successCount = 0
    $failCount = 0
    $skippedCount = 0

    foreach ($serviceName in $servicesConfig.Keys) {
        $reason = $servicesConfig[$serviceName]
        Log-Message -Level INFO -Message "Processing Service: '$serviceName' (Reason: $reason)"

        # Check for pattern-based services (e.g., User Services)
        if ($serviceName -like "*UserSvc*") {
             Log-Message -Level VERBOSE -Message "Handling pattern-based user service: $serviceName"
             $userServices = Get-Service -Name "$($serviceName)_*" -ErrorAction SilentlyContinue
             if ($userServices) {
                 foreach ($userService in $userServices) {
                     Log-Message -Level INFO -Message "  Processing User Instance: '$($userService.Name)'"
                     # Stop first, then disable
                     if (Manage-ServiceSafe -ServiceName $userService.Name -Action Stop -Reason $Reason) {
                         if (Manage-ServiceSafe -ServiceName $userService.Name -Action Disable -Reason $Reason) {
                             $successCount++
                         } else { $failCount++ }
                     } else { $failCount++ } # Fail if stop fails
                 }
             } else {
                 Log-Message -Level INFO -Message "No running instances found for pattern '$serviceName'."
                 $skippedCount++
             }
        } else {
            # Standard service handling
            # Stop first, then disable
            if (Manage-ServiceSafe -ServiceName $serviceName -Action Stop -Reason $Reason) {
                if (Manage-ServiceSafe -ServiceName $serviceName -Action Disable -Reason $Reason) {
                    $successCount++
                } else { $failCount++ }
            } else {
                # If Stop failed, maybe it doesn't exist or is already stopped but can still be disabled
                 Log-Message -Level VERBOSE -Message "Stop action failed or service not running/found for '$serviceName'. Attempting Disable anyway."
                 if (Manage-ServiceSafe -ServiceName $serviceName -Action Disable -Reason $Reason) {
                     # Check if the service actually existed or was just not found
                     if ($Error[-1].Exception.Message -like "*Cannot find any service*") {
                        $skippedCount++ # Count as skipped if it never existed
                     } else {
                         $successCount++ # Count as success if disable worked despite stop issue
                     }
                 } else {
                     # If disable also fails, check if it didn't exist
                      if ($Error[-1].Exception.Message -like "*Cannot find any service*") {
                        $skippedCount++ # Count as skipped if it never existed
                     } else {
                        $failCount++ # Count as fail if disable failed and it wasn't due to not existing
                     }
                 }
            }
        }
    }

    Log-Message -Level INFO -Message "Phase 3: Service Disabling completed. Success: $successCount, Failed: $failCount, Skipped/Not Found: $skippedCount."
    if ($servicesConfig.ContainsKey("WSearch")) {
        Log-Message -Level WARNING -Message "CRITICAL REMINDER: 'WSearch' service disabled. Windows Search functionality is BROKEN."
    }
    return ($failCount -eq 0) # Return true only if no failures occurred (ignoring skipped)
}

# Phase 4: Apply Network Tweaks
Function Invoke-Phase4_NetworkTweaks {
    Log-Message -Level HEADER -Message "--- Phase 4: Apply Network Tweaks ---"
    if (-Not $Configuration.EnablePhase_NetworkTweaks) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level INFO -Message "Applying various network optimizations..."
    $netConfig = $Configuration.Network
    $overallSuccess = $true

    try {
        # Set DNS if configured
        if ($netConfig.SetGoogleDNS) {
            Log-Message -Level INFO -Message "Setting DNS to Google DNS (8.8.8.8, 8.8.4.4) for active adapters..."
            $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
            if ($adapters) {
                foreach ($adapter in $adapters) {
                    Log-Message -Level VERBOSE -Message "Setting DNS for adapter: $($adapter.Name)"
                    try {
                         $adapter | Set-DnsClientServerAddress -ServerAddresses ("8.8.8.8", "8.8.4.4") -ErrorAction Stop | Out-Null
                         Log-Message -Level SUCCESS -Message "Successfully set DNS for $($adapter.Name)."
                    } catch {
                        Log-Message -Level WARNING -Message "Failed to set DNS for adapter '$($adapter.Name)': $($_.Exception.Message)"
                        $overallSuccess = $false
                    }
                }
            } else { Log-Message -Level INFO -Message "No active network adapters found to set DNS on."}
        }

        # Flush DNS if configured
        if ($netConfig.FlushDNS) {
            Log-Message -Level INFO -Message "Flushing DNS cache..."
            try {
                ipconfig /flushdns | Out-Null
                Log-Message -Level SUCCESS -Message "DNS cache flushed."
            } catch {
                 Log-Message -Level WARNING -Message "Failed to flush DNS cache: $($_.Exception.Message)"
                 $overallSuccess = $false
            }
        }

        # Apply Netsh TCP Global Settings
        Log-Message -Level INFO -Message "Applying netsh TCP global settings..."
        foreach ($setting in $netConfig.TCPGlobal.Keys) {
            $value = $netConfig.TCPGlobal[$setting]
            $command = "netsh int tcp set global $setting=$value"
            Log-Message -Level VERBOSE -Message "Executing: $command"
            try {
                Invoke-Expression $command | Out-Null # Using Invoke-Expression as netsh output isn't easily captured otherwise
                # No easy verification here without parsing netsh show global output
                Log-Message -Level SUCCESS -Message "Applied netsh setting: $setting=$value"
            } catch {
                 Log-Message -Level WARNING -Message "Failed to apply netsh setting '$setting=$value': $($_.Exception.Message)"
                 $overallSuccess = $false
            }
        }

        # Apply Advanced TCP Settings (Set-NetTCPSetting) if enabled
        if ($netConfig.EnableAdvancedTCPSettings) {
            Log-Message -Level INFO -Message "Applying advanced TCP settings (Set-NetTCPSetting) - Experimental..."
            # Get common TCP setting profiles
            $tcpProfiles = Get-NetTCPSetting | Where-Object { $_.SettingName -in ('InternetCustom', 'DatacenterCustom') } # Apply to these profiles
            if ($tcpProfiles) {
                foreach ($profile in $tcpProfiles) {
                    Log-Message -Level VERBOSE -Message "Applying settings to TCP Profile: $($profile.SettingName)"
                    foreach ($settingName in $netConfig.TCPSettings.Keys) {
                         $settingValue = $netConfig.TCPSettings[$settingName]
                         Log-Message -Level VERBOSE -Message "  Setting '$settingName' to '$settingValue'..."
                         try {
                            Set-NetTCPSetting -InputObject $profile -ErrorAction Stop -Force @{"$settingName" = $settingValue}
                            Log-Message -Level SUCCESS -Message "  Successfully set '$settingName' on profile '$($profile.SettingName)'."
                         } catch {
                             Log-Message -Level WARNING -Message "  Failed to set '$settingName' on profile '$($profile.SettingName)': $($_.Exception.Message)"
                             $overallSuccess = $false
                         }
                    }
                }
            } else { Log-Message -Level INFO -Message "No suitable TCP profiles (InternetCustom, DatacenterCustom) found to apply advanced settings."}
        }

        # Apply Advanced Adapter Properties if enabled
        if ($netConfig.EnableAdvancedAdapterSettings) {
            Log-Message -Level INFO -Message "Applying advanced network adapter properties (Set-NetAdapterAdvancedProperty) - Hardware Dependent & Experimental..."
            $adapters = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}
             if ($adapters) {
                foreach ($adapter in $adapters) {
                     Log-Message -Level VERBOSE -Message "Attempting to set advanced properties for adapter: $($adapter.Name) ($($adapter.InterfaceDescription))"
                     foreach ($prop in $netConfig.AdapterProperties) {
                         Log-Message -Level VERBOSE -Message "  Trying property: '$($prop.Name)' to DisplayValue: '$($prop.DisplayValue)' (RegistryValue: '$($prop.RegistryValue)')"
                         try {
                            # Check if property exists first
                            $advProp = Get-NetAdapterAdvancedProperty -Name $adapter.Name -RegistryKeyword $prop.Name -ErrorAction SilentlyContinue
                            if ($advProp) {
                                Set-NetAdapterAdvancedProperty -Name $adapter.Name -RegistryKeyword $prop.Name -RegistryValue $prop.RegistryValue -ErrorAction Stop | Out-Null
                                Log-Message -Level SUCCESS -Message "  Successfully set '$($prop.Name)' on adapter '$($adapter.Name)'."
                            } else {
                                Log-Message -Level DEBUG -Message "  Property '$($prop.Name)' not found on adapter '$($adapter.Name)'. Skipping."
                            }
                         } catch {
                             Log-Message -Level WARNING -Message "  Failed to set property '$($prop.Name)' on adapter '$($adapter.Name)': $($_.Exception.Message)"
                             # Don't mark overall phase as failed for optional adapter tweaks, but log warning.
                         }
                     }
                 }
             } else { Log-Message -Level INFO -Message "No active network adapters found to apply advanced properties."}
        }

        Log-Message -Level INFO -Message "Phase 4: Network Tweaks application attempted."
        return $overallSuccess

    } catch {
        Log-Message -Level ERROR -Message "Phase 4: Unexpected error during network tweaks. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 5: Manage Pagefile
Function Invoke-Phase5_PagefileManagement {
    Log-Message -Level HEADER -Message "--- Phase 5: Manage Pagefile ---"
    if (-Not $Configuration.EnablePhase_PagefileManagement -or -Not $Configuration.Pagefile.ManagePagefile) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Configuring system pagefile..."
    $pfConfig = $Configuration.Pagefile
    $overallSuccess = $true

    try {
        # Calculate Target Size
        $targetInitialMB = 0
        $targetMaximumMB = 0
        if ($pfConfig.CalculationMethod -eq "RAMMultiple") {
            $ramBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
            $ramMB = [Math]::Round($ramBytes / 1MB)
            $calculatedSize = $ramMB * $pfConfig.RAMMultipleFactor
            $targetInitialMB = [int][Math]::Min($calculatedSize, $pfConfig.MaxSizeMB)
            $targetMaximumMB = $targetInitialMB # Fixed size based on calculation
            Log-Message -Level INFO -Message "RAM: $ramMB MB. Calculated Pagefile size (Factor: $($pfConfig.RAMMultipleFactor), Cap: $($pfConfig.MaxSizeMB) MB): $targetInitialMB MB."
        } elseif ($pfConfig.CalculationMethod -eq "FixedSize") {
            $targetInitialMB = $pfConfig.FixedSizeMB
            $targetMaximumMB = $pfConfig.FixedSizeMB
             Log-Message -Level INFO -Message "Using fixed Pagefile size: $targetInitialMB MB."
        } else {
            throw "Invalid Pagefile CalculationMethod: '$($pfConfig.CalculationMethod)'"
        }

        # Disable Automatic Management
        Log-Message -Level VERBOSE -Message "Disabling automatic pagefile management..."
        Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem WHERE Name='$env:COMPUTERNAME'" -Property @{AutomaticManagedPagefile = $false} -ErrorAction Stop

        # Remove pagefiles on other drives if configured
        if ($pfConfig.RemovePagefilesOnOtherDrives) {
            Log-Message -Level INFO -Message "Removing existing pagefile settings on drives other than '$($pfConfig.TargetDrive)'..."
            $existingPagefiles = Get-CimInstance -ClassName Win32_PageFileSetting -ErrorAction SilentlyContinue
            if ($existingPagefiles) {
                foreach ($pf in $existingPagefiles) {
                    $driveLetter = $pf.Name.Substring(0, 1)
                    if ($driveLetter -ne $pfConfig.TargetDrive.TrimEnd(':')) {
                        Log-Message -Level VERBOSE -Message "Removing pagefile setting: $($pf.Name)"
                        try {
                            Remove-CimInstance -InputObject $pf -ErrorAction Stop
                            Log-Message -Level SUCCESS -Message "Removed pagefile setting for $($pf.Name)."
                        } catch {
                             Log-Message -Level WARNING -Message "Failed to remove pagefile setting for $($pf.Name): $($_.Exception.Message)"
                             $overallSuccess = $false
                        }
                    }
                }
            } else { Log-Message -Level INFO -Message "No existing pagefile settings found."}
        }

        # Set the target pagefile
        $targetPagefileName = "$($pfConfig.TargetDrive.TrimEnd(':')):\pagefile.sys"
        Log-Message -Level INFO -Message "Setting pagefile on '$($pfConfig.TargetDrive)' to Initial: $targetInitialMB MB, Maximum: $targetMaximumMB MB."
        $pfTarget = Get-CimInstance -ClassName Win32_PageFileSetting | Where-Object {$_.Name -eq $targetPagefileName} -ErrorAction SilentlyContinue

        if ($pfTarget) {
            Log-Message -Level VERBOSE -Message "Modifying existing pagefile setting for '$targetPagefileName'..."
            Set-CimInstance -InputObject $pfTarget -Property @{InitialSize = $targetInitialMB; MaximumSize = $targetMaximumMB} -ErrorAction Stop
        } else {
            Log-Message -Level VERBOSE -Message "Creating new pagefile setting for '$targetPagefileName'..."
            # Use New-CimInstance with -ClientOnly then Set-CimInstance
             $newInstance = New-CimInstance -ClassName Win32_PageFileSetting -Property @{Name = $targetPagefileName; InitialSize = $targetInitialMB; MaximumSize = $targetMaximumMB} -ClientOnly
             Set-CimInstance -CimInstance $newInstance -ErrorAction Stop
        }
        Log-Message -Level SUCCESS -Message "Successfully configured pagefile for '$targetPagefileName'. Changes require system restart."

        Log-Message -Level INFO -Message "Phase 5: Pagefile Management completed."
        return $overallSuccess

    } catch {
        Log-Message -Level ERROR -Message "Phase 5: Failed to manage pagefile. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 6: Apply System & Registry Tweaks
Function Invoke-Phase6_SystemRegistryTweaks {
    Log-Message -Level HEADER -Message "--- Phase 6: Apply System & Registry Tweaks ---"
    if (-Not $Configuration.EnablePhase_SystemRegistryTweaks) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level INFO -Message "Applying various system and registry tweaks for performance and responsiveness..."
    $tweaksConfig = $Configuration.SystemTweaks
    $overallSuccess = $true
    $successCount = 0
    $failCount = 0

    # File System Tweaks
    Log-Message -Level INFO -Message "Applying File System tweaks..."
    if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsDisableLastAccessUpdate" -Value $([int]$tweaksConfig.NtfsDisableLastAccessUpdate) -Type DWord -Force) { $successCount++ } else { $failCount++ }
    if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "NtfsMemoryUsage" -Value $tweaksConfig.NtfsMemoryUsage -Type DWord -Force) { $successCount++ } else { $failCount++ }

    # UI Responsiveness Tweaks
    Log-Message -Level INFO -Message "Applying UI Responsiveness tweaks..."
    if (Set-RegistrySafe -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value $tweaksConfig.MenuShowDelay -Type String -Force) { $successCount++ } else { $failCount++ }
    if (Set-RegistrySafe -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Value $tweaksConfig.MouseHoverTime -Type String -Force) { $successCount++ } else { $failCount++ }

     # Shutdown/Timeout Tweaks
    Log-Message -Level INFO -Message "Applying Shutdown/Timeout tweaks..."
    if (Set-RegistrySafe -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value $tweaksConfig.WaitToKillAppTimeout -Type String -Force) { $successCount++ } else { $failCount++ }
    if (Set-RegistrySafe -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Value $tweaksConfig.HungAppTimeout -Type String -Force) { $successCount++ } else { $failCount++ }
    if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value $tweaksConfig.WaitToKillServiceTimeout -Type String -Force) { $successCount++ } else { $failCount++ }

    # Memory Management Tweaks (Experimental)
    if ($tweaksConfig.EnableMemoryTweaks) {
        Log-Message -Level INFO -Message "Applying experimental Memory Management tweaks..."
        if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "LargeSystemCache" -Value $tweaksConfig.LargeSystemCache -Type DWord -Force) { $successCount++ } else { $failCount++ }
        if ($tweaksConfig.DisableSuperfetchParameters) {
            if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnableSuperfetch" -Value 0 -Type DWord -Force) { $successCount++ } else { $failCount++ }
            if (Set-RegistrySafe -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0 -Type DWord -Force) { $successCount++ } else { $failCount++ }
        }
    }

    Log-Message -Level INFO -Message "Phase 6: System & Registry Tweaks completed. Success: $successCount, Failed: $failCount."
    return ($failCount -eq 0)
}

# Phase 7: Disable Scheduled Tasks
Function Invoke-Phase7_ScheduledTaskDisabling {
     Log-Message -Level HEADER -Message "--- Phase 7: Disable Scheduled Tasks ---"
    if (-Not $Configuration.EnablePhase_ScheduledTaskDisabling) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level WARNING -Message "Disabling numerous scheduled tasks. This may affect system maintenance, updates, or other features."
    $tasksToDisable = $Configuration.ScheduledTasks.TasksToDisable
    $successCount = 0
    $failCount = 0
    $skippedCount = 0

    foreach ($taskFullPath in $tasksToDisable) {
        if (Manage-TaskSafe -FullTaskPath $taskFullPath -Action Disable -Reason "Hyperion AIO Configuration") {
            $successCount++
        } else {
             # Check if the failure was due to the task not being found
             if ($Error[0].Exception.Message -like "*The system cannot find the file specified*" -or $Error[0].Exception.Message -like "*No task exists*") {
                $skippedCount++
             } else {
                 $failCount++
             }
        }
    }

    Log-Message -Level INFO -Message "Phase 7: Scheduled Task Disabling completed. Disabled: $successCount, Failed: $failCount, Skipped/Not Found: $skippedCount."
    return ($failCount -eq 0) # Return true only if no actual failures occurred
}

# Phase 8: Show Desktop Icons
Function Invoke-Phase8_DesktopIcons {
    Log-Message -Level HEADER -Message "--- Phase 8: Show Desktop Icons ---"
    if (-Not $Configuration.EnablePhase_DesktopIcons) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level INFO -Message "Configuring desktop icons visibility..."
    $iconConfig = $Configuration.DesktopIcons
    $overallSuccess = $true
    $delegateFoldersKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

    try {
        # Ensure the parent key exists
        if (-not (Test-Path $delegateFoldersKey)) {
            Log-Message -Level VERBOSE -Message "Creating registry key: $delegateFoldersKey"
            New-Item -Path $delegateFoldersKey -Force | Out-Null
        }

        # Define icon CLSIDs
        $iconMapping = @{
            ThisPC = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
            Network = "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
            RecycleBin = "{645FF040-5081-101B-9F08-00AA002F954E}"
            ControlPanel = "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
            UserFiles = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
        }

        # Set visibility based on configuration (0 = Show, 1 = Hide)
        foreach ($iconName in $iconMapping.Keys) {
            $configKey = "Show$iconName"
            if ($iconConfig.Contains($configKey)) {
                $showIcon = $iconConfig[$configKey]
                $targetValue = if ($showIcon) { 0 } else { 1 }
                $clsid = $iconMapping[$iconName]
                Log-Message -Level VERBOSE -Message "Setting icon '$iconName' ($clsid) visibility to $($showIcon) (Value: $targetValue)..."
                if (-not (Set-RegistrySafe -Path $delegateFoldersKey -Name $clsid -Value $targetValue -Type DWord -Force)) {
                    $overallSuccess = $false
                }
            }
        }

        # Attempt to refresh explorer
        Log-Message -Level INFO -Message "Attempting to restart explorer.exe to apply icon changes (may require manual restart/logoff)."
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue

        if ($overallSuccess) {
            Log-Message -Level SUCCESS -Message "Phase 8: Desktop Icons configuration applied successfully."
        } else {
             Log-Message -Level WARNING -Message "Phase 8: Desktop Icons configuration completed with one or more errors."
        }
        return $overallSuccess

    } catch {
        Log-Message -Level ERROR -Message "Phase 8: Unexpected error managing desktop icons. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 9: Create Startup Cleanup Task
Function Invoke-Phase9_StartupCleanupTask {
     Log-Message -Level HEADER -Message "--- Phase 9: Create Startup Cleanup Task ---"
    if (-Not $Configuration.EnablePhase_StartupCleanupTask) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level INFO -Message "Creating scheduled task to clean temporary files and caches on startup..."
    $scConfig = $Configuration.StartupCleanup
    $scriptFullPath = Join-Path -Path $scConfig.ScriptPath -ChildPath $scConfig.ScriptFileName

    # Define the content of the cleanup script dynamically based on config
    $scriptContent = @"
# Hyperion Startup Cleanup Script (v$($Configuration.ScriptVersion)) - Executed as SYSTEM
Write-Host "Starting Hyperion automatic cleanup ($(Get-Date))" `n"-----"

# Function to remove items quietly
Function Remove-ItemQuietly {
    param([string]`$PathPattern)
    Write-Host "  Cleaning pattern: `"`$PathPattern`"..." -ForegroundColor DarkGray
    Get-ChildItem -Path `$PathPattern -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    # Consider adding item count or size removed for better logging?
}

# Function to clear event logs
Function Clear-EventLogSafe {
    param([string]`$LogName)
    Write-Host "  Attempting to clear Event Log: `"`$LogName`"..." -ForegroundColor DarkGray
    try {
        Clear-EventLog -LogName `$LogName -ErrorAction Stop
        Write-Host "    Successfully cleared `$LogName." -ForegroundColor Gray
    } catch {
        Write-Host "    WARNING: Failed to clear Event Log `"`$LogName`"`: `$(`$_.Exception.Message)" -ForegroundColor Yellow
    }
}

"@ # End of initial script block

    if ($scConfig.CleanSystemTemp) {
        $scriptContent += "`nWrite-Host '- Cleaning System Temp...'"
        $scriptContent += "`nRemove-ItemQuietly -PathPattern ('`$env:windir' + '\Temp\*')"
    }
    if ($scConfig.CleanWindowsUpdateCache) {
         $scriptContent += "`nWrite-Host '- Cleaning Windows Update Cache...'"
         $scriptContent += "`nRemove-ItemQuietly -PathPattern ('`$env:windir' + '\SoftwareDistribution\Download\*')"
    }
     if ($scConfig.CleanWindowsOld) {
         $scriptContent += "`nif (Test-Path 'C:\Windows.old') { Write-Host '- Cleaning Windows.old...'; Remove-ItemQuietly -PathPattern 'C:\Windows.old\*' }"
    }

    # User Profile Cleaning (More robust iteration)
    if ($scConfig.CleanUserProfileTemp -or $scConfig.CleanBrowserCaches) {
         $scriptContent += @"

Write-Host "- Cleaning User Profiles..."
`$UserProfilesPath = 'C:\Users'
`$UserProfileFolders = Get-ChildItem -Path `$UserProfilesPath -Directory -Force -ErrorAction SilentlyContinue | Where-Object { `$_.Name -ne 'Public' -and `$_.Name -ne 'Default' -and `$_.Name -notlike '.*' -and (Test-Path "`$(`$_.FullName)\AppData\Local")}
if (`$UserProfileFolders) {
    foreach (`$UserProfile in `$UserProfileFolders) {
        Write-Host "-- Processing Profile: `"`$(`$UserProfile.FullName)`" --"
"@ # End of User Profile loop start

        if ($scConfig.CleanUserProfileTemp) {
            $scriptContent += "`n        Write-Host '  Cleaning User Temp (AppData\Local\Temp)...'"
            $scriptContent += "`n        Remove-ItemQuietly -PathPattern (`"`$(`$UserProfile.FullName)\AppData\Local\Temp\*`")"
        }
        if ($scConfig.CleanBrowserCaches) {
            $scriptContent += @"
        Write-Host '  Cleaning Browser Caches (Chrome, Edge, Firefox, Brave - Default Profiles)...'
        Remove-ItemQuietly -PathPattern ("`$(`$UserProfile.FullName)\AppData\Local\Microsoft\Edge\User Data\Default\Cache\*" )
        Remove-ItemQuietly -PathPattern ("`$(`$UserProfile.FullName)\AppData\Local\Google\Chrome\User Data\Default\Cache\*" )
        Remove-ItemQuietly -PathPattern ("`$(`$UserProfile.FullName)\AppData\Roaming\Mozilla\Firefox\Profiles\*\cache2\*" ) # New FF cache
        Remove-ItemQuietly -PathPattern ("`$(`$UserProfile.FullName)\AppData\Roaming\Mozilla\Firefox\Profiles\*\cache\*" )  # Old FF cache
        Remove-ItemQuietly -PathPattern ("`$(`$UserProfile.FullName)\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Cache\*" )
"@ # End of Browser Cache clean
        }
        $scriptContent += "    }`n} else { Write-Host '- No user profiles found to clean.' }" # End of User Profile loop
    }

    # Event Log Cleaning
    if ($scConfig.CleanEventLogs -and $scConfig.EventLogsToClear) {
         $scriptContent += "`nWrite-Host '- Cleaning Specified Event Logs...'"
         foreach ($log in $scConfig.EventLogsToClear) {
             $scriptContent += "`nClear-EventLogSafe -LogName '$log'"
         }
    }

    # Final part of the cleanup script
    $scriptContent += "`n`nWrite-Host `n'-----'`nWrite-Host 'Hyperion automatic cleanup finished ($(Get-Date)).'"

    # Save and Register the Task
    try {
        Log-Message -Level VERBOSE -Message "Saving cleanup script to: $scriptFullPath"
        $scriptDir = Split-Path $scriptFullPath -Parent
        if (-not (Test-Path $scriptDir)) { New-Item -Path $scriptDir -ItemType Directory -Force | Out-Null }
        Set-Content -Path $scriptFullPath -Value $scriptContent -Encoding UTF8 -Force -ErrorAction Stop

        Log-Message -Level INFO -Message "Registering Scheduled Task '$($scConfig.TaskName)' to run at Startup as SYSTEM..."
        $taskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptFullPath`""
        $taskTrigger = New-ScheduledTaskTrigger -AtStartup
        $taskPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden -ExecutionTimeLimit (New-TimeSpan -Minutes 15) # Add time limit
        Register-ScheduledTask -TaskName $scConfig.TaskName -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -Settings $taskSettings -Force -ErrorAction Stop
        Log-Message -Level SUCCESS -Message "Phase 9: Startup cleanup task '$($scConfig.TaskName)' created successfully."
        return $true
    } catch {
        Log-Message -Level ERROR -Message "Phase 9: Failed to create Startup Cleanup Task. Error: $($_.Exception.Message)"
        # Attempt cleanup of the generated script file if task registration failed
        if (Test-Path $scriptFullPath) { Remove-Item $scriptFullPath -Force -ErrorAction SilentlyContinue }
        return $false
    }
}

# Phase 10: Create RAM Management Task
Function Invoke-Phase10_RAMManagementTask {
    Log-Message -Level HEADER -Message "--- Phase 10: Create RAM Management Task ---"
    if (-Not $Configuration.EnablePhase_RAMManagementTask -or -Not $Configuration.RAMManagement.EnableAggressiveRAMTask) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Creating scheduled task for experimental RAM clearing (ProcessIdleTasks)..."
    $ramConfig = $Configuration.RAMManagement
    try {
        Log-Message -Level VERBOSE -Message "Registering Task '$($ramConfig.TaskName)' to run '$($ramConfig.CommandToExecute)' with args '$($ramConfig.CommandArguments)' every $($ramConfig.ExecutionIntervalMinutes) minutes."
        $taskAction = New-ScheduledTaskAction -Execute $ramConfig.CommandToExecute -Argument $ramConfig.CommandArguments
        $taskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes $ramConfig.ExecutionIntervalMinutes) -RepetitionDuration ([TimeSpan]::MaxValue)
        $taskPrincipal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 5) -Priority 4 # Slightly higher priority?
        Register-ScheduledTask -TaskName $ramConfig.TaskName -Action $taskAction -Trigger $taskTrigger -Principal $taskPrincipal -Settings $taskSettings -Force -ErrorAction Stop
        Log-Message -Level SUCCESS -Message "Phase 10: Experimental RAM clearing task '$($ramConfig.TaskName)' created successfully."
        return $true
    } catch {
        Log-Message -Level ERROR -Message "Phase 10: Failed to create RAM Management Task. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 11: Enhanced Windows Defender Disable Attempt (EXTREME RISK)
Function Invoke-Phase11_DefenderDisable {
     Log-Message -Level HEADER -Message "--- Phase 11: Enhanced Windows Defender Disable Attempt ---"
    if (-Not $Configuration.EnablePhase_DefenderDisable) { Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true }

    Log-Message -Level WARNING -Message "EXECUTING EXTREME RISK PHASE: Attempting enhanced disable of Windows Defender."
    Log-Message -Level WARNING -Message "This involves taking ownership of registry keys and disabling core security services."
    Log-Message -Level WARNING -Message "SUCCESS IS NOT GUARANTEED. SYSTEM INSTABILITY OR SECURITY COMPROMISE IS HIGHLY LIKELY."

    $defConfig = $Configuration.Defender
    $overallSuccess = $true
    $registryModsAttempted = $false
    $registryModSuccessCount = 0
    $registryModFailCount = 0
    $serviceDisableSuccessCount = 0
    $serviceDisableFailCount = 0

    # Prerequisite check: Tamper Protection disable attempt flag
    if (-not $script:TP_Disable_Attempt_Success) {
         Log-Message -Level WARNING -Message "Tamper Protection disable attempt (Phase 1) failed or was skipped. Enhanced Defender disable is unlikely to succeed. Skipping further steps in this phase."
         return $true # Return true as the phase was skipped due to prereq, not an error here.
    }

    Log-Message -Level INFO -Message "Tamper Protection flag was set. Proceeding with enhanced disable..."

    # Attempt Enhanced Registry Modifications if configured
    if ($defConfig.AttemptEnhancedDisable) {
        Log-Message -Level INFO -Message "Attempting to take ownership and modify critical Defender registry keys..."
        $keysToOwn = @($defConfig.PolicyKey, $defConfig.RealTimeKey, $defConfig.FeaturesKey, $defConfig.SpynetKey, $defConfig.SignatureKey) # Add others if needed
        $ownershipSuccessOverall = $true
        foreach ($key in $keysToOwn) {
            if (-not (Take-RegistryOwnership -RegistryPath $key)) {
                $ownershipSuccessOverall = $false
                Log-Message -Level WARNING -Message "Failed to gain ownership/permissions for key '$key'. Subsequent modifications may fail."
                # Continue trying other keys even if one fails? Or stop? Let's continue for now.
            }
        }

        if ($ownershipSuccessOverall) {
            Log-Message -Level INFO -Message "Ownership/permissions likely set for target keys. Applying registry settings..."
            $registryModsAttempted = $true
            foreach ($setting in $defConfig.SettingsToApply) {
                # Use TakeOwnershipFirst=$false here as we did it globally above for the parent keys
                if (Set-RegistrySafe -Path $setting.Path -Name $setting.Name -Value $setting.Value -Type $setting.Type -Force) {
                    $registryModSuccessCount++
                } else {
                    $registryModFailCount++
                }
            }
        } else {
            Log-Message -Level WARNING -Message "Ownership failed for one or more keys. Skipping registry modifications."
            $overallSuccess = $false # Mark phase as potentially failed
        }
    } else {
        Log-Message -Level INFO -Message "Enhanced registry modification via ownership is disabled by configuration. Skipping ownership step."
        # Still attempt basic registry settings without ownership? Less likely to work but try anyway.
        Log-Message -Level INFO -Message "Attempting basic registry settings..."
         $registryModsAttempted = $true
         foreach ($setting in $defConfig.SettingsToApply) {
             if (Set-RegistrySafe -Path $setting.Path -Name $setting.Name -Value $setting.Value -Type $setting.Type -Force) { $registryModSuccessCount++ } else { $registryModFailCount++ }
         }
    }

    # Attempt Service Disabling (regardless of ownership success, as it might work sometimes)
    Log-Message -Level INFO -Message "Attempting to Stop and Disable Defender-related services..."
    foreach ($serviceName in $defConfig.ServicesToDisable) {
        # Stop first, then disable
        Manage-ServiceSafe -ServiceName $serviceName -Action Stop -Reason "Hyperion Defender Disable" # Ignore result of stop for now
        if (Manage-ServiceSafe -ServiceName $serviceName -Action Disable -Reason "Hyperion Defender Disable") {
             $serviceDisableSuccessCount++
        } else {
             # Check if failure was due to non-existence
             if ($Error[0].Exception.Message -like "*Cannot find any service*") {
                 # Ignore non-existent services count
             } else {
                $serviceDisableFailCount++
             }
        }
    }

    # Final Status Log
    Log-Message -Level INFO -Message "Registry Modifications Attempted: $registryModsAttempted (Success: $registryModSuccessCount, Failed: $registryModFailCount)"
    Log-Message -Level INFO -Message "Service Disabling Attempted: (Success: $serviceDisableSuccessCount, Failed: $serviceDisableFailCount)"

    if ($registryModFailCount -gt 0 -or $serviceDisableFailCount -gt 0) {
        Log-Message -Level WARNING -Message "Phase 11: Enhanced Defender Disable completed with failures. Defender may still be active or partially disabled. EXTREME RISK REMAINS."
        $overallSuccess = $false
    } else {
         Log-Message -Level SUCCESS -Message "Phase 11: Enhanced Defender Disable steps completed without direct errors. VERIFY STATUS AFTER RESTART. NO GUARANTEES."
    }

    return $overallSuccess
}

# Phase 12: Install Software via Winget
Function Invoke-Phase12_SoftwareInstallation {
     Log-Message -Level HEADER -Message "--- Phase 12: Install Software via Winget ---"
    if (-Not $Configuration.EnablePhase_SoftwareInstallation -or -Not $Configuration.Software.InstallViaWinget) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    $swConfig = $Configuration.Software
    if ($swConfig.WingetPackages.Count -eq 0) {
        Log-Message -Level INFO -Message "No Winget packages listed in configuration. Skipping installation."; return $true
    }

    Log-Message -Level INFO -Message "Attempting to install software using Winget. Requires internet connection."
    Log-Message -Level WARNING -Message "User MUST review and customize the package list in `$Configuration.Software.WingetPackages`!"
    Log-Message -Level INFO -Message "Packages to install: $($swConfig.WingetPackages -join ', ')"

    # Check internet connection first
    if (-not (Test-InternetConnection)) {
        Log-Message -Level ERROR -Message "Internet connection failed. Cannot proceed with Winget installations."
        return $false
    }

    $successCount = 0
    $failCount = 0

    # Ensure Winget exists? Winget should be present on modern Win10/11.
    # Check Winget source agreements? Sometimes needed on first run. `winget settings --enable Microsoft.Winget.Source_Experimental`? Too risky?

    foreach ($packageId in $swConfig.WingetPackages) {
         Log-Message -Level INFO -Message "Installing '$packageId'..."
         $command = "winget install --id `"$packageId`" $($swConfig.WingetInstallOptions)"
         Log-Message -Level VERBOSE -Message "Executing Winget command: $command"
         try {
            # Execute and capture output/errors if possible, or just check exit code
            $processInfo = Start-Process winget -ArgumentList "install --id `"$packageId`" $($swConfig.WingetInstallOptions.Split(' '))" -Wait -PassThru -WindowStyle Hidden
            $exitCode = $processInfo.ExitCode

            # $output = Invoke-Expression $command # Alternative, might capture stdout/stderr differently
            # $exitCode = $LASTEXITCODE

            if ($exitCode -eq 0) {
                 Log-Message -Level SUCCESS -Message "Successfully installed '$packageId'."
                 $successCount++
            } else {
                # Common Winget Exit Codes: https://docs.microsoft.com/en-us/windows/package-manager/winget/return-codes
                # Add more specific error messages based on exit code if desired
                Log-Message -Level WARNING -Message "Winget installation failed for '$packageId' (Exit Code: $exitCode). Check Winget logs (%LOCALAPPDATA%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir)."
                $failCount++
            }
         } catch {
             Log-Message -Level ERROR -Message "Error executing Winget command for '$packageId'. Exception: $($_.Exception.Message)"
             $failCount++
         }
         Start-Sleep -Seconds 2 # Small delay between installs
    }

    Log-Message -Level INFO -Message "Phase 12: Software Installation completed. Success: $successCount, Failed: $failCount."
    return ($failCount -eq 0)
}

# Phase 13: Attempt Set Default Browser
Function Invoke-Phase13_SetDefaultBrowser {
    Log-Message -Level HEADER -Message "--- Phase 13: Attempt Set Default Browser ---"
    if (-Not $Configuration.EnablePhase_SetDefaultBrowser -or -Not $Configuration.DefaultBrowser.AttemptSetDefault) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    $dbConfig = $Configuration.DefaultBrowser
    $targetBrowser = $dbConfig.BrowserToSet
    Log-Message -Level WARNING -Message "Attempting to set '$targetBrowser' as the default browser via Registry."
    Log-Message -Level WARNING -Message "This method is UNRELIABLE on modern Windows and may fail or be reset. Manual setting via 'Default Apps' is recommended."

    # Check if the target browser is supposed to be installed by the script
    $browserWingetId = switch ($targetBrowser) {
        "Chrome" { "Google.Chrome" }
        "Firefox" { "Mozilla.Firefox" }
        "Edge" { "Microsoft.Edge" } # Edge is usually built-in, but check ID if needed
        default { Log-Message -Level ERROR -Message "Invalid BrowserToSet '$targetBrowser' in configuration."; return $false }
    }

    # Verify the browser was in the install list (doesn't guarantee successful install)
    if ($Configuration.Software.WingetPackages -notcontains $browserWingetId -and $targetBrowser -ne "Edge") {
         Log-Message -Level WARNING -Message "'$targetBrowser' (ID: $browserWingetId) was not found in the Winget installation list. Skipping default browser setting."
         return $true # Skipped, not failed
    }

    # Find the ProgId
    $progId = $dbConfig.ProgIdMapping[$targetBrowser]
    if (-not $progId) {
        Log-Message -Level ERROR -Message "Could not find ProgId mapping for browser '$targetBrowser'."
        return $false
    }

    # Basic check if browser executable exists (improve this with registry checks for registered apps if needed)
    $browserPath = switch ($targetBrowser) {
        "Chrome" { @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe") }
        "Firefox" { @("$env:ProgramFiles\Mozilla Firefox\firefox.exe", "$env:ProgramFiles(x86)\Mozilla Firefox\firefox.exe") }
        "Edge" { @("$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") }
        default { @() }
    }
    $foundPath = $false
    foreach ($path in $browserPath) { if (Test-Path $path) { $foundPath = $true; Log-Message -Level DEBUG -Message "Found '$targetBrowser' executable at '$path'"; break } }

    if (-not $foundPath) {
         Log-Message -Level WARNING -Message "Executable for '$targetBrowser' not found in standard locations. Skipping default browser setting."
         return $true # Skipped, not failed
    }

    # Attempt to set registry keys
    $overallSuccess = $true
    try {
        foreach ($protocol in $dbConfig.ProtocolsToSet) {
            $keyPath = Join-Path -Path $dbConfig.UrlAssociationsPath -ChildPath "$protocol\UserChoice"
            Log-Message -Level INFO -Message "Attempting to set ProgId for protocol '$protocol' to '$progId' at '$keyPath'..."

            # Ensure path exists (might require HKCU context, but running as Admin should work)
             $parentPath = Split-Path -Path $keyPath -Parent
             if (-not (Test-Path $parentPath)) { New-Item -Path $parentPath -Force | Out-Null }
             if (-not (Test-Path $keyPath)) { New-Item -Path $keyPath -Force | Out-Null }

            # Set ProgId
            if (-not (Set-RegistrySafe -Path $keyPath -Name "ProgId" -Value $progId -Type String -Force)) {
                $overallSuccess = $false
            }

            # Remove Hash (This is the part that often makes it fail - Windows expects a specific hash)
            Log-Message -Level VERBOSE -Message "Attempting to remove Hash value from '$keyPath' (may not help)..."
            try {
                Remove-ItemProperty -Path $keyPath -Name "Hash" -Force -ErrorAction Stop
            } catch {
                # Silently ignore if hash doesn't exist or can't be removed
                 Log-Message -Level DEBUG -Message "Could not remove Hash property (or it didn't exist) for '$keyPath'."
            }
        }

         if ($overallSuccess) {
            Log-Message -Level SUCCESS -Message "Phase 13: Default Browser registry keys set (ATTEMPTED). Windows may ignore or reset this. Manual check required."
        } else {
             Log-Message -Level WARNING -Message "Phase 13: Failed to set one or more registry keys for Default Browser."
        }
        return $overallSuccess

    } catch {
        Log-Message -Level ERROR -Message "Phase 13: Unexpected error setting default browser. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 14: Optimize Visual Effects
Function Invoke-Phase14_VisualEffects {
    Log-Message -Level HEADER -Message "--- Phase 14: Optimize Visual Effects ---"
    if (-Not $Configuration.EnablePhase_VisualEffects -or -Not $Configuration.VisualEffects.OptimizeForPerformance) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Optimizing visual effects for performance..."
    $veConfig = $Configuration.VisualEffects
    $overallSuccess = $true
    $successCount = 0
    $failCount = 0

    try {
        # Method 1: Set VisualFXSetting to "Best Performance" (Value 2) - Simpler but less granular
        # Log-Message -Level VERBOSE -Message "Setting VisualFXSetting to 2 (Best Performance)..."
        # if (Set-RegistrySafe -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord -Force) { $successCount++ } else { $failCount++ }

        # Method 2: Set VisualFXSetting to "Custom" (Value 3) and apply specific settings (More control)
         Log-Message -Level VERBOSE -Message "Setting VisualFXSetting to 3 (Custom)..."
         if (Set-RegistrySafe -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 3 -Type DWord -Force) { $successCount++ } else { $failCount++ }

        # Apply specific registry settings from configuration
        Log-Message -Level INFO -Message "Applying specific visual effect registry settings..."
        foreach ($name in $veConfig.RegistrySettings.Keys) {
            $value = $veConfig.RegistrySettings[$name]
            $path = ""
            $type = "String" # Default, adjust as needed

            # Determine path and type based on setting name
            if ($name -eq "UserPreferencesMask") {
                $path = "HKCU:\Control Panel\Desktop"
                $type = "Binary"
            } elseif ($name -eq "DragFullWindows" -or $name -eq "FontSmoothing") { # Add more known Desktop keys here
                 $path = "HKCU:\Control Panel\Desktop"
                 $type = "String" # These are often strings despite being 0/1/2
                 # Special handling for FontSmoothing - ensure it's String
                 if($name -eq "FontSmoothing") {$type = "String"}

            } # Add more paths if needed for other keys

            if ($path) {
                if ($name -eq "UserPreferencesMask") {
                    Log-Message -Level VERBOSE -Message "Setting '$name' at '$path' (Binary Value)..."
                    # Value should already be byte array in config
                    if (Set-RegistrySafe -Path $path -Name $name -Value $value -Type $type -Force) { $successCount++ } else { $failCount++ }
                } else {
                     Log-Message -Level VERBOSE -Message "Setting '$name' to '$value' at '$path' (Type: $type)..."
                    if (Set-RegistrySafe -Path $path -Name $name -Value $value -Type $type -Force) { $successCount++ } else { $failCount++ }
                }
            } else {
                 Log-Message -Level WARNING -Message "Unknown registry path for visual effect setting '$name'. Skipping."
                 $failCount++ # Count as fail if path isn't defined
            }
        }

        # Method 3: Use SystemParametersInfo (More complex, requires P/Invoke or external tool, not implemented here for simplicity)
        # Log-Message -Level INFO -Message "SystemParametersInfo method not implemented in this script."

         # Attempt to broadcast setting change (may not work for all settings)
        try {
             Log-Message -Level VERBOSE -Message "Broadcasting WM_SETTINGCHANGE..."
             # Simple broadcast attempt using rundll32 (less reliable)
             Start-Process rundll32.exe "user32.dll,UpdatePerUserSystemParameters 1, True" -WindowStyle Hidden -ErrorAction SilentlyContinue | Out-Null
        } catch {Log-Message -Level DEBUG -Message "Failed to broadcast setting change (normal)."}


        if ($failCount -eq 0) {
            Log-Message -Level SUCCESS -Message "Phase 14: Visual Effects optimized for performance successfully."
        } else {
             Log-Message -Level WARNING -Message "Phase 14: Visual Effects optimization completed with $failCount errors."
        }
        return ($failCount -eq 0)

    } catch {
        Log-Message -Level ERROR -Message "Phase 14: Unexpected error optimizing visual effects. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 15: Hardware Check & Information
Function Invoke-Phase15_HardwareCheck {
    Log-Message -Level HEADER -Message "--- Phase 15: Hardware Check & Information ---"
    if (-Not $Configuration.EnablePhase_HardwareCheck -or -Not $Configuration.HardwareCheck.EnableCheck) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Gathering basic hardware information..."
    $hwConfig = $Configuration.HardwareCheck
    $overallSuccess = $true

    try {
        # Get CPU Info
        if ($hwConfig.CheckCPU) {
            Log-Message -Level INFO -Message "`nCPU Information:"
            $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1 -Property Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, Manufacturer, SocketDesignation
            $cpu | Format-List | Out-String | Write-Host # Log to console/transcript
            Log-Message -Level VERBOSE -Message "CPU details logged."
        }

         # Get RAM Info
        if ($hwConfig.CheckRAM) {
            Log-Message -Level INFO -Message "`nRAM Information:"
            $totalRamGB = [Math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
            $memoryModules = Get-CimInstance Win32_PhysicalMemory | Select-Object BankLabel, Capacity, Speed, Manufacturer, PartNumber, DeviceLocator
            Log-Message -Level INFO -Message "Total Installed RAM: $totalRamGB GB"
            Log-Message -Level INFO -Message "Memory Modules:"
            $memoryModules | Format-Table -AutoSize | Out-String | Write-Host
            Log-Message -Level VERBOSE -Message "RAM details logged."
        }

        # Get GPU Info
        if ($hwConfig.CheckGPU) {
            Log-Message -Level INFO -Message "`nGraphics Card(s) Information:"
            $gpus = Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, DriverVersion, VideoProcessor, AdapterCompatibility
            if ($gpus) {
                $gpus | Format-List | Out-String | Write-Host
                foreach ($gpu in $gpus){
                    if ($gpu.AdapterCompatibility -like "*NVIDIA*") { Log-Message -Level WARNING -Message "  -> NVIDIA GPU: Recommend checking NVIDIA.com drivers post-restart." }
                    elseif ($gpu.AdapterCompatibility -like "*AMD*" -or $gpu.AdapterCompatibility -like "*ATI*") { Log-Message -Level WARNING -Message "  -> AMD/ATI GPU: Recommend checking AMD.com drivers post-restart." }
                    elseif ($gpu.AdapterCompatibility -like "*Intel*") { Log-Message -Level INFO -Message "  -> Intel GPU: Check WU/Intel DSA post-restart." }
                }
            } else { Log-Message -Level WARNING -Message "Could not detect Graphics Card details." }
            Log-Message -Level VERBOSE -Message "GPU details logged."
        }

        # Get Network Info
        if ($hwConfig.CheckNetwork) {
             Log-Message -Level INFO -Message "`nActive Network Adapter(s) Information:"
             $netAdapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'} | Select-Object Name, InterfaceDescription, Status, MacAddress, LinkSpeed, DriverVersion, DriverDate
             if ($netAdapters) {
                 $netAdapters | Format-List | Out-String | Write-Host
                 foreach ($adapter in $netAdapters) {
                     if ($adapter.InterfaceDescription -like "*Intel*") { Log-Message -Level WARNING -Message "  -> Intel NIC: Check Intel DSA post-restart." }
                     elseif ($adapter.InterfaceDescription -like "*Realtek*") { Log-Message -Level WARNING -Message "  -> Realtek NIC: Check manufacturer site post-restart." }
                     elseif ($adapter.InterfaceDescription -like "*Killer*") { Log-Message -Level WARNING -Message "  -> Killer(Intel) NIC: Check Intel/manufacturer site post-restart." }
                 }
             } else { Log-Message -Level WARNING -Message "Could not detect active Network Adapter details." }
             Log-Message -Level VERBOSE -Message "Network details logged."
        }

        # Get Disk Info
        if ($hwConfig.CheckDisk) {
             Log-Message -Level INFO -Message "`nDisk Drive Information:"
             # Physical Disks
             $physicalDisks = Get-Disk | Select-Object Number, FriendlyName, Manufacturer, Model, SerialNumber, Size, MediaType, HealthStatus
             Log-Message -Level INFO -Message "Physical Disks:"
             $physicalDisks | Format-Table -AutoSize | Out-String | Write-Host
             # Logical Disks (Volumes)
             $logicalDisks = Get-Volume | Select-Object DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size, HealthStatus, DriveType
             Log-Message -Level INFO -Message "Volumes:"
             $logicalDisks | Format-Table -AutoSize | Out-String | Write-Host
             Log-Message -Level VERBOSE -Message "Disk details logged."
        }

        Log-Message -Level SUCCESS -Message "Phase 15: Hardware Check completed."
        return $true

    } catch {
        Log-Message -Level ERROR -Message "Phase 15: Error during Hardware Check. Error: $($_.Exception.Message)"
        return $false
    }
}

# Phase 16: Run Windows Update
Function Invoke-Phase16_WindowsUpdate {
    Log-Message -Level HEADER -Message "--- Phase 16: Run Windows Update ---"
    if (-Not $Configuration.EnablePhase_WindowsUpdate -or -Not $Configuration.WindowsUpdate.RunUpdate) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Attempting to check for and install all available Windows Updates..."
    Log-Message -Level WARNING -Message "This requires a stable internet connection and can take a VERY LONG time. System may restart multiple times if PSWindowsUpdate handles it (though configured not to here)."
    $wuConfig = $Configuration.WindowsUpdate
    $overallSuccess = $true

    try {
        # Check Disk Space
        $freeSpace = Get-DiskSpaceGB -DriveLetter "C"
        if ($freeSpace -lt $wuConfig.RequiredFreeSpaceGB) {
            Log-Message -Level ERROR -Message "Insufficient disk space on C: drive (Required: $($wuConfig.RequiredFreeSpaceGB) GB, Available: $freeSpace GB). Skipping Windows Update."
            return $false
        }

        # Check Internet Connection
        if (-not (Test-InternetConnection)) {
            Log-Message -Level ERROR -Message "Internet connection failed. Cannot proceed with Windows Update."
            return $false
        }

        # Install/Import PSWindowsUpdate Module
        if ($wuConfig.InstallPSWindowsUpdateModule) {
            Log-Message -Level INFO -Message "Checking/Installing PSWindowsUpdate module..."
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Log-Message -Level INFO -Message "PSWindowsUpdate module not found. Attempting installation (requires NuGet Provider)..."
                try {
                    # Ensure NuGet provider is available
                    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop | Out-Null
                    # Install the module
                    Install-Module PSWindowsUpdate -Force -Scope CurrentUser -AcceptLicense -Confirm:$false -ErrorAction Stop
                    Log-Message -Level SUCCESS -Message "PSWindowsUpdate module installed successfully."
                } catch {
                    Log-Message -Level ERROR -Message "Failed to install PSWindowsUpdate module. Error: $($_.Exception.Message). Skipping Windows Update."
                    return $false
                }
            } else { Log-Message -Level INFO -Message "PSWindowsUpdate module already available." }
        }

        # Import the module
        Log-Message -Level VERBOSE -Message "Importing PSWindowsUpdate module..."
        try {
            Import-Module PSWindowsUpdate -ErrorAction Stop
        } catch {
            Log-Message -Level ERROR -Message "Failed to import PSWindowsUpdate module. Error: $($_.Exception.Message). Skipping Windows Update."
            return $false
        }

        # Run Windows Update Check & Install
        Log-Message -Level INFO -Message "Running Get-WindowsUpdate with configured arguments..."
        Log-Message -Level VERBOSE -Message "Arguments: $($wuConfig.PSWindowsUpdateArgs | Out-String)"
        # Execute Get-WindowsUpdate with splatting for arguments
        Get-WindowsUpdate @wuConfig.PSWindowsUpdateArgs -ErrorAction Stop
        # Check $? or specific error handling if Get-WindowsUpdate provides it

        Log-Message -Level SUCCESS -Message "Phase 16: Windows Update check and installation process completed (or attempted)."
        return $true

    } catch {
        Log-Message -Level ERROR -Message "Phase 16: Error during Windows Update process. Error: $($_.Exception.Message)"
        Log-Message -Level WARNING -Message "Updates may not be fully installed. Check Windows Update settings manually after restart."
        return $false
    }
}

# Phase 17: System Cleanup
Function Invoke-Phase17_SystemCleanup {
    Log-Message -Level HEADER -Message "--- Phase 17: System Cleanup ---"
    if (-Not $Configuration.EnablePhase_SystemCleanup -or -Not $Configuration.SystemCleanup.EnableCleanup) {
        Log-Message -Level INFO -Message "Phase skipped by configuration."; return $true
    }

    Log-Message -Level INFO -Message "Performing final system cleanup operations..."
    $scConfig = $Configuration.SystemCleanup
    $overallSuccess = $true

    try {
        # 1. Clean Standard Temp Folders
        if ($scConfig.CleanStandardTemp) {
            Log-Message -Level INFO -Message "Cleaning standard temporary folders..."
            $tempPaths = @("$env:TEMP", "$env:windir\Temp")
            $startupCleanupScriptFullPath = Join-Path -Path $Configuration.StartupCleanup.ScriptPath -ChildPath $Configuration.StartupCleanup.ScriptFileName
            foreach ($path in $tempPaths) {
                Log-Message -Level VERBOSE -Message "Cleaning path: $path (excluding '$startupCleanupScriptFullPath' if present)"
                if (Test-Path $path) {
                    Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.FullName -ne $startupCleanupScriptFullPath } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                } else { Log-Message -Level DEBUG -Message "Path '$path' not found." }
            }
            Log-Message -Level SUCCESS -Message "Standard temporary folders cleaned."
        }

        # 2. Flush DNS Cache
        if ($scConfig.FlushDNSCache) {
             Log-Message -Level INFO -Message "Flushing DNS cache..."
             try { ipconfig /flushdns | Out-Null; Log-Message -Level SUCCESS -Message "DNS cache flushed."}
             catch { Log-Message -Level WARNING -Message "Failed to flush DNS cache: $($_.Exception.Message)"; $overallSuccess = $false }
        }

        # 3. Run DISM Component Store Cleanup
        if ($scConfig.RunDISMCleanup) {
             Log-Message -Level INFO -Message "Running DISM /Online /Cleanup-Image /StartComponentCleanup..."
             # Check Disk Space
             $freeSpace = Get-DiskSpaceGB -DriveLetter "C"
             if ($freeSpace -lt $scConfig.DISMRequiredFreeSpaceGB) {
                 Log-Message -Level WARNING -Message "Insufficient disk space for DISM Cleanup (Required: $($scConfig.DISMRequiredFreeSpaceGB) GB, Available: $freeSpace GB). Skipping."
             } else {
                 Log-Message -Level INFO -Message "Executing DISM (this may take a long time)..."
                 $dismArgs = "/Online /Cleanup-Image /StartComponentCleanup /Quiet"
                 $process = Start-Process Dism.exe -ArgumentList $dismArgs -Wait -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue
                 if ($process.ExitCode -ne 0) {
                     Log-Message -Level WARNING -Message "DISM /StartComponentCleanup completed with issues (Exit Code: $($process.ExitCode)). Check CBS log for details."
                     $overallSuccess = $false # Mark as potential failure
                 } else { Log-Message -Level SUCCESS -Message "DISM /StartComponentCleanup completed successfully." }
             }
        }

        # 4. Run DISM Reset Base (Optional, High Risk)
        if ($scConfig.RunDISMResetBase) {
             Log-Message -Level WARNING -Message "Running DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase..."
             Log-Message -Level WARNING -Message "This makes installed updates permanent and prevents uninstallation! Reduces WinSxS size."
              # Check Disk Space (again, might be needed)
             $freeSpace = Get-DiskSpaceGB -DriveLetter "C"
             if ($freeSpace -lt $scConfig.DISMRequiredFreeSpaceGB) { # Use same requirement for simplicity
                 Log-Message -Level WARNING -Message "Insufficient disk space for DISM ResetBase (Required: $($scConfig.DISMRequiredFreeSpaceGB) GB, Available: $freeSpace GB). Skipping."
             } else {
                 Log-Message -Level INFO -Message "Executing DISM ResetBase (this may take a long time)..."
                 $dismArgs = "/Online /Cleanup-Image /StartComponentCleanup /ResetBase /Quiet"
                 $process = Start-Process Dism.exe -ArgumentList $dismArgs -Wait -PassThru -WindowStyle Hidden -ErrorAction SilentlyContinue
                 if ($process.ExitCode -ne 0) {
                     Log-Message -Level WARNING -Message "DISM /ResetBase completed with issues (Exit Code: $($process.ExitCode)). Check CBS log."
                     $overallSuccess = $false
                 } else { Log-Message -Level SUCCESS -Message "DISM /ResetBase completed successfully." }
             }
        }

        # 5. Run fstrim (Optimize-Volume)
        if ($scConfig.RunFstrim) {
            Log-Message -Level INFO -Message "Running Optimize-Volume -ReTrim on C: drive (for SSDs)..."
            try {
                Optimize-Volume -DriveLetter C -ReTrim -Verbose -ErrorAction Stop # Verbose will show output in transcript
                Log-Message -Level SUCCESS -Message "Optimize-Volume -ReTrim completed for C:."
            } catch {
                 Log-Message -Level WARNING -Message "Failed to run Optimize-Volume -ReTrim on C:. Error: $($_.Exception.Message) (May not be SSD or drive busy)."
                 # Don't mark overall phase as fail for this, might be HDD
            }
        }

        # 6. Clear Windows Event Logs (Optional)
        if ($scConfig.ClearWindowsEventLogs -and $Configuration.StartupCleanup.EventLogsToClear) {
             Log-Message -Level WARNING -Message "Clearing specified Windows Event Logs..."
             $logsToClear = $Configuration.StartupCleanup.EventLogsToClear
             foreach ($logName in $logsToClear) {
                 Log-Message -Level VERBOSE -Message "Clearing Event Log: $logName"
                 try {
                     Clear-EventLog -LogName $logName -ErrorAction Stop
                     Log-Message -Level SUCCESS -Message "Cleared Event Log: $logName"
                 } catch {
                     Log-Message -Level WARNING -Message "Failed to clear Event Log '$logName': $($_.Exception.Message)"
                     # Don't mark overall phase as fail for optional cleanup item
                 }
             }
        }

        Log-Message -Level INFO -Message "Phase 17: System Cleanup completed."
        return $overallSuccess

    } catch {
        Log-Message -Level ERROR -Message "Phase 17: Unexpected error during System Cleanup. Error: $($_.Exception.Message)"
        return $false
    }
}

#endregion

#-----------------------------------------------------------------------------------------------------------------------
# --- Main Execution Logic ---
#-----------------------------------------------------------------------------------------------------------------------
$script:StartTime = Get-Date
$script:TranscriptActive = $false
$script:TP_Disable_Attempt_Success = $false # Initialize global flag

# Start Transcript Logging if enabled
if ($Configuration.EnableTranscriptLogging) {
    try {
        if (-not (Test-Path $Configuration.LogDirectory)) {
            New-Item -Path $Configuration.LogDirectory -ItemType Directory -Force | Out-Null
        }
        Start-Transcript -Path $Configuration.LogFilePath -Append -Force -IncludeInvocationHeader
        $script:TranscriptActive = $true
        Log-Message -Level INFO -Message "Transcript logging started: $($Configuration.LogFilePath)"
    } catch {
        $script:TranscriptActive = $false
        Write-Warning "Failed to start transcript logging to '$($Configuration.LogFilePath)': $($_.Exception.Message)"
    }
}

Log-Message -Level HEADER -Message "====================================================================="
Log-Message -Level HEADER -Message "$($Configuration.ScriptName) v$($Configuration.ScriptVersion) Execution Start"
Log-Message -Level HEADER -Message "Start Time: $($script:StartTime)"
Log-Message -Level HEADER -Message "====================================================================="
Log-Message -Level WARNING -Message "!!! EXTREME RISK SCRIPT - READ ALL WARNINGS CAREFULLY !!!"

# Run Phase 0: Admin Check (Mandatory - will halt if failed)
if (-not (Invoke-Phase0_CheckAdmin)) {
    # Error message handled within the function, script halted by Write-Error -ErrorAction Stop
    # Add cleanup code here if needed before halting, though Write-Error Stop might prevent it.
    if ($script:TranscriptActive) { Stop-Transcript }
    Exit 1
}

# Display Final Warning and Countdown
Log-Message -Level WARNING -Message "*********************************************************************"
Log-Message -Level WARNING -Message "*** FINAL WARNING - EXTREME SYSTEM MODIFICATIONS INITIATING ***"
Log-Message -Level WARNING -Message "* This script will apply AGGRESSIVE changes:"
Log-Message -Level WARNING -Message "* - Disable Security (Defender*, TP*, Services, Tasks -> HIGH RISK!)"
Log-Message -Level WARNING -Message "* - Max Performance Power Plan (Overheat/Wear Risk)"
Log-Message -Level WARNING -Message "* - Network/System/Registry Tweaks (Instability Risk)"
Log-Message -Level WARNING -Message "* - Service Disabling WILL BREAK FEATURES (e.g., Windows Search)"
Log-Message -Level WARNING -Message "* - Software Installs, WU Runs (Require Internet, Time)"
Log-Message -Level WARNING -Message "* - Automatic RESTART at the end (if configured)"
Log-Message -Level WARNING -Message "* NO UNDO. ALL RISKS ACCEPTED BY USER."
Log-Message -Level WARNING -Message "*********************************************************************"
Write-Host "`n" # Newline before countdown

$countdown = $Configuration.FinalWarningCountdownSeconds
for ($i = $countdown; $i -ge 1; $i--) {
    Write-Progress -Activity "FINAL WARNING - PRESS CTRL+C TO ABORT NOW!" -Status "Executing in $i seconds... ALL RISKS ACCEPTED!" -PercentComplete (($countdown - $i) / $countdown * 100) -Id 99
    Start-Sleep -Seconds 1
}
Write-Progress -Activity "FINAL WARNING" -Status "Executing..." -Completed -Id 99
Log-Message -Level FATAL -Message "--- EXECUTION STARTED - NO GOING BACK ---"
Start-Sleep -Seconds 2

# --- Execute Phases ---
# Store phase results
$PhaseResults = @{}

# Define the order and functions for each phase
$PhaseExecutionOrder = @(
    @{ Name="Phase1_TamperProtection"; Function="Invoke-Phase1_TamperProtection"; EnableConfig=$Configuration.EnablePhase_TamperProtection }
    @{ Name="Phase2_PowerSettings"; Function="Invoke-Phase2_PowerSettings"; EnableConfig=$Configuration.EnablePhase_PowerSettings }
    @{ Name="Phase3_ServiceDisabling"; Function="Invoke-Phase3_ServiceDisabling"; EnableConfig=$Configuration.EnablePhase_ServiceDisabling }
    @{ Name="Phase4_NetworkTweaks"; Function="Invoke-Phase4_NetworkTweaks"; EnableConfig=$Configuration.EnablePhase_NetworkTweaks }
    @{ Name="Phase5_PagefileManagement"; Function="Invoke-Phase5_PagefileManagement"; EnableConfig=$Configuration.EnablePhase_PagefileManagement }
    @{ Name="Phase6_SystemRegistryTweaks"; Function="Invoke-Phase6_SystemRegistryTweaks"; EnableConfig=$Configuration.EnablePhase_SystemRegistryTweaks }
    @{ Name="Phase7_ScheduledTaskDisabling"; Function="Invoke-Phase7_ScheduledTaskDisabling"; EnableConfig=$Configuration.EnablePhase_ScheduledTaskDisabling }
    @{ Name="Phase8_DesktopIcons"; Function="Invoke-Phase8_DesktopIcons"; EnableConfig=$Configuration.EnablePhase_DesktopIcons }
    @{ Name="Phase9_StartupCleanupTask"; Function="Invoke-Phase9_StartupCleanupTask"; EnableConfig=$Configuration.EnablePhase_StartupCleanupTask }
    @{ Name="Phase10_RAMManagementTask"; Function="Invoke-Phase10_RAMManagementTask"; EnableConfig=$Configuration.EnablePhase_RAMManagementTask }
    @{ Name="Phase11_DefenderDisable"; Function="Invoke-Phase11_DefenderDisable"; EnableConfig=$Configuration.EnablePhase_DefenderDisable }
    @{ Name="Phase12_SoftwareInstallation"; Function="Invoke-Phase12_SoftwareInstallation"; EnableConfig=$Configuration.EnablePhase_SoftwareInstallation }
    @{ Name="Phase13_SetDefaultBrowser"; Function="Invoke-Phase13_SetDefaultBrowser"; EnableConfig=$Configuration.EnablePhase_SetDefaultBrowser }
    @{ Name="Phase14_VisualEffects"; Function="Invoke-Phase14_VisualEffects"; EnableConfig=$Configuration.EnablePhase_VisualEffects }
    @{ Name="Phase15_HardwareCheck"; Function="Invoke-Phase15_HardwareCheck"; EnableConfig=$Configuration.EnablePhase_HardwareCheck }
    @{ Name="Phase16_WindowsUpdate"; Function="Invoke-Phase16_WindowsUpdate"; EnableConfig=$Configuration.EnablePhase_WindowsUpdate }
    @{ Name="Phase17_SystemCleanup"; Function="Invoke-Phase17_SystemCleanup"; EnableConfig=$Configuration.EnablePhase_SystemCleanup }
)

# Filter phases based on configuration flags
$EnabledPhases = $PhaseExecutionOrder | Where-Object { $_.EnableConfig -eq $true }
$script:TotalPhasesToRun = $EnabledPhases.Count # Update global for progress bar
$currentPhaseNumber = 0 # Start from 0 for progress calc

foreach ($phaseInfo in $EnabledPhases) {
    $currentPhaseNumber++ # Increment at the start for 1-based display
    $phaseName = $phaseInfo.Name
    $phaseFunction = $phaseInfo.Function

    # Update progress bar based on phase name and number
    Update-Progress -StatusMessage "Executing $phaseName..." -PhaseNumber $currentPhaseNumber

    $phaseStartTime = Get-Date
    $result = $false
    try {
        # Execute the phase function
        Log-Message -Level DEBUG -Message "Calling function: $phaseFunction for phase: $phaseName (Phase $currentPhaseNumber of $($script:TotalPhasesToRun))"
        $result = Invoke-Command -ScriptBlock ([ScriptBlock]::Create($phaseFunction))
        if ($null -eq $result) {$result = $true} # Assume true if function returns $null or nothing explicitly
        $PhaseResults[$phaseName] = @{ StartTime = $phaseStartTime; EndTime = Get-Date; Success = $result }
    } catch {
        # Catch errors from Invoke-Command or within the phase function if not caught internally
        $endTime = Get-Date
        Log-Message -Level FATAL -Message "FATAL ERROR during execution of phase '$phaseName'. Error: $($_.Exception.Message)"
        $PhaseResults[$phaseName] = @{ StartTime = $phaseStartTime; EndTime = $endTime; Success = $false; Error = $_.Exception.Message }
        # Decide whether to continue or halt on fatal phase error? For AIO, maybe continue but log?
        # For now, let's continue.
    }
     Start-Sleep -Seconds 1 # Small delay between phases
}

# --- Finalization ---
$script:EndTime = Get-Date
$script:Duration = $script:EndTime - $script:StartTime

Log-Message -Level HEADER -Message "====================================================================="
Log-Message -Level HEADER -Message "$($Configuration.ScriptName) Execution Finished"
Log-Message -Level HEADER -Message "End Time: $($script:EndTime)"
Log-Message -Level HEADER -Message "Total Duration: $($script:Duration.ToString())"
Log-Message -Level HEADER -Message "====================================================================="

# Log Phase Summary
Log-Message -Level INFO -Message "Phase Execution Summary:"
foreach ($phaseName in $PhaseResults.Keys) {
    $result = $PhaseResults[$phaseName]
    $status = if ($result.Success) { "SUCCESS" } else { "FAILED" }
    $color = if ($result.Success) { "Green" } else { "Red" }
    $duration = $result.EndTime - $result.StartTime
    Log-Message -Level INFO -Message (" - {0,-30} : {1,-7} ({2:N2} seconds)" -f $phaseName, $status, $duration.TotalSeconds) -ForegroundColor $color
    if (-not $result.Success -and $result.Contains("Error")) { # Check if Error key exists
        Log-Message -Level WARNING -Message "   Error Details: $($result.Error)"
    }
}
Log-Message -Level INFO -Message "---------------------------------------------------------------------"
Log-Message -Level WARNING -Message "REMINDER: System restart is required for many changes to take effect."
Log-Message -Level WARNING -Message "After restart: VERIFY STABILITY, check temperatures, Defender status, default apps, drivers."
Log-Message -Level FATAL   -Message "ALL RISKS WERE ACCEPTED BY INITIATING THIS SCRIPT."
Log-Message -Level INFO -Message "---------------------------------------------------------------------"


# Automatic Restart if configured
if ($Configuration.ForceAutoRestart) {
    Log-Message -Level WARNING -Message "*** SYSTEM WILL RESTART AUTOMATICALLY IN 10 SECONDS ***"
    Log-Message -Level WARNING -Message "- Save any work NOW!"
    # Final Countdown before restart
    $restartCountdown = 10
    for ($i = $restartCountdown; $i -ge 1; $i--) {
        Write-Progress -Activity "AUTO-RESTART INITIATED" -Status "Restarting in $i seconds..." -PercentComplete (($restartCountdown - $i) / $restartCountdown * 100) -Id 100
        Start-Sleep -Seconds 1
    }
    Write-Progress -Activity "AUTO-RESTART" -Status "Restarting now..." -Completed -Id 100

    Log-Message -Level FATAL -Message "[!!!] Initiating Forced System Restart NOW! [!!!]"

    # Stop transcript before restarting
    if ($script:TranscriptActive) {
        try { Stop-Transcript } catch {}
    }
    Restart-Computer -Force
} else {
    Log-Message -Level INFO -Message "Automatic restart is disabled by configuration. Please restart manually."
}

# Stop Transcript if still active (e.g., if restart is disabled)
if ($script:TranscriptActive -and -not $Configuration.ForceAutoRestart) {
    try { Stop-Transcript } catch {}
}

#-----------------------------------------------------------------------------------------------------------------------
# SCRIPT END
#-----------------------------------------------------------------------------------------------------------------------
Exit 0
