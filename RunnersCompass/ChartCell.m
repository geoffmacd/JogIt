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
@synthesize weeklyValues,monthlyValues;
@synthesize raceCell;
@synthesize prefs,unitLabel;

#pragma mark - Lifecycle

-(void)setup
{
    [scrollView setDelegate:self];
    
    loadedGraph = false;
    //[self loadChart];
    
    [self setExpand:false withAnimation:false];
    
    //set title to match the metric
    //[headerLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:16.0f]];
    if(!raceCell)
    {
        switch (associated) {
                
            case MetricTypeDistance:
                [unitLabel setHidden:false];
                [unitLabel setText:[prefs getDistanceUnit]];
                [headerLabel setText:[RunEvent stringForMetric:associated showSpeed:[[prefs showSpeed] boolValue]]];
                break;
            case MetricTypePace:
                [unitLabel setHidden:false];
                [unitLabel setText:[prefs getPaceUnit]];
                [headerLabel setText:[RunEvent stringForMetric:associated showSpeed:[[prefs showSpeed] boolValue]]];
                break;
            case MetricTypeDescended:
            case MetricTypeClimbed:
                [unitLabel setHidden:false];
                [unitLabel setText:[prefs getElevationUnit]];
                [headerLabel setText:[RunEvent stringForMetric:associated showSpeed:[[prefs showSpeed] boolValue]]];
                break;
                
            case MetricTypeActivityCount:
            case MetricTypeCadence:
            case MetricTypeCalories:
            case MetricTypeStride:
            case MetricTypeSteps:
            case MetricTypeTime:
                [headerLabel setText:[RunEvent stringForMetric:associated showSpeed:[[prefs showSpeed] boolValue]]];
                break;
            default:
                break;
        }
    }
    else
    {
        [headerLabel setText:[RunEvent stringForRace:associated]];
    }
    
    //localized buttons in IB
    [selectedLabel setText:NSLocalizedString(@"PerformanceSelectedLabel", @"label for selected performance")];
    [allTimeLabel setText:NSLocalizedString(@"PerformanceAllTimeLabel", @"label for all time performance")];
    
    //fonts
    [previousLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [currentLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [currentValueLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [previousValueLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [allTimeValueLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [selectedValueLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [allTimeLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [selectedLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [unitLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    [headerLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:14.0f]];
}

-(void)setTimePeriod:(BOOL) toWeekly
{
    //do nothing if the same
    if(toWeekly == weekly)
        return;
    
    weekly = toWeekly;
    
    NSTimeInterval highest= 0.0;
    NSTimeInterval lowest= [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval allTime = 0.0;
    NSInteger recordCount = 0;
    NSNumber* current;
    NSNumber* previous;
    
    //set weekly labels, with localization
    if(toWeekly)
    {
        [previousLabel setText:NSLocalizedString(@"PerformancePreviousWeek", @"previous week in performance")];
        [currentLabel setText:NSLocalizedString(@"PerformanceCurrentWeek", @"current week in performance")];
        
        //set all time high and selected
        for(NSNumber * num in weeklyValues)
        {
            //mostly for pace
            if([num doubleValue] > 0)
            {
                allTime += [num doubleValue];
                recordCount++;
            }
            
            if([num doubleValue] > highest)
                highest = [num doubleValue];
            
            if([num doubleValue] < lowest)
                lowest = [num doubleValue];
        }
        
        //set value for previous,current
        if([weeklyValues count] > 0)
            current = [weeklyValues objectAtIndex:0];
        else
            previous = [NSNumber numberWithDouble:0.0];
        if([weeklyValues count] > 1)
            previous = [weeklyValues objectAtIndex:1];
        else
            previous = [NSNumber numberWithDouble:0.0];
    }
    else
    {
        [previousLabel setText:NSLocalizedString(@"PerformancePreviousMonth", @"previous month in performance")];
        [currentLabel setText:NSLocalizedString(@"PerformanceCurrentMonth", @"current month in performance")];
        
        //set all time high and selected
        for(NSNumber * num in monthlyValues)
        {
            //mostly for pace
            if([num doubleValue] > 0)
            {
                allTime += [num doubleValue];
                recordCount++;
            }
            
            if([num doubleValue] > highest)
                highest = [num doubleValue];
            if([num doubleValue] < lowest)
                lowest = [num doubleValue];
        }
        
        //set value for previous,current
        if([monthlyValues count] > 0)
            current = [monthlyValues objectAtIndex:0];
        else
            previous = [NSNumber numberWithDouble:0.0];
        if([monthlyValues count] > 1)
            previous = [monthlyValues objectAtIndex:1];
        else
            previous = [NSNumber numberWithDouble:0.0];
    }
    
    //always average paces for races
    if(raceCell)
    {
        if(recordCount > 0)
            allTime = allTime / recordCount;
        
        [currentValueLabel setText:[RunEvent getTimeString:[current integerValue]]];
        [previousValueLabel setText:[RunEvent getTimeString:[previous integerValue]]];
        [allTimeValueLabel setText:[RunEvent getTimeString:allTime]];
    }
    else{
        //calc alltime avg pace if associated is pace
        if(associated == MetricTypePace && recordCount > 0)
            allTime = allTime / recordCount;
        
        switch(associated)
        {
            case MetricTypeDistance:
                [currentValueLabel setText:[NSString stringWithFormat:@"%.1f", [RunEvent getDisplayDistance:[current floatValue] withMetric:[[prefs metric] boolValue]]]];
                [previousValueLabel setText:[NSString stringWithFormat:@"%.1f", [RunEvent getDisplayDistance:[previous floatValue] withMetric:[[prefs metric] boolValue]]]];
                [allTimeValueLabel setText:[NSString stringWithFormat:@"%.1f", [RunEvent getDisplayDistance:allTime withMetric:[[prefs metric] boolValue]]]];
                break;
            case MetricTypePace:
                [currentValueLabel setText:[RunEvent getPaceString:[current doubleValue] withMetric:[[prefs metric] boolValue] showSpeed:[[prefs showSpeed] boolValue]]];
                [previousValueLabel setText:[RunEvent getPaceString:[previous doubleValue] withMetric:[[prefs metric] boolValue] showSpeed:[[prefs showSpeed] boolValue]]];
                [allTimeValueLabel setText:[RunEvent getPaceString:allTime withMetric:[[prefs metric] boolValue] showSpeed:[[prefs showSpeed] boolValue]]];
                break;
            case MetricTypeTime:
                [currentValueLabel setText:[RunEvent getTimeString:[current integerValue]]];
                [previousValueLabel setText:[RunEvent getTimeString:[previous integerValue]]];
                [allTimeValueLabel setText:[RunEvent getTimeString:allTime]];
                break;
            case MetricTypeCalories:
                [currentValueLabel setText:[NSString stringWithFormat:@"%.0f", [current floatValue]]];
                [previousValueLabel setText:[NSString stringWithFormat:@"%.0f", [previous floatValue]]];
                [allTimeValueLabel setText:[NSString stringWithFormat:@"%.0f", allTime]];
                break;
            case MetricTypeClimbed:
                if([[prefs metric] boolValue])
                {
                    [currentValueLabel setText:[NSString stringWithFormat:@"%.0f", [current floatValue]]];
                    [previousValueLabel setText:[NSString stringWithFormat:@"%.0f", [previous floatValue]]];
                    [allTimeValueLabel setText:[NSString stringWithFormat:@"%.0f", allTime]];
                }
                else
                {
                    [currentValueLabel setText:[NSString stringWithFormat:@"%.0f", [current floatValue]*convertMToFt]];
                    [previousValueLabel setText:[NSString stringWithFormat:@"%.0f", [previous floatValue]*convertMToFt]];
                    [allTimeValueLabel setText:[NSString stringWithFormat:@"%.0f", allTime*convertMToFt]];
                }
                break;
                
            default:
                break;
        }
    }
    
    //deter chart y range
    minY = 0;
    maxY = highest;
    
    //reload data if already loaded and shown
    if(loadedGraph)
    {
        loadedGraph = false;
        
        [barChart removePlot:barPlot];
        [barChart removePlot:selectedPlot];
        
        selectedPlot = nil;
        barPlot = nil;
        
        //reset scroll to prevent wrong position initially shown for modified weekly
        [scrollView setContentSize:CGSizeMake(0, 0)];
        
        if(expanded)
        {
            [self loadChart];
            //select nearest date which is on far right
            [self barPlot:nil barWasSelectedAtRecordIndex:0];
        }
    }
}

- (IBAction)expandTapped:(id)sender {
}

- (IBAction)headerTapped:(id)sender {
    
    [self setExpand:!expanded withAnimation:true];
}

-(void) setAssociated:(RunMetric) metricToAssociate
{
    associated = metricToAssociate;
    
    
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
            [self loadChart];
            //select nearest date which is on far right
            [self barPlot:nil barWasSelectedAtRecordIndex:0];
        }
        else
        {
            //scroll to end location?
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
        [scrollView setHidden:!open];
        [statView setHidden:!open];
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

-(void)loadChart
{
    NSInteger numBars = (weekly ? [weeklyValues count] : [monthlyValues count]);
    //reset added weeks in case of week/month change
    addedWeeksAfterReal = 0;
    
    //determine how many bars is deficient to make full screen
    if(weekly)
    {
        //adjust by adding 0 numbers until full screen
        while(performanceBarWidth * ([weeklyValues count]+addedWeeksAfterReal+1) < scrollView.frame.size.width)
        {
            addedWeeksAfterReal++;
        }
    }
    else
    {
        //adjust by adding 0 numbers until full screen
        while(performanceBarWidth * ([monthlyValues count]+addedWeeksAfterReal+1) < scrollView.frame.size.width)
        {
            addedWeeksAfterReal++;
        }
    }
    
    if(!barPlot)
    {
        //draw bar for current cache
        lastCacheMinute = numBars - performanceSplitObjects ;
        if(lastCacheMinute < 0)
            lastCacheMinute = 0;
        CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(lastCacheMinute) length:CPTDecimalFromInt(performanceSplitObjects)];
        [self setupGraphForView:expandedView withRange:firstRangeToShow];
    }
    
    
    //scroll to latest value
    if(addedWeeksAfterReal > 0)
    {
        //there is some 0 values here so scroll to 0
        [scrollView setContentSize:CGSizeMake((numBars + addedWeeksAfterReal) * performanceBarWidth, scrollView.frame.size.height)];
        CGRect animatedDestination = CGRectMake(0, 0, self.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:animatedDestination animated:true];
    }
    else{
        
        //rightmost value is non-zero and real
        [scrollView setContentSize:CGSizeMake((numBars * performanceBarWidth), scrollView.frame.size.height)];\
        //scroll to numbars which is at far right and back off one screen length
        CGRect animatedDestination = CGRectMake((numBars * performanceBarWidth) - scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:animatedDestination animated:true];
    }
    
    loadedGraph = true;
    
}


-(void)setupGraphForView:(CPTGraphHostingView *)hostingView withRange:(CPTPlotRange *)range
{
    NSInteger numBars = (weekly ? [weeklyValues count] : [monthlyValues count]);
    
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
    barChart.plotAreaFrame.paddingTop    = 25.0;//for selected labels
    barChart.plotAreaFrame.paddingRight  = 0.0f;
    barChart.plotAreaFrame.paddingBottom = 20.0f;
    barChart.plotAreaFrame.masksToBorder = NO;
    
    //look modification
    barChart.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    barChart.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    // Add plot space for horizontal bar charts
    plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minY) length:CPTDecimalFromFloat(maxY)];
    plotSpace.xRange = range;
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    
    //axis line style
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineCap   = kCGLineCapRound;
    majorLineStyle.lineColor = [CPTColor colorWithGenericGray:CPTFloat(0.6)];
    majorLineStyle.lineWidth = CPTFloat(1.0);
    x.axisLineStyle                  = majorLineStyle;
    
    //y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    
    //labels for x-axis
    CPTMutableTextStyle * dateLabelTextStyle = [CPTMutableTextStyle textStyle];
    dateLabelTextStyle.color = [CPTColor lightGrayColor];
    dateLabelTextStyle.fontSize = 12;
    x.labelTextStyle = dateLabelTextStyle;
    //analysis results gauranteed to be as of today
    NSDate * today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:today];
    
    //code to generate labels for months
    if(weekly)
    {
        NSInteger startWeek = components.week;
        NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:15];
        int dateIndex = 0;
        int idx = startWeek;
        //for each week ,if multiple of 13 , add label representing nearest month
        for (int i = 0; i < numBars + addedWeeksAfterReal; i++)
        {
            if(idx ==0)
                idx = 52;
            
            if(idx % 4 == 0)
            {
                NSString * tempLabel;
                
                switch(idx/4)
                {
                    case 1:
                        tempLabel = NSLocalizedString(@"JanMonth", "month string");
                        break;
                    case 2:
                        tempLabel = NSLocalizedString(@"FebMonth", "month string");
                        break;
                    case 3:
                        tempLabel = NSLocalizedString(@"MarMonth", "month string");
                        break;
                    case 4:
                        tempLabel = NSLocalizedString(@"AprilMonth", "month string");
                        break;
                    case 5:
                        tempLabel = NSLocalizedString(@"MayMonth", "month string");
                        break;
                    case 6:
                        tempLabel = NSLocalizedString(@"JunMonth", "month string");
                        break;
                    case 7:
                        tempLabel = NSLocalizedString(@"JulyMonth", "month string");
                        break;
                    case 8:
                        tempLabel = NSLocalizedString(@"AugMonth", "month string");
                        break;
                    case 9:
                        tempLabel = NSLocalizedString(@"SeptMonth", "month string");
                        break;
                    case 10:
                        tempLabel = NSLocalizedString(@"OctMonth", "month string");
                        break;
                    case 11:
                        tempLabel = NSLocalizedString(@"NovMonth", "month string");
                        break;
                    case 12:
                        tempLabel = NSLocalizedString(@"DecMonth", "month string");
                        break;
                }
                if(tempLabel)
                {
                    CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:tempLabel textStyle:dateLabelTextStyle];
                    label.tickLocation = CPTDecimalFromInt( numBars + addedWeeksAfterReal -dateIndex);
                    label.offset = 5.0f;
                    [labels addObject:label];
                }
            }
            //decrement week
            idx--;
            //increase index
            dateIndex++;
        }
        x.axisLabels = [NSSet setWithArray:labels];
    }
    else
    {
        //code to generate labels for years
        
        NSInteger startMonth = components.month;
        NSInteger startYear = components.year;
        NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:15];
        int dateIndex = 0;
        int idx = startMonth;
        for (int i = 0; i < numBars + addedWeeksAfterReal; i++)
        {
            if(idx ==0)
            {
                //decrement year even if startmonth is 4 so 2013 is missed
                idx = 11;
                startYear -= 1;
            }
            
            if(idx % 6 == 0)
            {
                NSString * tempLabel;
                
                tempLabel = [NSString stringWithFormat:@"%d", startYear];
                
                if(tempLabel)
                {
                    CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:tempLabel textStyle:dateLabelTextStyle];
                    label.tickLocation = CPTDecimalFromInt(numBars + addedWeeksAfterReal -dateIndex);
                    label.offset = 5.0f;
                    [labels addObject:label];
                }
            }
            idx--;
            dateIndex++;
        }
        x.axisLabels = [NSSet setWithArray:labels];
    }
    
    
    // add bar plot to view, all bar customization done here
    CPTColor * barColour = [CPTColor darkGrayColor];
    barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill = [CPTFill fillWithColor:barColour];
    CPTMutableLineStyle *barLineStyle = [CPTMutableLineStyle lineStyle];
	barLineStyle.lineWidth = CPTFloat(0.5);
    barPlot.lineStyle = barLineStyle;
    barPlot.barWidth   = CPTDecimalFromDouble(0.7);
    barPlot.barWidthsAreInViewCoordinates = NO;
    barPlot.barCornerRadius  = CPTFloat(5.0);
    //barPlot.barBaseCornerRadius = CPTFloat(5.0);
    barPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    barPlot.dataSource = self;
    barPlot.identifier = kPlot;
    barPlot.delegate = self;
    
    
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    //selected Plot
    selectedPlot = [[CPTBarPlot alloc] init];
    selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
    selectedPlot.lineStyle = barLineStyle;
    selectedPlot.barWidth   = CPTDecimalFromDouble(0.7);
    selectedPlot.barWidthsAreInViewCoordinates = NO;
    selectedPlot.barCornerRadius = CPTFloat(5.0);
    //selectedPlot.barBaseCornerRadius = CPTFloat(5.0);
    selectedPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    selectedPlot.dataSource = self;
    selectedPlot.identifier = kSelectedPlot;
    selectedPlot.delegate = self;
    
    [barChart addPlot:selectedPlot toPlotSpace:plotSpace];
    
    //set size of view of graph to be equal to that of the split load
    CGRect graphRect = expandedView.frame;
    graphRect.origin = CGPointMake(0, 0);
    graphRect.size = CGSizeMake(performanceSplitObjects * performanceBarWidth, expandedView.frame.size.height);
    [expandedView setFrame:graphRect];
    
    
    loadedGraph = true;
}

#pragma mark -
#pragma mark Plot Data Source Methods


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //return number of checkpoints for run to determine # of bars
    
    NSInteger numBars = (weekly ? [weeklyValues count] : [monthlyValues count]);
    
    return numBars;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber * numberValue;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                
                //x location of index is opposite side of chart such that weeklyValue[0] is latest run located at right
                if(weekly)
                    numberValue = [NSNumber numberWithDouble:([weeklyValues count] + addedWeeksAfterReal - index - 0.5)];
                else
                    numberValue = [NSNumber numberWithDouble:([monthlyValues count] + addedWeeksAfterReal - index - 0.5)];
                
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedBarIndex))
                {
                    if(weekly && [weeklyValues count] > index)
                        numberValue = [weeklyValues objectAtIndex:index];
                    else if([monthlyValues count] > index)
                        numberValue = [monthlyValues objectAtIndex:index];
                    else
                        numberValue = [NSNumber numberWithDouble:0.0];
                }
                break;
        }
    }
    
    return numberValue;
}

