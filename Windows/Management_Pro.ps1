<#
.SYNOPSIS
    Windows Optimization Script v3.5 - Enhanced Edition - Optimized (Powershell Version)

.DESCRIPTION
    This script is a PowerShell version of the original Bat script for Windows optimization.
    It provides various options to enhance system performance, manage Windows features, and more.
    It is optimized for Windows 11, and compatibility issues may occur on older versions.

.NOTES
    Version: 3.5 - Enhanced Edition (PowerShell)
    Author: GT Singtaro (Converted from Bat Script)

    **คำเตือน**: Script นี้ปรับให้เหมาะสมสำหรับ Windows 11. Windows 10 หรือเก่ากว่าอาจมีปัญหาความเข้ากันได้.
    **คำเตือน**: ตัวเลือก [11] KMS Activation:  มีความเสี่ยงด้านความปลอดภัยและกฎหมายสูง!
    **คำเตือน**: ตัวเลือก [14] จัดการพาร์ติชัน: มีความเสี่ยงสูงที่จะสูญเสียข้อมูลถาวร! สำรองข้อมูลก่อน!
    **คำเตือน**: ตัวเลือก [7, 27, 4, 20, 21] เป็นตัวเลือกขั้นสูง, ใช้ด้วยความระมัดระวัง.
#>

#region Script Initialization

#region Check Windows Version
if ((Get-WmiObject win32_operatingsystem).version -like "10.0.*") {
    Write-Host ""
    Write-Host "[!] ======================================================================= [!] " -ForegroundColor Yellow
    Write-Host "[!] **คำเตือน:** Script นี้ปรับให้เหมาะสมสำหรับ Windows 11. Windows 10    [!] " -ForegroundColor Yellow
    Write-Host "[!] หรือเก่ากว่าอาจมีปัญหาความเข้ากันได้.                                  [!] " -ForegroundColor Yellow
    Write-Host "[!] ======================================================================= [!] " -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Check Admin Rights
function Check-AdminRights {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host ""
        Write-Host "[!] **ข้อผิดพลาด:** จำเป็นต้องมีสิทธิ์ผู้ดูแลระบบ. กรุณา Run as administrator." -ForegroundColor Red
        Write-Host ""
        Read-Host -Prompt "Press Enter to exit..."
        exit
    }
}
Check-AdminRights
#endregion

#region Get System Status Function
function Get-SystemStatus {
    # Windows Defender Status
    $global:defender_status = Get-DefenderStatusInternal

    # Windows Update Status
    $global:update_status = Get-UpdateStatusInternal

    # Power Plan Status
    $global:powerplan_name = Get-PowerPlanStatusInternal

    # Dark Mode Status
    $global:darkmode_status = Get-DarkModeStatusInternal

    # GPU Scheduling Status
    $global:gpu_scheduling_status = Get-GPUSchedulingStatusInternal
}

function Get-DefenderStatusInternal {
    if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender") {
        $defenderPolicy = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
        if ($defenderPolicy -and $defenderPolicy.DisableAntiSpyware -eq 1) {
            return "Disabled (Policy)"
        } else {
            return "Enabled (Policy)"
        }
    } elseif (Test-Path "$env:ProgramFiles\Windows Defender\MpCmdRun.exe") {
        if (Get-Service -Name windefend -ErrorAction SilentlyContinue) {
            if ((Get-Service -Name windefend).Status -eq "Running") {
                return "Enabled (Service Running)"
            } else {
                return "Disabled (Service Stopped)"
            }
        } else {
            return "Disabled (Service Stopped)"
        }
    } else {
        return "Not Available"
    }
}

function Get-UpdateStatusInternal {
    if (Get-Service -Name wuauserv -ErrorAction SilentlyContinue) {
        if ((Get-Service -Name wuauserv).Status -eq "Disabled") {
            return "Disabled"
        } else {
            return "Enabled"
        }
    } else {
        return "Unknown"
    }
}

function Get-PowerPlanStatusInternal {
    $activePlanGuid = (powercfg /getactivescheme | ForEach-Object { $_ -match '(?<guid>[\w-]+)\s+\(.*\)' > $null; $Matches['guid'] })
    if ($activePlanGuid) {
        $powerPlanName = (powercfg /query $activePlanGuid /name | Select-String -Pattern "Scheme name" | ForEach-Object { $_ -replace 'Scheme name\s+:\s+','' }).Trim()
        if ($powerPlanName) {
            return $powerPlanName
        }
    }
    return "Unknown"
}

function Get-DarkModeStatusInternal {
    if (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize") {
        $appsUseLightTheme = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
        $systemUsesLightTheme = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -ErrorAction SilentlyContinue
        if ($appsUseLightTheme -is [int] -and $systemUsesLightTheme -is [int]) {
            if ($appsUseLightTheme -eq 0 -and $systemUsesLightTheme -eq 0) {
                return "Enabled"
            } else {
                return "Disabled"
            }
        } else {
            return "Disabled"
        }
    } else {
        return "Disabled"
    }
}

function Get-GPUSchedulingStatusInternal {
    if ((Get-WmiObject win32_operatingsystem).version -like "10.0.19041*") {
        if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers") {
            $hwSchMode = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -ErrorAction SilentlyContinue
            if ($hwSchMode -is [int] -and $hwSchMode -eq 2) {
                return "Enabled (Supported)"
            } else {
                return "Disabled (Supported)"
            }
        } else {
            return "Disabled (Supported)"
        }
    } else {
        return "Not Supported"
    }
}

Get-SystemStatus
#endregion

#endregion

#region Main Menu and Options
function Show-MainMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════════════════════════════════════════════╗"
    Write-Host " ║                      ** System Status Dashboard **                      ║"
    Write-Host " ╠══════════════════════════════════════════════════════════════════╣"
    Write-Host " ║ Windows Defender     : $($global:defender_status)                                 ║"
    Write-Host " ║ Windows Update       : $($global:update_status)                                   ║"
    Write-Host " ║ Power Plan           : $($global:powerplan_name)                                  ║"
    Write-Host " ║ Dark Mode            : $($global:darkmode_status)                                   ║"
    Write-Host " ║ GPU Scheduling       : $($global:gpu_scheduling_status)                             ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    Write-Host " ╔══════════════════════════════════════════════════════════════════╗"
    Write-Host " ║             Windows Optimization Script v3.5 - Enhanced Edition             ║"
    Write-Host " ╠══════════════════════════════════════════════════════════════════╣"
    Write-Host " ║ กรุณาเลือกตัวเลือก:                                                         ║"
    Write-Host " ║                                                                          ║"
    Write-Host " ║  [1] ปรับแต่งประสิทธิภาพการแสดงผล       [11] เปิดใช้งาน Windows (KMS - **เสี่ยง!**)  [21] ปรับแต่งเครือข่าย    ║"
    Write-Host " ║  [2] จัดการ Windows Defender             [12] จัดการการตั้งค่าพลังงาน                [22] ออกจากโปรแกรม        ║"
    Write-Host " ║  [3] ปรับแต่งคุณสมบัติระบบ                [13] เปิดใช้งาน Dark Mode                     [23] ปิดใช้งานเอฟเฟกต์โปร่งใส   ║"
    Write-Host " ║  [4] ปรับแต่งประสิทธิภาพ CPU               [14] จัดการพาร์ติชัน (**เสี่ยงข้อมูลหาย!**)    [24] ปิดใช้งาน Animation พิเศษ   ║"
    Write-Host " ║  [5] ปรับแต่งประสิทธิภาพอินเทอร์เน็ต        [15] ล้างไฟล์ขยะใน Disk                    [25] ปรับแต่ง Storage Sense     ║"
    Write-Host " ║  [6] จัดการ Windows Update                [16] จัดการโปรแกรม Startup                 [26] ปิดเสียง Startup          ║"
    Write-Host " ║  [7] ตั้งค่า Auto-login (**เสี่ยงด้านความปลอดภัย!**) [17] สำรองและกู้คืนการตั้งค่า         [27] ปรับแต่ง Paging File (**ขั้นสูง!**) ║"
    Write-Host " ║  [8] ล้าง System Cache                   [18] ข้อมูลระบบ                              [28] ปิด Widget Features (Win11) ║"
    Write-Host " ║  [9] ปรับแต่ง Disk                        [19] ปรับแต่งการตั้งค่าความเป็นส่วนตัว       [29] ปรับแต่ง Game Mode Settings  ║"
    Write-Host " ║  [10] ตรวจสอบและซ่อมแซม System Files      [20] จัดการ Windows Services               [30] กลับสู่เมนูหลัก          ║"
    Write-Host " ║                                                                          ║"
    Write-Host " ║ **คำเตือน**:                                                                ║"
    Write-Host " ║  - ตัวเลือก [11] KMS Activation:  **มีความเสี่ยงด้านความปลอดภัยและกฎหมายสูง!**   ║" -ForegroundColor Yellow
    Write-Host " ║  - ตัวเลือก [14] จัดการพาร์ติชัน: **มีความเสี่ยงสูงที่จะสูญเสียข้อมูลถาวร! สำรองข้อมูลก่อน!** ║" -ForegroundColor Yellow
    Write-Host " ║  - ตัวเลือก [7, 27, 4, 20, 21] เป็นตัวเลือกขั้นสูง, ใช้ด้วยความระมัดระวัง.         ║" -ForegroundColor Yellow
    Write-Host " ╚══════════════════════════════════════════════════════════════════╝"
    Write-Host ""
}

