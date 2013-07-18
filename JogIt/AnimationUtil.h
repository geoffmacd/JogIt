//
//  AnimationUtil.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-15.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


#define hierarchicalCellAnimationExpand 0.2f
#define hierarchicalCellAnimationCollapse 0.2f

#define dateCellAnimationExpand 0.2f
#define dateCellAnimationCollapse 0.3f

#define startCellAnimationExpand 0.25f
#define startCellAnimationCollapse 0.25f

#define folderRotationAnimationTime 0.15f
#define distanceToShake 3.0f
#define shakeDuration 0.1f
#define alphaToBlinkTo 0.35f
#define blinkPeriod 1.0f
#define buttonFade 0.2f //s


@interface AnimationUtil : NSObject

+ (void)fadeView:(UIView *)view duration:(NSTimeInterval)duration toVisible:(BOOL)visible;
+(void) cellLayerAnimate:(UIView *) expandedView toOpen:(BOOL)open openTime:(NSTimeInterval)openTime closeTime:(NSTimeInterval)closeTime closeAnimation:(UIViewAnimationOptions)closeAnimation;
+ (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees;

+(void)shakeView:(UIView *)viewToShake;
+ (void)blinkAnimation:(NSString *)animationID finished:(BOOL)finished target:(UIView *)target;

+(void)labelColorFade:(UILabel*)label withColor:(UIColor*)color;

@end
