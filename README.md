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

**This is the recommended method, because it always gets the public release that has been tested, it's easy to remember, and supports all parameters.**

Open PowerShell as Administrator and type

```powershell
Install-Script Get-SystemInfo -Force
```

Follow the prompts to complete the installation (you can tap `A` to accept all prompts or `Y` to select them individually.

**Note:** `-Force` is optional but recommended, as it will force the script to update if it is outdated. If you do not use `-Force`, it will _not_ overwrite the script if outdated.

#### Usage

```powershell
Get-SystemInfo
```

The script is published on [PowerShell Gallery](https://www.powershellgallery.com/packages/Get-SystemInfo) under `Get-SystemInfo`.

---

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

---

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

## Screenshots

![1](https://github.com/user-attachments/assets/6bbb1464-6fd4-42d6-8860-03ede4066865)
![2](https://github.com/user-attachments/assets/a58d7b0a-2c11-41cd-932f-6f087132a9d8)
![3](https://github.com/user-attachments/assets/9e4546df-b43c-4d70-a18b-6ce6d2173b03)

## Community & Contributions

We value community contributions and encourage you to get involved. For issues, feature requests, or code contributions, please create a Pull Request.

- If you come across any issues, open a new issue on GitHub.
- To suggest new features, you can also submit an issue.
- If you wish to contribute code, we accept Pull Requests. Be sure to read our [contributing guidelines](https://github.com/asheroto/Get-SystemInfo/blob/main/CONTRIBUTING.md) for the required code style.

Detailed instructions on how to contribute can be found on the [contributing guidelines](https://github.com/asheroto/Get-SystemInfo/blob/main/CONTRIBUTING.md) page.

## Support

If you found this script helpful and want to show your appreciation, consider making a small donation to the developer. Your support is greatly appreciated and helps keep the coffee flowing, allowing me to continue working on other cool projects like this!

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=asheroto&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/asheroto)