//
//  test8Ball.x
//  test 8Ball
//
//  Created by iMokhles on 12.09.2015.
//  Copyright (c) 2015 iMokhles. All rights reserved.
//

#import "test8BallHelper.h"

%group main

BOOL isTweakEnabled;
static void test8Ball_Prefs() {
	NSDictionary *test8BallSettings = [NSDictionary dictionaryWithContentsOfFile:[test8BallHelper preferencesPath]];
	NSNumber *isTweakEnabledNU = test8BallSettings[@"isTweakEnabled"];
    isTweakEnabled = isTweakEnabledNU ? [isTweakEnabledNU boolValue] : 0;
}

@interface UserInfo : NSObject
+ (void)releaseSharedUserInfo;
+ (id)sharedUserInfo;
@property(copy) NSString *userId; // @synthesize userId=mUserId;
@property(nonatomic) int level; // @synthesize level=mLevel;
@end

@interface MenuManager : NSObject
+ (void)releaseSharedMenuManager;
+ (id)sharedMenuManager;
@property(nonatomic) BOOL isOnOfflineMode; // @synthesize isOnOfflineMode=mIsOnOfflineMode;
@end

// updateCueStats

// NotificationUserInfoChanged
// NotificationUserInfoCueInfoChanged

%hook AppDelegate
- (void)applicationDidBecomeActive:(id)arg1 {
	%orig;
	if (![[%c(MenuManager) sharedMenuManager] isOnOfflineMode]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUserInfoChanged" object:nil userInfo:nil];
		// [[NSUserDefaults standardUserDefaults] setInteger:100 forKey:[NSString stringWithFormat:@"UserLevel%@",[[%c(UserInfo) sharedUserInfo] userId]]];
		[[%c(UserInfo) sharedUserInfo] setLevel:100];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationUserInfoChanged" object:nil userInfo:nil];
	}
}
%end

%end


%ctor {
	@autoreleasepool {
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *block) {
	        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)test8Ball_Prefs, [test8BallHelper preferencesChanged], NULL, 0);
	        test8Ball_Prefs();
	 
	    }];
		%init(main);
	}
}
