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

@interface PerformanceVC: UITableViewController<UITableViewDataSource,UITableViewDelegate,ChartCellDelegate>
{
    NSMutableArray * cells;
}

@property PermHeaderCell * header;
@property BOOL weekly;
@property BOOL metric;
@property Analysis * analysis;


@property (weak)  IBOutlet UITableView *table;

- (IBAction)doneTapped:(id)sender;
- (IBAction)predictTapped:(id)sender;
- (IBAction)weeklyTapped:(id)sender;
- (IBAction)monthlyTapped:(id)sender;

@end
