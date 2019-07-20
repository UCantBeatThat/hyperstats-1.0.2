$vms = Get-VM | Sort-Object VMName
Enable-VMResourceMetering $vms
$measure = Measure-VM $vms | Sort-Object VMName
$count = 0
$out = New-Object -TypeName "System.Object[]" -ArgumentList $vms.Count

foreach ($vmname in $measure.VMName){

    $traffic = $measure[$count].NetworkMeteredTrafficReport;
    foreach($addr in $traffic){
        if ($addr.Direction -eq \"Inbound\"){
            $inbound += $addr.TotalTraffic;
        }
        elseif ($addr.Direction -eq \"Outbound\"){
            $outbound += $addr.TotalTraffic;
        }
    }
    $out[$count] = [PSCustomObject]@{
        "VMName" = $vmname;
        "Inbound" = $inbound;
        "Outbound" = $outbound;
    }

    $count = $count + 1;
}

$retVal = $out | ConvertTo-Json

$retVal
