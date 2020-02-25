#import "ChargingManager.h"
#import "Interfaces.h"
#import "PreferencesManager.h"
#import "ChargingParentViewHorizontal.h"
#import "ChargingParentViewVertical.h"
#import "config.h"

// We call the group iOS13 because that is all that we have tested on.
%group iOS13
static ChargingManager* manager = nil;

// MARK: Hide battery
%hook CSChargingViewController
-(id)init {
  return nil; // Prevents the creation of the view AND stops the fading animation.
}
%end

// MARK: Show widget
%hook CSMainPageContentViewController
// a C method is required for the notification call back, which we use to call the member method that handles the notification
void orientationChanged (CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    CSMainPageContentViewController* vc = (__bridge CSMainPageContentViewController*)observer; // __bridge is used to convert from a C void* to our object.
    [vc orientationChanged];
}

-(void)viewDidLoad{
  %orig;
  [self checkAndUpdateManager];
  // __bridge is used to convert from self to a C void pointer.
  // Create the observer to detect if the orientation setting has changed.
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), (__bridge const void *)(self), orientationChanged, (__bridge CFStringRef)@"orientationChanged", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

%new
// This method checks if the manager exists and otherwise creates one.
-(void) checkAndUpdateManager {
  if(manager == nil) {
    switch([PreferencesManager orientation]) {
      case Orientation_Horizontal: {
        CGFloat width = [self.view frame].size.width*[PreferencesManager parentViewLength];
        CGRect viewRect = CGRectMake([self.view frame].size.width/2 - width/2, [self.view frame].size.height * Y_PERCENTAGE, width, DEFAULT_THICKNESS);

        if([PreferencesManager yOffsetEnabled]) {
          viewRect.origin.y += [PreferencesManager yOffset];
        }

        if([PreferencesManager xOffsetEnabled]) {
          viewRect.origin.x += [PreferencesManager xOffset];
        }

        ChargingParentViewHorizontal* dotsParentView = [[ChargingParentViewHorizontal alloc] initWithFrame: viewRect];
        [self.view addSubview: dotsParentView];
        manager = [[ChargingManager alloc] initWithParent: dotsParentView];
        break;
      }

      case Orientation_Vertical: {
        CGFloat length = [self.view frame].size.height*[PreferencesManager parentViewLength];
        CGRect viewRect = CGRectMake([self.view frame].size.width/2 - DEFAULT_THICKNESS/2, [self.view frame].size.height * Y_PERCENTAGE, DEFAULT_THICKNESS, length);

        if([PreferencesManager yOffsetEnabled]) {
          viewRect.origin.y += [PreferencesManager yOffset];
        }

        if([PreferencesManager xOffsetEnabled]) {
          viewRect.origin.x += [PreferencesManager xOffset];
        }

        ChargingParentViewVertical* dotsParentView = [[ChargingParentViewVertical alloc] initWithFrame: viewRect];
        [self.view addSubview: dotsParentView];
        manager = [[ChargingManager alloc] initWithParent: dotsParentView];
        break;
      }
    }
  }
}

%new
-(void) orientationChanged {
  // When the orientation is changed a new manager is required, first we ensure that we clean up the original one.
  [manager removeParentView];
  manager = nil;
  [self checkAndUpdateManager];
}

-(void) dealloc {
  %orig;
  // Remove observers.
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterRemoveEveryObserver(center, (__bridge const void *)(self));
}
%end


//MARK: Hide date view
%hook SBFLockScreenDateViewController
// This method controls whether a label containing "x% charged" appears.
-(void)setCustomSubtitleView:(id)arg1 {
  if(![PreferencesManager hideDateLabel]) {
    %orig;
  }
}
%end

%hook SBFLockScreenDateSubtitleDateView
// a C method is required for the notification call back, which we use to call the member method that handles the notification
void notificationCallback (CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    SBFLockScreenDateSubtitleDateView* view = (__bridge SBFLockScreenDateSubtitleDateView*)observer; // __bridge is used to convert from a C void* to our object.
    [view toggleHidden];
}

-(id)initWithDate:(id)arg1 {
  id value = %orig;

  // __bridge is used to convert from self to a C void pointer.
  // Create the observer to detect if the hideDateLabel setting has changed.
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback, (__bridge CFStringRef)@"hideDateLabelChanged", NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

  // Actually hides the view
  [self setHidden: [PreferencesManager hideDateLabel]];

  return value;
}

-(void)_updateDateLabelForCompact {
  // We only want to let SpringBoard update the label if we aren't hiding it otherwise it may reappear.
  if(![PreferencesManager hideDateLabel]) {
    %orig;
  }
}

-(void) dealloc {
  // Remove observers.
  CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
  CFNotificationCenterRemoveEveryObserver(center, (__bridge const void *)(self));
  %orig;
}

%new
-(void) toggleHidden {
  [self setHidden: [PreferencesManager hideDateLabel]];
}

%end
%end // iOS13

%ctor {
  if ([PreferencesManager tweakEnabled]) {
    %init(iOS13);
  }
}
