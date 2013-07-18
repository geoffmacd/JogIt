//
//  LocationRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationRecord : NSManagedObject

@property (nonatomic) NSTimeInterval date;
@property (nonatomic) float distance;
@property (nonatomic, retain) id location;
@property (nonatomic) double pace;
@property (nonatomic) double time;
@property (nonatomic) int32_t type;

@end
