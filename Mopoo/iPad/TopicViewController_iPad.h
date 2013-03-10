//
//  DetailViewController.h
//  SplitDemo
//
//  Created by altchen on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicViewController.h"
#import "MGSplitViewController.h"
@interface TopicViewController_iPad : TopicViewController <UIPopoverControllerDelegate, MGSplitViewControllerDelegate> {

}


@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
-(void) showTopic:(NSString *) topicId;

@end
