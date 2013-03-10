//
//  MopooAppDelegate.m
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MopooAppDelegate_iPad.h"
#import "MopooUserDefaults.h"
#import "LoginViewController_iPad.h"
#import "MopooRemoteServer.h"
@interface MopooAppDelegate_iPad(Private)
@end

@implementation MopooAppDelegate_iPad
@synthesize window=_window;

@synthesize splitViewController=_splitViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    _localSubstitutionCache = [[LocalSubstitutionCache alloc] init];
	[NSURLCache setSharedURLCache:_localSubstitutionCache]; 
    [self asyncSetLoadRemoteFlag];
    
    //_splitViewController.splitPosition = 340;
    if (![[MopooRemoteServer sharedRemoteServer] isLogin ])
    {
        [self showLoginViewController];
    }
    else
    {
        [self showTopicListViewController];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) showLoginViewController
{
    LoginViewController_iPad * loginController = [[LoginViewController_iPad alloc] init];
    self.window.rootViewController = loginController;
}
-(void) showTopicListViewController
{
        self.window.rootViewController = _splitViewController;
      
}
+(MopooAppDelegate_iPad *) sharedApplication
{
    return (MopooAppDelegate_iPad *) [[UIApplication sharedApplication] delegate];
}
+(void) alert:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}


-(void) asyncSetLoadRemoteFlag
{
    MopooUserDefaults * userDefaults = [MopooUserDefaults sharedUserDefaults];
    if (userDefaults.onlyWifiLoadImageFlag==FALSE) {
        [_localSubstitutionCache setIsLoadRemoteImage:YES];
    }else{        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Reachability * curReach = [Reachability reachabilityForLocalWiFi];
            if ([curReach currentReachabilityStatus]==ReachableViaWiFi) {
                ACLog(@"设置加载图片：%@",@"true");
                [_localSubstitutionCache setIsLoadRemoteImage:YES];
            }else{
                ACLog(@"设置加载图片：%@",@"false");
                [_localSubstitutionCache setIsLoadRemoteImage:NO];
            }
        });
    }  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
