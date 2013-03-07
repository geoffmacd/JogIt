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
@synthesize mapView;
@synthesize chart;
@synthesize panGesture;
@synthesize statusBut;
@synthesize finishBut;
@synthesize mapButton;
@synthesize dragButton;
@synthesize map;
@synthesize shadeView;
@synthesize countdownLabel;
@synthesize paceScroll;
@synthesize currentPaceLabel,currentPaceValue;
@synthesize paused;
@synthesize lastKmLabel,oldpace1,oldpace2,oldpace3,lastKmPace;
@synthesize goalAchievedImage;
@synthesize paceLabel,paceUnitLabel1,paceUnitLabel2;
@synthesize distanceLabel,distanceUnitLabel;
@synthesize caloriesLabel,timeLabel;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    
    
    [mapButton.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mapButton.layer setBorderWidth: 1.0];
    
    [map.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [map.layer setBorderWidth: 1.0];
    
    [paceScroll setDelegate:self];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceivePause:)
                                                name:@"pauseToggleNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setLabelsForUnits)
                                                 name:@"reloadUnitsNotification"
                                               object:nil];
    kmPaceShowMode= false;
    inMapView = false;
    paused = true;

}

-(void) viewDidLayoutSubviews
{
    //set correct position for mapview so that pulldrag is at bottom
    CGRect mapRect;
    mapRect.size =  mapView.frame.size;
    mapRect.origin = CGPointMake(0, self.view.frame.size.height - mapDragPullYOffset);
    [mapView setFrame:mapRect];
    
    //add shaded view for start animation
    CGRect shadeRect = self.view.frame;
    [shadeView setFrame:shadeRect];
    [self.view addSubview:shadeView];
    
    
    //load most recent run on startup, but not intended any other time
    RunEvent * loadRun = [[RunEvent alloc] initWithNoTarget];
    loadRun.live = false;
    NSMutableArray * loadPos = [[NSMutableArray alloc] initWithCapacity:300];
    //begin run now with no other pause points
    [loadRun setPausePoints:[[NSMutableArray alloc] initWithObjects:[NSDate date]  , nil]];
    
    for(int i = 0; i < 300; i ++)
    {
        RunPos *posToAdd = [[RunPos alloc] init];
        
        posToAdd.pos =  CGPointMake(arc4random() % 100, arc4random() % 100);
        posToAdd.pace =  arc4random() % 100;//100 * ((CGFloat)i/100.0);
        posToAdd.elevation =  arc4random() % 100;
        posToAdd.time=  i;
        
        
        [loadPos addObject:posToAdd];
    }
    
    [loadRun setPos:loadPos];
    [loadRun setCheckpoints:loadPos];
    
    [self setRun:loadRun];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLabelsForUnits
{
    DataTest* data = [DataTest sharedData];
    NSString *distanceUnitText = [data.prefs getDistanceUnit];
    
    [paceUnitLabel1 setText:[NSString stringWithFormat:@"min/%@", distanceUnitText]];
    [paceUnitLabel2 setText:[NSString stringWithFormat:@"min/%@", distanceUnitText]];
    
    [distanceUnitLabel setText:distanceUnitText];
    
    if(!run.live)
    {
        //set title
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        [runTitle setText:[NSString stringWithFormat:@"%.1f %@ • %@", run.distance, distanceUnitText, [dateFormatter stringFromDate:run.date]]];
    }
    
    [self setLabelsForKMSelection:selectedBarIndex];
    
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



- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate
{
    //configure new run with that metric and value if their is one

    
    //load most recent run on startup, but not intended any other time
    RunEvent * loadRun = newRunTemplate;
    NSMutableArray * loadPos = [[NSMutableArray alloc] initWithCapacity:1000];
    //begin run now with no other pause points
    [loadRun setPausePoints:[[NSMutableArray alloc] initWithObjects:[NSDate date]  , nil]];
    
    for(int i = 0; i < 300; i ++)
    {
        RunPos *posToAdd = [[RunPos alloc] init];
        
        posToAdd.pos =  CGPointMake(arc4random() % 100, arc4random() % 100);
        posToAdd.pace =  arc4random() % 100;//100 * ((CGFloat)i/100.0);
        posToAdd.elevation =  arc4random() % 100;
        posToAdd.time=  i;
        
        
        [loadPos addObject:posToAdd];
    }
    
    [loadRun setPos:loadPos];
    [loadRun setCheckpoints:loadPos];
    
    [self setRun:loadRun];
    
    
    [shadeView setHidden:false];
    [countdownLabel setAlpha:1.0f];
    
    //previous notification in app delegate has already changed status to paused
    NSAssert(paused, @"not yet paused from appdelegate notification");


    [UIView animateWithDuration:1.0 animations:^{
        [countdownLabel setAlpha:0.7f];
     
    }
                     completion:^(BOOL finish){
                         
                         //swipe early
                         if(!paused)
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
                                                  if(!paused)
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
    
    //hide these by default unless newrun overrides them
    [finishBut setHidden:!run.live];
    
    //set title
    if(!run.live)
    {
        [statusBut setImage:[UIImage imageNamed:@"ghost.png"] forState:UIControlStateNormal];
        
        //title is set in setLabelsFOrunits
    }
    else
    {
        //hide red x if it is not a targeted run
        if(run.metric == NoMetricType)
        {
            [goalAchievedImage setHidden:true];
        }
        else
        {
            //if it is, set the image to be besides the label
            CGRect metricRect;
            CGRect imageRect = goalAchievedImage.frame;
            
            switch (run.metric) {
                case MetricTypePace:
                    metricRect = paceLabel.frame;
                    break;
                case MetricTypeTime:
                    metricRect = timeLabel.frame;
                    break;
                case MetricTypeCalories:
                    metricRect = caloriesLabel.frame;
                    break;
                case MetricTypeDistance:
                    metricRect = distanceLabel.frame;
                    break;
                    
                default:
                    break;
            }
            
            imageRect.origin = metricRect.origin;
            imageRect.origin.x += metricRect.size.width;
            imageRect.origin.y += metricRect.size.height/4;
            [goalAchievedImage setFrame:imageRect];
            [goalAchievedImage setHidden:false];
        }
        
        [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        [runTitle setText:run.name];
    }
    
    
    
    [self setLabelsForUnits];

    
    //set size of view of graph to be equal to that of the split load
    CGRect paceGraphRect = chart.frame;
    paceGraphRect.size = CGSizeMake(paceGraphSplitObjects * paceGraphBarWidth, paceScroll.frame.size.height);
    //set origin so that view is drawn for split filling up the last possible view
    paceGraphRect.origin = CGPointMake(([[run checkpoints] count] * paceGraphBarWidth) - paceGraphRect.size.width, 0.0);
    [chart setFrame:paceGraphRect];
    
    
    //draw bar graph with new data from run
    lastCacheMinute = [[run checkpoints] count] - paceGraphSplitObjects;
    CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(lastCacheMinute) length:CPTDecimalFromInt(paceGraphSplitObjects)];
    [self setupGraphForView:chart withRange:firstRangeToShow];
    
    
    //set scroll to be at the end of run
    [paceScroll setContentSize:CGSizeMake([[run checkpoints] count] * paceGraphBarWidth, paceScroll.frame.size.height)];
    [paceScroll setContentOffset:CGPointMake(([[run checkpoints] count] * paceGraphBarWidth) - paceScroll.frame.size.width, 0)];
    
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
        
        [UIView transitionWithView:statusBut
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
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
        //disable km selection mode
        kmPaceShowMode = false;
        selectedBarIndex = -1;
        [self setLabelsForKMSelection:selectedBarIndex];
        
        [UIView transitionWithView:pauseImage
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"record.png"];
                        } completion:NULL];
        
        
        [UIView transitionWithView:statusBut
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [statusBut setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
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


-(void)shouldUserGhostRun
{
    sheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to ghost race yourself?"
                                        delegate:self
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:@"Ghost Race"
                               otherButtonTitles:nil];
    
    // Show the sheet in view
    
    [sheet showInView:self.parentViewController.view];
}

#pragma mark -
#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    if(buttonIndex == 0)
    {
        //start ghost run

        //set as ghost run
        run.ghost = true;
        //do standard newRun except with this run object
        [delegate selectedGhostRun:run];
        
    }
    //coninute otherwise
}


#pragma mark - ScrollView Delegate



-(CGFloat)convertToX:(NSInteger) minute
{
    CGFloat x =  paceGraphBarWidth * minute;
    
    return x;
    
}


-(NSInteger)convertToCheckpointMinute:(CGFloat)x
{
    
    NSInteger min =  x / paceGraphBarWidth;
    
    return min;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    CGFloat curViewOffset = paceScroll.contentOffset.x;
    NSInteger curViewMinute = [self convertToCheckpointMinute:curViewOffset];
    
    NSDecimalNumber *startLocDecimal = [NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.location];
    NSInteger startLocationMinute = [startLocDecimal integerValue];
    CGFloat startLocation = [self convertToX:startLocationMinute];
    NSDecimalNumber *endLengthDecimal = [NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.length];
    NSInteger endLocationMinute = [startLocDecimal integerValue] + [endLengthDecimal integerValue];
    CGFloat endLocation = [self convertToX:endLocationMinute];
    
    
    NSLog(@"Scroll @ %.f , %d min with plot start = %f , %d min, end = %f , %d min", curViewOffset, curViewMinute, startLocation, startLocationMinute, endLocation, endLocationMinute);
    
    
    if(curViewMinute <= lastCacheMinute  && !(curViewMinute <= 0))
    {
    
        
        //reload to the left
        lastCacheMinute -= paceGraphSplitObjects - paceGraphSplitLoadOffset;
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(paceGraphSplitObjects)];
        
        plotSpace.xRange = newRange;
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [chart frame];
        newGraphViewRect.origin.x -= [self convertToX:paceGraphSplitObjects - paceGraphSplitLoadOffset];
        [chart setFrame:newGraphViewRect];
    }
    else if(curViewMinute > lastCacheMinute + paceGraphSplitObjects - paceGraphSplitLoadOffset &&
            !(curViewMinute + paceGraphSplitLoadOffset >= [[run checkpoints] count]))
    {
        //reload to right
        lastCacheMinute += paceGraphSplitObjects - paceGraphSplitLoadOffset;
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(paceGraphSplitObjects)];
        
        plotSpace.xRange = newRange;
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [chart frame];
        newGraphViewRect.origin.x += [self convertToX:paceGraphSplitObjects - paceGraphSplitLoadOffset];
        [chart setFrame:newGraphViewRect];
    }

    
    
}



#pragma mark - BarChart





-(void)setupGraphForView:(CPTGraphHostingView *)hostingView withRange:(CPTPlotRange *)range
{

    
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    hostingView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;
    
    // Paddings for view
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 0.0f;
    barChart.paddingBottom = 0.0f;
    
    //plot area
    barChart.plotAreaFrame.paddingLeft   = 0.0f;
    barChart.plotAreaFrame.paddingTop    = 0.0;//nothing
    barChart.plotAreaFrame.paddingRight  = 0.0f;
    barChart.plotAreaFrame.paddingBottom = 10.0f;
    
    //look modification
    barChart.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    barChart.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    
    
    // Add plot space for horizontal bar charts
    plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
    plotSpace.xRange = range;
    
    //[plotSpace setAllowsUserInteraction:true];
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    
    //axis line style
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineCap   = kCGLineCapRound;
    majorLineStyle.lineColor = [CPTColor colorWithGenericGray:CPTFloat(0.3)];
    majorLineStyle.lineWidth = CPTFloat(0.0);
    x.axisLineStyle                  = majorLineStyle;
    
    //y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
     
    // add bar plot to view, all bar customization done here
    CPTColor * barColour = [CPTColor colorWithComponentRed:0.8f green:0.1f blue:0.15f alpha:1.0f];
    barPlot = [CPTBarPlot tubularBarPlotWithColor:barColour horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"2");
    barPlot.dataSource = self;
    barPlot.identifier = kPlot;
    barPlot.barWidth                      = CPTDecimalFromDouble(0.7);
    barPlot.barWidthsAreInViewCoordinates = NO;
    barPlot.barCornerRadius               = CPTFloat(5.0);
    barPlot.barBaseCornerRadius             = CPTFloat(5.0);
    CPTGradient *fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor darkGrayColor] endingColor:[CPTColor darkGrayColor]];
    fillGradient.angle = 0.0f;
    barPlot.fill       = [CPTFill fillWithGradient:fillGradient];
    barPlot.delegate = self;
    
    
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    

    
    
    //selected Plot
    selectedPlot = [[CPTBarPlot alloc] init];
    selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.8f green:0.1f blue:0.15f alpha:1.0f]];
    CPTMutableLineStyle *selectedBorderLineStyle = [CPTMutableLineStyle lineStyle];
	selectedBorderLineStyle.lineWidth = CPTFloat(0.5);
    selectedPlot.lineStyle = selectedBorderLineStyle;
    selectedPlot.barWidth = CPTDecimalFromString(@"0.7");
    selectedPlot.barCornerRadius               = CPTFloat(5.0);
    selectedPlot.barBaseCornerRadius             = CPTFloat(5.0);
    selectedPlot.baseValue  = CPTDecimalFromString(@"2");
    
    selectedPlot.dataSource = self;
    selectedPlot.identifier = kSelectedPlot;
    selectedPlot.delegate = self;
    
    [barChart addPlot:selectedPlot toPlotSpace:plotSpace];
    
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
    
}

