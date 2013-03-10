//
//  LoginViewController_iPad.m
//  Mopoo
//
//  Created by altchen on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController_iPad.h"
#import "MopooAppDelegate_iPad.h"

@implementation LoginViewController_iPad

-(void) showTopicViewController{
    [[MopooAppDelegate_iPad sharedApplication] showTopicListViewController];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end
