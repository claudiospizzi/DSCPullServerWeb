[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/DSCPullServerWeb/master.svg)](https://ci.appveyor.com/project/claudiospizzi/DSCPullServerWeb/branch/master)
[![AppVeyor - dev](https://img.shields.io/appveyor/ci/claudiospizzi/DSCPullServerWeb/dev.svg)](https://ci.appveyor.com/project/claudiospizzi/DSCPullServerWeb/branch/dev)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/DSCPullServerWeb.svg)](https://github.com/claudiospizzi/DSCPullServerWeb/releases)
[![PowerShell Gallery - DSCPullServerWeb](https://img.shields.io/badge/PowerShell_Gallery-DSCPullServerWeb-0072C6.svg)](https://www.powershellgallery.com/packages/DSCPullServerWeb)


# DSCPullServerWeb PowerShell Module

WebAPI and website to manage the DSC pull server artifacts nodes, modules and
configurations.

![DSC Pull Server Web](https://raw.githubusercontent.com/claudiospizzi/DSCPullServerWeb/dev/screenshot.png)


## Introduction

tbd


## Requirements

tbd


## Installation

With PowerShell 5.0, the new [PowerShell Gallery] was introduced. Additionally,
the new module [PowerShellGet] was added to the default WMF 5.0 installation.
With the cmdlet `Install-Module`, a published module from the PowerShell Gallery
can be downloaded and installed directly within the PowerShell host, optionally
with the scope definition:

```powershell
Install-Module DSCPullServerWeb [-Scope {CurrentUser | AllUsers}]
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]


## Features

* **Get-DSCPullServerConfiguration**  
  Returns MOF configurations from a DSC Pull Server.

* **Save-DSCPullServerConfiguration**  
  Save a MOF configuration from the DSC Pull Server to the local system.

* **Publish-DSCPullServerConfiguration**  
  Publish a MOF configuration to a DSC Pull Server.

* **Unpublish-DSCPullServerConfiguration**  
  Unpublish an existing MOF configuration from a DSC Pull Server.

* **Update-DSCPullServerConfigurationChecksum**  
  Update a MOF configuration checksum on a DSC Pull Server.

* **Get-DSCPullServerModule**  
  Returns PowerShell modules from a DSC Pull Server.

* **Save-DSCPullServerModule**  
  Save a PowerShell module from the DSC Pull Server to the local system.

* **Publish-DSCPullServerModule**  
  Publish a PowerShell module to a DSC Pull Server.

* **Unpublish-DSCPullServerModule**  
  Unpublish an existing PowerShell module from a DSC Pull Server.

* **Update-DSCPullServerModuleChecksum**  
  Update a PowerShell module checksum on a DSC Pull Server.


## Versions

### Unreleased

* tbd


## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code]
* [PowerShell Extension]

This module is tested with the PowerShell testing framework Pester. To run all
tests, just start the included test script `.\Scripts\test.ps1` or invoke Pester
directly with the `Invoke-Pester` cmdlet. The tests will automatically download
the latest meta test from the claudiospizzi/PowerShellModuleBase repository.

To debug the module, just copy the existing `.\Scripts\debug.default.ps1` file
to `.\Scripts\debug.ps1`, which is ignored by git. Now add the command to the
debug file and start it.



[PowerShell Gallery]: https://www.powershellgallery.com/packages/DSCPullServerWeb
[PowerShellGet]: https://technet.microsoft.com/en-us/library/dn807169.aspx

[GitHub Releases]: https://github.com/claudiospizzi/DSCPullServerWeb/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
