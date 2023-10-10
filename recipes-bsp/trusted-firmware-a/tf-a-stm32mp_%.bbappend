FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append := " \
	file://0001-plat-st-add-management-of-boot-partition.patch \
	file://0002-fwu-add-logs-for-demo-purpose.patch \
"
