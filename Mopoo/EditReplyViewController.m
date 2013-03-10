//
//  EditReplyViewController.m
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "EditReplyViewController.h"
#import "MBProgressHUD.h"
#import "MopooAppDelegate.h"
#import "MopooRemoteServer.h"

@implementation EditReplyViewController
@synthesize replyTextView=_replyTextView;
@synthesize topicId=_topicId,replyId=_replyId,text=_text;
-(id)initWithId:(NSString *)topicId replayId:(NSString *)editReplyId replayText:(NSString *)text
{
    self = [super init];
    if (self) {
        [self setTopicId:topicId];
        [self setReplyId:editReplyId];
        [self setText:text];
    }
    return self;
}
-(void) editButtonClick
{
    if ([_replyTextView.text length] <=0) {
        return;
    }
    [_replyTextView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [[MopooRemoteServer sharedRemoteServer] doEditReply:_topicId editReplyId:_replyId replyText:_replyTextView.text];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                [alert show];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"修改回复失败，请销等再试"];
            });
        }
    });
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REPLY_SUCCESS" object:self];
    [[self navigationController] popViewControllerAnimated:YES]; 
}
-(void) delButtonClick
{
    [_replyTextView resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [[MopooRemoteServer sharedRemoteServer] delReply:_topicId editReplyId:_replyId];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                [alert show];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"删除回复失败，请销等再试"];
            });
        }
    });   
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
    [_replyTextView setText:_text];
    [_replyTextView becomeFirstResponder];
    [self setTitle:@"修改回复"];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
