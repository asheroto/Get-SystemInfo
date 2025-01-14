<#PSScriptInfo

.VERSION 1.0.2

.GUID 21f7b5b3-f9bd-4611-a846-9372c3a89275

.AUTHOR asheroto

.COMPANYNAME asheroto

.TAGS PowerShell Windows get system info information hardware firmware details disk memory network pending reboot usage shutdown event last

.PROJECTURI https://github.com/asheroto/Get-SystemInfo

.RELEASENOTES
[Version 1.0.0] - Initial Release.
[Version 1.0.1] - Added TPM information support.
[Version 1.0.2] - Added graphics card information support.

#>

<#
.SYNOPSIS
    Gathers detailed system diagnostics, including configuration, hardware, network, and OS status.
.DESCRIPTION
    This script provides a complete overview of system information, hardware specifications, network details, and pending reboot status. It is useful for IT professionals who need to quickly retrieve in-depth diagnostics on Windows systems.
.EXAMPLE
    Get-SystemInfo
    Runs the script to display detailed system information.
.PARAMETER CheckForUpdate
    Checks if an update is available for this script.
.PARAMETER UpdateSelf
    Updates the script to the latest version from PSGallery.
.PARAMETER Version
    Displays the current version of the script.
.PARAMETER Help
    Shows detailed help information for the script.
.NOTES
    Version      : 1.0.2
    Created by   : asheroto
.LINK
    Project Site: https://github.com/asheroto/Get-SystemInfo
#>
[CmdletBinding()]
param (
    [switch]$CheckForUpdate,
    [switch]$UpdateSelf,
    [switch]$Version,
    [switch]$Help,
    [string]$OutputFile
)

# Script information
$CurrentVersion = '1.0.2'
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

function Get-GitHubRelease {
    <#
        .SYNOPSIS
        Fetches the latest release information of a GitHub repository.

        .DESCRIPTION
        This function uses the GitHub API to get information about the latest release of a specified repository, including its version and the date it was published.

        .PARAMETER Owner
        The GitHub username of the repository owner.

        .PARAMETER Repo
        The name of the repository.

        .EXAMPLE
        Get-GitHubRelease -Owner "asheroto" -Repo "Get-SystemInfo"
        This command retrieves the latest release version and published datetime of the Get-SystemInfo repository owned by asheroto.
    #>
    [CmdletBinding()]
    param (
        [string]$Owner,
        [string]$Repo
    )
    try {
        $url = "https://api.github.com/repos/$Owner/$Repo/releases/latest"
        $response = Invoke-RestMethod -Uri $url -ErrorAction Stop

        $latestVersion = $response.tag_name
        $publishedAt = $response.published_at

        # Convert UTC time string to local time
        $UtcDateTime = [DateTime]::Parse($publishedAt, [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::RoundtripKind)
        $PublishedLocalDateTime = $UtcDateTime.ToLocalTime()

        [PSCustomObject]@{
            LatestVersion     = $latestVersion
            PublishedDateTime = $PublishedLocalDateTime
        }
    } catch {
        Write-Error "Unable to check for updates.`nError: $_"
        exit 1
    }
}

function CheckForUpdate {
    param (
        [string]$RepoOwner,
        [string]$RepoName,
        [version]$CurrentVersion,
        [string]$PowerShellGalleryName
    )

    $Data = Get-GitHubRelease -Owner $RepoOwner -Repo $RepoName

    Write-Output ""
    Write-Output ("Repository:       {0,-40}" -f "https://github.com/$RepoOwner/$RepoName")
    Write-Output ("Current Version:  {0,-40}" -f $CurrentVersion)
    Write-Output ("Latest Version:   {0,-40}" -f $Data.LatestVersion)
    Write-Output ("Published at:     {0,-40}" -f $Data.PublishedDateTime)

    if ($Data.LatestVersion -gt $CurrentVersion) {
        Write-Output ("Status:           {0,-40}" -f "A new version is available.")
        Write-Output "`nOptions to update:"
        Write-Output "- Download latest release: https://github.com/$RepoOwner/$RepoName/releases"
        if ($PowerShellGalleryName) {
            Write-Output "- Run: $RepoName -UpdateSelf"
            Write-Output "- Run: Install-Script $PowerShellGalleryName -Force"
        }
    } else {
        Write-Output ("Status:           {0,-40}" -f "Up to date.")
    }
    exit 0
}

function UpdateSelf {
    try {
        # Get PSGallery version of script
        $psGalleryScriptVersion = (Find-Script -Name $PowerShellGalleryName).Version

        # If the current version is less than the PSGallery version, update the script
        if ($CurrentVersion -lt $psGalleryScriptVersion) {
            Write-Output "Updating script to version $psGalleryScriptVersion..."

            # Install NuGet PackageProvider if not already installed
            if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
                Install-PackageProvider -Name "NuGet" -Force
            }

            # Trust the PSGallery if not already trusted
            $psRepoInstallationPolicy = (Get-PSRepository -Name 'PSGallery').InstallationPolicy
            if ($psRepoInstallationPolicy -ne 'Trusted') {
                Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted | Out-Null
            }

            # Update the script
            Install-Script $PowerShellGalleryName -Force

            # If PSGallery was not trusted, reset it to its original state
            if ($psRepoInstallationPolicy -ne 'Trusted') {
                Set-PSRepository -Name 'PSGallery' -InstallationPolicy $psRepoInstallationPolicy | Out-Null
            }

            Write-Output "Script updated to version $psGalleryScriptVersion."
            exit 0
        } else {
            Write-Output "Script is already up to date."
            exit 0
        }
    } catch {
        Write-Output "An error occurred: $_"
        exit 1
    }
}

# ============================================================================ #
# Initial checks
# ============================================================================ #

# First heading
Write-Output "Get-SystemInfo $CurrentVersion"

# Check for updates if -CheckForUpdate is specified
if ($CheckForUpdate) { CheckForUpdate -RepoOwner $RepoOwner -RepoName $RepoName -CurrentVersion $CurrentVersion -PowerShellGalleryName $PowerShellGalleryName }

# Update the script if -UpdateSelf is specified
if ($UpdateSelf) { UpdateSelf }

# Heading
Write-Output "To check for updates, run Get-SystemInfo -CheckForUpdate"

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

    # TPM
    Write-Section "TPM Information"
    $tpm = Get-CimInstance -Namespace "root\cimv2\security\microsofttpm" -ClassName Win32_Tpm

    if ($tpm) {
        Write-Header "TPM Activated" $tpm.IsActivated_InitialValue
        Write-Header "TPM Enabled" $tpm.IsEnabled_InitialValue
        Write-Header "TPM Owned" $tpm.IsOwned_InitialValue
        Write-Header "TPM Version" ($tpm.SpecVersion -split ',')[0]
    } else {
        Write-Output "No TPM detected."
    }

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

    # Graphics Card Information
    Write-Section "Graphics Card Information"
    $graphicsCard = Get-CimInstance -ClassName Win32_VideoController | ForEach-Object {
        [PSCustomObject]@{
            "Name"             = $_.Name
            "Adapter RAM (GB)" = [math]::round($_.AdapterRAM / 1GB, 2)
            "Driver Version"   = $_.DriverVersion
            "Driver Date"      = $_.DriverDate
            "Status"           = $_.Status
        }
    }

    # Display the table
    $graphicsCard | Format-Table -AutoSize

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