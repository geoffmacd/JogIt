//
//  CompassSecondViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "JSSlidingViewController.h"
#import "CorePlot-CocoaTouch.h"

#define mapViewYOffset 193
#define mapDragCutoff 250
#define mapDragPreventOpposite 5
#define mapDragPullYOffset 20
#define paceGraphBarWidth 22
#define paceGraphSplitLoadOffset 20
#define paceGraphSplitObjects 100
#define kSelectedPlot @"selected"
#define kPlot @"plot"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)


@protocol LoggerViewControllerDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;
- (void)finishedRun:(RunEvent *)run;
- (void)pauseAnimation;

@end



@interface LoggerViewController : UIViewController <JSSlidingViewControllerDelegate,CPTPlotDataSource,CPTBarPlotDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    UIActionSheet *sheet;
    NSInteger selectedBarIndex;
    CPTXYGraph *barChart;
    NSTimer *timer;
    CPTBarPlot * selectedPlot;
    CPTBarPlot * barPlot;
    CPTXYPlotSpace *plotSpace;
    NSInteger lastCacheMinute;
    BOOL scrollEnabled;
    BOOL paused;
    BOOL inMapView;
    UIScrollView *mapScroll;
    NSTimer * shadeTimer;
    CGFloat countdown;
    BOOL kmPaceShowMode;
    NSUInteger numMinutesAtKmSelected;
}


//delegate
@property (weak, nonatomic) id <LoggerViewControllerDelegate>delegate;

//objects
@property (nonatomic, strong, setter = setRun:) RunEvent * run;
@property (nonatomic) BOOL paused;



//UI
@property (strong, nonatomic) IBOutlet UILabel *runTitle;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *chart;
@property (strong, nonatomic) IBOutlet UIButton *finishBut;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIView *shadeView;
@property (strong, nonatomic) IBOutlet UIButton *dragButton;
@property (strong, nonatomic) IBOutlet UIImageView *map;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *paceScroll;
@property (strong, nonatomic) IBOutlet UILabel *nextpace;
@property (strong, nonatomic) IBOutlet UILabel *oldpace1;
@property (strong, nonatomic) IBOutlet UILabel *oldpace2;
@property (strong, nonatomic) IBOutlet UILabel *oldpace3;
@property (strong, nonatomic) IBOutlet UILabel *currentPaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentPaceValue;
@property (strong, nonatomic) IBOutlet UIButton *invisibleLastKmButton;
@property (strong, nonatomic) IBOutlet UILabel *lastKmLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastKmPace;



//IB
- (IBAction)hamburgerTapped:(id)sender;
- (IBAction)handlePanGesture:(id)sender;
- (IBAction)mapIconTapped:(id)sender;
- (IBAction)finishTapped:(id)sender;
- (IBAction)invisibleButtonTapped:(id)sender;

- (void)newRun:(NSNumber *) value withMetric:(RunMetric) metric animate:(BOOL)animate;



@end

