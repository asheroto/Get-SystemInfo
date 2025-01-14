[![Release](https://img.shields.io/github/v/release/asheroto/Get-SystemInfo)](https://github.com/asheroto/Get-SystemInfo/releases)
[![GitHub Release Date - Published_At](https://img.shields.io/github/release-date/asheroto/Get-SystemInfo)](https://github.com/asheroto/Get-SystemInfo/releases)
[![GitHub Downloads - All Releases](https://img.shields.io/github/downloads/asheroto/Get-SystemInfo/total)](https://github.com/asheroto/Get-SystemInfo/releases)
[![GitHub Sponsor](https://img.shields.io/github/sponsors/asheroto?label=Sponsor&logo=GitHub)](https://github.com/sponsors/asheroto?frequency=one-time&sponsor=asheroto)
<a href="https://ko-fi.com/asheroto"><img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Ko-Fi Button" height="20px"></a>
<a href="https://www.buymeacoffee.com/asheroto"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=Get-SystemInfo&button_colour=FFDD00&font_colour=000000&font_family=Lato&outline_colour=000000&coffee_colour=ffffff)" height="40px"></a>

# Get-SystemInfo

![1](https://github.com/user-attachments/assets/6bbb1464-6fd4-42d6-8860-03ede4066865)

This PowerShell script provides information on system configuration, hardware specifications, network details, operating system status, and more. It is particularly useful for IT professionals and support staff who need rapid insight into system specs and performance.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Features](#features)
  - [Script Capabilities](#script-capabilities)
  - [Diagnostics Information Gathered](#diagnostics-information-gathered)
- [Requirements](#requirements)
- [Getting Started / Install / Download](#getting-started--install--download)
  - [Method 1 - PowerShell Gallery](#method-1---powershell-gallery)
    - [Usage](#usage)
  - [Method 2 - One Line Command (Runs Immediately)](#method-2---one-line-command-runs-immediately)
    - [Option A: asheroto.com short URL](#option-a-asherotocom-short-url)
    - [Option B: direct release URL](#option-b-direct-release-url)
  - [Method 3 - Download Locally and Run](#method-3---download-locally-and-run)
- [Parameters](#parameters)
- [Usage](#usage-1)
- [Using the Get-SystemInfo Object](#using-the-get-systeminfo-object)
  - [`Get-SystemInfo` Object Properties](#get-systeminfo-object-properties)
  - [Examples](#examples)
- [Additional Screenshots](#additional-screenshots)
- [Community \& Contributions](#community--contributions)
- [Support](#support)

## Features

### Script Capabilities
- **Dual Output Modes**: Supports both console output for quick diagnostics and object-based output for programmatic access and integration into other scripts.
- **PowerShell Gallery Support**: Install and run the script directly as a function using `Get-SystemInfo` for streamlined usage.

### Diagnostics Information Gathered
- **System Information**: Retrieves hostname, OS version and architecture, display version, installation date, last boot time, and uptime.
- **Hardware and Firmware Details**: Shows the make and model of the computer, firmware manufacturer, version, and serial number.
- **TPM Information**: Displays TPM activation status, enabled state, ownership status, and version.
- **CPU Details**: Provides CPU model, speed, usage, core count, and logical processor count.
- **Memory Details**: Displays total, used, and free RAM along with memory usage percentage. Additionally, lists details for each DIMM slot, including slot identifier, controller, size, and model/part number.
- **Disk Usage**: For each drive, displays the device ID, volume label, total size, free space, used space, usage percentage, and model of the physical disk.
- **Graphics Card Information**: Displays GPU details, including the name, adapter RAM (GB), driver version, driver date, and status.
- **Network Adapter Details**: Shows network adapter information, including adapter name, MAC address, IP address, subnet mask, and default gateway.
- **Pending Reboot Check**: Detects pending reboots due to Windows Update, Component-Based Servicing, pending file rename operations, or cluster reboots.
- **Last Shutdown Events**: Lists the five most recent system shutdown events for diagnostic purposes.

## Requirements

- **PowerShell 5.1** or higher (pre-installed on Windows 10 and 11)
- **Supported OS**: Windows 10, Windows 11, Server 2018, Server 2022

## Getting Started / Install / Download

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

#### Option A: asheroto.com short URL

```powershell
irm asheroto.com/Get-SystemInfo | iex
```

#### Option B: direct release URL

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

| Parameter         | Description                                                        |
| ----------------- | ------------------------------------------------------------------ |
| `-CheckForUpdate` | Checks if there is an update available for the script.             |
| `-UpdateSelf`     | Updates the script to the latest version.                          |
| `-Version`        | Displays the version of the script.                                |
| `-Help`           | Displays the full help information for the script.                 |
| `-Silent`         | Suppresses output when the script is run, useful for dot-sourcing. |

## Usage

You can use the script in two ways:

1. **Run the Script Directly**  
   If you’ve installed the script from the PowerShell Gallery, you can simply run the `Get-SystemInfo` command:
```powershell
Get-SystemInfo
```
This will display all system diagnostics, including hardware details, OS version, disk usage, and more, directly to the console.

If you’re using the script file itself, execute it directly:
```powershell
.\Get-SystemInfo.ps1
```
2.  **Call the `Get-SystemInfo` Function**

To work with the diagnostics programmatically, retrieve them as an object. If installed via the PowerShell Gallery, you can call the function directly:

```powershell

$info = Get-SystemInfo -Silent

```

Alternatively, if you have the script file, dot-source it to access the `Get-SystemInfo` function:

```powershell

. .\Get-SystemInfo.ps1 -Silent

$info = Get-SystemInfo

```

This method allows access to specific sections of the diagnostics and integration into other scripts. See the next section for details.

## Using the Get-SystemInfo Object

When invoked programmatically, the script returns all diagnostic information as a structured object, allowing for seamless access and manipulation. Specific sections of the diagnostics can be retrieved by accessing the corresponding properties of the object.

### `Get-SystemInfo` Object Properties
| Property          | Description                                                                              |
| ----------------- | ---------------------------------------------------------------------------------------- |
| `System`          | General system information, such as hostname.                                            |
| `Hardware`        | Details about the system's make, model, serial number, and firmware.                     |
| `TPM`             | Trusted Platform Module (TPM) status and version.                                        |
| `OS`              | Operating system information, including version, architecture, install date, and uptime. |
| `CPU`             | Processor details, including model, speed, usage, and core/thread count.                 |
| `Memory`          | Memory details, including total, used, and per-DIMM slot information.                    |
| `Disks`           | Information about logical disks, including size, free space, and usage.                  |
| `Graphics`        | Graphics card details, including name, RAM, and driver information.                      |
| `NetworkAdapters` | Network adapter details, including MAC address, IP, and speed.                           |
| `PendingReboot`   | Information on pending reboots due to updates or other operations.                       |
| `ShutdownEvents`  | Details of the last system shutdown events.                                              |

### Examples

- **OS Information**:
```powershell
$info.OS
```
![image](https://github.com/user-attachments/assets/652017d0-da7a-4844-8aeb-8ad4ce102d59)
- **CPU Information**:
```powershell
$info.CPU
```
![image](https://github.com/user-attachments/assets/7b10939e-bb39-4654-9f2b-379eb0b79e51)
- **Memory Details**:
```powershell
$info.Memory
```
![image](https://github.com/user-attachments/assets/ea169875-c86e-4f2f-aca0-7b5026e3c110)

## Additional Screenshots

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