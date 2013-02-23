//
//  UserPrefs.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPrefs : NSObject
@property (nonatomic, retain) NSString *fullname;
@property (nonatomic, retain) NSDate *birthdate;
@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSNumber *countdown;
@property (nonatomic, retain) NSNumber *autopause;
@property (nonatomic, retain) NSNumber *metric;
@property (nonatomic, retain) NSNumber *facebook;
@property (nonatomic, retain) NSNumber *twitter;

+ (id)defaultUser;
@end
