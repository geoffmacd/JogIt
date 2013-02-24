//
//  DataTest.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goal.h"
#import "UserPrefs.h"
#import "RunEvent.h"

@interface DataTest : NSObject{
    Goal * curGoal;
    UserPrefs * prefs;
    RunEvent *curRun;
}


@property (nonatomic, retain) Goal * curGoal;
@property (nonatomic, retain) UserPrefs * prefs;
@property (nonatomic, retain) RunEvent *curRun;

+ (id)sharedData;


@end
