#import "enums.h"

@interface PreferencesManager : NSObject

+ (void)resetSettings;

// Global methods. Each method checks if a key is defined otherwise returns the default value
// defined in "config.h"
+ (bool)tweakEnabled;              // Are we enabled?
+ (UIColor*)primaryColor;          // The primary color.
+ (UIColor*)secondaryColor;        // The secondary color.
+ (UIColor*)chargingColor;         // The color used to indicate charging.
+ (UIColor*)lowPowerColor;         // The color used to indicate the phone is in low power mode.
+ (AnchorPosition)anchorPosition;  // Where we should attempt to anchor the view.
+ (int)numberOfDots;
+ (bool)showAllTime;           // Show even when not charging
+ (bool)lowPowerColorEnabled;  // Use the low power color if enabled.
+ (bool)hasChargingColor;      // Use the charging color if possible.
+ (bool)pulseChargingColor;    // Controls if the pulse animation is enabled.
+ (float)yOffset;
+ (float)xOffset;
+ (bool)yOffsetEnabled;
+ (bool)xOffsetEnabled;
+ (float)parentViewLength;
+ (float)dotRadius;
+ (float)fadeAnimationDuration;  // The length of the pulse animation.
+ (Mode)indicatorMode;
+ (RoundingStyle)roundingStyle;  // How should we round the number of dots? Up/down/nearest.
+ (bool)hideDateLabel;
// This converts from degrees to radians
+ (Orientation)orientation;
+ (bool)individualDotColorsEnabled;
+ (NSArray<UIColor*>*)individualDotColors;  // An array of all the dot colours

// Base Methods used for low level operation with the preferences.
+ (void)setValue:(id)value forKey:(NSString*)key;
+ (id)valueForKey:(NSString*)key;
@end
