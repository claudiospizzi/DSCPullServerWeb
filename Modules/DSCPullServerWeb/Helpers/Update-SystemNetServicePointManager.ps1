
function Update-SystemNetServicePointManager
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    param ()

    if ($PSCmdlet.ShouldProcess("System.Net.ServicePointManager", "Update SecurityProtocol to support Ssl3, Tls, Tls11, Tls12"))
    {
        try
        {
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Ssl3 -bor
                                                                 [System.Net.SecurityProtocolType]::Tls -bor
                                                                 [System.Net.SecurityProtocolType]::Tls11 -bor
                                                                 [System.Net.SecurityProtocolType]::Tls12
        }
        catch
        {
            Write-Warning 'Unable to activate all security protocols: SSL3, TLS 1.0, TLS 1.1, TLS 1.2.'
        }
    }
}
