//
//  PostTopicViewController_iPad.m
//  Mopoo
//
//  Created by altchen on 11-9-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostTopicViewController_iPad.h"


@implementation PostTopicViewController_iPad


-(void) closePostViewController
{
    [self dismissModalViewControllerAnimated:YES]; 
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_TOPIC_SUCCESS" object:nil];    
    [self closePostViewController];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
