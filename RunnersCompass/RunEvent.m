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
            return NSLocalizedString(@"CaloriesMetric", @"Calorie name for title or goal");
        case MetricTypeDistance:
            return NSLocalizedString(@"DistanceMetric", @"Distance name for title or goal");
        case MetricTypePace:
            return NSLocalizedString(@"PaceMetric", @"Pace name for title or goal");
        case MetricTypeTime:
            return NSLocalizedString(@"TimeMetric", @"Time name for title or goal");
        case MetricTypeClimbed:
            return NSLocalizedString(@"AscentionMetric", @"Climbed name for title or goal");
        case MetricTypeCadence:
            return NSLocalizedString(@"CadenceMetric", @"Cadence name for title or goal");
        case MetricTypeStride:
            return NSLocalizedString(@"StrideMetric", @"Stride name for title or goal");
        case NoMetricType:
            return @"UNKNOWNMETRIC";
    }
    
    return @"UNKNOWNMETRIC";
}

-(id)initWithNoTarget
{
    self = [super init];
    if (self) {
        name = NSLocalizedString(@"JustGoRunTitle", @"Default run title for just go");//no name for just go
        metric = NoMetricType;
        metricGoal = 0.0f;
        eventType = EventTypeRun;    //for now this is only possible
        date = [NSDate date];
        distance = 4.1f;
        calories = 301.5f;
        avgPace = 264;
        time = 2063;
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
                name = [NSString stringWithFormat:@"%@ %@ • %f", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value];
                break;
            case MetricTypeCalories:
                name = [NSString stringWithFormat:@"%@ %@ • %.0f", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value];
                break;
            case MetricTypeDistance:
                name = [NSString stringWithFormat:@"%@ %@ • %.1f %@", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value, @"KM"];
                break;
            case MetricTypeTime:
                name = [NSString stringWithFormat:@"%@ %@ • %f", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value];
                break;
                
            case MetricTypeCadence:
            case MetricTypeStride:
            case MetricTypeClimbed:
            case NoMetricType:
                name = nil;
                break;
                
        }
        metric = type;
        metricGoal = value;
        eventType = EventTypeRun;    //for now this is only possible
        date = [NSDate date];
        distance = 4.1f;
        calories = 301.5f;
        avgPace = 264;
        time = 2063;
        live = true;
        ghost = false;
        return self;
    }
    return nil;
}




@end
