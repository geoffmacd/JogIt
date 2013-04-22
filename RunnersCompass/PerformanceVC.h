//
//  CreateGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartCell.h"
#import "PermHeaderCell.h"
#import "Analysis.h"
#import "UserPrefs.h"
#import "Util.h"
#import "PRCell.h"
#import "UpgradeVC.h"

@interface PerformanceVC: UITableViewController<UITableViewDataSource,UITableViewDelegate,ChartCellDelegate,PRCellDelegate>
{
    NSMutableArray * cells;
    PRCell * prCell;
}

@property PermHeaderCell * header;
@property UserPrefs * prefs;
@property Analysis * analysis;
@property BOOL weekly;


@property (weak)  IBOutlet UITableView *table;

- (IBAction)doneTapped:(id)sender;
- (IBAction)predictTapped:(id)sender;
- (IBAction)weeklyTapped:(id)sender;
- (IBAction)monthlyTapped:(id)sender;

@end
