#!/bin/bash

# TODO: Make this script usable.

# Customize this if your disk is not /dev/sdb
HDD_DEVICE="/dev/sdb"

case "$1" in
  homelab)
    echo "🔧 Switching to HOMELAB mode..."
    sudo cpupower frequency-set -g powersave
    sudo nvidia-smi -pm 1
    sudo nvidia-smi -pl 80
    sudo hdparm -S 242 "$HDD_DEVICE"  # spins down after 20 mins
    echo "✅ Homelab mode activated."
    ;;

  gaming)
    echo "🎮 Switching to GAMING mode..."
    sudo cpupower frequency-set -g performance
    sudo nvidia-smi -pm 1
    sudo nvidia-smi -pl 145  # adjust depending on your GPU max
    sudo hdparm -S 0 "$HDD_DEVICE"  # disable spin-down
    echo "✅ Gaming mode activated."
    ;;

  status)
    echo "🧾 Power Mode Status:"
    echo -n "CPU Governor: "; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    echo -n "GPU Power Limit: "; nvidia-smi --query-gpu=power.limit --format=csv,noheader
    echo -n "Disk Spin-Down (sdb): "; sudo hdparm -I "$HDD_DEVICE" | grep "Advanced power management"
    ;;

  *)
    echo "Usage: $0 {homelab|gaming|status}"
    exit 1
    ;;
esac
