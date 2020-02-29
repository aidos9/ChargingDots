#include "CHDWidgetLayoutListController.h"

@implementation CHDWidgetLayoutListController

- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"WidgetLayout" target:self];
  }

  return _specifiers;
}

@end
