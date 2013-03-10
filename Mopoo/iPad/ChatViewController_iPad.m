//
//  ChatViewController_iPad.m
//  Mopoo
//
//  Created by altchen on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController_iPad.h"
#import "NewChatViewController_iPad.h"

@implementation ChatViewController_iPad

-(void) newChatButtonClick
{
    NewChatViewController * chatController = [[NewChatViewController_iPad alloc] init];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
