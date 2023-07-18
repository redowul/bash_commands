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
    echo "Attempting to connect to $target_name at $steamdeck_ip_address on port $target_port..."
    ssh -o ConnectTimeout=$connect_timeout "$username"@"$steamdeck_ip_address" -p "$target_port"
}

# Check if IP address variable is already set
if [ -z "$steamdeck_ip_address" ]; then
    scan
fi

# Attempt to connect via SSH
ssh_connect

# If the SSH connection fails or times out, perform the scan again and retry the connection
if [ $? -ne 0 ]; then
    echo "SSH connection failed or timed out, rescanning network..."
    scan
    ssh_connect
fi
