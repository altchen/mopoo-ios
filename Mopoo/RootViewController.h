//
//  RootViewController.h
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate> {
    UIWebView * _webView;
}
@property (nonatomic,strong)IBOutlet UIWebView * webView;

-(IBAction) actionButtonClick;
-(IBAction) logoutButtonClick;
-(IBAction) postTopicButtonClick;
-(IBAction) refreshButtonClick;
-(IBAction) gpsButtonClick;
-(void)receivePostSuccess;
-(void) reloadWebView;
-(void) showTopicViewController: (NSString *) topicId;
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end
