//
//  CompassSecondViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "RunEvent.h"
#import "JSSlidingViewController.h"
#import "CorePlot-CocoaTouch.h"
#import "Util.h"
#import "AnimationUtil.h"
#import "KMAnnotation.h"
#import "MileAnnotation.h"
#import "UserPrefs.h"
#import "MBProgressHUD.h"
#import "StartAnnotation.h"
#import "FinishAnnotation.h"



#define mapZoomDefault 1000 //m
#define mapViewYOffset 173
#define mapDragCutoff 300
#define mapDragPreventOpposite 5
#define mapDragPullYOffset 30
#define paceGraphBarWidth 25.0
#define paceGraphSplitLoadOffset 20
#define paceGraphSplitObjects 30
#define paceGraphAnimated true //for km selection to animate pace chart
#define kSelectedPlot @"selected"
#define kPlot @"plot"
#define logRequiredAccuracy 50 //m maximum
#define calcPeriod 3 //every 3 seconds
#define barPeriod 60 //bar represents 10 seconds
#define autoZoomPeriod 6 //seconds before auto zoom
#define userDelaysAutoZoom 15 //second delays before autozoom
#define reloadMapIconPeriod 6 // second reload map icon period
#define autoPauseDelay 10 // seconds before app pauses
#define autoPauseSpeed 0.5 //m/s speed app pauses at 
#define minSpeedUnpause 1.25 //m/s
#define paceChartMaxYMin 1//m/s
#define paceChartCutoffPercent 0.05//%
#define maxPermittableAccuracy 30 //m
#define evalAccuracyPeriod 12 //seconds
#define avgPaceUpdatePeriod 3//ss
#define mapLoadSinceFinishWait 2//s
#define mapMinSpanForRun 0.005//degress
#define mapSpanMultipler 1.04// 4 percent
#define lowSignalPeriod 3//s for animation
#define mapPathWidth 15.0//pixels
#define mapIconPathWidth 10.0//pixels
#define mapPathSize 10 //positions
#define paceSelectionOverrideTime 5 //s
#define delayGoalAssessment 3 //s

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)


@protocol LoggerViewControllerDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;
- (void)finishedRun:(RunEvent *)run;
- (void)pauseAnimation:(void(^)(void))completion;
-(void)selectedGhostRun:(RunEvent *)run;
-(void)updateRunTimeForMenu:(NSString *)updateTimeString;
-(UserPrefs *)curUserPrefs;

@end



@interface LoggerViewController : UIViewController <JSSlidingViewControllerDelegate,CPTPlotDataSource,CPTBarPlotDelegate,UIScrollViewDelegate,UIActionSheetDelegate,CLLocationManagerDelegate,MKMapViewDelegate>
{
    //for ghost run
    UIActionSheet *sheet;
    
    //pace chart
    CPTXYGraph *barChart;
    NSTimer *timer;
    CPTBarPlot * selectedPlot;
    CPTBarPlot * barPlot;
    CPTXYPlotSpace *plotSpace;
    NSInteger lastCacheMinute;
    BOOL scrollEnabled;
    
    //general paused
    BOOL paused;
    
    //count for when to restart after autopausing
    NSInteger autoPauseRestartCount;
    BOOL pausedForAuto;
    
    //is user looking at full map
    BOOL inMapView;
    
    //km selection
    BOOL kmPaceShowMode;
    BOOL selectedPaceShowMode;
    NSInteger selectedMinIndex;
    NSInteger selectedKmIndex;
    NSUInteger numMinutesAtKmSelected;
    
    //core location
    CLLocationManager *locationManager;
    
    //times
    NSTimeInterval timeSinceMapCenter;
    NSTimeInterval timeSinceMapIconRefresh;
    NSTimeInterval timeSinceUnpause;
    NSTimeInterval timeSinceMapTouch;
    NSTimeInterval timeSinceKmSelection;
    NSTimeInterval timeSinceBarSelection;

    //quetostore positions not processed
    NSMutableArray *posQueue;
    
    //starting point for calcs from recent unpause
    BOOL needsStartPos;
    
    //for increased accuracy, smoothes out lines
    NSInteger consecutiveHeadingCount;
    
    //km markers on map
    NSMutableArray *mapAnnotations;
    //run overlay on map
    NSMutableArray *mapOverlays;
    NSMutableArray *mapGhostOverlays;
    MKPolyline *mapSelectionOverlay;
    
    
    //for finishing map loading before screen grab
    BOOL waitingForMapToLoad;
    NSInteger loadingMapTiles;
    NSTimeInterval timeSinceLastMapLoadFinish;
    
    //low signal
    CLLocationAccuracy avgAccuracy;
    
    //positions for labels for ghost runs
    CGRect orgTimeTitle;
    CGRect orgTimeLabel;
    
    //timer tracker
    NSInteger countdown; //s
    
    //low gps animation
    BOOL lowSignal;
    BOOL animatingLowSignal;
    CGRect orgTitleLabelPosition;
    //goal acheived label
    BOOL goalAchieved;
    BOOL animatingGoalAchieved;
    
