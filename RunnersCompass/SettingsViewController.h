//
//  Settings.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPrefs.h"

@class FKFormModel;

@interface SettingsViewController : UITableViewController


@property  FKFormModel *formModel;
@property  UserPrefs *prefsToChange;
@property  BOOL oldMetric;

@end
