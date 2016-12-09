
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
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

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


    $website = $null # Get-Website -Name $EndpointName      # T O  D O

    if ($null -ne $website)
    {
        $Ensure = 'Present'

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

        # Get the IIS port from the binding information
        $Port = $website.Bindings.Collection[0].BindingInformation.Split(':')[1]
    }
    else
    {
        $Ensure = 'Absent'

        $Title       = ''
        $Description = ''

        $ModulePath          = ''
        $ConfigurationPath   = ''
        $DatabasePath        = ''
        $RegistrationKeyPath = ''

        $Port = 0
    }

    @{
        EndpointName        = $EndpointName
        Ensure              = $Ensure
        Port                = $Port
        Title               = $Title
        Description         = $Description
        PhysicalPath        = $website.physicalPath
        ModulePath          = $ModulePath
        ConfigurationPath   = $ConfigurationPath
        DatabasePath        = $DatabasePath
        RegistrationKeyPath = $RegistrationKeyPath
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
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

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
            $website = $null # Get-Website -Name $EndpointName      # T O  D O

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
        $Title = 'DSC Pull Server Web',

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description = 'Website with a REST API to manage the PowerShell DSC web pull server.',

        [Parameter(Mandatory = $false)]
        [System.String]
        $PhysicalPath = "$Env:SystemDrive\inetpub\$EndpointName",

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
}

function Get-TargetResourceDetail
{
}

Export-ModuleMember -Function *-TargetResource
