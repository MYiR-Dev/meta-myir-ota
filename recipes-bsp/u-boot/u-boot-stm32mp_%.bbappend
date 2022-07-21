FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append += " \
	file://0001-stm32mp1-update-env-to-support-boot-A-B.patch \
"
