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

@interface NotificationVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel2;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel3;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property RunMetric type;
@property RunMetric type2;
@property RunMetric type3;
@property RunMetric type4;
@property RunEvent * oldPR;
@property RunEvent * prRun;
@property UserPrefs * prefs;


-(void)setPRLabels;
@end
