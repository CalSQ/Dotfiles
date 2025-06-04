#!/bin/bash
# Show "VPN" if Mullvad VPN is connected, otherwise "Online" or "Offline"

if nmcli connection show --active | grep -qi 'mullvad'; then
  echo " VPN"
elif nmcli networking connectivity check | grep -qi 'full'; then
  echo "  Online"
else
  echo " Offline"
fi

