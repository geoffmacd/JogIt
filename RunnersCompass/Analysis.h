//
//  Analysis.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RunEvent.h"

@interface Analysis : NSObject

//array of array holds metadata for every run including time,pace,calories, distance
@property (nonatomic, strong) NSMutableArray * runMeta;

//array of array per metric holds values per week
@property (nonatomic, strong) NSMutableArray * weeklyMeta;

//just an average of the above
@property (nonatomic, strong) NSMutableArray * monthlyMeta;

//race prediction weekly, just times 
@property (nonatomic, strong) NSMutableArray * weeklyRace;
@property (nonatomic, strong) NSMutableArray * monthlyRace;


-(id)setupFakeWithRuns:(NSMutableArray *)runToAnalyze;

-(CGFloat)timeForRace:(RaceType)raceType WithPace:(NSTimeInterval)paceForRace;
@end
