param (
    [string]$vc,
    [string]$user,
    [string]$password,
    [string]$vm_name
)
Connect-VIServer -Server $vc -User $user -Password $password
$vm = Get-VM -Name $vm_name
$diskToRemove = Get-HardDisk -VM $vm | Where-Object { $_.Name -eq "Hard disk 2" }
Remove-HardDisk -HardDisk $diskToRemove -Confirm:$false
Restart-VM -VM $vm -Confirm:$false
Disconnect-VIServer -Confirm:$false