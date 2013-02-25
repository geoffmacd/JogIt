//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunMap.h"

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
    MetricTypeCalories
} RunMetric;

@property (nonatomic, weak) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) float distance;
@property (nonatomic) float time;
@property (nonatomic) float pace;
@property (nonatomic) float calories;
@property (nonatomic, strong) RunMap *map;
@property (nonatomic) RunType type;
@property (nonatomic, assign) BOOL live;

-(id)initWithName:(NSString *)name date:(NSDate *)date;

+(NSString * )stringForMetric:(RunMetric) metric;


@end
