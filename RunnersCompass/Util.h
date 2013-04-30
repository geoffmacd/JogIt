//
//  Util.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-13.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPrefs.h"

@interface Util : NSObject

+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size;
+(UIColor*) redColour;
+(UIColor*) blueColour;
+(UIColor*) cellRedColour;

+(UIColor*) flatColorForCell:(NSInteger)indexFromInstallation;
+(void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;


@end