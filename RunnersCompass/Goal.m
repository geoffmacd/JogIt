//
//  Goal.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Goal.h"

@implementation Goal

@synthesize endDate,startDate,type,value,value2,race;

-(id)initWithType:(GoalType)goaltype value:(NSNumber *)Value start:(NSDate *)startD end:(NSDate *)endD
{
    self.type = goaltype;
    self.value = Value;
    self.startDate = startD;
    self.endDate = endD;
    
    return self;
    
}

-(NSString*)getName
{
    return @"Test Goal Name";
}

-(NSArray*)getRaceTypes
{
    return [NSArray arrayWithObjects:@"1 mile", @"3 mile",@"5 mile",@"10 mile",@"5 km",@"10 km",@"Half Marathon",@"Full Marathon", nil];
}

@end
