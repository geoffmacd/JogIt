//
//  UserPrefs.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UserPrefs.h"

@implementation UserPrefs

@synthesize facebook,twitter,autopause,weight,fullname,birthdate,metric,countdown;

+ (id)defaultUser{
    UserPrefs * new = [[UserPrefs alloc] init];
    
    new.countdown = [NSNumber numberWithInt:3];
    new.autopause = [NSNumber numberWithInt:0];
    new.twitter = [NSNumber numberWithInt:0];
    new.facebook = [NSNumber numberWithInt:0];
    //find systems default unit measure
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    new.metric = [NSNumber numberWithInt:isMetric];
    new.weight = [NSNumber numberWithInt:150];
    
    //best to leave these blank so user does not have to backspace them
    new.fullname = nil;
    new.birthdate = nil;
    
    return new;
}

-(NSString*)getDistanceUnit
{
    
    //should not need to be translated
    
    if([self.metric boolValue])
        return @"Km";
    else
        return @"Mi";
    
}


@end
