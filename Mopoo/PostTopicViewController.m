//
//  PostTopicViewController.m
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostTopicViewController.h"
#import "MBProgressHUD.h"
#import "MopooAppDelegate.h"
#import "MopooRemoteServer.h"

@implementation PostTopicViewController
@synthesize titleTextField=_titleTextField,bodyTextView=_bodyTextView,niminSwitch=_niminSwitch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) sumitButtonClick
{
    if ([_titleTextField.text length]<=0 || [_bodyTextView.text length] <=0) {
        return;
    }
    [_bodyTextView resignFirstResponder];
    [_titleTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [[MopooRemoteServer sharedRemoteServer] postNewTopic:_titleTextField.text body:_bodyTextView.text nimin:
                        [_niminSwitch isOn]];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发帖成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                [alert show];

            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"发帖失败，请销等再试"];
            });
        }
    });
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_TOPIC_SUCCESS" object:nil];  
    [[self navigationController] popViewControllerAnimated:YES];
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
    [self setTitle:@"发帖"];
    [_niminSwitch setOn:NO];
    [_titleTextField becomeFirstResponder];
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
