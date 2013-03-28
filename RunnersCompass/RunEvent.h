//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunMap.h"
#define convertMSTOminKM 16.6666666666666

@interface CLLocationMeta : NSObject{
    NSTimeInterval pace;
    NSTimeInterval time;
    
}

@property (nonatomic) NSTimeInterval pace;//seconds per km
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
    NoMetricType,
    MetricTypeDistance,
    MetricTypePace,
    MetricTypeTime,
    MetricTypeCalories,
    MetricTypeClimbed,
    MetricTypeCadence,
    MetricTypeStride
} RunMetric;


//meta data
@property (nonatomic) NSString *name;//customized in init, to be displayed on the logger, not the hierarchial cells
@property (nonatomic) NSDate *date;//just set to now for all events on init
@property (nonatomic) RunType eventType;//not useful yet
@property (nonatomic) RunMetric metric;
@property (nonatomic) CGFloat metricGoal;
@property (nonatomic) BOOL live;
@property (nonatomic) BOOL ghost;

//total/averages for display/data collection

//updated every 5 sec
@property (nonatomic) CGFloat distance;
@property (nonatomic) NSTimeInterval avgPace;
@property (nonatomic) CGFloat calories;
@property (nonatomic) CGFloat climbed;
@property (nonatomic) CGFloat stride;
@property (nonatomic) CGFloat cadence;
//updated every second
@property (nonatomic) NSTimeInterval time;



//data 


//used during run
@property (nonatomic, strong) NSMutableArray * pos; //actual CLLocation positions
@property (nonatomic, strong) NSMutableArray * posMeta; //CLLocationMeta data

//processed later
@property (nonatomic, strong) NSMutableArray * kmCheckpoints; //metrics @ km checkpoints
@property (nonatomic, strong) NSMutableArray * kmCheckpointsMeta; //metrics @ km checkpoints

@property (nonatomic, strong) NSMutableArray * minCheckpoints; //metrics by time unit for graph
@property (nonatomic, strong) NSMutableArray * minCheckpointsMeta; //metrics by time unit for graph

@property (nonatomic, strong) NSMutableArray * pausePoints; //NSTimerInterval
@property (nonatomic, strong) RunMap *map;


-(id)initWithTarget:(RunMetric)type withValue:(CGFloat)value;
-(id)initWithNoTarget;

+(NSString * )stringForMetric:(RunMetric) metric;
+(NSString*)getCurKMPaceString:(NSTimeInterval)paceToFormat;
+(NSString*)getTimeString:(NSTimeInterval)timeToFormat;
+(NSString*)getPaceString:(NSTimeInterval)paceToFormat;
@end
