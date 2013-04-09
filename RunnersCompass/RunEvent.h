//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "UserPrefs.h"
#import "RunRecord.h"
#import "LocationRecord.h"

#define convertMSTOminKM 16.6666666666666
#define convertKMToMile 0.6214//0.621371
#define calcPeriod 3 //s
#define barPeriod 3 //s

@interface CLLocationMeta : NSObject{
    NSTimeInterval pace;
    NSTimeInterval time;
    CGFloat distance;
    
}

@property (nonatomic) NSTimeInterval pace;//seconds per km
@property (nonatomic) NSTimeInterval time;//seconds after the pausePoint
@property (nonatomic) CGFloat distance;//m for distance


@end


@interface RunEvent : NSObject


typedef enum {
    EventTypeRun,
    EventTypeBike,
    EventTypeWalk,
    EventTypeHike
} EventType;

typedef enum 
{
    NoMetricType,
    MetricTypeDistance,
    MetricTypePace,
    MetricTypeTime,
    MetricTypeCalories,
    MetricTypeActivityCount,
    MetricTypeClimbed,
    MetricTypeCadence,
    MetricTypeStride
} RunMetric;

typedef enum
{
    NoRaceType,
    RaceType5Km,
    RaceType10Km,
    RaceType10Mile,
    RaceTypeHalfMarathon,
    RaceTypeFullMarathon
} RaceType;


//meta data
@property (nonatomic) NSString *name;//customized in init, to be displayed on the logger, not the hierarchial cells
@property (nonatomic) NSDate *date;//just set to now for all events on init
@property (nonatomic) NSString *mapPath; //path to map location
@property (nonatomic) EventType eventType;//not useful yet
@property (nonatomic) RunMetric targetMetric; //for targeted runs
@property (nonatomic) CGFloat metricGoal; //target run goal

//should be moved to logger
@property (nonatomic) BOOL live;
@property (nonatomic) BOOL ghost;
@property (nonatomic) RunEvent * associatedRun;


//total/averages for display/data collection

@property (nonatomic) CGFloat distance;
@property (nonatomic) CGFloat calories;
//@property (nonatomic) CGFloat climbed;
//@property (nonatomic) CGFloat stride;
//@property (nonatomic) CGFloat cadence;
@property (nonatomic) NSTimeInterval avgPace;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic) UIImage* thumbnail;



//data 


//used during run
@property (nonatomic, strong) NSMutableArray * pos; //actual CLLocation positions
@property (nonatomic, strong) NSMutableArray * posMeta; //CLLocationMeta data

//processed later
@property (nonatomic, strong) NSMutableArray * kmCheckpoints; //metrics @ km checkpoints
@property (nonatomic, strong) NSMutableArray * kmCheckpointsMeta; //metrics @ km checkpoints
@property (nonatomic, strong) NSMutableArray * impCheckpoints; //metrics @ km checkpoints
@property (nonatomic, strong) NSMutableArray * impCheckpointsMeta; //metrics @ km checkpoints


@property (nonatomic, strong) NSMutableArray * minCheckpoints; //metrics by time unit for graph
@property (nonatomic, strong) NSMutableArray * minCheckpointsMeta; //metrics by time unit for graph

@property (nonatomic, strong) NSMutableArray * pausePoints; //CLLocation to compare to just to draw new lines


-(id)initWithGhostRun:(RunEvent*)associatedRunToGhost;
-(id)initWithTarget:(RunMetric)type withValue:(CGFloat)value withMetric:(BOOL)metric showSpeed:(BOOL)showSpeed;
-(id)initWithNoTarget;
-(id)initWithRecord:(RunRecord*)record;
-(id)initWithRecordToLogger:(RunRecord*)record;
-(void)processRunForRecord;

+(NSString * )stringForMetric:(RunMetric) metricForDisplay showSpeed:(BOOL)showSpeed;
+(NSString*)getCurKMPaceString:(NSTimeInterval)paceToFormat;
+(NSString*)getTimeString:(NSTimeInterval)timeToFormat;
+(NSString*)getPaceString:(NSTimeInterval)paceToFormat withMetric:(BOOL)metricForDisplay showSpeed:(BOOL)showSpeed;
+(NSString * )stringForRace:(RaceType) metric;
+(CGFloat)getDisplayDistance:(CGFloat)distanceToDisplayInM withMetric:(BOOL)metricForDisplay;
@end
