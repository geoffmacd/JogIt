//
//  CompassSecondViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Logger.h"
#import "JSSlidingViewController.h"

@interface LoggerViewController ()

@end

@implementation LoggerViewController

@synthesize run;
@synthesize runTitle;
@synthesize delegate;
@synthesize mapView;
@synthesize chart;
@synthesize panGesture;
@synthesize inMapView;
@synthesize paused;
@synthesize statusIcon;
@synthesize timer;
@synthesize finishBut;
@synthesize mapScroll;
@synthesize scrollEnabled;
@synthesize mapButton;
@synthesize dragButton;
@synthesize map;
@synthesize shadeView;
@synthesize shadeTimer;
@synthesize countdownLabel;


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    paused = true;
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    
    
    CGRect mapRect;
    mapRect.size =  mapView.frame.size;
    mapRect.origin = CGPointMake(0, mapViewYOffset);
    [mapView setFrame:mapRect];
    
    [self.view addSubview:mapView];
    
    CGRect shadeRect = self.view.frame;
    [shadeView setFrame:shadeRect];
    
    [self.view addSubview:shadeView];
    
    
    [mapButton.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mapButton.layer setBorderWidth: 1.0];
    
    [map.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [map.layer setBorderWidth: 1.0];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceivePause:)
                                                name:@"pauseToggleNotification" object:nil];
    
    inMapView = false;
    
    
    [self timerFired];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing runs

- (void)newRun:(NSInteger) value withMetric:(NSInteger) metric animate:(BOOL)animate pauseImage:(UIImageView*)image
{
    [self setRun:[[RunEvent alloc] initWithName:@"10.5 Km" date:[NSDate date]]];
    
    
    [statusIcon setHidden:false];
    [finishBut setHidden:true];
    
    [shadeView setHidden:false];
    [countdownLabel setAlpha:1.0f];
    
    //previous notification in app delegate has already changed status to paused
    NSAssert(paused, @"not yet paused from appdelegate notification");
    
    [UIView animateWithDuration:1.0 animations:^{
        [countdownLabel setAlpha:0.7f];
        
    }
                     completion:^(BOOL finish){
                         
                         [countdownLabel setText:@"2"];
                         [UIView animateWithDuration:1.0 animations:^{
                             
                             [countdownLabel setAlpha:1.0f];
                             
                         }
                                          completion:^(BOOL finish){
                                              
                                              [countdownLabel setText:@"1"];
                                              [UIView animateWithDuration:1.0 animations:^{
                                                  
                                                  [countdownLabel setAlpha:0.7f];
                                                  [shadeView setAlpha:0.1f];
                                                  
                                                  
                                              }
                                                               completion:^(BOOL finish){
                                                                   
                                                                   //notification with pause image to start recording
                                                                   [[NSNotificationCenter defaultCenter]
                                                                    postNotificationName:@"pauseToggleNotification"
                                                                    object:image];
                                                                   
                                                                   [shadeView setHidden:true];
                                                                   [shadeView setAlpha:1.0f];
                                                                   [countdownLabel setText:@"3"];
                                                                   
                                                               }];
                                              
                                          }];
                         
                     }];
    
}

-(void)setRun:(RunEvent *)_run
{
    run = _run;
    
    if(!run.live)
    {
        //set title
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        [runTitle setText:[NSString stringWithFormat:@"%@ • %@", run.name, [dateFormatter stringFromDate:run.date]]];
    }
    else
        [runTitle setText:run.name];
    
    //hide these by default unless newrun overrides them
    [statusIcon setHidden:true];
    [finishBut setHidden:true];

    
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
        mapRect.origin = CGPointMake(0, mapViewYOffset);
        mapRect.size =  mapView.frame.size;
        [mapView setFrame:mapRect];
        
        
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
        mapRect.size =  mapView.frame.size;
        mapRect.origin = CGPointMake(0, mapViewYOffset - map.frame.size.height);
        [mapView setFrame:mapRect];
        
        
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
    }];
}



- (void)didReceivePause:(NSNotification *)notification
{
    paused = !paused;
    
    UIImageView * pauseImage = (UIImageView *) [notification object];
    
    if(paused){
        [UIView transitionWithView:pauseImage
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"pause invert.png"];
                        } completion:NULL];
        
        [UIView transitionWithView:statusIcon
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            statusIcon.image = [UIImage imageNamed:@"pause.png"];
                        } completion:NULL];
        
        finishBut.alpha = 0.0f;
        [finishBut setHidden:false];
        [UIView transitionWithView:finishBut
                          duration:0.2f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 1.0f;
                        } completion:nil];
        
    }
    else
    {
        [UIView transitionWithView:pauseImage
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"record.png"];
                        } completion:NULL];
        
        
        [UIView transitionWithView:statusIcon
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            statusIcon.image = [UIImage imageNamed:@"record.png"];
                        } completion:NULL];
        
        
        finishBut.alpha = 1.0f;
        [UIView transitionWithView:finishBut
                          duration:0.2f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 0.0f;
                        } completion:^(BOOL finish){
                            [finishBut setHidden:true];
                        }];
        
    }
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


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(gestureRecognizer == panGesture)
    {
        //check the long drag button
        CGPoint pt = [touch locationInView:mapView];
        //check the drag button
        CGRect rect  = dragButton.frame;
        if(CGRectContainsPoint(rect, pt))
        {
            return true;
        }
        
        pt = [touch locationInView:self.view];
        rect = mapButton.frame;
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
        
        if(current.y < mapDragPreventOpposite && inMapView){
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = true;
        } else if (current.y > mapDragPreventOpposite && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        } else if (current.y < -mapDragCutoff && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        }else if (current.y > mapDragCutoff && inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        } else{
            
            CGRect mapRect;
            mapRect.size =  mapView.frame.size;
            mapRect.origin = CGPointMake(0, (inMapView ? (self.view.frame.size.height - mapView.frame.size.height)  : mapViewYOffset) + current.y);
            
            
            [mapView setFrame:mapRect];
        
        }
    }
    else
    {
        
        if(mapView.frame.origin.y > mapDragCutoff){
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
    [delegate finishedRun];
    
    //convert current run to a historical run now that it is saved!
    [self setRun:run];
    
}

- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
    
}
@end
