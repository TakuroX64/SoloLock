#import <UIKit/UIKit.h>
#import <notify.h>

#define PREF_PATH @"/var/jb/var/mobile/Library/Preferences/com.yourname.sololock.plist"

static BOOL isEnabled = YES;
static NSString *targetBundleID = @"";

static void loadPreferences() {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    if (prefs) {
        isEnabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
        targetBundleID = [prefs objectForKey:@"targetApp"] ?: @"";
    }
}

@interface SBApplication : NSObject
- (NSString *)bundleIdentifier;
@end

@interface SpringBoard : UIApplication
- (SBApplication *)_accessibilityFrontMostApplication;
- (void)launchApplicationWithIdentifier:(NSString *)bundleID suspended:(BOOL)suspended;
@end

@interface SBHomeGesturePanGestureRecognizer : UIGestureRecognizer
@end

// Checks if the user is currently looking at the designated app
static BOOL isTargetAppActive() {
    if (!targetBundleID || [targetBundleID isEqualToString:@""]) return NO;
    SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
    if ([sb respondsToSelector:@selector(_accessibilityFrontMostApplication)]) {
        SBApplication *frontApp = [sb _accessibilityFrontMostApplication];
        if (frontApp && [[frontApp bundleIdentifier] isEqualToString:targetBundleID]) {
            return YES;
        }
    }
    return NO;
}

// 1. Launch target app after unlocking if not already active
%hook CSCoverSheetViewController

- (void)viewDidDisappear:(BOOL)animated {
    %orig;
    loadPreferences();
    
    if (isEnabled && targetBundleID.length > 0) {
        if (!isTargetAppActive()) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SpringBoard *sb = (SpringBoard *)[UIApplication sharedApplication];
                [sb launchApplicationWithIdentifier:targetBundleID suspended:NO];
            });
        }
    }
}

%end

// 2. Block the swipe-up (Home Bar / App Switcher) gesture strictly when target app is active
%hook SBHomeGesturePanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isEnabled && isTargetAppActive()) {
        // Cancel the gesture immediately, locking the user in the app
        [self setState:UIGestureRecognizerStateFailed];
        return;
    }
    %orig;
}

%end

// 3. Listen for dynamic toggles from Settings and Control Center
%ctor {
    loadPreferences();
    int token;
    notify_register_dispatch("com.yourname.sololock/ReloadPrefs", &token, dispatch_get_main_queue(), ^(int t) {
        loadPreferences();
    });
}
