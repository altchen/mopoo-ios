//
//  ChatViewController.m
//  Mopoo
//
//  Created by altchen on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ChatViewController.h"
#import "MopooRemoteServer.h"
#import "NewChatViewController.h"
@interface ChatViewController()
-(void) renewWebView;
@end
@implementation ChatViewController
@synthesize webView=_webView;

#pragma mark - my code
-(void) newChatButtonClick
{
    NewChatViewController * newChatController = [[NewChatViewController alloc] init];
    [self.navigationController pushViewController:newChatController animated:YES];
}

-(void)reloadChatMessage
{
    [[self webView ] loadHTMLString:@"loading..." baseURL:[NSURL URLWithString:@"https://www.253874.com/new/"] ];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * html = [[MopooRemoteServer sharedRemoteServer] fetchChatHtml];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self renewWebView];
            if ([MopooRemoteServer sharedRemoteServer].error==nil) {
                [[self webView ] loadHTMLString:html baseURL:[NSURL URLWithString:@"https://www.253874.com/new/"] ];
            } else {
                [[self webView ] loadHTMLString:[[MopooRemoteServer sharedRemoteServer].error localizedDescription]  baseURL:[NSURL URLWithString:@"https://www.253874.com/new/"] ];
            }
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
-(void) goTopButtonClick
{
    [_webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, 0);"];
}
-(void) goBottomButtonClick
{
    [_webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, document.body.scrollHeight);"];
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
    [self setTitle:@"留言板"];
    [self reloadChatMessage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatMessage) name:@"SEND_CHAT_SUCCESS" object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
