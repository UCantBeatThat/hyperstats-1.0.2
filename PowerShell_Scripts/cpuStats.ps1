$vms = Get-VM | Sort-Object VMName
Enable-VMResourceMetering $vms
$measure = Measure-VM $vms | Sort-Object VMName
$count = 0
$out = New-Object -TypeName 'System.Object[]' -ArgumentList $vms.Count

foreach ($vmname in $measure.VMName){
	$out[$count] = [PSCustomObject]@{
        "VMName" = $vmname
        "Current_CPU_Usage" = $vms[$count].CPUUsage
        "Average_CPU_Usage" = $measure[$count].AverageProcessorUsage
    }
    $count++
}

$retVal = $out | ConvertTo-Json

$retVal
