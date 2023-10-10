FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rauc.config"
KERNEL_CONFIG_FRAGMENTS:append = "${WORKDIR}/rauc.config"
