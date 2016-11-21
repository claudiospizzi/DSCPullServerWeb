
Configuration PullServer
{
    Import-DscResource -ModuleName DSCPullServerWeb -ModuleVersion 1.0.0
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 5.0.0.0

    Node $AllNodes.Where{$_.Role -contains 'PullServer'}.NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = 'Present'
            Name   = 'DSC-Service'
        }

        foreach ($config in $ConfigurationData.PullServerConfig)
        {
            $name = $config.Name

            xDscWebService "DSCPullServer$name"
            {
                Ensure                   = 'Present'
                EndpointName             = "PSDSCPullServer$name"
                Port                     = $config.SvcPort
                PhysicalPath             = "$Env:SystemDrive\inetpub\PSDSCPullServer$name"
                CertificateThumbPrint    = ' '
                UseSecurityBestPractices = $true
                ModulePath               = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name\Modules"
                ConfigurationPath        = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name\Configuration"
                DatabasePath             = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name"
                RegistrationKeyPath      = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name"
                State                    = 'Started'

                DependsOn = @(
                    '[WindowsFeature]DSCServiceFeature'
                )
            }

            DscPullServerWeb "DSCPullServerWeb$name"
            {
                Ensure                = 'Present'
                EndpointName          = "PSDSCPullServerWeb$name"
                Port                  = $config.WebPort
                Title                 = "DSC Pull Server Web $name"
                Description           = "Web and API access to the $name DSC Pull Server."
                PhysicalPath          = "$Env:SystemDrive\inetpub\PSDSCPullServerWeb$name"
                ModulePath            = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name\Modules"
                ConfigurationPath     = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name\Configuration"
                DatabasePath          = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name"
                RegistrationKeyPath   = "$Env:ProgramFiles\WindowsPowerShell\DscServices\$name"

                DependsOn = @(
                    "[xDscWebService]DSCPullServer$name"
                )
            }
        }
    }
}

$configurationData = Import-PowerShellDataFile -Path "$PSScriptRoot\PullServer.psd1"

PullServer -ConfigurationData $configurationData
