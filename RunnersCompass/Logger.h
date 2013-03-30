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
#import "DataTest.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "Util.h"
#import "KMAnnotation.h"


#define mapZoomDefault 1000 //m
#define mapViewYOffset 173
#define mapDragCutoff 300
#define mapDragPreventOpposite 5
#define mapDragPullYOffset 30
#define paceGraphBarWidth 25
#define paceGraphSplitLoadOffset 20
#define paceGraphSplitObjects 30
#define kSelectedPlot @"selected"
#define kPlot @"plot"
#define logRequiredAccuracy 50 //m maximum
#define calcPeriod 3 //every 2 seconds
#define barPeriod 3 //bar represents 10 seconds
#define autoZoomPeriod 4 //seconds before auto zoom
#define userDelaysAutoZoom 5 //second delays before autozoom
#define reloadMapIconPeriod 3 // second reload map icon period
#define autoPauseDelay 9 // seconds before app pauses
#define autoPauseSpeed 0.5 //m/s speed app pauses at 
#define minSpeedUnpause 1 //m/s
#define paceChartMaxYMin 0.5//m/s
#define paceChartCutoffOffset 0.1//m/s
#define maxPermittableAccuracy 30 //m
#define evalAccuracyPeriod 5 //seconds
#define avgPaceUpdatePeriod 3//ss
#define mapLoadSinceFinishWait 3//s

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

    //quetostore positions not processed
    NSMutableArray *posQueue;
    
    //starting point for calcs from recent unpause
    BOOL needsStartPos;
    
    //for increased accuracy, smoothes out lines
    NSInteger consecutiveHeadingCount;
    
    //km markers on map
    NSMutableArray *mapAnnotations;
    //run overlay on map
    BOOL readyForPathInit;
    NSMutableArray *crumbPaths;
    NSMutableArray *crumbPathViews;
    
    //for finishing map loading before screen grab
    BOOL waitingForMapToLoad;
    NSInteger loadingMapTiles;
    NSTimeInterval timeSinceLastMapLoadFinish;
    
    //low signal
    CLLocationAccuracy avgAccuracy;
    
    //positions for labels for ghost runs
    CGFloat timeTitlex,timeLabelx;
    
}


//objects need to accesed by delegate:

//delegate
@property (weak, nonatomic) id <LoggerViewControllerDelegate>delegate;
//user preferences
@property (nonatomic, strong, setter = setRun:) RunEvent * run;
@property (nonatomic) BOOL paused;
//APP IS IN BACKGROUND
@property (nonatomic,setter = setInBackground:) BOOL inBackground;


//UI
@property (strong, nonatomic)  IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UILabel *runTitle;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIButton *statusBut;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *chart;
@property (strong, nonatomic) IBOutlet UIButton *finishBut;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIView *shadeView;
@property (strong, nonatomic) IBOutlet UIButton *dragButton;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *paceScroll;
@property (strong, nonatomic) IBOutlet UILabel *oldpace1;
@property (strong, nonatomic) IBOutlet UILabel *oldpace2;
@property (strong, nonatomic) IBOutlet UILabel *oldpace3;
@property (strong, nonatomic) IBOutlet UILabel *currentPaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentPaceValue;
@property (strong, nonatomic) IBOutlet UIButton *invisibleLastKmButton;
@property (strong, nonatomic) IBOutlet UILabel *lastKmLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastKmPace;
@property (strong, nonatomic) IBOutlet UIImageView *goalAchievedImage;
@property (strong, nonatomic) IBOutlet UILabel *distanceUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *ghostDistanceUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel *paceUnitLabel1;
@property (strong, nonatomic) IBOutlet UILabel *paceUnitLabel2;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ghostDistance;
@property (strong, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *paceLabel;
@property (strong, nonatomic) IBOutlet UIButton *ghostBut;
@property (strong, nonatomic) IBOutlet UILabel *caloriesTitle;
@property (strong, nonatomic) IBOutlet UILabel *avgPaceTitle;
@property (strong, nonatomic) IBOutlet UILabel *distanceTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeTitle;
@property (strong, nonatomic) IBOutlet UILabel *swipeToPauseLabel;
@property (strong, nonatomic) IBOutlet UIButton *hamburgerBut;
@property (strong, nonatomic) IBOutlet UIImageView *lowSignalImage;
@property (strong, nonatomic) IBOutlet UILabel *ghostDistanceTitle;



//IB
- (IBAction)hamburgerTapped:(id)sender;
- (IBAction)handlePanGesture:(id)sender;
- (IBAction)mapIconTapped:(id)sender;
- (IBAction)finishTapped:(id)sender;
- (IBAction)invisibleButtonTapped:(id)sender;
- (IBAction)statusButTapped:(id)sender;
- (IBAction)ghostButTapped:(id)sender;
- (IBAction)hamburgerTouched:(id)sender;
- (IBAction)hamburgerUnTouched:(id)sender;
- (IBAction)ghostButTouched:(id)sender;
- (IBAction)ghostButUnTouched:(id)sender;
- (IBAction)statusTouched:(id)sender;
- (IBAction)statusUntouched:(id)sender;


//exposed methods
-(void) stopRun;
- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate;
-(void)updateHUD;



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
