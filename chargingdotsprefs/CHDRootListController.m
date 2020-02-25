#include "CHDRootListController.h"
#import "../source/PreferencesManager.h"
#include <spawn.h>

@implementation CHDRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void) respring {
  pid_t pid;
	int status;

	//Execute on the commandline; killall to kill the SpringBoard and force it to reload
  const char* args[] = {"killall", "-9", "SpringBoard", NULL};
  posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
  waitpid(pid, &status, WEXITED);
}

-(void) resetSettings {
	[PreferencesManager resetSettings];
	[self respring]; // A respring is required because we also reset the enabled toggle.
}
@end
