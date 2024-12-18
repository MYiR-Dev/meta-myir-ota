#!/bin/sh

# Remove write protection on boot partitions
echo "0" > /sys/class/block/mmcblk1boot0/force_ro
echo "0" > /sys/class/block/mmcblk1boot1/force_ro
