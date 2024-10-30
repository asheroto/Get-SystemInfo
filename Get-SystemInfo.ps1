<#PSScriptInfo

.VERSION 4.2.0

.GUID 3b581edb-5d90-4fa1-ba15-4f2377275463

.AUTHOR asheroto, 1ckov, MisterZeus, ChrisTitusTech, uffemcev, MatthiasGuelck, o-l-a-v

.COMPANYNAME asheroto

.TAGS PowerShell Windows winget win get install installer fix script setup

.PROJECTURI https://github.com/asheroto/winget-install

.RELEASENOTES
[Version 0.0.1] - Initial Release.
[Version 0.0.2] - Implemented function to get the latest version of winget and its license.
[Version 0.0.3] - Signed file for PSGallery.
[Version 0.0.4] - Changed URI to grab latest release instead of releases and preleases.
[Version 0.0.5] - Updated version number of dependencies.
[Version 1.0.0] - Major refactor code, see release notes for more information.
[Version 1.0.1] - Fixed minor bug where version 2.8 was hardcoded in URL.
[Version 1.0.2] - Hardcoded UI Xaml version 2.8.4 as a failsafe in case the API fails. Added CheckForUpdates, Version, Help functions. Various bug fixes.
[Version 1.0.3] - Added error message to catch block. Fixed bug where appx package was not being installed.
[Version 1.0.4] - MisterZeus optimized code for readability.
[Version 2.0.0] - Major refactor. Reverted to UI.Xaml 2.7.3 for stability. Adjusted script to fix install issues due to winget changes (thank you ChrisTitusTech). Added in all architecture support.
[Version 2.0.1] - Renamed repo and URL references from winget-installer to winget-install. Added extra space after the last line of output.
[Version 2.0.2] - Adjusted CheckForUpdates to include Install-Script instructions and extra spacing.
[Version 2.1.0] - Added alternate method/URL for dependencies in case the main URL is down. Fixed licensing issue when winget is installed on Server 2022.
[Version 2.1.1] - Switched primary/alternate methods. Added Cleanup function to avoid errors when cleaning up temp files. Added output of URL for alternate method. Suppressed Add-AppxProvisionedPackage output. Improved success message. Improved verbiage. Improve PS script comments. Added check if the URL is empty. Moved display of URL beneath the check.
[Version 3.0.0] - Major changes. Added OS version detection checks - detects OS version, release ID, ensures compatibility. Forces older file installation for Server 2022 to avoid issues after installing. Added DebugMode, DisableCleanup, Force. Renamed CheckForUpdates to CheckForUpdate. Improved output. Improved error handling. Improved comments. Improved code readability. Moved CheckForUpdate into function. Added PowerShellGalleryName. Renamed Get-OSVersion to Get-OSInfo. Moved architecture detection into Get-OSInfo. Renamed Get-NewestLink to Get-WingetDownloadUrl. Have Get-WingetDownloadUrl not get preview releases.
[Version 3.0.1] - Updated Get-OSInfo function to fix issues when used on non-English systems. Improved error handling of "resources in use" error.
[Version 3.0.2] - Added winget registration command for Windows 10 machines.
[Version 3.1.0] - Added support for one-line installation with irm and iex compatible with $Force session variable. Added UpdateSelf command to automatically update the script to the latest version. Created short URL asheroto.com/winget.
[Version 3.1.1] - Changed winget register command to run on all OS versions.
[Version 3.2.0] - Added -ForceClose logic to relaunch the script in conhost.exe and automatically end active processes associated with winget that could interfere with the installation. Improved verbiage on winget already installed.
[Version 3.2.1] - Fixed minor glitch when using -Version or -Help parameters.
[Version 3.2.2] - Improved script exit functionality.
[Version 3.2.3] - Improved -ForceClose window handling with x86 PowerShell process.
[Version 3.2.4] - Improved verbiage for incompatible systems. Added importing Appx module on Windows Server with PowerShell 7+ systems to avoid error message.
[Version 3.2.5] - Removed pause after script completion. Added optional Wait parameter to force script to wait several seconds for script output.
[Version 3.2.6] - Improved ExitWithDelay function. Sometimes PowerShell will close the window accidentally, even when using the proper 'exit' command. Adjusted several closures for improved readability. Improved error code checking. Fixed glitch with -Wait param.
[Version 3.2.7] - Addded ability to install for all users. Added checks for Windows Sandbox and administrative privileges.
[Version 4.0.0] - Microsoft created some short URLs for winget. Removed a large portion of the script to use short URLs instead. Simplified and refactored. Switched debug param from DebugMode to Debug.
[Version 4.0.1] - Fixed PowerShell help information.
[Version 4.0.2] - Adjusted UpdateSelf function to reset PSGallery to original state if it was not trusted. Improved comments.
[Version 4.0.3] - Updated UI.Xaml package as per winget-cli issue #4208.
[Version 4.0.4] - Fixed detection for Windows multi-session.
[Version 4.0.5] - Improved error handling when registering winget.
[Version 4.1.0] - Support for Windows Server 2019 added by installing Visual C++ Redistributable.
[Version 4.1.1] - Minor revisions to comments & debug output.
[Version 4.1.2] - Implemented Visual C++ Redistributable version detection to ensure compatibility with winget.
[Version 4.1.3] - Added additional debug output for Visual C++ Redistributable version detection.
[Version 4.2.0] - Added environment path detection and addition if needed. Added NoExit parameter to prevent script from exiting after completion.

