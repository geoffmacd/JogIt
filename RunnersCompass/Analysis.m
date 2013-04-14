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
@synthesize furthestRun,fastestRun,caloriesRun,longestRun;
@synthesize runMeta;

-(id)analyzeWithRuns:(NSMutableArray *)runToAnalyze
{
    runMeta = runToAnalyze;
    
    //consider 5 metricss
    weeklyRace = [[NSMutableArray alloc] initWithCapacity:5];
    monthlyRace = [[NSMutableArray alloc] initWithCapacity:5];
    weeklyMeta = [[NSMutableArray alloc] initWithCapacity:5];
    monthlyMeta = [[NSMutableArray alloc] initWithCapacity:5];
    
    //init arrays within arrays representing week/month units
    for(int i = MetricTypeDistance; i <= MetricTypeActivityCount; i++)
    {
        NSMutableArray * arrayToAdd2 = [[NSMutableArray alloc] initWithCapacity:100];
        NSMutableArray * arrayToAdd3 = [[NSMutableArray alloc] initWithCapacity:100];
        [weeklyMeta addObject:arrayToAdd2];
        [monthlyMeta addObject:arrayToAdd3];
    }
    for(int i = RaceType5Km; i <= RaceTypeFullMarathon; i++)
    {
        NSMutableArray * arrayToAdd = [[NSMutableArray alloc] initWithCapacity:100];
        NSMutableArray * arrayToAdd4 = [[NSMutableArray alloc] initWithCapacity:100];
        [weeklyRace addObject:arrayToAdd];
        [monthlyRace addObject:arrayToAdd4];
    }
    
    
    //get todays date
    NSDate * today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //starts on thursday
    [calendar setMinimumDaysInFirstWeek:4];
    NSDateComponents *startComponents = [calendar components:NSWeekCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];
    NSInteger startWeek = startComponents.week;
    NSInteger startYear = startComponents.year;
    NSInteger startMonth = startComponents.month;
    
    //calculate number of months and weeks to analyze
    NSDate * oldestRunDate = [NSDate date];
    for(RunEvent * oldRun in runToAnalyze)
    {
        if([oldRun.date timeIntervalSince1970] < [oldestRunDate timeIntervalSince1970])
            oldestRunDate = oldRun.date;
    }
    NSDateComponents *endComponents = [calendar components:NSWeekCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:oldestRunDate];
    NSInteger endWeek = endComponents.week;
    NSInteger endYear = endComponents.year;
    NSInteger endMonth = endComponents.month;
    //calculate num with fixed #weeks/year, may not be correct
    NSInteger numWeeksToAnalyze = (startWeek - endWeek) + 52 * (startYear - endYear) + 1;
    NSInteger numMonthsToAnalyze = (startMonth - endMonth) + 12 * (startYear - endYear) + 1;
    
    /*
    if(numMonthsToAnalyze == 0)
        numMonthsToAnalyze = 1;
    if(numWeeksToAnalyze == 0)
        numWeeksToAnalyze = 1;
     */
    
    NSLog(@"weeks: %d months: %d", numWeeksToAnalyze, numMonthsToAnalyze);
    
    
    //for all calculated weeks fill out zeros for each array
    for(int i = 0; i < 5; i++)
    {
        NSMutableArray * tempWeeklyMeta = [weeklyMeta objectAtIndex:i];
        NSMutableArray * tempMonthlyMeta = [monthlyMeta objectAtIndex:i];
        NSMutableArray * tempWeeklyRace = [weeklyRace objectAtIndex:i];
        NSMutableArray * tempMonthlyRace= [monthlyRace objectAtIndex:i];
        
        //add 0's for all weeks to be analyzed
        for(int j = 0; j < numWeeksToAnalyze; j++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [tempWeeklyMeta addObject:value];
            [tempWeeklyRace addObject:value];
        }
        //add 0's for all months to be analyzed
        for(int j = 0; j < numMonthsToAnalyze; j++)
        {
            NSNumber * value = [NSNumber numberWithInt:0];
            [tempMonthlyMeta addObject:value];
            [tempMonthlyRace addObject:value];
        }
    }
    
    //for each run, aggregrate weekly and monthy race data
    for(RunEvent * oldRun in runToAnalyze)
    {
        //find date to place in arrays
        NSDateComponents *runDate = [calendar components:NSWeekCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit  fromDate:oldRun.date];
        NSInteger weeksFromStart = startWeek - runDate.week;
        NSInteger monthsFromStart = startMonth - runDate.month;
        NSInteger yearsFromStart = startYear - runDate.year;
        
        NSInteger weeklyIndexToModify = weeksFromStart + (52 * yearsFromStart);
        NSInteger monthlyIndexToModify = monthsFromStart + (12 * yearsFromStart);
        
        //weeks
        if(weeklyIndexToModify >=0 && weeklyIndexToModify < numWeeksToAnalyze)
        {
            
            //modify the value for this in each metric
            for(NSInteger i = MetricTypeDistance; i <= MetricTypeActivityCount; i++)
            {
                NSMutableArray * array = [weeklyMeta objectAtIndex:i-1];
                
                //set the value of this index, increment previously added runs in week
                NSNumber * currentValue = [array objectAtIndex:weeklyIndexToModify];
                NSNumber * newValue;
                switch(i)
                {
                    case MetricTypeDistance:
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + (oldRun.distance)];
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
                [array replaceObjectAtIndex:weeklyIndexToModify withObject:newValue];
                
                //determine if race variable can be changed for this week
                [self runPrediction:weeklyIndexToModify withWeekly:true withRun:oldRun forRace:i];
            }
        }
        //months
        if(monthlyIndexToModify >=0 && monthlyIndexToModify < numMonthsToAnalyze)
        {
            
            //modify the value for this in each metric
            for(NSInteger i = MetricTypeDistance; i <= MetricTypeActivityCount; i++)
            {
                NSMutableArray * array = [monthlyMeta objectAtIndex:i-1];
                
                //set the value of this index, increment previously added runs in week
                NSNumber * currentValue = [array objectAtIndex:monthlyIndexToModify];
                NSNumber * newValue;
                switch(i)
                {
                    case MetricTypeDistance:
                        newValue = [NSNumber numberWithFloat:[currentValue floatValue] + (oldRun.distance)];
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
                [array replaceObjectAtIndex:monthlyIndexToModify withObject:newValue];
                
                //determine if race variable can be changed for this week
                [self runPrediction:monthlyIndexToModify withWeekly:false withRun:oldRun forRace:i];
            }
            
        }
        
        //check for PRs
        if(furthestRun)
        {
            if(furthestRun.distance < oldRun.distance)
            {
                furthestRun = oldRun;
            }
        }
        else
        {
            furthestRun = oldRun;
        }
        if(fastestRun)
        {
            if(fastestRun.avgPace < oldRun.avgPace)
            {
                fastestRun = oldRun;
            }
        }
        else
        {
            fastestRun = oldRun;
        }
        if(caloriesRun)
        {
            if(caloriesRun.calories < oldRun.calories)
            {
                caloriesRun = oldRun;
            }
        }
        else
        {
            caloriesRun = oldRun;
        }
        if(longestRun)
        {
            if(longestRun.time < oldRun.time)
            {
                longestRun = oldRun;
            }
        }
        else
        {
            longestRun = oldRun;
        }
    }
    
    //process avg paces per week
    for(NSInteger i = 0; i < [[weeklyMeta objectAtIndex:MetricTypePace-1] count]; i++)
    {
        NSMutableArray * paceArray = [weeklyMeta objectAtIndex:MetricTypePace-1];
        NSNumber * curWeekPaceSum = [paceArray objectAtIndex:i];
        NSMutableArray * countArray = [weeklyMeta objectAtIndex:MetricTypeActivityCount-1];
        NSNumber * weekCount = [countArray objectAtIndex:i];
        NSNumber * weeklyAvgPace;
        if([weekCount integerValue] > 0 )
            weeklyAvgPace = [NSNumber numberWithFloat:[curWeekPaceSum floatValue] / [weekCount integerValue]];
        else//set 0 pace if there was no activity
            weeklyAvgPace = [NSNumber numberWithInt:0];
        [paceArray replaceObjectAtIndex:i withObject:weeklyAvgPace];
    }
    //process avg paces per month
    for(NSInteger i = 0; i < [[monthlyMeta objectAtIndex:MetricTypePace-1] count]; i++)
    {
        NSMutableArray * paceArray = [monthlyMeta objectAtIndex:MetricTypePace-1];
        NSNumber * curMonthPaceSum = [paceArray objectAtIndex:i];
        NSMutableArray * countArray = [monthlyMeta objectAtIndex:MetricTypeActivityCount-1];
        NSNumber * monthCount = [countArray objectAtIndex:i];
        NSNumber * monthlyAvgPace;
        if([monthCount integerValue] > 0 )
            monthlyAvgPace = [NSNumber numberWithFloat:[curMonthPaceSum floatValue] / [monthCount integerValue]];
        else//set 0 pace if there was no activity
            monthlyAvgPace = [NSNumber numberWithInt:0];
        [paceArray replaceObjectAtIndex:i withObject:monthlyAvgPace];
    }
    
    //predict race times
    //[self analyzeWeeklyRaces];
    //[self analyzeMonthlyRaces];
    
    return self;
}

-(void)analyzeWeeklyRaces
{
    //analyze race times based on pace in that week
    //independant on date format
    
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
    //independant on date format
    
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
    //need seconds from a m/s value with a certain distance
    NSTimeInterval racetime = 0;
    
    if(paceForRace == 0)
        return 0;
    
    switch (raceType) {
        case RaceType10Km:
            racetime = 10000 / paceForRace;
            break;
        case RaceType10Mile:
            racetime = 16093.4 / paceForRace;
            break;
        case RaceType5Km:
            racetime = 5000 / paceForRace;
            break;
        case RaceTypeFullMarathon:
            racetime = 42194.988 / paceForRace;
            break;
        case RaceTypeHalfMarathon:
            racetime = 21097.494 / paceForRace;
            break;
            
        default:
            break;
    }
    
    return racetime;
}

-(void)runPrediction:(NSInteger)index withWeekly:(BOOL)weekly withRun:(RunEvent*)run forRace:(RaceType)racetype
{
    //decide if to replace predicted run time in the array for that week or month
    //use the Riegel formula of time = oldtime * (prediction distance / old distance) ^ 1.06
    
    NSTimeInterval racetime = 0;
    
    switch (racetype) {
        case RaceType10Km:
            racetime = 10000;
            racetime = run.time * pow((racetime / run.distance), 1.06);
            break;
        case RaceType10Mile:
            racetime = 16093.4;
            racetime = run.time * pow((racetime / run.distance), 1.06);
            break;
        case RaceType5Km:
            racetime = 5000;
            racetime = run.time * pow((racetime / run.distance), 1.06);
            break;
        case RaceTypeFullMarathon:
            racetime = 42194.988;
            racetime = run.time * pow((racetime / run.distance), 1.06);
            break;
        case RaceTypeHalfMarathon:
            racetime = 21097.494;
            racetime = run.time * pow((racetime / run.distance), 1.06);
            break;
            
        default:
            break;
    }
    
    //ditch right away if doesn't satisfy criteria
    /*
     1.min distance
     2. max speed
     3. elevation?
     4. pausepoints??
     */

    
    //must be at least 1km
    if(run.distance < 1000)
        return;
    
    //check against currently stored time for each
    NSMutableArray * arrayForRace;
    if(weekly)
        arrayForRace = [weeklyRace objectAtIndex:racetype-1];
    else
        arrayForRace = [monthlyRace objectAtIndex:racetype-1];
    NSNumber * oldPrediction = [arrayForRace objectAtIndex:index];
    NSNumber * curPrediction = [NSNumber numberWithDouble:racetime];
    
    if(racetime > [oldPrediction doubleValue])
    {
        //replace
        [arrayForRace replaceObjectAtIndex:index withObject:curPrediction];
    }
}

@end
