//
//  ReplyViewController.m
//  Mopoo
//
//  Created by altchen on 11-9-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ReplyViewController.h"
#import "MBProgressHUD.h"
#import "MopooRemoteServer.h"
#import "MopooAppDelegate.h"
@implementation ReplyViewController
@synthesize replyTipLabel = _replyTipLabel;

@synthesize replyContentTextView=_replyContentTextView,niminSwitch=_niminSwitch,sumitButton=_sumitButton,topicId=_topicId,lc=_lc,oldReply=_oldReply;


-(id) initWithTopicId:(NSString *)topicId
{
    self = [super init];
    if (self) {
        _topicId = topicId;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"回复"];
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
-(void) submitClick
{
    if ([_replyContentTextView.text length]<=0) {
        return;
    }
    [_replyContentTextView resignFirstResponder];        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL sucess = [[MopooRemoteServer sharedRemoteServer] doReply:_topicId replayText:_replyContentTextView.text nimin: [_niminSwitch isOn] lc:_lc lcText:_oldReply];
        if (sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"回复成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                [alert show];
                 
            });
             
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"回复失败，请销等再试"];
            });            
        }
    });
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REPLY_SUCCESS" object:nil];
    [[self navigationController] popViewControllerAnimated:YES]; 
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [_replyContentTextView becomeFirstResponder];
    [_niminSwitch setOn:FALSE];
    if (_lc!=nil && _oldReply != nil) {
        NSString * newText = [NSString stringWithFormat:@"回复:引用(%@)楼",_lc];
        [_replyTipLabel setText:newText];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    _replyTipLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void) setReplyLcAndText:(NSString *) lc withText:(NSString *) text
{
    _lc=lc;
    _oldReply = text;    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
