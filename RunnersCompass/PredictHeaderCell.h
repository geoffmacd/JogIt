//
//  CreateGoalHeaderCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PredictHeaderCell : UIView
@property (strong, nonatomic) IBOutlet UIButton *doneBut;
@property (strong, nonatomic) IBOutlet UIButton *weeklyBut;
@property (strong, nonatomic) IBOutlet UIButton *monthlyBut;


-(void) setup;

@end
