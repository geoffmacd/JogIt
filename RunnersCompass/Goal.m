//
//  Goal.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Goal.h"

@implementation Goal

@synthesize endDate,startDate,type,value,time,race,activityCount,weight,metricValueChange,progress,raceDictionary,fatDictionary;

-(id)initWithType:(GoalType)typeToCreate
{
    self.type = typeToCreate;
    
    self.startDate = [NSDate date];

    
    return self;
    
}

-(id)initWithRecord:(GoalRecord*)record
{
    self = [super init];
    
    if (self) {
        
        type = [record.type integerValue];
        startDate = record.startDate;
        endDate = record.endDate;   //for now this is only possible
        value = record.value;
        time = record.time;
        return self;
    }
    return nil;
}

-(NSString*)getName:(BOOL)metric
{
    NSString * goalName;//generate every time
    
    //need time components for race
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components;

    NSString *endString = @"";
    
    UserPrefs * tempPrefs = [UserPrefs MR_findFirst];
    tempPrefs.metric = [NSNumber numberWithBool:metric];

    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            goalName = [NSString stringWithFormat:@"%@: %@ %@ %@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"LoseWord",@"Word for Lose in title"),[Goal getWeightNameForCals:[self.value integerValue]], endString];
            break;
        case GoalTypeOneDistance:
            goalName = [NSString stringWithFormat:@"%@: %@ %@ race%@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),[Goal getRaceNameForRun:[self.value floatValue]], endString];
            break;
        case GoalTypeRace:
            components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:time];
            if(components.hour > 0)
                goalName = [NSString stringWithFormat:@"%@: %@ %@ %@ %d hr %d min", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),[Goal getRaceNameForRun:[self.value floatValue]], NSLocalizedString(@"InWord",@"Word for in in title"), components.hour, components.minute];
            else
                goalName = [NSString stringWithFormat:@"%@: %@ %@ %@ %d min", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),[Goal getRaceNameForRun:[self.value floatValue]], NSLocalizedString(@"InWord",@"Word for in in title"), components.minute];
            break;
        case GoalTypeTotalDistance:
            goalName = [NSString stringWithFormat:@"%@: %@ %.0f %@ %@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"LogWord",@"Word for log in title"), [RunEvent getDisplayDistance:[self.value floatValue] withMetric:metric], [tempPrefs getDistanceUnit],  endString];
            break;
        default:
            return NSLocalizedString(@"GoalNameBadGoalType",@"bad goal type");//return @"bad goal name";
    }
    
    return goalName;

}

+(NSInteger)getCalorieForWeight:(NSInteger)lbs
{
    NSInteger cals = (lbs + 1) * calsInLbFat;
    
    return cals;
}


+(NSNumber*)getRaceDistance:(NSString*)stringForRace
{
    NSArray * raceValues = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1610],
                            [NSNumber numberWithFloat:4830],
                            [NSNumber numberWithFloat:8050],
                            [NSNumber numberWithFloat:16100],
                            [NSNumber numberWithFloat:1000],
                            [NSNumber numberWithFloat:3000],
                            [NSNumber numberWithFloat:5000],
                            [NSNumber numberWithFloat:10000],
                            [NSNumber numberWithFloat:21100],
                            [NSNumber numberWithFloat:42200], nil];
    
    NSArray * raceNames = [Goal getRaceNames];
    
    NSInteger arrayIndex = [raceNames indexOfObject:stringForRace];
    
    
    
    
    if(arrayIndex != NSNotFound)
    {
        NSNumber * raceValue = [raceValues objectAtIndex:arrayIndex];
        return raceValue;
    }
    
    return [NSNumber numberWithInt:0];
}

+(NSNumber*)getWeight:(NSString*)stringForWeight
{
    
    NSArray * weightNames = [Goal getWeightNames];
    
    NSInteger arrayIndex = [weightNames indexOfObject:stringForWeight];
    
    if(arrayIndex != NSNotFound)
    {
        return [NSNumber numberWithInt:arrayIndex+1];
    }
    
    return [NSNumber numberWithInt:0];
}



