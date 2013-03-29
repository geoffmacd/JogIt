//
//  Analysis.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Analysis.h"

@implementation Analysis

@synthesize weeklyMeta,weeklyRace,monthlyMeta,monthlyRace;
@synthesize runMeta;

-(id)setupFakeWithRuns:(NSMutableArray *)runToAnalyze
{
    runMeta = runToAnalyze;
    
    weeklyRace = [[NSMutableArray alloc] initWithCapacity:5];
    monthlyRace = [[NSMutableArray alloc] initWithCapacity:5];
    weeklyMeta = [[NSMutableArray alloc] initWithCapacity:5];
    monthlyMeta = [[NSMutableArray alloc] initWithCapacity:5];
    
    //init arrays within arrays representing week/month units
    for(int i = 0; i < MetricTypeActivityCount; i++)
    {
        NSMutableArray * arrayToAdd2 = [[NSMutableArray alloc] initWithCapacity:100];
        NSMutableArray * arrayToAdd3 = [[NSMutableArray alloc] initWithCapacity:100];
        [weeklyMeta addObject:arrayToAdd2];
        [monthlyMeta addObject:arrayToAdd3];
    }
    for(int i = 0; i < RaceTypeFullMarathon; i++)
    {
        NSMutableArray * arrayToAdd = [[NSMutableArray alloc] initWithCapacity:100];
        NSMutableArray * arrayToAdd4 = [[NSMutableArray alloc] initWithCapacity:100];
        [weeklyRace addObject:arrayToAdd];
        [monthlyRace addObject:arrayToAdd4];
    }
    
    
    //for the last 100 weeks fill out zeros
    for(NSMutableArray * array1 in weeklyMeta)
    {
        for(int i = 0; i < 100; i++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [array1 addObject:value];
        }
    }
    //for the last 100 weeks fill out zeros
    for(NSMutableArray * array1 in monthlyMeta)
    {
        for(int i = 0; i < 100; i++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [array1 addObject:value];
        }
    }
    //for the last 100 weeks fill out zeros
    for(NSMutableArray * array1 in weeklyRace)
    {
        for(int i = 0; i < 100; i++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [array1 addObject:value];
        }
    }
    //for the last 100 weeks fill out zeros
    for(NSMutableArray * array1 in monthlyRace)
    {
        for(int i = 0; i < 100; i++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [array1 addObject:value];
        }
    }
    
    
    NSDate * today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekOfYearCalendarUnit|NSYearCalendarUnit fromDate:today];
    NSInteger startWeek = components.weekOfYear;
    NSInteger startYear = components.year;
    
    //for each run, aggregrate race and meta
    for(RunEvent * oldRun in runToAnalyze)
    {
        //find date to place in arrays
        NSDateComponents *runDate = [calendar components:NSWeekOfYearCalendarUnit|NSYearCalendarUnit  fromDate:oldRun.date];
        NSInteger weeksFromStart = startWeek - runDate.weekOfYear;
        NSInteger yearsFromStart = startYear - runDate.year;
        
        
        NSInteger indexToInsert;
        
        if(yearsFromStart == 0)
            indexToInsert = weeksFromStart;
        else
            indexToInsert = (yearsFromStart * 52) - (52 - weeksFromStart);

        if(indexToInsert >=0)
        {
            
            //modify the value for this in each metric
            for(NSInteger i = MetricTypeDistance; i <= MetricTypeActivityCount; i++)
            {
                NSMutableArray * array = [weeklyMeta objectAtIndex:i-1];
                
                //set the value of this index, increment previously added runs in week
                NSNumber * currentValue = [array objectAtIndex:indexToInsert];
                NSNumber * newValue;
                switch(i)
                {
                    case MetricTypeDistance:
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + (oldRun.distance/1000)];
                        break;
                    case MetricTypePace:
                        //need to figure this one out
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + oldRun.avgPace];
                        break;
                    case MetricTypeTime:
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + oldRun.time];
                        break;
                    case MetricTypeCalories:
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + oldRun.calories];
                        break;
                    case MetricTypeActivityCount:
                        newValue = [NSNumber numberWithFloat:[currentValue integerValue] + 1];
                        break;
                }
                //replace value
                [array replaceObjectAtIndex:indexToInsert withObject:newValue];
            }
            
        }
    }
    
    //process avg paces per week
    for(NSInteger i = 0; i < [weeklyMeta count]; i++)
    {
        NSMutableArray * paceArray = [weeklyMeta objectAtIndex:MetricTypePace-1];
        NSNumber * curWeekPaceSum = [paceArray objectAtIndex:i];
        NSMutableArray * countArray = [weeklyMeta objectAtIndex:MetricTypeActivityCount-1];
        NSNumber * weekCount = [countArray objectAtIndex:i];
        NSNumber * weeklyAvgPace = [NSNumber numberWithFloat:[curWeekPaceSum floatValue] / [weekCount integerValue]];
        [paceArray replaceObjectAtIndex:i withObject:weeklyAvgPace];
    }
    
    
    //convert weekly values to monthy
    [self analyzeWeeklyForMonthly];
    
    //predict race imes
    [self analyzeWeeklyRaces];
    [self analyzeMonthlyRaces];
    
    return self;
    
}

