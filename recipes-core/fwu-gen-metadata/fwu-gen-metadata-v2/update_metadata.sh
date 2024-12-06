#!/bin/bash
# Update metadata partition according with parameters
# to stop bootcount, active_index and previous_active_index have to be same

UUID_LIST="8a7a84a0-8387-40f6-ab41-a8b9a5a60d23,19d5df83-11b0-457b-be2c-7559c13142a5,4fd84c93-54ef-463f-a7ef-ae25ff887087,09c54952-d5bf-45af-acee-335303766fb3"
OPTIONS="-g -i 1 -b 2 -v 2"

if test ! $# -eq 3
then
    echo "arg1: active partition number: 0 (rauc.slot=A) or 1 (rauc.slot=B)"
    echo "arg2: previous partition number: 0 (rauc.slot=A) or 1 (rauc.slot=B)"
    echo "      Should be different from active partition number"
    echo "arg3: active partition acceptation: accept (trial mode OFF) or refuse (trial mode ON)"
    exit 1
fi

#metadata v2:
# A (Accepted) : partition is accepted : normal boot (a.k.a normal mode with metadata v1 or accept)
# V(Valid)     : partition not yet accepted : bootcount is enabled (a.k.a trial mode with metadata v1 or refuse)
# I(Invalid)   : invalid partition : not possible to boot on it (not managed in that script)
if test $3 == "refuse"
then
    if test $1 -eq 0
    then
        # set current partition 0 as Valid, and partition 1 as Accepted : bootcount is enabled
        bank_state="V,A"
    else
        # set partition 0 as Accepted, and current partition 1 as Valid : bootcount is enabled
        bank_state="A,V"
    fi
else
    #Both partition are accepted
    bank_state="A,A"
fi

echo "writing metadata partitions...."
CMD="mkfwumdata ${OPTIONS} -s ${bank_state} -a $1 -p $2 ${UUID_LIST}"
echo ${CMD}
${CMD} /dev/disk/by-partlabel/metadata1
${CMD} /dev/disk/by-partlabel/metadata2
sync

if test $1 -eq 0
then
    echo "active boot is A"
else
    echo "active boot is B"
fi

if test $3 == "refuse"
then
    echo "boot count is enabled"
fi
