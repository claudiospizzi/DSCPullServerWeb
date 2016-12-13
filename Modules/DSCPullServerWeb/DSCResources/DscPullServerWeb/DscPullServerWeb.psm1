
#Import-Module "$PSScriptRoot\PSWSIISEndpoint.psm1" -Verbose:$false

[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSDSCDscTestsPresent', '')]
param()

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EndpointName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $ModulePath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules",

        [Parameter(Mandatory = $false)]
        [System.String]
        $ConfigurationPath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration",

        [Parameter(Mandatory = $false)]
        [System.String]
        $DatabasePath = "$Env:ProgramFiles\WindowsPowerShell\DscService",

        [Parameter(Mandatory = $false)]
        [System.String]
        $RegistrationKeyPath = "$Env:ProgramFiles\WindowsPowerShell\DscService"
    )


    Write-Verbose "Get current configuration for $EndpointName"


    $website = Get-Website -Name $EndpointName

    if ($null -ne $website)
    {
        $Ensure = 'Present'

        # Get the IIS port from the binding information and the physical path
        $Port         = $website.Bindings.Collection[0].BindingInformation.Split(':')[1]
        $PhysicalPath = $website.physicalPath

        # Get Full Path for web.config file
        $webConfigFullPath = Join-Path -Path $website.physicalPath -ChildPath 'web.config'

        # Get the title and description information
        $Title       = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'Title'
        $Description = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'Description'

        # Get module, configuration, database and registry key path from the web.config file
        $ModulePath          = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'ModulePath'
        $ConfigurationPath   = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'ConfigurationPath'
        $DatabasePath        = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'DatabasePath'
        $RegistrationKeyPath = Get-WebConfigAppSetting -WebConfigFullPath $webConfigFullPath -AppSettingName 'RegistrationKeyPath'
    }
    else
    {
        $Ensure              = 'Absent'
        $Port                = 0
        $Title               = ''
        $Description         = ''
        $PhysicalPath        = ''
        $ModulePath          = ''
        $ConfigurationPath   = ''
        $DatabasePath        = ''
        $RegistrationKeyPath = ''
    }

    @{
        EndpointName          = $EndpointName
        Ensure                = $Ensure
        Port                  = $Port
        PhysicalPath          = $PhysicalPath
        CertificateThumbPrint = $CertificateThumbPrint
        Title                 = $Title
        Description           = $Description
        ModulePath            = $ModulePath
        ConfigurationPath     = $ConfigurationPath
        DatabasePath          = $DatabasePath
        RegistrationKeyPath   = $RegistrationKeyPath
    }
}

