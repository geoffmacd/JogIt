//
//  CreateGoalViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-17.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UpgradeCell.h"
#import "UpgradeHeaderCell.h"

@interface UpgradeVC: UITableViewController<UITableViewDataSource,UITableViewDelegate,UpgradeCellDelegate>
{
    UpgradeHeaderCell * header;
    NSMutableArray * cells;
}


@property (weak)  IBOutlet UITableView *table;

- (IBAction)doneTapped:(id)sender;
- (IBAction)upgradeTapped:(id)sender;

@end
