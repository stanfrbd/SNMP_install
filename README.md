# SNMP_install
Script to install SNMPv2 (default) on a single Windows Server or multi servers.

## SNMP

SNMP is a protocol that allows trusted hosts to access the target server information (CPU usage, Disk usage, ...). 
This is used by supervising services, but SNMP is not installed by default on Windows Servers (WMI is the default protocol).

## The server must run at least Windows Server 2016 (2012 is not supported)

You'll need to be admin if you want to run the script.

Theses scripts install SNMP-Service with management options (security is not added in the default package).
Then they create a `.reg` file that is imported by Windows. This will configure the "public" Community with READ-ONLY access, only accessible by the trusted host you added. 

No personnal information given.

Edit the scripts below with the missing information: servers, admin login, trusted host for public community.

On the multi servers script, make sure the OS is Windows Server and that this server is reachable.
