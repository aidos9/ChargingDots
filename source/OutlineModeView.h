@interface OutlineModeView : UIView {
  float percentageFilled;
  float lineWidth;
  UIColor* fillColor;
  UIColor* emptyColor;
  UIColor* backdropColor;
  CABasicAnimation* chargingPulseAnimation;
  CAShapeLayer* fillLayer;
  CAShapeLayer* trackLayer;
  CAShapeLayer* backdropLayer;
}

- (id)initWithFrame:(CGRect)frame
    withPercentageFilled:(float)percentageFilled
           withFillColor:(UIColor*)fillColor
          withEmptyColor:(UIColor*)emptyColor
           withLineWidth:(float)lineWidth
       withBackdropColor:(UIColor*)backdropColor;

- (void)drawCircle;
- (void)redoColours; // Convenience method so that we don't have to constantly redraw.

- (void)setPercentageFilled:(float)percentageFilled;
- (void)setFillColor:(UIColor*)fillColor;
- (void)setEmptyColor:(UIColor*)emptyColor;
- (void)setLineWidth:(float)lineWidth;
- (void)setBackdropColor:(UIColor*)backdropColor;

- (void)createAnimationWithDuration:(float)duration;
- (void)removeAnimation;

- (void)removeAdditionalLayers;
@end
