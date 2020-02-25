#import "ChargingParentViewVertical.h"
#import "PreferencesManager.h"

// For explanations of what each method does see the header.
@implementation ChargingParentViewVertical

-(void) updateBarPercentage {
  if(self->barFill == nil) {
    return;
  }

  CGFloat width = self.frame.size.width * [PreferencesManager dotRadius];
  // We need to subtract the percentage from 1 or else the bar will empty as we charge!
  // Change the height and y-position based on the amount of charge we have.
  #ifdef DEBUG_BATTERY_PERCENTAGE
  CGRect fillBarRect = CGRectMake(0,self->bar.frame.size.height * (1 - DEBUG_BATTERY_PERCENTAGE), width, self->bar.frame.size.height * DEBUG_BATTERY_PERCENTAGE);
  #else
  CGRect fillBarRect = CGRectMake(0,self->bar.frame.size.height * (1 - [UIDevice currentDevice].batteryLevel), width, self->bar.frame.size.height * [UIDevice currentDevice].batteryLevel);
  #endif
  self->barFill.frame = fillBarRect;
}

-(void) lengthChanged {
  // Simple sanity check to ensure that the value actually changed because this calls relayout which is expensive.
  if (self->lengthConstant != [PreferencesManager parentViewLength]) {
    self->lengthConstant = [PreferencesManager parentViewLength];
    CGFloat length = [self.superview frame].size.height*[PreferencesManager parentViewLength];
    CGRect newPosition = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, length);
    self.frame = newPosition;
    [self relayout];
  }
}

-(void) layoutDots {
  // Make sure that there is an array to append to.
  if(self->dots == nil) {
    self->dots = [[NSMutableArray alloc] init];
  }

  [self removeDots];

  int numberOfDots = [PreferencesManager numberOfDots];
  CGFloat dotDiameter = self.frame.size.width*0.95*[PreferencesManager dotRadius]; // Since dotRadius is a percentage value anyway
  CGFloat spacing = (self.frame.size.height - dotDiameter * numberOfDots) / (numberOfDots+1); // +1 to account for spacing after the last dot
  int dotIndex = 0;

  while(self->dots.count < numberOfDots) {
    // spacing + spacing * dotIndex + dotIndex * dotDiameter = (spacing * (dotIndex + 1)) + (dotIndex * dotDiameter)
    // This basically allows us to have an offset from the start of the view and then spacing inbetween the previous dots and for this dot plus the width
    // of the previous dots.
    CGRect frame = CGRectMake(self.frame.size.width/2 - dotDiameter/2, spacing + spacing * dotIndex + dotIndex * dotDiameter, dotDiameter, dotDiameter);
    UIView* newView = [[UIView alloc] initWithFrame: frame];
    newView.layer.cornerRadius = dotDiameter/2;
    newView.layer.masksToBounds = true;
    [self addSubview: newView];
    // We have to insert at 0 because as we create the views we move down but we want the top view to be the last one to be filled in and hence it must be at the last index.
    [self->dots insertObject: newView atIndex: 0];
    dotIndex++;
  }
}

-(void) layoutBar {
  // Simple sanity check to ensure that the bar does not exist already.
  // Remove it if it does.
  if(self->bar != nil && self->barFill != nil) {
    [self removeBar];
  }

  CGFloat width = self.frame.size.width * [PreferencesManager dotRadius];

  CGRect mainBarRect = CGRectMake(self.frame.size.width/2 - width/2, 0, width, self.frame.size.height);
  self->bar = [[UIView alloc] initWithFrame: mainBarRect];
  self->bar.layer.cornerRadius = width/2;
  self->bar.layer.masksToBounds = true;
  [self addSubview: self->bar];

  #ifdef DEBUG_BATTERY_PERCENTAGE
  CGRect fillBarRect = CGRectMake(0,self->bar.frame.size.height * (1 - DEBUG_BATTERY_PERCENTAGE), width, self->bar.frame.size.height * DEBUG_BATTERY_PERCENTAGE);
  #else
  CGRect fillBarRect = CGRectMake(0,self->bar.frame.size.height * (1 - [UIDevice currentDevice].batteryLevel), width, self->bar.frame.size.height * [UIDevice currentDevice].batteryLevel);
  #endif
  
  self->barFill = [[UIView alloc] initWithFrame: fillBarRect];
  [self->bar addSubview: self->barFill];
}
@end
