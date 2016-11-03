
<#
    .SYNOPSIS
    Returns MOF configurations from a DSC Pull Server.

    .DESCRIPTION
    The Get-DSCPullServerConfiguration cmdlet uses the Invoke-RestMethod to get
    the MOF configurations from a DSC Pull Server. The DSC Pull Server Web API
    must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Configuration.

    .EXAMPLE
    PS C:\> Get-DSCPullServerConfiguration -Uri 'http://localhost:8081/api'
    Return all MOF configurations on the local DSC Pull Server instance.

    .EXAMPLE
    PS C:\> Get-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to return all MOF
    configurations.

    .EXAMPLE
    PS C:\> Get-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Name 'Demo'
    Return the MOF configuration with the name 'Demo' on the local DSC Pull
    Server instance.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Get-DSCPullServerConfiguration
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Use this parameter to filter for just one MOF configuration by name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $RestMethodParam = @{
        Method = 'Get'
        Uri    = "$Uri/configurations"
    }

    # If a name was specified, append it to the uri.
    if (-not [String]::IsNullOrEmpty($Name))
    {
        $RestMethodParam.Uri += "/$Name"
    }

    # Depending on the credential input, add the default or specfic credentials.
    if ($null -eq $Credential)
    {
        $RestMethodParam.UseDefaultCredentials = $true
    }
    else
    {
        $RestMethodParam.Credential = $Credential
    }

    $configurations = Invoke-RestMethod @RestMethodParam

    foreach ($configuration in $configurations)
    {
        $configuration.PSTypeNames.Insert(0, 'DSCPullServerWeb.Configuration')

        Write-Output $configuration
    }
}