function Process-MainMenuChoice {
    param(
        [string]$choice
    )

    switch ($choice) {
        "1" { Optimize-Display }
        "2" { Show-ManageDefenderMenu }
        "3" { Optimize-Features }
        "4" { Show-OptimizeCPUMenu }
        "5" { Show-OptimizeInternetMenu }
        "6" { Show-WindowsUpdateMenu }
        "7" { Enable-AutoLogin }
        "8" { Clear-Cache }
        "9" { Show-OptimizeDiskMenu }
        "10" { Show-CheckRepairMenu }
        "11" { Show-WindowsActivateMenu }
        "12" { Show-ManagePowerMenu }
        "13" { Enable-DarkMode }
        "14" { Show-ManagePartitionsMenu }
        "15" { Cleanup-System }
        "16" { Manage-Startup }
        "17" { Show-BackupRestoreMenu }
        "18" { Show-SystemInfo }
        "19" { Optimize-Privacy }
        "20" { Show-ManageServicesMenu }
        "21" { Optimize-Network }
        "22" { Exit-Script }
        "23" { Disable-Transparency }
        "24" { Disable-AnimationsExtra }
        "25" { Show-OptimizeStorageSenseMenu }
        "26" { Disable-StartupSound }
        "27" { Show-OptimizePagingFileMenu }
        "28" { Disable-Widgets }
        "29" { Show-OptimizeGameModeMenu }
        "30" { Show-MainMenu }
        "?" { Show-HelpMenu }
        default {
            Write-Host ""
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง. กรุณาลองอีกครั้ง." -ForegroundColor Red
            Write-Host ""
            Read-Host -Prompt "Press Enter to continue..."
        }
    }
}

#endregion

#region Option Functions

#region Option 1: Optimize Display
function Optimize-Display {
    Write-Host ""
    Write-Host "[>] กำลังปรับแต่งการแสดงผล..."
    Modify-Registry -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value "9012078010000000" -ValueType Binary
    Modify-Registry -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0" -ValueType String
    Modify-Registry -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -ValueType String
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "EnableAeroPeek" -Value 0 -ValueType DWord
    Write-Host "[>] การแสดงผลได้รับการปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 2: Manage Windows Defender
function Show-ManageDefenderMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔════════════════════════ Windows Defender Management ══════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] ตรวจสอบสถานะ         [4] อัปเดต Defender         [7] จัดการ Real-time Protection  [10] ดูประวัติภัยคุกคาม ║"
    Write-Host " ║  [2] เปิดใช้งาน             [5] สแกนด่วน                [8] จัดการ Cloud Protection      [11] กลับสู่เมนูหลัก        ║"
    Write-Host " ║  [3] ปิดใช้งาน (**ไม่แนะนำ**) [6] สแกนเต็มรูปแบบ          [9] จัดการ Sample Submission                               ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $def_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-11)"
    Write-Host ""

    switch ($def_choice) {
        "1" { Check-DefenderStatus }
        "2" { Enable-Defender }
        "3" { Disable-Defender }
        "4" { Update-Defender }
        "5" { QuickScan-Defender }
        "6" { FullScan-Defender }
        "7" { Manage-RealtimeProtection }
        "8" { Manage-CloudProtection }
        "9" { Manage-SampleSubmission }
        "10" { View-ThreatHistory }
        "11" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ManageDefenderMenu
        }
    }
}

function Check-DefenderStatus {
    Write-Host "[>] กำลังตรวจสอบสถานะ Defender..."
    Get-Service -Name windefend
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Enable-Defender {
    Write-Host "[>] กำลังเปิดใช้งาน Defender..."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 0 -ValueType DWord -ForceName
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Value 1 -ValueType DWord
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 1 -ValueType DWord
    Write-Host "[>] Defender เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-Defender {
    Write-Host ""
    Write-Host "[!] **คำเตือน:** การปิดใช้งาน Defender จะลดความปลอดภัยของระบบ." -ForegroundColor Yellow
    $confirm_disable = Read-Host -Prompt "  คุณต้องการดำเนินการต่อหรือไม่? (Y/N)"
    if ($confirm_disable -match "^y" -or $confirm_disable -match "^Y") {
        Write-Host "[>] กำลังปิดใช้งาน Defender..."
        Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -ValueType DWord
        Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -ValueType DWord -ForceName
        Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpynetReporting" -Value 0 -ValueType DWord
        Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 2 -ValueType DWord
        Write-Host "[>] Defender ถูกปิดใช้งานแล้ว. **มีความเสี่ยงด้านความปลอดภัย!**" -ForegroundColor Yellow
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[>] การปิดใช้งาน Defender ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}

function Update-Defender {
    Write-Host "[>] กำลังอัปเดต Defender..."
    $updateResult = & "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[>] Defender อัปเดตแล้ว."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** การอัปเดตล้มเหลว. กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function QuickScan-Defender {
    Write-Host "[>] กำลังทำการสแกนด่วน..."
    & "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
    Write-Host "[>] การสแกนด่วนเสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function FullScan-Defender {
    Write-Host "[>] กำลังทำการสแกนเต็มรูปแบบ (อาจใช้เวลานาน)..."
    Start-Process -FilePath "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -ArgumentList "-Scan -ScanType 2" -NoNewWindow
    Write-Host "[>] การสแกนเต็มรูปแบบเริ่มทำงานในพื้นหลังแล้ว. กรุณาตรวจสอบ Windows Security สำหรับความคืบหน้า."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Manage-RealtimeProtection { Toggle-DefenderFeature "Real-Time Protection" "DisableRealtimeMonitoring" }
function Manage-CloudProtection { Toggle-DefenderFeature "Cloud-delivered Protection" "SpynetReporting" }
function Manage-SampleSubmission { Toggle-DefenderFeature "Automatic Sample Submission" "SubmitSamplesConsent" }

function View-ThreatHistory {
    Write-Host "[>] กำลังดูประวัติภัยคุกคาม..."
    & "$env:ProgramFiles\Windows Defender\MpCmdRun.exe" -GetFiles
    Write-Host "[>] ประวัติภัยคุกคามแสดงแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Toggle-DefenderFeature {
    param(
        [string]$FeatureName,
        [string]$RegistryValueName
    )
    Write-Host ""
    Write-Host "[>] สถานะปัจจุบันของ $($FeatureName):"
    if ($RegistryValueName -eq "DisableRealtimeMonitoring") {
        Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name $RegistryValueName -ErrorAction SilentlyContinue
    } elseif ($RegistryValueName -in @("SpynetReporting", "SubmitSamplesConsent")) {
        Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet" -Name $RegistryValueName -ErrorAction SilentlyContinue
    }

    $choice = Read-Host -Prompt "  คุณต้องการเปิดใช้งาน (E) หรือปิดใช้งาน (D) $($FeatureName)? (E/D)"

    if ($choice -match "^e" -or $choice -match "^E") {
        if ($RegistryValueName -eq "DisableRealtimeMonitoring") {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name $RegistryValueName -ErrorAction SilentlyContinue
        } elseif ($RegistryValueName -in @("SpynetReporting", "SubmitSamplesConsent")) {
            Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet" -Name $RegistryValueName -Value 2 -ValueType DWord -ForceName
        }
        Write-Host "[>] $($FeatureName) เปิดใช้งานแล้ว."
    } elseif ($choice -match "^d" -or $choice -match "^D") {
        if ($RegistryValueName -eq "DisableRealtimeMonitoring") {
            Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name $RegistryValueName -Value 1 -ValueType DWord -ForceName
        } elseif ($RegistryValueName -in @("SpynetReporting", "SubmitSamplesConsent")) {
            Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet" -Name $RegistryValueName -Value 0 -ValueType DWord -ForceName
        }
        Write-Host "[>] $($FeatureName) ปิดใช้งานแล้ว."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 3: Optimize System Features
function Optimize-Features {
    Write-Host ""
    Write-Host "[>] กำลังปรับแต่งคุณสมบัติระบบ..."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -ValueType DWord
    Write-Host "[>] - Activity Feed ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -ValueType DWord
    Write-Host "[>] - Background apps ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -ValueType DWord
    Write-Host "[>] - Cortana ปิดใช้งานแล้ว."
    Disable-GameDVRBar
    Write-Host "[>] - Game DVR และ Game Bar ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value "506" -ValueType String
    Write-Host "[>] - Sticky Keys prompt ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Value 1 -ValueType DWord
    Write-Host "[>] - Windows Tips ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -ValueType DWord
    Write-Host "[>] - Start Menu suggestions ปิดใช้งานแล้ว."
    Modify-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 1 -ValueType DWord
    Write-Host "[>] - Fast Startup เปิดใช้งานแล้ว."
    Write-Host "[>] คุณสมบัติระบบได้รับการปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-GameDVRBar {
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ValueType DWord
}
#endregion

#region Option 4: Optimize CPU Performance
function Show-OptimizeCPUMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════ CPU Optimization ══════════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] High Performance Plan       [4] Disable Core Parking    [7] Disable Services (**Advanced**) ║"
    Write-Host " ║  [2] Disable Throttling          [5] Adjust Power Mgmt       [8] Adjust Visual Effects         ║"
    Write-Host " ║  [3] Optimize Scheduling         [6] Enable GPU Scheduling   [9] กลับสู่เมนูหลัก                ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $cpu_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-9)"
    Write-Host ""

    switch ($cpu_choice) {
        "1" { Set-HighPerformancePlan }
        "2" { Disable-CPUThrottling }
        "3" { Optimize-Scheduling }
        "4" { Disable-CoreParking }
        "5" { Adjust-PowerManagement }
        "6" { Enable-GPUScheduling }
        "7" { Show-DisableServicesMenu }
        "8" { Adjust-VisualEffects }
        "9" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeCPUMenu
        }
    }
}

function Set-HighPerformancePlan {
    Write-Host "[>] กำลังตั้งค่าแผน High Performance..."
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการตั้งค่า. กำลังสร้างแผนใหม่..." -ForegroundColor Red
        powercfg /duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        $hp_guid = (powercfg /list | Select-String -Pattern "High performance" | ForEach-Object {$_.Line -split "    " | Where-Object {$_} | Select-Object -Skip 1 -First 1}).Trim()
        if ($hp_guid) {
            powercfg /setactive $hp_guid
        }
    }
    Write-Host "[>] แผน High Performance ถูกตั้งค่าแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-CPUThrottling {
    Write-Host "[>] กำลังปิดใช้งาน CPU throttling..."
    powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
    powercfg /setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
    powercfg /setactive scheme_current
    Write-Host "[>] CPU throttling ถูกปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Optimize-Scheduling {
    Write-Host "[>] กำลังปรับแต่ง processor scheduling..."
    Modify-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -ValueType DWord
    Write-Host "[>] Processor scheduling ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-CoreParking {
    Write-Host "[>] กำลังปิดใช้งาน CPU core parking..."
    powercfg /setacvalueindex scheme_current sub_processor CPMINCORES 100
    powercfg /setactive scheme_current
    Write-Host "[>] CPU core parking ถูกปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Adjust-PowerManagement {
    Write-Host "[>] กำลังปรับแต่ง power management..."
    powercfg /setacvalueindex scheme_current sub_processor PERFBOOSTMODE 2
    powercfg /setacvalueindex scheme_current sub_processor PERFBOOSTPOL 100
    powercfg /setacvalueindex scheme_current sub_processor PERFINCPOL 2
    powercfg /setacvalueindex scheme_current sub_processor PERFDECPOL 1
    powercfg /setactive scheme_current
    Write-Host "[>] Power management ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Enable-GPUScheduling {
    Write-Host "[>] กำลังเปิดใช้งาน GPU scheduling..."
    if ((Get-WmiObject win32_operatingsystem).version -like "10.0.19041*") {
        Modify-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -ValueType DWord
        Write-Host "[>] GPU scheduling เปิดใช้งานแล้ว. จำเป็นต้อง Restart."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** GPU scheduling ไม่รองรับใน Windows version นี้." -ForegroundColor Red
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}

function Show-DisableServicesMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Disable System Services (Advanced) ══════════╗"
    Write-Host " ║                                                          ║"
    Write-Host " ║ **คำเตือน:** การปิดใช้งาน services อาจทำให้ระบบไม่เสถียร. ║" -ForegroundColor Yellow
    Write-Host " ║ โปรดดำเนินการด้วยความระมัดระวัง!                       ║" -ForegroundColor Yellow
    Write-Host " ║                                                          ║"
    Write-Host " ║  [1] Disable SysMain (Superfetch)    [3] Disable WSearch (Windows Search)  [5] กลับสู่เมนู CPU ║"
    Write-Host " ║  [2] Disable DiagTrack (Diagnostics) [4] Disable ALL above (Aggressive)      ║"
    Write-Host " ║                                                          ║"
    Write-Host " ╚══════════════════════════════════════════════╝"
    Write-Host ""
    $svc_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($svc_choice) {
        "1" { Disable-Service "SysMain" "Superfetch" }
        "2" { Disable-Service "DiagTrack" "Diagnostic Tracking" }
        "3" { Disable-Service "WSearch" "Windows Search" }
        "4" { Disable-MultipleServices }
        "5" { Show-OptimizeCPUMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-DisableServicesMenu
        }
    }
}

function Disable-Service {
    param(
        [string]$ServiceName,
        [string]$ServiceDisplayName
    )
    Write-Host "[>] กำลังปิดใช้งาน $($ServiceDisplayName) ($($ServiceName))..."
    Set-Service -Name $ServiceName -StartupType Disabled
    Stop-Service -Name $ServiceName -ErrorAction SilentlyContinue
    Write-Host "[>] $($ServiceDisplayName) ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-MultipleServices {
    Write-Host "[>] กำลังปิดใช้งาน SysMain, DiagTrack, WSearch..."
    Disable-Service "SysMain" "Superfetch"
    Disable-Service "DiagTrack" "Diagnostic Tracking"
    Disable-Service "WSearch" "Windows Search"
    Write-Host "[>] Services หลายรายการถูกปิดใช้งานแล้ว. **กรุณาตรวจสอบระบบหลัง Restart!**" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
    Show-DisableServicesMenu
}

function Adjust-VisualEffects {
    Write-Host "[>] กำลังปรับแต่ง visual effects เพื่อประสิทธิภาพ..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ValueType DWord
    Write-Host "[>] Visual effects ถูกปรับแต่งเพื่อประสิทธิภาพแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 5: Optimize Internet Performance
function Show-OptimizeInternetMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════ Internet Optimization ══════════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] Basic Optimizations          [4] Network Adapter Tuning (**Advanced**)      ║"
    Write-Host " ║  [2] Advanced TCP Optimizations     [5] Clear Network Cache                     ║"
    Write-Host " ║  [3] DNS Optimization             [6] กลับสู่เมนูหลัก                            ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $net_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-6)"
    Write-Host ""

    switch ($net_choice) {
        "1" { Basic-InternetOptimizations }
        "2" { Advanced-TCPOptimizations }
        "3" { DNS-Optimization }
        "4" { Adapter-Tuning }
        "5" { Clear-NetworkCache }
        "6" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeInternetMenu
        }
    }
}

