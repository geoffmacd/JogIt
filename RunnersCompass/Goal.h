//
//  Goal.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

typedef enum
{
    GoalTypeTotalDistance,
    GoalTypeOneDistance,
    GoalTypeCalories,
    GoalTypeRace,
} GoalType;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic) NSInteger value;
@property (nonatomic) NSInteger value2;
@property (nonatomic, retain) NSString * race;
@property (nonatomic) GoalType type;

-(id)initWithType:(GoalType)type value:(NSNumber *)value start:(NSDate *)start end:(NSDate *)end;
-(NSString*)getName;
-(NSArray*)getRaceTypes;
@end
