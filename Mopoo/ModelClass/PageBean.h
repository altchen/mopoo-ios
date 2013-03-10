//
//  PageBean.h
//  Mopoo
//
//  Created by altchen on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PageBean : NSObject {
    long _total;
    NSArray * _list;
}
@property (nonatomic) long total;
@property (nonatomic,strong) NSArray * list;
@end