function Basic-InternetOptimizations {
    Write-Host "[>] กำลังดำเนินการ basic optimizations..."
    netsh int tcp set global autotuninglevel=normal
    netsh int tcp set global chimney=enabled
    netsh int tcp set global dca=enabled
    netsh int tcp set global netdma=enabled
    netsh int tcp set global ecncapability=enabled
    netsh int tcp set global timestamps=disabled
    netsh int tcp set global rss=enabled
    Write-Host "[>] Basic optimizations เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Advanced-TCPOptimizations {
    Write-Host "[>] กำลังดำเนินการ advanced TCP optimizations (**ผู้ใช้ขั้นสูง**)..." -ForegroundColor Yellow
    netsh int tcp set global congestionprovider=ctcp
    netsh int tcp set global ecncapability=enabled
    netsh int tcp set heuristics disabled
    netsh int tcp set global rss=enabled
    netsh int tcp set global fastopen=enabled
    netsh int tcp set global hystart=disabled
    netsh int tcp set global pacingprofile=off
    Modify-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPNoDelay" -Value 1 -ValueType DWord
    Modify-Registry -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TCPDelAckTicks" -Value 0 -ValueType DWord
    Write-Host "[>] Advanced TCP optimizations เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function DNS-Optimization {
    Write-Host "[>] กำลังปรับแต่ง DNS settings..."
    ipconfig /flushdns
    $interface_name = (netsh interface show interface | Select-String -Pattern "Connected" | ForEach-Object {$_.Line -split "    " | Where-Object {$_} | Select-Object -Skip 1 -First 1}).Trim()
    if ($interface_name) {
        netsh int ip set dns name="$interface_name" source=static address=8.8.8.8 register=primary
        netsh int ip add dns name="$interface_name" address=8.8.4.4 index=2
        Write-Host "[>] DNS optimized (8.8.8.8, 8.8.4.4)."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. DNS ล้มเหลว." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Adapter-Tuning {
    Write-Host "[>] กำลังปรับแต่ง network adapter (**ขั้นสูง - อาจต้องปรับแต่งเพิ่มเติม**)..." -ForegroundColor Yellow
    $interface_name = (netsh interface show interface | Select-String -Pattern "Connected" | ForEach-Object {$_.Line -split "    " | Where-Object {$_} | Select-Object -Skip 1 -First 1}).Trim()
    if ($interface_name) {
        netsh int ip set interface name="$interface_name" dadtransmits=0 store=persistent
        netsh int ip set interface name="$interface_name" routerdiscovery=disabled store=persistent
        try {
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0
        } catch {
            Write-Warning "Warning: Could not set advanced adapter properties. Please check manually."
        }
        Write-Host "[>] Adapter tuned. **อาจต้องปรับแต่งเพิ่มเติมใน Device Manager.**" -ForegroundColor Yellow
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Adapter tuning ล้มเหลว." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Clear-NetworkCache {
    Write-Host "[>] กำลังล้าง network cache..."
    ipconfig /flushdns
    arp -d *
    nbtstat -R
    nbtstat -RR
    netsh int ip reset
    netsh winsock reset
    Write-Host "[>] Network cache ถูกล้างแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 6: Manage Windows Update
function Show-WindowsUpdateMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════ Windows Update Management ══════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] Enable Updates                  [3] Check for Updates                    ║"
    Write-Host " ║  [2] Disable Updates (**Not Recommended**) [4] กลับสู่เมนูหลัก                ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $update_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-4)"
    Write-Host ""

    switch ($update_choice) {
        "1" { Enable-WindowsUpdate }
        "2" { Disable-WindowsUpdate }
        "3" { Check-WindowsUpdates }
        "4" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-WindowsUpdateMenu
        }
    }
}

