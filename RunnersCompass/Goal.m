//
//  Goal.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Goal.h"

@implementation Goal

@synthesize endDate,startDate,type,value,value2,race,activityCount,tempValueFromFK,metricValueChange,progress;

-(id)initWithType:(GoalType)goaltype
{
    self.type = goaltype;
    
    self.startDate = [NSDate date];
    
    return self;
    
}

-(NSString*)getName
{
    
    NSString * goalName;//generate every time
    
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
        
        endString = [endString stringByAppendingString:dateString];
    }
    else{
        //leave string blank
        endString = @"";
    }
    
    
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            goalName = [NSString stringWithFormat:@"Goal: Lose %d lbs%@", [self.value integerValue], endString];
            break;
        case GoalTypeOneDistance:
            goalName = [NSString stringWithFormat:@"Goal: Finish %d km race%@", [self.value integerValue], endString];
            break;
        case GoalTypeRace:
            goalName = [NSString stringWithFormat:@"Goal: Finish %d km in less than %d", [self.value integerValue], [self.value2 integerValue]];
            break;
        case GoalTypeTotalDistance:
            goalName = [NSString stringWithFormat:@"Goal: Log %d km distance%@", [self.value integerValue], endString];
            break;
        default:
            return @"bad goal name";
    }
    
    return goalName;

}

-(NSArray*)getRaceTypes
{
    return [NSArray arrayWithObjects:@"1 mile", @"3 mile",@"5 mile",@"10 mile",@"1 km",@"3 km",@"5 km",@"10 km",@"Half Marathon",@"Full Marathon", nil];
}

//method is called with variables
-(void)save
{
    
    
}


-(NSString *)stringForDescription
{
    NSString * description;
    
    //switch between metric to determine label for metric description
    switch(type)
    {
        case GoalTypeCalories:
            description = @"Calories Burned";
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

@end
