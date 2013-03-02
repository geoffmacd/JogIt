//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunMap.h"

@interface RunPos : NSObject{
    CGPoint pos;
    CGFloat elevation;
    CGFloat pace;
    NSTimeInterval time;
}

@property (nonatomic) CGPoint pos;
@property (nonatomic) CGFloat elevation;
@property (nonatomic) CGFloat pace;
@property (nonatomic) NSTimeInterval time;//seconds after the pausePoint


@end


@interface RunEvent : NSObject


typedef enum {
    EventTypeRun,
    EventTypeBike,
    EventTypeWalk,
    EventTypeHike
} RunType;

typedef enum 
{
    MetricTypeDistance,
    MetricTypePace,
    MetricTypeTime,
    MetricTypeCalories,
    MetricTypeClimbed,
    MetricTypeCadence,
    MetricTypeStride
} RunMetric;

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *date;
@property (nonatomic) float distance;
@property (nonatomic) float time;
@property (nonatomic) float pace;
@property (nonatomic) float calories;
@property (nonatomic, strong) RunMap *map;
@property (nonatomic) RunType type;
@property (nonatomic) RunMetric metric;
@property (nonatomic) NSNumber * metricGoal;
@property (nonatomic, assign) BOOL live;

//data ( all arrays of RunPos) , must be strong to retain
@property (nonatomic, strong) NSMutableArray * pos; //actual positions
@property (nonatomic, strong) NSMutableArray * distanceCheckpoints; //metrics @ km checkpoints
@property (nonatomic, strong) NSMutableArray * checkpoints; //metrics by time unit for graph
@property (nonatomic, strong) NSMutableArray * pausePoints; //NSDate for pauses



-(id)initWithName:(NSString *)name date:(NSDate *)date;

+(NSString * )stringForMetric:(RunMetric) metric;


@end
