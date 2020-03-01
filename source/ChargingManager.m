#import "ChargingManager.h"
#import "PreferencesManager.h"

// For explanations of what each method does see the header.
@implementation ChargingManager
- (id)initWithParent:(ChargingParentViewBase *)view {
  self = [super init];

  // We need to take ownership of the view pointer because this manager will be a static variable.
  self->parent = view;

  // Perform the initial setup steps
  [self setupObservers];

  [self checkShowView];

  return self;
}

- (void)dealloc {
  // We need to remove the observers we create during initialization
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterRemoveEveryObserver(center, (__bridge const void *)(self));
}

- (void)removeParentView {
  [self->parent removeFromSuperview];
}

- (void)checkShowView {
  // If we should show all the time then just call the show method and return.
  if ([PreferencesManager showAllTime]) {
    [self showParentView];
    return;
  }

  // We want to show the view even when the battery is at 100%
  if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging ||
      [UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
    [self showParentView];
  } else {
    [self hideParentView];
  }
}

- (void)showParentView {
  if (self->parent != nil) {
    [self->parent fadeIn];
  }
}

- (void)hideParentView {
  if (self->parent != nil) {
    [self->parent fadeOut];
  }
}

- (void)setupObservers {
  // Setup the observers for the darwin center when settings change.
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"parentViewLengthChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"yOffsetChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"xOffsetChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"showAllTimeChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"primaryColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"secondaryColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"chargingColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"lowPowerColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"lowPowerColorEnabledChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"hasChargingColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"anchorPositionChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"numberOfDotsChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"pulseChargingColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"dotRadiusChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"indicatorModeChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"fadeAnimationDurationChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"roundingStyleChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"individualDotColorsEnabledChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"individualDotColorsChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"lowBatteryColorChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"lowBatteryColorEnabledChanged", NULL,
                                  CFNotificationSuspensionBehaviorDeliverImmediately);
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback,
                                  (__bridge CFStringRef) @"lowBatteryEnabledPercentageChanged",
                                  NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  // These are called when the battery changes states or percentage
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(batteryLevelDidChange:)
                                             name:UIDeviceBatteryLevelDidChangeNotification
                                           object:nil];
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(batteryStateDidChange:)
                                             name:UIDeviceBatteryStateDidChangeNotification
                                           object:nil];
  [NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(powerStateDidChange:)
                                             name:NSProcessInfoPowerStateDidChangeNotification
                                           object:nil];
}

// a C method is required for the notification call back, which we use to call the member method
// that handles the notification
void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name,
                          const void *object, CFDictionaryRef userInfo) {
  ChargingManager *man = (__bridge ChargingManager *)
      observer;  // __bridge is used to convert from a C void* to our object.
  // We want to pass in the name of the method and to convert from a C string we can use __bridge
  [man notificationCallback:(__bridge NSString *)name];
}

