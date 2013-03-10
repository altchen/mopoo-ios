//
//  ACLog.h
//  Mopoo
//
//  Created by altchen on 11-9-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG    
#define ACLog(format, ...) NSLog(format, ## __VA_ARGS__)    
#else    
#define ACLog(format, ...) 
#endif