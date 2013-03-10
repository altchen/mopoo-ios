//
//  NewChatViewController.m
//  Mopoo
//
//  Created by altchen on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewChatViewController.h"
#import "MopooRemoteServer.h"
#import "MBProgressHUD.h"

@implementation NewChatViewController

@synthesize messageTextView=_messageTextView;

#pragma mark - my code

-(void) sendButtonClick
{
    if ([_messageTextView.text length] <=0) {
        return;
    }
    [_messageTextView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[MopooRemoteServer sharedRemoteServer] sendChat:_messageTextView.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([MopooRemoteServer sharedRemoteServer].error==nil) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"留言成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"留言失败,请销后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        });
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEND_CHAT_SUCCESS" object:nil];    
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
    [self setTitle:@"留言"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.messageTextView=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
