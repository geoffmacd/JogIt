//
//  AnimationUtil.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-15.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "AnimationUtil.h"

@implementation AnimationUtil

+(void)labelColorFade:(UILabel*)label withColor:(UIColor*)color
{
    [UIView transitionWithView:label duration:buttonFade options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [label setTextColor:color];
    } completion:nil];
}

+ (void)fadeView:(UIView *)view duration:(NSTimeInterval)duration toVisible:(BOOL)visible
{
    if(visible)
    {
        view.alpha = 0.0f;
        [view setHidden:false];
    }
    else
        view.alpha = 1.0f;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         if(!visible)
                             view.alpha = 0.0f;
                         else
                             view.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if(!visible)
                             [view setHidden:true];
                     }];
}

+ (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

+(void) cellLayerAnimate:(UIView *) expandedView toOpen:(BOOL)open openTime:(NSTimeInterval)openTime closeTime:(NSTimeInterval)closeTime closeAnimation:(UIViewAnimationOptions)closeAnimation
{
    
    if(open)
    {  
        
        CGRect rect = expandedView.frame;
        CGRect correct = rect;
        //set expanded view to be exactly behind header on starting
        rect.origin.y = 0;
        rect.size.height = 48;
        
        [expandedView setFrame:rect];
        [expandedView setHidden:!open];
        
        [UIView animateWithDuration:openTime
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [expandedView setFrame:correct];
                         }
                         completion:^(BOOL finished) {
                             //ensure it is not hidden
                             [expandedView setHidden:false];
                         }];
    }
    else{
        
        CGRect rect = expandedView.frame;
        CGRect correct = rect;
        rect.origin.y = 0;
        rect.size.height = 48;
        
        [UIView animateWithDuration:closeTime
                         delay:0
                         options:closeAnimation 
                         animations:^{
                             [expandedView setFrame:rect];
                         }
                         completion:^(BOOL finished) {
                             [expandedView setHidden:true];
                             [expandedView setFrame:correct];
                         }];
    }
}

+(void)shakeView:(UIView *)viewToShake
{
    
    CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
    anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-distanceToShake, 0.0f, 0.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(distanceToShake, 0.0f, 0.0f) ] ] ;
    anim.autoreverses = YES ;
    anim.repeatCount = 2.0f ;
    anim.duration = shakeDuration ;
    
    [ viewToShake.layer addAnimation:anim forKey:nil ] ;
}


+ (void)blinkAnimation:(NSString *)animationID finished:(BOOL)finished target:(UIView *)target
{
    
    [UIView beginAnimations:animationID context:(__bridge void *)(target)];
    [UIView setAnimationDuration:blinkPeriod];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(blinkAnimation:finished:target:)];
    
    if([target alpha] == 1.0f)
        [target setAlpha:alphaToBlinkTo];
    else
        [target setAlpha:1.0f];
    [UIView commitAnimations];
}

@end
