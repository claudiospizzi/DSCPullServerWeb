
<#
    .SYNOPSIS
    Update a MOF configuration checksum on a DSC Pull Server.

    .DESCRIPTION
    The Update-DSCPullServerConfigurationChecksum cmdlet uses the
    Invoke-RestMethod to recalcualte the checksum file for an existing MOF
    configuration. The DSC Pull Server Web API must be deployed on the target
    DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Configuration.

    .EXAMPLE
    PS C:\> Update-DSCPullServerConfigurationChecksum -Uri 'http://localhost:8081/api' -Name 'Demo'
    Recalcualte the checksum of the Demo configuration.

    .EXAMPLE
    PS C:\> Update-DSCPullServerConfigurationChecksum -Uri 'http://localhost:8081/api' -Name 'Demo' -Credential 'DOMAIN\user'
    Recalcualte the checksum of the Demo configuration with alternative
    credentials.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Update-DSCPullServerConfigurationChecksum
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Use this parameter to specified the target MOF configuration name.
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
        Method = 'Patch'
        Uri    = "$Uri/v1/configurations/$Name/checksum"
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
        if ($PSCmdlet.ShouldProcess("Configuration: $Name", "Update Configuration Checksum"))
        {
            Update-SystemNetServicePointManager

            $configurations = Invoke-RestMethod @restMethodParam -ErrorAction Stop

            foreach ($configuration in $configurations)
            {
                $configuration.PSTypeNames.Insert(0, 'DSCPullServerWeb.Configuration')

                Write-Output $configuration
            }
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to update the configuration checksum.' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