#>

<#
.SYNOPSIS
	Downloads and installs the latest version of winget and its dependencies.
.DESCRIPTION
	Downloads and installs the latest version of winget and its dependencies.

This script is designed to be straightforward and easy to use, removing the hassle of manually downloading, installing, and configuring winget. This function should be run with administrative privileges.
.EXAMPLE
	winget-install
.PARAMETER Debug
    Enables debug mode, which shows additional information for debugging.
.PARAMETER Force
    Ensures installation of winget and its dependencies, even if already present.
.PARAMETER ForceClose
    Relaunches the script in conhost.exe and automatically ends active processes associated with winget that could interfere with the installation.
.PARAMETER Wait
    Forces the script to wait several seconds before exiting.
.PARAMETER NoExit
    Forces the script to wait indefinitely before exiting.
.PARAMETER UpdateSelf
    Updates the script to the latest version on PSGallery.
.PARAMETER CheckForUpdate
    Checks if there is an update available for the script.
.PARAMETER Version
    Displays the version of the script.
.PARAMETER Help
    Displays the full help information for the script.
.NOTES
	Version      : 4.2.0
	Created by   : asheroto
.LINK
	Project Site: https://github.com/asheroto/winget-install
#>
[CmdletBinding()]
param (
    [switch]$Force,
    [switch]$ForceClose,
    [switch]$CheckForUpdate,
    [switch]$Wait,
    [switch]$NoExit,
    [switch]$UpdateSelf,
    [switch]$Version,
    [switch]$Help
)

# Script information
$CurrentVersion = '1.0.0'
$RepoOwner = 'asheroto'
$RepoName = 'Get-SystemInfo'
$PowerShellGalleryName = 'Get-SystemInfo'

# Preferences
$ProgressPreference = 'SilentlyContinue' # Suppress progress bar (makes downloading super fast)
$ConfirmPreference = 'None' # Suppress confirmation prompts

# Display version if -Version is specified
if ($Version.IsPresent) {
    $CurrentVersion
    exit 0
}

# Display full help if -Help is specified
if ($Help) {
    Get-Help -Name $MyInvocation.MyCommand.Source -Full
    exit 0
}

# Display $PSVersionTable and Get-Host if -Verbose is specified
if ($PSBoundParameters.ContainsKey('Verbose') -and $PSBoundParameters['Verbose']) {
    $PSVersionTable
    Get-Host
}

