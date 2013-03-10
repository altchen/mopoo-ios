//
//  MopooUserDefaults.m
//  Mopoo
//
//  Created by altchen on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MopooUserDefaults.h"


@implementation MopooUserDefaults

+(MopooUserDefaults *) sharedUserDefaults
{
   static MopooUserDefaults * staticUserDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticUserDefaults = [[MopooUserDefaults alloc] init];
    });
    return staticUserDefaults;
}
-(NSString *) loginCookie
{
    if (_loginCookie == nil) {
        _loginCookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_COOKIE"];
    }
    return _loginCookie;
}
-(void) setLoginCookie:(NSString *)loginCookie
{
    
    [[NSUserDefaults standardUserDefaults] setObject:loginCookie forKey:@"LOGIN_COOKIE"];
    if (_loginCookie !=NULL) {
        _loginCookie = NULL;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *) loginUser
{
    if (_loginUser == nil) {
        _loginUser = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN_USER"];
    }
    return _loginUser;
}
-(void) setLoginUser:(NSString *)loginUser
{
    
    [[NSUserDefaults standardUserDefaults] setObject:loginUser forKey:@"LOGIN_USER"];
    if (_loginUser !=NULL) {
        _loginUser =NULL;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *) fontSize
{
    if (_fontSize==NULL) {
        _fontSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"FONT_SIZE"];
        if (_fontSize == nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                _fontSize = @"14";
            }else{
                _fontSize = @"12";
            }
        }
        ACLog(@"得到配置字体大小:%@", _fontSize);
    }
    return _fontSize;
}
-(void) setFontSize: (NSString *) value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"FONT_SIZE"];
    if (_fontSize !=NULL) {
        _fontSize =NULL;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self clearCacheFontSize];
    
}
-(void) clearCacheFontSize
{
    if (_fontSize!=NULL) {
        _fontSize = NULL;
    }
}
-(NSString *) lineHeight
{
    if (_lineHeight==NULL) {
        _lineHeight = [[NSUserDefaults standardUserDefaults] objectForKey:@"LINE_HEIGHT"];
        if (_lineHeight == nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                _lineHeight = @"24";
            }else{
                _lineHeight = @"22";
            }
        }
        ACLog(@"得到配置行高:%@", _lineHeight);
    }
    return _lineHeight;
}
-(void) clearCacheLineHeight
{
    if (_lineHeight!=NULL) {
        _lineHeight = NULL;
    }
}
-(void) setLineHeight:(NSString *) value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"LINE_HEIGHT"];
    if (_lineHeight !=NULL) {
        _lineHeight =NULL;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self clearCacheLineHeight];
}
-(BOOL) onlyWifiLoadImageFlag
{
    if (_stringOnlyWifiLoadImageFlag==NULL) {
        _stringOnlyWifiLoadImageFlag = [[NSUserDefaults standardUserDefaults] objectForKey:@"ONLY_WIFI_LOAD_IMAGE"];
        if (_stringOnlyWifiLoadImageFlag == nil) {
            _onlyWifiLoadImageFlag = YES;
        }else{
            if ([_stringOnlyWifiLoadImageFlag isEqualToString:@"1"]) {
                _onlyWifiLoadImageFlag = YES;
            }else{
                _onlyWifiLoadImageFlag = NO;
            }
                
        }
    }
    return _onlyWifiLoadImageFlag;
}
-(void) setOnlyWifiLoadImageFlag:(BOOL)onlyWifiLoadImageFlag
{
    if (onlyWifiLoadImageFlag) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ONLY_WIFI_LOAD_IMAGE"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ONLY_WIFI_LOAD_IMAGE"];
    }
    if (_stringOnlyWifiLoadImageFlag !=NULL) {
        _stringOnlyWifiLoadImageFlag =NULL;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
