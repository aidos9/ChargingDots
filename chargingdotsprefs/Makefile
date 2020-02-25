include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ChargingDotsPrefs

ChargingDotsPrefs_FILES = CHDRootListController.m CHDWidgetLayoutListController.m CHDColoursRootListController.m ../source/PreferencesManager.m
ChargingDotsPrefs_INSTALL_PATH = /Library/PreferenceBundles
ChargingDotsPrefs_FRAMEWORKS = UIKit
ChargingDotsPrefs_PRIVATE_FRAMEWORKS = Preferences
ChargingDotsPrefs_CFLAGS += -fobjc-arc
ChargingDotsPrefs_LDFLAGS += -lCSColorPicker -F$(THEOS_PRIVATE_PATH)
# THEOS_PRIVATE_PATH should point to the theos sdk privateframeworks path

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ChargingDotsPrefs.plist$(ECHO_END)
