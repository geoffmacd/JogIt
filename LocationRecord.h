//
//  LocationRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationRecord : NSManagedObject

@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSDate * date;
//pos,min,km,mile,pause
@property (nonatomic, retain) NSNumber * type; 
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * pace;

@end
