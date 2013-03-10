//
//  ChatViewController.h
//  Mopoo
//
//  Created by altchen on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChatViewController : UIViewController<UIWebViewDelegate> {
    UIWebView * _webView;
}
@property (nonatomic,strong) IBOutlet UIWebView * webView;
-(IBAction) newChatButtonClick;
-(IBAction) reloadChatMessage;
-(IBAction) goTopButtonClick;
-(IBAction) goBottomButtonClick;
@end
