TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SoloLock

SoloLock_FILES = Tweak.x
SoloLock_CFLAGS = -fobjc-arc
SoloLock_FRAMEWORKS = UIKit CoreGraphics
SoloLock_PRIVATE_FRAMEWORKS = SpringBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs CCModule
include $(THEOS_MAKE_PATH)/aggregate.mk
