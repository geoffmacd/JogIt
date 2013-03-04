//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"


@implementation RunPos

@synthesize pos,elevation,pace,time;

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
@synthesize avgPace;
@synthesize time;
@synthesize live,metric,ghost;
@synthesize checkpoints,distanceCheckpoints,pos,pausePoints;
@synthesize metricGoal;
@synthesize eventType;


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
            return @"Time";
        case MetricTypeClimbed:
            return @"Climbed";
        case MetricTypeCadence:
            return @"Cadence";
        case MetricTypeStride:
            return @"Stride";
    }
    
    return @"UNKNOWNMETRIC";
}

-(id)initWithNoTarget
{
    self = [super init];
    if (self) {
        name = @"";//no name for just go
        metric = NoMetricType;
        metricGoal = 0.0f;
        eventType = EventTypeRun;    //for now this is only possible
        date = [NSDate date];
        distance = 4.1f;
        calories = 301.5f;
        avgPace = 264.3f;
        time = 2063.0f;
        live = true;
        ghost = false;
        return self;
    }
    return nil;
}

-(id)initWithTarget:(RunMetric)type withValue:(CGFloat)value
{
    self = [super init];
    if (self) {
        switch(type)
        {
            case MetricTypePace:
                name = [NSString stringWithFormat:@"%@ Target • %f", [RunEvent stringForMetric:type], value];
                break;
            case MetricTypeCalories:
                name = [NSString stringWithFormat:@"%@ Target • %.0f", [RunEvent stringForMetric:type], value];
                break;
            case MetricTypeDistance:
                name = [NSString stringWithFormat:@"%@ Target • %.1f", [RunEvent stringForMetric:type], value];
                break;
            case MetricTypeTime:
                name = [NSString stringWithFormat:@"%@ Target • %f", [RunEvent stringForMetric:type], value];
                break;
                
        }
        metric = type;
        metricGoal = value;
        eventType = EventTypeRun;    //for now this is only possible
        date = [NSDate date];
        distance = 4.1f;
        calories = 301.5f;
        avgPace = 264.3f;
        time = 2063.0f;
        live = true;
        ghost = false;
        return self;
    }
    return nil;
}




@end
