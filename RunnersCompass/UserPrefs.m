//
//  UserPrefs.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UserPrefs.h"

@implementation UserPrefs

@synthesize autopause,weight,fullname,birthdate,metric,countdown,showSpeed;
//@synthesize facebook,twitter;

+ (id)defaultUser{
    UserPrefs * new = [[UserPrefs alloc] init];
    
    new.countdown = [NSNumber numberWithInt:3];
    new.autopause = [NSNumber numberWithInt:0];
    new.weight = [NSNumber numberWithInt:150];
    //new.twitter = [NSNumber numberWithInt:0];
    //new.facebook = [NSNumber numberWithInt:0];
    //find systems default unit measure
    NSLocale *locale = [NSLocale currentLocale];
    //BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    new.metric = [NSNumber numberWithBool:false];
    new.showSpeed = [NSNumber numberWithBool:false];
    
    //best to leave these blank so user does not have to backspace them
    new.fullname = nil;
    new.birthdate = nil;
    
    return new;
}

+(NSString*)getDistanceUnitWithMetric:(BOOL) forMetric
{
    
    //should not need to be translated
    
    if(forMetric)
        return NSLocalizedString(@"KmMetricUnitShort", @"shortform for km");
    else
        return NSLocalizedString(@"MiImperialUnitShort", @"shortform for mi");
    
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
