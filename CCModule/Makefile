TARGET := iphone:clang:latest:14.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SoloLockCC
SoloLockCC_BUNDLE_EXTENSION = bundle
SoloLockCC_FILES = SoloLockCCModule.m
SoloLockCC_CFLAGS = -fobjc-arc
SoloLockCC_FRAMEWORKS = UIKit
SoloLockCC_PRIVATE_FRAMEWORKS = ControlCenterUIKit
SoloLockCC_INSTALL_PATH = /Library/ControlCenter/Bundles

include $(THEOS_MAKE_PATH)/bundle.mk
