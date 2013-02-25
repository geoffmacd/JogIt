//
//  GoalsViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTest.h"
#import "GoalHeaderCell.h"

@interface GoalsViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * runs;
    
}

@property (strong, nonatomic) IBOutlet UITableView *table;
@property(retain) GoalHeaderCell * header;

- (IBAction)done:(id)sender;
- (IBAction)goalTapped:(id)sender;
@end
