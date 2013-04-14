//
//  Settings.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPrefs.h"
#import "RunEvent.h"
#import "RunRecord.h"

@class FKFormModel;

@protocol ManualVCDelegate <NSObject>

-(void)manualRunToSave:(RunEvent*)runToSave;
-(void)manualRunCancelled;

@end

@interface ManualVC : UITableViewController


@property  FKFormModel *formModel;
@property  UserPrefs *prefs;
@property  RunRecord *manualRun;

//delegate
@property id <ManualVCDelegate>delegate;

@end
