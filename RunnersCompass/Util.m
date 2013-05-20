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


+(UIColor*) flatColorForCell:(NSInteger)indexFromInstallation
{
    //7 flat colors, return 1
    UIColor * flatColor;
    
    //return [self redColour];
    
    switch(indexFromInstallation % 2)
    {
            
        case 0:
            //rgb(44, 62, 80) , midnight blue
            flatColor = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
            break;
            
        case 1:
            //rgb(41, 128, 185), belize
            flatColor = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
            break;
            /*
        case 0:
            //rgb(44, 62, 80) , midnight blue
            flatColor = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
            break;
            
        case 1:
            //rgb(41, 128, 185), belize 
            flatColor = [UIColor colorWithRed:41.0/255.0 green:128.0/255.0 blue:185.0/255.0 alpha:1.0];
            break;
             case 0:
             //rgb(52, 73, 94), wet asphalt
             flatColor = [UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1.0];
             break;
             
             
             case 1:
             //rgb(52, 152, 219),pete river
             flatColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219/255.0 alpha:1.0];
             break;
             
             case 0:
             //rgb(192, 57, 43), pomegranate
             flatColor = [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
             break;
             case 1:
             //rgb(231, 76, 60) , alizarins
             flatColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
             break;
            
        case 1:
            //rgb(39, 174, 96), nephritis
            flatColor = [UIColor colorWithRed:39.0/255.0 green:174.0/255.0 blue:96.0/255.0 alpha:1.0];
            break;
        case 0:
            //rgb(211, 84, 0), pumpkin
            flatColor = [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
            
        case 3:
            //rgb(243, 156, 18), orange
            flatColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
            break;
            
        case 2:
            //rgb(22, 160, 133), green sea
            flatColor = [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0];
            break;
        case 0:
            //rgb(192, 57, 43), pomegranate
            flatColor = [UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1.0];
            break;
        case 1:
            //rgb(231, 76, 60) , alizarins
            flatColor = [UIColor colorWithRed:231.0/255.0 green:76.0/255.0 blue:60.0/255.0 alpha:1.0];
            break;
        //case 1:
            //rgb(241, 196, 15), sunflower
            flatColor = [UIColor colorWithRed:241.0/255 green:196.0/255.0 blue:15.0/255.0 alpha:1.0];
            break;
        case 64:
            //rgb(26, 188, 156), turqoise
            flatColor = [UIColor colorWithRed:26.0/255.0 green:188.0/255.0 blue:156.0/255.0 alpha:1.0];
            break;
        case 2:
            //rrgb(46, 204, 113), emerald
            flatColor = [UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1.0];
            break;
        case 3:
            //rgb(52, 152, 219),pete river
            flatColor = [UIColor colorWithRed:52.0/255.0 green:152.0/255.0 blue:219/255.0 alpha:1.0];
            break;
        case 4:
            //rgb(142, 68, 173), wisteria
            flatColor = [UIColor colorWithRed:142.0/255.0 green:68.0/255.0 blue:173.0/255.0 alpha:1.0];
            break;
        case 5:
            //rgb(44, 62, 80) , midnight blue
            flatColor = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
            break;
             
             case 5:
             //rgb(211, 84, 0), pumpkin 
             flatColor = [UIColor colorWithRed:211.0/255.0 green:84.0/255.0 blue:0.0/255.0 alpha:1.0];
             break;
             
             case 5:
             //rgb(243, 156, 18), orange
             flatColor = [UIColor colorWithRed:243.0/255.0 green:156.0/255.0 blue:18.0/255.0 alpha:1.0];
             break;
             */
            
    }
    
    return  flatColor;
}

+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+(UIColor*) cellRedColour
{
    UIColor *redColor = [UIColor colorWithRed:142.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    return redColor;
}

+(UIColor*) redColour
{
    //UIColor *redColor = [UIColor colorWithRed:192.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    UIColor * redColor = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
    return redColor;
}

+(UIColor*) blueColour
{
    
    UIColor *blueColor = [UIColor colorWithRed:37.0f/255 green:24.0f/255 blue:192.0f/255 alpha:1.0f];
    return blueColor;
}

+(UIColor*) getContrastTextColor:(UIColor *)backgroundColor {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:backgroundColor];
    
    CGFloat total = ((components[0]*299)+(components[1]*587)+(components[2]*114))/1000;
    
	return (total >= 128) ? [UIColor blackColor] : [UIColor whiteColor];
    
}

+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

+(NSInteger)numPeriodsForRuns:(NSMutableArray*)runs withWeekly:(BOOL)weekly
{
    NSInteger periods = 0;
    NSDate *oldest = [self dateForPeriod:0 withWeekly:weekly];
    NSDate *newest = [NSDate date];
    
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
        NSDate *iWeek = newest;
        
        while([oldest timeIntervalSinceReferenceDate] < [iWeek timeIntervalSinceReferenceDate])
        {
            periods++;
            //shift date one week at a time until iWeek is less
            iWeek = shiftDateByXweeks(newest, -periods);
        }
        
    }
    else
    {
        NSDate *iMonth = newest;
        
        while([oldest timeIntervalSinceReferenceDate] < [iMonth timeIntervalSinceReferenceDate])
        {
            periods++;
            //shift date one month at a time until iWeek is less
            iMonth = shiftDateByXmonths(newest, -periods);
        }
    }
    
    //NSLog(@"%d periods found for %d runs", periods, [runs count]);
    
    //show at least two months
    if(periods == 1)
        return 2;
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
