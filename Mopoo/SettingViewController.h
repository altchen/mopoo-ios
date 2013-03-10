//
//  SettingViewController.h
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingViewController : UIViewController {
    UISwitch * _onlyWifiLoadImage;
    UILabel * _lineHeightLabel;
    UILabel * _fontSizeLabel;
    UISlider * _lineHeightSlider;
    UISlider * _fontSizeSlider;
    BOOL _doLineHeightChange;
    BOOL _dofontSizeChange;
}
@property (nonatomic,strong) IBOutlet UISwitch * onlyWifiLoadImage;
@property (nonatomic,strong) IBOutlet UILabel * lineHeightLabel;
@property (nonatomic,strong) IBOutlet UILabel * fontSizeLabel;
@property (nonatomic,strong) IBOutlet UISlider * lineHeightSlider;
@property (nonatomic,strong) IBOutlet UISlider * fontSizeSlider;

-(IBAction) onlyWifiLoadImageSwitchChange;

-(IBAction) lineHeigthChange;
-(IBAction) fontSizeChange;
@end
