#import "PreferencesManager.h"
#import "config.h"
#import <CSColorPicker/CSColorPicker.h>

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

// For explanations of what each method does see the header.
@implementation PreferencesManager

+(void) setValue:(id)value forKey:(NSString*)key {
  NSMutableDictionary *edit = [[NSMutableDictionary alloc] init];
  NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName: DOMAIN_NAME];
  [edit addEntriesFromDictionary: bundleDefaults];
  [edit setObject: value forKey: key];
  [[NSUserDefaults standardUserDefaults] setPersistentDomain: edit forName: DOMAIN_NAME];
}

+(id) valueForKey: (NSString*)key {
  NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName: DOMAIN_NAME];
  return [bundleDefaults objectForKey: key];
}

+(void) resetSettings {
  // For bools, ints and floats we have to convert to an NSNumber because the NSUserDefaults requires an NSObject derived object.
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_TWEAK_ENABLED] forKey: @"enabled"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"primaryColor"];
  [PreferencesManager setValue: DEFAULT_SECONDARY_COLOR forKey: @"secondaryColor"];
  [PreferencesManager setValue: DEFAULT_CHARGING_COLOR forKey: @"chargingColor"];
  [PreferencesManager setValue: DEFAULT_ANCHOR_POSITION forKey: @"anchorPosition"];
  [PreferencesManager setValue: [NSNumber numberWithInt: DEFAULT_NUMBER_OF_DOTS] forKey: @"numberOfDots"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_SHOW_ALL_TIME] forKey: @"showAllTime"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_HAS_CHARGING_COLOR] forKey: @"hasChargingColor"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_PULSE_CHARGING_COLOR] forKey: @"pulseChargingColor"];
  [PreferencesManager setValue: [NSNumber numberWithFloat: DEFAULT_Y_OFFSET] forKey: @"yOffset"];
  [PreferencesManager setValue: [NSNumber numberWithFloat: DEFAULT_X_OFFSET] forKey: @"xOffset"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_Y_OFFSET_ENABLED] forKey: @"yOffsetEnabled"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_X_OFFSET_ENABLED] forKey: @"xOffsetEnabled"];
  [PreferencesManager setValue: [NSNumber numberWithFloat: DEFAULT_PARENT_VIEW_LENGTH] forKey: @"parentViewLength"];
  [PreferencesManager setValue: [NSNumber numberWithFloat: DEFAULT_DOT_RADIUS] forKey: @"dotRadius"];
  [PreferencesManager setValue: DEFAULT_INDICATOR_MODE_STRING forKey: @"indicatorMode"];
  [PreferencesManager setValue: DEFAULT_FADE_ANIMATION_DURATION forKey: @"fadeAnimationDuration"];
  [PreferencesManager setValue: DEFAULT_ROUNDING_STYLE_STRING forKey: @"roundingStyle"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_HIDE_DATE_LABEL] forKey: @"hideDateLabel"];
  [PreferencesManager setValue: DEFAULT_ORIENTATION_STRING forKey: @"orientation"];
  [PreferencesManager setValue: [NSNumber numberWithBool: DEFAULT_INDIVIDUAL_DOT_COLOURS_ENABLED] forKey: @"individualDotColorsEnabled"];

  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color1"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color2"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color3"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color4"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color5"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color6"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color7"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color8"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color9"];
  [PreferencesManager setValue: DEFAULT_PRIMARY_COLOR forKey: @"color10"];
}

// Most of these methods are self-explanatory.
+(bool) tweakEnabled {
  id value = [self valueForKey: @"enabled"];

  if(value == nil)
  {
    return DEFAULT_TWEAK_ENABLED;
  }

  return [value boolValue];
}

+(UIColor*) primaryColor {
  NSString* value = [self valueForKey: @"primaryColor"];

  if(value == nil || [value isEqual: @""])
  {
    value = DEFAULT_PRIMARY_COLOR;
  }

  return [UIColor cscp_colorFromHexString: value];
}

+(UIColor*) secondaryColor{
  NSString* value = [self valueForKey: @"secondaryColor"];

  if(value == nil || [value isEqual: @""])
  {
    value = DEFAULT_SECONDARY_COLOR;
  }

  return [UIColor cscp_colorFromHexString: value];
}

+(UIColor*) chargingColor{
  NSString* value = [self valueForKey: @"chargingColor"];

  if(value == nil || [value isEqual: @""])
  {
    value = DEFAULT_CHARGING_COLOR;
  }

  return [UIColor cscp_colorFromHexString: value];
}

+(AnchorPosition) anchorPosition {
  NSString* value = [self valueForKey: @"anchorPosition"];

  if(value == nil || [value isEqual: @""])
  {
    value = DEFAULT_ANCHOR_POSITION;
  }

  if([value isEqual: @"Right"]) {
    return Anchor_Right;
  }else if([value isEqual: @"Left"]) {
    return Anchor_Left;
  }else {
    return Anchor_Center;
  }

}

+(int) numberOfDots {
  id value = [self valueForKey: @"numberOfDots"];

  if(value == nil)
  {
    return DEFAULT_NUMBER_OF_DOTS;
  }

  return [value intValue];
}

+(bool) showAllTime {
  id value = [self valueForKey: @"showAllTime"];

  if(value == nil)
  {
    return DEFAULT_SHOW_ALL_TIME;
  }

  return [value boolValue];
}

