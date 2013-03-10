//
//  NewChatViewController.h
//  Mopoo
//
//  Created by altchen on 11-10-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewChatViewController : UIViewController<UIAlertViewDelegate> {
    UITextView * _messageTextView;
}
@property (nonatomic,strong) IBOutlet UITextView * messageTextView;
-(IBAction) sendButtonClick;
@end
