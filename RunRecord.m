//
//  RunRecord.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-04-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RunRecord.h"
#import "LocationRecord.h"
#import "UIImageToDataTransformer.h"

@implementation RunRecord

@dynamic name;
@dynamic date;
@dynamic targetMetric;
@dynamic eventType;
@dynamic metricGoal;
@dynamic calories;
@dynamic time;
@dynamic avgPace;
@dynamic distance;
@dynamic locations;
@dynamic thumbnail;

+ (void)initialize {
	if (self == [RunRecord class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
