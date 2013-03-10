//
//  MopooAppDelegate.h
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSubstitutionCache.h"
#import "MGSplitViewController.h"
#import "Reachability.h"
@class Reachability;
@interface MopooAppDelegate_iPad : NSObject <UIApplicationDelegate> {
    LocalSubstitutionCache * _localSubstitutionCache;
    MGSplitViewController * _splitViewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet MGSplitViewController * splitViewController;
-(void) asyncSetLoadRemoteFlag;
-(void) showLoginViewController;
-(void) showTopicListViewController;
+(MopooAppDelegate_iPad *) sharedApplication;
+(void) alert:(NSString *) msg;
@end
