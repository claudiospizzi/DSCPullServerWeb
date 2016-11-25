
<#
    .SYNOPSIS
    Returns PowerShell modules from a DSC Pull Server.

    .DESCRIPTION
    The Get-DSCPullServerModule cmdlet uses the Invoke-RestMethod to get the
    PowerShell modules from a DSC Pull Server. The DSC Pull Server Web API must
    be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Module.

    .EXAMPLE
    PS C:\> Get-DSCPullServerModule -Uri 'http://localhost:8081/api'
    Return all PowerShell modules on the local DSC Pull Server instance.

    .EXAMPLE
    PS C:\> Get-DSCPullServerModule -Uri 'http://localhost:8081/api' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to return all PowerShell
    modules.

    .EXAMPLE
    PS C:\> Get-DSCPullServerModule -Uri 'http://localhost:8081/api' -Name 'Demo'
    Return the PowerShell module with the name 'Demo' on the local DSC Pull
    Server instance.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Get-DSCPullServerModule
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Use this parameter to filter the PowerShell modules by name.
        [Parameter(Mandatory = $false)]
        [System.String]
        $Name,

        # Use this parameter to filter for just one PowerShell module by name
        # and by version. This parameter is ignored if no name is specified.
        [Parameter(Mandatory = $false)]
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
        Method = 'Get'
        Uri    = "$Uri/modules"
    }

    # If a name was specified, append it to the uri and check if also a version
    # was specified. The version will be ignored if no name was specified.
    if (-not [String]::IsNullOrEmpty($Name))
    {
        $restMethodParam.Uri += "/$Name"

        if (-not [String]::IsNullOrEmpty($Version))
        {
            $restMethodParam.Uri += "/$Version"
        }
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
        $modules = Invoke-RestMethod @restMethodParam -ErrorAction Stop

        foreach ($module in $modules)
        {
            $module.Created = [DateTime] $module.Created

            $module.PSTypeNames.Insert(0, 'DSCPullServerWeb.Module')

            Write-Output $module
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to get the module(s).' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
