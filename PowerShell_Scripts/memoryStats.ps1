$vms = Get-VM | Sort-Object VMName
Enable-VMResourceMetering $vms
$measure = Measure-VM $vms | Sort-Object VMName
$count = 0
$out = New-Object -TypeName "System.Object[]" -ArgumentList $vms.Count

foreach ($vmname in $measure.VMName){
    $out[$count] = [PSCustomObject]@{
        "VMName" = $vmname;
        "MemoryAssigned" = ($vms[$count].MemoryAssigned / (1024*1024));
        "MinimumMemoryUsage" = $measure[$count].MinimumMemoryUsage;
        "MaximumMemoryUsage" = $measure[$count].MaximumMemoryUsage;
        "AverageMemoryUsage" = $measure[$count].AverageMemoryUsage;
    }
    $count++;
}

$retVal = $out | ConvertTo-Json

$retVal
