//
//  CreateGoalHeaderCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PredictHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PredictHeaderCell

@synthesize doneBut,weeklyBut,monthlyBut;

-(void) setup
{
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    [doneBut.layer setMasksToBounds:true];
    
    //localized buttons in IB
    /*
    [weeklyBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0f]];
    [monthlyBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0f]];
    [doneBut.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0f]];
     */
    [weeklyBut setTitle:NSLocalizedString(@"WeeklyButton", @"button for weekly") forState:UIControlStateNormal];
    [monthlyBut setTitle:NSLocalizedString(@"MonthlyButton", @"button for monthly") forState:UIControlStateNormal];
    [doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
}


@end
