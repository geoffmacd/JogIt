//
//  ManualRun.h
//  JogIt
//
//  Created by Geoff MacDonald on 2013-06-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManualRun : NSObject

//meta data
@property (nonatomic) NSString *name; // for historic runs with date
@property (nonatomic) NSDate *date;//just set to now for all events on init


//total/averages for display/data collection

@property (nonatomic) CGFloat distance;
@property (nonatomic) CGFloat calories;
@property (nonatomic) NSInteger steps;
@property (nonatomic) NSTimeInterval avgPace;
@property (nonatomic) NSDate * time;

@end