-(void)analyzeWeeklyForMonthly
{
    
    
    //modify the value for this in each metric
    for(NSInteger i = MetricTypeDistance; i <= MetricTypeActivityCount; i++)
    {
        NSMutableArray * weeklyMetricArray = [weeklyMeta objectAtIndex:i-1];
        NSMutableArray * monthlyMetricArray = [monthlyMeta objectAtIndex:i-1];
        
        NSInteger weekCount = 0;
        NSInteger monthIndex = 0;
        
        //for each array go through each week and aggregate to monthly
        for(NSInteger j = 0; j < [weeklyMetricArray count]; j++)
        {
            
            //count 4 weeks until add to monthly array
            
            //set the value of this index, increment previously added runs in week
            NSNumber * currentWeeklyValue = [weeklyMetricArray objectAtIndex:j];
            NSNumber * currentMonthlyValue = [monthlyMetricArray objectAtIndex:monthIndex];
            NSNumber * newValue;
            switch(i)
            {
                case MetricTypeDistance:
                    newValue = [NSNumber numberWithFloat:[currentWeeklyValue floatValue] + [currentMonthlyValue floatValue]];
                    break;
                case MetricTypePace:
                    //need to figure this one out
                    newValue = [NSNumber numberWithFloat:[currentWeeklyValue floatValue] + [currentMonthlyValue floatValue]];
                    break;
                case MetricTypeTime:
                    newValue = [NSNumber numberWithFloat:[currentWeeklyValue floatValue] + [currentMonthlyValue floatValue]];
                    break;
                case MetricTypeCalories:
                    newValue = [NSNumber numberWithFloat:[currentWeeklyValue floatValue] + [currentMonthlyValue floatValue]];
                    break;
                case MetricTypeActivityCount:
                    newValue = [NSNumber numberWithFloat:[currentMonthlyValue floatValue] + 1];
                    break;
            }
            
            
            //replace value
            [monthlyMetricArray replaceObjectAtIndex:monthIndex withObject:newValue];
            
            weekCount++;
            
            if(weekCount > 3)
            {
                weekCount = 0;
                monthIndex++;
            }
        }
    }
    
    //process avg paces per week
    for(NSInteger i = 0; i < [monthlyMeta count]; i++)
    {
        NSMutableArray * paceArray = [monthlyMeta objectAtIndex:MetricTypePace-1];
        NSNumber * curMonthPaceSum = [paceArray objectAtIndex:i];
        NSMutableArray * countArray = [monthlyMeta objectAtIndex:MetricTypeActivityCount-1];
        NSNumber * monthCount = [countArray objectAtIndex:i];
        NSNumber * monthAvgPace = [NSNumber numberWithFloat:[curMonthPaceSum floatValue] / [monthCount integerValue]];
        [paceArray replaceObjectAtIndex:i withObject:monthAvgPace];
    }
}

-(void)analyzeWeeklyRaces
{
    //analyze race times based on pace in that week
    
    NSMutableArray * paceArray = [weeklyMeta objectAtIndex:MetricTypePace-1];
    
    for(NSInteger i = 0; i < [paceArray count]; i++)
    {
        NSNumber * weeklyAvgPace = [paceArray objectAtIndex:i];
        NSTimeInterval weeklyPace = [weeklyAvgPace floatValue];
        
        //calc race time based on that avg pace
        NSNumber * raceTime;
        
        for(NSInteger j = 0; j < [weeklyRace count]; j++)
        {
            NSMutableArray * weeklyRaceMetric = [weeklyRace objectAtIndex:j];
            
            raceTime = [NSNumber numberWithFloat:[self timeForRace:j+1 WithPace:weeklyPace]];
            
            //replace value
            [weeklyRaceMetric replaceObjectAtIndex:i withObject:raceTime];
        }
    }
}


-(void)analyzeMonthlyRaces
{
    //analyze race times based on pace in that week
    
    NSMutableArray * paceArray = [monthlyMeta objectAtIndex:MetricTypePace-1];
    
    for(NSInteger i = 0; i < [paceArray count]; i++)
    {
        NSNumber * monthlyAvgPace = [paceArray objectAtIndex:i];
        NSTimeInterval monthlyPace = [monthlyAvgPace floatValue];
        
        //calc race time based on that avg pace
        NSNumber * raceTime;
        
        for(NSInteger j = 0; j < [monthlyRace count]; j++)
        {
            NSMutableArray * monthlyRaceMetric = [monthlyRace objectAtIndex:j];
            
            raceTime = [NSNumber numberWithFloat:[self timeForRace:j+1 WithPace:monthlyPace]];
            
            //replace value
            [monthlyRaceMetric replaceObjectAtIndex:i withObject:raceTime];
        }
    }
}

-(CGFloat)timeForRace:(RaceType)raceType WithPace:(NSTimeInterval)paceForRace
{
    NSTimeInterval time;
    //need seconds from a m/s value with a certain distance
    
    if(paceForRace == 0)
        return 0;
    
    switch (raceType) {
        case RaceType10Km:
            time = 10000 / paceForRace;
            break;
        case RaceType10Mile:
            time = 16093.4 / paceForRace;
            break;
        case RaceType5Km:
            time = 5000 / paceForRace;
            break;
        case RaceTypeFullMarathon:
            time = 42194.988 / paceForRace;
            break;
        case RaceTypeHalfMarathon:
            time = 21097.494 / paceForRace;
            break;
            
        default:
            break;
    }
    
    return time;
}

@end
