//
//  MopooUserDefaults.h
//  Mopoo
//
//  Created by altchen on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MopooUserDefaults : NSObject {
    NSString * _loginCookie;
    NSString * _loginUser;
    NSString * _fontSize;
    NSString * _lineHeight;
    NSString * _stringOnlyWifiLoadImageFlag;
    BOOL _onlyWifiLoadImageFlag;
}
@property (unsafe_unretained) NSString * loginCookie;
@property (unsafe_unretained) NSString * loginUser;
@property (unsafe_unretained) NSString * fontSize;
@property (unsafe_unretained) NSString * lineHeight;
@property (assign) BOOL onlyWifiLoadImageFlag;

-(void) clearCacheLineHeight;
-(void) clearCacheFontSize;

+(MopooUserDefaults *) sharedUserDefaults;
@end
