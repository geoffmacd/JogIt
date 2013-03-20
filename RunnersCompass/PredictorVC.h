//
//  CreateGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTest.h"
#import "ChartCell.h"
#import "PredictHeaderCell.h"

@interface PredictorVC: UITableViewController<UITableViewDataSource,UITableViewDelegate,ChartCellDelegate>
{
    NSMutableArray * cells;
    Analysis * analysis;
}

@property(retain) PredictHeaderCell * header;
@property (nonatomic, assign) BOOL weekly;



@property (strong, nonatomic) IBOutlet UITableView *table;

- (IBAction)doneTapped:(id)sender;
- (IBAction)weeklyTapped:(id)sender;
- (IBAction)monthlyTapped:(id)sender;

@end
