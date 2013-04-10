//
//  RunRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-09.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationRecord, ThumbnailRecord;

typedef enum
{
    RecordPosType,
    RecordMinType,
    RecordKmType,
    RecordMileType,
    RecordPauseType
} LocationType;

@interface RunRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * avgPace;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSNumber * metricGoal;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * targetMetric;
@property (nonatomic, retain) UIImage * thumbnail;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSOrderedSet *locations;
@property (nonatomic, retain) ThumbnailRecord *thumbnailRecord;
@end

@interface RunRecord (CoreDataGeneratedAccessors)

- (void)insertObject:(LocationRecord *)value inLocationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationsAtIndex:(NSUInteger)idx;
- (void)insertLocations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationsAtIndex:(NSUInteger)idx withObject:(LocationRecord *)value;
- (void)replaceLocationsAtIndexes:(NSIndexSet *)indexes withLocations:(NSArray *)values;
- (void)addLocationsObject:(LocationRecord *)value;
- (void)removeLocationsObject:(LocationRecord *)value;
- (void)addLocations:(NSOrderedSet *)values;
- (void)removeLocations:(NSOrderedSet *)values;
@end
