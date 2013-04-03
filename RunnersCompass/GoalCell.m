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

@synthesize label,progress,dateLabel;

-(void)setupWithRun:(RunEvent*)runForCell withGoal:(Goal*)goal withMetric:(BOOL)metric
{
    //always show the date in label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString * header = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:runForCell.date]];
    [dateLabel setText:header];
    
    //set value for goal
    NSString * stringForGoal;
    CGFloat progessValue = 0.0;
    UserPrefs * tempPrefs = [UserPrefs defaultUser];
    tempPrefs.metric = [NSNumber numberWithBool:metric];
    switch(goal.type)
    {
        case GoalTypeCalories:
            stringForGoal = [NSString stringWithFormat:@"%.0f cal", runForCell.calories];
            break;
        case GoalTypeOneDistance:
            stringForGoal = [NSString stringWithFormat:@"%.1f %@", runForCell.distance, [tempPrefs getDistanceUnit]];
            break;
        case GoalTypeRace:
            stringForGoal = [NSString stringWithFormat:@"%@", [RunEvent getPaceString:runForCell.avgPace withMetric:metric]];
            break;
        case GoalTypeTotalDistance:
            stringForGoal = [NSString stringWithFormat:@"%.1f %@", runForCell.distance, [tempPrefs getDistanceUnit]];
            break;
        default:
            break;
    }
    
    //set progress bar for value with custom bar
    UIImage *background = [[UIImage imageNamed:@"progress-bar-bg.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    UIImage *fill = [[UIImage imageNamed:@"progress-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    [progress setTrackImage:background];
    [progress setProgressImage:fill];
    [progress.layer setCornerRadius:6.0f];
    [progress.layer setMasksToBounds:true];
    [progress setProgress:progessValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
