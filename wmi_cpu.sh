#!/bin/bash
/usr/lib/zabbix/externalscripts/zbxwmi "$1" Name "Name,PercentProcessorTime,PercentIdleTime" "Win32_PerfFormattedData_PerfOS_Processor" -U user -D domain -P 'password'
