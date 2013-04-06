//
//  UserPrefs.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPrefs : NSObject
@property NSString *fullname;
@property NSDate *birthdate;
@property NSNumber *weight;
@property NSNumber *countdown;
@property NSNumber *autopause;
@property NSNumber *metric;
@property NSNumber *showSpeed;
//@property (nonatomic, retain) NSNumber *facebook;
//@property (nonatomic, retain) NSNumber *twitter;

+ (id)defaultUser;
+(NSString*)getDistanceUnitWithMetric:(BOOL) forMetric;
-(NSString*)getDistanceUnit;
-(NSString*)getPaceUnit;
-(NSString*)getTimeStringWithSeconds:(NSTimeInterval) f;
-(NSString*)getTimeString:(NSTimeInterval) f;
@end
