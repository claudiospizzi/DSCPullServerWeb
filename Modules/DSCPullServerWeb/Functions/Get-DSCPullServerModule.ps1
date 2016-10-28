
<#
    .SYNOPSIS
    

    .DESCRIPTION
    

    .INPUTS
    None.

    .OUTPUTS
    None.

    .EXAMPLE
    PS C:\> 


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
        # Base uri to the pull server
        [Parameter(Mandatory = $false)]
        [System.String]
        $Uri = 'http://localhost:35217/api'
    )

    Invoke-RestMethod -Method Get -Uri "$Uri/modules"
}
