//
//  UserPrefs.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UserPrefs.h"

@implementation UserPrefs

@dynamic autopause;
@dynamic metric;
@dynamic showSpeed;
@dynamic countdown;
@dynamic weight;
@dynamic fullname;
@dynamic birthdate;
@dynamic speech;
@dynamic speechTime;
@dynamic speechPace;
@dynamic speechDistance;
@dynamic speechCalories;
@dynamic speechCurPace;
@dynamic weekly;
@dynamic purchased;

+(NSString*)getDistanceUnitWithMetric:(BOOL) forMetric
{
    
    //should not need to be translated
    
    if(forMetric)
        return NSLocalizedString(@"KmMetricUnitShort", @"shortform for km");
    else
        return NSLocalizedString(@"MiImperialUnitShort", @"shortform for mi");
    
}


+(NSString*)getPaceUnitWithSpeedMetric:(BOOL)metric showSpeed:(BOOL)showSpeed
{
    
    //should not need to be translated
    
    if(showSpeed)
    {
        if(metric)
            return NSLocalizedString(@"KPHUnitShort", @"shortform for kph");
        else
            return NSLocalizedString(@"MPHUnitShort", @"shortform for mph");
    }
    else
    {
        if(metric)
            return NSLocalizedString(@"MinKmMetricUnitShort", @"shortform for min/km");
        else
            return NSLocalizedString(@"MinMiImperialUnitShort", @"shortform for min/mile");
    }
    
}


-(NSString*)getDistanceUnit
{
    
    //should not need to be translated
    
    if([self.metric boolValue])
        return NSLocalizedString(@"KmMetricUnitShort", @"shortform for km");
    else
        return NSLocalizedString(@"MiImperialUnitShort", @"shortform for mi");
    
}

-(NSString*)getPaceUnit
{
    
    //should not need to be translated
    
    if([self.showSpeed boolValue])
    {
        if([self.metric boolValue])
            return NSLocalizedString(@"KPHUnitShort", @"shortform for kph");
        else
            return NSLocalizedString(@"MPHUnitShort", @"shortform for mph");
    }
    else
    {
        if([self.metric boolValue])
            return NSLocalizedString(@"MinKmMetricUnitShort", @"shortform for min/km");
        else
            return NSLocalizedString(@"MinMiImperialUnitShort", @"shortform for min/mile");
    }
    
}


-(NSString*)getTimeString:(NSTimeInterval) f
{
    //should not need to be converted to other units just hh:mm
    
    
    NSString * stringToReturn;
    
    NSInteger minutes = f / 60;
    NSInteger seconds = f - (minutes * 60);
    
    stringToReturn = [NSString stringWithFormat:@"%d:%d", minutes, seconds];
    
    return stringToReturn;
    
    
}


-(NSString*)getTimeStringWithSeconds:(NSTimeInterval) f
{
    //should not need to be converted to other units just hh:mm:ss
    
    NSString * stringToReturn;
    
    NSInteger hours = f / 3600;
    NSInteger minutes = f - (hours * 3600);
    NSInteger seconds = f - (minutes * 60);
    
    stringToReturn = [NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds];
    
    return stringToReturn;
}



@end
