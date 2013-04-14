//
//  Util.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-13.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "Util.h"
#import <QuartzCore/QuartzCore.h>


@implementation Util


+ (UIImage *) imageWithView:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+(UIColor*) cellRedColour
{
    UIColor *redColor = [UIColor colorWithRed:142.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    return redColor;
}

+(UIColor*) redColour
{
    UIColor *redColor = [UIColor colorWithRed:192.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    return redColor;
}

+(UIColor*) blueColour
{
    
    UIColor *blueColor = [UIColor colorWithRed:37.0f/255 green:24.0f/255 blue:192.0f/255 alpha:1.0f];
    return blueColor;
}

@end
