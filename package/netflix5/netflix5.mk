################################################################################
#
# netflix5
#
################################################################################

NETFLIX5_VERSION = 77aa46b6301811f13b3cf671dc9ca0c685579040
NETFLIX5_SITE = git@github.com:Metrological/netflix.git
NETFLIX5_SITE_METHOD = git
NETFLIX5_LICENSE = PROPRIETARY
NETFLIX5_DEPENDENCIES = freetype icu jpeg libpng libmng webp harfbuzz expat openssl c-ares libcurl graphite2 nghttp2 wpeframework gst1-plugins-base
NETFLIX5_INSTALL_TARGET = YES
NETFLIX5_INSTALL_STAGING = YES
NETFLIX5_SUBDIR = netflix
NETFLIX5_RESOURCE_LOC = $(call qstrip,${BR2_PACKAGE_NETFLIX5_RESOURCE_LOCATION})

NETFLIX5_CONF_ENV += TOOLCHAIN_DIRECTORY=$(STAGING_DIR)/usr LD=$(TARGET_CROSS)ld
NETFLIX_CONF_ENV += TARGET_CROSS="$(GNU_TARGET_NAME)-"

ifeq ($(BR2_PACKAGE_PLAYREADY), y)
NETFLIX5_DEPENDENCIES += playready
endif
# TODO: disable hardcoded build type, check if all args are really needed.
NETFLIX5_CONF_OPTS = \
	-DBUILD_DPI_DIRECTORY=$(@D)/partner/dpi \
	-DCMAKE_INSTALL_PREFIX=$(@D)/release \
	-DCMAKE_OBJCOPY="$(TARGET_CROSS)objcopy" \
	-DCMAKE_STRIP="$(TARGET_CROSS)strip" \
	-DBUILD_COMPILE_RESOURCES=ON \
	-DBUILD_SYMBOLS=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DGIBBON_SCRIPT_JSC_DYNAMIC=OFF \
	-DGIBBON_SCRIPT_JSC_DEBUG=OFF \
	-DNRDP_HAS_IPV6=ON \
	-DNRDP_CRASH_REPORTING="off" \
	-DNRDP_TOOLS="provisioning" \
	-DDPI_IMPLEMENTATION=sink-interface \
	-DDPI_SINK_INTERFACE_IMPLEMENTATION=null \
	-DBUILD_DEBUG=OFF -DNRDP_HAS_GIBBON_QA=ON -DNRDP_HAS_MUTEX_STACK=ON -DNRDP_HAS_OBJECTCOUNT=ON \
	-DBUILD_PRODUCTION=OFF -DNRDP_HAS_QA=ON -DBUILD_SMALL=OFF -DBUILD_SYMBOLS=ON -DNRDP_HAS_TRACING=OFF \
	-DNRDP_CRASH_REPORTING=breakpad \
	-DNRDP_HAS_AUDIOMIXER=OFF \
	-DDPI_SINK_INTERFACE_OVERRIDE_APPBOOT=ON \
	-DGIBBON_GRAPHICS=rpi \
	-DGIBBON_GRAPHICS_GL_WSYS=egl
	
NETFLIX5_CONF_OPTS += -DGIBBON_MODE=shared
NETFLIX5_FLAGS = -O3 -fPIC

NETFLIX5_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(NETFLIX5_FLAGS)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(NETFLIX5_FLAGS)"

