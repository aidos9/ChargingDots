#import "CircleModeView.h"
#import "OutlineModeView.h"
#import "enums.h"

// We can also uncomment the definition below to test with custom battery levels.
//#define DEBUG_BATTERY_PERCENTAGE 0.75f

// This interface is the base for the parent view which houses and manages the visual appearance of
// the widget, subclasses are used to layout in different orientations.
@interface ChargingParentViewBase : UIView {
  // We cache some preferences to prevent us constantly accessing the disk.
  UIColor* primaryColor;
  UIColor* secondaryColor;
  UIColor* chargingColor;
  UIColor* lowPowerColor;
  UIColor* lowBatteryColor;
  UIColor* outlineEmptyColor;
  float lowBatteryEnablePercentage;
  bool hasChargingColor;
  AnchorPosition anchorPosition;
  Mode mode;
  float lengthConstant;
  int numberOfDotsColored;
  NSArray<UIColor*>* individualColors;
  // An array for the dots so we can access them to assign colours.
  NSMutableArray<UIView*>* dots;
  // The background bar
  UIView* bar;
  // The view that is the fill colour
  UIView* barFill;
  // The view that manages the circle.
  CircleModeView* circleView;
  // The view that manages the outline circle.
  OutlineModeView* outlineView;
  // Track the pulsing index so we don't create two animations and so we can remove the animation on
  // demand.
  int pulsingIndex;
  // The animation.
  CABasicAnimation* chargingPulseAnimation;
}
// Anything followed by "Changed" indicates a method that is called when the user changes a setting

- (id)initWithFrame:(CGRect)frame;
// This lays out every view, after deleting the original ones and recolours them all.
- (void)relayout;

// Switch between bar mode and dot mode.
- (void)indicatorModeChanged;

// Called when co-ordinates change
- (void)yChanged;
- (void)xChanged;

// Called when the outline mode line thickness has changed
- (void)thicknessChanged;

// Called when the battery level has changed.
- (void)updateBatteryLevel;

// Loads the colors from the preferences
- (void)retrieveColors;
- (void)colorChanged;

// These methods recolor the dots or the bar. Forcing only affects the dots in that it overrides the
// check if the number of dots colored has changed
- (void)updateViewColors:(bool)force;
- (void)updateViewColors;
- (void)updateViewColorsDots:(bool)force;
- (void)updateViewColorsBar;
- (void)updateViewColorsCircle;
- (void)updateViewColorsOutline;

// Show/hide the parent view.
- (void)fadeIn;
- (void)fadeOut;

// These methods are called when pulse animation preferences are changed.
- (void)animationChanged;
- (void)fadeAnimationDurationChanged;

// Create the pulse animation for bar mode, for dot mode this is handled in the updateViewColorsDots
// method.
- (void)addBarAnimation;

// Called when UIDevice.batteryState is changed
- (void)batteryStateChanged;
// Returns true if the phone is plugged in to power.
- (bool)isCharging;

// Removes the dots, bar or animation from their respective parent views.
- (void)removeDots;
- (void)removeBar;
- (void)removeCircle;
- (void)removeOutline;
- (void)removeAnimation;

// Default implementations. Sub-classes should re-implement these
- (void)layoutDots;
- (void)layoutBar;
- (void)layoutCircle;
- (void)layoutOutline;
- (void)lengthChanged;        // The view length has been changed
- (void)updateBarPercentage;  // Changes the size of the fill bar.
- (void)updateCirclePercentage;
- (void)updateOutlinePercentage;
@end
