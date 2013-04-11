//
//  GoalHeader.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalHeaderCell.h"
#import <QuartzCore/QuartzCore.h>
#import "RunEvent.h"

@implementation GoalHeaderCell

@synthesize countLabel,countValue,beganLabel,beganValue;
@synthesize targetLabel,targetValue,metricDescriptionLabel,metricDescriptionSubtitle,metricValue;

@synthesize doneBut,goalButton;
@synthesize progress,goal,metric,noGoalImage;

-(void) setup
{
    //set labels
    [self setGoalLabels];
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    [goalButton.layer setCornerRadius:8.0f];
    [doneBut.layer setMasksToBounds:true];
    [goalButton.layer setMasksToBounds:true];
    
    //set progress bar
    UIImage *background = [[UIImage imageNamed:@"progress-bar-bg.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    UIImage *fill = [[UIImage imageNamed:@"progress-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 4)];
    
    [progress setTrackImage:background];
    [progress setProgressImage:fill];
    [progress.layer setCornerRadius:6.0f];
    [progress.layer setMasksToBounds:true];
    
}

-(void)setGoalLabels
{
    if(goal && goal.type != GoalTypeNoGoal)
    {
        [goalButton setTitle:[goal getName:metric] forState:UIControlStateNormal];
        
        //dates
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setCalendar:cal];
        [formatter setLocale:[NSLocale currentLocale]];
        if(goal.startDate)
        {
            NSString *beganString = [formatter stringFromDate:goal.startDate];
            [beganValue setText:beganString];
        }
        else{
            [beganValue setText:@""];
        }
        if(goal.endDate)
        {
            NSString *targetString = [formatter stringFromDate:goal.endDate];
            [targetValue setText:targetString];
        }
        else{
            [targetValue setText:@""];
        }
        
        [countValue setText:[NSString stringWithFormat:@"%d", [goal.activityCount integerValue]]];
        [metricValue setText:goal.metricValueChange];
        
        //both description labels to be updated
        [metricDescriptionLabel setText:[goal stringForDescription]];
        [metricDescriptionSubtitle setText:[goal stringForSubtitle]];
        
        //progress bar
        [progress setProgress:goal.progress];
        //hide image
        [noGoalImage setHidden:true];
        
    }else{
        [goalButton setTitle:NSLocalizedString(@"GoalButtonWithNone", @"No goal for button") forState:UIControlStateNormal];
        
        //dates
        [beganValue setText:@""];
        [targetValue setText:@""];
        
        [countValue setText:@""];
        [metricValue setText:@""];
        
        //both description labels to be updated
        [metricDescriptionLabel setText:@""];
        [metricDescriptionSubtitle setText:@""];
        
        //progress bar
        [progress setProgress:0];
        //view image
        [noGoalImage setHidden:false];
        CGRect curBounds = self.bounds;
        curBounds.size.height += 200;
        [self setBounds:curBounds];
    }
    
    //localizations    //localized buttons in IB
    [doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
    [beganLabel setText:NSLocalizedString(@"GoalBeganLabel", @"began date label for goal")];
    [targetLabel setText:NSLocalizedString(@"GoalTargetLabel", @"target date label for goal")];
    [countLabel setText:NSLocalizedString(@"GoalCountLabel", @"count label for goal activites")];
}

@end
