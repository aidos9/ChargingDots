#import "ChargingParentViewBase.h"

// This interface is the overall manager, it is responsible for handling Darwin notifications(created when a setting is changed) and passing that to
// the parentview. It is also responsible for hiding/showing and changing the orientation of the parentView.
@interface ChargingManager : NSObject {
  ChargingParentViewBase* parent;
}

-(id) initWithParent: (ChargingParentViewBase*) view;
// Manual dealloc so that we remove the observers for the darwin notification center
-(void) dealloc;

// This method is called externally to delete the parentView
-(void) removeParentView;

// This setups observers for notifications posted when a setting changes
-(void) setupObservers;

// This method handles the selection of which *Changed method should be called, which in turn call a method on the parentView to handle the change in the settings
-(void) notificationCallback: (NSString*)name;

// These methods fade in/out the parentView and also do a sanity check to ensure that parentView is not nil.
-(void) showParentView;
-(void) hideParentView;

// Checks if we are charging or if we should show the view otherwise and then shows or hides parentView
-(void) checkShowView;

// These methods are called when battery related things change.
-(void) batteryLevelDidChange: (id) notification;
-(void) batteryStateDidChange: (id) notification;

// These methods are called when a setting changes
-(void) showAllTimeChanged;
-(void) primaryColorChanged;
-(void) secondaryColorChanged;
-(void) chargingColorChanged;
-(void) hasChargingColorChanged;
-(void) anchorPositionChanged;
-(void) numberOfDotsChanged;
-(void) pulseChargingColorChanged;
-(void) parentViewLengthChanged;
-(void) yOffsetChanged;
-(void) xOffsetChanged;
-(void) dotRadiusChanged;
-(void) indicatorModeChanged;
-(void) fadeAnimationDurationChanged;
-(void) roundingStyleChanged;
@end
