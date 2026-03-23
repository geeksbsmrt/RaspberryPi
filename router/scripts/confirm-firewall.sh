#!/bin/sh
# confirm-firewall.sh — Disarms the dead man's switch.
# Call after verifying SSH connectivity to the router is intact.
touch /tmp/.fw_confirmed
logger -t "confirm-firewall" "Firewall rules confirmed. Dead man's switch disarmed."