function Enable-WindowsUpdate {
    Write-Host "[>] กำลังเปิดใช้งาน Windows Update..."
    Set-Service -Name wuauserv -StartupType Automatic
    Start-Service -Name wuauserv
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[>] Updates เปิดใช้งานแล้ว."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** การเปิดใช้งานล้มเหลว. กรุณาตรวจสอบสิทธิ์." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-WindowsUpdate {
    Write-Host ""
    Write-Host "[!] **คำเตือน:** การปิดใช้งาน updates เป็นความเสี่ยงด้านความปลอดภัย." -ForegroundColor Yellow
    $confirm_disable_update = Read-Host -Prompt "  คุณต้องการดำเนินการต่อหรือไม่? (Y/N)"
    if ($confirm_disable_update -match "^y" -or $confirm_disable_update -match "^Y") {
        Write-Host "[>] กำลังปิดใช้งาน Windows Update..."
        Set-Service -Name wuauserv -StartupType Disabled
        Stop-Service -Name wuauserv
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[>] Updates ถูกปิดใช้งานแล้ว. **ความเสี่ยงด้านความปลอดภัย!**" -ForegroundColor Yellow
        } else {
            Write-Host "[!] **ข้อผิดพลาด:** การปิดใช้งานล้มเหลว. กรุณาตรวจสอบสิทธิ์." -ForegroundColor Red
        }
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[>] การปิดใช้งาน Updates ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}

function Check-WindowsUpdates {
    Write-Host "[>] กำลังตรวจสอบ updates..."
    (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
    Write-Host "[>] การตรวจสอบ Update เริ่มต้นแล้ว. กรุณาดูที่ Settings > Windows Update."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 7: Enable Auto-login
function Enable-AutoLogin {
    Write-Host ""
    Write-Host "[>] กำลังตั้งค่า Auto-login (**เสี่ยงด้านความปลอดภัย!**)..." -ForegroundColor Yellow
    Write-Host "[!] **คำเตือนด้านความปลอดภัย:** Auto-login ข้ามหน้าจอ login, ลดความปลอดภัย." -ForegroundColor Yellow
    Write-Host "[!] กรุณาใช้บนเครื่องส่วนตัวที่ปลอดภัยเท่านั้น." -ForegroundColorYellow
    $username = Read-Host -Prompt "  กรุณาป้อน username"
    $password = Read-Host -Prompt "  กรุณาป้อน password"
    Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value $username -ValueType String
    Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value $password -ValueType String
    Modify-Registry -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1" -ValueType String
    Write-Host "[>] Auto-login ถูกตั้งค่าแล้ว. **ความเสี่ยงด้านความปลอดภัย!**" -ForegroundColorYellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 8: Clear System Cache
function Clear-Cache {
    Write-Host "[>] กำลังล้าง system cache..."
    Remove-Item -Path "$env:TEMP\*" -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "[>] System cache ถูกล้างแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 9: Optimize Disk
function Show-OptimizeDiskMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════ Disk Optimization ══════════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] Analyze Disk              [3] Check Disk Errors         [5] Clean Up System Files        ║"
    Write-Host " ║  [2] Optimize/Defrag           [4] Trim SSD                  [6] กลับสู่เมนูหลัก                ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $disk_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-6)"
    Write-Host ""

    switch ($disk_choice) {
        "1" { Analyze-Disk }
        "2" { Optimize-Defrag }
        "3" { Check-DiskErrors }
        "4" { Trim-SSD }
        "5" { Cleanup-System }
        "6" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeDiskMenu
        }
    }
}

function Analyze-Disk {
    Write-Host "[>] กำลังวิเคราะห์ disk..."
    defrag C: /A
    Write-Host "[>] Disk analysis เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Optimize-Defrag {
    Write-Host "[>] กำลัง Optimize/Defragment disk..."
    defrag C: /O
    Write-Host "[>] Disk optimization เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Check-DiskErrors {
    Write-Host "[>] กำลังกำหนดเวลา disk check สำหรับการ restart ครั้งถัดไป..."
    Write-Host "[!] **Disk check จะทำงานในการ restart ระบบครั้งถัดไป.**" -ForegroundColor Yellow
    chkdsk C: /F /R /X
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Trim-SSD {
    Write-Host "[>] กำลังเปิดใช้งาน SSD TRIM..."
    fsutil behavior set disabledeletenotify 0
    Write-Host "[>] SSD TRIM เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Cleanup-System {
    Write-Host "[>] กำลังล้างไฟล์ขยะใน system files..."
    if (!(Test-Path -Path "$env:USERPROFILE\AppData\Local\Microsoft\CleanMgr\StateMgr\CustomState_1.ini")) {
        Write-Host "[>] Disk Cleanup settings ไม่พบ. กำลังตั้งค่าเริ่มต้น..."
        cleanmgr /sageset:1
        Write-Host "[!] กรุณาเลือก items ที่ต้องการล้างและคลิก OK." -ForegroundColor Yellow
        Read-Host -Prompt "Press Enter to continue after setting Disk Cleanup..."
    }
    Write-Host "[>] กำลัง Run Disk Cleanup..."
    cleanmgr /sagerun:1
    Write-Host "[>] System file cleanup เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 10: Check and Repair System Files
function Show-CheckRepairMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════ Check & Repair System Files ══════════════╗"
    Write-Host " ║                                                            ║"
    Write-Host " ║  [1] Run SFC                 [3] Check Disk Health          [5] กลับสู่เมนูหลัก ║"
    Write-Host " ║  [2] Run DISM                [4] Verify System Files                         ║"
    Write-Host " ║                                                            ║"
    Write-Host " ╚══════════════════════════════════════════════════╝"
    Write-Host ""
    $repair_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($repair_choice) {
        "1" { Run-SFC }
        "2" { Run-DISM }
        "3" { Check-DiskHealth }
        "4" { Verify-SFCFiles }
        "5" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-CheckRepairMenu
        }
    }
}

function Run-SFC {
    Write-Host "[>] กำลัง Run System File Checker..."
    sfc /scannow
    Write-Host "[>] SFC scan เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Run-DISM {
    Write-Host "[>] กำลัง Run DISM..."
    DISM /Online /Cleanup-Image /RestoreHealth
    Write-Host "[>] DISM repair เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Check-DiskHealth {
    Write-Host "[>] กำลังตรวจสอบ disk health..."
    wmic diskdrive get status
    Write-Host "[>] Disk health check เสร็จสมบูรณ์."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Verify-SFCFiles {
    Write-Host "[>] กำลัง Verify system files (sfcdetails.txt บน Desktop)..."
    Get-Content "$env:windir\Logs\CBS\CBS.log" | Select-String -Pattern "[SR]" | Out-File -FilePath "$env:USERPROFILE\Desktop\sfcdetails.txt"
    Write-Host "[>] Verification เสร็จสมบูรณ์. ผลลัพธ์อยู่ใน sfcdetails.txt บน Desktop."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 11: Windows Activation (KMS - RISKY!)
function Show-WindowsActivateMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Windows Activation (KMS - **RISKY!**) ══════════╗"
    Write-Host " ║                                                                 ║"
    Write-Host " ║ **คำเตือนความเสี่ยงสูงด้านความปลอดภัยและกฎหมาย:** KMS Activators  ║" -ForegroundColor Yellow
    Write-Host " ║ เป็นแหล่งที่ไม่น่าเชื่อถือ. การใช้งาน **ไม่แนะนำอย่างยิ่ง**          ║" -ForegroundColor Yellow
    Write-Host " ║ เนื่องจากภัยคุกคามด้านความปลอดภัยและการละเมิดลิขสิทธิ์ซอฟต์แวร์.   ║" -ForegroundColor Yellow
    Write-Host " ║                                                                 ║"
    Write-Host " ║ **โปรดดำเนินการด้วยความเสี่ยงของคุณเอง!** โดยการดำเนินการต่อ,      ║" -ForegroundColor Yellow
    Write-Host " ║ คุณรับทราบและยอมรับความเสี่ยงที่อาจเกิดขึ้นทั้งหมด.              ║" -ForegroundColor Yellow
    Write-Host " ║                                                                 ║"
    Write-Host " ║  [1] Check Activation Status         [4] Input Product Key         [6] กลับสู่เมนูหลัก ║"
    Write-Host " ║  [2] Activate using KMS (**HIGH RISK!**) [5] Remove Product Key                    ║"
    Write-Host " ║  [3] Activate Digital License                                    ║"
    Write-Host " ║                                                                 ║"
    Write-Host " ╚══════════════════════════════════════════════════╝"
    Write-Host ""
    $activate_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-6)"
    Write-Host ""

    switch ($activate_choice) {
        "1" { Check-ActivationStatus }
        "2" { KMS-ActivateWarn }
        "3" { Digital-Activate }
        "4" { Manual-ProductKey }
        "5" { Remove-ProductKey }
        "6" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-WindowsActivateMenu
        }
    }
}

function Check-ActivationStatus {
    Write-Host "[>] กำลังตรวจสอบ activation status..."
    slmgr /xpr
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function KMS-ActivateWarn {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ KMS Activation - **CONFIRM RISK!** ══════════╗" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ║ **คุณกำลังจะใช้ KMS ACTIVATION - มีความเสี่ยงสูง!**         ║" -ForegroundColor Yellow
    Write-Host " ║ **โปรดยืนยันว่าคุณเข้าใจและยอมรับความเสี่ยงด้านความปลอดภัย   ║" -ForegroundColor Yellow
    Write-Host " ║ และกฎหมาย (Y/N):**                                     ║" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ╚══════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    $confirm_kms_risk = Read-Host -Prompt "  ยืนยันการดำเนินการต่อ (Y/N)"
    if ($confirm_kms_risk -match "^y" -or $confirm_kms_risk -match "^Y") {
        KMS-Activate
    } else {
        Write-Host "[>] KMS Activation ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
        Show-WindowsActivateMenu
    }
}

function KMS-Activate {
    Write-Host "[>] กำลังพยายาม KMS activation (**HIGH RISK!**)..." -ForegroundColor Yellow
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "[!] **ข้อผิดพลาด:** จำเป็นต้องมีสิทธิ์ผู้ดูแลระบบ." -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit..."
        exit
    }
    try {
        Invoke-WebRequest -Uri "https://get.activated.win" -UseBasicParsing | Invoke-Expression
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** KMS activation อาจล้มเหลว. กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตและสิทธิ์." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Digital-Activate {
    Write-Host "[>] กำลังพยายาม digital license activation..."
    slmgr /ato
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** Digital license activation ล้มเหลว." -ForegroundColor Red
    } else {
        Write-Host "[>] Digital license activation ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Manual-ProductKey {
    $product_key = Read-Host -Prompt "  กรุณาป้อน product key 25 ตัวอักษร (XXXXX-XXXXX-XXXXX-XXXXX-XXXXX)"
    Write-Host "[>] กำลังติดตั้ง product key..."
    slmgr /ipk $product_key
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** Key install ล้มเหลว. Product key ไม่ถูกต้อง?" -ForegroundColor Red
    } else {
        Write-Host "[>] Key ติดตั้งแล้ว. กำลังพยายาม activation..."
        slmgr /ato
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] **ข้อผิดพลาด:** Activation ล้มเหลว. กรุณาตรวจสอบ key." -ForegroundColor Red
        } else {
            Write-Host "[>] Activation ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ."
        }
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Remove-ProductKey {
    Write-Host "[>] กำลังลบ product key..."
    slmgr /upk
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** Key removal ล้มเหลว. สิทธิ์?" -ForegroundColor Red
    } else {
        Write-Host "[>] Product key ถูกลบแล้ว."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 12: Manage Power Settings
function Show-ManagePowerMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════ Power Settings Management ══════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] List Power Plans             [4] Delete Power Plan (**Caution!**)       [7] Adjust Display/Sleep Timeouts ║"
    Write-Host " ║  [2] Set Power Plan              [5] Adjust Sleep Settings                 [8] Configure Lid Close Action     ║"
    Write-Host " ║  [3] Create Power Plan             [6] Configure Hibernation                 [9] Configure Power Button Action║"
    Write-Host " ║                                                            [10] กลับสู่เมนูหลัก                ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $power_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-10)"
    Write-Host ""

    switch ($power_choice) {
        "1" { List-PowerPlans }
        "2" { Show-SetPowerPlanMenu }
        "3" { Show-CreatePowerPlanMenu }
        "4" { Show-DeletePowerPlanMenu }
        "5" { Adjust-SleepSettings }
        "6" { Show-ConfigureHibernationMenu }
        "7" { Show-AdjustTimeoutsMenu }
        "8" { Show-LidCloseActionMenu }
        "9" { Show-PowerButtonActionMenu }
        "10" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ManagePowerMenu
        }
    }
}

