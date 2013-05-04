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
@synthesize titleLabel,recordLabel;

-(void)setLabels
{
    
    [recordLabel setText:@""];
    
    if(goal)
    {
        NSString * goalAchieved;
        
        goalAchieved = [goal getName:[[prefs metric] boolValue]];
        [recordLabel setText:goalAchieved];
        
        [recordLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15.0f]];
        [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:17.0f]];
    }
}

@end
