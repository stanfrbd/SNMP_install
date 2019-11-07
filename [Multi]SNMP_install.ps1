<#    
      stanfrbd
      06/11/2019
      Install and configure SNMPv2 (default) on multi servers.
      REMEMBER: 
      The servers MUST be reachables. If not, you will get fatal errors. Same if OS are not Windows Server.
      It will be a password prompt for each remote command. (Better for debbuging and know what you are doing).
      The public commnity will have READ-ONLY privileges.
      Replace 10.0.0.0 with your trusted IP address.
      You can change the Community Name but this is not recommanded.

#>

$adminLogin = "yourAdminLogin"
$servers = "10.0.0.0", "10.0.0.0", "10.0.0.0" <# ... enter others here #>

foreach ($server in $servers) {

    Write-Host "Install and configure: SNMP on $server"
    Install-WindowsFeature -computername $server -Credential $adminLogin -Name SNMP-Service -IncludeManagementTools <# If already installed, the status "noChangeNeeded will appear #>
        
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