<#PSScriptInfo

.VERSION 2.0.0

.GUID 21f7b5b3-f9bd-4611-a846-9372c3a89275

.AUTHOR asheroto

.COMPANYNAME asheroto

.TAGS PowerShell Windows get system info information hardware firmware details disk memory network pending reboot usage shutdown event last

.PROJECTURI https://github.com/asheroto/Get-SystemInfo

.RELEASENOTES
[Version 1.0.0] - Initial Release.
[Version 1.0.1] - Added TPM information support.
[Version 1.0.2] - Added graphics card information support.
[Version 2.0.0] - Redesigned for improved functionality with robust support for object-oriented usage, allowing easy access to specific diagnostic sections.

<#
.SYNOPSIS
    Gathers detailed system diagnostics, including configuration, hardware, network, and OS status.

.DESCRIPTION
    This function provides a complete overview of system information, hardware specifications, network details, and pending reboot status. It is designed to be used either as a standalone script for console output or programmatically as a function to retrieve diagnostics as an object.

.PARAMETER CheckForUpdate
    Checks if there is an update available for the script. The latest version information is retrieved from GitHub.

.PARAMETER UpdateSelf
    Updates the script to the latest version available in the PowerShell Gallery.

.PARAMETER Version
    Displays the current version of the script.

.PARAMETER Help
    Displays detailed help information for the script, including usage examples.

.PARAMETER Silent
    Suppresses console output when running the script. Useful for retrieving the diagnostics as an object without any visible output.

.EXAMPLE
    .\Get-SystemInfo.ps1
    Runs the script and displays all diagnostics in a well-formatted console output.

.EXAMPLE
    . .\Get-SystemInfo.ps1 -Silent
    $info = Get-SystemInfo
    Retrieves all diagnostics as an object for programmatic access.

.EXAMPLE
    Get-SystemInfo -CheckForUpdate
    Checks for updates to the script.

.EXAMPLE
    Get-SystemInfo -UpdateSelf
    Updates the script to the latest version from the PowerShell Gallery.

.INPUTS
    None.

.OUTPUTS
    [PSCustomObject]
    Returns a custom object containing system diagnostics, including sections such as System, Hardware, TPM, OS, CPU, Memory, Disks, Graphics, NetworkAdapters, PendingReboot, and ShutdownEvents.

.NOTES
    Author: asheroto
    Version: 2.0.0
    Repository: https://github.com/asheroto/Get-SystemInfo

.LINK
    https://github.com/asheroto/Get-SystemInfo
#>

[CmdletBinding()]
param (
    [switch]$CheckForUpdate,
    [switch]$UpdateSelf,
    [switch]$Version,
    [switch]$Help,
    [switch]$Silent
)

# Script information
$CurrentVersion = '2.0.0'
$RepoOwner = 'asheroto'
$RepoName = 'Get-SystemInfo'
$PowerShellGalleryName = 'Get-SystemInfo'

# Preferences
$ProgressPreference = 'SilentlyContinue'
$ConfirmPreference = 'None'

if ($Version.IsPresent) {
    $CurrentVersion
    exit 0
}

if ($Help) {
    Get-Help -Name $MyInvocation.MyCommand.Source -Full
    exit 0
}

