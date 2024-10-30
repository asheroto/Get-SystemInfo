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

## Usage

To execute the script, save it to a `.ps1` file and run it in PowerShell. Compatible with Windows 10 and Windows 11.

### Example Command

```powershell
.\Get-SystemInfo.ps1
```

## Output

Each section is clearly labeled, with key headers in green for easy reading. The output format provides a structured and intuitive way to review system information.

### Screenshots



## Requirements

- **PowerShell 5.1** or higher (pre-installed on Windows 10 and 11)
- **Supported OS**: Windows 10, Windows 11, Server 2018, Server 2022