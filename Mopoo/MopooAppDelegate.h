//
//  MopooAppDelegate.h
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalSubstitutionCache.h"
#import "Reachability.h"
@class Reachability;
@interface MopooAppDelegate : NSObject <UIApplicationDelegate> {
    LocalSubstitutionCache * _localSubstitutionCache;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

-(void) asyncSetLoadRemoteFlag;
-(void) showLoginViewController;
-(void) showRootViewController;
-(void) showTopicViewController: (NSString *) topicId;
-(void) reloadTopicViewData;
-(void) reloadTopicListViewData;
+(MopooAppDelegate *) sharedApplication;
+(void) alert:(NSString *) msg;
@end
