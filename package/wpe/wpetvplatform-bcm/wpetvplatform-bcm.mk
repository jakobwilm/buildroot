################################################################################
#
# WPETVControl
#
################################################################################

WPETVPLATFORMBCM_VERSION = 7b6146592d03076bc818d4e07f0fbee181e36c5e
WPETVPLATFORMBCM_SITE_METHOD = git
WPETVPLATFORMBCM_SITE = git@github.com:WebPlatformForEmbedded/WPETVPlatformBCM.git
WPETVPLATFORMBCM_INSTALL_STAGING = YES
WPETVPLATFORMBCM_DEPENDENCIES = wpeframework

WPETVPLATFORMBCM_CONF_OPTS += \
    -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
    -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -D_GNU_SOURCE" \
     $(WPETVPLATFORMBCM_FLAGS)

$(eval $(cmake-package))
