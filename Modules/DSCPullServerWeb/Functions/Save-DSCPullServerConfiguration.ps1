
<#
    .SYNOPSIS
    Save a MOF configuration from the DSC Pull Server to the local system.

    .DESCRIPTION
    The Save-DSCPullServerConfiguration cmdlet uses the Invoke-RestMethod to
    download an existing MOF configuration from the DSC Pull Server. The DSC
    Pull Server Web API must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> Save-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Name 'Demo' -Path '.\Demo.mof'
    Save the demo MOF configuration from the DSC Pull Server to the local
    system.

    .EXAMPLE
    PS C:\> Save-DSCPullServerConfiguration -Uri 'http://localhost:8081/api' -Name 'Demo' -Path '.\Demo.mof' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to save the demo MOF
    configuration.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Save-DSCPullServerConfiguration
{
    [CmdletBinding()]
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

        # The local path where the MOF configuration file is stored.
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
        Uri     = "$Uri/v1/configurations/$Name/download"
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

        Write-Error -Message "Unable to save the configuration: $_" -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
