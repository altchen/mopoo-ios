//
//  RootViewController.m
//  SplitDemo
//
//  Created by altchen on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopicListViewController_iPad.h"
#import "MopooAppDelegate_iPad.h"
#import "TopicViewController_iPad.h"
#import "PostTopicViewController_iPad.h"
#import "MopooRemoteServer.h"
#import "SettingViewController_iPad.h"
#import "ChatViewController_iPad.h"
#import "MoreListViewController_iPad.h"
@implementation TopicListViewController_iPad
		
@synthesize detailViewController,moreActionButtomItem=_moreActionButtomItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==0) {
        [self postTopicButtonClick];
    }
    if (buttonIndex==1) {
        SettingViewController_iPad * settingController = [[SettingViewController_iPad alloc]init];
        settingController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.parentViewController presentModalViewController:settingController animated:YES];
    }else if (buttonIndex ==2){
        [[MopooRemoteServer sharedRemoteServer] logout];
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [[MopooAppDelegate_iPad sharedApplication] showLoginViewController];
    }else if (buttonIndex ==3){
        ChatViewController_iPad * chatController = [[ChatViewController_iPad alloc] init];
        [self.detailViewController.navigationController pushViewController:chatController animated:YES];
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 4){
        MoreListViewController_iPad * more = [[MoreListViewController_iPad alloc]init];
        more.topicViewController_iPad = [self detailViewController];
        [self.navigationController pushViewController:more animated:YES];
    }
}
-(void) moreActionClick
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"发帖",@"设置",@"注销",@"留言板",@"更多功能", nil];
    [actionSheet showFromBarButtonItem:_moreActionButtomItem animated:YES];
}
-(void) postTopicButtonClick
{
    PostTopicViewController_iPad * postView = [[PostTopicViewController_iPad alloc] init];
    postView.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.parentViewController presentModalViewController:postView animated:YES];
}
-(void) refreshButtonClick
{
    [self reloadWebView];
}

-(void) showTopicViewController:(NSString *)topicId
{
    [detailViewController showTopic:topicId];
}
		
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
