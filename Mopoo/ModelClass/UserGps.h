//
//  UserGps.h
//  Mopoo
//
//  Created by altchen on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserGps : NSObject {
    NSString * _user;
    double _longitude;    
    double _latitude;
    NSString * _address;
    long _lastCheckinTime;
    int _state;
}
@property (nonatomic,strong) NSString * user;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic,strong) NSString * address;
@property (nonatomic) long lastCheckinTime;
@property (nonatomic) int state;
@end
