@interface CircleView : UIView {
  float percentageFilled;
  UIColor* fillColor;
  CABasicAnimation* chargingPulseAnimation;
  CAShapeLayer* circleLayer;
}

- (id)initWithFrame:(CGRect)frame
    withPercentageFilled:(float)percentageFilled
           withFillColor:(UIColor*)fillColor;

- (void)drawCircle;

- (void)setPercentageFilled:(float)percentageFilled;
- (void)setFillColor:(UIColor*)fillColor;

- (void)createAnimation;
- (void)removeAnimation;
@end