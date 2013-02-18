//
//  CompassSecondViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Logger.h"

@interface LoggerViewController ()

@end

@implementation LoggerViewController

@synthesize run;
@synthesize runTitle;
@synthesize delegate;
@synthesize dragMapButton;
@synthesize mapView;
@synthesize chart;
@synthesize panGesture;
@synthesize inMapView;
@synthesize mapThumbnail;
@synthesize paused;
@synthesize statusIcon;
@synthesize timer;
@synthesize finishBut;


-(void)setRun:(RunEvent *)_run
{
    run = _run;
    
    [runTitle setText:run.name];
    
    [statusIcon setHidden:!run.live];
    
    //lock slider if not live
    
}

- (void)closeMapWithSmoothAnimation:(BOOL)animated completion:(void(^)(void))completion {
    CGFloat duration = 0.0f;
    if (animated) {
        duration = 0.25f;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            duration = 0.4f;
        }
    }
    [UIView animateWithDuration:duration  delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration animations:^{
        
        //set back to start
        CGRect mapRect;
        mapRect.origin = CGPointMake(0, 400);
        mapRect.size =  mapView.frame.size;
        [mapView setFrame:mapRect];
        
        [mapThumbnail setAlpha:1.0f];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
    }];
}


- (void)openMapWithSmoothAnimation:(BOOL)animated completion:(void(^)(void))completion {
    CGFloat duration = 0.0f;
    if (animated) {
        duration = 0.25f;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            duration = 0.4f;
        }
    }
    [UIView animateWithDuration:duration  delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration animations:^{
        
        //open mapview and pin to top
        CGRect mapRect;
        mapRect.origin = CGPointMake(0, 80);
        mapRect.size =  mapView.frame.size;
        [mapView setFrame:mapRect];
        
        
        [mapThumbnail setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    paused = true;
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    
    CGRect mapRect;
    mapRect.origin = CGPointMake(0, 400);
    mapRect.size =  mapView.frame.size;
    [mapView setFrame:mapRect];
    
    [self.view addSubview:mapView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceivePause:)
                                                name:@"pauseToggleNotification" object:nil];
    
    inMapView = false;
    
    
    [self timerFired];
}



- (void)didReceivePause:(NSNotification *)notification
{
    paused = !paused;
    
    UIImageView * pauseImage = (UIImageView *) [notification object];
    
    if(paused){
        [UIView transitionWithView:pauseImage
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"pause invert.png"];
                        } completion:NULL];
        [statusIcon setImage:[UIImage imageNamed:@"pause.png"]];
        
        [finishBut setHidden:false];
    }
    else
    {
        [UIView transitionWithView:pauseImage
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"record.png"];
                        } completion:NULL];
        [statusIcon setImage:[UIImage imageNamed:@"record.png"]];
        
        [finishBut setHidden:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarChart

-(void)timerFired
{
    
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    CPTGraphHostingView *hostingView = chart;
    hostingView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;
    
    // Paddings
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 0.0f;
    barChart.paddingBottom = 0.0f;
    
    barChart.plotAreaFrame.paddingLeft   = 40.0;
    barChart.plotAreaFrame.paddingTop    = 20.0;
    barChart.plotAreaFrame.paddingRight  = 10.0;
    barChart.plotAreaFrame.paddingBottom = 60.0;
    
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(300.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(16.0f)];
    
    //set scrolling
    //plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0.0f) length:CPTDecimalFromInt(300.0f)];
    //plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0.0f) length:CPTDecimalFromInt(24.0f)];
    [plotSpace setAllowsUserInteraction:false];
    
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = CPTDecimalFromString(@"10000");
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    //x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
    
    //y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle               = nil;
    y.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"2000000");
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    //y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
     
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    //barPlot.barOffset  = CPTDecimalFromFloat(-0.25f);
    barPlot.identifier = @"Bar Plot 1";
    
    /*
    //adding animation here
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [anim setDuration:2.5f];
    anim.toValue = [NSNumber numberWithFloat:1];
    anim.fromValue = [NSNumber numberWithFloat:0.0f];
    anim.removedOnCompletion = NO;
    anim.delegate = self;
    anim.fillMode = kCAFillModeForwards;
    
    
    barPlot.anchorPoint = CGPointMake(0.0, 0.0);
    [barPlot addAnimation:anim forKey:@"grow"];
    */
    
    
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    
}

/*
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation stopped");
    
}
 */

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 24;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:index];
                break;
                
            case CPTBarPlotFieldBarTip:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 1) * (index + 1)];
                if ( [plot.identifier isEqual:@"Bar Plot 2"] ) {
                    num = [num decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"10"]];
                }
                break;
        }
    }
    
    return num;
}


#pragma mark - UI Actions

- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(gestureRecognizer == panGesture)
    {
        CGPoint pt = [touch locationInView:mapView];
        CGRect rect = dragMapButton.frame;
        if(CGRectContainsPoint(rect, pt))
        {
            return true;
        }
        
    }
    return false;
}

- (IBAction)handlePanGesture:(id)sender {
    
    UIPanGestureRecognizer *pan= sender;
    
    
    if([pan state] == UIGestureRecognizerStateChanged)
    {
        
        CGPoint current = [pan translationInView:self.view];
        
        if(current.y < 5 && inMapView){
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = true;
        } else if (current.y > 5 && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        }
        
        CGRect mapRect;
        mapRect.origin = CGPointMake(0, (inMapView ? 80 : 400) + current.y);
        mapRect.size =  mapView.frame.size;
        
        [mapView setFrame:mapRect];
    }
    else
    {
        
        if(mapView.frame.origin.y > 200){
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        } else{
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = true;
        }
    }
}

- (IBAction)mapIconTapped:(id)sender {
    
    if(inMapView){
        [self closeMapWithSmoothAnimation:true completion:nil];
        inMapView = false;
    } else{
        [self openMapWithSmoothAnimation:true completion:nil];
        inMapView = true;
    }
}

- (IBAction)finishTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
}
@end
