//
//  RunEvent.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunEvent.h"

@implementation RunEvent

@synthesize name;
@synthesize date;
@synthesize calories;
@synthesize distance;
@synthesize pace;
@synthesize time;
@synthesize live;



-(id)initWithName:(NSString *)_name date:(NSDate *)_date
{
    self = [super init];
    if (self) {
        name = _name;
        date = _date;
        distance = 4.1f;
        calories = 301.5f;
        pace = 264.3f;
        time = 2063.0f;
        live = true;
        return self;
    }
    return nil;
}


@end
