$vms = Get-VM | Sort-Object VMName
Enable-VMResourceMetering $vms
$measure = Measure-VM $vms | Sort-Object VMName
$count = 0
$out = New-Object -TypeName "System.Object[]" -ArgumentList $vms.Count

foreach ($vmname in $measure.VMName){
    $out[$count] = [PSCustomObject]@{
        "VMName" = $vmname;
        "Total_Disk_Allocated" = $measure[$count].TotalDiskAllocation;
        "AggregatedDiskDataRead" = $measure[$count].AggregatedDiskDataRead;
        "AggregatedDiskDataWritten" = $measure[$count].AggregatedDiskDataWritten;
        "AggregatedAverageLatency" = $measure[$count].AggregatedAverageLatency;
    }
    $count++;
}

$retVal = $out | ConvertTo-Json

$retVal
