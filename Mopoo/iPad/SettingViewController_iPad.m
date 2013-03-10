//
//  SettingViewController_iPad.m
//  Mopoo
//
//  Created by altchen on 11-9-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController_iPad.h"


@implementation SettingViewController_iPad


-(void) closeButtonClick
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
