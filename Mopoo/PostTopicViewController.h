//
//  PostTopicViewController.h
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostTopicViewController : UIViewController<UIAlertViewDelegate> {
    UITextField * _titleTextField;
    UITextView * _bodyTextView;
    UISwitch * _niminSwitch;
}
@property (nonatomic,strong) IBOutlet UITextField * titleTextField;
@property (nonatomic,strong) IBOutlet UITextView * bodyTextView;
@property (nonatomic,strong) IBOutlet UISwitch * niminSwitch;

-(IBAction) sumitButtonClick;

@end
