#/bin/sh

#Create system.conf according with storage (eMMC or sdcard)
BOOT_TYPE=/tmp/mmcblk
if [ ! -f /etc/rauc/system.conf.ok ]; then
	#eMMC is mmcblk0 and sdcard is mmcblk1 : default is sdcard
	mount | grep boot | grep /dev/mmcblk1 > $BOOT_TYPE
	if test -s $BOOT_TYPE; then
		cp /etc/rauc/system.conf.emmc /etc/rauc/system.conf
	fi
	touch /etc/rauc/system.conf.ok
fi
rm $BOOT_TYPE


#To disable bootcount, "accepted" entry has to be true in metadata (in order to leave trial mode)
#This is done in st-boot-script.sh called by rauc just after
/usr/bin/rauc status mark-good
