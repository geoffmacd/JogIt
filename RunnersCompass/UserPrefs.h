//
//  UserPrefs.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPrefs : NSObject
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *releaseDate;
@property (nonatomic, retain) NSNumber *numberOfActor;
@property (nonatomic, retain) NSNumber *suitAllAges;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *shortName;
@property (nonatomic, retain) NSString *choice;
@property (nonatomic, retain) NSNumber *rate;

+ (id)movieWithTitle:(NSString *)newTitle content:(NSString *)newContent;
@end
