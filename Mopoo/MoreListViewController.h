//
//  MoreListViewController.h
//  libasihttp
//
//  Created by  on 12-2-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreListViewController : UIViewController<UIWebViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;

@end
