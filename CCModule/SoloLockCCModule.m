#import "SoloLockCCModule.h"
#import <notify.h>

#define PREF_PATH @"/var/jb/var/mobile/Library/Preferences/com.yourname.sololock.plist"

@implementation SoloLockCCModule

- (BOOL)isSelected {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    return prefs && [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
}

- (void)setSelected:(BOOL)selected {
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:PREF_PATH] ?: [NSMutableDictionary dictionary];
    [prefs setObject:@(selected) forKey:@"enabled"];
    [prefs writeToFile:PREF_PATH atomically:YES];
    notify_post("com.yourname.sololock/ReloadPrefs");
    [super refreshState];
}

- (UIImage *)iconGlyph {
    return [UIImage systemImageNamed:@"lock.fill"];
}

- (UIColor *)selectedColor {
    return [UIColor systemBlueColor];
}

@end