function Get-SystemInfo {
    $result = [PSCustomObject]@{
        System          = [PSCustomObject]@{
            Hostname = $env:COMPUTERNAME
        }
        Hardware        = [PSCustomObject]@{
            MakeModel            = $null
            SerialNumber         = $null
            FirmwareManufacturer = $null
            FirmwareVersion      = $null
        }
        TPM             = [PSCustomObject]@{
            IsActivated = $null
            IsEnabled   = $null
            IsOwned     = $null
            Version     = $null
        }
        OS              = [PSCustomObject]@{
            Version        = $null
            DisplayVersion = $null
            Architecture   = $null
            InstallDate    = $null
            LastBootTime   = $null
            Uptime         = $null
        }
        CPU             = [PSCustomObject]@{
            MakeModel = $null
            SpeedGHz  = $null
            Usage     = $null
            Cores     = $null
            Threads   = $null
        }
        Memory          = [PSCustomObject]@{
            TotalGB      = $null
            UsedGB       = $null
            UsagePercent = $null
            DIMMs        = @()
        }
        Disks           = @()
        Graphics        = @()
        NetworkAdapters = @()
        PendingReboot   = @()
        ShutdownEvents  = @()
    }

    # Populate Hardware Information
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios = Get-CimInstance -ClassName Win32_BIOS
    $result.Hardware.MakeModel = "$($cs.Manufacturer) $($cs.Model)"
    $result.Hardware.SerialNumber = $bios.SerialNumber
    $result.Hardware.FirmwareManufacturer = $bios.Manufacturer
    $result.Hardware.FirmwareVersion = $bios.SMBIOSBIOSVersion

    # Populate TPM Information
    $tpm = Get-CimInstance -Namespace "root\cimv2\security\microsofttpm" -ClassName Win32_Tpm
    if ($tpm) {
        $result.TPM.IsActivated = $tpm.IsActivated_InitialValue
        $result.TPM.IsEnabled = $tpm.IsEnabled_InitialValue
        $result.TPM.IsOwned = $tpm.IsOwned_InitialValue
        $result.TPM.Version = ($tpm.SpecVersion -split ',')[0]
    }

    # Populate OS Information
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $uptime = (Get-Date) - $os.LastBootUpTime
    $displayVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion
    $result.OS.Version = $os.Caption
    $result.OS.DisplayVersion = $displayVersion
    $result.OS.Architecture = $os.OSArchitecture
    $result.OS.InstallDate = $os.InstallDate
    $result.OS.LastBootTime = $os.LastBootUpTime
    $result.OS.Uptime = "$([math]::Floor($uptime.TotalDays)) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"

    # Populate CPU Information
    $cpu = Get-CimInstance -ClassName Win32_Processor
    $result.CPU.MakeModel = $cpu.Name
    $result.CPU.SpeedGHz = [math]::Round($cpu.MaxClockSpeed / 1000, 2)
    $result.CPU.Usage = "$(($cpu | Measure-Object -Property LoadPercentage -Average).Average)%"
    $result.CPU.Cores = $cpu.NumberOfCores
    $result.CPU.Threads = $cpu.NumberOfLogicalProcessors

    # Populate Memory Information
    $result.Memory.TotalGB = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    $result.Memory.UsedGB = $result.Memory.TotalGB - [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $result.Memory.UsagePercent = [math]::Round(($result.Memory.UsedGB / $result.Memory.TotalGB) * 100, 2)
    $result.Memory.DIMMs = Get-CimInstance -ClassName Win32_PhysicalMemory | ForEach-Object {
        [PSCustomObject]@{
            DIMMNumber   = $_.DeviceLocator
            SizeGB       = if ($_.Capacity) { [math]::Round($_.Capacity / 1GB, 2) } else { "N/A" }
            Model        = if ($_.PartNumber) { $_.PartNumber } else { "Unknown" }
            SpeedMHz     = if ($_.Speed) { $_.Speed } else { "Unknown" }
            Manufacturer = if ($_.Manufacturer) { $_.Manufacturer } else { "Unknown" }
        }
    }

    # Populate Disk Information
    $result.Disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        [PSCustomObject]@{
            Drive        = $_.DeviceID
            TotalSizeGB  = [math]::Round($_.Size / 1GB, 2)
            FreeSpaceGB  = [math]::Round($_.FreeSpace / 1GB, 2)
            UsagePercent = [math]::Round((($_.Size - $_.FreeSpace) / $_.Size) * 100, 2)
        }
    }

    # Populate Graphics Card Information
    $result.Graphics = Get-CimInstance -ClassName Win32_VideoController | ForEach-Object {
        [PSCustomObject]@{
            Name          = $_.Name
            MemoryGB      = [math]::Round($_.AdapterRAM / 1GB, 2)
            DriverVersion = $_.DriverVersion
            DriverDate    = $_.DriverDate
        }
    }

    $result.NetworkAdapters = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object {
        $adapter = Get-CimInstance -Query "SELECT * FROM Win32_NetworkAdapter WHERE Index = $($_.Index)"
        [PSCustomObject]@{
            Adapter     = $_.Description
            IP          = $_.IPAddress -join ", "
            MAC         = $_.MACAddress
            SpeedMbps   = if ($adapter.Speed) { [math]::Round($adapter.Speed / 1e6, 2) } else { "Unknown" }
            DHCPEnabled = $_.DHCPEnabled
        }
    }

    # Populate Pending Reboot Information
    $result.PendingReboot = @()

    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        $result.PendingReboot += [PSCustomObject]@{
            Source  = "Windows Update"
            Details = "Reboot required for pending updates."
            Path    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
        }
    }

    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        $result.PendingReboot += [PSCustomObject]@{
            Source  = "Component-Based Servicing"
            Details = "Reboot required for servicing stack changes."
            Path    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending"
        }
    }

    if ((Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager").PendingFileRenameOperations) {
        $result.PendingReboot += [PSCustomObject]@{
            Source  = "Pending File Rename Operations"
            Details = "Reboot required for file operations."
            Path    = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager"
        }
    }

    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Cluster\PendingReboot") {
        $result.PendingReboot += [PSCustomObject]@{
            Source  = "Cluster Pending Reboot"
            Details = "Cluster changes require a reboot."
            Path    = "HKLM:\SOFTWARE\Microsoft\Cluster\PendingReboot"
        }
    }

    # Populate Shutdown Events
    $result.ShutdownEvents = Get-WinEvent -FilterHashtable @{ LogName = 'System'; ID = 1074 } |
    Select-Object -First 5 -Property TimeCreated, Message

    return $result
}

