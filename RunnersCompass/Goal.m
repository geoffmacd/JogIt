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
    //do no care of unit system, since metric people may want 10 mile, etc
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
    
    //disable dates for now because of long text in button
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
            goalName = [NSString stringWithFormat:@"%@: %@ %d lbs%@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"LoseWord",@"Word for Lose in title"),[self.value integerValue], endString];
            break;
        case GoalTypeOneDistance:
            goalName = [NSString stringWithFormat:@"%@: %@ %@ race%@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),self.race, endString];
            break;
        case GoalTypeRace:
            if(components.hour > 0)
                goalName = [NSString stringWithFormat:@"%@: %@ %@ in less than %d hr %d min", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),self.race, components.hour, components.minute];
            else
                goalName = [NSString stringWithFormat:@"%@: %@ %@ in less than %d min", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"FinishWord",@"Word for finish in title"),self.race, components.minute];
            break;
        case GoalTypeTotalDistance:
            goalName = [NSString stringWithFormat:@"%@: %@ %d km %@", NSLocalizedString(@"GoalWord",@"Word for Goal in title"), NSLocalizedString(@"LogWord",@"Word for log in title"), [self.value integerValue], endString];
            break;
        default:
            return NSLocalizedString(@"GoalNameBadGoalType",@"bad goal type");//return @"bad goal name";
    }
    
    return goalName;

}

-(NSArray*)getRaceNames
{
    //return [raceDictionary allKeys]; returns unsorted, doesnt work
    
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
