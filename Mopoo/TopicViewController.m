//
//  TopicViewController.m
//  Mopoo
//
//  Created by altchen on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TopicViewController.h"
#import "MBProgressHUD.h"
#import "MopooRemoteServer.h"
#import "ReplyViewController.h"
#import "NSString+SSToolkitAdditions.h"
#import "NSDictionary+SSToolkitAdditions.h"
#import "MopooAppDelegate.h"
#import "EditReplyViewController.h"
@interface TopicViewController(Private)
-(void) showReplayDialog:(NSString *) lc withText:(NSString*) oldReply;
-(void) renewWebView;
-(NSString *) replaceFlashToHtml5: (NSString *) html;
@end
@implementation TopicViewController

@synthesize webView=_webView,topicId=_topicId;

-(id) initWithTopicId:(NSString *) topicId
{
    self = [super init];
    if (self) {
        _topicId = topicId;
        [self setTitle:@"看帖"];
    }
    return self;        
}
-(void) receiveReplySuccess
{
    [self reloadWebView:NO];
}
-(void) reloadWebView:(BOOL) viewPay
{
    if (_topicId==nil) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * html = [[MopooRemoteServer sharedRemoteServer] fetchTopicHtml:_topicId viewPlay:viewPay useCache:NO useRemote:YES];
        html = [self replaceFlashToHtml5:html];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [self renewWebView];//在切换时候经常出现，页面不刷新，只好重新new一个了
            }
            [[self webView ] loadHTMLString:html baseURL:[NSURL URLWithString:@"about:blank"] ];
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
-(void) showReplayDialog:(NSString *) lc withText:(NSString*) oldReply
{
    ReplyViewController * reply = [[ReplyViewController alloc ] initWithTopicId:_topicId];
    if (lc != nil && oldReply != nil) {
        [reply setReplyLcAndText:lc withText:oldReply];
    }
    [[self navigationController ] pushViewController:reply animated:YES];
}
-(void) replyButtonClick
{
    [self showReplayDialog:nil withText:nil];
}

-(void) favButtonClick
{
    if (_topicId==nil) {
        return;
    }    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [[MopooRemoteServer sharedRemoteServer] favTopic:_topicId];
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"收藏成功"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MopooAppDelegate alert:@"收藏失败,请销等再试"];
            });
        }
    });    
}
-(void) zoomButtonClick
{
    _webView.scalesPageToFit = YES;
    [self reloadWebView:NO];
}
-(void) refrechButtonClick
{
    [self reloadWebView:NO];
}
-(void) goBottomButtonClick
{
    [_webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, document.body.scrollHeight);"];
}
-(void) goTopButtonClick
{
    [_webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, 0);"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView setNeedsLayout];
    [webView setNeedsDisplay];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        NSString * requestString = [[request URL] absoluteString];
        if ( [requestString containsString:@"jpuserif.asp"] ) { //查看回复
            NSDictionary * dic = [NSDictionary dictionaryWithFormEncodedString:requestString];
            NSString * replyId = [dic objectForKey:@"id2"];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString * replyText = [[MopooRemoteServer sharedRemoteServer] fetchReplyText:_topicId editReplyId:replyId];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (replyText == nil) {
                [MopooAppDelegate alert:@"得到回复信息失败，请确认是自己的回复"];
                return NO;
            }
            [self showEditReplyViewController:_topicId replayId:replyId replayText:replyText];
            return NO;
        }else if ([requestString containsString:@"info2.asp?lmck=1"]){
            [self reloadWebView:YES];
            return NO;
        }else if ([requestString containsString:@"submitrhtml.asp"]){
            NSString * param = [requestString substringFromIndex:[requestString rangeOfString:@"?"].location+1];
            NSDictionary * dic = [NSDictionary dictionaryWithFormEncodedString:param];
            NSString * newUrl =[NSString stringWithFormat:@"/new/submitrhtml.asp?%@",[dic stringWithFormEncodedComponentsWithEncoding:kCFStringEncodingDOSChineseSimplif]];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block NSArray * othereplayText = [[MopooRemoteServer sharedRemoteServer] fetchOtherUserReplayByURL:newUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if ([othereplayText count]==2) {
                        [self showReplayDialog:[othereplayText objectAtIndex:0] 
                                      withText:[othereplayText objectAtIndex:1]];
                    }
                });  
                
            });
            return NO;
        }
    }
    return YES;
}

-(void) showEditReplyViewController:(NSString*) topicId replayId:(NSString *) replyId replayText:(NSString *)replyText
{
    EditReplyViewController * editController =[[EditReplyViewController alloc]initWithId:topicId replayId:replyId replayText:replyText];
    [[self navigationController] pushViewController:editController animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(NSString *)replaceFlashToHtml5:(NSString *)html
{
    //NSDate * startDate = [NSDate date];
    NSString * youkuFlashRegex = @"<embed src=\"http://player\\.youku\\.com/player\\.php/[^\"]*sid/([^/]*)/[^<]*</embed>";
    NSString * youkuVideoRegex = @"<video width=\"480\" height=\"400\" preload=\"\" autoplay=\"\" controls=\"\" x-webkit-airplay=\"allow\" id=\"youku-html5-player-video\" tabindex=\"0\" src=\"http://www.youku.com/player/getRealM3U8/vid/$1/type/video.m3u8\"></video>";
    NSString * resultString = [html stringByReplacingMatches:youkuFlashRegex withTemplate:youkuVideoRegex];
    //ACLog(@"=============%@", resultString);
    //NSTimeInterval usedTime = [[NSDate date] timeIntervalSinceDate:startDate];
    //ACLog(@"replaceFlashToHtml5 use time :%f", usedTime);
    return resultString;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView setDelegate:self];
    [self reloadWebView:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReplySuccess) name:@"REPLY_SUCCESS" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
