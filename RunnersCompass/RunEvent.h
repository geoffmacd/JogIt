//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunMap.h"

@interface RunEvent : NSObject{
    float distance;
    float avgPace;
    float calories;
    float climb;
    float descend;
}


typedef enum {
    Monday=1,
    Tuesday,
    Wednesday,
    Thursday
} RunType;

@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSDate *date;
@property (nonatomic, strong) RunMap *map;
@property (nonatomic) RunType type;

-(id)initWithName:(NSString *)name date:(NSDate *)date;


@end
