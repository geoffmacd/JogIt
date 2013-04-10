//
//  GoalRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-09.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Goal.h"


@interface GoalRecord : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * value;


@end
