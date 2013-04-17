//
//  MJDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "UserPrefs.h"
#import "Goal.h"

@interface GoalNotifyVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hideLabel;

@property Goal * goal;
@property RunEvent * prRun;
@property UserPrefs * prefs;


-(void)setLabels;
@end
