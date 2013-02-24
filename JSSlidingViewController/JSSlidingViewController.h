//
//  JSSlidingViewController.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define dropShadowXOffset 20.0f
#define firstStageAnimationClose 0.2f
#define secondStageAnimationClose 0.1f
#define bouncyOvershootX 10.0f
#define pauseOvershootX 100.0f
#define pauseSlideDuration 0.2f
#define pauseImageAnimationXScale 100.0f
#define pauseImageSize 50.0f
#define pauseDragChangeStateRatio 0.5f

@protocol JSSlidingViewControllerDelegate;

extern NSString * const JSSlidingViewControllerWillOpenNotification;
extern NSString * const JSSlidingViewControllerWillCloseNotification;
extern NSString * const JSSlidingViewControllerDidOpenNotification;
extern NSString * const JSSlidingViewControllerDidCloseNotification;
extern NSString * const JSSlidingViewControllerWillBeginDraggingNotification;

@interface JSSlidingViewController : UIViewController

@property (nonatomic, assign) BOOL frontViewControllerHasOpenCloseNavigationBarButton; // Defaults to YES.
@property (nonatomic, readonly) UIViewController *frontViewController;
@property (nonatomic, readonly) UIViewController *backViewController;
@property (strong, nonatomic) UIImageView *pauseImage;
@property (nonatomic, assign) BOOL allowManualSliding;
@property (assign, nonatomic) BOOL useBouncyAnimations;
@property (assign, nonatomic) BOOL toggledState;
@property (assign, nonatomic) BOOL shouldTemporarilyRemoveBackViewControllerWhenClosed;
@property (assign, nonatomic) BOOL isSetupForPauseScroll;
@property (assign, nonatomic) BOOL changeState;
@property (assign, nonatomic) BOOL liveRun;
@property (nonatomic, readonly) BOOL animating;
@property (nonatomic, readonly) BOOL isOpen;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, weak) id <JSSlidingViewControllerDelegate> delegate;
@property (nonatomic, weak) id <JSSlidingViewControllerDelegate> menuDelegate;

- (id)initWithFrontViewController:(UIViewController *)frontVC backViewController:(UIViewController *)backVC;
- (void)closeSlider:(BOOL)animated completion:(void (^)(void))completion;
- (void)openSlider:(BOOL)animated completion:(void (^)(void))completion;
- (void)setFrontViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setBackViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:(CGFloat)width;
- (void)pauseWithBounceAnimation:(void(^)(void))completion;

@end

// Note: These delegate methods are called *after* any completion blocks have been performed.

@protocol JSSlidingViewControllerDelegate <NSObject>

@optional

- (void)slidingViewControllerWillOpen:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerWillClose:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerDidOpen:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerDidClose:(JSSlidingViewController *)viewController;
- (void)isBouncing:(CGFloat)differential changeState:(BOOL)changeState;
-(void)resetViewFromSlider;

// If these are not implemented by the delegate, they return UIInterfaceOrientationPortrait for iPhone and all 4 orientations for iPad.
- (NSUInteger)supportedInterfaceOrientationsForSlidingViewController:(JSSlidingViewController *)viewController;
- (BOOL)slidingViewController:(JSSlidingViewController *)viewController shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end