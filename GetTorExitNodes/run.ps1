param($Timer)

$data = Invoke-RestMethod -Uri https://check.torproject.org/exit-addresses
$lines = $data.Split("`n") | ? {$_ -like '*ExitAddress*'}
$ips = $lines | Foreach-object {$_.split(" ")[1]}

$ips | Out-File tor_ips.txt
