FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# -------------------------------------------------------------
# Append hook files
#
SRC_URI += "file://pre-push"
SRC_URI += "file://checkscore.py"

HOOK_FILES = "pre-push"
HOOK_FILES += "checkscore.py"

# -------------------------------------------------------------
# Defconfig
#
SRC_URI += "file://rauc.cfg"
KERNEL_CONFIG_FRAGMENTS += "${WORKDIR}/rauc.cfg"
