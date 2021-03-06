################################################################################
#
# WPEFramework Provisioning
#
################################################################################

WPEFRAMEWORK_PROVISIONING_VERSION = 43fac8ca8f208ef06ea1a0bda673318be17be5ff
WPEFRAMEWORK_PROVISIONING_SITE_METHOD = git
WPEFRAMEWORK_PROVISIONING_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginProvisioning.git
WPEFRAMEWORK_PROVISIONING_INSTALL_STAGING = YES
WPEFRAMEWORK_PROVISIONING_DEPENDENCIES = wpeframework libprovision

WPEFRAMEWORK_PROVISIONING_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_PROVISIONING_VERSION}

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DEBUG),y)
# TODO: This recently stopped working, for now pass debug flags explicitly.
#WPEFRAMEWORK_PROVISIONING_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
WPEFRAMEWORK_PROVISIONING_CONF_OPTS += -DCMAKE_CXX_FLAGS='-g -Og'
endif

WPEFRAMEWORK_PROVISIONING_CONF_OPTS += -DWPEFRAMEWORK_PROVISIONING_URI=${BR2_PACKAGE_WPEFRAMEWORK_PROVISIONING_URI}
WPEFRAMEWORK_PROVISIONING_CONF_OPTS += -DPLUGIN_PROVISIONING_OPERATOR=${BR2_PACKAGE_WPEFRAMEWORK_PROVISIONING_OPERATOR}


$(eval $(cmake-package))