+(NSArray*)getRaceNames
{
    
    return [NSArray arrayWithObjects:NSLocalizedString(@"1mile",nil),
            NSLocalizedString(@"3mile",nil),
            NSLocalizedString(@"5mile",nil),
            NSLocalizedString(@"10mile",nil),
            NSLocalizedString(@"1km",nil),
            NSLocalizedString(@"3km",nil),
            NSLocalizedString(@"5km",nil),
            NSLocalizedString(@"10km",nil),
            NSLocalizedString(@"halfmarathon",nil),
            NSLocalizedString(@"fullmarathon",nil), nil];
}

+(NSString*)getRaceNameForRun:(CGFloat)distance
{
    NSArray * raceValues = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1610],
                            [NSNumber numberWithFloat:4830],
                            [NSNumber numberWithFloat:8050],
                            [NSNumber numberWithFloat:16100],
                            [NSNumber numberWithFloat:1000],
                            [NSNumber numberWithFloat:3000],
                            [NSNumber numberWithFloat:5000],
                            [NSNumber numberWithFloat:10000],
                            [NSNumber numberWithFloat:21100],
                            [NSNumber numberWithFloat:42200], nil];
    
    NSArray * raceNames =  [Goal getRaceNames];
    
    NSInteger arrayIndex = [raceValues indexOfObject:[NSNumber numberWithFloat:distance]];
    
    NSString * raceName = @"";
    
    if(arrayIndex != NSNotFound)
    {
        //should be at same index
        raceName = [raceNames objectAtIndex:arrayIndex];
        return raceName;
    }
    
    return raceName;
}

+(NSString*)getWeightNameForCals:(NSInteger)lbs
{
    
    NSString * raceName = [NSString stringWithFormat:@"%d lbs", lbs];
    
    
    return raceName;
}

+(NSArray*)getWeightNames
{
    
    //set up weight loss strings
    NSMutableArray  * fatKeys= [[NSMutableArray alloc] initWithCapacity:30];
    //start at 1 lb, end at 30lb
    for(int i = 1; i<= 30; i++)
    {
        [fatKeys addObject:[NSString stringWithFormat:@"%d lb", i]];
    }
    
    return fatKeys;
}


-(NSString *)stringForDescription
{
    NSString * description;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            description = NSLocalizedString(@"GoalDescriptCalories",@"goal descriptions");//@"Weight Loss";
            break;
        case GoalTypeOneDistance:
            description = NSLocalizedString(@"GoalDescriptOneDistance",@"goal descriptions"); //@"Furthest Distance";
            break;
        case GoalTypeRace:
            description = NSLocalizedString(@"GoalDescriptRace",@"goal descriptions");//@"Fastest Race Time";
            break;
        case GoalTypeTotalDistance:
            description = NSLocalizedString(@"GoalDescriptTotalDistance",@"goal descriptions");//@"Total Distance";
            break;
        default:
            return NSLocalizedString(@"GoalDescriptionBadMetric",@"bad metric for goal description");//@"bad subtitle";//return @"bad description";
    }
    
    return description;
}

-(NSString *)stringForProgress
{
    NSString * progressString;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            progressString = NSLocalizedString(@"GoalprogressCalories",@"goal progress");//@"Weight Loss";
            break;
        case GoalTypeOneDistance:
            progressString = NSLocalizedString(@"GoalprogressOneDistance",@"goal progress"); //@"Furthest Distance";
            break;
        case GoalTypeRace:
            progressString = NSLocalizedString(@"GoalprogressRace",@"goal progress");//@"Fastest Race Time";
            break;
        case GoalTypeTotalDistance:
            progressString = NSLocalizedString(@"GoalprogressTotalDistance",@"goal progress");//@"Total Distance";
            break;
        default:
            return NSLocalizedString(@"GoalprogressBadMetric",@"bad metric for goal progress");//@"bad subtitle";//return @"bad description";
    }
    
    return progressString;
}



