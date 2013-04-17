//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//


#import "GoalNotifyVC.h"

@implementation GoalNotifyVC

@synthesize goal,prRun,prefs;
@synthesize titleLabel,hideLabel,recordLabel;

-(void)setLabels
{
    
    [recordLabel setText:@""];
    
    if(goal)
    {
        NSString * goalAchieved;
        
        goalAchieved = [goal getName:[[prefs metric] boolValue]];
        [recordLabel setText:goalAchieved];
    }
}

@end
