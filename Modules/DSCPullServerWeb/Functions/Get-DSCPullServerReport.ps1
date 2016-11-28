
<#
    .SYNOPSIS
    Returns all reports from a DSC Pull Server.

    .DESCRIPTION
    The Get-DSCPullServerReport cmdlet uses the Invoke-RestMethod to get the
    reports from a DSC Pull Server. The DSC Pull Server Web API must be deployed
    on the target DSC Pull Server.

    .INPUTS
    None.

    .OUTPUTS
    DSCPullServerWeb.Report.

    .EXAMPLE
    PS C:\> Get-DSCPullServerReport -Uri 'http://localhost:8081/api'
    Return all reports on the local DSC Pull Server instance.

    .EXAMPLE
    PS C:\> Get-DSCPullServerReport -Uri 'http://localhost:8081/api' -Credential 'DOMAIN\user'
    Invoke the cmdlet with alternative credentials to return all reports.

    .NOTES
    Author     : Claudio Spizzi
    License    : MIT License

    .LINK
    https://github.com/claudiospizzi/DSCPullServerWeb
#>

function Get-DSCPullServerReport
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
        Uri    = "$Uri/reports"
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
            $node.StartTime        = [DateTime] $node.StartTime
            $node.EndTime          = [DateTime] $node.EndTime
            $node.LastModifiedTime = [DateTime] $node.LastModifiedTime

            $node.PSTypeNames.Insert(0, 'DSCPullServerWeb.Report')

            Write-Output $node
        }
    }
    catch
    {
        $target = $restMethodParam.Method.ToUpper() + ' ' + $restMethodParam.Uri

        Write-Error -Message 'Unable to get the report(s).' -Exception $_.Exception -Category ConnectionError -TargetObject $target
    }
}
