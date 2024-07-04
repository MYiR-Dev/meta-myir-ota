SUMMARY = "Tool to create FWU Metadata struct in Python"
HOMEPAGE = "https://github.com/etienne-lms/fwu_gen_metadata"
LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD-2-Clause;md5=cb641bc04cda31daea161b1bc15da69f"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/CGUSTM/fwu_gen_metadata;protocol=https;branch=master \
	file://update_metadata.sh \
	file://metadata_check_crc.py \
"

SRCREV = "e94004e94fdfdaebec536f03df742916b416ffff"

S = "${WORKDIR}/git"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -Dm 0755 ${WORKDIR}/git/fwumd_tool.py ${D}${libdir}/fwu/fwumd_tool.py
	install -d ${D}${libdir}/fwu/src
	install -m 0755 ${WORKDIR}/git/src/*.py ${D}${libdir}/fwu/src
	install -m 0755 ${WORKDIR}/update_metadata.sh ${D}${libdir}/fwu/
	install -m 0755 ${WORKDIR}/metadata_check_crc.py ${D}${libdir}/fwu/
}

FILES:${PN} += "${libdir}/fwu"
FILES:${PN} += "${libdir}/fwu/src"

RDEPENDS:${PN} += "python3-core bash"




