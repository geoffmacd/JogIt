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

#define cellDropAnimationTime 0.3f
#define folderRotationAnimationTime 0.2f
#define distanceToShake 2.5f
#define shakeDuration 0.07f

@interface AnimationUtil : NSObject
+(void) cellLayerAnimate:(UIView *) expandedView toOpen:(BOOL)open;
+ (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees;

+(void)shakeView:(UIView *)viewToShake;
@end
