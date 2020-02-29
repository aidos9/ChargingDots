#include "CHDColourAssignmentListController.h"

@implementation CHDColourAssignmentListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"ColourAssignment" target:self];
	}

	return _specifiers;
}

@end
