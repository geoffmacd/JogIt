//
//  DataController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-12.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunEvent.h"


@interface DataController : NSObject

@property (nonatomic, copy) NSMutableArray *historyList;

- (NSUInteger)countOfList;
- (RunEvent *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addRunEvent:(RunEvent *)event;



@end
