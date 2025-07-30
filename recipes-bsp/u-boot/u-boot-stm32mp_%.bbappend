FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append := " \
	file://0001-stm32mpu-update-env-to-support-boot-A-B.patch \
	file://0002-autoboot-propagate-boot-index-from-tf-a.patch \
"
