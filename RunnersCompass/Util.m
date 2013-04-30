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


+(UIColor*) flatColorForCell:(NSInteger)indexFromInstallation
{
    //7 flat colors, return 1
    UIColor * flatColor;
    
    switch(indexFromInstallation % 7)
    {
        case 0:
            //rgb(192, 57, 43), pomegranate
            flatColor = [UIColor colorWithRed:192/255 green:57/255 blue:43/255 alpha:1.0];
            break;
        case 1:
            //rgb(241, 196, 15), sunflower
            flatColor = [UIColor colorWithRed:241/255 green:196/255 blue:15/255 alpha:1.0];
            break;
        case 2:
            //rgb(26, 188, 156), turqoise
            flatColor = [UIColor colorWithRed:26/255 green:188/255 blue:156/255 alpha:1.0];
            break;
        case 3:
            //rrgb(46, 204, 113), emerald
            flatColor = [UIColor colorWithRed:46/255 green:204/255 blue:113/255 alpha:1.0];
            break;
        case 4:
            //rgb(52, 152, 219),pete river
            flatColor = [UIColor colorWithRed:52/255 green:152/255 blue:219/255 alpha:1.0];
            break;
        case 5:
            //rgb(142, 68, 173), wisteria
            flatColor = [UIColor colorWithRed:142/255 green:68/255 blue:173/255 alpha:1.0];
            break;
        case 6:
            //rgb(44, 62, 80) , midnight blue
            flatColor = [UIColor colorWithRed:44/255 green:62/255 blue:80/255 alpha:1.0];
            break;
    }
    
    return  flatColor;
}

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

+(UIColor*) getContrastTextColor:(UIColor *)backgroundColor {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:backgroundColor];
    
    CGFloat total = ((components[0]*299)+(components[1]*587)+(components[2]*114))/1000;
    
	return (total >= 128) ? [UIColor blackColor] : [UIColor whiteColor];
    
}

+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}


@end
