# Input bindings are passed in via param block.
param($Timer)

$data = Invoke-RestMethod https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt
$lines = $data.Split("`n") | where-object {$_ -notlike '#*'}
$ips = foreach ($line in $lines) { $line.split("`t")[0] }

$ips | Out-File dnsbl_ips.txt
