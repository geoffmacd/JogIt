//
//  ChartCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "ChartCell.h"
#import "AnimationUtil.h"

@implementation ChartCell

@synthesize folderImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize statView;
@synthesize headerView;
@synthesize currentLabel,currentValueLabel,previousLabel,previousValueLabel;
@synthesize delegate;
@synthesize selectedValueLabel,allTimeValueLabel;
@synthesize associated;
@synthesize expanded,loadedGraph;
@synthesize weekly;
@synthesize scrollView;
@synthesize selectedLabel,allTimeLabel;

-(void)setup
{
    
    UIColor *col = [UIColor blackColor];
    
    [headerView setBackgroundColor:col];
    
    loadedGraph = false;//load later
    
    [self setExpand:false withAnimation:false];
    
    //set title to match the metric
    [headerLabel setText:[RunEvent stringForMetric:associated]];
    
    
    [scrollView setDelegate:self];
    
    
    
    //localized buttons in IB
    [selectedLabel setText:NSLocalizedString(@"PerformanceSelectedLabel", @"label for selected performance")];
    [allTimeLabel setText:NSLocalizedString(@"PerformanceAllTimeLabel", @"label for all time performance")];
    
    
    //init array
    weeklyValues = [[NSMutableArray alloc] initWithCapacity:100];
    weeklyXValues = [[NSMutableArray alloc] initWithCapacity:100];
    monthlyValues = [[NSMutableArray alloc] initWithCapacity:100];
    monthlyXValues = [[NSMutableArray alloc] initWithCapacity:100];
    
    //fake data
    for(int i = 0; i < 100; i ++)
    {
        NSNumber * value = [NSNumber numberWithFloat:arc4random() % 100];
        NSNumber * xValue = [NSNumber numberWithInt:i];
        
        
        [weeklyXValues addObject:xValue];
        [monthlyXValues addObject:xValue];
        [weeklyValues addObject:value];
        [monthlyValues addObject:value];
    }
    
}

-(void)setTimePeriod:(BOOL) toWeekly
{
    weekly = toWeekly;
    
    
    //set weekly labels, with localization
    if(toWeekly)
    {
        [previousLabel setText:NSLocalizedString(@"PerformancePreviousWeek", @"previous week in performance")];
        [currentLabel setText:NSLocalizedString(@"PerformanceCurrentWeek", @"current week in performance")];
    }
    else
    {
        [previousLabel setText:NSLocalizedString(@"PerformancePreviousMonth", @"previous month in performance")];
        [currentLabel setText:NSLocalizedString(@"PerformanceCurrentMonth", @"current month in performance")];
    }
    
    //reload data
}

- (IBAction)expandTapped:(id)sender {
}

- (IBAction)headerTapped:(id)sender {
    
    [self setExpand:!expanded withAnimation:true];
}


-(void) setAssociated:(RunMetric) chart
{
    associated = chart;
    
    
    [self setup];
}



-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    
    expanded = open;
    
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:scrollView toOpen:true];
            [AnimationUtil cellLayerAnimate:statView toOpen:true];
            
        }
        
        
        if(!loadedGraph)
        {
            
            
            //set size of view of graph to be equal to that of the split load
            CGRect graphRect = expandedView.frame;
            graphRect.size = CGSizeMake(performanceSplitObjects * performanceBarWidth, scrollView.frame.size.height);
            //set origin so that view is drawn for split filling up the last possible view
            if(weekly)
                graphRect.origin = CGPointMake(([weeklyValues count] * performanceBarWidth) - graphRect.size.width, 0.0);
            else
                graphRect.origin = CGPointMake(([monthlyValues count] * performanceBarWidth) - graphRect.size.width, 0.0);
            [expandedView setFrame:graphRect];
            
            
            //draw bar graph with new data from run
            if(weekly)
                lastCacheMinute = [weeklyValues count] - performanceSplitObjects;
            else
                lastCacheMinute = [monthlyValues count] - performanceSplitObjects;
            CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(lastCacheMinute) length:CPTDecimalFromInt(performanceSplitObjects)];
            [self setupGraphForView:expandedView withRange:firstRangeToShow];
            
            
            //set scroll to be at the end of run
            [scrollView setContentSize:CGSizeMake([weeklyValues count] * performanceBarWidth, scrollView.frame.size.height)];
            [scrollView setContentOffset:CGPointMake(([weeklyValues count]  * performanceBarWidth) - scrollView.frame.size.width, 0)];
            
        }
        
        
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:scrollView toOpen:false];
            [AnimationUtil cellLayerAnimate:statView toOpen:false];
            
        }
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:0];
    }
    
    if(!animate)
    {
       // [expandedView setHidden:!open];
    }
    
    
    [delegate cellDidChangeHeight:self];
    
    
}



-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + scrollView.frame.size.height;
    }
    
}

#pragma mark - BarChart

