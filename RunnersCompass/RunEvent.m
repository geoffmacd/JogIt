//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"


@implementation RunPos

@synthesize pos,elevation,velocity;

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {

        
    }
    return self;
}

@end


@implementation RunEvent

@synthesize name;
@synthesize date;
@synthesize calories;
@synthesize distance;
@synthesize pace;
@synthesize time;
@synthesize live;
@synthesize checkpoints,distanceCheckpoints,pos;


-(id)initWithName:(NSString *)_name date:(NSDate *)_date
{
    self = [super init];
    if (self) {
        name = _name;
        date = _date;
        distance = 4.1f;
        calories = 301.5f;
        pace = 264.3f;
        time = 2063.0f;
        live = true;
        return self;
    }
    return nil;
}


+(NSString * )stringForMetric:(RunMetric) metric
{
    switch(metric)
    {
        case MetricTypeCalories:
            return @"Calories";
        case MetricTypeDistance:
            return @"Distance";
        case MetricTypePace:
            return @"Pace";
        case MetricTypeTime:
            return @"Duration";
        case MetricTypeClimbed:
            return @"Climbed";
        case MetricTypeCadence:
            return @"Cadence";
        case MetricTypeStride:
            return @"Stride";
    }
    
    return @"UnknownMetric";
}



@end