define NETFLIX5_INSTALL_STAGING_CMDS
   echo 'About to start install staging commands'

	make -C $(@D)/netflix install
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/libnetflix.so $(STAGING_DIR)/usr/lib
	$(INSTALL) -D package/netflix/netflix.pc $(STAGING_DIR)/usr/lib/pkgconfig/netflix.pc
	mkdir -p $(STAGING_DIR)/usr/include/netflix/src
	mkdir -p $(STAGING_DIR)/usr/include/netflix/nrdbase
	mkdir -p $(STAGING_DIR)/usr/include/netflix/nrd
	mkdir -p $(STAGING_DIR)/usr/include/netflix/nrdnet
	cp -Rpf $(@D)/release/include/* $(STAGING_DIR)/usr/include/netflix/
	cp -Rpf $(@D)/netflix/include/nrdbase/*.h $(STAGING_DIR)/usr/include/netflix/nrdbase/
	cp -Rpf $(@D)/netflix/include/nrd/*.h $(STAGING_DIR)/usr/include/netflix/nrd/
	cp -Rpf $(@D)/netflix/include/nrdnet/*.h $(STAGING_DIR)/usr/include/netflix/nrdnet/
	cd $(@D)/netflix/src && find ./base/ -name "*.h" -exec cp --parents {} ${STAGING_DIR}/usr/include/netflix/src \;
	cd $(@D)/netflix/src && find ./nrd/ -name "*.h" -exec cp --parents {} ${STAGING_DIR}/usr/include/netflix/src \;
	cd $(@D)/netflix/src && find ./net/ -name "*.h" -exec cp --parents {} ${STAGING_DIR}/usr/include/netflix/src \;
	mkdir -p $(STAGING_DIR)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/*.h $(STAGING_DIR)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/bridge/*.h $(STAGING_DIR)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/text/*.h $(STAGING_DIR)/usr/include/netflix
	cp -Rpf $(@D)/netflix/src/platform/gibbon/text/freetype/*.h $(STAGING_DIR)/usr/include/netflix
	mkdir -p $(STAGING_DIR)/usr/include/netflix/gibbon
	cp -Rpf $(@D)/netflix/src/platform/gibbon/include/gibbon/*.h $(STAGING_DIR)/usr/include/netflix/gibbon
	find output/staging/usr/include/netflix/nrdbase/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;
	find output/staging/usr/include/netflix/nrd/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;
	find output/staging/usr/include/netflix/nrdnet/ -name "*.h" -exec sed -i "s/^#include \"\.\.\/\.\.\//#include \"/g" {} \;

	mkdir -p $(TARGET_DIR)/root/Netflix
	cp -r $(@D)/netflix/src/platform/gibbon/resources/gibbon/fonts $(TARGET_DIR)/root/Netflix
	cp -r $(@D)/netflix/resources/etc $(TARGET_DIR)/root/Netflix
	mkdir -p $(TARGET_DIR)/root/Netflix/etc/conf
	cp -r $(@D)/netflix/src/platform/gibbon/resources/configuration/* $(TARGET_DIR)/root/Netflix/etc/conf
	cp -r $(@D)/netflix/src/platform/gibbon/resources/gibbon/icu $(TARGET_DIR)/root/Netflix
	cp -r $(@D)/netflix/src/platform/gibbon/resources $(TARGET_DIR)/root/Netflix
	cp -r $(@D)/netflix/resources/configuration/* $(TARGET_DIR)/root/Netflix/etc/conf
	cp $(@D)/partner/graphics/nexus/graphics.xml $(TARGET_DIR)/root/Netflix/etc/conf
	cp $(@D)/netflix/src/platform/gibbon/resources/gibbon/icu/icudt58l/debug/unames.icu $(TARGET_DIR)/root/Netflix/icu/icudt58l
	cp $(@D)/netflix/src/platform/gibbon/*.js* $(TARGET_DIR)/root/Netflix/resources/js
	cp $(@D)/netflix/src/platform/gibbon/resources/default/PartnerBridge.js $(TARGET_DIR)/root/Netflix/resources/js

   echo 'Done with install staging commands'
endef

define NETFLIX5_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/netflix/src/platform/gibbon/libnetflix.so $(TARGET_DIR)/usr/lib
	$(STRIPCMD) $(TARGET_DIR)/usr/lib/libnetflix.so
endef

define NETFLIX5_PREPARE_DPI
	mkdir -p $(TARGET_DIR)/root/Netflix/dpi
	ln -sfn /etc/playready $(TARGET_DIR)/root/Netflix/dpi/playready
endef

NETFLIX5_POST_INSTALL_TARGET_HOOKS += NETFLIX5_PREPARE_DPI

$(eval $(cmake-package))
