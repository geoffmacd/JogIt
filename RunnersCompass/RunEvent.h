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
    Monday=1,
    Tuesday,
    Wednesday,
    Thrusday
} RunType;

@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *location;
@property (nonatomic, weak) NSDate *date;
@property (nonatomic, weak) RunMap *map;
@property (nonatomic) RunType type;

-(id)initWithName:(NSString *)name location:(NSString *)location date:(NSDate *)date;


@end
