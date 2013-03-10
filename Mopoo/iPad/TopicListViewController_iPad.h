//
//  RootViewController.h
//  SplitDemo
//
//  Created by altchen on 11-9-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "TopicViewController_iPad.h"
@class TopicViewController_iPad;

@interface TopicListViewController_iPad : RootViewController<UIActionSheetDelegate> {
    
}

@property (nonatomic,strong) IBOutlet UIBarButtonItem * moreActionButtomItem;		
@property (nonatomic, strong) IBOutlet TopicViewController_iPad *detailViewController;

-(IBAction) moreActionClick;
-(IBAction) postTopicButtonClick;
-(IBAction) refreshButtonClick;

@end