    //ghost
    CGRect orgDistanceLabelPosition;
    CGRect orgDistanceTitlePosition;
    CGRect orgDistanceUnitPosition;
    
    //index for last drawn path
    NSInteger lastPathIndex;
    NSInteger lastGhostPathIndex;
    
    BOOL justLoaded;
}


//objects need to accesed by delegate:

//delegate
@property id <LoggerViewControllerDelegate>delegate;
@property (nonatomic, setter = setRun:) RunEvent * run;
@property BOOL paused;
//APP IS IN BACKGROUND
@property (setter = setInBackground:) BOOL inBackground;


//UI
@property (weak)  IBOutlet MKMapView *fullMap;
@property (weak)  IBOutlet UILabel *runTitle;
@property (weak)  IBOutlet UIView *slideView;
@property (weak)  IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak)  IBOutlet UIButton *statusBut;
@property (weak)  IBOutlet CPTGraphHostingView *chart;
@property (weak)  IBOutlet UIButton *finishBut;
@property (weak)  IBOutlet UIView *shadeView;
@property (weak)  IBOutlet UIButton *dragButton;
@property (weak)  IBOutlet UILabel *countdownLabel;
@property (weak)  IBOutlet UIScrollView *paceScroll;
@property (weak)  IBOutlet UILabel *oldpace1;
@property (weak)  IBOutlet UILabel *oldpace2;
@property (weak)  IBOutlet UILabel *oldpace3;
@property (weak)  IBOutlet UILabel *currentPaceLabel;
@property (weak)  IBOutlet UILabel *currentPaceValue;
@property (weak)  IBOutlet UIButton *invisibleLastKmButton;
@property (weak)  IBOutlet UILabel *lastKmLabel;
@property (weak)  IBOutlet UILabel *lastKmPace;
@property (weak)  IBOutlet UIImageView *goalAchievedImage;
@property (weak)  IBOutlet UILabel *distanceUnitLabel;
@property (weak)  IBOutlet UILabel *ghostDistanceUnitLabel;
@property (weak)  IBOutlet UILabel *paceUnitLabel1;
@property (weak)  IBOutlet UILabel *paceUnitLabel2;
@property (weak)  IBOutlet UILabel *timeLabel;
@property (weak)  IBOutlet UILabel *distanceLabel;
@property (weak)  IBOutlet UILabel *ghostDistance;
@property (weak)  IBOutlet UILabel *caloriesLabel;
@property (weak)  IBOutlet UILabel *paceLabel;
@property (weak)  IBOutlet UIButton *ghostBut;
@property (weak)  IBOutlet UILabel *caloriesTitle;
@property (weak)  IBOutlet UILabel *avgPaceTitle;
@property (weak)  IBOutlet UILabel *distanceTitle;
@property (weak)  IBOutlet UILabel *timeTitle;
@property (weak)  IBOutlet UILabel *swipeToPauseLabel;
@property (weak)  IBOutlet UIButton *hamburgerBut;
@property (weak)  IBOutlet UILabel *ghostDistanceTitle;
@property (weak)  IBOutlet MKMapView *iconMap;
@property (weak, nonatomic) IBOutlet UILabel *lowSignalLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *autopauseLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalAchievedLabel;


//IB

- (IBAction)hamburgerTapped:(id)sender;
- (IBAction)handlePanGesture:(id)sender;
- (IBAction)mapIconTapped:(id)sender;
- (IBAction)finishTapped:(id)sender;
- (IBAction)invisibleButtonTapped:(id)sender;
- (IBAction)invisibleTouched:(id)sender;
- (IBAction)invisibleUntouched:(id)sender;
- (IBAction)statusButTapped:(id)sender;
- (IBAction)ghostButTapped:(id)sender;
- (IBAction)hamburgerTouched:(id)sender;
- (IBAction)hamburgerUnTouched:(id)sender;
- (IBAction)ghostButTouched:(id)sender;
- (IBAction)ghostButUnTouched:(id)sender;
- (IBAction)statusTouched:(id)sender;
- (IBAction)statusUntouched:(id)sender;


//exposed methods
-(void) stopRun:(BOOL)finished;
- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate;
-(void)updateHUD;
-(void)cancelAutopausingRun;



@end


//for distance calculations

#define RAD_TO_DEG(r) ((r) * (180 / M_PI))
@interface CLLocation (Direction)
- (CLLocationDirection)directionToLocation:(CLLocation *)location;
@end
@implementation CLLocation (Direction)

- (CLLocationDirection)directionToLocation:(CLLocation *)location {
    
    CLLocationCoordinate2D coord1 = self.coordinate;
    CLLocationCoordinate2D coord2 = location.coordinate;
    
    CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
    CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
    CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
    
    CLLocationDegrees radians = atan2(yComponent, xComponent);
    CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
    
    return fmod(degrees, 360);
}

@end
