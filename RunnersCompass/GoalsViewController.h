//
//  GoalsViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTest.h"

@interface GoalsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray * runs;
}

@property (strong, nonatomic) IBOutlet UIButton *doneBut;
@property (strong, nonatomic) IBOutlet UIButton *goalButton;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueChangedDescription;
@property (strong, nonatomic) IBOutlet UILabel *beganDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalBeganLabel;
@property (strong, nonatomic) IBOutlet UILabel *targetDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalTargetLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalActivitiesLabel;
@property (strong, nonatomic) IBOutlet UILabel *activitiesCountLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;

- (IBAction)done:(id)sender;
- (IBAction)goalTapped:(id)sender;
@end
