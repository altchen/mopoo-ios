//
//  DetailViewController.m
//  SplitDemo
//
//  Created by altchen on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopicViewController_iPad.h"

#import "RootViewController.h"
#import "ReplyViewController_iPad.h"
#import "EditReplyViewController_iPad.h"
@interface TopicViewController_iPad ()
@property (nonatomic, strong) UIPopoverController *popoverController;

@end

@implementation TopicViewController_iPad

@synthesize toolbar=_toolbar;

@synthesize popoverController=_myPopoverController;

#pragma mark - Managing the detail item


-(void) showReplayDialog:(NSString *) lc withText:(NSString*) oldReply
{
    if (self.topicId==nil) {
        return;
    }
    ReplyViewController_iPad * replyController = [[ReplyViewController_iPad alloc] initWithTopicId:self.topicId];
    [replyController setReplyLcAndText:lc withText:oldReply];
    [self.navigationController pushViewController:replyController animated:YES];
}
-(void) showEditReplyViewController:(NSString*) topicId replayId:(NSString *) replyId replayText:(NSString *)replyText
{
    EditReplyViewController_iPad * editController =[[EditReplyViewController_iPad alloc]initWithId:topicId replayId:replyId replayText:replyText];
    [self.navigationController pushViewController:editController animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadHTMLString:@"请从帖子列表选择要查看的帖" baseURL:[NSURL URLWithString:@"about:blank" ]];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    
	[super viewDidAppear:animated];
}

-(void) showTopic:(NSString *)topicId
{
    [self.popoverController dismissPopoverAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [super setTopicId:topicId];
    if (self.webView.scalesPageToFit==YES) {
        self.webView.scalesPageToFit =NO;
    }
    [super reloadWebView:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(MGSplitViewController*)svc 
	 willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc
{
    barButtonItem.title = @"帖子列表";
    
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc 
	 willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [[self navigationItem] setLeftBarButtonItem:nil];
    self.popoverController = nil;
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
 */

- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


@end
