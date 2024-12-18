#/bin/bash
# At this stage, we can consider the new image has successfully boot, so the bootcount can be disabled.
# To disable it, "accepted" entry has to be true in metadata (in order to leave trial mode)

arg1=$1

if [ "$arg1" = "get-primary" ]
then
    cat /proc/cmdline | grep "rauc.slot=A" > /dev/null
    if test $? == 0
    then
        /usr/lib/fwu/update_metadata.sh 0 0 accept > /dev/null
        echo "A"
    else
        /usr/lib/fwu/update_metadata.sh 1 1 accept > /dev/null
        echo "B"
    fi
    exit 0
fi

# When boot succeeded, st-status-mark-good.sh calls rauc status mark-good which
# enters in this function.
if [ "$arg1" = "get-state" ]
then
    echo "good"
    exit 0
fi
