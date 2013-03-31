//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"


@implementation CLLocationMeta

@synthesize time,pace;

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
@synthesize minCheckpointsMeta, minCheckpoints;
@synthesize kmCheckpoints,kmCheckpointsMeta;
@synthesize impCheckpoints,impCheckpointsMeta;
@synthesize metricGoal;
@synthesize eventType;
@synthesize map;
@synthesize pos,posMeta;
@synthesize pausePoints;
@synthesize associatedRun;


+(NSString * )stringForMetric:(RunMetric) metricForDisplay
{
    switch(metricForDisplay)
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
        default:
            return @"UNKNOWNMETRIC";
    }
    
    return @"UNKNOWNMETRIC";
}

+(NSString * )stringForRace:(RaceType) metricForDisplay
{
    switch(metricForDisplay)
    {
        case RaceType5Km:
            return NSLocalizedString(@"5kRace", @"race name");
        case RaceType10Km:
            return NSLocalizedString(@"10kRace", @"race name");
        case RaceType10Mile:
            return NSLocalizedString(@"10mileRace", @"race name");
        case RaceTypeHalfMarathon:
            return NSLocalizedString(@"halfmarathonRace", @"race name");
        case RaceTypeFullMarathon:
            return NSLocalizedString(@"fullmarathonRace", @"race name");
        case NoRaceType:
            return @"UNKNOWNMETRIC";
    }
    
    return @"UNKNOWNMETRIC";
}

+(CGFloat)getDisplayDistance:(CGFloat)distanceToDisplayInM withMetric:(BOOL)metricForDisplay
{
    distanceToDisplayInM = distanceToDisplayInM / 1000;
    
    if(!metricForDisplay)
        distanceToDisplayInM = convertKMToMile * distanceToDisplayInM;
    
    return distanceToDisplayInM;
}

+(NSString*)getPaceString:(NSTimeInterval)paceToFormat withMetric:(BOOL)metricForDisplay
{
    //expects paceToFormat as m/s
    //need to transform to s/km
    
    //if it is 0 , just return 0:00 right away
    if(paceToFormat == 0)
        return @"0:00";
    
    paceToFormat = 1000 / paceToFormat;
    
    //convert to min/mile if necessary
    if(!metricForDisplay)
    {
        paceToFormat = paceToFormat / convertKMToMile;
    }
    
    //constrain to 30:00
    if(paceToFormat > 1800)
        return @"30:00";
    
    NSInteger minutes,seconds;
    
    minutes = paceToFormat/ 60;
    seconds = paceToFormat - (minutes * 60);
    
    NSString * minuteTime;
    NSString * secondTime;
    NSString *stringToSetTime;
    
    if(minutes < 10)
        minuteTime = [NSString stringWithFormat:@"0%d", minutes];
    else
        minuteTime = [NSString stringWithFormat:@"%d",minutes];
    
    if(seconds < 10)
        secondTime = [NSString stringWithFormat:@"0%d",seconds];
    else
        secondTime = [NSString stringWithFormat:@"%d",seconds];
    
    stringToSetTime = [NSString stringWithFormat:@"%@:%@",minuteTime,secondTime];
    
    return stringToSetTime;
    
}

+(NSString*)getCurKMPaceString:(NSTimeInterval)paceToFormat
{
    //expects paceToFormat as s
    //not a complete km so no mile conversion
    
    //if it is 0 , just return 0:00 right away
    if(paceToFormat == 0)
        return @"0:00";
    
    //constrain to 59:59
    if(paceToFormat > 3599)
        return @"59:59";
    
    NSInteger minutes,seconds;
    
    minutes = paceToFormat/ 60;
    seconds = paceToFormat - (minutes * 60);
    
    NSString * minuteTime;
    NSString * secondTime;
    NSString *stringToSetTime;
    
    if(minutes < 10)
        minuteTime = [NSString stringWithFormat:@"0%d", minutes];
    else
        minuteTime = [NSString stringWithFormat:@"%d",minutes];
    
    if(seconds < 10)
        secondTime = [NSString stringWithFormat:@"0%d",seconds];
    else
        secondTime = [NSString stringWithFormat:@"%d",seconds];
    
    stringToSetTime = [NSString stringWithFormat:@"%@:%@",minuteTime,secondTime];
    
    return stringToSetTime;
    
}

+(NSString*)getTimeString:(NSTimeInterval)timeToFormat
{
    if(timeToFormat > 3600000)
        return @"99:99:99";
        
    
    NSInteger hours,minutes,seconds;
    
    hours = timeToFormat / 3600;
    minutes = timeToFormat/ 60 - (hours*60);
    seconds = timeToFormat - (minutes * 60) - (hours * 3600);
    
    NSString * hourTime;
    NSString * minuteTime;
    NSString * secondTime;
    NSString *stringToSetTime;
    if(hours < 10)
        hourTime = [NSString stringWithFormat:@"0%d", hours];
    else
        hourTime = [NSString stringWithFormat:@"%d",hours];
    
    if(minutes < 10)
        minuteTime = [NSString stringWithFormat:@"0%d", minutes];
    else
        minuteTime = [NSString stringWithFormat:@"%d",minutes];
    
    if(seconds < 10)
        secondTime = [NSString stringWithFormat:@"0%d",seconds];
    else
        secondTime = [NSString stringWithFormat:@"%d",seconds];
    
    stringToSetTime = [NSString stringWithFormat:@"%@:%@:%@", hourTime,minuteTime,secondTime];
    
    return stringToSetTime;
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
        distance = 0;
        calories = 0;
        avgPace = 0;
        time = 0;
        live = true;
        ghost = false;
        pos  = [[NSMutableArray alloc] initWithCapacity:1000];
        posMeta  = [[NSMutableArray alloc] initWithCapacity:1000];
        kmCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        kmCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        pausePoints = [[NSMutableArray alloc] initWithCapacity:10];
        map = [[RunMap alloc] init];
        return self;
    }
    return nil;
}

-(id)initWithTarget:(RunMetric)type withValue:(CGFloat)value withMetric:(BOOL)metricForDisplay
{
    self = [super init];
    
    if (self) {
        switch(type)
        {
            case MetricTypePace:
                name = [NSString stringWithFormat:@"%@ %@ • %@", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getPaceString:value withMetric:metricForDisplay]];
                break;
            case MetricTypeCalories:
                name = [NSString stringWithFormat:@"%@ %@ • %.0f", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value];
                break;
            case MetricTypeDistance:
                name = [NSString stringWithFormat:@"%@ %@ • %.1f %@", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getDisplayDistance:value withMetric:metricForDisplay], [UserPrefs getDistanceUnitWithMetric:metricForDisplay]];
                break;
            case MetricTypeTime:
                name = [NSString stringWithFormat:@"%@ %@ • %@", [RunEvent stringForMetric:type], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getTimeString:value]];
                break;
                
            default:
                name = nil;
                break;
                
        }
        metric = type;
        metricGoal = value;
        eventType = EventTypeRun;    //for now this is only possible
        date = [NSDate date];
        distance = 0;
        calories = 0;
        avgPace = 0;
        time = 0;
        live = true;
        ghost = false;
        pos  = [[NSMutableArray alloc] initWithCapacity:1000];
        posMeta  = [[NSMutableArray alloc] initWithCapacity:1000];
        kmCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        kmCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        pausePoints = [[NSMutableArray alloc] initWithCapacity:10];
        map = [[RunMap alloc] init];
        return self;
    }
    return nil;
}




@end
