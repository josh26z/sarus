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
--add-combo="Scan Type:" --combo-values="Ping|TCP SYN" \
--add-entry="Timeout (seconds):" "$DEFAULT_TIMEOUT" \
--width=700 --height=450

}

##############################################################################################################


validate_input() {

local prefix=$1 start=$2 end=$3 port=$4 timeout=$5

if [[ ! $prefix =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
zenity --error --text="Invalid network prefix format. Use something like '192.168.1'"
return 1
fi


if [[ ! $start =~ ^[0-9]+$ ]] || [ $start -lt 1 ] || [ $start -gt 255 ]; then
zenity --error --text="Start must be a number between 1 and 255"
return 1
fi




if [[ ! $end =~ ^[0-9]+$ ]] || [ $end -lt 1 ] || [ $end -gt 255 ]; then
zenity --error --text="End must be a number between 1 and 255"
return 1
fi



if [ $start -gt $end ]; then
zenity --error --text="Start number cannot be greater than end number"
return 1
fi



    if [[ ! $port =~ ^[0-9]+$ ]] || [ $port -lt 1 ] || [ $port -gt 65535 ]; then
        zenity --error --text="Port must be a number between 1 and 65535"
        return 1
    fi
    
    if [[ ! $timeout =~ ^[0-9.]+$ ]] || (( $(echo "$timeout <= 0" | bc -l) )); then
        zenity --error --text="Timeout must be a positive number"
        return 1
    fi
    
    return 0
}




show_progress() {
    zenity --progress \
        --title="Scanning Network" \
        --text="Initializing scan..." \
        --percentage=0 \
        --auto-close \
        --auto-kill \
        --width=400
}




ping_scan() {
    local prefix=$1 start=$2 end=$3 timeout=$4
    local total_hosts=$((end - start + 1))
    local current=0
    active_hosts=0
    
    (
    for host in $(seq $start $end); do
        ip="$prefix.$host"
        current=$((current + 1))
        percentage=$((current * 100 / total_hosts))
        
        # Update progress dialog
        echo "$percentage"
        echo "# Scanning $ip... Found: $active_hosts active hosts"
        
        if ping -c 1 -W $timeout $ip >/dev/null 2>&1; then
            echo -e "${GREEN}[+] Host $ip is ACTIVE${NC}" >> /tmp/scan_results.txt
            ((active_hosts++))
        else
            echo "[-] Host $ip is inactive" >> /tmp/scan_results.txt
        fi
        sleep 0.1 # Small delay to allow GUI updates
    done
    ) | show_progress
}


tcp_scan() {
    local prefix=$1 start=$2 end=$3 port=$4
    local target_range="$prefix.$start-$end"
    
    if ! command -v nmap >/dev/null 2>&1; then
        zenity --error --text="nmap is required for TCP scans but not installed.\nInstall with: sudo apt install nmap"
        return 1
    fi
    
    # Show progress for TCP scan
    (
    echo "10"
    echo "# Starting TCP SYN scan on port $port..."
    
    # Run nmap and capture results
    sudo nmap -sS -p $port --open $target_range 2>/dev/null | \
        grep -E "(Nmap scan|open)" > /tmp/scan_results.txt
    
    echo "100"
    echo "# TCP scan completed"
    ) | show_progress
}




show_results() {
    if [ -f /tmp/scan_results.txt ] && [ -s /tmp/scan_results.txt ]; then
        zenity --text-info \
            --title="Scan Results" \
            --filename=/tmp/scan_results.txt \
            --width=600 --height=400 \
            --checkbox="Save results to file"
        
        if [ $? -eq 0 ] && [ "$?" = "1" ]; then
            save_file=$(zenity --file-selection --save --confirm-overwrite \
                --title="Save Scan Results" \
                --filename="network_scan_$(date +%Y%m%d_%H%M%S).txt")
            
            if [ -n "$save_file" ]; then
                cp /tmp/scan_results.txt "$save_file"
                zenity --info --text="Results saved to: $save_file"
            fi
        fi
    else
        zenity --info --text="No active hosts found during the scan."
    fi
}


# Cleanup temporary files
cleanup() {
    rm -f /tmp/scan_results.txt
}






#------------------------------------------------------------------------------------------------------------------------#





main() {
    check_zenity
    cleanup
    
    # Show main menu and get input
    input=$(show_main_menu)
    if [ $? -ne 0 ] || [ -z "$input" ]; then
        zenity --info --text="Scan cancelled."
        exit 0
    fi
    
    # Parse input (zenity forms returns pipe-separated values)
    IFS='|' read -r prefix start end port scan_type timeout <<< "$input"
    
    # Validate input
    if ! validate_input "$prefix" "$start" "$end" "$port" "$timeout"; then
        exit 1
    fi
    
    # Confirm scan
    total_hosts=$((end - start + 1))
    zenity --question \
        --title="Confirm Scan" \
        --text="This will scan $total_hosts hosts ($prefix.$start to .$end).\nScan type: $scan_type\n\nContinue?" \
        --width=400
    
    if [ $? -ne 0 ]; then
        zenity --info --text="Scan cancelled."
        exit 0
    fi
    
    # Ask for sudo password if doing TCP scan
    if [ "$scan_type" = "TCP SYN" ] && [ "$EUID" -ne 0 ]; then
        sudo -v || exit 1
    fi
    
    # Execute the scan
    start_time=$(date +%s)
    
    case "$scan_type" in
        "Ping")
            ping_scan "$prefix" "$start" "$end" "$timeout"
            ;;
        "TCP SYN")
            tcp_scan "$prefix" "$start" "$end" "$port"
            ;;
    esac
    
    # Calculate execution time
    end_time=$(date +%s)
    execution_time=$((end_time - start_time))
    
    # Show results
    show_results
    
    # Show summary
    if [ -f /tmp/scan_results.txt ]; then
        result_count=$(grep -c "ACTIVE\|open" /tmp/scan_results.txt 2>/dev/null || echo "0")
        zenity --info \
            --title="Scan Complete" \
            --text="Scan completed in ${execution_time} seconds.\nFound ${result_count} active hosts/services."
    fi
    
    cleanup
}










main "$@"































