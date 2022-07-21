FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
	file://config.cfg \
"
do_install:append () {
	install -Dm 0755 ${WORKDIR}/config.cfg ${D}${sysconfdir}/${BPN}/config.cfg
}

# at least python3-html socketserver are missing
RDEPENDS:${PN}:append = " python3-modules"
