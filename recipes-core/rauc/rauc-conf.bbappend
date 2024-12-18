FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://system.conf \
	file://ca.cert.pem \
	file://post-install.sh \
	file://st-status-mark-good.sh \
	file://st-boot-script.sh \
"

do_install:append () {
	install -Dm 0755 ${WORKDIR}/post-install.sh ${D}${libdir}/rauc/post-install.sh
	install -Dm 0755 ${WORKDIR}/st-status-mark-good.sh ${D}${libdir}/rauc/st-status-mark-good.sh
	install -Dm 0755 ${WORKDIR}/st-boot-script.sh ${D}${libdir}/rauc/st-boot-script.sh
}

FILES:${PN} += "${libdir}/rauc"