-(NSString *)stringSubtitleDescription
{
    NSString * description;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            description = NSLocalizedString(@"GoalSubtitleDescriptCalories",@"goal subtitle descriptions for edit");//@"Enter Target Weight Loss";
            break;
        case GoalTypeOneDistance:
            description = NSLocalizedString(@"GoalSubtitleDescriptOneDistance",@"goal subtitle descriptions for edit");//@"Enter Distance Target";
            break;
        case GoalTypeRace:
            description = NSLocalizedString(@"GoalSubtitleDescriptRace",@"goal header descriptions for edit");//@"Enter Fastest Time for Distance";
            break;
        case GoalTypeTotalDistance:
            description = NSLocalizedString(@"GoalSubtitleDescriptTotalDistance",@"goal header descriptions for edit");//@"Enter Total Distance To Log";
            break;
        default:
            return NSLocalizedString(@"GoalSubtitleBadMetric",@"bad metric for goal subtitle in edit");//@"bad subtitle";//return @"bad description";
    }
    
    return description;
}


-(NSString *)stringForHeaderDescription
{
    NSString * description;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            description = NSLocalizedString(@"GoalHeaderDescriptCalories",@"goal header descriptions for edit");//@"Enter Target Weight Loss";
            break;
        case GoalTypeOneDistance:
            description = NSLocalizedString(@"GoalHeaderDescriptOneDistance",@"goal header descriptions for edit");//@"Enter Distance Target";
            break;
        case GoalTypeRace:
            description = NSLocalizedString(@"GoalHeaderDescriptRace",@"goal header descriptions for edit");//@"Enter Fastest Time for Distance";
            break;
        case GoalTypeTotalDistance:
            description = NSLocalizedString(@"GoalHeaderDescriptTotalDistance",@"goal header descriptions for edit");//@"Enter Total Distance To Log";
            break;
        default:
            return NSLocalizedString(@"GoalHeaderBadMetric",@"bad metric for goal header in edit");//@"bad subtitle";//return @"bad description";
    }
    
    return description;
}


-(NSString *)stringForEdit2
{
    NSString * description;
    
    switch(type)
    {       
        case GoalTypeRace:
            return NSLocalizedString(@"GoalEditSecondChoiceRace",@"goal edit second dscrition for race");//@"Time to Beat";
        case GoalTypeCalories:
        case GoalTypeOneDistance:
        case GoalTypeTotalDistance:
            return nil;
        default:
            return NSLocalizedString(@"GoalEditSecondChoiceBadMetric",@"bad metric for goal edit second edit");//@"bad subtitle";//return @"bad description";
    }
    
    return description;
}


-(NSString *)stringForEdit1
{
    return [self stringForDescription];
}




-(NSString*)stringForSubtitle
{
    
    NSString * subtitle;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            subtitle = NSLocalizedString(@"SubtitleGoalTypeCalories",@"3500cal/1lb fat for calories goal subtitle");//@"3500cal/1lb fat";
            break;
        case GoalTypeOneDistance:
            subtitle = NSLocalizedString(@"SubtitleGoalTypeOneDistance",@"nothing here for one distance goal");
            break;
        case GoalTypeRace:
            subtitle = NSLocalizedString(@"SubtitleGoalTypeRace",@"nothing here for one race goal");
            break;
        case GoalTypeTotalDistance:
            subtitle = NSLocalizedString(@"SubtitleGoalTypeTotalDistance",@"nothing here for one total distance goal");
            break;
            
        default:
            return NSLocalizedString(@"SubtitleBadMetric",@"bad metric for goal subtitle");//@"bad subtitle";
    }
    
    return subtitle;
    
}

