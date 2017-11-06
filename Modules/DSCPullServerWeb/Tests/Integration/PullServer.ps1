
Configuration PullServerCfg
{
    # Import-DscResource -ModuleName DSCPullServerWeb -ModuleVersion 1.0.0
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 5.0.0.0

    Node $AllNodes.Where{$_.Role -contains 'PullServer'}.NodeName
    {
        WindowsFeature 'DSCServiceFeature'
        {
            Ensure = 'Present'
            Name   = 'DSC-Service'
        }

        WindowsFeature 'IISMgmtConsoleFeature'
        {
            Ensure = 'Present'
            Name   = 'Web-Mgmt-Console'
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$Env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = $Node.RegistrationKey
        }

        xDscWebService 'DSCPullServer'
        {
            Ensure                   = 'Present'
            EndpointName             = 'PSDSCPullServer'
            Port                     = 8080
            PhysicalPath             = "$Env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint    = $Node.CertificateThumbPrint
            UseSecurityBestPractices = $true
            ModulePath               = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath        = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            DatabasePath             = "$Env:ProgramFiles\WindowsPowerShell\DscService\"
            RegistrationKeyPath      = "$Env:ProgramFiles\WindowsPowerShell\DscService\"
            State                    = 'Started'

            DependsOn = @(
                '[WindowsFeature]DSCServiceFeature'
            )
        }

            # DscPullServerWeb "DSCPullServerWeb$name"
            # {
            #     Ensure                = 'Present'
            #     EndpointName          = "PSDSCPullServerWeb$name"
            #     Port                  = $config.WebPort
            #     Name                  = $name
            #     Title                 = "DSC Pull Server Web $name"
            #     Description           = "Web and API access to the $name DSC Pull Server."
            #     PhysicalPath          = "$Env:SystemDrive\inetpub\PSDSCPullServerWeb$name"
            #     ModulePath            = "$Env:ProgramFiles\WindowsPowerShell\DscService\$name\Modules"
            #     ConfigurationPath     = "$Env:ProgramFiles\WindowsPowerShell\DscService\$name\Configuration"
            #     DatabasePath          = "$Env:ProgramFiles\WindowsPowerShell\DscService\$name"
            #     RegistrationKeyPath   = "$Env:ProgramFiles\WindowsPowerShell\DscService\$name"

            #     DependsOn = @(
            #         "[xDscWebService]DSCPullServer$name"
            #     )
            # }
    }
}

[DSCLocalConfigurationManager()]
Configuration PullServerLcm
{
    Node $AllNodes.Where{$_.Role -contains 'NodeLcm'}.NodeName
    {
        Settings
        {
            RefreshMode = 'Pull'

            ConfigurationID = $Node.ConfigurationId
        }

        ConfigurationRepositoryWeb ConfigurationRepository
        {
            ServerURL       = $Node.PullServerUrl
            RegistrationKey = $Node.RegistrationKey

            ConfigurationNames = $Node.ConfigurationNames
        }

        ResourceRepositoryWeb ResourceRepository
        {
            ServerURL       = $Node.PullServerUrl
            RegistrationKey = $Node.RegistrationKey
        }

        ReportServerWeb ReportServer
        {
            ServerURL       = $Node.PullServerUrl
            RegistrationKey = $Node.RegistrationKey
        }
    }
}

$configurationData = Import-PowerShellDataFile -Path "$PSScriptRoot\PullServer.psd1"

PullServerCfg -ConfigurationData $configurationData -OutputPath "$PSScriptRoot\PullServer"

PullServerLcm -ConfigurationData $configurationData -OutputPath "$PSScriptRoot\PullServer"

Start-DscConfiguration -Path "$PSScriptRoot\PullServer" -Wait -Force -Verbose

Set-DscLocalConfigurationManager -Path "$PSScriptRoot\PullServer" -Force -Verbose
