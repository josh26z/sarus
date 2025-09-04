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

TCP_PORT=80
while [[ $# -gt 0  ]]; do
case $1 in

-h|--help)
usage
exit 0
;;

-p|--ping)
SCAN_TYPE="ping"
shift
;;

-t|--tcp)
SCAN_TYPE="tcp"
if [[ -n $2 && ! $2 =~ ^-  ]]; then
TCP_PORT=$2
shift 2
else
shift
fi
;;

*)

if [[ -z $network_prefix  ]]; then
network_prefix=$1

elif [[ -z $start_range  ]]; then
start_range=$1

elif [[ -z $end_range  ]]; then
end_range=$1

fi
shift
;;

esac
done


if [[ -z $network_prefix  ]]; then
read -p "	Enter the network prefix (e.g., 192.168.1) [$DEFAULT_PREFIX]:  " network_prefix
network_prefix=${network_prefix:-$DEFAULT_PREFIX}
fi

if [[ -z $start_range  ]]; then
read -p "       Enter the starting host number (e.g., 1) [$DEFAULT_START]:  " start_range
start_range=${start_range:-$DEFAULT_START}
fi


if [[ -z $end_range  ]]; then
read -p "       Enter the ending host number (e.g., 254) [$DEFAULT_END]:  " end_range
end_range=${end_range:-$DEFAULT_END}
fi




#input validation

if ! validate_ip "$network_prefix"; then
echo -e "	${red}[ERROR] Invalid network prefix format. Use something like '192.168.1'${nc}"
exit 1
fi


if ! validate_number "$start_range" 1 255; then
echo -e "	${red}[ERROR] Start must be a number between 1 and 255${nc}"
exit 1
fi

if ! validate_number "$end_range" 1 255; then
echo -e "       ${red}[ERROR] End must be a number between 1 and 255${nc}"
exit 1
fi

if [ $start_range -gt $end_range ]; then
echo -e "	${red}[ERROR] Start number cannot be greater than the end number.${nc}"
exit 1
fi



#scan info


echo
echo -e "	${blu}[*] Scan Configuration: ${nc}"
echo -e "		Network: ${yel}$network_prefix${nc}"
echo -e "               Range: ${yel}${start_range} - ${end_range}${nc}"
echo -e "               Type: ${yel}$SCAN_TYPE${nc}"
if [ "$SCAN_TYPE" = "tcp" ]; then
echo -e "               Port: ${yel}$TCP_PORT${nc}"
fi

echo




#large scan confirmation

total_hosts=$((end_range - start_range + 1))
if [ $total_hosts -gt 50 ]; then
read -p "	${blu}[\!] This will scan $total_hosts hosts. Continue? (y/N):  ${nc}" confirm
if [[ ! $confirm =~ ^[Yy]$  ]]; then
echo    "	Scan cancelled."
exit 0
fi
fi



#scan start

start_time=$(date +%s)

case $SCAN_TYPE in

"ping")
ping_scan "$network_prefix" "$start_range" "$end_range"
;;


"tcp")
tcp_scan "$network_prefix" "$start_range" "$end_range" "$TCP_PORT"
;;

esac



#execution time

end_time=$(date +%s)
execution_time=$((end_time - start_time))
echo -e "	${blu}[*] Execution time: ${execution_time} seconds${nc}"


#exit

exit 0

























