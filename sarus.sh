#!/bin/bash

# Author : srsu10d
# Date : Skyscraper Day, 2025

# sarus is a basic network recon tool...
# frankly, i had some free time with all the placements stuff... so ye .. HERE WE GO...

# usage: .sarus.sh [network_prefix] [start] [end] [options]

###########################################################################################################


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
RED='\033[0;31m'
grn='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
nc='\033[0m'




# +-----------------------------+
# |    Function Definitions     |
# +-----------------------------+
sleep 0.5
usage() {
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



splash
usage

