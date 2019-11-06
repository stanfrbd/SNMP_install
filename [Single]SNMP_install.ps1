<#    
      stanfrbd
      06/11/2019
      Install and configure SNMP on a single server, locally with admin privileges
#>
    
Write-Host "Configuration de SNMP"
Install-WindowsFeature -Name "SNMP-Service" -IncludeManagementTools
        

if (-not(Test-Path -Path "C:\temp")) { mkdir "C:\temp" } 
Write-Output 'Windows Registry Editor Version 5.00
 
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters]
        "EnableAuthenticationTraps"=dword:00000000
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers]
        "1"="10.80.3.250"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\TrapConfiguration\public]
        "1"="10.80.3.250"
         
        [-HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
         
        [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities]
        "public"=dword:00000004' | out-file "C:\temp\config.reg" 

reg import "C:\temp\config.reg" 

Restart-Service "SNMP" 
    
if ((Get-Service -Name "SNMP").Status -eq "Running") { Write-Host "Install success" } else { Write-Host "SNMP is not running - try to troubleshoot." } 