/*
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animation stopped");
    
}
 */


#pragma mark - KM Selection methods



-(void)setLabelsForKMSelection:(NSInteger) indexSelected
{
    
    DataTest* data = [DataTest sharedData];
    NSString *distanceUnitText = [data.prefs getDistanceUnit];
    
    //set the labels to be for the km if this method was called with an index
    if(indexSelected >= 0 )
    {
        RunPos * selectionCheckpoint = [[run checkpoints] objectAtIndex:indexSelected];
        
        
        //set the label to say 'KM 4' or 'Km 17'
        [lastKmLabel setText:[NSString stringWithFormat:@"%@ %.f ", distanceUnitText, selectionCheckpoint.pos.x]];
        
        //load fake values
        [lastKmPace setText:@"4:42"];
        [oldpace1 setText:@"4:12"];
        [oldpace2 setText:@"4:37"];
        [oldpace3 setText:@"4:44"];
    }
    else{
        
        [lastKmLabel setText:[NSString stringWithFormat:@"Current %@", distanceUnitText]];
        //load fake values
        [lastKmPace setText:@"4:42"];
        [oldpace1 setText:@"4:42"];
        [oldpace2 setText:@"4:11"];
        [oldpace3 setText:@"4:59"];
    }
    
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //return number of checkpoints for run to determine # of bars
    return [[run checkpoints] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    RunPos * paceForTime;
    NSInteger xCoord;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                //x location of index
                
                paceForTime = [[run checkpoints] objectAtIndex:index];
                
                xCoord = paceForTime.time;
                
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:xCoord];
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                if(!kmPaceShowMode)
                {
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedBarIndex))
                    {
                        paceForTime = [[run checkpoints] objectAtIndex:index];
                        num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:paceForTime.pace];
                    }
                }
                else{
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && (index >= selectedBarIndex && index <= (selectedBarIndex + numMinutesAtKmSelected))))
                    {
                        paceForTime = [[run checkpoints] objectAtIndex:index];
                        num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:paceForTime.pace];
                    }
                }
                break;
        }
    }
    
    return num;
}


