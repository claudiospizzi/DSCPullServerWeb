
<#
    .SYNOPSIS
    Publish a PowerShell module to a DSC Pull Server.

    .DESCRIPTION
    The Publish-DSCPullServerModule cmdlet uses the Invoke-RestMethod to upload
    the PowerShell module to the DSC Pull Server. The DSC Pull Server Web API
    must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Module.

    .EXAMPLE
    PS C:\> Publish-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0' -Path '.\Demo.zip'
    Publish the demo PowerShell module to the DSC Pull Server.

    .EXAMPLE
    PS C:\> Publish-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0.0.0' -Path '.\Demo.zip' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to return publish a demo PowerShell
    module.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Publish-DSCPullServerModule
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

        # The local path if the PowerShell module file.
        [Parameter(Mandatory = $true)]
        [ValidateScript({Test-Path -Path $_})]
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
        Method = 'Put'
        Uri    = "$Uri/v1/modules/$Name/$Version"
        InFile = $Path
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
        if ($PSCmdlet.ShouldProcess("Module: $Name, Version: $Version", "Publish Module (replace, if the module already exists on the pull server)"))
        {
            Update-SystemNetServicePointManager

            $module = Invoke-RestMethod @restMethodParam -ErrorAction Stop

            $module.PSTypeNames.Insert(0, 'DSCPullServerWeb.Module')

            Write-Output $module
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to publish the configuration.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
