#include "CHDColoursRootListController.h"

@implementation CHDColoursRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"ColoursRoot" target:self];
	}

	return _specifiers;
}

@end
