//
//  GoalHeader.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalHeaderCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DataTest.h"
#import "RunEvent.h"

@implementation GoalHeaderCell

@synthesize countLabel,countValue,beganLabel,beganValue;
@synthesize targetLabel,targetValue,metricDescriptionLabel,metricDescriptionSubtitle,metricValue;

@synthesize doneBut,goalButton;
@synthesize progress;


-(void) setup
{
    //set labels
    [self setGoalLabels];
    
    //set rounded corners on button
    [doneBut.layer setCornerRadius:8.0f];
    [goalButton.layer setCornerRadius:8.0f];
    
    //set progress bar
    UIImage *trackImg = [[UIImage imageNamed:@"track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *progressImg = [[UIImage imageNamed:@"progress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    [progress setTrackImage:trackImg];
    [progress setProgressImage:progressImg];
}

-(void)setGoalLabels
{
    DataTest * data = [DataTest sharedData];
    if(data.curGoal)
    {
        
        [goalButton setTitle:[data.curGoal getName] forState:UIControlStateNormal];
        
        //dates
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setCalendar:cal];
        [formatter setLocale:[NSLocale currentLocale]];
        NSString *beganString = [formatter stringFromDate:data.curGoal.startDate];
        [beganValue setText:beganString];
        NSString *targetString = [formatter stringFromDate:data.curGoal.endDate];
        [targetValue setText:targetString];
        
        
        [countValue setText:[NSString stringWithFormat:@"%d", [data.curGoal.activityCount integerValue]]];
        [metricValue setText:data.curGoal.metricValueChange];
        
        
        //both description labels to be updated
        [metricDescriptionLabel setText:[data.curGoal stringForDescription]];
        [metricDescriptionSubtitle setText:[data.curGoal stringForSubtitle]];
        
        //progress bar
        [progress setProgress:data.curGoal.progress];
        
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
        [progress setProgress:0.0f];
    }
    
    //localizations    //localized buttons in IB
    [doneBut setTitle:NSLocalizedString(@"DoneButton", @"done button") forState:UIControlStateNormal];
    [beganLabel setText:NSLocalizedString(@"GoalBeganLabel", @"began date label for goal")];
    [targetLabel setText:NSLocalizedString(@"GoalTargetLabel", @"target date label for goal")];
    [countLabel setText:NSLocalizedString(@"GoalCountLabel", @"count label for goal activites")];
}

@end