- (void)notificationCallback:(NSString *)name {
  if ([name isEqual:@"parentViewLengthChanged"]) {
    [self parentViewLengthChanged];
  } else if ([name isEqual:@"yOffsetChanged"]) {
    [self yOffsetChanged];
  } else if ([name isEqual:@"xOffsetChanged"]) {
    [self xOffsetChanged];
  } else if ([name isEqual:@"showAllTimeChanged"]) {
    [self showAllTimeChanged];
  } else if ([name isEqual:@"primaryColorChanged"]) {
    [self primaryColorChanged];
  } else if ([name isEqual:@"secondaryColorChanged"]) {
    [self secondaryColorChanged];
  } else if ([name isEqual:@"chargingColorChanged"]) {
    [self chargingColorChanged];
  } else if ([name isEqual:@"hasChargingColorChanged"]) {
    [self hasChargingColorChanged];
  } else if ([name isEqual:@"anchorPositionChanged"]) {
    [self anchorPositionChanged];
  } else if ([name isEqual:@"numberOfDotsChanged"]) {
    [self numberOfDotsChanged];
  } else if ([name isEqual:@"pulseChargingColorChanged"]) {
    [self pulseChargingColorChanged];
  } else if ([name isEqual:@"dotRadiusChanged"]) {
    [self dotRadiusChanged];
  } else if ([name isEqual:@"indicatorModeChanged"]) {
    [self indicatorModeChanged];
  } else if ([name isEqual:@"fadeAnimationDurationChanged"]) {
    [self fadeAnimationDurationChanged];
  } else if ([name isEqual:@"roundingStyleChanged"]) {
    [self roundingStyleChanged];
  } else if ([name isEqual:@"individualDotColorsEnabledChanged"]) {
    [self individualDotColorsEnabledChanged];
  } else if ([name isEqual:@"individualDotColorsChanged"]) {
    [self individualDotColorsChanged];
  } else if ([name isEqual:@"lowPowerColorChanged"]) {
    [self lowPowerColorChanged];
  } else if ([name isEqual:@"lowPowerColorEnabledChanged"]) {
    [self lowPowerColorEnabledChanged];
  } else if ([name isEqual:@"lowBatteryColorChanged"]) {
    [self lowBatteryColorChanged];
  } else if ([name isEqual:@"lowBatteryColorEnabledChanged"]) {
    [self lowBatteryColorEnabledChanged];
  } else if ([name isEqual:@"lowBatteryEnabledPercentageChanged"]) {
    [self lowBatteryEnabledPercentageChanged];
  }
}

- (void)parentViewLengthChanged {
  if (self->parent != nil) {
    [self->parent lengthChanged];
  }
}

- (void)yOffsetChanged {
  if (self->parent != nil) {
    [self->parent yChanged];
  }
}

- (void)xOffsetChanged {
  if (self->parent != nil) {
    [self->parent xChanged];
  }
}

- (void)showAllTimeChanged {
  [self checkShowView];
}

- (void)primaryColorChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)secondaryColorChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)chargingColorChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)hasChargingColorChanged {
  [self->parent colorChanged];
}

- (void)anchorPositionChanged {
  if (self->parent != nil) {
    [self->parent relayout];
  }
}

- (void)numberOfDotsChanged {
  if (self->parent != nil) {
    [self->parent relayout];
  }
}

- (void)pulseChargingColorChanged {
  if (self->parent != nil) {
    [self->parent animationChanged];
  }
}

- (void)dotRadiusChanged {
  [self->parent relayout];
}

- (void)batteryLevelDidChange:(id)notification {
  // parent does all the heavy lifting here.
  if (self->parent != nil) {
    [self->parent updateBatteryLevel];
  }
}

- (void)batteryStateDidChange:(id)notification {
  // parent does all the heavy lifting here.
  [self checkShowView];
  if (self->parent != nil) {
    [self->parent batteryStateChanged];
  }
}

- (void)powerStateDidChange:(id)notification {
  if (self->parent != nil) {
    // We need to do this because for some reason this notification often puts us not on the main
    // thread.
    dispatch_async(dispatch_get_main_queue(), ^{
      [self->parent colorChanged];
    });
  }
}

- (void)indicatorModeChanged {
  if (self->parent != nil) {
    [self->parent indicatorModeChanged];
  }
}

- (void)fadeAnimationDurationChanged {
  if (self->parent != nil) {
    [self->parent fadeAnimationDurationChanged];
  }
}

- (void)roundingStyleChanged {
  if (self->parent != nil) {
    [self->parent updateViewColors:true];
  }
}

- (void)individualDotColorsEnabledChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)individualDotColorsChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)lowPowerColorChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)lowPowerColorEnabledChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)lowBatteryColorChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)lowBatteryColorEnabledChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}

- (void)lowBatteryEnabledPercentageChanged {
  if (self->parent != nil) {
    [self->parent colorChanged];
  }
}
@end
