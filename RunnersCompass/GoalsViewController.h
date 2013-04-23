//
//  GoalsViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalHeaderCell.h"
#import "UserPrefs.h"
#import "UpgradeVC.h"

@interface GoalsViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSInteger totalRunCount;
    NSInteger goalRunCount;
    CGFloat minValueForGoal;
    CGFloat maxValueForGoal;
    NSMutableArray * cells;
    NSMutableArray * sortedRunsForGoal;
    BOOL drilledDown;
    
}

@property (strong) IBOutlet UITableView *table;

@property (strong) GoalHeaderCell * header;
@property Goal * curGoal;
@property (nonatomic, setter = setOriginalRunsSorted:)NSMutableArray * originalRunsSorted;
@property UserPrefs * prefs;


- (IBAction)done:(id)sender;
- (IBAction)goalTapped:(id)sender;

@end
