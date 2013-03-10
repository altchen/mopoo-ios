//
//  RootViewController.m
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MopooAppDelegate.h"
#import "MopooRemoteServer.h"
#import "MBProgressHUD.h"
#import "NSURL+SSToolkitAdditions.h"
#import "PostTopicViewController.h"
#import "ASIHTTPRequest.h"
#import "SettingViewController.h"
#import "ChatViewController.h"
#import "MoreListViewController.h"
@interface RootViewController()
-(void) renewWebView;
@end
@implementation RootViewController
@synthesize webView=_webView;
- (void)viewDidLoad
{
    [_webView setDelegate:self];
    [self reloadWebView];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePostSuccess) name:@"POST_TOPIC_SUCCESS" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) receivePostSuccess
{
    [self reloadWebView];
}
-(void) reloadWebView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * html = [[MopooRemoteServer sharedRemoteServer] fetchTopicListHtml:TRUE useRemote:TRUE];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self renewWebView];
            [[self webView ] loadHTMLString:html baseURL:[NSURL URLWithString:@"https://www.253874.com/new/"] ];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    });
}
-(void) renewWebView
{
    UIWebView * oldWebView = [self webView];
    [oldWebView stopLoading];
    UIWebView * newWebView = [[UIWebView alloc] initWithFrame:[oldWebView frame]];
    newWebView.delegate= self;
    newWebView.autoresizingMask = oldWebView.autoresizingMask;
    newWebView.scalesPageToFit = oldWebView.scalesPageToFit;
    [self.view addSubview:newWebView];
    [[self webView] removeFromSuperview];
    [self setWebView:newWebView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        NSString * url = [[request URL] absoluteString];
        if ([url rangeOfString:@"info2.asp?id="].length >0) {
            NSDictionary * dict = [[request URL] queryDictionary];
            NSString * topicId = [dict valueForKey:@"id"];
            [self showTopicViewController:topicId];
        }
        return NO;
    }
    return YES;
}
-(void) showTopicViewController:(NSString *)topicId
{
    [[MopooAppDelegate sharedApplication] showTopicViewController:topicId];
}
-(void) refreshButtonClick
{
    [self reloadWebView];
}
-(void) postTopicButtonClick
{
    PostTopicViewController * postController = [[PostTopicViewController alloc] init];
    [[self navigationController ] pushViewController:postController animated:YES];
}
-(void) logoutButtonClick
{
    [[MopooRemoteServer sharedRemoteServer] logout];
    [[MopooAppDelegate sharedApplication] showLoginViewController];
}
-(void) actionButtonClick
{
    UIActionSheet * actinShell = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"注销",@"设置",@"留言板",@"更多功能",nil];
    [actinShell showInView:self.view];
    

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0 ){
        [self logoutButtonClick];
    }else if (buttonIndex ==1) {
        SettingViewController * settingController = [[SettingViewController alloc] init];
        [[self navigationController] pushViewController:settingController animated:YES];
    }else if (buttonIndex ==2){
        ChatViewController * chatController = [[ChatViewController alloc] init];
        [self.navigationController pushViewController:chatController animated:YES];
    }else if ( buttonIndex == 3 ){
        MoreListViewController * moreController = [[MoreListViewController alloc]init];
        [self.navigationController pushViewController:moreController animated:YES];
    }
}

#pragma view method

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

	[super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end
