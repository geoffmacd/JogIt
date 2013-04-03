//
//  GoalsViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalHeaderCell.h"

@interface GoalsViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    
    NSInteger goalRunCount;
    
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property(retain) GoalHeaderCell * header;
@property(retain) Goal * curGoal;
@property(weak) NSMutableArray * runs;
@property (nonatomic, assign) BOOL metric;

- (IBAction)done:(id)sender;
- (IBAction)goalTapped:(id)sender;
@end
