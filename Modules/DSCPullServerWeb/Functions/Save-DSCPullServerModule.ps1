
<#
    .SYNOPSIS
    Save a PowerShell module from the DSC Pull Server to the local system.

    .DESCRIPTION
    The Save-DSCPullServerModule cmdlet uses the Invoke-RestMethod to
    download an existing PowerShell module from the DSC Pull Server. The DSC
    Pull Server Web API must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Save-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0' -Path '.\Demo.zip'
    Save the demo PowerShell module from the DSC Pull Server to the local
    system.

    .EXAMPLE
    PS C:\> Save-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0' -Path '.\Demo.zip' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to save the demo PowerShell
    module.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Save-DSCPullServerModule
{
    [CmdletBinding()]
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

        # The local path where the PowerShell module file is stored.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $restMethodParam = @{
        Method  = 'Get'
        Uri     = "$Uri/v1/modules/$Name/$Version/download"
        OutFile = $Path
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
        Update-SystemNetServicePointManager

        Invoke-RestMethod @restMethodParam -ErrorAction Stop
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to save the module.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
