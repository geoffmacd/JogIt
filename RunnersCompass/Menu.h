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
#import "Goal.h"
#import "Analysis.h"
#import "Constants.h"
#import "RunEvent.h"
#import "Logger.h"
#import "PerformanceVC.h"
#import "SettingsViewController.h"
#import "GoalsViewController.h"
#import "CreateGoalViewController.h"
#import "RunFormPicker.h"
#import "ManualVC.h"
#import "NotificationVC.h"
#import "GoalNotifyVC.h"
#import "MJPopupBackgroundView.h"
#import "UIViewController+MJPopupViewController.h"
#import "MBProgressHUD.h"

#import "LocationRecord.h"
#import "ThumbnailRecord.h"
#import "RunRecord.h"


@protocol MenuViewControllerDelegate <NSObject>

-(void)lockBeforeLoad;
- (void)loadRun:(RunEvent*) runToLoad close:(BOOL)close;
- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate;
-(void)selectedRunInProgress:(BOOL)shouldDiscard;
- (void)finishedRun:(RunEvent *)run;
-(void)preventUserFromSlidingRunInvalid:(RunEvent *)runToDelete;
-(BOOL)isRunAlreadyLoaded:(RunEvent*)runToCheck;
-(void)updateGesturesNeededtoFail:(UIGestureRecognizer*)gestureToFail;
-(UserPrefs *)curUserPrefs;
-(Goal *)curGoal;

@end


@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,HierarchicalCellDelegate,StartCellDelegate,JSSlidingViewControllerDelegate,ManualVCDelegate>
{
    NSMutableArray * runs;
    NSMutableArray * cells;
    StartCell * start;
    BOOL showingNoRuns;
    RunEvent * longestRun;
    RunEvent * fastestRun;
    RunEvent * furthestRun;
    RunEvent * caloriesRun;
}

@property (assign, nonatomic) BOOL runInProgressAsFarAsICanTell;

//delegate
@property (weak, nonatomic) id <MenuViewControllerDelegate>delegate;

//UI
@property (strong, nonatomic) IBOutlet UITableView *MenuTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBut;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *goalsBut;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *performanceBut;
@property (strong, nonatomic) IBOutlet UIImageView *runningManImage;
@property (strong, nonatomic) IBOutlet UILabel *noRunsLabel;
@property (strong, nonatomic) IBOutlet UIView *noRunView;


//actions
- (IBAction)performanceNavPressed:(id)sender;
- (IBAction)goalsNavPressed:(id)sender;
- (IBAction)settingsNavPressed:(id)sender;
- (IBAction)garbageTapped:(id)sender;



- (void)finishedRun:(RunEvent *)run;
-(void)updateTimeString:(NSString *)updatedTimeString;

@end
