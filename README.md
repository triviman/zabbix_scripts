zabbix_scripts
==============

This is a collection of scripts for use with Zabbix.

## zbxwmi
Connects to a Windows server using WMI to discover and collect WMI data. It uses Low-Level Discovery and is agentless.

zbxwmi must be installed on a Zabbix server or proxy and depends on wmic.

![](https://github.com/dav3860/zabbix_scripts/blob/master/services.png)

### Installation
* Create a Windows user with WMI permissions
* Install wmic. It can be installed from rpmforge or compiled from source, http://dev.zenoss.org/svn/tags/wmi-1.3.14/
* Clone this repository into /usr/lib/zabbix/externalscripts/
* Make zabbix the owner of the zbxwmi script and add execute permissions
* Install the dependencies :
```
pip install -r requirements.txt
```
* Import the template and set the required macros.

### Usage
```
Usage:
  zbxwmi [-d] get <host> <item> <class> [-f <filter>] [-z <server>] [-D <domain>] [-U <username>] [-P <password] [-o <logfile>]
  zbxwmi [-d] (bulk|discover) <host> <keys> <items> <class> [-f <filter>] [-z <server>] [-D <domain>] [-U <username>] [-P <password] [-o <logfile>]
  zbxwmi [-d] <host> <keys> <items> <class> [-f <filter>] [-z <server>] [-D <domain>] [-U <username>] [-P <password] [-o <logfile>]
  zbxwmi --help
  zbxwmi --version
```
### Actions

get: query a specific WMI item.
```
zbxwmi get SVR1 FreeSpace "Win32_LogicalDisk" -f "MediaType = 12 AND Name = 'C:'"
4079554560
```

discover : outputs a JSON-formatted output for LLD discovery.
```
zbxwmi discover SVR1 Name Name,Size,FreeSpace "Win32_LogicalDisk" -f "MediaType = 12"
{
    "data": [
        {
            "{#WMIINDEX0}": "C:"
        },
        {
            "{#WMIINDEX0}": "D:"
        },
        {
            "{#WMIINDEX0}": "E:"
        }
    ]
}
```

bulk: bulk sends item values to Zabbix using the Zabbix sender protocol.
```
zbxwmi bulk SVR1 Name Name,Size,FreeSpace "Win32_LogicalDisk" -f "MediaType = 12"
```

both (default action): combines the discover and bulk actions to create the discovered items in Zabbix using LLD and get their values.
```
zbxwmi SVR1 Name Name,Size,FreeSpace "Win32_LogicalDisk" -f "MediaType = 12" -D MYDOMAIN -U wmiuser -P secret
{
    "data": [
        {
            "{#WMIINDEX0}": "C:"
        },
        {
            "{#WMIINDEX0}": "D:"
        },
        {
            "{#WMIINDEX0}": "E:"
        }
    ]
}
```

A sample template to monitor Windows services is provided. Don't forget to use a secure Windows account to query your hosts (a domain admin will work but it's not recommended). You can add the credentials into the script if you don't want to display them into the Zabbix frontend.
UPDATE:
use new files:

create a new template an create a new discovery rule:

Name:volumes
type: external check
Key: wmi_volumes.sh[{HOST.HOST}]

create into discovery a two new Items Prototype:

item 1:
```
Name:FreeSpace {#WMIINDEX0}
type: Zabbix Trapper
Key: FreeSpace[{#WMIINDEX0}]
type: numeric
data type: Decimal
Units:B
```
item 2:
```
Name:Size {#WMIINDEX0}
type: Zabbix Trapper
Key: Size[{#WMIINDEX0}]
type: numeric
data type: Decimal
Units:B
```

create a new template an create a new discovery rule:

Name:cpu
type: external check
Key: wmi_cpu.sh[{HOST.HOST}]

create into discovery a two new Items Prototype:

item 1:
```
Name:Cpu idle [{#WMIINDEX0}]
type: Zabbix Trapper
Key: PercentIdleTime[{#WMIINDEX0}]
type: numeric
data type: Decimal
Units:B
```
item 2:
```
Name:Cpu use [{#WMIINDEX0}]
type: Zabbix Trapper
Key: PercentProcessorTime[{#WMIINDEX0}]
type: numeric
data type: Decimal
Units:B
```
attach template to host and enjoy.




