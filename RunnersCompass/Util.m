//
//  Util.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-13.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Util.h"
#import <QuartzCore/QuartzCore.h>


@implementation Util

#pragma mark  Look and Feel

+(UIColor*) flatColorForCell:(NSInteger)indexFromInstallation
{
    
    switch(indexFromInstallation % 2)
    {
            
        case 0:
            //rgb(44, 62, 80) , midnight blue
            return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
            break;
            
        case 1:
        default:
            //rgb(41, 128, 185), belize
            return [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
            break;
    }
}

+(UIColor*) cellRedColour
{
    return [UIColor colorWithRed:142.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
}

+(UIColor*) redColour
{
    return [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
}

+(UIColor*) blueColour
{
    
    return [UIColor colorWithRed:37.0f/255 green:24.0f/255 blue:192.0f/255 alpha:1.0f];
}

+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark  Date Functions

+(NSInteger)numPeriodsForRuns:(NSMutableArray*)runs withWeekly:(BOOL)weekly
{
    NSInteger periods = 0;
    NSDate *oldest = [NSDate date];
    
    //get oldest run
    for(RunEvent * oldRun in runs)
    {
        if([oldRun.date timeIntervalSinceReferenceDate] < [oldest timeIntervalSinceReferenceDate])
        {
            oldest = oldRun.date;
        }
    }
    
    if(weekly)
    {
        //start at end of current week
        NSDate *iWeek = shiftDateByXweeks(getFirstDayOfTheWeekFromDate([NSDate date]),1);
        NSDate * curWeekDate = shiftDateByXweeks(getFirstDayOfTheWeekFromDate([NSDate date]),1);
        
        while([oldest timeIntervalSinceReferenceDate] < [iWeek timeIntervalSinceReferenceDate])
        {
            periods++;
            //shift date one week at a time until iWeek is less
            iWeek = shiftDateByXweeks(curWeekDate, -periods);
        }
        
    }
    else
    {
        NSDate *iMonth = shiftDateByXmonths(getMonthDateFromDate([NSDate date]),1);
        NSDate * curMonthDate = shiftDateByXmonths(getMonthDateFromDate([NSDate date]),1);
        
        while([oldest timeIntervalSinceReferenceDate] < [iMonth timeIntervalSinceReferenceDate])
        {
            periods++;
            //shift date one month at a time until iWeek is less
            iMonth = shiftDateByXmonths(curMonthDate, -periods);
        }
    }
    
    NSLog(@"%d periods found for %d runs", periods, [runs count]);
    
    //show at least two months
    if(periods == 1)
        return 2;
    else if(periods < 1)
        return 1;
    return periods;
}


+(NSMutableArray*)runsForPeriod:(NSMutableArray*)runs withWeekly:(BOOL)weekly withPeriodStart:(NSDate*)start
{
    NSMutableArray * periodRuns = [NSMutableArray new];
    
    if(weekly)
    {
        NSInteger periodWeek = weekForPeriod(start);
        NSInteger periodYear = yearForPeriod(start);
        
        for(RunEvent * oldRun in runs)
        {
            if(periodWeek == weekForPeriod(oldRun.date) && yearForPeriod(oldRun.date) == periodYear)
            {
                [periodRuns addObject:oldRun];
            }
        }
    }
    else
    {
        NSInteger periodMonth = monthForPeriod(start);
        NSInteger periodYear = yearForPeriod(start);
        
        for(RunEvent * oldRun in runs)
        {
            if(periodMonth == monthForPeriod(oldRun.date) && yearForPeriod(oldRun.date) == periodYear)
            {
                [periodRuns addObject:oldRun];
            }
        }
    }
    
    //NSLog(@"%d runs returnned for period: %@", [periodRuns count], start);
    return periodRuns;
}

+(NSDate*)dateForPeriod:(NSInteger)index withWeekly:(BOOL)weekly
{
    NSDate * indexDate, *first;
    
    
    //must be exclusive because index 0 should return first
    if(weekly)
    {
        
        first = getFirstDayOfTheWeekFromDate([NSDate date]);
        indexDate = shiftDateByXweeks(first, -index);
    }
    else
    {
        first = getMonthDateFromDate([NSDate date]);
        indexDate = shiftDateByXmonths(first, -index);
    }

    return indexDate;
}

int monthForPeriod(NSDate * date) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSMonthCalendarUnit) fromDate:date];
    
    return [dateComps month];
}

int weekForPeriod(NSDate * date) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSWeekCalendarUnit) fromDate:date];
    
    return [dateComps week];
}

