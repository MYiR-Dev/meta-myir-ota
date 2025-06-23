FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append := " \
	file://0001-autoboot-propagate-boot-index-from-tf-a.patch \
	file://0002-stm32mp-update-env-to-support-boot-A-B.patch \
	file://0003-stm32-stm32prog-add-support-rootfs-a-for-OTA.patch \
"
