//
//  EditReplyViewController.h
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditReplyViewController : UIViewController<UIAlertViewDelegate> {
    UITextView * _replyTextView;
    NSString * _topicId;
    NSString * _replyId;
    NSString * _text;
}
-(id) initWithId:(NSString *) topicId replayId:(NSString *) editReplyId replayText:(NSString*) text;
@property (nonatomic,strong) IBOutlet UITextView * replyTextView;
@property (nonatomic,strong) NSString * topicId;
@property (nonatomic,strong) NSString * replyId;
@property (nonatomic,strong) NSString * text;
-(IBAction) editButtonClick;
-(IBAction) delButtonClick;
@end
