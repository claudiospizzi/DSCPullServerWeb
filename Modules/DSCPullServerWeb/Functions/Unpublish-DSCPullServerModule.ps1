
<#
    .SYNOPSIS
    Unpublish an existing PowerShell module from a DSC Pull Server.

    .DESCRIPTION
    The Unpublish-DSCPullServerModule cmdlet uses the Invoke-RestMethod
    to remove a PowerShell module from the DSC Pull Server. The DSC Pull Server
    Web API must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Unpublish-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0'
    Unpublish the demo PowerShell module from the DSC Pull Server.

    .EXAMPLE
    PS C:\> Unpublish-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to unpublish the demo
    PowerShell module.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Unpublish-DSCPullServerModule
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # The name for the module.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # The version for the module.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Version,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $restMethodParam = @{
        Method = 'Delete'
        Uri    = "$Uri/modules/$Name/$Version"
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
        if ($PSCmdlet.ShouldProcess("Module: $Name, Version: $Version", "Unpublish Module (remove it from the pull server)"))
        {
            Invoke-RestMethod @restMethodParam -ErrorAction Stop
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to unpublish the module.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
