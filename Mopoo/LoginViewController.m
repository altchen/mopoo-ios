//
//  LoginViewController.m
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "MopooAppDelegate.h"
#import "MBProgressHUD.h"
#import "MopooRemoteServer.h"
#import "MopooUserDefaults.h"
@implementation LoginViewController
@synthesize userTextField = _userTextField,passwordTextField = _passwordTextField,loginButton = _loginButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) loginButtonClick
{
    [_userTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{       
        BOOL success = [[MopooRemoteServer sharedRemoteServer] login: [_userTextField text] withPassword:[_passwordTextField text]];
        if(success){
            [[MopooUserDefaults sharedUserDefaults] setLoginUser: [_userTextField text]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showTopicViewController];
            });            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"里屋" message:@"登录失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });             
        }     
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[self view] animated:YES];
        });        
        
    });
    
}
-(void) showTopicViewController
{
    [[MopooAppDelegate sharedApplication] showRootViewController];   
}
-(void) textFieldValueChange
{
    if ([[_userTextField text] length] !=0 && [[_passwordTextField text] length]!=0) {
        [_loginButton setEnabled:YES];
    }else {
        [_loginButton setEnabled:NO];
    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
