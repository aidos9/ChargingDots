// These are forward declarations of view that we are hooking into.

@interface SBFLockScreenDateSubtitleDateView : UIView
- (void)toggleHidden;
@end

// The view that this controller looks after is CSMainPageView
@interface CSMainPageContentViewController : UIViewController
- (void)checkAndUpdateManager;
- (void)orientationChanged;
@end
