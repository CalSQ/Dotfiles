#!/bin/bash

power_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$power_status" == "yes" ]; then
    connected_device=$(bluetoothctl info | grep "Name" | head -n 1 | cut -d ' ' -f2-)

    if [ -n "$connected_device" ]; then
        echo -e " $connected_device"
    else
        echo -e " On"
    fi
else
    echo -e "󰂲 Off"
fi