function List-PowerPlans {
    Write-Host "[>] กำลัง List power plans..."
    powercfg /list
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-SetPowerPlanMenu {
    Write-Host "[>] Available power plans:"
    powercfg /list
    $plan_guid = Read-Host -Prompt "  กรุณาป้อน plan GUID ที่ต้องการตั้งค่า"
    Set-PowerPlan -PlanGuid $plan_guid
}

function Set-PowerPlan {
    param(
        [string]$PlanGuid
    )
    powercfg /setactive $PlanGuid
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการตั้งค่า plan. กรุณาตรวจสอบ GUID." -ForegroundColor Red
    } else {
        Write-Host "[>] Power plan ถูกตั้งค่าแล้ว."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-CreatePowerPlanMenu {
    $plan_name = Read-Host -Prompt "  กรุณาป้อนชื่อ power plan ใหม่"
    Create-PowerPlan -PlanName $plan_name
}

function Create-PowerPlan {
    param(
        [string]$PlanName
    )
    powercfg /duplicatescheme scheme_balanced
    if ($LASTEXITCODE -eq 0) {
        powercfg /changename $PlanName
        Write-Host "[>] Power plan ถูกสร้างแล้ว."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** Plan creation ล้มเหลว." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-DeletePowerPlanMenu {
    Write-Host "[>] Available power plans:"
    powercfg /list
    $del_guid = Read-Host -Prompt "  กรุณาป้อน plan GUID ที่ต้องการลบ (**Caution!**)"
    Delete-PowerPlan -PlanGuid $del_guid
}

function Delete-PowerPlan {
    param(
        [string]$PlanGuid
    )
    Write-Host ""
    Write-Host "[!] **คำเตือน:** การลบ power plan อาจลบ active plan." -ForegroundColor Yellow
    $confirm_delete_plan = Read-Host -Prompt "  คุณต้องการดำเนินการต่อหรือไม่? (Y/N)"
    if ($confirm_delete_plan -match "^y" -or $confirm_delete_plan -match "^Y") {
        powercfg /delete $PlanGuid
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[>] Power plan ถูกลบแล้ว."
        } else {
            Write-Host "[!] **ข้อผิดพลาด:** Plan deletion ล้มเหลว. กรุณาตรวจสอบ GUID." -ForegroundColor Red
        }
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[>] Plan deletion ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}

function Adjust-SleepSettings {
    $sleep_time = Read-Host -Prompt "  Minutes before sleep (0=never)"
    powercfg /change standby-timeout-ac $sleep_time
    powercfg /change standby-timeout-dc $sleep_time
    Write-Host "[>] Sleep settings ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-ConfigureHibernationMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════ Configure Hibernation ══════════════╗"
    Write-Host " ║                                                      ║"
    Write-Host " ║  [1] Enable Hibernation      [2] Disable Hibernation  [3] กลับสู่เมนู Power ║"
    Write-Host " ║                                                      ║"
    Write-Host " ╚══════════════════════════════════════════════╝"
    Write-Host ""
    $hib_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-3)"
    Write-Host ""

    switch ($hib_choice) {
        "1" { Enable-Hibernation }
        "2" { Disable-Hibernation }
        "3" { Show-ManagePowerMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ConfigureHibernationMenu
        }
    }
}

function Enable-Hibernation {
    powercfg /hibernate on
    Write-Host "[>] Hibernation เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-Hibernation {
    powercfg /hibernate off
    Write-Host "[>] Hibernation ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-AdjustTimeoutsMenu {
    $display_ac = Read-Host -Prompt "  Minutes to turn off display (AC)"
    $display_dc = Read-Host -Prompt "  Minutes to turn off display (Battery)"
    $sleep_ac = Read-Host -Prompt "  Minutes before sleep (AC)"
    $sleep_dc = Read-Host -Prompt "  Minutes before sleep (Battery)"
    Adjust-Timeouts -DisplayAc $display_ac -DisplayDc $display_dc -SleepAc $sleep_ac -SleepDc $sleep_dc
}

function Adjust-Timeouts {
    param(
        [string]$DisplayAc,
        [string]$DisplayDc,
        [string]$SleepAc,
        [string]$SleepDc
    )
    powercfg /change monitor-timeout-ac $DisplayAc
    powercfg /change monitor-timeout-dc $DisplayDc
    powercfg /change standby-timeout-ac $SleepAc
    powercfg /change standby-timeout-dc $SleepDc
    Write-Host "[>] Display/sleep timeouts ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-LidCloseActionMenu { Show-PowerActionMenu -ActionType "lid" -ActionDisplayName "Lid Close" }
function Show-PowerButtonActionMenu { Show-PowerActionMenu -ActionType "pbutton" -ActionDisplayName "Power Button" }

function Show-PowerActionMenu {
    param(
        [string]$ActionType,
        [string]$ActionDisplayName
    )
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Configure $($ActionDisplayName) Action ══════════╗"
    Write-Host " ║                                              ║"
    Write-Host " ║  [1] Do Nothing  [2] Sleep  [3] Hibernate  [4] Shut Down  [5] กลับสู่เมนู Power ║"
    Write-Host " ║                                              ║"
    Write-Host " ╚══════════════════════════════════════════╝"
    Write-Host ""
    $action_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($action_choice) {
        "1" { Set-PowerAction -ActionType $ActionType -ActionValue 0 }
        "2" { Set-PowerAction -ActionType $ActionType -ActionValue 1 }
        "3" { Set-PowerAction -ActionType $ActionType -ActionValue 2 }
        "4" { Set-PowerAction -ActionType $ActionType -ActionValue 3 }
        "5" { Show-ManagePowerMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-PowerActionMenu -ActionType $ActionType -ActionDisplayName $ActionDisplayName
        }
    }
}

function Set-PowerAction {
    param(
        [string]$ActionType,
        [string]$ActionValue
    )
    powercfg /setacvalueindex scheme_current sub_buttons $($ActionType)action $ActionValue
    powercfg /setdcvalueindex scheme_current sub_buttons $($ActionType)action $ActionValue
    powercfg /setactive scheme_current
    Write-Host "[>] $($ActionDisplayName) action ถูกตั้งค่าแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 13: Enable Dark Mode
function Enable-DarkMode {
    Write-Host "[>] กำลังเปิดใช้งาน Dark Mode..."
    Modify-Registry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ValueType DWord
    Write-Host "[>] Dark Mode เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 14: Manage Partitions (DATA LOSS RISK!)
function Show-ManagePartitionsMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════ Partition Management (**DATA LOSS RISK!**) ══════╗" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ║ **คำเตือน:** การจัดการ partition อาจทำให้ **ข้อมูลสูญหายถาวร**.   ║" -ForegroundColor Yellow
    Write-Host " ║ กรุณาสำรองข้อมูลสำคัญทั้งหมด!                             ║" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ║  [1] List Partitions        [3] Delete Partition (**DATA LOSS!**)  [5] กลับสู่เมนูหลัก ║" -ForegroundColor Yellow
    Write-Host " ║  [2] Create Partition (**DATA LOSS RISK!**) [4] Format Partition (**DATA LOSS!**)    ║" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ╚══════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    $part_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($part_choice) {
        "1" { List-Partitions }
        "2" { Show-CreatePartitionMenu }
        "3" { Show-DeletePartitionMenu }
        "4" { Show-FormatPartitionMenu }
        "5" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ManagePartitionsMenu
        }
    }
}

function List-Partitions {
    Write-Host "[>] กำลัง List Partitions..."
    @"
list disk
list volume
"@ | diskpart
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-CreatePartitionMenu {
    Write-Host "[!] **Data Loss Risk! กรุณาสำรองข้อมูล!**" -ForegroundColor Yellow
    $disk_num = Read-Host -Prompt "  กรุณาป้อน disk number"
    $part_size = Read-Host -Prompt "  กรุณาป้อน partition size (MB)"
    Create-Partition -DiskNumber $disk_num -PartitionSize $part_size
}

function Create-Partition {
    param(
        [string]$DiskNumber,
        [string]$PartitionSize
    )
    Write-Host "[>] กำลังสร้าง Partition (**Data Loss Risk!**)..." -ForegroundColor Yellow
    @"
select disk $($DiskNumber)
create partition primary size=$($PartitionSize)
"@ | diskpart
    Write-Host "[>] Partition ถูกสร้างแล้ว. **กรุณาตรวจสอบ Disk Management.**" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-DeletePartitionMenu {
    Write-Host "[!] **Permanent Data Loss Warning! กรุณาสำรองข้อมูล!**" -ForegroundColor Yellow
    $disk_num = Read-Host -Prompt "  กรุณาป้อน disk number"
    $part_num = Read-Host -Prompt "  กรุณาป้อน partition number"
    Delete-Partition -DiskNumber $disk_num -PartitionNumber $part_num
}

function Delete-Partition {
    param(
        [string]$DiskNumber,
        [string]$PartitionNumber
    )
    Write-Host "[>] กำลังลบ Partition (**Permanent Data Loss!**)..." -ForegroundColor Yellow
    Write-Host "[!] **คำเตือน: ข้อมูลจะสูญหายอย่างถาวร! คุณต้องการดำเนินการต่อหรือไม่? (Y/N)**" -ForegroundColor Red
    $confirm_delete_part = Read-Host -Prompt "  ยืนยันการลบ partition (Y/N)"
    if ($confirm_delete_part -match "^y" -or $confirm_delete_part -match "^Y") {
        @"
select disk $($DiskNumber)
select partition $($PartitionNumber)
delete partition override
"@ | diskpart
        Write-Host "[>] Partition ถูกลบแล้ว. **ข้อมูลสูญหายอย่างถาวร! กรุณาตรวจสอบ Disk Management.**" -ForegroundColor Yellow
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[>] Partition deletion ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}

function Show-FormatPartitionMenu {
    Write-Host "[!] **Data Loss Warning! กรุณาสำรองข้อมูล!**" -ForegroundColor Yellow
    $disk_num = Read-Host -Prompt "  กรุณาป้อน disk number"
    $part_num = Read-Host -Prompt "  กรุณาป้อน partition number"
    $fs = Read-Host -Prompt "  กรุณาป้อน file system (NTFS/FAT32)"
    Format-Partition -DiskNumber $disk_num -PartitionNumber $part_num -FileSystem $fs
}

function Format-Partition {
    param(
        [string]$DiskNumber,
        [string]$PartitionNumber,
        [string]$FileSystem
    )
    Write-Host "[>] กำลัง Format Partition (**Data Loss!**)..." -ForegroundColor Yellow
    Write-Host "[!] **คำเตือน: ข้อมูลจะสูญหาย! คุณต้องการดำเนินการต่อหรือไม่? (Y/N)**" -ForegroundColor Red
    $confirm_format_part = Read-Host -Prompt "  ยืนยันการ format partition (Y/N)"
    if ($confirm_format_part -match "^y" -or $confirm_format_part -match "^Y") {
        @"
select disk $($DiskNumber)
select partition $($PartitionNumber)
format fs=$($FileSystem) quick
"@ | diskpart
        Write-Host "[>] Partition ถูก format แล้ว. **ข้อมูลสูญหาย! กรุณาตรวจสอบ Disk Management.**" -ForegroundColor Yellow
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    } else {
        Write-Host "[>] Partition formatting ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
    }
}
#endregion

#region Option 16: Manage Startup Programs
function Manage-Startup {
    Write-Host "[>] กำลังจัดการ startup programs..."
    Start-Process msconfig -Verb RunAs
    Write-Host "[>] กรุณาใช้ System Configuration utility เพื่อจัดการ startup programs."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 17: Backup and Restore Settings
function Show-BackupRestoreMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Backup & Restore Settings ══════════╗"
    Write-Host " ║                                              ║"
    Write-Host " ║  [1] Create Restore Point    [2] Restore from Restore Point  [3] กลับสู่เมนูหลัก ║"
    Write-Host " ║                                              ║"
    Write-Host " ╚══════════════════════════════════════════╝"
    Write-Host ""
    $backup_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-3)"
    Write-Host ""

    switch ($backup_choice) {
        "1" { Create-RestorePoint }
        "2" { Restore-FromPoint }
        "3" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-BackupRestoreMenu
        }
    }
}

function Create-RestorePoint {
    Write-Host "[>] กำลังสร้าง system restore point..."
    try {
        $wmi = Get-WmiObject -Class SystemRestore -Namespace root\default
        $result = Invoke-WmiMethod -InputObject $wmi -Name CreateRestorePoint -ArgumentList "Manual Restore Point", 100, 7
        if ($result.ReturnValue -eq 0) {
            Write-Host "[>] System restore point ถูกสร้างแล้ว."
        } else {
            Write-Host "[!] **ข้อผิดพลาด:** การสร้าง restore point ล้มเหลว. Error Code: $($result.ReturnValue)" -ForegroundColor Red
        }
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่สามารถสร้าง system restore point. กรุณาตรวจสอบ System Restore service." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Restore-FromPoint {
    Write-Host "[>] กำลัง Restore from restore point..."
    rstrui.exe
    Write-Host "[>] กรุณาทำตามคำแนะนำบนหน้าจอเพื่อ restore system."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 18: System Information
function Show-SystemInfo {
    Write-Host "[>] กำลังแสดง system information..."
    systeminfo
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 19: Optimize Privacy Settings
function Optimize-Privacy {
    Write-Host "[>] กำลังปรับแต่ง privacy settings..."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -ValueType DWord
    Write-Host "[>] - Telemetry ถูกปิดใช้งานแล้ว."
    Modify-Registry -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Value 1 -ValueType DWord
    Write-Host "[>] - Advertising ID ถูกปิดใช้งานแล้ว."
    Modify-Registry -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -ValueType DWord
    Write-Host "[>] - เพิ่มเติม Telemetry ถูกปิดใช้งานแล้ว."
    Write-Host "[>] Privacy settings ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 20: Manage Windows Services
function Show-ManageServicesMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Windows Services Management ══════════╗"
    Write-Host " ║                                                ║"
    Write-Host " ║  [1] List All Services         [4] Start Service         [7] Change Startup Type  [10] กลับสู่เมนูหลัก ║"
    Write-Host " ║  [2] List Running Services     [5] Stop Service          [8] Search for Service                 ║"
    Write-Host " ║  [3] List Stopped Services     [6] Restart Service       [9] View Service Details               ║"
    Write-Host " ║                                                ║"
    Write-Host " ╚══════════════════════════════════════════════╝"
    Write-Host ""
    $service_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-10)"
    Write-Host ""

    switch ($service_choice) {
        "1" { List-AllServices }
        "2" { List-RunningServices }
        "3" { List-StoppedServices }
        "4" { Show-StartServiceMenu }
        "5" { Show-StopServiceMenu }
        "6" { Show-RestartServiceMenu }
        "7" { Show-ChangeStartupTypeMenu }
        "8" { Show-SearchServiceMenu }
        "9" { Show-ViewServiceDetailsMenu }
        "10" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ManageServicesMenu
        }
    }
}

function List-AllServices {
    Write-Host "[>] กำลัง List all services..."
    Get-Service -ErrorAction SilentlyContinue | Format-Table Name, Status
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function List-RunningServices {
    Write-Host "[>] กำลัง List running services..."
    Get-Service -Status Running -ErrorAction SilentlyContinue | Format-Table Name, Status
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function List-StoppedServices {
    Write-Host "[>] กำลัง List stopped services..."
    Get-Service -Status Stopped -ErrorAction SilentlyContinue | Format-Table Name, Status
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-StartServiceMenu {
    $service_name = Read-Host -Prompt "  กรุณาป้อน service name ที่ต้องการ start"
    Start-ServiceCmd -ServiceName $service_name
}

function Start-ServiceCmd {
    param(
        [string]$ServiceName
    )
    Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการ start service. กรุณาตรวจสอบ name/permissions." -ForegroundColor Red
    } else {
        Write-Host "[>] Service start ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-StopServiceMenu {
    $service_name = Read-Host -Prompt "  กรุณาป้อน service name ที่ต้องการ stop"
    Stop-ServiceCmd -ServiceName $service_name
}

function Stop-ServiceCmd {
    param(
        [string]$ServiceName
    )
    Stop-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการ stop service. กรุณาตรวจสอบ name/permissions." -ForegroundColor Red
    } else {
        Write-Host "[>] Service stop ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-RestartServiceMenu {
    $service_name = Read-Host -Prompt "  กรุณาป้อน service name ที่ต้องการ restart"
    Restart-ServiceCmd -ServiceName $service_name
}

function Restart-ServiceCmd {
    param(
        [string]$ServiceName
    )
    Restart-Service -Name $ServiceName -ErrorAction SilentlyContinue
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการ restart service. กรุณาตรวจสอบ name/permissions." -ForegroundColor Red
    } else {
        Write-Host "[>] Service restart ถูกพยายามแล้ว. กรุณาตรวจสอบสถานะ."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-ChangeStartupTypeMenu {
    $service_name = Read-Host -Prompt "  กรุณาป้อน service name"
    Show-ChangeStartupTypeSubMenu -ServiceName $service_name
}

function Show-ChangeStartupTypeSubMenu {
    param(
        [string]$ServiceName
    )
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════ Change Service Startup Type ══════╗"
    Write-Host " ║                                        ║"
    Write-Host " ║  [1] Automatic        [3] Manual        ║"
    Write-Host " ║  [2] Automatic (Delayed) [4] Disabled     ║"
    Write-Host " ║                                        ║"
    Write-Host " ╚══════════════════════════════════════╝"
    Write-Host ""
    $startup_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-4)"
    Write-Host ""

    switch ($startup_choice) {
        "1" { Change-ServiceStartup -ServiceName $ServiceName -StartupType "Automatic" }
        "2" { Change-ServiceStartup -ServiceName $ServiceName -StartupType "AutomaticDelayedStart" }
        "3" { Change-ServiceStartup -ServiceName $ServiceName -StartupType "Manual" }
        "4" { Change-ServiceStartup -ServiceName $ServiceName -StartupType "Disabled" }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ChangeStartupTypeSubMenu -ServiceName $ServiceName
        }
    }
}

function Change-ServiceStartup {
    param(
        [string]$ServiceName,
        [string]$StartupType
    )
    Set-Service -Name $ServiceName -StartupType $StartupType
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[!] **ข้อผิดพลาด:** ล้มเหลวในการ change startup type. กรุณาตรวจสอบ name/permissions." -ForegroundColor Red
    } else {
        Write-Host "[>] Startup type ถูกเปลี่ยนเรียบร้อยแล้ว."
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-SearchServiceMenu {
    $search_term = Read-Host -Prompt "  กรุณาป้อน service name search term"
    Search-Service -SearchTerm $search_term
}

function Search-Service {
    param(
        [string]$SearchTerm
    )
    Get-Service -Name "*$SearchTerm*" -ErrorAction SilentlyContinue | Format-Table Name, Status
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-ViewServiceDetailsMenu {
    $service_name = Read-Host -Prompt "  กรุณาป้อน service name สำหรับรายละเอียด"
    View-ServiceDetails -ServiceName $service_name
}

function View-ServiceDetails {
    param(
        [string]$ServiceName
    )
    Get-Service -Name $ServiceName | Format-List *
    Write-Host ""
    Write-Host "[>] สถานะปัจจุบัน:"
    Get-Service -Name $ServiceName | Format-Table Name, Status
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 21: Network Optimization
function Show-OptimizeNetworkMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════ Network Optimization ══════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  [1] Optimize TCP Settings         [5] Disable IPv6 (**Caution**)           [8] Reset All Network Settings (**Restart Req.**) ║"
    Write-Host " ║  [2] Reset Winsock (**Restart Req.**) [6] Enable QoS Packet Scheduler       [9] กลับสู่เมนูหลัก                            ║"
    Write-Host " ║  [3] Clear DNS Cache               [7] Set Static DNS Servers                                   ║"
    Write-Host " ║  [4] Optimize Adapter (**Advanced**)                                                          ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    $net_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-9)"
    Write-Host ""

    switch ($net_choice) {
        "1" { Optimize-TCPSettings }
        "2" { Reset-Winsock }
        "3" { Clear-DNSCache }
        "4" { Optimize-AdapterSettings }
        "5" { Show-DisableIPv6Menu }
        "6" { Enable-QoSPacketScheduler }
        "7" { Show-SetStaticDNSMenu }
        "8" { Reset-NetworkSettings }
        "9" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeNetworkMenu
        }
    }
}

function Optimize-TCPSettings {
    Write-Host "[>] กำลังปรับแต่ง TCP settings..."
    netsh int tcp set global autotuninglevel=normal
    netsh int tcp set global congestionprovider=ctcp
    netsh int tcp set global ecncapability=enabled
    netsh int tcp set heuristics disabled
    netsh int tcp set global rss=enabled
    netsh int tcp set global fastopen=enabled
    netsh int tcp set global timestamps=disabled
    netsh int tcp set global initialRto=2000
    netsh int tcp set global nonsackrttresiliency=disabled
    Write-Host "[>] TCP settings ถูกปรับแต่งแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Reset-Winsock {
    Write-Host "[>] กำลัง Reset Winsock..."
    netsh winsock reset
    Write-Host "[>] Winsock reset แล้ว. **กรุณา Restart computer!**" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Clear-DNSCache {
    Write-Host "[>] กำลังล้าง DNS cache..."
    ipconfig /flushdns
    Write-Host "[>] DNS cache ถูกล้างแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Optimize-AdapterSettings {
    Write-Host "[>] กำลังปรับแต่ง adapter settings (**ขั้นสูง - โปรดระวัง**)..." -ForegroundColor Yellow
    $interface_name = (netsh interface show interface | Select-String -Pattern "connected" | ForEach-Object {$_.Line -split "    " | Where-Object {$_} | Select-Object -Skip 1 -First 1}).Trim()
    if ($interface_name) {
        netsh int ip set interface name="$interface_name" dadtransmits=0 store=persistent
        netsh int ip set interface name="$interface_name" routerdiscovery=disabled store=persistent
        Write-Host "[>] กำลัง Disable TCP Security features (**อาจลดความปลอดภัย**)..." -ForegroundColor Yellow
        netsh int tcp set security mpp=disabled
        netsh int tcp set security profiles=disabled
        try {
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*FlowControl' -RegistryValue 0
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*InterruptModeration' -RegistryValue 0
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*PriorityVLANTag' -RegistryValue 3
            Get-NetAdapter -Name $interface_name | Set-NetAdapterAdvancedProperty -RegistryKeyword '*SpeedDuplex' -RegistryValue 0
        } catch {
            Write-Warning "Warning: Could not set advanced adapter properties. Please check manually."
        }
        Write-Host "[>] Adapter settings ถูกปรับแต่งแล้ว. **กรุณาตรวจสอบ connection หลัง tuning.**" -ForegroundColor Yellow
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Adapter optimization ล้มเหลว." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-DisableIPv6Menu {
    Write-Host ""
    Write-Host "[!] **คำเตือน:** การปิดใช้งาน IPv6 อาจทำให้เกิดปัญหา network." -ForegroundColor Yellow
    $confirm_ipv6_disable = Read-Host -Prompt "  คุณต้องการดำเนินการต่อหรือไม่? (Y/N)"
    if ($confirm_ipv6_disable -match "^y" -or $confirm_ipv6_disable -match "^Y") {
        Disable-IPv6
    } else {
        Write-Host "[>] IPv6 disabling ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
        Show-OptimizeNetworkMenu
    }
}

function Disable-IPv6 {
    Write-Host "[>] กำลังปิดใช้งาน IPv6..."
    netsh interface ipv6 set global randomizeidentifiers=disabled
    netsh interface ipv6 set privacy state=disabled
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 255 -PropertyType DWord -Force
    Write-Host "[>] IPv6 ปิดใช้งานแล้ว. **กรุณา Restart computer! ตรวจสอบ connection.**" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Enable-QoSPacketScheduler {
    Write-Host "[>] กำลังเปิดใช้งาน QoS Packet Scheduler..."
    netsh int tcp set global packetcoalescinginbound=disabled
    Set-Service -Name Qwave -StartupType Automatic
    Start-Service -Name Qwave
    Write-Host "[>] QoS Packet Scheduler เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-SetStaticDNSMenu {
    $primary_dns = Read-Host -Prompt "  กรุณาป้อน primary DNS (เช่น, 8.8.8.8)"
    $secondary_dns = Read-Host -Prompt "  กรุณาป้อน secondary DNS (เช่น, 8.8.4.4)"
    Set-StaticDNS -PrimaryDNS $primary_dns -SecondaryDNS $secondary_dns
}

function Set-StaticDNS {
    param(
        [string]$PrimaryDNS,
        [string]$SecondaryDNS
    )
    $interface_name = (netsh interface show interface | Select-String -Pattern "connected" | ForEach-Object {$_.Line -split "    " | Where-Object {$_} | Select-Object -Skip 1 -First 1}).Trim()
    if ($interface_name) {
        netsh interface ip set dns name="$interface_name" source=static address=$PrimaryDNS register=primary
        netsh interface ip add dns name="$interface_name" address=$SecondaryDNS index=2
        Write-Host "[>] Static DNS ถูกตั้งค่าแล้ว."
    } else {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่พบ interface ที่ใช้งานอยู่. Static DNS ล้มเหลว." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Reset-NetworkSettings {
    Write-Host "[>] กำลัง Reset all network settings (**Restart Required**)..." -ForegroundColor Yellow
    netsh winsock reset
    netsh int ip reset
    netsh advfirewall reset
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
    Write-Host "[>] All network settings reset แล้ว. **กรุณา Restart computer!**" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 23: Disable Transparency Effects
function Disable-Transparency {
    Write-Host "[>] กำลังปิดใช้งาน Transparency Effects..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -ValueType DWord
    Write-Host "[>] Transparency Effects ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 24: Disable Extra Animations
function Disable-AnimationsExtra {
    Write-Host "[>] กำลังปิดใช้งาน Extra Animation Effects..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Animations" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Value "1" -ValueType String
    Write-Host "[>] Extra Animations ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 25: Optimize Storage Sense
function Show-OptimizeStorageSenseMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Storage Sense Optimization ══════════╗"
    Write-Host " ║                                              ║"
    Write-Host " ║  [1] Enable Storage Sense      [3] Configure Recycle Bin Cleanup  [5] กลับสู่เมนูหลัก ║"
    Write-Host " ║  [2] Set Cleanup Frequency     [4] Configure Temp Files Cleanup                  ║"
    Write-Host " ║                                              ║"
    Write-Host " ╚══════════════════════════════════════════╝"
    Write-Host ""
    $ss_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($ss_choice) {
        "1" { Enable-StorageSense }
        "2" { Show-ConfigCleanupFrequencyMenu }
        "3" { Config-RecycleBinCleanup }
        "4" { Config-TempFilesCleanup }
        "5" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeStorageSenseMenu
        }
    }
}

function Enable-StorageSense {
    Write-Host "[>] กำลังเปิดใช้งาน Storage Sense..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\StorageSense" -Name "Enabled" -Value 1 -ValueType DWord
    Write-Host "[>] Storage Sense เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-ConfigCleanupFrequencyMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Cleanup Frequency ══════════╗"
    Write-Host " ║                                       ║"
    Write-Host " ║  [1] Every Day    [3] Every Month      ║"
    Write-Host " ║  [2] Every Week   [4] Low Disk Space   ║"
    Write-Host " ║                                       ║"
    Write-Host " ╚══════════════════════════════════════╝"
    Write-Host ""
    $freq_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-4)"
    Write-Host ""

    switch ($freq_choice) {
        "1" { Config-CleanupFrequency -FrequencyValue 1 }
        "2" { Config-CleanupFrequency -FrequencyValue 7 }
        "3" { Config-CleanupFrequency -FrequencyValue 30 }
        "4" { Config-CleanupFrequency -FrequencyValue 0 }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-ConfigCleanupFrequencyMenu
        }
    }
}

function Config-CleanupFrequency {
    param(
        [string]$FrequencyValue
    )
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\StorageSense" -Name "CleanupFrequency" -Value $FrequencyValue -ValueType DWord
    Write-Host "[>] Cleanup frequency ถูกตั้งค่าแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Config-RecycleBinCleanup {
    $rb_days = Read-Host -Prompt "  Days for Recycle Bin cleanup (0=disable)"
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\StorageSense" -Name "DaysToRunRecycleBinCleanup" -Value $rb_days -ValueType DWord
    Write-Host "[>] Recycle Bin cleanup ถูกตั้งค่าแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Config-TempFilesCleanup {
    $temp_days = Read-Host -Prompt "  Days for Temp Files cleanup (0=disable)"
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\StorageSense" -Name "DaysToRunTempFilesCleanup" -Value $temp_days -ValueType DWord
    Write-Host "[>] Temp files cleanup ถูกตั้งค่าแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 26: Disable Startup Sound
function Disable-StartupSound {
    Write-Host "[>] กำลังปิดใช้งาน Startup Sound..."
    Modify-Registry -Path "HKCU:\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" -Name ".Default" -Value "%SystemRoot%\media\Windows Logon.wav" -ValueType String
    Modify-Registry -Path "HKCU:\AppEvents\Schemes\Apps\Explorer\WindowsLogon\.Current" -Name "ExcludeFromCPL" -Value 1 -ValueType DWord
    Write-Host "[>] Startup Sound ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 27: Optimize Paging File (Virtual Memory) (Advanced!)
function Show-OptimizePagingFileMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════ Paging File (Virtual Memory) Optimization (**Advanced**) ══════╗" -ForegroundColor Yellow
    Write-Host " ║                                                                      ║" -ForegroundColor Yellow
    Write-Host " ║ **คำเตือนขั้นสูง:** การตั้งค่า Paging File ที่ไม่ถูกต้องอาจเป็นอันตรายต่อระบบ.   ║" -ForegroundColor Yellow
    Write-Host " ║ โปรดดำเนินการด้วยความระมัดระวังและศึกษาข้อมูล!                        ║" -ForegroundColor Yellow
    Write-Host " ║                                                                      ║" -ForegroundColor Yellow
    Write-Host " ║  [1] System Managed Size (**Recommended**) [3] Disable Paging File (**NOT Recommended!**) [5] กลับสู่เมนูหลัก ║" -ForegroundColor Yellow
    Write-Host " ║  [2] Custom Size                               [4] กลับสู่เมนู CPU                       ║" -ForegroundColor Yellow
    Write-Host " ║                                                                      ║" -ForegroundColor Yellow
    Write-Host " ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    $pf_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($pf_choice) {
        "1" { System-ManagedPagingFile }
        "2" { Show-CustomSizePagingFileMenu }
        "3" { Disable-PagingFileWarn }
        "4" { Show-OptimizeCPUMenu }
        "5" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizePagingFileMenu
        }
    }
}

function System-ManagedPagingFile {
    Write-Host "[>] กำลังตั้งค่า Paging File เป็น System Managed Size (**Recommended**)..."
    try {
        (Get-WmiObject win32_computersystem -ComputerName $env:COMPUTERNAME -ErrorAction Stop) | ForEach-Object {$_.SetAutomaticManagedPagefile($true)}
        Write-Host "[>] Paging File ถูกตั้งค่าเป็น System Managed."
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่สามารถตั้งค่า Paging File เป็น System Managed. กรุณาตรวจสอบสิทธิ์." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Show-CustomSizePagingFileMenu {
    $initial_size = Read-Host -Prompt "  กรุณาป้อน initial size (MB)"
    $max_size = Read-Host -Prompt "  กรุณาป้อน maximum size (MB)"
    Custom-SizePagingFile -InitialSize $initial_size -MaxSize $max_size
}

function Custom-SizePagingFile {
    param(
        [string]$InitialSize,
        [string]$MaxSize
    )
    try {
        (Get-WmiObject win32_pagefileset -ComputerName $env:COMPUTERNAME -ErrorAction Stop | Where-Object {$_.Name -eq "C:\pagefile.sys"}) | ForEach-Object {$_.SetInitialSize($InitialSize)}
        (Get-WmiObject win32_pagefileset -ComputerName $env:COMPUTERNAME -ErrorAction Stop | Where-Object {$_.Name -eq "C:\pagefile.sys"}) | ForEach-Object {$_.SetMaximumSize($MaxSize)}
        Write-Host "[>] Paging File ถูกตั้งค่าเป็น Custom Size (Initial: $($InitialSize)MB, Max: $($MaxSize)MB)."
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่สามารถตั้งค่า Paging File เป็น Custom Size. กรุณาตรวจสอบสิทธิ์และ Paging File configuration." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-PagingFileWarn {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════ Disable Paging File - **CONFIRM RISK!** ══════╗" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ║ **คุณกำลังจะ DISABLE PAGING FILE - ไม่แนะนำ!**             ║" -ForegroundColor Yellow
    Write-Host " ║ **โปรดยืนยันว่าคุณเข้าใจความเสี่ยงด้าน SYSTEM STABILITY (Y/N):** ║" -ForegroundColor Yellow
    Write-Host " ║                                                          ║" -ForegroundColor Yellow
    Write-Host " ╚══════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    $confirm_pf_disable = Read-Host -Prompt "  ยืนยันการดำเนินการต่อ (Y/N)"
    if ($confirm_pf_disable -match "^y" -or $confirm_pf_disable -match "^Y") {
        Disable-PagingFile
    } else {
        Write-Host "[>] Paging File disabling ถูกยกเลิก."
        Write-Host ""
        Read-Host -Prompt "Press Enter to continue..."
        Show-OptimizePagingFileMenu
    }
}

function Disable-PagingFile {
    Write-Host "[>] กำลังปิดใช้งาน Paging File (**NOT Recommended!**)..." -ForegroundColor Yellow
    try {
        (Get-WmiObject win32_computersystem -ComputerName $env:COMPUTERNAME -ErrorAction Stop) | ForEach-Object {$_.SetAutomaticManagedPagefile($false)}
        (Get-WmiObject win32_pagefileset -ComputerName $env:COMPUTERNAME -ErrorAction Stop | Where-Object {$_.Name -eq "C:\pagefile.sys"}) | ForEach-Object {$_.Delete()}
        Write-Host "[>] Paging File ปิดใช้งานแล้ว. **System instability risk! Restart & test system.**" -ForegroundColor Yellow
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่สามารถปิดใช้งาน Paging File. กรุณาตรวจสอบสิทธิ์และ Paging File configuration." -ForegroundColor Red
    }
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 28: Disable Widget Features (Win11)
function Disable-Widgets {
    Write-Host "[>] กำลังปิดใช้งาน Widget Features (Windows 11)..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -ValueType DWord
    Modify-Registry -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -ValueType DWord
    Write-Host "[>] Widget Features ปิดใช้งานแล้ว. (**Restart Explorer or PC recommended.**)" -ForegroundColor Yellow
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 29: Optimize Game Mode Settings
function Show-OptimizeGameModeMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════ Game Mode Optimization ══════════╗"
    Write-Host " ║                                             ║"
    Write-Host " ║  [1] Enable Game Mode         [3] Disable Game DVR & Bar (Option 3) [5] กลับสู่เมนูหลัก ║"
    Write-Host " ║  [2] Disable GameBar Service   [4] กลับสู่เมนู CPU                       ║"
    Write-Host " ║                                             ║"
    Write-Host " ╚══════════════════════════════════════════╝"
    Write-Host ""
    $game_choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-5)"
    Write-Host ""

    switch ($game_choice) {
        "1" { Enable-GameMode }
        "2" { Disable-GameBarService }
        "3" { Disable-GameDVRBar; Read-Host -Prompt "Press Enter to continue..." } # Re-use existing function
        "4" { Show-OptimizeCPUMenu }
        "5" { Show-MainMenu }
        default {
            Write-Host "[!] **ข้อผิดพลาด:** ตัวเลือกไม่ถูกต้อง." -ForegroundColor Red
            Read-Host -Prompt "Press Enter to continue..."
            Show-OptimizeGameModeMenu
        }
    }
}

function Enable-GameMode {
    Write-Host "[>] กำลังเปิดใช้งาน Game Mode..."
    Modify-Registry -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -ValueType DWord
    Write-Host "[>] Game Mode เปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}

function Disable-GameBarService {
    Write-Host "[>] กำลังปิดใช้งาน Game Bar Presence Writer Service..."
    Set-Service -Name GameBarSvc -StartupType Disabled
    Stop-Service -Name GameBarSvc -ErrorAction SilentlyContinue
    Write-Host "[>] Game Bar Presence Writer Service ปิดใช้งานแล้ว."
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 30: Return to Main Menu (Handled in Main Loop)
#endregion

#region Option ?: Help Menu
function Show-HelpMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════ Help Menu ══════════════════════════╗"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  Windows Optimization Script v3.5 - Enhanced Edition - Help                   ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  คำแนะนำการใช้งาน:                                                            ║"
    Write-Host " ║  - ป้อนหมายเลขตัวเลือก (1-30) เพื่อเลือกเมนู.                                  ║"
    Write-Host " ║  - ตัวเลือกที่มี **คำเตือน** ควรใช้ด้วยความระมัดระวัง.                           ║" -ForegroundColor Yellow
    Write-Host " ║  - อ่านคำแนะนำและคำเตือนอย่างละเอียดก่อนดำเนินการ.                             ║"
    Write-Host " ║  - หากพบปัญหา, กรุณาตรวจสอบสิทธิ์ผู้ดูแลระบบและ Restart เครื่อง.                ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  **ข้อมูลเพิ่มเติม:**                                                          ║"
    Write-Host " ║  - Script นี้ปรับปรุงประสิทธิภาพและความเร็วของ Windows.                         ║"
    Write-Host " ║  - เหมาะสำหรับ Windows 11 (อาจมีปัญหาความเข้ากันได้กับ Windows รุ่นเก่า).         ║"
    Write-Host " ║  - การปรับแต่งบางอย่างอาจต้อง Restart เครื่องเพื่อให้มีผล.                        ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  **ติดต่อผู้พัฒนา:** [GT Singtaro]                                             ║"
    Write-Host " ║  **Version:** 3.5 - Enhanced Edition                                          ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ║  กดปุ่มใดก็ได้เพื่อกลับสู่เมนูหลัก...                                           ║"
    Write-Host " ║                                                                              ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    Read-Host -Prompt "Press Enter to continue..."
}
#endregion

#region Option 22: Exit Script
function Exit-Script {
    Clear-Host
    Write-Host ""
    Write-Host " ╔══════════════════════════════════════════════════════════════════╗"
    Write-Host " ║         ขอบคุณที่ใช้ Windows Optimization Script! - Enhanced Edition         ║"
    Write-Host " ║               Script พัฒนาโดย [GT Singtaro]                                 ║"
    Write-Host " ║              Version 3.5 - Enhanced Edition - Main Menu                     ║"
    Write-Host " ╚══════════════════════════════════════════════════════════════════╝"
    Write-Host ""
    Read-Host -Prompt "Press Enter to exit..."
    exit
}
#endregion

#endregion

#region Helper Functions

function Modify-Registry {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Value,
        [ValidateSet("String","DWord","Binary","MultiString","ExpandString","QWord")]
        [string]$ValueType = "String",
        [switch]$ForceName
    )
    try {
        if (!(Test-Path -Path $Path)) {
            New-Item -Path $Path -ItemType Directory -Force | Out-Null
        }
        if ($ValueType -ieq "DWord") {
            New-ItemProperty -Path $Path -Name $Name -Value ([int]$Value) -PropertyType "DWord" -Force -ErrorAction Stop
        } elseif ($ValueType -ieq "Binary") {
            New-ItemProperty -Path $Path -Name $Name -Value ([byte[]]$Value) -PropertyType "Binary" -Force -ErrorAction Stop
        } else {
            New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $ValueType -Force -ErrorAction Stop
        }
    } catch {
        Write-Host "[!] **ข้อผิดพลาด:** ไม่สามารถแก้ไข registry key: $($Path)\$($Name)" -ForegroundColor Red
        Write-Host "    Error: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to continue..."
    }
}

#endregion

#region Main Script Loop
do {
    Show-MainMenu
    $choice = Read-Host -Prompt "  กรุณาเลือกตัวเลือก (1-30)"
    Process-MainMenuChoice -choice $choice
} while ($choice -ne "22") # Loop until Exit option is chosen
#endregion