# Set debug preferences if -Debug is specified
if ($PSBoundParameters.ContainsKey('Debug') -and $PSBoundParameters['Debug']) {
    $DebugPreference = 'Continue'
    $ConfirmPreference = 'None'
}

function Get-SystemInfo {
    function Write-Header {
        param (
            [string]$Header,
            [string]$Value
        )
        Write-Host "${Header}: " -ForegroundColor Green -NoNewline
        Write-Output $Value
    }

    # System Information
    Write-Section "System Information"
    $hostname = $env:COMPUTERNAME
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    $bios = Get-CimInstance -ClassName Win32_BIOS

    Write-Header "Hostname" $hostname

    # Hardware and Firmware Details
    Write-Section "Hardware and Firmware Details"
    Write-Header "Make/Model" "$($cs.Manufacturer) $($cs.Model)"
    Write-Header "Serial Number" $bios.SerialNumber
    Write-Header "Firmware Manufacturer" $bios.Manufacturer
    Write-Header "Firmware Version" $bios.SMBIOSBIOSVersion

    # OS Details
    Write-Section "OS Details"
    $uptime = (Get-Date) - $os.LastBootUpTime
    $displayVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion

    Write-Header "OS Version" $os.Caption
    Write-Header "OS Display Version" $displayVersion
    Write-Header "OS Architecture" $os.OSArchitecture
    Write-Header "OS Install Date" $os.InstallDate
    Write-Header "OS Last Boot Time" $os.LastBootUpTime
    Write-Header "System Uptime" "$([math]::Floor($uptime.TotalDays)) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"

    # CPU Details
    Write-Section "CPU Details"
    $cpu = Get-CimInstance -ClassName Win32_Processor
    $cpuSpeedGHz = [math]::Round($cpu.MaxClockSpeed / 1000, 2)

    Write-Header "CPU Make/Model" $cpu.Name
    Write-Header "CPU Speed" "$cpuSpeedGHz GHz"
    Write-Header "CPU Usage" "$(($cpu | Measure-Object -Property LoadPercentage -Average).Average)%"
    Write-Header "CPU Cores" $cpu.NumberOfCores
    Write-Header "CPU Threads (Logical Processors)" $cpu.NumberOfLogicalProcessors

    # Memory details
    Write-Section "Memory Details"

    # Total memory summary
    $totalRAM = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    $freeMem = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $usedMem = $totalRAM - $freeMem
    $memUsage = [math]::Round(($usedMem / $totalRAM) * 100, 2)

    Write-Header "Total RAM (GB)" $totalRAM
    Write-Header "Used RAM (GB)" $usedMem
    Write-Header "Free RAM (GB)" $freeMem
    Write-Header "Memory Usage (%)" $memUsage

    # Collect RAM DIMM information for table display
    $dimmDetails = Get-CimInstance -ClassName Win32_PhysicalMemory | ForEach-Object {
        # Remove "Controller" from DeviceLocator for DIMM Number and Controller
        $dimmSlot = $_.DeviceLocator -replace "Controller", ""
        $controller = if ($dimmSlot -match "(\d+)-") { $matches[1] } else { "N/A" }
        $slot = if ($dimmSlot -match "-(DIMM\w+)") { $matches[1] } else { $dimmSlot }

        # Determine size and model details
        $dimmSizeGB = [math]::Round($_.Capacity / 1GB, 2)
        $makeModel = if ($_.Model) { $_.Model } elseif ($_.PartNumber) { $_.PartNumber } else { "Unknown" }

        # Output each DIMM detail as a custom object
        [PSCustomObject]@{
            "DIMM Number" = $dimmSlot
            "Controller"  = $controller
            "Slot"        = $slot
            "RAM (GB)"    = $dimmSizeGB
            "Model/Part"  = $makeModel
        }
    }

    # Display the table
    $dimmDetails | Format-Table -AutoSize

    # Disk usage in table format
    Write-Section "Disk Usage"
    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        $totalSizeGB = [math]::Round($_.Size / 1GB, 2)
        $freeSpaceGB = [math]::Round($_.FreeSpace / 1GB, 2)
        $usedSpaceGB = $totalSizeGB - $freeSpaceGB
        $driveUsage = [math]::Round(($usedSpaceGB / $totalSizeGB) * 100, 2)

        # Retrieve associated physical disk information
        $physicalDisk = Get-CimInstance -Query "ASSOCIATORS OF {Win32_LogicalDisk.DeviceID='$($_.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition" |
        ForEach-Object { Get-CimInstance -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($_.DeviceID)'} WHERE AssocClass=Win32_DiskDriveToDiskPartition" }

        $makeModel = if ($physicalDisk.Model) { $physicalDisk.Model } else { "Unknown" }

        # Create a custom object for each disk
        [PSCustomObject]@{
            Drive             = $_.DeviceID
            "Volume Label"    = $_.VolumeName
            "Total Size (GB)" = $totalSizeGB
            "Free Space (GB)" = $freeSpaceGB
            "Used Space (GB)" = $usedSpaceGB
            "Usage (%)"       = $driveUsage
            "Make/Model"      = $makeModel
        }
    }

    # Display the table
    $diskInfo | Format-Table -AutoSize

    # Network Adapter Details
    Write-Section "Network Adapter Details"

    # Retrieve network adapter information and format it as a table
    $networkInfo = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true } | ForEach-Object {
        $adapterName = $_.Description
        $macAddress = $_.MACAddress
        $ipAddresses = $_.IPAddress -join ", "
        $subnetMasks = $_.IPSubnet -join ", "
        $defaultGateway = if ($_.DefaultIPGateway) { $_.DefaultIPGateway -join ", " } else { "N/A" }

        # Create a custom object for each network adapter
        [PSCustomObject]@{
            "Adapter"         = $adapterName
            "MAC Address"     = $macAddress
            "IP Address(es)"  = $ipAddresses
            "Subnet Mask(s)"  = $subnetMasks
            "Default Gateway" = $defaultGateway
        }
    }

    # Display the table
    $networkInfo | Format-Table -AutoSize
}

