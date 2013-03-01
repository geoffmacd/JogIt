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
@synthesize countdown;
@synthesize paceScroll;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    paused = true;
    //hide status button until live run
    [statusIcon setHidden:true];
    
    
    //load most recent run on startup, but not intended any other time
    RunEvent * loadRun = [[RunEvent alloc] initWithName:@"Old Run" date:[NSDate date]];
    loadRun.live = false;
    
    NSMutableArray * loadPos = [[NSMutableArray alloc] initWithCapacity:10000];
    
    for(int i = 0; i < 10000; i ++)
    {
        RunPos *posToAdd = [[RunPos alloc] init];
        
        posToAdd.pos =  CGPointMake(arc4random() % 100, arc4random() % 100);
        posToAdd.velocity =  arc4random() % 100;
        posToAdd.elevation =  arc4random() % 100;
        
        
        [loadPos addObject:posToAdd];
    }
    
    [loadRun setPos:loadPos];
    [self setRun:loadRun];
    
    
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    
    
    CGRect mapRect;
    mapRect.size =  mapView.frame.size;
    
    //must resize acc. to screen size to ensure bottom of map view is always bottom of view
    //the self.view is resizing in JSSLider which prevents us from getting real height
    if(IS_IPHONE5)
        mapRect.origin = CGPointMake(0, mapView4inchOffset);
    else
        mapRect.origin = CGPointMake(0, mapView35inchOffset);
    mapRect.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height  - mapViewYOffset - mapDragPullYOffset);
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
    

    
    //set content offset here
    [paceScroll setContentOffset:CGPointMake(0, 0)];
    [paceScroll setDelegate:self];
    
    [self timerFired];
    


    

}

-(void) viewDidLayoutSubviews
{
    //setup map here instead after view has possibly been resized
    //only need a bigger width
    
    CGRect rect;
    rect = paceScroll.frame;
    rect.size.width = 1000;
    rect.origin = CGPointMake(0, 0);
    [chart setFrame:rect];
    
    //need to set scroll width to be equal
    [paceScroll setContentSize:CGSizeMake(1000, rect.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing runs

/*
-(void) countdownCycle
{
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         [countdownLabel setText:[NSString stringWithFormat:@"%.f", countdown]];
                         
                     }
                     completion:^(BOOL finish){
                         countdown -= 0.5;
                         
                        [self countdownCycle];
                     }
     ];
}
*/



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
                         
                         //swipe early
                         if(!self.paused)
                         {
                             [shadeView setHidden:true];
                             [shadeView setAlpha:1.0f];
                             [countdownLabel setText:@"3"];
                         }
                         else
                         {
                             [countdownLabel setText:@"2"];
                             [UIView animateWithDuration:1.0 animations:^{
                                 
                                 [countdownLabel setAlpha:1.0f];
                                 
                             }
                                              completion:^(BOOL finish){
                                                  
                                                  //swipe early
                                                  if(!self.paused)
                                                  {
                                                      [shadeView setHidden:true];
                                                      [shadeView setAlpha:1.0f];
                                                      [countdownLabel setText:@"3"];
                                                  }
                                                  else
                                                  {
                                                      [countdownLabel setText:@"1"];
                                                      [UIView animateWithDuration:1.0 animations:^{
                                                          
                                                          [countdownLabel setAlpha:0.7f];
                                                          [shadeView setAlpha:0.1f];
                                                          
                                                          
                                                      }
                                                                       completion:^(BOOL finish){
                                                                           
                                                                           
                                                                           [shadeView setHidden:true];
                                                                           [shadeView setAlpha:1.0f];
                                                                           [countdownLabel setText:@"3"];
                                                                           
                                                                           //animate the view controller
                                                                           //this will scroll to the right and automatically start recording with the delegate viewdidsroll method
                                                                           [delegate pauseAnimation];
                                                                           
                                                                       }];
                                                      
                                                  }
                                              }];
                         }
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




- (void)didReceivePause:(NSNotification *)notification
{
    //assume it is not locked
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
    
    barChart.plotAreaFrame.paddingLeft   = 0.0f;
    barChart.plotAreaFrame.paddingTop    = 0.0;//nothing
    barChart.plotAreaFrame.paddingRight  = 0.0f;
    barChart.plotAreaFrame.paddingBottom = 10.0f;
    
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
     
    /*
    //set scrolling
    //plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0.0f) length:CPTDecimalFromInt(300.0f)];
    //plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0.0f) length:CPTDecimalFromInt(24.0f)];
    //[plotSpace setAllowsUserInteraction:true];
    */
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
     
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor darkGrayColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.identifier = @"Pace Chart";
    
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
    return 100;
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
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:arc4random() % 100];
                
                
                break;
        }
    }
    
    return num;
}


#pragma mark - Map opening



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
        mapRect.origin = CGPointMake(0, self.view.frame.size.height - mapDragPullYOffset);//gaurentees position
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
        mapRect.origin = CGPointMake(0, mapViewYOffset - mapDragPullYOffset);//gauranteed position
        [mapView setFrame:mapRect];
        
        
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
    }];
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
            
            //translate on the finger of the user with current.y
            CGRect mapRect;
            mapRect.size =  mapView.frame.size;
            //mapRect.origin = CGPointMake(0, (inMapView ? (self.view.frame.size.height - mapView.frame.size.height)  : mapViewYOffset) + current.y);
            mapRect.origin = CGPointMake(0, (inMapView ? mapViewYOffset - mapDragPullYOffset : self.view.frame.size.height - mapDragPullYOffset) + current.y);
            
            
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
    [delegate finishedRun:run];
    
    //convert current run to a historical run now that it is saved!
    [self setRun:run];
    
}

- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
}
@end
