
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
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

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


    if (Test-Path -Path "IIS:\Sites\$EndpointName")
    {
        Write-Verbose "Website $EndpointName found, DscPullServerWeb is present."

        $Ensure = 'Present'

        # Get Website and the full path for web.config file
        $websiteItem   = Get-Item -Path "IIS:\Sites\$EndpointName"
        $webConfigPath = Join-Path -Path $website.physicalPath -ChildPath 'web.config'

        # Get the IIS port from the binding information and the physical path
        $PhysicalPath          = $websiteItem.physicalPath
        $Port                  = $websiteItem.Bindings.Collection[0].BindingInformation.Split(':')[1]
        $CertificateThumbPrint = $websiteItem.Bindings.Collection[0].CertificateHash

        # Get the title and description information
        $Name        = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Name'
        $Title       = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Title'
        $Description = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Description'

        # Get module, configuration, database and registry key path from the web.config file
        $ModulePath          = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ModulePath'
        $ConfigurationPath   = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ConfigurationPath'
        $DatabasePath        = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'DatabasePath'
        $RegistrationKeyPath = Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'RegistrationKeyPath'
    }
    else
    {
        Write-Verbose "Website $EndpointName not found, DscPullServerWeb is absent."

        $Ensure              = 'Absent'
        $PhysicalPath        = ''
        $Port                = 0
        $Name                = ''
        $Title               = ''
        $Description         = ''
        $ModulePath          = ''
        $ConfigurationPath   = ''
        $DatabasePath        = ''
        $RegistrationKeyPath = ''
    }

    return @{
        EndpointName          = $EndpointName
        Ensure                = $Ensure
        PhysicalPath          = $PhysicalPath
        Port                  = $Port
        CertificateThumbPrint = $CertificateThumbPrint
        Name                  = $Name
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
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

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
            $webConfigPath = Join-Path -Path $PhysicalPath -ChildPath 'web.config'

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


            # Check and update the certificate binding
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


            # Check name, title and description configurations
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Name') -ne $Name)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Name' -AppSettingValue $Name
            }
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Title') -ne $Title)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Title' -AppSettingValue $Title
            }
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Description') -ne $Description)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'Description' -AppSettingValue $Description
            }


            # Check path configurations
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ModulePath') -ne $ModulePath)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ModulePath' -AppSettingValue $ModulePath
            }
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ConfigurationPath') -ne $ConfigurationPath)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'ConfigurationPath' -AppSettingValue $ConfigurationPath
            }
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'DatabasePath') -ne $DatabasePath)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'DatabasePath' -AppSettingValue $DatabasePath
            }
            if ((Get-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'RegistrationKeyPath') -ne $RegistrationKeyPath)
            {
                Set-WebConfigAppSetting -Path $webConfigPath -AppSettingName 'RegistrationKeyPath' -AppSettingValue $RegistrationKeyPath
            }


            # Start
            Start-Website -Name $EndpointName -ErrorAction SilentlyContinue
            Start-WebAppPool -Name $EndpointName -ErrorAction SilentlyContinue
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
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

        [Parameter(Mandatory = $false)]
        [System.UInt32]
        $Port = 8090,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbPrint,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Name = 'Default',

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


    # Get the current configuration

    $current = Get-TargetResource @PSBoundParameters


    # Verify in case the desired state is absent

    if (($Ensure -eq 'Absent') -and
        ($Ensure -eq $current.Ensure))
    {
        return $true
    }


    # Verify in case the desired state is present

    if (($Ensure                -eq 'Present') -and
        ($Ensure                -eq $current.Ensure) -and
        ($PhysicalPath          -eq $current.PhysicalPath) -and
        ($Port                  -eq $current.Port) -and
        ($CertificateThumbPrint -eq $current.CertificateThumbPrint) -and
        ($Name                  -eq $current.Name) -and
        ($Title                 -eq $current.Title) -and
        ($Description           -eq $current.Description) -and
        ($ModulePath            -eq $current.ModulePath) -and
        ($ConfigurationPath     -eq $current.ConfigurationPath) -and
        ($DatabasePath          -eq $current.DatabasePath) -and
        ($RegistrationKeyPath   -eq $current.RegistrationKeyPath))
    {
        return $true
    }

    return $false
}

function Get-WebConfigAppSetting
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppSettingName
    )

    $appSettingValue = ''

    if ((Test-Path -Path $Path))
    {
        $webConfigXml = [xml](Get-Content -Path $Path)

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

function Set-WebConfigAppSetting
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppSettingName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AppSettingValue
    )

    if ((Test-Path -Path $Path))
    {
        if ($PSCmdlet.ShouldProcess($Path, "Update $AppSettingName"))
        {
            $webConfigXml = [xml](Get-Content -Path $Path)

            foreach ($item in $webConfigXml.configuration.appSettings.add)
            {
                if ($item.key -eq $AppSettingName)
                {
                    $item.value = $AppSettingValue
                }
            }

            $webConfigXml.Save($Path)
        }
    }
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
