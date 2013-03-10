//
//  MoreListViewController.m
//  libasihttp
//
//  Created by  on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreListViewController.h"
#import "NSDictionary+SSToolkitAdditions.h"
#import "MBProgressHUD.h"
#import "MopooRemoteServer.h"
#import "MopooAppDelegate.h"
#import "NSURL+SSToolkitAdditions.h"
@interface MoreListViewController()
-(void) renewWebView;
-(void) showInitWebView;
-(void) showTopicViewController:(NSString *)topicId;
-(NSString *) htmlOfTopLink;
-(void) showHtmlToWebView:(NSString * ) html addTopLink:(BOOL) isAddTopLink;
@end

@implementation MoreListViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"更多功能"];
        // Custom initialization
    }
    return self;
}


#pragma mark - my logic code

-(void) showInitWebView
{
    NSString * html = [self htmlOfTopLink];
    [[self webView] loadHTMLString:html baseURL:[NSURL URLWithString:@"about:blank"]];
}
-(NSString *) htmlOfTopLink
{
    return @"<div style='height:3px'></div><form action='msearch.asp' method='post'><div align='left'><p>\
    <input name='T1' size='10' style='FONT-SIZE: 9pt' value=''><span style='FONT-SIZE: 9pt'><select name='D1' size='1' style='FONT-SIZE: 9pt'>\
    <option value='帖子标题' selected=''>帖子标题</option>\
    <option value='发帖人'>发帖人</option>\
    <option value='发言人'>发言人</option>\
    </select></span><input name='B1' c type='submit' value='查找'><br/><div style='height:3px'></div><span style='FONT-SIZE: 12pt'><a href='infonew.asp?iio=2'>收藏</a>&nbsp;<a href='infonew.asp?iio=3'>自己</a>&nbsp;<a href='infonew.asp?iio=4'>自回</a></span></p>\
    </div>\
    </form>";
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString * url = [[request URL] absoluteString];
        if ([url rangeOfString:@"info2.asp?id="].length >0) {
            NSDictionary * dict = [[request URL] queryDictionary];
            NSString * topicId = [dict valueForKey:@"id"];
            [self showTopicViewController:topicId];
        } else if ([url rangeOfString:@"infonew.asp?iio="].length >0){
            NSDictionary * dict = [[request URL] queryDictionary];
            NSString * iio = [dict valueForKey:@"iio"];
            NSString * lastUrl = [@"infonew.asp?iio=" stringByAppendingString:iio];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString * html = [[MopooRemoteServer sharedRemoteServer] fetchInfoNewHtml:lastUrl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHtmlToWebView:html addTopLink:TRUE];
                        [MBProgressHUD hideHUDForView:self.view animated:YES]; 
                    });
                });
            }); 
        } else if ([url rangeOfString:@"infonewdel.asp"].length >0){
            NSDictionary * dict = [[request URL] queryDictionary];
            NSString * topicId = [dict valueForKey:@"sid"];   
            NSString * replyId = [dict valueForKey:@"id"];  
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                BOOL success = [[MopooRemoteServer sharedRemoteServer] delReply:topicId editReplyId:replyId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (success) {
                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                        [alert show];
                    }else{
                        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] ;
                        [alert show];
                    }
                                                
                });
            }); 
        }
        return NO;
    } else if ( navigationType == UIWebViewNavigationTypeFormSubmitted ) {
        NSString * data = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSDictionary dictionaryWithFormEncodedString:data];
        NSString * key = [dict valueForKey:@"T1"];
        NSString * type = [dict valueForKey:@"D1"]; 
        //ACLog(@"==============key:%@,type:%@", key,type);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES]; 
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString * html = [[MopooRemoteServer sharedRemoteServer] fetchSearchHtml:key searchType:type useCache:FALSE useRemote:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHtmlToWebView:html addTopLink:TRUE];
                        [MBProgressHUD hideHUDForView:self.view animated:YES]; 
                });
            });
        });      

        return NO;
    }
    return YES;
}
-(void) showTopicViewController:(NSString *)topicId
{
    [[MopooAppDelegate sharedApplication] showTopicViewController:topicId];
}
-(void) showHtmlToWebView:(NSString * ) html addTopLink:(BOOL) isAddTopLink
{
    [self renewWebView];
    NSString * showHtml = html;
    if (showHtml == NULL || showHtml ==nil) {
        showHtml=@"";
    }
    if (isAddTopLink) {
        showHtml = [[self htmlOfTopLink] stringByAppendingString:showHtml];
    }

    [[self webView ] loadHTMLString:showHtml baseURL:[NSURL URLWithString:@"about:blank"] ];
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
    [self showInitWebView];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
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
