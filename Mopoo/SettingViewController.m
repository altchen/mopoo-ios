//
//  SettingViewController.m
//  Mopoo
//
//  Created by altchen on 11-9-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "MopooUserDefaults.h"
#import "MopooAppDelegate.h"
#import "MopooRemoteServer.h"
@implementation SettingViewController
@synthesize onlyWifiLoadImage=_onlyWifiLoadImage,lineHeightLabel=_lineHeightLabel
    ,fontSizeLabel=_fontSizeLabel,lineHeightSlider=_lineHeightSlider,fontSizeSlider=_fontSizeSlider;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) onlyWifiLoadImageSwitchChange
{
    MopooUserDefaults * userDefuals = [MopooUserDefaults sharedUserDefaults];
    if ([_onlyWifiLoadImage isOn]) {
        [userDefuals setOnlyWifiLoadImageFlag:YES];
    }else{
        [userDefuals setOnlyWifiLoadImageFlag:NO];
    }
    ACLog(@"设置只有Wifi才加载图片:%@", [userDefuals onlyWifiLoadImageFlag]?@"true":@"false");
    [[MopooAppDelegate sharedApplication] asyncSetLoadRemoteFlag];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"设置"];
    MopooUserDefaults * userDefaults = [MopooUserDefaults sharedUserDefaults];
    if (userDefaults.onlyWifiLoadImageFlag) {
        [_onlyWifiLoadImage setOn:YES];
    }else{
        [_onlyWifiLoadImage setOn:NO];
    }
    
    NSString * lineHeight = [userDefaults lineHeight];
    [_lineHeightLabel setText: [NSString stringWithFormat:@"行高(%@)",lineHeight]];
    [_lineHeightSlider setValue:[lineHeight intValue]]; 
    
    NSString * fontSize = [userDefaults fontSize];
    [_fontSizeLabel setText: [NSString stringWithFormat:@"字体大小(%@)",fontSize]];
    [_fontSizeSlider setValue:[fontSize intValue]];    
    
    _dofontSizeChange = FALSE;
    _doLineHeightChange =FALSE;
}
-(void) lineHeigthChange
{
    int lineHeight = [_lineHeightSlider value];
    [_lineHeightLabel setText: [NSString stringWithFormat:@"行高(%d)",lineHeight]];
    _doLineHeightChange=TRUE;
}
-(void) fontSizeChange
{
    int fontSize = [_fontSizeSlider value];
    [_fontSizeLabel setText: [NSString stringWithFormat:@"字体大小(%d)",fontSize]];
    _dofontSizeChange=TRUE;
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_dofontSizeChange) {
        int fontSize = [_fontSizeSlider value];
        [[MopooUserDefaults sharedUserDefaults] setFontSize:[NSString stringWithFormat:@"%d",fontSize]]; 
        [[MopooRemoteServer sharedRemoteServer] clearCacheCSS];
    }
    if (_doLineHeightChange) {
        int lineHeight = [_lineHeightSlider value];
        [[MopooUserDefaults sharedUserDefaults] setLineHeight:[NSString stringWithFormat:@"%d",lineHeight]];
        [[MopooRemoteServer sharedRemoteServer] clearCacheCSS];
    }    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
