//
//  EditGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@class FKFormModel;

@interface EditGoalViewController : UITableViewController

@property FKFormModel *formModel;
@property Goal  *tempGoal;


@end
