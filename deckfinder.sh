#!/bin/bash

target_name="steamdeck"
network_range="192.168.0.0/24"
target_port="4220"
username="deck"
connect_timeout=3

function scan {
    echo "Scanning network for host '$target_name'..."
    export steamdeck_ip_address=$(nmap -p $target_port -PR -T5 --max-retries 0 --host-timeout 0.25s $network_range | grep "$target_name" -B 2 | awk -F'[()]' '/Nmap scan report for/ {print $2}')
}

function ssh_connect {
    local connection_type=${1:-ssh}  # default to ssh if no argument passed
    echo "Attempting to connect to $target_name at $steamdeck_ip_address on port $target_port using $connection_type..."
    if [ "$connection_type" == "sftp" ]; then
        sftp -oPort=$target_port $username@$steamdeck_ip_address
    else
        ssh -o ConnectTimeout=$connect_timeout $username@$steamdeck_ip_address -p $target_port
    fi
}

# Check if IP address variable is already set
if [ -z "$steamdeck_ip_address" ]; then
    scan
fi

# Get the connection type from the first command line argument (default to ssh if not specified)
connection_type=${1:-ssh}

# Attempt to connect
ssh_connect $connection_type

# If the connection fails or times out, perform the scan again and retry the connection
if [ $? -ne 0 ]; then
    echo "$connection_type connection failed or timed out, rescanning network..."
    scan
    ssh_connect $connection_type
fi
