//
//  Goal.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunEvent.h" //for metric enum
#import "GoalRecord.h"

#define calsInLbFat 3500

@interface Goal : NSObject

typedef enum
{
    GoalTypeNoGoal,
    GoalTypeTotalDistance,
    GoalTypeOneDistance,
    GoalTypeCalories,
    GoalTypeRace
} GoalType;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic) GoalType type;//defines metric to use


@property (nonatomic, retain) NSNumber * activityCount;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSString * metricValueChange;
@property (nonatomic) CGFloat progress;
//sorta static
@property (nonatomic, retain) NSDictionary * raceDictionary;
@property (nonatomic, retain) NSDictionary * fatDictionary;

+(NSNumber*)getRaceDistance:(NSString*)stringForRace;
+(NSNumber*)getWeight:(NSString*)stringForWeight;
+(NSInteger)getCalorieForWeight:(NSInteger)lbs;
+(NSArray*)getWeightNames;
+(NSString*)getWeightNameForCals:(NSInteger)lbs;
+(NSArray*)getRaceNames;
+(NSString*)getRaceNameForRun:(CGFloat)distance;
-(id)initWithType:(GoalType)typeToCreate;
-(id)initWithRecord:(GoalRecord*)record;
-(NSString*)getName:(BOOL)metric;
-(NSString *)stringForDescription;
-(NSString *)stringForHeaderDescription;
-(NSString*)stringForSubtitle;
-(NSString *)stringForEdit2;
-(NSString *)stringForEdit1;
-(BOOL)validateGoalEntry:(BOOL)metric;
-(BOOL)processGoalForRuns:(NSMutableArray *)runsToAnalyze withMetric:(BOOL)metric;

@end
