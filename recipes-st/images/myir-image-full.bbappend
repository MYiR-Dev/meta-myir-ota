#
# INSTALL addons for dev images
#
IMAGE_INSTALL:append = "     \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'rauc', '', d)}  \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'rauc-conf', '', d)} \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'rauc-hawkbit', '', d)} \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'rauc-hawkbit-service', '', d)} \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'rauc-service', '', d)}  \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'fwu-gen-metadata-v2', '', d)} \
    ${@bb.utils.contains('OTA_SUPPORT', '1', 'u-boot-tools-stm32mp', '', d)}  \
"
