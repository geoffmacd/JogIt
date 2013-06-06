//
//  GoalCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoalCell

@synthesize label,progress,dateLabel,tooShortLabel;

-(void)setupWithRun:(RunEvent*)runForCell withGoal:(Goal*)goal withMetric:(BOOL)metric showSpeed:(BOOL)showSpeed withMin:(CGFloat)min withMax:(CGFloat)max
{
    [label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [tooShortLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [dateLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    
    //always show the date in label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString * header = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:runForCell.date]];
    [dateLabel setText:header];
    
    //set value for goal
    NSString * stringForGoal;
    CGFloat progessValue = 0.0;
    UserPrefs * tempPrefs = [UserPrefs MR_findFirst];
    tempPrefs.metric = [NSNumber numberWithBool:metric];
    switch(goal.type)
    {
        case GoalTypeCalories:
            stringForGoal = [NSString stringWithFormat:@"%.0f cal", runForCell.calories];
            progessValue = runForCell.calories / max;
            break;
        case GoalTypeOneDistance:
            stringForGoal = [NSString stringWithFormat:@"%.1f %@", [RunEvent getDisplayDistance:runForCell.distance withMetric:metric], [tempPrefs getDistanceUnit]];
            progessValue = runForCell.distance / [goal.value integerValue];
            break;
        case GoalTypeRace:
            stringForGoal = [NSString stringWithFormat:@"%@/%.1f%@", [RunEvent getPaceString:runForCell.avgPace withMetric:metric showSpeed:showSpeed], [RunEvent getDisplayDistance:runForCell.distance withMetric:metric], [tempPrefs getDistanceUnit]];
            progessValue = runForCell.avgPace / max;
            break;
        case GoalTypeTotalDistance:
            stringForGoal = [NSString stringWithFormat:@"%.1f %@", [RunEvent getDisplayDistance:runForCell.distance withMetric:metric], [tempPrefs getDistanceUnit]];
            progessValue = runForCell.distance / max;
            break;
        default:
            break;
    }
    [label setText:stringForGoal];
    
    //set progress bar for value with custom bar
    UIImage *background = [[UIImage imageNamed:@"progress-bar-bg.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    UIImage *fill = [[UIImage imageNamed:@"progress-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    [progress setTrackImage:background];
    [progress setProgressImage:fill];
    [progress.layer setCornerRadius:6.0f];
    [progress.layer setMasksToBounds:true];
    //ensure bar is within 0-1
    if(progessValue > 1)
        progessValue = 1;
    else if(progessValue < 0)
        progessValue = 0;
    [progress setProgress:progessValue];
    
    //hide progress if run is not applicable, ie. race time
    if([goal.value floatValue] > runForCell.distance && goal.type == GoalTypeRace)
    {
        [progress setHidden:true];
        
        [tooShortLabel setText:NSLocalizedString(@"TooShortLabel", @"label too short goals")];
        [tooShortLabel setHidden:false];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
