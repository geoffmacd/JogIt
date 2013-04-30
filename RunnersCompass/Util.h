//
//  Util.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-13.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPrefs.h"
#import "RunEvent.h"
#import "DateHelpers.h"

@interface Util : NSObject

+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size;
+(UIColor*) redColour;
+(UIColor*) blueColour;
+(UIColor*) cellRedColour;

+(UIColor*) flatColorForCell:(NSInteger)indexFromInstallation;
+(void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;

+(NSInteger)numPeriodsForRuns:(NSMutableArray*)runs withWeekly:(BOOL)weekly;

NSDate *getFirstDayOfTheWeekFromDate(NSDate *givenDate);


+(NSMutableArray*)runsForPeriod:(NSMutableArray*)runs withWeekly:(BOOL)weekly withPeriodStart:(NSDate*)start;

+(NSDate*)dateForPeriod:(NSInteger)index withWeekly:(BOOL)weekly;
@end