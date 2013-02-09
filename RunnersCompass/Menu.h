//
//  MenuViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HierarchicalCell.h"
#import "StartCell.h"
#import "JSSlidingViewController.h"
#import "Logger.h"

@protocol MenuViewControllerDelegate <NSObject>

- (void)loadRun:(RunEvent*) run;

@end


@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HierarchicalCellDelegate,StartCellDelegate, JSSlidingViewControllerDelegate, LoggerViewControllerDelegate>
{
    NSMutableArray * runs;
    NSMutableArray * cells;
    StartCell * start;
    
}

//delegate
@property (weak, nonatomic) id <MenuViewControllerDelegate>delegate;

//UI
@property (weak, nonatomic) IBOutlet UITableView *MenuTable;

//actions
- (IBAction)performanceNavPressed:(id)sender;
- (IBAction)goalsNavPressed:(id)sender;
- (IBAction)settingsNavPressed:(id)sender;


@end
