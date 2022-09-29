#!/bin/bash
# Update metadata partition according with parameters
# to stop bootcount, active_index and previous_active_index have to be same

if test ! $# -eq 3
then
    echo "arg1: active partition number: 0 (rauc.slot=A) or 1 (rauc.slot=B)"
    echo "arg2: previous partition number: 0 (rauc.slot=A) or 1 (rauc.slot=B)"
    echo "      Should be different from active partition number"
    echo "arg3: active partition acceptation: accept (trial mode ON) or refuse (triel mode OFF)"
    exit 1
fi

echo "Updating metadata partitions...."
# Load metadata
/usr/lib/fwu/fwumd_tool.py binparse /dev/disk/by-partlabel/metadata1 -j /tmp/dummy.json

# Update index
echo "set_active_index $1" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null
echo "set_previous_active_index $2" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null

# Configure active partition in trial state (refuse: enable trial; accept: disable trial)
echo "set_bank_policy img_0 $1 $3" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null

# Store metadata
/usr/lib/fwu/fwumd_tool.py jsonparse /tmp/dummy.json -b /dev/disk/by-partlabel/metadata1
/usr/lib/fwu/fwumd_tool.py jsonparse /tmp/dummy.json -b /dev/disk/by-partlabel/metadata2

rm /tmp/dummy.json

if test $1 -eq 0
then
    echo "active boot is A"
else
    echo "active boot is B"
fi

if test $3 == "refuse"
then
    echo "fwu boot count is enabled"
fi
