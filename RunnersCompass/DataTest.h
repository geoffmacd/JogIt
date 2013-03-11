//
//  DataTest.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunEvent.h"
#import "Goal.h"
#import "UserPrefs.h"
#import "Analysis.h"

@interface DataTest : NSObject{
    RunEvent * curRun;
    Goal * curGoal;
    UserPrefs * prefs;
    Analysis * analysis;
}


@property (nonatomic, retain) Goal * curGoal;
@property (nonatomic, retain) UserPrefs * prefs;
@property (nonatomic, retain) RunEvent * curRun;
@property (nonatomic, retain) Analysis * analysis;


+ (id)sharedData;


@end
