# Get-SystemInfo

This PowerShell script provides comprehensive system diagnostics by gathering detailed information on system configuration, hardware, network, and operating status. It is designed for Windows environments and is particularly useful for IT professionals and support staff who need rapid insight into system specs and performance.

## Features

- **System Information**: Retrieves hostname, OS version and architecture, display version, installation date, last boot time, and uptime.
- **Hardware and Firmware Details**: Shows the make and model of the computer, firmware manufacturer, version, and serial number.
- **CPU Details**: Provides CPU model, speed, usage, core count, and logical processor count.
- **Memory Details**: Displays total, used, and free RAM along with memory usage percentage. Additionally, lists details for each DIMM slot, including slot identifier, controller, size, and model/part number.
- **Disk Usage**: For each drive, displays the device ID, volume label, total size, free space, used space, usage percentage, and make/model of the physical disk.
- **Network Adapter Details**: Shows network adapter information, including adapter name, MAC address, IP address, subnet mask, and default gateway.
- **Pending Reboot Check**: Detects pending reboots due to Windows Update, Component-Based Servicing, pending file rename operations, or cluster reboots.
- **Last Shutdown Events**: Lists the five most recent system shutdown events for diagnostic purposes.

## Requirements

- **PowerShell 5.1** or higher (pre-installed on Windows 10 and 11)
- **Supported OS**: Windows 10, Windows 11, Server 2018, Server 2022

## Setup

### Method 1 - PowerShell Gallery

> [!TIP]
>If you want to trust PSGallery so you aren't prompted each time you run this command, or if you're scripting this and want to ensure the script isn't interrupted the first time it runs...
>```powershell
>Install-PackageProvider -Name "NuGet" -Force
>Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
>```

**This is the recommended method, because it always gets the public release that has been tested, it's easy to remember, and supports all parameters.**

Open PowerShell as Administrator and type

```powershell
Install-Script Get-SystemInfo -Force
```

Follow the prompts to complete the installation (you can tap `A` to accept all prompts or `Y` to select them individually.

**Note:** `-Force` is optional but recommended, as it will force the script to update if it is outdated. If you do not use `-Force`, it will _not_ overwrite the script if outdated.

### Usage

```powershell
Get-SystemInfo
```

The script is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/Get-SystemInfo) under `Get-SystemInfo`.

### Method 2 - One Line Command (Runs Immediately)

The URL [asheroto.com/Get-SystemInfo](https://asheroto.com/Get-SystemInfo) always redirects to the [latest code-signed release](https://github.com/asheroto/Get-SystemInfo/releases/latest/download/Get-SystemInfo.ps1) of the script.

If you just need to run the basic script without any parameters, you can use the following one-line command:

### Option A: asheroto.com short URL

```powershell
irm asheroto.com/Get-SystemInfo | iex
```

### Option B: direct release URL

Alternatively, you can of course use the latest code-signed release URL directly:

```powershell
irm https://github.com/asheroto/Get-SystemInfo/releases/latest/download/Get-SystemInfo.ps1 | iex
```

### Method 3 - Download Locally and Run

As a more conventional approach, download the latest [Get-SystemInfo.ps1](https://github.com/asheroto/Get-SystemInfo/releases/latest/download/Get-SystemInfo.ps1) from [Releases](https://github.com/asheroto/Get-SystemInfo/releases), then run the script as follows:

```powershell
.\Get-SystemInfo.ps1
```

> [!TIP]
> If for some reason your PowerShell window closes at the end of the script and you don't want it to, or don't want your other scripts to be interrupted, you can wrap the command in a `powershell "COMMAND HERE"`. For example, `powershell "irm asheroto.com/Get-SystemInfo | iex"`.

## Parameters

**No parameters are required** to run the script, but there are some optional parameters to use if needed.

| Parameter         | Description                                            |
| ----------------- | ------------------------------------------------------ |
| `-CheckForUpdate` | Checks if there is an update available for the script. |
| `-UpdateSelf`     | Updates the script to the latest version.              |
| `-Version`        | Displays the version of the script.                    |
| `-Help`           | Displays the full help information for the script.     |

## Output

Each section is clearly labeled, with key headers in green for easy reading. The output format provides a structured and intuitive way to review system information.

### Screenshots

![1](https://github.com/user-attachments/assets/6bbb1464-6fd4-42d6-8860-03ede4066865)
![2](https://github.com/user-attachments/assets/a58d7b0a-2c11-41cd-932f-6f087132a9d8)
![3](https://github.com/user-attachments/assets/9e4546df-b43c-4d70-a18b-6ce6d2173b03)