<#    
      stanfrbd
      06/11/2019
      Install and configure SNMPv2 (default) on a single server, locally with admin privileges.
      REMEMBER: the OS must be Windows Server.
      The public commnity will have READ-ONLY privileges.
      Replace 10.0.0.0 with your trusted IP address.
      You can change the Community Name but this is not recommanded.

#>
    
Write-Host "Install and configure: SNMP"
Install-WindowsFeature -Name "SNMP-Service" -IncludeManagementTools <# If already installed, the status "noChangeNeeded will appear #>
        

if (-not(Test-Path -Path "C:\temp")) { mkdir "C:\temp" } 
Write-Output 'Windows Registry Editor Version 5.00
 
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters]
        "EnableAuthenticationTraps"=dword:00000000
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers]
        "1"="10.0.0.0"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
        "1"="10.0.0.0"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
        "public"=dword:00000004' | out-file "C:\temp\config.reg" 

reg import "C:\temp\config.reg" 

Restart-Service "SNMP" 
    
if ((Get-Service -Name "SNMP").Status -eq "Running") { Write-Host "Install success" } else { Write-Host "SNMP is not running - try to troubleshoot." } 