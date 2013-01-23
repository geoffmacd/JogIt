//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"

@implementation RunEvent

@synthesize name = _name;
@synthesize date = _date;



-(id)initWithName:(NSString *)name date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _name = name;
        _date = date;
        distance = 4.1f;
        avgPace = 273.6f;
        calories = 301.5f;
        climb = 16.7f;
        descend = 19.3f;
        
        return self;
    }
    return nil;
}


@end
