//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"


@implementation CLLocationMeta

@synthesize time,pace,distance;

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
@synthesize calories,climbed,stride,cadence,steps,descended;
@synthesize distance;
@synthesize avgPace;
@synthesize time;
@synthesize live,targetMetric,ghost;
@synthesize minCheckpointsMeta, minCheckpoints;
@synthesize kmCheckpoints,kmCheckpointsMeta;
@synthesize impCheckpoints,impCheckpointsMeta;
@synthesize metricGoal;
@synthesize eventType;
@synthesize mapPath;
@synthesize pos,posMeta;
@synthesize pausePoints;
@synthesize associatedRun,thumbnail;
@synthesize shortname;


+(NSString * )stringForMetric:(RunMetric) metricForDisplay showSpeed:(BOOL)showSpeed
{
    switch(metricForDisplay)
    {
        case MetricTypeCalories:
            return NSLocalizedString(@"CaloriesMetric", @"Calorie name for title or goal");
        case MetricTypeDistance:
            return NSLocalizedString(@"DistanceMetric", @"Distance name for title or goal");
        case MetricTypePace:
            if(showSpeed)
                return NSLocalizedString(@"SpeedMetric", @"speed name for title or goal");
            else
                return NSLocalizedString(@"PaceMetric", @"Pace name for title or goal");
        case MetricTypeTime:
            return NSLocalizedString(@"TimeMetric", @"Time name for title or goal");
        case MetricTypeClimbed:
            return NSLocalizedString(@"AscentionMetric", @"Climbed name for title or goal");
        case MetricTypeActivityCount:
            return NSLocalizedString(@"CountMetric", @"");
        case MetricTypeCadence:
            return NSLocalizedString(@"CadenceMetric", @"Cadence name for title or goal");
        case MetricTypeStride:
            return NSLocalizedString(@"StrideMetric", @"Stride name for title or goal");
        case MetricTypeDescended:
            return NSLocalizedString(@"DescendMetric", @"");
        case MetricTypeSteps:
            return NSLocalizedString(@"StepsMetric", @"");
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

+(NSString*)getPaceString:(NSTimeInterval)paceToFormat withMetric:(BOOL)metricForDisplay showSpeed:(BOOL)showSpeed
{
    //expects paceToFormat as m/s
    
    //if it is 0 or less, just return 0:00 right away
    if(paceToFormat <= 0)
    {
        if(showSpeed)
            return @"---";
        else
            return @"--:--";
    }
    
    //need to transform to s/km
    paceToFormat = 1000 / paceToFormat;
    
    //convert to min/mile if necessary
    if(!metricForDisplay)
    {
        paceToFormat = paceToFormat / convertKMToMile;
    }
    
    //constrain to 59:59
    if(paceToFormat > 3599)
    {
        if(showSpeed)
            return @"---";
        else
            return @"--:--";
    }
    
    NSString *stringToSetTime = @"";
    
    if(showSpeed)
    {
        //just convert to per hour from s/km or s/mi
        CGFloat speed = 3600 / paceToFormat;
        //set to one decimal place only 
        stringToSetTime = [NSString stringWithFormat:@"%.1f", speed];
    }
    else
    {
        //convert to per minute format
        NSInteger minutes,seconds;
        
        minutes = paceToFormat/ 60;
        seconds = paceToFormat - (minutes * 60);
        
        NSString * minuteTime;
        NSString * secondTime;
        
        if(minutes < 10)
            minuteTime = [NSString stringWithFormat:@"%d", minutes];//minuteTime = [NSString stringWithFormat:@"0%d", minutes];
        else
            minuteTime = [NSString stringWithFormat:@"%d",minutes];
        
        if(seconds < 10)
            secondTime = [NSString stringWithFormat:@"0%d",seconds];
        else
            secondTime = [NSString stringWithFormat:@"%d",seconds];
        
        stringToSetTime = [NSString stringWithFormat:@"%@:%@",minuteTime,secondTime];

    }
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
        return @"--:--";
    
    NSInteger minutes,seconds;
    
    minutes = paceToFormat/ 60;
    seconds = paceToFormat - (minutes * 60);
    
    NSString * minuteTime;
    NSString * secondTime;
    NSString *stringToSetTime;
    
    if(minutes < 10)
        minuteTime = [NSString stringWithFormat:@"%d", minutes];
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

-(NSString*)getDateString
{
    
    //date formatting
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    NSString * dateString = [dateFormatter stringFromDate:associatedRun.date];
    
    return dateString;
}


-(void)processRunForRecord
{

    RunRecord * newRunRecord = [RunRecord MR_createEntity];
    
    //process values
    newRunRecord.name = name;
    newRunRecord.shortname = shortname;
    newRunRecord.date = date;
    newRunRecord.distance = [NSNumber numberWithFloat:distance];
    newRunRecord.calories = [NSNumber numberWithFloat:calories];
    newRunRecord.avgPace = [NSNumber numberWithDouble:avgPace];
    newRunRecord.steps = [NSNumber numberWithInt:steps];
    newRunRecord.time = [NSNumber numberWithDouble:time];
    newRunRecord.eventType = [NSNumber numberWithInt:eventType];
    newRunRecord.targetMetric = [NSNumber numberWithInt:targetMetric];
    newRunRecord.metricGoal = [NSNumber numberWithFloat:metricGoal];
    
    //add thumbnail
    ThumbnailRecord * thumbNailRecord = [ThumbnailRecord MR_createEntity];
    thumbNailRecord.image = thumbnail;
    thumbNailRecord.run = newRunRecord;
    newRunRecord.thumbnail = thumbnail;
    newRunRecord.thumbnailRecord = thumbNailRecord;
    
    //calculate post-processed metrics: descended,climbed,stride,cadence
    BOOL goingUp = false;
    BOOL streaking = false;
    BOOL initStreaking = false;
    CLLocation * startPos;
    CLLocation * lastPos;
    for(CLLocation * curPos in pos)
    {
        if(streaking)
        {
            if(goingUp)
            {
                //curPos must be higher than lastPos
                if(curPos.altitude >= lastPos.altitude)
                {
                    lastPos = curPos;
                    continue;
                }
                else
                {
                    //abort
                    streaking = false;
                    climbed += lastPos.altitude - startPos.altitude;
                }
            }
            else
            {
                //curPos must be lower than lastPos
                if(curPos.altitude <= lastPos.altitude)
                {
                    lastPos = curPos;
                    continue;
                }
                else
                {
                    //abort
                    streaking = false;
                    descended += startPos.altitude - lastPos.altitude;
                }
            }
        }
        else
        {
            if(initStreaking)
            {
                //start streaking
                startPos = curPos;
                initStreaking = false;
                streaking = true;
                //set direction
                if(lastPos.altitude < curPos.altitude)
                    goingUp = true;
                else
                    goingUp = false;
            }
            else
            {
                //wait once
                initStreaking = true;
            }
        }
        
        lastPos = curPos;
    }
    
    //strides per minute
    if(time > 0)
        cadence = steps / (time / 60);
    else
        cadence = 0;
    // m per stride
    if(steps > 0)
        stride = distance / steps;
    else
        stride = 0;
    newRunRecord.cadence = [NSNumber numberWithFloat:cadence];
    newRunRecord.stride = [NSNumber numberWithFloat:stride];
    newRunRecord.climbed = [NSNumber numberWithFloat:climbed];
    newRunRecord.descended = [NSNumber numberWithFloat:descended];
    newRunRecord.steps = [NSNumber numberWithInt:steps];
    
    NSMutableArray * allLocationsToAdd = [NSMutableArray new];
    
    //pos
    for(int i = 0; i < [pos count]; i++)
    {
        CLLocation  * positionToAdd = [pos objectAtIndex:i];
        CLLocationMeta * metaToAdd = [posMeta objectAtIndex:i];
        
        //construct location record
        LocationRecord * recToAdd = [LocationRecord MR_createEntity];
        recToAdd.pace = [metaToAdd pace];
        recToAdd.time = [metaToAdd time];
        recToAdd.distance = [metaToAdd distance];
        recToAdd.type = RecordPosType;
        recToAdd.date = [date timeIntervalSinceReferenceDate];

        recToAdd.location = positionToAdd;
        [allLocationsToAdd addObject:recToAdd];
    }
    //min
    for(int i = 0; i < [minCheckpoints count]; i++)
    {
        CLLocation  * positionToAdd = [minCheckpoints objectAtIndex:i];
        CLLocationMeta * metaToAdd = [minCheckpointsMeta objectAtIndex:i];
        
        //construct location record
        LocationRecord * recToAdd = [LocationRecord MR_createEntity];
        recToAdd.pace = [metaToAdd pace];
        recToAdd.time = [metaToAdd time];
        recToAdd.distance = [metaToAdd distance];
        recToAdd.type = RecordMinType;
        recToAdd.date = [date timeIntervalSinceReferenceDate];
        
        recToAdd.location = positionToAdd;
        [allLocationsToAdd addObject:recToAdd];
    }
    //km
    for(int i = 0; i < [kmCheckpoints count]; i++)
    {
        CLLocation  * positionToAdd = [kmCheckpoints objectAtIndex:i];
        CLLocationMeta * metaToAdd = [kmCheckpointsMeta objectAtIndex:i];
        
        //construct location record
        LocationRecord * recToAdd = [LocationRecord MR_createEntity];
        recToAdd.pace = [metaToAdd pace];
        recToAdd.time = [metaToAdd time];
        recToAdd.distance = [metaToAdd distance];
        recToAdd.type = RecordKmType;
        recToAdd.date = [date timeIntervalSinceReferenceDate];
        
        recToAdd.location = positionToAdd;
        [allLocationsToAdd addObject:recToAdd];
    }
    //miles
    for(int i = 0; i < [impCheckpoints count]; i++)
    {
        CLLocation  * positionToAdd = [impCheckpoints objectAtIndex:i];
        CLLocationMeta * metaToAdd = [impCheckpointsMeta objectAtIndex:i];
        
        //construct location record
        LocationRecord * recToAdd = [LocationRecord MR_createEntity];
        recToAdd.pace = [metaToAdd pace];
        recToAdd.time = [metaToAdd time];
        recToAdd.distance = [metaToAdd distance];
        recToAdd.type = RecordMileType;
        recToAdd.date = [date timeIntervalSinceReferenceDate];
        
        recToAdd.location = positionToAdd;
        [allLocationsToAdd addObject:recToAdd];
    }
    //pausepoints
    for(int i = 0; i < [pausePoints count]; i++)
    {
        CLLocation  * positionToAdd = [pausePoints objectAtIndex:i];
        
        //construct location record
        LocationRecord * recToAdd = [LocationRecord MR_createEntity];
        //no meta to add
        recToAdd.type = RecordPauseType;
        recToAdd.date = [date timeIntervalSinceReferenceDate];
        
        recToAdd.location = positionToAdd;
        [allLocationsToAdd addObject:recToAdd];
    }
    
    //add locations to run record
    newRunRecord.locations = [NSOrderedSet orderedSetWithArray:allLocationsToAdd];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(id)initWithGhostRun:(RunEvent*)associatedRunToGhost
{
    self = [super init];
    if (self) {
        shortname = NSLocalizedString(@"JustGoRunTitle", @"Default run title for just go");//no name for just go
        //name not set
        targetMetric = NoMetricType;
        metricGoal = 0.0f;
        eventType = EventTypeRun;
        date = [NSDate date];
        distance = 0;
        calories = 0;
        avgPace = 0;
        steps = 0;
        cadence = 0.0f;
        stride = 0.0f;
        climbed = 0.0f;
        descended = 0.0f;
        time = 0;
        live = true;
        ghost = true;
        associatedRun = associatedRunToGhost;
        pos  = [[NSMutableArray alloc] initWithCapacity:1000];
        posMeta  = [[NSMutableArray alloc] initWithCapacity:1000];
        kmCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        kmCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        pausePoints = [[NSMutableArray alloc] initWithCapacity:10];
        return self;
    }
    return nil;
}

-(id)initWithNoTarget
{
    self = [super init];
    if (self) {
        shortname = NSLocalizedString(@"JustGoRunTitle", @"Default run title for just go");//no name for just go
        //name not set
        targetMetric = NoMetricType;
        metricGoal = 0.0f;
        eventType = EventTypeRun;    
        date = [NSDate date];
        distance = 0;
        calories = 0;
        avgPace = 0;
        steps = 0;
        cadence = 0.0f;
        stride = 0.0f;
        climbed = 0.0f;
        descended = 0.0f;
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
        return self;
    }
    return nil;
}

-(id)initWithTarget:(RunMetric)type withValue:(CGFloat)value withMetric:(BOOL)metricForDisplay showSpeed:(BOOL)showSpeed
{
    self = [super init];
    
    if (self) {
        
        switch(type)
        {
            case MetricTypePace:
                //never show speed here, only pace including units
                //units will be wrong if metric switched
                shortname = [NSString stringWithFormat:@"%@ %@ • %@ %@", [RunEvent stringForMetric:type showSpeed:false], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getPaceString:value withMetric:metricForDisplay showSpeed:false], [UserPrefs getPaceUnitWithSpeedMetric:metricForDisplay showSpeed:false]];
                name = [NSString stringWithFormat:@"%@ %@ %@", [RunEvent getPaceString:value withMetric:metricForDisplay showSpeed:false], [UserPrefs getPaceUnitWithSpeedMetric:metricForDisplay showSpeed:false], NSLocalizedString(@"TargetInRunTitle", @"target word in title")];
                break;
            case MetricTypeCalories:
                shortname = [NSString stringWithFormat:@"%@ %@ • %.0f %@", [RunEvent stringForMetric:type showSpeed:showSpeed], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), value, NSLocalizedString(@"CalShortForm", @"Shortform for calories")];
                name = [NSString stringWithFormat:@"%.0f %@ %@", value, NSLocalizedString(@"CalShortForm", @"Shortform for calories"), NSLocalizedString(@"TargetInRunTitle", @"target word in title")];
                break;
            case MetricTypeDistance:
                //units are going to be wrong if metric switched
                shortname = [NSString stringWithFormat:@"%@ %@ • %.1f %@", [RunEvent stringForMetric:type showSpeed:showSpeed], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getDisplayDistance:value withMetric:metricForDisplay], [UserPrefs getDistanceUnitWithMetric:metricForDisplay]];
                name = [NSString stringWithFormat:@"%.1f %@ %@", [RunEvent getDisplayDistance:value withMetric:metricForDisplay], [UserPrefs getDistanceUnitWithMetric:metricForDisplay], NSLocalizedString(@"TargetInRunTitle", @"target word in title")];
                break;
            case MetricTypeTime:
                shortname = [NSString stringWithFormat:@"%@ %@ • %@", [RunEvent stringForMetric:type showSpeed:showSpeed], NSLocalizedString(@"TargetInRunTitle", @"target word in title"), [RunEvent getTimeString:value]];
                name = [NSString stringWithFormat:@"%@ %@", [RunEvent getTimeString:value],  NSLocalizedString(@"TargetInRunTitle", @"target word in title")];
                break;
                
            default:
                name = nil;
                break;
                
        }
        targetMetric = type;
        metricGoal = value;
        eventType = EventTypeRun;
        date = [NSDate date];
        distance = 0;
        calories = 0;
        avgPace = 0;
        steps = 0;
        cadence = 0.0f;
        stride = 0.0f;
        climbed = 0.0f;
        descended = 0.0f;
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
        return self;
    }
    return nil;
}

-(id)initWithRecord:(RunRecord*)record
{
    self = [super init];
    
    if (self) {
        name = record.name;
        shortname = record.shortname;
        targetMetric = [record.targetMetric integerValue];
        metricGoal = [record.metricGoal integerValue];
        eventType = [record.eventType integerValue];
        date = record.date;
        distance = [record.distance floatValue];
        calories = [record.calories floatValue];
        avgPace = [record.avgPace doubleValue];
        time = [record.time doubleValue];
        live = false;
        ghost = false;
        steps = [record.steps integerValue];
        cadence = [record.cadence floatValue];
        stride = [record.stride floatValue];
        climbed = [record.climbed floatValue];
        descended = [record.descended floatValue];
        
        thumbnail = record.thumbnailRecord.image;
        
        pos  = [[NSMutableArray alloc] initWithCapacity:1000];
        posMeta  = [[NSMutableArray alloc] initWithCapacity:1000];
        kmCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        kmCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        minCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpoints  = [[NSMutableArray alloc] initWithCapacity:100];
        impCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:100];
        pausePoints = [[NSMutableArray alloc] initWithCapacity:10];
        return self;
    }
    return nil;
}

