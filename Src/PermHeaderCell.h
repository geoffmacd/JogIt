//
//  CreateGoalHeaderCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermHeaderCell : UIView
@property (weak)  IBOutlet UIButton *doneBut;
@property (weak) IBOutlet UIButton *predictBut;
@property (weak)  IBOutlet UIButton *weeklyBut;
@property (weak)  IBOutlet UIButton *monthlyBut;


-(void) setup;

@end
