@{
    RootModule           = 'DSCPullServerWeb.psm1'
    ModuleVersion        = '0.0.0'
    GUID                 = 'B9449D06-0A81-4743-B9A1-33A2D2082DE4'
    Author               = 'Claudio Spizzi'
    Copyright            = 'Copyright (c) 2016 by Claudio Spizzi. Licensed under MIT license.'
    Description          = 'Website with a REST API to manage the PowerShell DSC pull server.'
    PowerShellVersion    = '4.0'
    RequiredModules      = @()
    ScriptsToProcess     = @()
    TypesToProcess       = @(
        'Resources\DSCPullServerWeb.Types.ps1xml'
    )
    FormatsToProcess     = @(
        'Resources\DSCPullServerWeb.Formats.ps1xml'
    )
    FunctionsToExport    = @(
        'Get-DSCPullServerConfiguration'
        'Get-DSCPullServerModule'
        'Publish-DSCPullServerConfiguration'
        'Publish-DSCPullServerModule'
        'Unpublish-DSCPullServerConfiguration'
        'Unpublish-DSCPullServerModule'
        'Save-DSCPullServerConfiguration'
        'Save-DSCPullServerModule'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
    DscResourcesToExport = @(
    )
    PrivateData          = @{
        PSData               = @{
            Tags                 = @('PSModule', 'DSC', 'DSCResource', 'PullServer')
            LicenseUri           = 'https://raw.githubusercontent.com/claudiospizzi/DSCPullServerWeb/master/LICENSE'
            ProjectUri           = 'https://github.com/claudiospizzi/DSCPullServerWeb'
        }
    }
}
