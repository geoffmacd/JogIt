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

-(void)setup
{
    
    UIColor *col = [UIColor blackColor];
    
    [headerView setBackgroundColor:col];
    
    UIColor *col3 = [UIColor colorWithRed:145.0f/255 green:153.0f/255 blue:161.0f/255 alpha:1.0f];
    
    [expandedView setBackgroundColor:col3];
    
    loadedGraph = false;//load later
    
    [self setExpand:false withAnimation:false];
    
    //set title to match the metric
    [headerLabel setText:[RunEvent stringForMetric:associated]];
    
    
    [scrollView setDelegate:self];
    
    
    
    
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
    
    //set weekly labels
    if(toWeekly)
    {
        [previousLabel setText:@"Previous Week"];
        [currentLabel setText:@"Current Week"];
    }
    else
    {
        [previousLabel setText:@"Previous Month"];
        [currentLabel setText:@"Current Month"];
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
        [expandedView setHidden:!open];
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
    CPTGradient *fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor lightGrayColor] endingColor:[CPTColor lightGrayColor]];
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
    RunPos * paceForTime;
    NSInteger xCoord;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                //x location of index
                
                if(weekly)
                    paceForTime = [weeklyXValues objectAtIndex:index];
                else
                    paceForTime = [monthlyXValues objectAtIndex:index];
                
                xCoord = paceForTime.time;
                
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:xCoord];
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedBarIndex))
                    {
                        if(weekly)
                            paceForTime = [weeklyValues objectAtIndex:index];
                        else
                            paceForTime = [monthlyValues objectAtIndex:index];
                        
                        num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:paceForTime.pace];
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
