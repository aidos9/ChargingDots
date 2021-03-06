#import "ChargingParentViewHorizontal.h"
#import "PreferencesManager.h"

// For explanations of what each method does see the header.
@implementation ChargingParentViewHorizontal

- (void)updateBarPercentage {
  if (self->barFill == nil) {
    return;
  }

  CGFloat height = self.frame.size.height * [PreferencesManager dotRadius];
#ifdef DEBUG_BATTERY_PERCENTAGE
  CGRect fillBarRect =
      CGRectMake(0, 0, self->bar.frame.size.width * DEBUG_BATTERY_PERCENTAGE, height);
#else
  CGRect fillBarRect =
      CGRectMake(0, 0, self->bar.frame.size.width * [UIDevice currentDevice].batteryLevel, height);
#endif
  self->barFill.frame = fillBarRect;
}

- (void)lengthChanged {
  // Simple sanity check to ensure that the value actually changed because this calls relayout which
  // is expensive.
  if (self->lengthConstant != [PreferencesManager parentViewLength]) {
    self->lengthConstant = [PreferencesManager parentViewLength];
    CGFloat width = [self.superview frame].size.width * [PreferencesManager parentViewLength];
    CGRect newPosition =
        CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    self.frame = newPosition;
    [self relayout];
    [self xChanged];  // We call this here because we want to ensure that since the center position
                      // has changed that we are still centered.
  }
}

- (void)layoutDots {
  if (self->dots == nil) {
    self->dots = [[NSMutableArray alloc] init];
  }

  [self removeDots];

  int numberOfDots = [PreferencesManager numberOfDots];
  CGFloat dotDiameter =
      self.frame.size.height * 0.95 *
      [PreferencesManager dotRadius];  // Since dotRadius is a percentage value anyway
  CGFloat spacing = (self.frame.size.width - dotDiameter * numberOfDots) /
                    (numberOfDots + 1);  // +1 to account for spacing after the last dot
  int dotIndex = 0;

  while (self->dots.count < numberOfDots) {
    // spacing + spacing * dotIndex + dotIndex * dotDiameter = (spacing * (dotIndex + 1)) +
    // (dotIndex * dotDiameter) This basically allows us to have an offset from the start of the
    // view and then spacing inbetween the previous dots and for this dot plus the width of the
    // previous dots.
    CGRect frame =
        CGRectMake(spacing + spacing * dotIndex + dotIndex * dotDiameter,
                   self.frame.size.height / 2 - dotDiameter / 2, dotDiameter, dotDiameter);
    UIView* newView = [[UIView alloc] initWithFrame:frame];
    newView.layer.cornerRadius = dotDiameter / 2;
    newView.layer.masksToBounds = true;
    [self addSubview:newView];
    // Here we append because unlike the vertical layout the last view we add is the last view we
    // want coloured
    [self->dots addObject:newView];
    dotIndex++;
  }
}

- (void)layoutBar {
  // Simple sanity check to ensure that the bar does not exist already.
  // Remove it if it does.
  if (self->bar != nil && self->barFill != nil) {
    [self removeBar];
  }

  CGFloat height = self.frame.size.height * [PreferencesManager dotRadius];
  CGRect mainBarRect =
      CGRectMake(0, self.frame.size.height / 2 - height / 2, self.frame.size.width, height);
  self->bar = [[UIView alloc] initWithFrame:mainBarRect];
  self->bar.layer.cornerRadius = height / 2;
  self->bar.layer.masksToBounds = true;
  [self addSubview:self->bar];

#ifdef DEBUG_BATTERY_PERCENTAGE
  CGRect fillBarRect =
      CGRectMake(0, 0, self->bar.frame.size.width * DEBUG_BATTERY_PERCENTAGE, height);
#else
  CGRect fillBarRect =
      CGRectMake(0, 0, self->bar.frame.size.width * [UIDevice currentDevice].batteryLevel, height);
#endif

  self->barFill = [[UIView alloc] initWithFrame:fillBarRect];
  [self->bar addSubview:self->barFill];
}

- (void)layoutCircle {
  if (self->circleView != nil) {
    [self removeCircle];
  }

  CGFloat circleDiameter =
      self.frame.size.width *
      [PreferencesManager dotRadius];  // Since dotRadius is a percentage value anyway

  CGRect circleLocation =
      CGRectMake(self.frame.size.width / 2 - circleDiameter / 2, 0, circleDiameter, circleDiameter);

#ifdef DEBUG_BATTERY_PERCENTAGE
  self->circleView = [[CircleModeView alloc] initWithFrame:circleLocation
                                      withPercentageFilled:DEBUG_BATTERY_PERCENTAGE
                                             withFillColor:self->primaryColor];
#else
  self->circleView = [[CircleModeView alloc] initWithFrame:circleLocation
                                      withPercentageFilled:[UIDevice currentDevice].batteryLevel
                                             withFillColor:self->primaryColor];
#endif
  [self addSubview:self->circleView];
  [self->circleView drawCircle];
}

- (void)layoutOutline {
  if (self->outlineView != nil) {
    [self removeOutline];
  }

  CGFloat circleDiameter =
      self.frame.size.width *
      [PreferencesManager dotRadius];  // Since dotRadius is a percentage value anyway

  CGRect circleLocation =
      CGRectMake(self.frame.size.width / 2 - circleDiameter / 2, 0, circleDiameter, circleDiameter);

#ifdef DEBUG_BATTERY_PERCENTAGE
  self->outlineView =
      [[OutlineModeView alloc] initWithFrame:circleLocation
                        withPercentageFilled:DEBUG_BATTERY_PERCENTAGE
                               withFillColor:self->primaryColor
                              withEmptyColor:self->outlineEmptyColor
                               withLineWidth:[PreferencesManager outlineBorderThickness]
                           withBackdropColor:self->secondaryColor];
#else
  self->outlineView =
      [[OutlineModeView alloc] initWithFrame:circleLocation
                        withPercentageFilled:[UIDevice currentDevice].batteryLevel
                               withFillColor:self->primaryColor
                              withEmptyColor:self->outlineEmptyColor
                               withLineWidth:[PreferencesManager outlineBorderThickness]
                           withBackdropColor:self->secondaryColor];
#endif
  [self addSubview:self->outlineView];
  [self->outlineView drawCircle];
}

@end
