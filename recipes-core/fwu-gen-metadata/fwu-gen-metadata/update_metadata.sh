#!/bin/bash
# Update metadata partition according with parameters
# to stop bootcount, active_index and previous_active_index have to be same

if test ! $# -eq 2
then
    echo "arg1: active partition number"
    echo "arg2: previous partition number"
    exit 1
fi

echo "Updating metadata partitions...."

/usr/lib/fwu/fwumd_tool.py binparse /dev/disk/by-partlabel/metadata1 -j /tmp/dummy.json

#echo "set_bank_policy img_0 $1 accept" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null
#echo "set_bank_policy img_0 $2 refuse" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null
echo "set_active_index $1" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null
echo "set_previous_active_index $2" | /usr/lib/fwu/fwumd_tool.py shell -j /tmp/dummy.json > /dev/null

/usr/lib/fwu/fwumd_tool.py jsonparse /tmp/dummy.json -b /dev/disk/by-partlabel/metadata1
/usr/lib/fwu/fwumd_tool.py jsonparse /tmp/dummy.json -b /dev/disk/by-partlabel/metadata2

rm /tmp/dummy.json

if test $1 -eq 0
then
    echo "active boot is A"
else
    echo "active boot is B"
fi

if test ! $1 -eq $2
then
    echo "fwu boot count is enabled"
fi
