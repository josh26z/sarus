#!/bin/bash

# GUI Network Scanner with Zenity
# Author: srsu10d
# GUI implementation of sarus
# Date: Thiruvonam 2025

#--------------------------------------------------------------------------------------------------------------#



# +---------------------------------------------------+
# |                                                   |
# |                Config and Defaults                |
# |                                                   |
# +---------------------------------------------------+

DEFAULT_PREFIX="192.168.1"
DEFAULT_START="1"
DEFAULT_END="254"
DEFAULT_PORT="80"
DEFAULT_TIMEOUT="0.5"

#text colors

red='\033[0;31m'
grn='\033[0;32m'
yel='\033[1;33m'
blu='\033[0;34m'
nc='\033[0m'


################################################################################################################





check_zenity() {

if ! command -v zenity >/dev/null 2>&1; then
echo "	Zenity is required but not installed. Please install with:"
echo
echo "	${blu}sudo apt install zenity ${nc}"
exit 1
fi
}


################################################################################################################




show_main_menu() {

zenity --forms --title="SARUS-UI" --text="Enter scan parameters"  --ok-label="Scan" \
--add-entry="Network Prefix:" "$DEFAULT_PREFIX" \
--add-entry="Start Host:" "$DEFAULT_START" \
--add-entry="End Host:" "$DEFAULT_END" \
--add-entry="TCP Port (if applicable):" "$DEFAULT_PORT" \
--add-entry="Scan Type:" --combo-values="Ping|TCP SYN" \
--add-entry="Timeout (seconds):" "$DEFAULT_TIMEOUT" \
--width=700 --height=450

}