-(BOOL)processGoalForRuns:(NSMutableArray *)runsToAnalyze withMetric:(BOOL)metric
{
    //determine if goal is acheived
    //set activitycount,metricValueChange,progress
    
    CGFloat min = 9999999;
    CGFloat max = 0;
    CGFloat avg = 0;
    CGFloat total = 0;
    NSInteger runCount = [runsToAnalyze count];
    
    for(RunEvent * run in runsToAnalyze)
    {
        switch(type)
        {
            case GoalTypeCalories:
                avg += run.calories;
                if(run.calories < min)
                    min = run.calories;
                if(run.calories > max)
                    max = run.calories;
                break;
            case GoalTypeOneDistance:
                avg += run.distance;
                if(run.distance < min)
                    min = run.distance;
                if(run.distance > max)
                    max = run.distance;
                break;
            case GoalTypeRace:
                avg += run.avgPace;
                if(run.avgPace < min)
                    min = run.avgPace;
                if(run.avgPace > max)
                    max = run.avgPace;
                break;
            case GoalTypeTotalDistance:
                avg += run.distance;
                if(run.distance < min)
                    min = run.distance;
                if(run.distance > max)
                    max = run.distance;
                break;
            default:
                break;
        }
    }
    
    total = avg;
    //calc avg
    avg = (runCount > 0 ? avg / runCount : 0);
    
    //alert to negative calcs
    //NSAssert(avg > 0 && min > 0 && max > 0, @"negative parameter in processGoalForRuns");
    NSLog(@"min: %.1f avg: %.1f max: %.1f", min,avg,max);
    
    //set goal values
    activityCount = [NSNumber numberWithFloat:runCount];
    
    UserPrefs * tempPrefs = [UserPrefs MR_findFirst];
    tempPrefs.metric = [NSNumber numberWithBool:metric];
    
    CGFloat avgPace;
    //need time components for race
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components; 
    
    //process progress and string for metric change
    switch(type)
    {
        case GoalTypeCalories:
            progress = total / ([value floatValue]*calsInLbFat);
            metricValueChange = [NSString stringWithFormat:@"%.1f lb / %.0f %@" , total / calsInLbFat, total , NSLocalizedString(@"CalShortForm", @"Shortform for calories")];
            break;
        case GoalTypeOneDistance:
            progress = max / [value floatValue];
            metricValueChange = [NSString stringWithFormat:@"%.1f %@", [RunEvent getDisplayDistance:max withMetric:metric], [tempPrefs getDistanceUnit]];
            break;
        case GoalTypeRace:
            components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:time];
            //value is the race distance, time is the NSDate of target race time
            //calc avg pace
            avgPace = [value floatValue] / ((components.hour * 3600) + (components.minute * 60))  ; //to m/s
            progress = max / avgPace;
            metricValueChange = [NSString stringWithFormat:@"%.1f %@ in %@", [RunEvent getDisplayDistance:[value floatValue] withMetric:metric], [tempPrefs getDistanceUnit], [RunEvent getTimeString:([value floatValue]/max)]];
            break;
        case GoalTypeTotalDistance:
            progress = total / [value floatValue];
            metricValueChange = [NSString stringWithFormat:@"%.1f %@", [RunEvent getDisplayDistance:total withMetric:metric], [tempPrefs getDistanceUnit]];
            break;
        default:
            break;
    }
    
    
    if(avg == 0)
    {
        switch(type)
        {
            case GoalTypeCalories:
                progress = 0;
                metricValueChange = @"";
                break;
            case GoalTypeOneDistance:
                break;
            case GoalTypeRace:
                break;
            case GoalTypeTotalDistance:
                progress = 0;
                metricValueChange = @"";
                break;
            default:
                break;
        }
    }
    else if(max == 0)
    {
        
        switch(type)
        {
            case GoalTypeCalories:
                break;
            case GoalTypeOneDistance:
                progress = 0;
                metricValueChange = @"";
                break;
            case GoalTypeRace:
                progress = 0;
                metricValueChange = @"";
                break;
            case GoalTypeTotalDistance:
                break;
            default:
                break;
        }
    }
    
    if(progress >= 1)
    {
        progress = 1;
        return true;
    }
    else
    {
        return false;
    }
}


-(BOOL)validateGoalEntry:(BOOL)metric
{
    if(!self.endDate)
        return false;
    if([self.endDate compare:self.startDate ] == NSOrderedAscending)
        return false;
    
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            
            if(weight)
            {
                value = [Goal getWeight:weight];
                return true;
            }
            break;
        case GoalTypeOneDistance:
            if(race)
            {
                value = [Goal getRaceDistance:race];
                return true;
            }
            break;
        case GoalTypeRace:
            if(race && time)
            {
                value = [Goal getRaceDistance:race];
                return true;
            }
            break;
        case GoalTypeTotalDistance:
            if(value)
            {
                //get to m from km
                value = [NSNumber numberWithInt:[value integerValue] * 1000];
                //could be a mile figure
                if(!metric)
                {
                    value = [NSNumber numberWithInt:[value integerValue] / convertKMToMile];
                }
                return true;
            }
            break;
    }
    
    return false;
}


@end
