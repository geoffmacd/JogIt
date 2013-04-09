//
//  UserPrefs.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface UserPrefs : NSManagedObject


@property (nonatomic, retain) NSNumber * autopause;
@property (nonatomic, retain) NSNumber * metric;
@property (nonatomic, retain) NSNumber * showSpeed;
@property (nonatomic, retain) NSNumber * countdown;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSDate * birthdate;
//@property (nonatomic, retain) NSNumber *facebook;
//@property (nonatomic, retain) NSNumber *twitter;

+(NSString*)getDistanceUnitWithMetric:(BOOL) forMetric;
+(NSString*)getPaceUnitWithSpeedMetric:(BOOL)metric showSpeed:(BOOL)showSpeed;
-(NSString*)getDistanceUnit;
-(NSString*)getPaceUnit;
-(NSString*)getTimeStringWithSeconds:(NSTimeInterval) f;
-(NSString*)getTimeString:(NSTimeInterval) f;
@end
