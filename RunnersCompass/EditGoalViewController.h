//
//  EditGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPrefs.h"

@class FKFormModel;

@interface EditGoalViewController : UITableViewController

@property (nonatomic, strong) FKFormModel *formModel;
@property (nonatomic,strong) UserPrefs *prefs;

@end
