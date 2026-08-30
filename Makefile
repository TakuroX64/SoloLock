TARGET := iphone:clang:14.5:14.0
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SoloLock

SoloLock_FILES = Tweak.x
SoloLock_CFLAGS = -fobjc-arc
SoloLock_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Prefs CCModule
include $(THEOS_MAKE_PATH)/aggregate.mk