if ($CheckForUpdate) {
    CheckForUpdate -RepoOwner $RepoOwner -RepoName $RepoName -CurrentVersion $CurrentVersion -PowerShellGalleryName $PowerShellGalleryName
}

if ($UpdateSelf) {
    UpdateSelf
}

# Main execution
if (-not $Silent) {
    $info = Get-SystemInfo

    function Write-Section($text) {
        <#
            .SYNOPSIS
            Prints a text block surrounded by a section divider for enhanced output readability.

            .DESCRIPTION
            This function takes a string input and prints it to the console, surrounded by a section divider made of hash characters.
            It is designed to enhance the readability of console output.

            .PARAMETER text
            The text to be printed within the section divider.

            .EXAMPLE
            Write-Section "Downloading Files..."
            This command prints the text "Downloading Files..." surrounded by a section divider.
        #>
        Write-Output ""
        Write-Output ("#" * ($text.Length + 4))
        Write-Output "# $text #"
        Write-Output ("#" * ($text.Length + 4))
        Write-Output ""
    }

    Write-Section "System Information"
    $info.System | Format-List

    Write-Section "Hardware Information"
    $info.Hardware | Format-List

    Write-Section "TPM Information"
    $info.TPM | Format-List

    Write-Section "OS Information"
    $info.OS | Format-List

    Write-Section "CPU Information"
    $info.CPU | Format-List

    Write-Section "Memory Information"
    $info.Memory | Format-List
    $info.Memory.DIMMs | Format-Table -AutoSize

    Write-Section "Disk Information"
    $info.Disks | Format-Table -AutoSize

    Write-Section "Graphics Information"
    $info.Graphics | Format-Table -AutoSize

    Write-Section "Network Adapters"
    $info.NetworkAdapters | Format-Table -AutoSize

    Write-Section "Pending Reboot Information"
    $info.PendingReboot | ForEach-Object { Write-Output "- $_" }

    Write-Section "Last Shutdown Events"
    $info.ShutdownEvents | Format-Table -AutoSize
}