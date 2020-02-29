#import "ChargingParentViewBase.h"
#import "PreferencesManager.h"
#import "config.h"

// For explanations of what each method does see the header.
@implementation ChargingParentViewBase
-(id) initWithFrame: (CGRect)frame {
  self = [super initWithFrame: frame];

  [self setAlpha: 0.0f];

  self->dots = [[NSMutableArray alloc] init];
  self->mode = [PreferencesManager indicatorMode];
  self->anchorPosition = Anchor_Center;
  self->pulsingIndex = -1;
  self->lengthConstant = [PreferencesManager parentViewLength];
  self->numberOfDotsColored = -1;
  [self retrieveColors];

  [self updateBatteryLevel];
  [self relayout];
  return self;
}

// This method is expensive so we will try and minimize any calls to it.
-(void) relayout {
  switch (self->mode) {
    case Mode_Dots: {
      [self layoutDots];
      break;
    }
    case Mode_Bar: {
      [self layoutBar];
      break;
    }
  }

  [self retrieveColors];
  [self updateViewColors: true];

  CGRect newPosition;

  if(self->anchorPosition != [PreferencesManager anchorPosition]){
    switch ([PreferencesManager anchorPosition]) {
      case Anchor_Left:{
        newPosition = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        break;
      }
      case Anchor_Right:{
        newPosition = CGRectMake([self.superview frame].size.width - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        break;
      }
      case Anchor_Center:{
        newPosition = CGRectMake([self.superview frame].size.width/2 - self.frame.size.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        break;
      }
    }

    if([PreferencesManager xOffsetEnabled]) {
      newPosition.origin.x += [PreferencesManager xOffset];
    }

    self.frame = newPosition;

    self->anchorPosition = [PreferencesManager anchorPosition];
  }
}

-(void) indicatorModeChanged {
  if (self->mode == [PreferencesManager indicatorMode]) {
    return;
  }

  switch (self->mode) {
    case Mode_Dots: {
      [self removeDots];
      break;
    }
    case Mode_Bar: {
      [self removeBar];
      break;
    }
  }

  self->mode = [PreferencesManager indicatorMode];
  [self relayout];
}

-(void) xChanged {
  CGRect newPosition;

  switch (self->anchorPosition) {
    case Anchor_Left:{
      newPosition = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
      break;
    }
    case Anchor_Right:{
      newPosition = CGRectMake([self.superview frame].size.width - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
      break;
    }
    case Anchor_Center:{
      newPosition = CGRectMake([self.superview frame].size.width/2 - self.frame.size.width/2, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
      break;
    }
  }

  if([PreferencesManager xOffsetEnabled]) {
    newPosition.origin.x += [PreferencesManager xOffset];
  }

  self.frame = newPosition;
}

-(void) yChanged {
  if ([PreferencesManager yOffsetEnabled]) {
    CGRect newPosition = CGRectMake(self.frame.origin.x, [self.superview frame].size.height * Y_PERCENTAGE + [PreferencesManager yOffset], self.frame.size.width, self.frame.size.height);
    self.frame = newPosition;
  }else if(![PreferencesManager yOffsetEnabled]) {
    CGRect newPosition = CGRectMake(self.frame.origin.x, [self.superview frame].size.height * Y_PERCENTAGE, self.frame.size.width, self.frame.size.height);
    self.frame = newPosition;
  }
}

-(void) updateBatteryLevel {
  if(self->mode == Mode_Dots) {
    [self updateViewColors];
  }else if(self->mode == Mode_Bar){
    [self updateBarPercentage];
  }
}

-(void) retrieveColors {
  self->primaryColor = [PreferencesManager primaryColor];
  self->secondaryColor = [PreferencesManager secondaryColor];
  self->chargingColor = [PreferencesManager chargingColor];
  self->lowPowerColor = [PreferencesManager lowPowerColor];
  self->individualColors = [PreferencesManager individualDotColors];
  self->hasChargingColor = [PreferencesManager hasChargingColor];
}

-(void) colorChanged {
  [self retrieveColors];
  [self updateViewColors: true]; // Force a recolor
}

-(void) updateViewColors {
  [self updateViewColors: false]; // Don't force a refresh of view colors.
}

-(void) updateViewColors: (bool) force {
  if(self->mode == Mode_Dots) {
    [self updateViewColorsDots: force];
  }else if(self->mode == Mode_Bar) {
    [self updateViewColorsBar];
  }
}

-(void) updateViewColorsDots: (bool) force {

  #ifdef DEBUG_BATTERY_PERCENTAGE
  int comparisonNumberOfDotsColored;
  switch([PreferencesManager roundingStyle]) {
    case Round_Up: {
      comparisonNumberOfDotsColored = ceilf([PreferencesManager numberOfDots] * DEBUG_BATTERY_PERCENTAGE);
      break;
    }
    case Round_Down: {
      comparisonNumberOfDotsColored = floorf([PreferencesManager numberOfDots] * DEBUG_BATTERY_PERCENTAGE);
      break;
    }
    case Round_Nearest: {
      comparisonNumberOfDotsColored = roundf([PreferencesManager numberOfDots] * DEBUG_BATTERY_PERCENTAGE);
      break;
    }
  }

  #else

  int comparisonNumberOfDotsColored;
  switch([PreferencesManager roundingStyle]) {
    case Round_Up: {
      comparisonNumberOfDotsColored = ceilf([PreferencesManager numberOfDots] * [UIDevice currentDevice].batteryLevel);
      break;
    }
    case Round_Down: {
      comparisonNumberOfDotsColored = floorf([PreferencesManager numberOfDots] * [UIDevice currentDevice].batteryLevel);
      break;
    }
    case Round_Nearest: {
      comparisonNumberOfDotsColored = roundf([PreferencesManager numberOfDots] * [UIDevice currentDevice].batteryLevel);
      break;
    }
  }
  #endif

  #ifdef DEBUG_BATTERY_PERCENTAGE
  if ([self isCharging] && [PreferencesManager numberOfDots] == comparisonNumberOfDotsColored && self->hasChargingColor && DEBUG_BATTERY_PERCENTAGE != 1.0f) {
    comparisonNumberOfDotsColored -= 1;
  }
  #else
  if ([self isCharging] && [PreferencesManager numberOfDots] == comparisonNumberOfDotsColored && self->hasChargingColor && [UIDevice currentDevice].batteryLevel != 1.0f) {
    comparisonNumberOfDotsColored -= 1;
  }
  #endif

  // Don't bother changing any colors, should improve performance.
  if(self->numberOfDotsColored == comparisonNumberOfDotsColored && !force) {
    return;
  }else {
    self->numberOfDotsColored = comparisonNumberOfDotsColored;
  }

  if ((!self->hasChargingColor || ![self isCharging] || (self->pulsingIndex >= 0 && self->pulsingIndex != self->numberOfDotsColored)) && self->chargingPulseAnimation != nil) {
    [self->dots[self->pulsingIndex].layer removeAllAnimations];
    self->chargingPulseAnimation = nil;
    self->pulsingIndex = -1;
  }

  bool individualDotColorsEnabled = [PreferencesManager individualDotColorsEnabled];
  bool lowPowerColorEnabled = [PreferencesManager lowPowerColorEnabled] && [[NSProcessInfo processInfo] isLowPowerModeEnabled];

  for(int i = 0; i < self->dots.count; i++) {
    if (i < self->numberOfDotsColored) {
      if (lowPowerColorEnabled) {
        self->dots[i].backgroundColor = self->lowPowerColor;
      }else if (individualDotColorsEnabled) {
        self->dots[i].backgroundColor = self->individualColors[i];
      }else {
        self->dots[i].backgroundColor = self->primaryColor;
      }
    #ifdef DEBUG_BATTERY_PERCENTAGE
    }else if ([self isCharging] && i == self->numberOfDotsColored && self->hasChargingColor && DEBUG_BATTERY_PERCENTAGE != 1.0f) {
    #else
    }else if ([self isCharging] && i == self->numberOfDotsColored && self->hasChargingColor && [UIDevice currentDevice].batteryLevel != 1.0f) {
    #endif
      self->dots[i].backgroundColor = self->chargingColor;
      self->pulsingIndex = i;

      if ([PreferencesManager pulseChargingColor]) {
        self->chargingPulseAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        self->chargingPulseAnimation.duration=[PreferencesManager fadeAnimationDuration];
        self->chargingPulseAnimation.repeatCount=HUGE_VALF;
        self->chargingPulseAnimation.autoreverses=YES;
        self->chargingPulseAnimation.fromValue=[NSNumber numberWithFloat:1.0];
        self->chargingPulseAnimation.toValue=[NSNumber numberWithFloat:0.0];

        //[self->dots[i].layer addAnimation:self->chargingPulseAnimation forKey:@"animateOpacity"];
      }
    }else {
      self->dots[i].backgroundColor = self->secondaryColor;
    }
  }
}

-(void) updateViewColorsBar {
  if([self isCharging] && self->hasChargingColor) {
    self->barFill.backgroundColor = self->chargingColor;
    if ([PreferencesManager pulseChargingColor] && self->chargingPulseAnimation == nil) {
      [self addBarAnimation];
    }
  }else {
    self->barFill.backgroundColor = self->primaryColor;
    [self removeAnimation];
  }

  self->bar.backgroundColor = self->secondaryColor;
}

-(void) fadeIn {
  if (self.alpha == 1.0f) {
    return; // So we don't get two fade ins
  }

  [self setAlpha: 0.0f];

  [UIView animateWithDuration: SELF_FADE_ANIMATION_DURATION animations:^{
        [self setAlpha:1.0f];
    } completion: nil];
}

-(void) fadeOut {
  if (self.alpha == 0.0f) {
    return; // So we don't get two fade outs
  }

  [self setAlpha: 1.0f];

  [UIView animateWithDuration: SELF_FADE_ANIMATION_DURATION animations:^{
        [self setAlpha:0.0f];
    } completion: nil];
}

-(void) animationChanged {
  if ([PreferencesManager pulseChargingColor]) {
    [self updateViewColors: true]; // This will create the animation on the right view whilst also checking the colors.
  } else {
    // We can manually remove the animation
    [self removeAnimation];
  }
}

-(void) fadeAnimationDurationChanged {
  [self removeAnimation];
  [self updateViewColors: true];
}

-(void) addBarAnimation {
  self->chargingPulseAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
  self->chargingPulseAnimation.duration=[PreferencesManager fadeAnimationDuration];
  self->chargingPulseAnimation.repeatCount=HUGE_VALF;
  self->chargingPulseAnimation.autoreverses=YES;
  self->chargingPulseAnimation.fromValue=[NSNumber numberWithFloat:1.0];
  self->chargingPulseAnimation.toValue=[NSNumber numberWithFloat:0.0];

  [self->barFill.layer addAnimation: self->chargingPulseAnimation forKey:@"animateOpacity"];
}

-(void) batteryStateChanged {
  // We call this because if the state changes to not charging we no longer want to show the pulsing charge color.
  [self updateViewColors: true]; // Force because the percentage charged may not have changed
}

-(bool) isCharging {
  return [UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull || [UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging;
}

-(void) removeDots {
  if (self->dots == nil) {
    return;
  }

  [self removeAnimation];

  while (self->dots.count > 0) {
    [self->dots[self->dots.count-1] removeFromSuperview];
    [self->dots removeLastObject];
  }
}

-(void) removeBar {
  [self removeAnimation];

  if(self->barFill != nil) {
    [self->barFill removeFromSuperview];
    self->barFill = nil;
  }

  if (self->bar != nil) {
    [self->bar removeFromSuperview];
    self->bar = nil;
  }
}

-(void) removeAnimation {
  if (self->mode == Mode_Dots) {
    if (self->dots == nil || self->dots.count == 0 || self->pulsingIndex < 0 || self->pulsingIndex > self->dots.count) {
      return;
    }
    [self->dots[self->pulsingIndex].layer removeAllAnimations];
  }else if(self->mode == Mode_Bar) {
    if(self->barFill == nil) {
      return;
    }
    [self->barFill.layer removeAllAnimations];
  }

  self->pulsingIndex = -1;
  self->chargingPulseAnimation = nil;
}

// Default protocol implementations. Sub-classes should re-implement these
-(void) layoutDots{

}

-(void) layoutBar {

}

-(void) lengthChanged {

}

-(void) updateBarPercentage {

}
@end
