#import "OutlineModeView.h"
#import "PreferencesManager.h"

#define DegreesToRadians(x) ((x)*M_PI / 180.0)
#define CIRCLE_OFFSET DegreesToRadians(-90)

@implementation OutlineModeView

- (id)initWithFrame:(CGRect)frame
    withPercentageFilled:(float)iPercentageFilled
           withFillColor:(UIColor *)iFillColor
          withEmptyColor:(UIColor *)iEmptyColor
           withLineWidth:(float)iLineWidth
       withBackdropColor:(UIColor *)iBackdropColor {
  self = [super initWithFrame:frame];

  self->fillColor = iFillColor;
  self->percentageFilled = iPercentageFilled;
  self->backdropColor = iBackdropColor;
  self->emptyColor = iEmptyColor;
  self->lineWidth = iLineWidth;

  return self;
}

- (void)drawCircle {
  CGFloat radius = self.frame.size.width / 2;


  // Create the backdropLayer
  self->backdropLayer = [CAShapeLayer layer];

  // We need an offset because otherwise it will start from essentially pi/2 rad which is not what
  UIBezierPath *arc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                     radius:radius
                                                 startAngle:CIRCLE_OFFSET
                                                   endAngle:DegreesToRadians(360) + CIRCLE_OFFSET
                                                  clockwise:true];

  self->backdropLayer.path = arc.CGPath;
  self->backdropLayer.lineWidth = 0;
  self->backdropLayer.strokeColor = [UIColor clearColor].CGColor;
  self->backdropLayer.fillColor = self->backdropColor.CGColor;
  self->backdropLayer.position = CGPointMake(0, 0);

  [self.layer addSublayer: self->backdropLayer];

  // Create the track layer
  self->trackLayer = [CAShapeLayer layer];
  self->trackLayer.path = arc.CGPath;
  self->trackLayer.lineWidth = self->lineWidth;
  self->trackLayer.strokeColor = self->emptyColor.CGColor;
  self->trackLayer.fillColor = [UIColor clearColor].CGColor;
  self->trackLayer.backgroundColor = [UIColor clearColor].CGColor;
  self->trackLayer.position = CGPointMake(0, 0);

  [self.layer addSublayer:self->trackLayer];

  // Create the fill layer
  self->fillLayer = [CAShapeLayer layer];
  self->fillLayer.path = arc.CGPath;
  self->fillLayer.lineWidth = self->lineWidth;
  self->fillLayer.strokeColor = self->fillColor.CGColor;
  self->fillLayer.fillColor = [UIColor clearColor].CGColor;
  self->fillLayer.backgroundColor = [UIColor clearColor].CGColor;
  self->fillLayer.position = CGPointMake(0, 0);
  self->fillLayer.lineCap = kCALineCapRound;
  self->fillLayer.strokeEnd = self->percentageFilled;

  [self.layer addSublayer:self->fillLayer];
}

- (void)redoColours {
  self->fillLayer.strokeColor = self->fillColor.CGColor;
  self->trackLayer.strokeColor = self->emptyColor.CGColor;
  self->backdropLayer.fillColor = self->backdropColor.CGColor;
}

- (void)setPercentageFilled:(float)iPercentageFilled {
  self->percentageFilled = iPercentageFilled;
  self->fillLayer.strokeEnd = self->percentageFilled;
}

- (void)setFillColor:(UIColor *)iFillColor {
  self->fillColor = iFillColor;
}

- (void)setEmptyColor:(UIColor *)iEmptyColor {
  self->emptyColor = iEmptyColor;
}

- (void)setLineWidth:(float)iLineWidth {
  self->lineWidth = iLineWidth;
  [self removeAdditionalLayers];
  [self drawCircle];
}

- (void)setBackdropColor:(UIColor *)iBackdropColor {
  self->backdropColor = iBackdropColor;
}

- (void)createAnimationWithDuration:(float)duration {
  self->chargingPulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  self->chargingPulseAnimation.duration = duration;
  self->chargingPulseAnimation.repeatCount = HUGE_VALF;
  self->chargingPulseAnimation.autoreverses = YES;
  self->chargingPulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
  self->chargingPulseAnimation.toValue = [NSNumber numberWithFloat:0.0];

  [self->fillLayer addAnimation:self->chargingPulseAnimation forKey:@"animateOpacity"];
}

- (void)removeAnimation {
  [self->fillLayer removeAllAnimations];
  self->chargingPulseAnimation = nil;
}

- (void)removeAdditionalLayers {
  if (self->fillLayer != nil) {
    [self->fillLayer removeFromSuperlayer];
  }

  if (self->trackLayer != nil) {
    [self->trackLayer removeFromSuperlayer];
  }

  if (self->backdropLayer != nil) {
    [self->backdropLayer removeFromSuperlayer];
  }
}
@end
