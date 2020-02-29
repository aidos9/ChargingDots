// This header contains a number of constants that configure the default behaviour

#define Y_PERCENTAGE 0.268f   // Just a value that looked good on an iPhone X with no yOffset
#define DEFAULT_THICKNESS 20  // The width for horizontal mode or the height for vertical mode.
#define SELF_FADE_ANIMATION_DURATION \
  1.0f  // The fade in/out animation duration. For showing the view when charging begins or ends.
#define DOMAIN_NAME @"com.aidos9.chargingdotsprefs"

// These are a collection of default values for preferences. New preferences should define a default
// in here.
#define DEFAULT_TWEAK_ENABLED true
#define DEFAULT_PRIMARY_COLOR @"0cf085"
#define DEFAULT_SECONDARY_COLOR @"99b5b5b5"
#define DEFAULT_CHARGING_COLOR @"0aa5fe"
#define DEFAULT_LOW_POWER_COLOR @"fec10a"
#define DEFAULT_LOW_POWER_ENABLED false
#define DEFAULT_ANCHOR_POSITION @"Center"
#define DEFAULT_NUMBER_OF_DOTS 7
#define DEFAULT_SHOW_ALL_TIME false
#define DEFAULT_HAS_CHARGING_COLOR true
#define DEFAULT_PULSE_CHARGING_COLOR true
#define DEFAULT_Y_OFFSET 0.0f
#define DEFAULT_X_OFFSET 0.0f
#define DEFAULT_Y_OFFSET_ENABLED false
#define DEFAULT_X_OFFSET_ENABLED false
#define DEFAULT_PARENT_VIEW_LENGTH 0.65f
#define DEFAULT_DOT_RADIUS 0.75f
#define DEFAULT_INDICATOR_MODE Mode_Dots
#define DEFAULT_INDICATOR_MODE_STRING @"Dots"
#define DEFAULT_FADE_ANIMATION_DURATION @"1.0"
#define DEFAULT_ROUNDING_STYLE_STRING @"Down"
#define DEFAULT_ROUNDING_STYLE Round_Down
#define DEFAULT_HIDE_DATE_LABEL false
#define DEFAULT_ORIENTATION Orientation_Horizontal
#define DEFAULT_ORIENTATION_STRING @"Horizontal"
#define DEFAULT_INDIVIDUAL_DOT_COLOURS_ENABLED false
