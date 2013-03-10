//
//  NSDate+ACAdditions.m
//  Mopoo
//
//  Created by altchen on 11-10-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+ACAdditions.h"


@implementation NSDate(ACAdditions)
-(NSString *) stringWithFormatter:(NSString *) formatter
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString * result =[dateFormatter stringFromDate:self];
    return result;
}
@end
