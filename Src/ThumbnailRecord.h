//
//  ThumbnailRecord.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RunRecord;

@interface ThumbnailRecord : NSManagedObject

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) RunRecord *run;

@end
