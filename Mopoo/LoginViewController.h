//
//  LoginViewController.h
//  Mopoo
//
//  Created by altchen on 11-8-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController {
    UITextField * userTextField;
    UITextField * passwordTextField;
    UIButton * loginButton;
}
@property (nonatomic,strong) IBOutlet UIButton * loginButton;
@property (nonatomic,strong) IBOutlet UITextField * userTextField;
@property (nonatomic,strong) IBOutlet UITextField * passwordTextField;

-(void) showTopicViewController;
-(IBAction)loginButtonClick;
-(IBAction)textFieldValueChange;
@end
