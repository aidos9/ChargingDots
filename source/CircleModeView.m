#import "CircleModeView.h"
#import "PreferencesManager.h"

#define DegreesToRadians(x) ((x)*M_PI / 180.0)
#define CIRCLE_OFFSET DegreesToRadians(-90)

@implementation CircleModeView

- (id)initWithFrame:(CGRect)frame
    withPercentageFilled:(float)iPercentageFilled
           withFillColor:(UIColor *)iFillColor {
  self = [super initWithFrame:frame];

  self->fillColor = iFillColor;
  self->percentageFilled = iPercentageFilled;

  self.layer.cornerRadius = self.frame.size.height / 2;
  self.layer.masksToBounds = true;

  return self;
}

- (void)drawCircle {
  self->circleLayer = [CAShapeLayer layer];

  CGFloat radius = self.frame.size.width / 2;
  // We need an offset because otherwise it will start from essentially pi/2 rad which is not what
  // we want.
  CGFloat startAngle = CIRCLE_OFFSET;
  CGFloat endAngle = DegreesToRadians(360) * self->percentageFilled +
                     CIRCLE_OFFSET;  // Ensure we account for the offset

  CGPoint center = CGPointMake(radius, radius);
  UIBezierPath *arc = [UIBezierPath bezierPath];
  [arc moveToPoint:center];

  CGPoint next;
  next.x = center.x + radius * cos(startAngle);
  next.y = center.y + radius * sin(startAngle);
  [arc addLineToPoint:next];  // go one end of arc

  [arc addArcWithCenter:center
                 radius:radius
             startAngle:startAngle
               endAngle:endAngle
              clockwise:true];  // add the arc
  [arc addLineToPoint:center];  // back to center

  self->circleLayer.path = arc.CGPath;
  self->circleLayer.lineWidth = 0.0;
  self->circleLayer.fillColor = self->fillColor.CGColor;
  self->circleLayer.strokeColor = [UIColor clearColor].CGColor;
  self->circleLayer.backgroundColor = [UIColor clearColor].CGColor;
  self->circleLayer.position = CGPointMake(0, 0);

  [self.layer addSublayer:self->circleLayer];
}

- (void)setPercentageFilled:(float)iPercentageFilled {
  self->percentageFilled = iPercentageFilled;
  [self->circleLayer removeFromSuperlayer];
  [self drawCircle];
}

- (void)setFillColor:(UIColor *)iFillColor {
  self->fillColor = iFillColor;
  [self->circleLayer removeFromSuperlayer];
  [self drawCircle];
}

- (void)createAnimationWithDuration:(float)duration {
  self->chargingPulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  self->chargingPulseAnimation.duration = duration;
  self->chargingPulseAnimation.repeatCount = HUGE_VALF;
  self->chargingPulseAnimation.autoreverses = YES;
  self->chargingPulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
  self->chargingPulseAnimation.toValue = [NSNumber numberWithFloat:0.0];

  [self->circleLayer addAnimation:self->chargingPulseAnimation forKey:@"animateOpacity"];
}

- (void)removeAnimation {
  [self->circleLayer removeAllAnimations];
  self->chargingPulseAnimation = nil;
}
@end
