//
//  DataController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "DataController.h"
@implementation DataController


@synthesize historyList = _historyList;

//replace setter accessor method
- (void)setHistoryList:(NSMutableArray *)newList
{
    if (_historyList != newList) {
        _historyList = [newList mutableCopy];
    }
}


//custom initiallizer for data controller required to
- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}


- (void)initializeDefaultDataList
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    self.historyList = list;
    
    //add sample here?
}


- (NSUInteger)countOfList
{
    NSUInteger size;
    
    size = [self.historyList count];
    
    return size;
    
}

- (RunEvent *)objectInListAtIndex:(NSUInteger)theIndex
{
    
    return [self.historyList objectAtIndex:theIndex];
    
}

- (void)addRunEvent:(RunEvent *)event
{
    [self.historyList addObject:event];
}


@end
