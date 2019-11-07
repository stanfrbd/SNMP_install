<#    
      stanfrbd
      06/11/2019
      Install and configure SNMP on a multi servers
      REMEMBER: the server must be reachable. If not, you will get errors.
      It will be a password prompt for each remote command.
      The public commnity will have READ-ONLY privilegies
      Replace 10.0.0.0 with your trusted IP address
      You can change the Community Name but this is not recommanded
#>
$adminLogin = "yourAdminLogin"
$servers = "10.0.0.0", "10.0.0.0" <# enter others here #>

foreach ($server in $servers) {
    <# Check if SNMP-Service is already installed
    $check = Get-WindowsFeature -computername $server -Credential smedrano.admin -Name SNMP-Service, Failover-Clustering 
    if (-not($check.installed)) { #>
    Write-Host "Install and configure: SNMP on $server"
    Install-WindowsFeature -computername $server -Credential $adminLogin -Name SNMP-Service -IncludeManagementTools
        
    <# create et install .reg file#>
    Invoke-Command -ComputerName $server -Credential $adminLogin { if (-not(Test-Path -Path "C:\temp")) { mkdir C:\temp } }
    Invoke-Command -ComputerName $server -Credential $adminLogin { Write-Output 'Windows Registry Editor Version 5.00
 
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters]
        "EnableAuthenticationTraps"=dword:00000000
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers]
        "1"="10.0.0.0"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
        "1"="10.0.0.0"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
        "public"=dword:00000004' | out-file "C:\temp\config.reg" }

    Invoke-Command -ComputerName $server -Credential $adminLogin { reg import "C:\temp\config.reg" }

    Invoke-Command -ComputerName $server -Credential $adminLogin { Restart-Service SNMP }
    Invoke-Command -ComputerName $server -Credential $adminLogin { if ((Get-Service -Name SNMP).Status -eq "Running") { Write-Host "Install success" } else { Write-Host "SNMP is not running - try to troubleshoot." } }

        
}
}
