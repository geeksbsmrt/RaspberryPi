#!/bin/bash
# setup-vlans.sh — Creates 802.1Q sub-interfaces on the Raspberry Pi host.
# Idempotent. Called by systemd oneshot unit (pi-vlans.service) on boot
# and by the deploy pipeline on each deployment.
#
# Management (VLAN 10) uses untagged eth0 — no sub-interface needed.
# The Pi's eth0 address should be set to 192.168.10.4 via dhcpcd/netplan.

set -euo pipefail

PARENT_IF="eth0"

# VLAN ID → static IP for the Pi host on each VLAN
declare -A VLANS=(
  [20]="192.168.20.4/24"
  [30]="192.168.30.4/24"
  [40]="192.168.40.4/24"
  [50]="192.168.50.4/24"
  [60]="192.168.60.4/24"
  [70]="192.168.70.4/24"
  [80]="192.168.80.4/24"
)

for VLAN_ID in "${!VLANS[@]}"; do
  IFACE="${PARENT_IF}.${VLAN_ID}"
  IP_ADDR="${VLANS[$VLAN_ID]}"

  if ip link show "$IFACE" &>/dev/null; then
    echo "[OK] $IFACE already exists"
  else
    echo "[+] Creating $IFACE"
    ip link add link "$PARENT_IF" name "$IFACE" type vlan id "$VLAN_ID"
  fi

  ip addr flush dev "$IFACE" 2>/dev/null || true
  ip addr add "$IP_ADDR" dev "$IFACE"
  ip link set "$IFACE" up
  echo "[✓] $IFACE up with $IP_ADDR"
done
