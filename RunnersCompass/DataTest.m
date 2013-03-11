//
//  DataTest.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "DataTest.h"

@implementation DataTest

@synthesize curGoal,curRun,prefs,analysis;



+ (id)sharedData{
    
    static DataTest *sharedData;
    
    @synchronized(self) {
        if (sharedData == nil)
            sharedData = [[self alloc] init];
    }
    return sharedData;
}

- (id)init{
    
    curGoal = nil;//[[Goal alloc] initWithType:GoalTypeCalories value:[NSNumber numberWithInt:10000] start:[NSDate date] end:[NSDate date] ];
    prefs = [UserPrefs defaultUser];
    curRun = nil;//[[RunEvent alloc] initWithName:@"Test Run from core" date:[NSDate date]];
    analysis = nil;
    
    return self;
}

@end
