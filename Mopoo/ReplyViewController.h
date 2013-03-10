//
//  ReplyViewController.h
//  Mopoo
//
//  Created by altchen on 11-9-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReplyViewController : UIViewController<UIAlertViewDelegate> {
    UITextView * _replyContentTextView;
    UISwitch * _niminSwitch;
    UIButton * _sumitButton;
    NSString * _topicId;
    NSString * _lc;
    NSString * oldReply;
}
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *replyTipLabel;
@property (nonatomic,strong) IBOutlet UITextView *replyContentTextView;
@property (nonatomic,strong) IBOutlet UISwitch * niminSwitch;
@property (nonatomic,strong) IBOutlet UIButton * sumitButton;
@property (nonatomic,strong) IBOutlet NSString * topicId;
@property (nonatomic,strong) NSString * lc;
@property (nonatomic,strong) NSString * oldReply;
-(id) initWithTopicId:(NSString * ) topicId;
-(void) setReplyLcAndText:(NSString *) lc withText:(NSString *) text;
-(IBAction) submitClick;
@end
