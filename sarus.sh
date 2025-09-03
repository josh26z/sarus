#!/bin/bash

# Author : srsu10d
# Date : Skyscraper Day, 2025

# sarus is a basic network recon tool...
# frankly, i had some free time with all the placements stuff... so ye .. HERE WE GO...

# usage: .sarus.sh [network_prefix] [start] [end] [options]

#______________________________________________________________________________________________________________#


# +-----------------------------+
# |  Configuration & Defaults   |
# +-----------------------------+

DEFAULT_PREFIX="192.168.1"
DEFAULT_START=1
DEFAULT_END=254
TIMEOUT=0.5
PING_COUNT=1
SCAN_TYPE="ping"

# text colors
red='\033[0;31m'
grn='\033[0;32m'
yel='\033[1;33m'
blu='\033[0;34m'
nc='\033[0m'




# +-----------------------------+
# |    Function Definitions     |
# +-----------------------------+

usage() {
sleep 0.5
echo
echo
echo -e "    ${grn}Usage:${nc}"
echo "		$0 [network_prefix] [start] [end] [options]"
echo "		$0 (interactive mode)"
echo
sleep 0.2
echo -e "    ${grn}Options:${nc}"
echo "		-p, --ping            Ping scan (default)"
echo "                -t, --tcp [PORT]      TCP SYN scan on specified port"
echo "                -h, --help            Shows this help message"
echo
sleep 0.2
echo -e "    ${grn}Examples:${nc}"
echo "		$0 192.168.1 1 100"
echo "		$0 10.0.0 50 150 -t 80"
echo "		$0 -t 22"
echo
}



################################################################################################################




splash() {

clear
sleep 0.2
echo -e "  ${grn}+-----------------------------------------------------------------------------+${nc}"
echo -e "  ${grn}|                                                                             |${nc}"
echo -e "  ${grn}|                                                                             |${nc}"
figlet -f smslant "                          SARUS                   "
echo -e "  ${grn}|                                                                             |${nc}"
echo -e "  ${grn}|                                                                             |${nc}"
echo -e "  ${grn}+-----------------------------------------------------------------------------+${nc}"

}



################################################################################################################




validate_ip() {

local ip=$1
local stat=1

if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
OIFS=$IFS
IFS='.'
ip=($ip)
IFS=$OIFS
[[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 ]]
stat=$?
fi

return $stat

}



################################################################################################################



validate_number() {

local num=$1
local min=$2
local max=$3
[[ $num =~ ^[0-9]+$ ]] && [ $num -ge $min  ] && [ $num -le $max ]

}



################################################################################################################




command_exists() {

command -v "$1" >/dev/null 2>&1

}




################################################################################################################



ping_scan() {

local prefix=$1
local start=$2
local end=$3

echo
echo -e "	${blu}[*] Starting Ping Scan (ICMP Echo Request)...${nc}"
sleep 0.5
echo -e "	${yel}[*] Scanning range: $prefix.$start - $prefix.$end ${nc}"
echo

active_hosts=0
for host in $(seq $start $end); do
ip="$prefix.$host"
if ping -c $PING_COUNT -W $TIMEOUT $ip >/dev/null 2>&1; then
echo -e "		${grn}[*] Host $ip is ACTIVE${nc}"
((active_hosts++))

else

echo -e "		${red}[-] Host $ip is inactive${nc}" > /dev/null 2>&1

fi
done
echo
echo -e "	${blu}[*] Ping scan complete. Found $active_hosts active hosts.${nc}"


}



################################################################################################################



tcp_scan() {

local prefix=$1
local start=$2
local end=$3
local port=$4

if ! command_exists nmap; then
echo -e "	${red}[ERROR] nmap id required for TCP scans but not installed.${nc}"
echo    "	Install with: sudo apt install nmap"
exit 1
fi

echo -e "	${blu}[*] Starting TCP SYN Scan on port ${port}...${nc}"
echo -e "	${yel}[*] Scanning range: $prefix.$start - $prefix.$end ${nc}"
echo

target_range="$prefix.$start-$end"

sudo nmap -sS -p $port --open $target_range 2>/dev/null | grep -E "(Nmap scan|open)"

echo
echo -e "	${blu}[*] TCP scan complete.${nc}"
echo

}


################################################################################################################



# +-----------------------------+
# |    Main Script Execution    |
# +-----------------------------+

splash