function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([void])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EndpointName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $ModulePath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules",

        [Parameter(Mandatory = $false)]
        [System.String]
        $ConfigurationPath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration",

        [Parameter(Mandatory = $false)]
        [System.String]
        $DatabasePath = "$Env:ProgramFiles\WindowsPowerShell\DscService",

        [Parameter(Mandatory = $false)]
        [System.String]
        $RegistrationKeyPath = "$Env:ProgramFiles\WindowsPowerShell\DscService"
    )


    Write-Verbose "Set new configuration for $EndpointName"


    ## ABSENT: Remove existing website from the local system

    if ($Ensure -eq 'Absent')
    {
        if ($PSCmdlet.ShouldProcess($EndpointName, 'Remove'))
        {
            $website = Get-Website -Name $EndpointName

            if ($null -ne $website)
            {
                Write-Verbose "Removing website $EndpointName"

                # PSWSIISEndpoint\Remove-PSWSEndpoint -SiteName $EndpointName
                # ToDo: Remove Website
            }
        }
    }


    ## PRESENT: Add website to local system and update configuration

    if ($Ensure -eq 'Present')
    {
        if ($PSCmdlet.ShouldProcess($EndpointName, 'Add'))
        {
            $physicalPathSource = $PSScriptRoot | Split-Path | Split-Path | Join-Path -ChildPath 'Binaries\Website'


            # Create the physical path folder if it does not exist
            if (-not (Test-Path -Path $PhysicalPath))
            {
                Write-Verbose "Create website physical path $PhysicalPath"

                New-Item -Path $PhysicalPath -ItemType Directory -Force | Out-Null
            }


            # Copy the files to the target folder, if the folder versions are not equal
            if (-not (Test-WebsiteFile -Source $physicalPathSource -Destination $PhysicalPath))
            {
                Write-Verbose "Deploy website files to $PhysicalPath"

                # Try to stop the website and the app pool, in order to prevent file locks
                if (Test-Path -Path "IIS:\Sites\$EndpointName")    { Stop-Website -Name $EndpointName -ErrorAction SilentlyContinue }
                if (Test-Path -Path "IIS:\AppPools\$EndpointName") { Stop-WebAppPool -Name $EndpointName -ErrorAction SilentlyContinue }

                Get-ChildItem -Path $PhysicalPath -Recurse | Remove-Item -Force

                Copy-Item -Path "$physicalPathSource\*" -Destination $PhysicalPath -Recurse -Force
            }


            # Create the app pool if it does not exist
            if (-not (Test-Path -Path "IIS:\AppPools\$EndpointName"))
            {
                Write-Verbose "Create the app pool $PhysicalPath"

                New-WebAppPool -Name $EndpointName
            }


            # Change the app pool identity to local system
            if ((Get-Item -Path "IIS:\AppPools\$EndpointName").processModel.identityType -ne 'LocalSystem')
            {
                Write-Verbose 'Set the local system account as app pool identity'

                $appPool = Get-Item -Path "IIS:\AppPools\$EndpointName"
                $appPool.processModel.identityType = 'LocalSystem'
                $appPool | Set-Item
            }


            # Enable 32 bit applications on 64 bit operations systems
            if (-not (Get-Item -Path "IIS:\AppPools\$EndpointName").enable32BitAppOnWin64)
            {
                Write-Verbose "Enable the option enable32BitAppOnWin64"

                Set-itemProperty -Path "IIS:\AppPools\$EndpointName" -Name 'enable32BitAppOnWin64' -Value $true
            }


            # Create the website if it does not exist
            if (-not (Test-Path -Path "IIS:\Sites\$EndpointName"))
            {
                Write-Verbose 'Create a new IIS website'

                New-Website -Name $EndpointName -PhysicalPath $PhysicalPath -ApplicationPool $EndpointName -Port $Port -Ssl
            }


            # Check the certificate binding
            $binding = (Get-Item -Path "IIS:\Sites\$EndpointName").Bindings.Collection
            if ($binding.certificateHash -ne $CertificateThumbPrint)
            {
                Write-Verbose 'Update the SSL certificate'

                if (-not ([string]::IsNullOrEmpty($binding.certificateHash)))
                {
                    $binding.RemoveSslCertificate()
                }

                $binding.AddSslCertificate($CertificateThumbPrint, 'My')
            }


            # Set web.config values....
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $EndpointName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $ModulePath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Modules",

        [Parameter(Mandatory = $false)]
        [System.String]
        $ConfigurationPath = "$Env:ProgramFiles\WindowsPowerShell\DscService\Configuration",

        [Parameter(Mandatory = $false)]
        [System.String]
        $DatabasePath = "$Env:ProgramFiles\WindowsPowerShell\DscService",

        [Parameter(Mandatory = $false)]
        [System.String]
        $RegistrationKeyPath = "$Env:ProgramFiles\WindowsPowerShell\DscService"
    )


    Write-Verbose "Test current configuration of $EndpointName for desired state"


    # ToDo

    return $false
}

function Get-TargetResourceDetail
{
}

function Get-WebConfigAppSetting
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $WebConfigFullPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppSettingName
    )

    $appSettingValue = ''

    if ((Test-Path -Path $WebConfigFullPath))
    {
        $webConfigXml = [xml](Get-Content -Path $WebConfigFullPath)

        foreach ($item in $webConfigXml.configuration.appSettings.add)
        {
            if ($item.key -eq $AppSettingName)
            {
                $appSettingValue = $item.value
                break
            }
        }
    }

    $appSettingValue
}

function Test-WebsiteFile
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Destination
    )

    if (-not (Test-Path -Path "$Destination\bin\DSCPullServerWeb.dll"))
    {
        return $false
    }

    $sourceVersion      = (Get-Item -Path "$Source\bin\DSCPullServerWeb.dll").VersionInfo.FileVersion
    $destinationVersion = (Get-Item -Path "$Destination\bin\DSCPullServerWeb.dll").VersionInfo.FileVersion

    return ($sourceVersion -eq $destinationVersion)
}

Export-ModuleMember -Function *-TargetResource