#pragma mark - Bar Plot deleget methods

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    //set the select pace
    selectedBarIndex = idx;
    [self setLabelsForKMSelection:idx];
    
    kmPaceShowMode = false;
    
    [selectedPlot reloadData];
    
    
    //change "current pace" and value to respective value at checkpoint
    RunPos * posAtIndex = [[run checkpoints] objectAtIndex:idx];
    
    [currentPaceLabel setText:[NSString stringWithFormat:@"Minute %.2f",posAtIndex.time]];
    [currentPaceValue setText:[NSString stringWithFormat:@"%.2f",posAtIndex.pace]];
    
}


-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)plot recordIndex:(NSUInteger)index
{
    if ([plot.identifier isEqual: kPlot] && index == selectedBarIndex)
    {
        CPTFill *fillColor = [CPTFill fillWithColor:[CPTColor clearColor]];
        return fillColor;
    }
    return nil;
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

- (IBAction)invisibleButtonTapped:(id)sender {
    
    //if not already in the mode, just select current km/partial km and remove the label
    if(!kmPaceShowMode)
    {
        kmPaceShowMode = true;
        
        //start at last km
        selectedBarIndex = 285;
        numMinutesAtKmSelected = 15;
        
    }
    else{
        //already in this mode, cycle to next km
        selectedBarIndex -= 15;
        if(selectedBarIndex < 0)    //cycle to beginning if necessary
            selectedBarIndex = [[run checkpoints] count] - 15;
        
    }
    //reload labels/selection
    [selectedPlot reloadData];
    [self setLabelsForKMSelection:selectedBarIndex];
    
    //scroll to selected index
    CGRect rectToScroll = paceScroll.frame;
    rectToScroll.origin = CGPointMake(paceGraphBarWidth * selectedBarIndex, 0.0);
    [paceScroll scrollRectToVisible:rectToScroll animated:true];
}

- (IBAction)statusButTapped:(id)sender {
    
    //action depends on if the run is live
    if(run.live)
    {
        //animate the logger to opposite of paused/record state
        //asks the jsslider to animate the pause, includes the automatic pausing/record logic
        //meant to illustrate to user that you can swipe to pause
        [delegate pauseAnimation];
        
    }else{
        
        //ask user if they want to start a ghost run
        [self shouldUserGhostRun];
        
    }
}

- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
}
@end
