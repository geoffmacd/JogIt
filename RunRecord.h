//
//  RunRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ThumbnailRecord.h"

@class LocationRecord;

@interface RunRecord : NSManagedObject


typedef enum
{
    RecordPosType,
    RecordMinType,
    RecordKmType,
    RecordMileType,
    RecordPauseType
} LocationType;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * targetMetric;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSNumber * metricGoal;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * avgPace;
@property (nonatomic, retain) NSNumber * distance;
//generated from transformer
@property (nonatomic, retain) UIImage *thumbnail;

@property (nonatomic, retain) NSSet *locations;
@property (nonatomic, retain) ThumbnailRecord *thumbnailRecord;
@end

@interface RunRecord (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(LocationRecord *)value;
- (void)removeLocationsObject:(LocationRecord *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
