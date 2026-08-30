TARGET := iphone:clang:14.5:14.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SoloLockPrefs

SoloLockPrefs_FILES = SoloLockPrefs.m
SoloLockPrefs_FRAMEWORKS = UIKit
SoloLockPrefs_PRIVATE_FRAMEWORKS = Preferences
SoloLockPrefs_INSTALL_PATH = /Library/PreferenceBundles
SoloLockPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
