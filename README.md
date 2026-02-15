# Office2024 Deployment Tool

This repository contains scripts and configuration files to automate the deployment of Microsoft Office 2024. It is designed to simplify the installation process for different locales and streamline the setup for end users or IT administrators.

## Features
- Automated Office 2024 installation for US and FR locales
- Pre-configured XML files for deployment customization
- Batch and PowerShell scripts for easy execution
- Download and data management for required Office CAB files

## Repository Structure
```
config-fr.xml         # French deployment configuration
config-us.xml         # US deployment configuration
download.bat          # Script to download required files
full.xml              # Full deployment configuration
gui.ps1               # PowerShell GUI for deployment
install-fr.bat        # Batch installer for French locale
install-us.bat        # Batch installer for US locale
links.txt             # Useful links and references
Office/Data/          # Directory containing Office CAB files
```

## Usage
1. **Download Required Files**
   - Run `download.bat` to fetch necessary Office CAB files into `Office/Data/`.

2. **Choose Locale and Install**
   - For US: Run `install-us.bat`
   - For French: Run `install-fr.bat`

3. **Custom Installation**
   - Edit the XML configuration files (`config-us.xml`, `config-fr.xml`, or `full.xml`) to customize your deployment.
   - Use `gui.ps1` for a graphical interface to assist with deployment.

## Requirements
- Windows OS
- Administrator privileges for installation
- Internet connection for downloading CAB files

## Notes
- Ensure all CAB files are present in `Office/Data/` before running the installer.
- Modify XML files as needed to match your organization's requirements.


## Useful Links

- [Official Deployment Instructions](https://learn.microsoft.com/en-us/office/ltsc/2024/deploy)
- [Download Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117)
- [Download full deployment zip (3.7GB)](https://1drv.ms/u/c/0a2fe9c7a6350f2a/IQD4zHlJpYPwTrNbDs803NfxAVFmKPdRRSJ_-3-uv4za4XE?e=7WTdhp)

## License
This project is provided as-is for internal or educational use. Please ensure compliance with Microsoft licensing for Office deployments.
