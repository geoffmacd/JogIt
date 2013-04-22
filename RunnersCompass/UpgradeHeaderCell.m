//
//  CreateGoalHeaderCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UpgradeHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UpgradeHeaderCell

@synthesize doneBut,upgradeBut;

-(void) setup
{
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    [doneBut.layer setMasksToBounds:true];
    
    [upgradeBut.layer setCornerRadius:8.0f];
    [upgradeBut.layer setMasksToBounds:true];
    
    //localized buttons in IB
    [doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
}


@end
