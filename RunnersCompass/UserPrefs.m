//
//  UserPrefs.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-06.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UserPrefs.h"

@implementation UserPrefs

@synthesize title, content, releaseDate, numberOfActor, suitAllAges, password, shortName, choice, rate;

+ (id)movieWithTitle:(NSString *)newTitle content:(NSString *)newContent {
    UserPrefs *movie = [[UserPrefs alloc] init];
    
    movie.title = newTitle;
    movie.content = newContent;
    
    return movie;
}


@end
