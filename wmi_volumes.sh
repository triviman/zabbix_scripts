!/bin/bash
/usr/lib/zabbix/externalscripts/zbxwmi "$1" Name "Name,Size,FreeSpace" "Win32_LogicalDisk" -f "MediaType = 12"  -U user -D domain -P 'password'