+(bool) hasChargingColor {
  id value = [self valueForKey: @"hasChargingColor"];

  if(value == nil)
  {
    return DEFAULT_HAS_CHARGING_COLOR;
  }

  return [value boolValue];
}

+(bool) pulseChargingColor {
  id value = [self valueForKey: @"pulseChargingColor"];

  if(value == nil)
  {
    return DEFAULT_PULSE_CHARGING_COLOR;
  }

  return [value boolValue];
}

+(float) yOffset {
  id value = [self valueForKey: @"yOffset"];

  if(value == nil)
  {
    return DEFAULT_Y_OFFSET;
  }

  return [value floatValue];
}

+(float) xOffset {
  id value = [self valueForKey: @"xOffset"];

  if(value == nil)
  {
    return DEFAULT_X_OFFSET;
  }

  return [value floatValue];
}

+(bool) yOffsetEnabled {
  id value = [self valueForKey: @"yOffsetEnabled"];

  if(value == nil)
  {
    return DEFAULT_Y_OFFSET_ENABLED;
  }

  return [value boolValue];
}

+(bool) xOffsetEnabled {
  id value = [self valueForKey: @"xOffsetEnabled"];

  if(value == nil)
  {
    return DEFAULT_X_OFFSET_ENABLED;
  }

  return [value boolValue];
}

// This value can't be greater than 1 or <= 0 so we ensure that here.
+(float) parentViewLength {
  id value = [self valueForKey: @"parentViewLength"];

  if(value == nil)
  {
    // This is a check because in previous versions before we added the vertical orientation so if the user was on that beta then we move their value across to
    // this new key for the new version.
    id width = [self valueForKey: @"parentViewWidth"];
    if (width == nil) {
      [PreferencesManager setValue: [NSNumber numberWithFloat: DEFAULT_PARENT_VIEW_LENGTH] forKey: @"parentViewLength"];
      return DEFAULT_PARENT_VIEW_LENGTH;
    }else {
      [PreferencesManager setValue: width forKey: @"parentViewLength"];
      value = width;
    }
  }

  float val = [value floatValue];

  if (val > 1) {
    return 1.0f;
  }else if (val <= 0) {
    return 0.01f;
  }else {
    return val;
  }
}

// This value can't be greater than 1 so we ensure that here.
+(float) dotRadius {
  id value = [self valueForKey: @"dotRadius"];

  if(value == nil)
  {
    return DEFAULT_DOT_RADIUS;
  }

  float val = [value floatValue];

  if (val > 1 || val <= 0) {
    return 1;
  }else if (val <= 0) {
    return 0.01f;
  }else {
    return val;
  }
}

+(Mode) indicatorMode {
  NSString* value = [self valueForKey: @"indicatorMode"];

  if(value == nil)
  {
    value = DEFAULT_INDICATOR_MODE_STRING;
  }

  if([value isEqual: @"Bar"]) {
    return Mode_Bar;
  }else if([value isEqual: @"Dots"]){
    return Mode_Dots;
  }else {
    return DEFAULT_INDICATOR_MODE;
  }
}

+(float) fadeAnimationDuration {
  id value = [self valueForKey: @"fadeAnimationDuration"];

  if(value == nil)
  {
    value = DEFAULT_FADE_ANIMATION_DURATION;
  }

  float val = [value floatValue];

  if (val > 10) {
    return 10;
  }else if(val < 0.1) {
    return 0.1;
  }else {
    return val;
  }
}

+(RoundingStyle) roundingStyle {
  NSString* value = [self valueForKey: @"roundingStyle"];

  if(value == nil)
  {
    value = DEFAULT_ROUNDING_STYLE_STRING;
  }

  if([value isEqual: @"Down"]) {
    return Round_Down;
  }else if([value isEqual: @"Nearest"]){
    return Round_Nearest;
  }else if([value isEqual: @"Up"]){
    return Round_Up;
  }else {
    return DEFAULT_ROUNDING_STYLE;
  }
}

+(bool) hideDateLabel {
  NSString* value = [self valueForKey: @"hideDateLabel"];

  if(value == nil)
  {
    return DEFAULT_HIDE_DATE_LABEL;
  }

  return [value boolValue];
}

+(Orientation) orientation {
  id value = [self valueForKey: @"orientation"];

  if(value == nil)
  {
    return DEFAULT_ORIENTATION;
  }

  if([value isEqual: @"Vertical"]) {
    return Orientation_Vertical;
  }else if([value isEqual: @"Horizontal"]){
    return Orientation_Horizontal;
  }else {
    return DEFAULT_ORIENTATION;
  }
}

+(bool) individualDotColorsEnabled{
  id value = [self valueForKey: @"individualDotColorsEnabled"];

  if (value == nil) {
    return DEFAULT_INDIVIDUAL_DOT_COLOURS_ENABLED;
  }
  return [value boolValue];
}

+(NSArray*) individualDotColors {
  NSMutableArray* colors = [[NSMutableArray alloc] init];

  for (int i = 1; i <= 10; i++) {
    id value = [self valueForKey: [NSString stringWithFormat: @"color%d", i]];

    if(value == nil || [value isEqual: @""])
    {
      value = DEFAULT_PRIMARY_COLOR;
    }

    UIColor* color = [UIColor cscp_colorFromHexString: value];
    [colors addObject: color];
  }

  return colors;
}
@end
