
<#
    .SYNOPSIS
    Unpublish an existing MOF configuration from a DSC Pull Server.

    .DESCRIPTION
    The Unpublish-DSCPullServerConfiguration cmdlet uses the Invoke-RestMethod
    to remove a MOF configuration from the DSC Pull Server. The DSC Pull Server
    Web API must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Unpublish-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Name 'Demo'
    Unpublish the demo MOF configuration from the DSC Pull Server.

    .EXAMPLE
    PS C:\> Unpublish-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Name 'Demo' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to unpublish the demo MOF
    configuration.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Unpublish-DSCPullServerConfiguration
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # The name for the configuration.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $restMethodParam = @{
        Method = 'Delete'
        Uri    = "$Uri/v1/configurations/$Name"
    }

    # Depending on the credential input, add the default or specfic credentials.
    if ($null -eq $Credential)
    {
        $restMethodParam.UseDefaultCredentials = $true
    }
    else
    {
        $restMethodParam.Credential = $Credential
    }

    try
    {
        if ($PSCmdlet.ShouldProcess("Configuration: $Name", "Unpublish Configuration (remove it from the pull server)"))
        {
            Update-SystemNetServicePointManager

            Invoke-RestMethod @restMethodParam -ErrorAction Stop
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to unpublish get the configuration.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