-(void)setupGraphForView:(CPTGraphHostingView *)hostingView withRange:(CPTPlotRange *)range
{
    
    
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    expandedView.hostedGraph = barChart;
    
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
    barChart.plotAreaFrame.paddingTop    = 15.0;//for selected labels
    barChart.plotAreaFrame.paddingRight  = 0.0f;
    barChart.plotAreaFrame.paddingBottom = 10.0f;
    
    //look modification
    barChart.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    barChart.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    
    // Add plot space for horizontal bar charts
    plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
    plotSpace.xRange = range;
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.majorIntervalLength = CPTDecimalFromString(@"12");
    x.minorTicksPerInterval = 1;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.title = @"Months";
    x.timeOffset = 0.0f;
 	NSArray *exclusionRanges = [NSArray arrayWithObjects:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)], nil];
	x.labelExclusionRanges = exclusionRanges;
    CPTMutableTextStyle *yLabelTextStyle = [CPTMutableTextStyle textStyle];
    yLabelTextStyle.color = [CPTColor whiteColor];
    yLabelTextStyle.fontSize = 14;
    yLabelTextStyle.fontName = @"Ingleby";
    x.labelTextStyle = yLabelTextStyle;
    
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:[weeklyValues count]/12];
    int idx = 0;
    
    for (NSNumber * valueToLabel  in weeklyValues)
    {
        if(idx % 12 == 0)
        {
            NSString * tempLabel;
            
            switch(idx/12)
            {
                case 1:
                    tempLabel = @"Mar";
                    break;
                case 2:
                    tempLabel = @"Jun";
                    break;
                case 3:
                    tempLabel = @"Sept";
                    break;
                case 4:
                    tempLabel = @"Dec";
                    idx -= 52;
                    break;
                    
                    
            }
            
            
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:tempLabel textStyle:x.labelTextStyle];
            label.tickLocation = CPTDecimalFromInt(idx);
            label.offset = 5.0f;
            [labels addObject:label];
        }
        idx ++;
    }
    x.axisLabels = [NSSet setWithArray:labels];
    
    
    
    //axis line style
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineCap   = kCGLineCapRound;
    majorLineStyle.lineColor = [CPTColor colorWithGenericGray:CPTFloat(0.15)];
    majorLineStyle.lineWidth = CPTFloat(1.0);
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
    
    
    loadedGraph = true;
    
    
}

#pragma mark -
#pragma mark Plot Data Source Methods


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //return number of checkpoints for run to determine # of bars
    if(weekly)
        return [weeklyValues count];
    else
        return [monthlyValues count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    NSNumber * numberValue;
    NSInteger xCoord;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                //x location of index
                
                if(weekly)
                    numberValue = [weeklyXValues objectAtIndex:index];
                else
                    numberValue = [monthlyXValues objectAtIndex:index];
                
                num = numberValue;
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedBarIndex))
                    {
                        if(weekly)
                            numberValue = [weeklyValues objectAtIndex:index];
                        else
                            numberValue = [monthlyValues objectAtIndex:index];
                        
                        num = numberValue;
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
    
    
    [selectedPlot reloadData];
    
    
    //change selected values
    NSNumber* valueToDisplay;
    
    if(weekly)
        valueToDisplay = [weeklyValues objectAtIndex:idx];
    else
        valueToDisplay = [monthlyValues objectAtIndex:idx];
    
    [selectedValueLabel setText:[NSString stringWithFormat:@"Minute %.2f",[valueToDisplay floatValue]]];
    
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



#pragma mark - ScrollView Delegate



-(CGFloat)convertToX:(NSInteger) minute
{
    CGFloat x =  performanceBarWidth * minute;
    
    return x;
    
}


-(NSInteger)convertToCheckpointMinute:(CGFloat)x
{
    
    NSInteger min =  x / performanceBarWidth;
    
    return min;
}

- (void)scrollViewDidScroll:(UIScrollView *)tempScrollView
{
    
    
    CGFloat curViewOffset = tempScrollView.contentOffset.x;
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
        lastCacheMinute -= performanceSplitObjects - performanceLoadObjectsOffset;
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(performanceSplitObjects)];
        
        plotSpace.xRange = newRange;
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [expandedView frame];
        newGraphViewRect.origin.x -= [self convertToX:performanceSplitObjects - performanceLoadObjectsOffset];
        [expandedView setFrame:newGraphViewRect];
    }
    else if(curViewMinute > lastCacheMinute + performanceSplitObjects - performanceLoadObjectsOffset &&
            !(curViewMinute + performanceLoadObjectsOffset >= [weeklyValues count]))
    {
        //reload to right
        lastCacheMinute += performanceSplitObjects - performanceLoadObjectsOffset;
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(performanceSplitObjects)];
        
        plotSpace.xRange = newRange;
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [expandedView frame];
        newGraphViewRect.origin.x += [self convertToX:performanceSplitObjects - performanceLoadObjectsOffset];
        [expandedView setFrame:newGraphViewRect];
    }
    
    
    
}


@end