#pragma mark - Bar Plot deleget methods

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)idx
{
    //set the select pace
    selectedBarIndex = idx;
    
    [selectedPlot reloadData];
    
    //change selected values
    NSNumber* valueToDisplay;
    
    if(weekly && [weeklyValues count] > idx)
        valueToDisplay = [weeklyValues objectAtIndex:idx];
    else if([monthlyValues count] > idx)
        valueToDisplay = [monthlyValues objectAtIndex:idx];
    else
        valueToDisplay = [NSNumber numberWithDouble:0.0];
        
    
    if(raceCell)
    {
        [selectedValueLabel setText:[RunEvent getTimeString:[valueToDisplay doubleValue]]];
    }
    else{
        switch(associated)
        {
            case MetricTypeDistance:
                [selectedValueLabel setText:[NSString stringWithFormat:@"%.1f",[RunEvent getDisplayDistance:[valueToDisplay floatValue] withMetric:[[prefs metric] boolValue]]]];
                break;
            case MetricTypePace:
                [selectedValueLabel setText:[RunEvent getPaceString:[valueToDisplay doubleValue] withMetric:[[prefs metric] boolValue] showSpeed:[[prefs showSpeed] boolValue]]];
                break;
            case MetricTypeTime:
                [selectedValueLabel setText:[RunEvent getTimeString:[valueToDisplay doubleValue]]];
                break;
            case MetricTypeCalories:
                [selectedValueLabel setText:[NSString stringWithFormat:@"%.0f",[valueToDisplay floatValue]]];
                break;
            case MetricTypeClimbed:
                if([[prefs metric] boolValue])
                    [selectedValueLabel setText:[NSString stringWithFormat:@"%.0f",[valueToDisplay floatValue]]];
                else
                    [selectedValueLabel setText:[NSString stringWithFormat:@"%.0f",[valueToDisplay floatValue]*convertMToFt]];
                break;
            default:
                break;
        }
    }
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
    NSInteger numBars = (weekly ? [weeklyValues count] : [monthlyValues count]);
    
    CGFloat curViewOffset = tempScrollView.contentOffset.x;
    NSInteger curViewMinute = [self convertToCheckpointMinute:curViewOffset];
    
    NSDecimalNumber *startLocDecimal = [NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.location];
    NSInteger startLocationMinute = [startLocDecimal integerValue];
    CGFloat startLocation = [self convertToX:startLocationMinute];
    NSDecimalNumber *endLengthDecimal = [NSDecimalNumber decimalNumberWithDecimal:plotSpace.xRange.length];
    NSInteger endLocationMinute = [startLocDecimal integerValue] + [endLengthDecimal integerValue];
    CGFloat endLocation = [self convertToX:endLocationMinute];
    
    
    //NSLog(@"Scroll @ %.f , %d min with plot start = %f , %d min, end = %f , %d min", curViewOffset, curViewMinute, startLocation, startLocationMinute, endLocation, endLocationMinute);

    
    if(curViewMinute < lastCacheMinute)
    {
        //reload to the left
        lastCacheMinute = curViewMinute - (performanceSplitObjects - performanceLoadObjectsOffset);
        //constrain to zero
        if(lastCacheMinute < 0)
            lastCacheMinute = 0;
        
        //NSLog(@"Reload to left @ %d", lastCacheMinute);
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(performanceSplitObjects)];
        
        plotSpace.xRange = newRange;
        [barPlot reloadData];
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [expandedView frame];
        newGraphViewRect.origin.x = [self convertToX:lastCacheMinute];
        [expandedView setFrame:newGraphViewRect];
    }
    else if(curViewMinute > lastCacheMinute + performanceSplitObjects - performanceLoadObjectsOffset &&
            !(curViewMinute + performanceSplitObjects - performanceLoadObjectsOffset >= numBars))
    {
        //reload to right
        lastCacheMinute = curViewMinute;
        //constrain to length of chart
        if(lastCacheMinute >= numBars - (performanceSplitObjects - performanceLoadObjectsOffset))
            lastCacheMinute = numBars - (performanceSplitObjects - performanceLoadObjectsOffset);
        
        //NSLog(@"Reload to right @ %d", lastCacheMinute);
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(performanceSplitObjects)];
        
        plotSpace.xRange = newRange;
        [barPlot reloadData];
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [expandedView frame];
        newGraphViewRect.origin.x = [self convertToX:lastCacheMinute];
        [expandedView setFrame:newGraphViewRect];
    }
    
}


@end
