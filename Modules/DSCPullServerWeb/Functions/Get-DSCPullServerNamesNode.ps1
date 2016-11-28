
<#
    .SYNOPSIS
    Returns all ConfigurationNames nodes from a DSC Pull Server.

    .DESCRIPTION
    The Get-DSCPullServerNamesNode cmdlet uses the Invoke-RestMethod to get the
    ConfigurationNames nodes from a DSC Pull Server. The DSC Pull Server Web API
    must be deployed on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.NamesNode.

    .EXAMPLE
    PS C:\> Get-DSCPullServerNamesNode -Uri 'http://localhost:8081/api'
    Return all ConfigurationNames nodes on the local DSC Pull Server instance.

    .EXAMPLE
    PS C:\> Get-DSCPullServerNamesNode -Uri 'http://localhost:8081/api' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to return all
    ConfigurationNames nodes.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Get-DSCPullServerNamesNode
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        # Base uri to the DSC Pull Server including the relative '/api' path.
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        # Optionally specify credentials for the request.
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    # Use splatting to prepare the parameters.
    $restMethodParam = @{
        Method = 'Get'
        Uri    = "$Uri/v1/nodes/names"
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
        $nodes = Invoke-RestMethod @restMethodParam -ErrorAction Stop

        foreach ($node in $nodes)
        {
            $node.PSTypeNames.Insert(0, 'DSCPullServerWeb.NamesNode')

            Write-Output $node
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to get the ConfigurationNames node(s).' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
