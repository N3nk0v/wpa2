#!/bin/bash

# This script is intended to check and enable monitor mode on an Alfa network interface.

# Get the name of the Alfa network interface
ALFA_INTERFACE=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)

# If the Alfa interface is not found, display an error message and exit the script
if [ -z "$ALFA_INTERFACE" ]; then
    echo "Alfa network card not found. Please check if it is connected."
    exit 1
fi

# If the Alfa interface is found, display the interface name
echo "Alfa network card found on interface: $ALFA_INTERFACE"

# Check if the interface is already in monitor mode
MODE=$(iwconfig $ALFA_INTERFACE | grep -o "Mode:Monitor")

# If the interface is already in monitor mode, notify the user
if [ "$MODE" == "Mode:Monitor" ]; then
    echo "The interface $ALFA_INTERFACE is already in monitor mode."
else
    # If not in monitor mode, enable monitor mode
    echo "Enabling monitor mode for the interface $ALFA_INTERFACE..."
    sudo ifconfig $ALFA_INTERFACE down  # Bring the interface down
    sudo iwconfig $ALFA_INTERFACE mode monitor  # Set the interface to monitor mode
    sudo ifconfig $ALFA_INTERFACE up  # Bring the interface back up

    # Check if monitor mode was successfully enabled
    NEW_MODE=$(iwconfig $ALFA_INTERFACE | grep -o "Mode:Monitor")
    if [ "$NEW_MODE" == "Mode:Monitor" ]; then
        echo "Monitor mode successfully enabled on $ALFA_INTERFACE!"
    else
        echo "Failed to enable monitor mode. Please check manually."
    fi
fi
