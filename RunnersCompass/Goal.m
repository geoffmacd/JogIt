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

-(id)initWithType:(GoalType)goaltype
{
    self.type = goaltype;
    
    self.startDate = [NSDate date];

    
    //set up race types
    NSArray * raceKeys =  [NSArray arrayWithObjects:@"1 mile",
                            @"3 mile",
                            @"5 mile",
                            @"10 mile",
                            @"1 km",
                            @"3 km",
                            @"5 km",
                            @"10 km",
                            @"Half Marathon",
                            @"Full Marathon", nil];
    NSArray * raceValues = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.61],
                            [NSNumber numberWithFloat:4.83],
                            [NSNumber numberWithFloat:8.05],
                            [NSNumber numberWithFloat:16.1],
                            [NSNumber numberWithFloat:1],
                            [NSNumber numberWithFloat:3],
                            [NSNumber numberWithFloat:5],
                            [NSNumber numberWithFloat:10],
                            [NSNumber numberWithFloat:21.1],
                            [NSNumber numberWithFloat:42.2], nil];
    raceDictionary = [[NSDictionary alloc] initWithObjects:raceValues forKeys:raceKeys ];
    
    
    
    //set up weight loss strings
    NSMutableArray  * fatValues= [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableArray  * fatKeys= [[NSMutableArray alloc] initWithCapacity:30];
    for(int i = 0; i< 30; i++)
    {
        [fatKeys addObject:[NSString stringWithFormat:@"%d lb", i]];
        [fatValues addObject:[NSNumber numberWithInt:i]];
    }
    fatDictionary = [[NSDictionary alloc] initWithObjects:fatValues forKeys:fatKeys ];
    
    return self;
    
}

-(NSString*)getName
{
    
    NSString * goalName;//generate every time
    /*
    NSString *endString = @" by ";
    
    
    if(endDate)
    {
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setCalendar:cal];
        [formatter setLocale:[NSLocale currentLocale]];
        NSString * dateString = [formatter stringFromDate:self.endDate];
        
        
        
        //remove the year if it is less than 6 months away
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                                   fromDate:[NSDate date]
                                                     toDate:endDate
                                                    options:0];
        if(components.month < 6)
            dateString =  [[dateString componentsSeparatedByString:@","] objectAtIndex:0];
        
        endString = [endString stringByAppendingString:dateString];
    }
    else{
        //leave string blank
        endString = @"";
    }
    */
    
    //need time components for race
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:self.time];
    
    NSString *endString = @"";
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            goalName = [NSString stringWithFormat:@"Goal: Lose %d lbs%@", [self.value integerValue], endString];
            break;
        case GoalTypeOneDistance:
            goalName = [NSString stringWithFormat:@"Goal: Finish %@ race%@", self.race, endString];
            break;
        case GoalTypeRace:
            if(components.hour > 0)
                goalName = [NSString stringWithFormat:@"Goal: Finish %@ in less than %d hr %d min", self.race, components.hour, components.minute];
            else
                goalName = [NSString stringWithFormat:@"Goal: Finish %@ in less than %d min", self.race, components.minute];
            break;
        case GoalTypeTotalDistance:
            goalName = [NSString stringWithFormat:@"Goal: Log %d km %@", [self.value integerValue], endString];
            break;
        default:
            return @"bad goal name";
    }
    
    return goalName;

}

-(NSArray*)getRaceNames
{
    //return [raceDictionary allKeys]; returns unsorted, doesnt work
    
    return [NSArray arrayWithObjects:@"1 mile",
            @"3 mile",
            @"5 mile",
            @"10 mile",
            @"1 km",
            @"3 km",
            @"5 km",
            @"10 km",
            @"Half Marathon",
            @"Full Marathon", nil];
}

-(NSArray*)getWeightNames
{
    //return [fatDictionary allKeys] ;  doesnt work since the result is unsort
    
    //set up weight loss strings
    NSMutableArray  * fatKeys= [[NSMutableArray alloc] initWithCapacity:30];
    for(int i = 0; i< 30; i++)
    {
        [fatKeys addObject:[NSString stringWithFormat:@"%d lb", i]];
    }
    
    return fatKeys;
}

//method is called with variables
-(void)save
{
    
    switch(self.type)
    {
        case GoalTypeCalories:
            break;
            
        case GoalTypeOneDistance:
            break;
            
        case GoalTypeRace:
            break;
            
        case GoalTypeTotalDistance:
            break;
            
            
        default:
            break;
    }
    
}


-(NSString *)stringForDescription
{
    NSString * description;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            description = @"Weight Loss";
            break;
        case GoalTypeOneDistance:
            description = @"Furthest Distance";
            break;
        case GoalTypeRace:
            description = @"Fastest Race Time";
            break;
        case GoalTypeTotalDistance:
            description = @"Total Distance";
            break;
        default:
            return @"bad description";
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
            description = @"Enter Target Weight Loss";
            break;
        case GoalTypeOneDistance:
            description = @"Enter Distance Target";
            break;
        case GoalTypeRace:
            description = @"Enter Fastest Time for Distance";
            break;
        case GoalTypeTotalDistance:
            description = @"Enter Total Distance To Log";
            break;
        default:
            return @"bad description";
    }
    
    return description;
}


-(NSString *)stringForEdit2
{
    NSString * description;
    
    switch(type)
    {       
        case GoalTypeRace:
            return @"Time to Beat";
        case GoalTypeCalories:
        case GoalTypeOneDistance:
        case GoalTypeTotalDistance:
            return nil;
        default:
            return @"bad description";
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
            subtitle = @"3500cal/1lb fat";
            break;
        case GoalTypeOneDistance:
            subtitle = @"";
            break;
        case GoalTypeRace:
            subtitle = @"";
            break;
        case GoalTypeTotalDistance:
            subtitle = @"";
            break;
            
        default:
            return @"bad subtitle";
    }
    
    return subtitle;
    
}

-(BOOL)validateGoalEntry
{
    if(!self.endDate)
        return false;
    if([self.endDate compare:self.startDate ] == NSOrderedAscending)
        return false;
    
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            if(self.value && self.weight)
                return true;
            break;
        case GoalTypeOneDistance:
            if(self.value && self.race)
                return true;
            break;
        case GoalTypeRace:
            if(self.value && self.race && self.time)
                return true;
            break;
        case GoalTypeTotalDistance:
            if(self.value)
                return true;
            break;
    }
    
    return false;
}


@end
