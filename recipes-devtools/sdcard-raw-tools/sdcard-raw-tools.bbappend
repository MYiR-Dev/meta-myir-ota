FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "${@bb.utils.contains('OTA_SUPPORT', '1', 'file://create_sdcard_from_flashlayout_ota.sh', '', d)}"