-(id)initWithRecordToLogger:(RunRecord*)record
{
    self = [super init];
    
    if (self) {
        name = record.name;
        shortname = record.shortname;
        targetMetric = [record.targetMetric integerValue];
        metricGoal = [record.metricGoal integerValue];
        eventType = [record.eventType integerValue];
        date = record.date;
        distance = [record.distance floatValue];
        calories = [record.calories floatValue];
        avgPace = [record.avgPace doubleValue];
        time = [record.time doubleValue];
        live = false;
        ghost = false;
        steps = [record.steps integerValue];
        cadence = [record.cadence floatValue];
        stride = [record.stride floatValue];
        climbed = [record.climbed floatValue];
        descended = [record.descended floatValue];
        
        thumbnail = record.thumbnailRecord.image;
        
        pos  = [[NSMutableArray alloc] initWithCapacity:time /3];
        posMeta  = [[NSMutableArray alloc] initWithCapacity:time /3];
        minCheckpoints  = [[NSMutableArray alloc] initWithCapacity:time/60];
        minCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:time/60];
        kmCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:distance/1000];
        kmCheckpoints  = [[NSMutableArray alloc] initWithCapacity:distance/1000];
        impCheckpoints  = [[NSMutableArray alloc] initWithCapacity:distance/1600];
        impCheckpointsMeta  = [[NSMutableArray alloc] initWithCapacity:distance/1600];
        pausePoints = [[NSMutableArray alloc] initWithCapacity:10]; //expect 10 pauses at best
        
        NSOrderedSet * allLocs = record.locations;
        
        NSLog(@"Retrieved location records %f",[NSDate timeIntervalSinceReferenceDate]);
        
        //no need to sort, since stored as nsorderedset
        /*
        NSArray * timeOrderLocs = [allLocs sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSNumber * time1 = [obj1 valueForKeyPath:@"time"];
            NSNumber * time2 = [obj2 valueForKeyPath:@"time"];
            return (NSComparisonResult)[time1 compare:time2];
        }];
         
         NSLog(@"Sorted location records %f",[NSDate timeIntervalSinceReferenceDate]);
        */
        
        //add to correct array
        for(LocationRecord * rec in [allLocs array])//timeOrderLocs)
        {
            //stuff to add
            CLLocationMeta * metaToAdd = [[CLLocationMeta alloc] init];
            //meta should be same for all types me thinks
            metaToAdd.time = rec.time;
            metaToAdd.pace = rec.pace;
            metaToAdd.distance = rec.distance;
            CLLocation * locationToAdd = rec.location;
            
            //already ordered so timing is gauraunteed
            switch(rec.type)
            {
                case RecordPosType:
                    [pos addObject:locationToAdd];
                    [posMeta addObject:metaToAdd];
                    break;
                    
                case RecordMinType:
                    [minCheckpoints addObject:locationToAdd];
                    [minCheckpointsMeta addObject:metaToAdd];
                    break;
                    
                case RecordKmType:
                    [kmCheckpoints addObject:locationToAdd];
                    [kmCheckpointsMeta addObject:metaToAdd];
                    break;
                    
                case RecordMileType:
                    [impCheckpoints addObject:locationToAdd];
                    [impCheckpointsMeta addObject:metaToAdd];
                    break;
                    
                case RecordPauseType:
                    [pausePoints addObject:locationToAdd];
                    break;
                    
                default:
                    NSLog(@"bad location record type");
                    break;
            }
        }
        
        NSLog(@"Loading Run from Record %f",[NSDate timeIntervalSinceReferenceDate]);
        return self;
    }
    return nil;
}


@end
