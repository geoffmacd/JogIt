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
#import "DataTest.h"

@protocol MenuViewControllerDelegate <NSObject>

- (void)loadRun:(RunEvent*) run close:(BOOL)close;
- (void)newRun:(NSInteger) value withMetric:(NSInteger) metric animate:(BOOL)animate;
-(void)selectedRunInProgress:(BOOL)shouldDiscard;
- (void)finishedRun:(RunEvent *)run;

@end


@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,HierarchicalCellDelegate,StartCellDelegate, JSSlidingViewControllerDelegate, LoggerViewControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray * runs;
    NSMutableArray * cells;
    StartCell * start;
    
    DataTest * core;
    
}

-(void)testNewRun;

@property (assign, nonatomic) BOOL runInProgressAsFarAsICanTell;

//delegate
@property (weak, nonatomic) id <MenuViewControllerDelegate>delegate;

//UI
@property (strong, nonatomic) IBOutlet UITableView *MenuTable;


//actions
- (IBAction)performanceNavPressed:(id)sender;
- (IBAction)goalsNavPressed:(id)sender;
- (IBAction)settingsNavPressed:(id)sender;


@end
