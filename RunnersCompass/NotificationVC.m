//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//


#import "NotificationVC.h"

@implementation NotificationVC

@synthesize type, type2, type3, type4, oldPR,prRun,prefs;
@synthesize titleLabel,hideLabel,recordLabel,recordLabel2,recordLabel3,recordLabel4;

-(void)setPRLabels
{
    
    if(type)
        [recordLabel setText:[self descriptionForPR:type]];
    else
        [recordLabel setHidden:true];
    if(type2)
        [recordLabel2 setText:[self descriptionForPR:type2]];
    else
        [recordLabel2 setHidden:true];
    if(type3)
        [recordLabel3 setText:[self descriptionForPR:type3]];
    else
        [recordLabel3 setHidden:true];
    if(type4)
        [recordLabel4 setText:[self descriptionForPR:type4]];
    else
        [recordLabel4 setHidden:true];
}

-(NSString*)descriptionForPR:(RunMetric)metric
{
    NSString * description;
    BOOL metricForDisplay = [prefs.metric boolValue];
    BOOL showSpeed = [prefs.showSpeed boolValue];
    
    switch (metric) {
        case MetricTypeTime:
            description = [NSString stringWithFormat:@"%@ • %@", NSLocalizedString(@"LongestRunDescription", @"notification longest run word"), [RunEvent getTimeString: prRun.time]];
            break;
            
        case MetricTypePace:
            description = [NSString stringWithFormat:@"%@ • %@ %@", NSLocalizedString(@"FastestRunDescription", @"notification fastest run word"), [RunEvent getPaceString:prRun.avgPace withMetric:metricForDisplay showSpeed:showSpeed], [UserPrefs getPaceUnitWithSpeedMetric:metricForDisplay showSpeed:showSpeed]];
            break;
        case MetricTypeCalories:
            description = [NSString stringWithFormat:@"%@ • %.0f %@", NSLocalizedString(@"CaloriesRunDescription", @"notification calories run word") , prRun.calories, NSLocalizedString(@"CalShortForm", @"Shortform for calories")];
            break;
        case MetricTypeDistance:
            description = [NSString stringWithFormat:@"%@ • %.1f %@", NSLocalizedString(@"FurthestRunDescription", @"notification furthest run word"), [RunEvent getDisplayDistance:prRun.distance withMetric:metricForDisplay], [UserPrefs getDistanceUnitWithMetric:metricForDisplay]];
            break;
        default:
            break;
    }
    
    return description;
}

@end
