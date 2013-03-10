//
//  TopicViewController.h
//  Mopoo
//
//  Created by altchen on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopicViewController : UIViewController<UIWebViewDelegate> {
    NSString * _topicId;
    UIWebView * _webView;
}
@property (nonatomic,strong)IBOutlet UIWebView * webView;
@property (nonatomic,strong) NSString * topicId;
-(IBAction) zoomButtonClick;
-(IBAction) replyButtonClick;
-(IBAction) favButtonClick;
-(IBAction) refrechButtonClick;
-(IBAction) goBottomButtonClick;
-(IBAction) goTopButtonClick;
-(void) receiveReplySuccess;
-(void) reloadWebView:(BOOL) viewPay;
-(void) showEditReplyViewController:(NSString*) topicId replayId:(NSString *) replyId replayText:(NSString *)replyText;
-(id) initWithTopicId:(NSString *) topicId;

@end