function Get-LastShutdownEvents {
    Write-Section "Last Shutdown Events"
    try {
        $shutdownEvents = Get-WinEvent -FilterHashtable @{LogName = 'System'; ID = 1074 } -ErrorAction SilentlyContinue |
                          Select-Object -Property TimeCreated, Message |
                          Sort-Object -Property TimeCreated -Descending |
                          Select-Object -First 5

        if ($shutdownEvents) {
            $shutdownEvents | ForEach-Object {
                Write-Output "$($_.TimeCreated): $($_.Message)"
            }
        } else {
            Write-Output "No shutdown events found."
        }
    } catch {
        Write-Output "An error occurred while retrieving shutdown events: $_"
    }
}

function Get-PendingRebootReasons {
    Write-Section "Pending Reboot Check"
    $PendingRebootReasons = @()

    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
        $PendingRebootReasons += "Windows Update"
    }
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending") {
        $PendingRebootReasons += "Component-Based Servicing"
    }
    if ((Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager").PendingFileRenameOperations) {
        $PendingRebootReasons += "Pending File Rename Operations"
    }
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Cluster\PendingReboot") {
        $PendingRebootReasons += "Cluster Pending Reboot"
    }

    if ($PendingRebootReasons.Count -gt 0) {
        Write-Output "Pending reboot reasons:"
        $PendingRebootReasons | ForEach-Object { Write-Output "- $_" }
    } else {
        Write-Output "No pending reboot."
    }
}

function Write-Section($text) {
    Write-Output ""
    Write-Output ("#" * ($text.Length + 4))
    Write-Output "# $text #"
    Write-Output ("#" * ($text.Length + 4))
    Write-Output ""
}

# Main execution
Get-SystemInfo
Get-PendingRebootReasons
Get-LastShutdownEvents