int yearForPeriod(NSDate * date){
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit) fromDate:date];
    
    return [dateComps year];
}

int currentWeek(void) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSWeekCalendarUnit) fromDate:[NSDate date]];
    
    return [dateComps week];
}

NSString * getTimeString(NSDate * timeDate)
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [timeFormatter setLocale:[NSLocale currentLocale]];
    [timeFormatter setCalendar:calendar];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [timeFormatter stringFromDate: timeDate];
    
    return dateString;
}

NSDate *getMonthDateFromDate(NSDate *givenDate)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:givenDate];
    [components setDay:1];
    
    
    return [calendar dateFromComponents:components];
}

// Finds the date for the first day of the week
NSDate *getFirstDayOfTheWeekFromDate(NSDate *givenDate)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Edge case where beginning of week starts in the prior month
    NSDateComponents *edgeCase = [[NSDateComponents alloc] init];
    [edgeCase setMonth:2];
    [edgeCase setDay:1];
    [edgeCase setYear:2013];
    NSDate *edgeCaseDate = [calendar dateFromComponents:edgeCase];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:edgeCaseDate];
    [components setWeekday:1]; // 1 == Sunday, 7 == Saturday
    [components setWeek:[components week]];
    
    //NSLog(@"Edge case date is %@ and beginning of that week is %@", edgeCaseDate , [calendar dateFromComponents:components]);
    
    // Find Sunday for the given date
    components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:givenDate];
    [components setWeekday:1]; // 1 == Sunday, 7 == Saturday
    [components setWeek:[components week]];
    
    //NSLog(@"Original date is %@ and beginning of week is %@", givenDate , [calendar dateFromComponents:components]);
    
    return [calendar dateFromComponents:components];
}

NSUInteger daysBetween(NSDate *fromDate, NSDate *toDate) {
    
    fromDate = setDateToMidnite(fromDate);
    toDate = setDateToMidnite(toDate);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                             inUnit: NSEraCalendarUnit forDate:fromDate];
    NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                           inUnit: NSEraCalendarUnit forDate:toDate];
    return endDay - startDay;
}


NSDate *setDateToMidnite(NSDate *aDate) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit |
                                                        NSDayCalendarUnit |
                                                        NSHourCalendarUnit |
                                                        NSSecondCalendarUnit |
                                                        NSMinuteCalendarUnit) fromDate:aDate];
    
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    NSDate *midniteDate = [calendar dateFromComponents:dateComps];
    
    return midniteDate;
}


NSDate *setDatetoHourAndMinute(NSDate *theDate, int hour, int minute) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit |
                                                        NSDayCalendarUnit |
                                                        NSHourCalendarUnit |
                                                        NSSecondCalendarUnit |
                                                        NSMinuteCalendarUnit) fromDate:theDate];
    
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:0];
    
    NSDate *processedDate = [calendar dateFromComponents:dateComps];
    
    return processedDate;
}


int dayOfTheWeekFromDate(NSDate *aDate) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSWeekdayCalendarUnit) fromDate:aDate];
    
    return [dateComps weekday];
}


int dayOfTheMonthFromDate(NSDate *aDate) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSDayCalendarUnit) fromDate:aDate];
    
    return [dateComps day];
}

int currentMonth(void) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
    
    return [dateComps month];
}



NSDate *shiftDateByXmonths(NSDate *aDate, int shift) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setMonth:shift];
    NSDate *processedDate = [calendar dateByAddingComponents:dateComps toDate:aDate options:0];
    return processedDate;
}

NSDate *shiftDateByXweeks(NSDate *aDate, int shift) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setWeek:shift];
    NSDate *processedDate = [calendar dateByAddingComponents:dateComps toDate:aDate options:0];
    return processedDate;
}

NSDate *shiftDateByXdays(NSDate *aDate, int shift) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:shift];
    NSDate *processedDate = [calendar dateByAddingComponents:dateComps toDate:aDate options:0];
    return processedDate;
}

NSDate *setDateToDayOfMonth(NSDate *theDate, int dayOfMonth) {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateComponents *dateComps = [calendar components:(NSYearCalendarUnit |
                                                        NSMonthCalendarUnit |
                                                        NSDayCalendarUnit |
                                                        NSHourCalendarUnit |
                                                        NSSecondCalendarUnit |
                                                        NSMinuteCalendarUnit) fromDate:theDate];
    [dateComps setDay:dayOfMonth];
    [dateComps setSecond:0];
    
    NSDate *processedDate = [calendar dateFromComponents:dateComps];
    
    return processedDate;
    
}


@end
