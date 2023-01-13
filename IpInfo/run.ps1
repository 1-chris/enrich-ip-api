using namespace System.Net

param($Request, $TriggerMetadata)

function Test-WebProxy($IPAddress)
{
    if (Test-Connection -TcpPort 3128 $IPAddress -TimeoutSeconds 2) { return $true }
    return $false
}

function Get-IPInfo($IPAddress)
{
    if ($IPAddress -eq "" -or $null -eq $IPAddress) { $IPAddress = "1.1.1.1"}
    $ipstackUri = "https://api.ipstack.com/$($IPAddress)?access_key=$($env:APIKey)"
    $ipInfo = Invoke-RestMethod $ipstackUri | ConvertTo-Json -Depth 50 | ConvertFrom-Json -AsHashtable -Depth 50

    $torNodes = (Get-Content tor_ips.txt).Split("`n")
    $dnsblIPs = (Get-Content dnsbl_ips.txt).Split("`n")
    if ($IPAddress -in $torNodes) { $ipInfo.tor = $true } else { $ipInfo.tor = $false }
    if ($IPAddress -in $dnsblIPs) { $ipInfo.dnsbl = $true } else { $ipInfo.dnsbl = $false }
    # $ipInfo.webproxy = Test-WebProxy -IPAddress $IPAddress

    return $ipInfo
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = (Get-IPInfo -IPAddress $Request.Query.ip)
})
