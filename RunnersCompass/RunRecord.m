//
//  RunRecord.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-09.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunRecord.h"
#import "LocationRecord.h"
#import "ThumbnailRecord.h"
#import "UIImageToDataTransformer.h"


@implementation RunRecord

@dynamic avgPace;
@dynamic calories;
@dynamic date;
@dynamic distance;
@dynamic eventType;
@dynamic metricGoal;
@dynamic name;
@dynamic shortname;
@dynamic targetMetric;
@dynamic thumbnail;
@dynamic time;
@dynamic locations;
@dynamic thumbnailRecord;

@dynamic steps;
@dynamic cadence;
@dynamic climbed;
@dynamic descended;
@dynamic stride;

+ (void)initialize {
	if (self == [RunRecord class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
