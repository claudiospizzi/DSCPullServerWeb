
Configuration DSCPullServerWithWeb
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $CertificateThumbPrint
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName xPSDesiredStateConfiguration -ModuleVersion 5.0.0.0
    Import-DscResource -ModuleName DSCPullServerWeb -ModuleVersion 1.0.2

    Node 'localhost'
    {
        WindowsFeature 'DSCServiceFeature'
        {
            Ensure = 'Present'
            Name   = 'DSC-Service'
        }

        File RegistrationKeyFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$Env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents        = '3e0cbed0-0b21-4e8e-874e-7577f9cda75f'
        }

        xDscWebService 'DSCPullServer'
        {
            State                    = 'Started'
            Ensure                   = 'Present'

            EndpointName             = 'PSDSCPullServer'
            Port                     = 8080

            PhysicalPath             = "$Env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint    = $CertificateThumbPrint
            UseSecurityBestPractices = $true

            ModulePath               = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath        = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            DatabasePath             = "$Env:ProgramFiles\WindowsPowerShell\DscService"
            RegistrationKeyPath      = "$Env:ProgramFiles\WindowsPowerShell\DscService"

            DependsOn = @(
                '[WindowsFeature]DSCServiceFeature'
            )
        }

        DscPullServerWeb 'DSCPullServerWeb'
        {
            Ensure                = 'Present'

            EndpointName          = 'PSDSCPullServerWeb'
            Port                  = 8090

            PhysicalPath          = "$Env:SystemDrive\inetpub\PSDSCPullServerWeb"
            CertificateThumbPrint = $CertificateThumbPrint

            Name                  = 'Default'
            Title                 = 'DSC Pull Server Web'
            Description           = 'Web and API access to the DSC Pull Server.'

            ModulePath            = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath     = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            DatabasePath          = "$Env:ProgramFiles\WindowsPowerShell\DscService"
            RegistrationKeyPath   = "$Env:ProgramFiles\WindowsPowerShell\DscService"

            DependsOn = @(
                "[xDscWebService]DSCPullServer"
            )
        }
    }
}

# Compile the configuration for the localhost node. Update the certificate
# thumbprint to match your SSL certificate on the target system!
DSCPullServerWithWeb -OutputPath '.\DSCPullServerWithWeb' -CertificateThumbPrint '1234567890ABCDEF1234567890ABCDEF12345678'

# Invoke the configuration and setup the DSC Pull Server with the web extension.
Start-DscConfiguration -Path '.\DSCPullServerWithWeb' -Wait -Force -Verbose
