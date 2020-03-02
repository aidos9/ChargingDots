INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = chargingdots

chargingdots_FILES = source/Tweak.xm source/ChargingManager.m source/PreferencesManager.m source/ChargingParentViewHorizontal.m source/ChargingParentViewVertical.m source/ChargingParentViewBase.m source/CircleView.m
chargingdots_CFLAGS = -fobjc-arc
chargingdots_LDFLAGS += -lCSColorPicker

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += chargingdotsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
