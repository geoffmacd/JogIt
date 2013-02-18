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


@protocol LoggerViewControllerDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;

@end



@interface LoggerViewController : UIViewController <JSSlidingViewControllerDelegate,CPTPlotDataSource,CPTBarPlotDelegate>
{
@private
    CPTXYGraph *barChart;
    NSTimer *timer;
    
}


//delegate
@property (weak, nonatomic) id <LoggerViewControllerDelegate>delegate;

//objects
@property (nonatomic, weak, setter = setRun:) RunEvent * run;
@property (assign, nonatomic) BOOL inMapView;
@property (assign, nonatomic) BOOL paused;
@property (readwrite, retain, nonatomic) NSTimer *timer;


//UI
@property (strong, nonatomic) IBOutlet UILabel *runTitle;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) IBOutlet UIButton *dragMapButton;
@property (strong, nonatomic) IBOutlet UIImageView *mapThumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *chart;
@property (strong, nonatomic) IBOutlet UIButton *finishBut;




//IB
- (IBAction)hamburgerTapped:(id)sender;
- (IBAction)handlePanGesture:(id)sender;
- (IBAction)mapIconTapped:(id)sender;
- (IBAction)finishTapped:(id)sender;

@end

