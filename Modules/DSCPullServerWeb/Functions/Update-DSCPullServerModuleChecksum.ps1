
<#
    .SYNOPSIS
    Update a PowerShell module checksum on a DSC Pull Server.

    .DESCRIPTION
    The Update-DSCPullServerModuleChecksum cmdlet uses the Invoke-RestMethod to
    recalcualte the checksum file for an existing PowerShell module. The DSC
    Pull Server Web API must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Module.

    .EXAMPLE
    PS C:\> Update-DSCPullServerModuleChecksum -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0'
    Recalcualte the checksum of the Demo module version 1.0.

    .EXAMPLE
    PS C:\> Update-DSCPullServerModuleChecksum -Uri 'http://localhost:8081/api' -Name 'Demo' -Version '1.0' -Credential 'DOMAIN\user'
    Recalcualte the checksum of the Demo module version 1.0 with alternative
    credentials.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Update-DSCPullServerModuleChecksum
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Use this parameter to specified the target PowerShell module name.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        # Use this parameter to specified the target PowerShell module version.
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
        Method = 'Get'
        Uri    = "$Uri/v1/modules/$Name/$Version/hash"
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
        if ($PSCmdlet.ShouldProcess("Module: $Name, Version: $Version", "Update Module Checksum"))
        {
            $modules = Invoke-RestMethod @restMethodParam -ErrorAction Stop

            foreach ($module in $modules)
            {
                $module.PSTypeNames.Insert(0, 'DSCPullServerWeb.Module')

                Write-Output $module
            }
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to update the module checksum.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
