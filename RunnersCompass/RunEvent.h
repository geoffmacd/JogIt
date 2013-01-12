//
//  RunEvent.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunEvent : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;


typedef enum {
    Monday=1,
    Tuesday,
    Wednesday,
    Thrusday
} RunType;


@property (nonatomic) RunType type;

-(id)initWithName:(NSString *)name location:(NSString *)location date:(NSDate *)date;


@end
