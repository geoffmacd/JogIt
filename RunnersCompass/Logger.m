//
//  CompassSecondViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "Logger.h"
#import <objc/objc-api.h>


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
@synthesize ghostBut;
@synthesize timeTitle,distanceTitle,caloriesTitle,avgPaceTitle;
@synthesize swipeToPauseLabel;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    
    
    [mapButton.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mapButton.layer setBorderWidth: 1.0];
    [mapButton.layer setCornerRadius: 5.0];
    [mapButton.layer setMasksToBounds:YES];
    
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
    
    //localization
    [timeTitle setText:NSLocalizedString(@"TimeTitle", "Logger title for time")];
    [avgPaceTitle setText:NSLocalizedString(@"PaceTitle", "Logger title for pace")];
    [caloriesTitle setText:NSLocalizedString(@"CaloriesTitle", "Logger title for calories")];
    [distanceTitle setText:NSLocalizedString(@"DistanceTitle", "Logger title for distance")];
    [finishBut setTitle:NSLocalizedString(@"FinishButton", "Logger finish button title") forState:UIControlStateNormal];
    [lastKmLabel setText:NSLocalizedString(@"LastKMTitle", "Logger title for last km")];
    [currentPaceLabel setText:NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace")];
    [swipeToPauseLabel setText:NSLocalizedString(@"SwipeToPauseLabel", "Label for swipe to pause shaded view")];
    
    
    //init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //locationManager.activityType = CLActivityTypeFitness;//causes location not to respond if not moving
    //[locationManager startUpdatingLocation];
    
    //init paths
    crumbPaths = [[NSMutableArray alloc] initWithCapacity:100];
    crumbPathViews = [[NSMutableArray alloc] initWithCapacity:100];
    readyForPathInit = true;
    
    
    [map setShowsUserLocation:YES];
    [map setDelegate:self];
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
    
    [paceUnitLabel1 setText:[NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"MinutesShortForm", @"Shortform for min"), distanceUnitText]];
    [paceUnitLabel2 setText:[NSString stringWithFormat:@"%@/%@", NSLocalizedString(@"MinutesShortForm", @"Shortform for min"), distanceUnitText]];
    
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
    
    [self setPaceLabels];
    
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

#pragma mark - Managing runs


- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate
{
    //configure new run with that metric and value if their is one

    
    //load most recent run on startup, but not intended any other time
    RunEvent * loadRun = newRunTemplate;
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
                             [self startRun];
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
                                                      [self startRun];
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
                                                                           [delegate pauseAnimation:^{
                                                                               //[self startRun];
                                                                           }];
                                                                           
                                                                           
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
    [finishBut setHidden:true];
    
    //set title
    if(!run.live)
    {
        //display ghost and share
        [statusBut setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [ghostBut setHidden:false];
        
        //hide goal image
        [goalAchievedImage setHidden:true];
    }
    else
    {
        //hide red x if it is not a targeted run
        if(run.metric == NoMetricType)
        {
            //hide goal image
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
        
        //hide ghost
        [ghostBut setHidden:true];
        
        //set map to follow user before starting track
        [map setUserTrackingMode:MKUserTrackingModeFollow];
    }
    
    [self drawMapOverlayForRun];
    [self setLabelsForUnits];
    
    [self updateHUD];
    
    if(barPlot)
    {
        [barChart removePlot:barPlot];
        [barChart removePlot:selectedPlot];
        
        selectedPlot = nil;
        barPlot = nil;
    }
    
    [self updateChart];
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
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 1.0f;
                        } completion:^(BOOL finish){
                            
                            //stop location updates
                            [self stopRun];
                        }];
        
        
        
    }
    else
    {
        
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
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 0.0f;
                        } completion:^(BOOL finish){
                            [finishBut setHidden:true];
                            //start run
                            [self startRun];

                            
                        }];
        
        
    }
    
    
}


-(void)shouldUserGhostRun
{
    sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"GhostRun", @"Question for starting ghost run")//@"Do you want to ghost race yourself?"
                                        delegate:self
                               cancelButtonTitle:NSLocalizedString(@"CancelWord", @"cancel word")
                          destructiveButtonTitle:NSLocalizedString(@"GhostRunStart", @"word for starting ghost run")
                               otherButtonTitles:nil];
    
    
    // Show the sheet in view
    
    [sheet showInView:self.parentViewController.view];
}



#pragma mark - Managing Live run

-(void)startRun
{
    //stop map following user
    [map setUserTrackingMode:MKUserTrackingModeNone];
    
    //start updates
    NSLog(@"started tracking.....");
    [locationManager startUpdatingLocation];
    
    
    //set timer up
    if(![timer isValid])
    {
        
        //schedule on run loop to increase priority
        timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    readyForPathInit = true; //to restart path at the current users location
    lastCalculate = [NSDate timeIntervalSinceReferenceDate];
    
    //disable km selection mode
    kmPaceShowMode = false;
    numMinutesAtKmSelected = -1;
    selectedMinIndex = [[run minCheckpointsMeta] count];
    selectedKmIndex = [[run kmCheckpointsMeta] count];
    [self setPaceLabels];
    
}


-(void) stopRun
{
    //stop timer updating
    [timer invalidate];
    
    
    //stop updates
    NSLog(@"stopped tracking.....");
    [locationManager stopUpdatingLocation];
    
    //only zoom if there exists a last point
    if([run.pos lastObject])
    {
        [self autoZoomMap:[run.pos lastObject]];
        
    }
    
    //update map icon one last time
    [self reloadMapIcon];
    
}


-(void)tick
{
    //process 1 second gone by in timer
    
    //update time with 1 second
    run.time += 1;
    
    //update hud if multiple of 60, therefore one minute
    if(!((int)run.time % barPeriod))
    {
        //add one checkpoint representing past 60 seconds
        
        [self updateChart];
    }
    
    if(selectedKmIndex == [[run kmCheckpointsMeta] count] )
    {
        //need current time update to lastKMLabel
        
        
        DataTest* data = [DataTest sharedData];
        NSString *distanceUnitText = [data.prefs getDistanceUnit];
        NSTimeInterval timeToAdjust = 0;
        
        if([[run kmCheckpointsMeta] count] > selectedKmIndex - 1)
        {
            CLLocationMeta * priorKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex - 1];
            //get distance from km just by looking at index
            timeToAdjust = priorKmMeta.time;
        }
        
        //show current time in the current km
        NSString * paceForCurrentIndex = [RunEvent getPaceString:(run.time - timeToAdjust)];
        [lastKmPace setText:paceForCurrentIndex];
    }
    
    //update time displayed
    NSString * stringToSetTime = [RunEvent getTimeString:run.time];
    [timeLabel setText:stringToSetTime];
    
    
    
}


-(void)calculate:(CLLocation*)latest
{
    //process last 4 locations to determine all metrics: distance, avgpace, climbed, calories, stride, cadence
    
    NSInteger countOfLoc = [run.pos count] ;

    
    if(latest.horizontalAccuracy <= logRequiredAccuracy  && countOfLoc >= 1)
    {

        
        CLLocation *prior = [run.pos lastObject];
        NSTimeInterval paceTimeInterval = latest.timestamp.timeIntervalSinceReferenceDate - prior.timestamp.timeIntervalSinceReferenceDate;

        CLLocationDistance distanceToAdd = [self calcDistance:latest];
        CLLocationDistance oldRunDistance = run.distance;
        run.distance += distanceToAdd;
        
        //add calories @ 0.08 cal per minute per lb
        run.calories += (paceTimeInterval / 60) * 0.08  * [[[[DataTest sharedData] prefs] weight] integerValue];
        
        run.avgPace =  run.time / run.distance;
        
        NSLog(@"%f distance added", distanceToAdd);
        
        //set current pace
        CLLocationDistance paceDistance = distanceToAdd;
        CLLocationSpeed currentPace = paceTimeInterval / paceDistance;//s/m
        NSTimeInterval adjustedPace = (currentPace * 1000); //s / km
        
    
        [self addPosToRun:latest withPace:adjustedPace];

        //decrement bad signal count
        if(badSignalCount > 0 )
            badSignalCount--;
        
        //check if a new km was created
        if((NSInteger)(oldRunDistance/1000) != (NSInteger)(run.distance/1000))
        {
            //add to object
            CLLocationMeta * newKM = [[CLLocationMeta alloc] init];
            CLLocationMeta * lastPosMeta = [[run posMeta] lastObject] ;
            newKM.time = [lastPosMeta time]; //set time to most recent
            newKM.pace = 0;
            CLLocationMeta * pos;
            CLLocationMeta * oldKM = [[run kmCheckpointsMeta] lastObject];
            
            //aggregrate past position until we get to the time of the last km or start
            NSInteger numPosCounted = 0;
            
            for(int i = [[run posMeta] count] - 1; i >= 0; i--)
            {
                //get posMeta and see if time is less than last km's time
                pos = [[run posMeta] objectAtIndex:i];
                
                if([[run kmCheckpointsMeta] count] > 0)
                {
                    if(pos.time <= [oldKM time])
                    {
                        //all positions have been accounted for
                        break;
                    }
                }
                
                if(pos.time <= 0)
                {
                    newKM.pace += pos.pace;
                    numPosCounted++;
                    break;
                }
                
                
                newKM.pace += pos.pace;
                numPosCounted++;
            }
            
            //breaked at last km end position
            //aggregrate pace
            newKM.pace =  newKM.pace / (numPosCounted);
            
            //add to array
            [[run kmCheckpointsMeta] addObject:newKM];
            [[run kmCheckpoints] addObject:latest];
            
        }
        
        
    }
    else{
        /*
        if(countOfLoc < 1)
            [self addPosToRun:latest withPace:0];
         */
        
        //incremenet bad signal count and wait for better signal
        NSLog(@"bad signal - cant process");
        badSignalCount++;
    }
    
    kmPaceShowMode = false;
    selectedMinIndex = [[run minCheckpointsMeta] count] ;
    selectedKmIndex = [[run kmCheckpointsMeta] count];
    [self setPaceLabels];
    
    
    //update hud too after distance
    [self updateHUD];
}

-(void)addPosToRun:(CLLocation*)locToAdd withPace:(NSTimeInterval)paceToAdd
{
    CLLocationMeta * metaToAdd = [[CLLocationMeta alloc] init];
    
    metaToAdd.pace = paceToAdd;
    metaToAdd.time = run.time;
    
    //add both 
    [run.posMeta addObject:metaToAdd];
    [run.pos addObject:locToAdd];
    
}

-(void)updateHUD
{
    //set text for labels
    
    //set distance in km
    [distanceLabel setText:[NSString stringWithFormat:@"%.2f", (run.distance/1000)]];

    
    //update time displayed
    NSString * stringToSetTime = [RunEvent getTimeString:run.time];
    [timeLabel setText:stringToSetTime];
    
    [caloriesLabel setText:[NSString stringWithFormat:@"%.0f", run.calories]];
}

-(CLLocationDistance)calcDistance:(CLLocation *)latest 
{
    
    CLLocation * prior = [run.pos lastObject];
    NSInteger locCount = [run.pos count];
    CLLocationDistance distanceToAdd = 0.0;
    
    if(consecutiveHeadingCount)
    {
     
        CLLocationDirection cumulativeCourseDifferential = 0;
        
        for(int i = 1; i <= consecutiveHeadingCount; i++)
        {
            //invalidate consequtive run only if cumulative error is too large or course differential is too big
            CLLocation * considerPt = [run.pos objectAtIndex:(locCount - i)];
            
            if(!NSLocationInRange(fabs(considerPt.course - latest.course), NSMakeRange(-20, 40)))
            {
                //invalid
                consecutiveHeadingCount = 0;
                break;
            }
            
            cumulativeCourseDifferential += fabs(considerPt.course - latest.course);
            
            if(cumulativeCourseDifferential > 50)
            {
                consecutiveHeadingCount = 0;
                break;
            }
            
        }
        
        
        //calc distance if still availabe
        distanceToAdd = [latest distanceFromLocation:[run.pos objectAtIndex:(locCount - consecutiveHeadingCount - 1)]] - [prior distanceFromLocation:[run.pos objectAtIndex:(locCount - consecutiveHeadingCount - 1)]];
        
        //incremenet if it did not fail on prior
        if(consecutiveHeadingCount != 0)
            consecutiveHeadingCount++;
        
    }
    else{
        
        //check to see if consequtive should start
        if(NSLocationInRange(fabs(prior.course - latest.course), NSMakeRange(-20, 40)))
        {
            consecutiveHeadingCount++;
        }
        
        distanceToAdd = [latest distanceFromLocation:prior];
    }
    
    NSLog(@"Consequtive %d", consecutiveHeadingCount);
    
    return distanceToAdd;
}


#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //last should the last object in run.pos
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation = [run.pos lastObject];
    
    NSLog(@"%d  - lat%f - lon%f  - accur %f , %f  -speed %f", [run.pos count], newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy, newLocation.verticalAccuracy , newLocation.speed);

    
    //add anotation to map
    //if (newLocation.timestamp > oldLocation.timestamp)
    //{
		
		// make sure the old and new coordinates are different
        if ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) &&
            (oldLocation.coordinate.longitude != newLocation.coordinate.longitude))
        {
            if (readyForPathInit)
            {
                // This is the first time we're getting a location update, so create
                // the CrumbPath and add it to the map.
                //
                CrumbPath * newPath = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
                [self.map addOverlay:newPath];
                [crumbPaths addObject:newPath];
                
                // On the first location update only, zoom map to user location
                MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, mapZoomDefault, mapZoomDefault);
                [self.map setRegion:region animated:YES];
                timeSinceMapCenter = [NSDate timeIntervalSinceReferenceDate];
                
                //set initial map icon
                UIImage * newMapIcon = [Util imageWithView:map];
                
                [mapButton setImage:newMapIcon forState:UIControlStateNormal];
                timeSinceMapIconRefresh = timeSinceMapCenter;
                
                //add an inital position
                [self addPosToRun:newLocation withPace:0];
                
                readyForPathInit = false;
                
            }
            else
            {
                // This is a subsequent location update.
                // If the crumbs MKOverlay model object determines that the current location has moved
                // far enough from the previous location, use the returned updateRect to redraw just
                // the changed area.

                //
                MKMapRect updateRect = [[crumbPaths lastObject] addCoordinate:newLocation.coordinate];
                
                if (!MKMapRectIsNull(updateRect))
                {
                    // There is a non null update rect.
                    // Compute the currently visible map zoom scale
                    MKZoomScale currentZoomScale = (CGFloat)(map.bounds.size.width / map.visibleMapRect.size.width);
                    // Find out the line width at this zoom scale and outset the updateRect by that amount
                    CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                    updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                    // Ask the overlay view to update just the changed area.
                    [[crumbPathViews lastObject] setNeedsDisplayInMapRect:updateRect];
                }
                
                [self calculate:newLocation];
                //update metrics every 1 seconds
                /*
                 if(lastCalculate < ([NSDate timeIntervalSinceReferenceDate] - calcPeriod))
                 {
                 [self calculate:newLocation];
                 
                 lastCalculate = [NSDate timeIntervalSinceReferenceDate];
                 }
                 */
                
                //reload map icon every 30 seconds, must happen before animation to prevent image being captured during meaningless position
                if(timeSinceMapIconRefresh < ([NSDate timeIntervalSinceReferenceDate] - reloadMapIconPeriod))
                {
                    [self reloadMapIcon];
                    
                }
                
                //zoom every 5 seconds, or 30 seconds inMapView
                //also do not auto zoom if user has recently scrolled
                if((timeSinceMapCenter < ([NSDate timeIntervalSinceReferenceDate] - autoZoomPeriod)) && (lastMapTouch < ([NSDate timeIntervalSinceReferenceDate] - userDelaysAutoZoom)))
                {
                    [self autoZoomMap:newLocation];

                }
            
            }
        }
    //}
}


#pragma mark - Map Custom Functions

-(void) reloadMapIcon
{
    
    timeSinceMapIconRefresh = [NSDate timeIntervalSinceReferenceDate];
    
    UIImage * newMapIcon = [Util imageWithView:map];
    
    //blur
    //newMapIcon = [newMapIcon imageWithGaussianBlur9];
    
    [mapButton setImage:newMapIcon forState:UIControlStateNormal];
}


-(void) autoZoomMap:(CLLocation*)newLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, mapZoomDefault, mapZoomDefault);
    //animated to prevent jumpy
    [self.map setRegion:region animated:(inMapView ? YES : NO)];
    
    timeSinceMapCenter = [NSDate timeIntervalSinceReferenceDate];
    
}

-(void)drawMapOverlayForRun
{
    
    //reset live variables,caches,etc
    [map removeOverlays:crumbPaths];
    [crumbPathViews removeAllObjects];
    [crumbPaths removeAllObjects];
    
    readyForPathInit = true;
    
    //redraw crumb paths for positions
    
    for(CLLocation * loc in run.pos)
    {
        if (readyForPathInit)
        {
            // This is the first time we're getting a location update, so create
            // the CrumbPath and add it to the map.
            //
            CrumbPath * newPath = [[CrumbPath alloc] initWithCenterCoordinate:loc.coordinate];
            [map addOverlay:newPath];
            [crumbPaths addObject:newPath];
            
            timeSinceMapCenter = [NSDate timeIntervalSinceReferenceDate];
            
            readyForPathInit = false;
            
        }
        else
        {
            //path already created
            MKMapRect updateRect = [[crumbPaths lastObject] addCoordinate:loc.coordinate];
            
            if (!MKMapRectIsNull(updateRect))
            {
                // There is a non null update rect.
                // Compute the currently visible map zoom scale
                MKZoomScale currentZoomScale = (CGFloat)(map.bounds.size.width / map.visibleMapRect.size.width);
                // Find out the line width at this zoom scale and outset the updateRect by that amount
                CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
                updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
                // Ask the overlay view to update just the changed area.
                [[crumbPathViews lastObject] setNeedsDisplayInMapRect:updateRect];
            }
        }
    }
    
    
    //zoom map to user location, no animation
    CLLocation * lastPos = [run.pos lastObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lastPos.coordinate, mapZoomDefault, mapZoomDefault);
    [map setRegion:region animated:NO];
    
    
    //set initial map icon
    UIImage * newMapIcon = [Util imageWithView:map];
    [mapButton setImage:newMapIcon forState:UIControlStateNormal];
    
    
}

#pragma mark - MapKit Delegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([crumbPaths lastObject])
    {
        CrumbPathView* crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
        [crumbPathViews addObject:crumbView];
    }
    return [crumbPathViews lastObject];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    //check for network errors, throw up popup?
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if([NSDate timeIntervalSinceReferenceDate] < timeSinceMapCenter + 0.5)
    {
        //scrolling was caused programmatically do nothing
    }
    else{
        //user scrolled
        //set time to lastMapTouch
        
        lastMapTouch = [NSDate timeIntervalSinceReferenceDate];
    }
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
            !(curViewMinute + paceGraphSplitLoadOffset >= [[run minCheckpoints] count]))
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

-(CGFloat)maxYForChart
{
    CGFloat maxYPace = 0.0f;
    
    //find max
    for(CLLocationMeta * meta in run.minCheckpointsMeta)
    {
        if(meta.pace == 0)
            continue;
        
        CGFloat tempValue = 100.0f/meta.pace;
        if(tempValue > maxYPace)
        {
            maxYPace = tempValue;
        }
        
    }
    
    //constraint pace to at least 1 m/s
    if(maxYPace < 1.0f)
        maxYPace = 1.0f;
    
    
    return maxYPace + 0.1f; //add small amount to not cutoff top
    
}

-(void)updateChart
{
    //add meta data for recent minute, or create chart
    
    
    if(barPlot)
    {
        //aggregrate last minute, starting at most recent
        NSInteger index = [run.posMeta count] - 1;
        NSInteger sumCount = 0;
        NSInteger currentTime = run.time;
        CLLocationMeta * lastMeta;
        NSTimeInterval paceSum = 0;
        
        if(index >= 0)
        {
            do {
                
                lastMeta = [run.posMeta objectAtIndex:index];
                //aggregate pace
                paceSum += [lastMeta pace];
                sumCount++;
                
                index--;
                
                //until we have reached 60 seconds ago
            } while ((currentTime - barPeriod) < [lastMeta time] && index > 0);
            
            if(index == 0)
                sumCount--;

            NSTimeInterval avgPaceInMin = paceSum / sumCount;
            
            CLLocationMeta * newMinMeta = [[CLLocationMeta alloc] init];
            newMinMeta.pace = avgPaceInMin;
            newMinMeta.time = currentTime;
            
            //add meta and loc to array
            [run.minCheckpointsMeta addObject:newMinMeta];
            [run.minCheckpoints addObject:[run.pos lastObject]];
        }
    }
    
    lastCacheMinute = [[run minCheckpointsMeta] count] - paceGraphSplitObjects;
    
    //set size of view of graph to be equal to that of the split load if not already
    CGRect paceGraphRect = chart.frame;
    paceGraphRect.size = CGSizeMake(paceGraphSplitObjects * paceGraphBarWidth, paceScroll.frame.size.height);
    if(lastCacheMinute < 0)
    {
        paceGraphRect.origin = CGPointMake(0, 0);
    }
    else    //set origin so that view is drawn for split filling up the last possible view
    {
        paceGraphRect.origin = CGPointMake((lastCacheMinute * paceGraphBarWidth), 0.0);
    }
    [chart setFrame:paceGraphRect];
    
    
    if(!barPlot)
    {
        //if bar graph not yet loaded
        
        //draw bar graph with new data from run
        CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt((lastCacheMinute < 0 ? 0 : lastCacheMinute)) length:CPTDecimalFromInt(paceGraphSplitObjects)];
        [self setupGraphForView:chart withRange:firstRangeToShow];
        
        
    }
    else{
        //if loaded, just update ranges
        
        //set x range and y range for new graph config
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat((lastCacheMinute < 0 ? 0 : lastCacheMinute)) length:CPTDecimalFromFloat(paceGraphSplitObjects)];
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
        
        
        [barPlot reloadData];
    }
    
    //scroll to latest value
    if([[run minCheckpointsMeta] count] * paceGraphBarWidth < paceScroll.frame.size.width)
    {
        //set scroll to be at start of empty run
        [paceScroll setContentSize:CGSizeMake(paceScroll.frame.size.width, paceScroll.frame.size.height)];
        [paceScroll setContentOffset:CGPointMake(0, 0)];
    }
    else{
        
        //set scroll to be at the end of run
        [paceScroll setContentSize:CGSizeMake([[run minCheckpointsMeta] count] * paceGraphBarWidth, paceScroll.frame.size.height)];
        [paceScroll setContentOffset:CGPointMake(([[run minCheckpointsMeta] count] * paceGraphBarWidth) - paceScroll.frame.size.width, 0)];
    }
    
    
    
}


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
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
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
    barPlot.baseValue  = CPTDecimalFromString(@"0");
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
    selectedPlot.baseValue  = CPTDecimalFromString(@"0");
    
    selectedPlot.dataSource = self;
    selectedPlot.identifier = kSelectedPlot;
    selectedPlot.delegate = self;
    
    [barChart addPlot:selectedPlot toPlotSpace:plotSpace];
    
}


#pragma mark - KM Selection methods

-(NSInteger) getMinBarIndexForKMSelecton:(NSInteger) kmIndex
{
    if([[run kmCheckpointsMeta] count] > kmIndex - 1 && (kmIndex-1 >= 0))
    {
        CLLocationMeta * previousKM = [[run kmCheckpointsMeta] objectAtIndex:kmIndex-1];
        NSTimeInterval kmStartTime = [previousKM time];
        
        //get all minutes within these bounds
        NSTimeInterval time;
        NSInteger minIndex = 0;
        
        for (CLLocationMeta * min in [run minCheckpointsMeta])
        {
            time = [min time];
            
            if(time > kmStartTime)
                return minIndex;
            
            minIndex++;
        }
        
        return  [[run minCheckpointsMeta] count] - 1;
    }
    
    return 0;
}


-(NSInteger) getBarCountForKMSelection:(NSInteger) kmIndex
{
    
    if([[run kmCheckpointsMeta] count] > kmIndex)
    {
        CLLocationMeta * selectedKM = [[run kmCheckpointsMeta] objectAtIndex:kmIndex];
        NSTimeInterval kmEndTime = [selectedKM time];
        NSTimeInterval kmStartTime;
        if([[run kmCheckpointsMeta] count] > 0 && kmIndex-1 >= 0)
        {
            CLLocationMeta * previousKM = [[run kmCheckpointsMeta] objectAtIndex:kmIndex-1];
            kmStartTime = [previousKM time];
        }
        else
        {
            kmStartTime = 0;
        }
        
        //get all minutes within these bounds
        NSTimeInterval time;
        NSInteger numBars = 0;
        
        for (CLLocationMeta * min in [run minCheckpointsMeta])
        {
            time = [min time];
            
            if(time > kmStartTime && time < kmEndTime)
                numBars++;
            
        }
        
        return  numBars;
    }
    else{
        //next km doesnt exist to get end time
        NSTimeInterval kmStartTime;
        if([[run kmCheckpointsMeta] count]  > 0 && kmIndex-1 >= 0)
        {
            CLLocationMeta * previousKM = [[run kmCheckpointsMeta] objectAtIndex:kmIndex-1];
            kmStartTime = [previousKM time];
        }
        else
        {
            kmStartTime = 0;
        }
        
        //get all minutes within these bounds
        NSTimeInterval time;
        NSInteger numBars = 0;
        
        for (CLLocationMeta * min in [run minCheckpointsMeta])
        {
            time = [min time];
            
            if(time > kmStartTime)
                numBars++;
            
        }
        
        return  numBars;
    }
    
    return [[run minCheckpointsMeta] count];
}



-(void)setPaceLabels
{
    //responible for two bottom sections
    
    DataTest* data = [DataTest sharedData];
    NSString *distanceUnitText = [data.prefs getDistanceUnit];
    
    //avg pace
    NSString * stringToSetTime = [RunEvent getPaceString:(run.avgPace * 1000)];
    [paceLabel setText:stringToSetTime];
    
    
    //current pace/selected pace
    CLLocationMeta * selectedMinMeta;
    NSString * selectedPaceLabel;
    NSString * selectedPaceString;
    if([[run minCheckpointsMeta] count] == 0)
    {
        // nothing logged yet, just put 0:00
        selectedMinMeta = [[run minCheckpointsMeta] lastObject];
        selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = @"0:00";
    }
    else if(selectedMinIndex == [[run minCheckpointsMeta] count])
    {
        // current pace
        selectedMinMeta = [[run posMeta] lastObject];
        selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = [RunEvent getPaceString:selectedMinMeta.pace];
    }
    else if(kmPaceShowMode){
        
        //km paceshow mode so still say current pace
        selectedMinMeta = [[run posMeta] lastObject];
        selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = [RunEvent getPaceString:selectedMinMeta.pace];
    }
    else{
        
        //selection mode of one bar
        selectedMinMeta = [[run posMeta] lastObject];
        selectedPaceLabel = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"MinuteWord", "minute word for pace minute selection"), (NSInteger)(selectedMinMeta.time/60)];
        selectedPaceString = [RunEvent getPaceString:selectedMinMeta.pace];
    }
    [currentPaceLabel setText:selectedPaceLabel];
    [currentPaceValue setText:selectedPaceString];
    

    
    
    if([[run kmCheckpointsMeta] count] == 0)
    {
        //no km's so far, just set lastKm to be time
        
        //set the label to say 'KM 4' or 'Km 17'
        [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, 1]];
        
        //load current
        [lastKmPace setText:[RunEvent getPaceString:run.time]];
        
        //set old to be empty
        NSString * paceForOld = @"";
        [oldpace1 setText:paceForOld];
        [oldpace2 setText:paceForOld];
        [oldpace3 setText:paceForOld];
    }
    else if(selectedKmIndex == [[run kmCheckpointsMeta] count])
    {
        //show current km in lastKmLabel

        CLLocationMeta * priorKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
        CLLocationMeta * oldKMMeta;
        //get distance from km just by looking at index
        
        //set the label to say 'KM 4' or 'Km 17'
        [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, selectedKmIndex + 1]];
        
        //show current time in the current km
        NSString * paceForCurrentIndex = [RunEvent getPaceString:(run.time - priorKmMeta.time)];
        //[lastKmPace setText:paceForCurrentIndex];
        
        //load old values
        NSString * paceForOld;
        if(selectedKmIndex - 1  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace1 setText:paceForOld];
        if(selectedKmIndex - 2  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace2 setText:paceForOld];
        if(selectedKmIndex - 3  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace3 setText:paceForOld];
    }
    else{
        //showing only prior kms, since selection is not the last one
        
        CLLocationMeta * selectionKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex];
        CLLocationMeta * oldKMMeta;
        //get distance from km just by looking at index
        
        //set the label to say 'KM 4' or 'Km 17'
        [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d ", distanceUnitText, selectedKmIndex + 1]];
        
        //load current
        NSString * paceForCurrentIndex = [RunEvent getPaceString:[selectionKmMeta pace]];
        [lastKmPace setText:paceForCurrentIndex];
        
        //load old values
        NSString * paceForOld;
        if(selectedKmIndex - 1  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace1 setText:paceForOld];
        if(selectedKmIndex - 2  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace2 setText:paceForOld];
        if(selectedKmIndex - 3  >= 0)
        {
            oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
            paceForOld = [RunEvent getPaceString:[oldKMMeta pace]];
        }
        else
            paceForOld = @"";
        [oldpace3 setText:paceForOld];
    }
    
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    //return number of checkpoints for run to determine # of bars
    //return the full width of the chart view to ensure bars are not autoshrunk
    return ([[run minCheckpointsMeta] count] < paceGraphSplitObjects) ? paceGraphSplitObjects : [[run minCheckpointsMeta] count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    CLLocationMeta * metaForPos;
    
    if(index + 1 > [[run minCheckpointsMeta] count])
    {
        return [NSNumber numberWithInt:0];
    }
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                //x location of index
                
                metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                
                //divide time by 60 seconds to get minute index, then minus half a minute to center bar plots
                num = [NSNumber  numberWithInt:((metaForPos.time)/barPeriod)];
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                if(!kmPaceShowMode)
                {
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedMinIndex))
                    {
                        metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                        //must invert number
                        if(metaForPos.pace == 0)
                            num = [NSNumber numberWithFloat:0.1f];
                        else
                            num = [NSNumber numberWithFloat:100.0f/metaForPos.pace];//converted to m/s
                    }
                }
                else{
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && (index >= selectedMinIndex && index <= (selectedMinIndex + numMinutesAtKmSelected))))
                    {
                        metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                        //must invert number
                        if(metaForPos.pace == 0)
                            num = [NSNumber numberWithFloat:0.1f];
                        else
                            num = [NSNumber numberWithFloat:100.0f/metaForPos.pace];//converted to m/s
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
    //set the  minute
    
    kmPaceShowMode = false;
    numMinutesAtKmSelected = 1;
    selectedMinIndex = idx;
    selectedKmIndex = [[run kmCheckpointsMeta] count];
    
    //set all pace labels for this minute
    [self setPaceLabels];
    [selectedPlot reloadData];
    
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
        //reload icon to refresh
        if(run.live && !paused)
            [self reloadMapIcon];
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
        //autozoom
        if(run.live && !paused)
            [self autoZoomMap:[run.pos lastObject]];
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
    
    //set the run to have the correct picture in table cell
    run.map.thumbnail = [mapButton imageForState:UIControlStateNormal];
    
    //go back to menu and add to table at top
    [delegate finishedRun:run];
    
    
    //convert current run to a historical run now that it is saved!
    run.live = false;
    [self setRun:run];
    
    
}

- (IBAction)invisibleButtonTapped:(id)sender {
    
    //if not already in the mode, just select current km/partial km and remove the label
    if(!kmPaceShowMode)
    {
        kmPaceShowMode = true;
        
        //start at last km
        selectedKmIndex = [[run kmCheckpointsMeta] count];
    }
    else{
        //already in this mode, cycle to next km
        selectedKmIndex --;
        if(selectedKmIndex < 0)    //cycle to beginning if necessary
            selectedKmIndex = [[run kmCheckpointsMeta] count];
        
    }
    
    //reload labels/selection
    selectedMinIndex = [self getMinBarIndexForKMSelecton:selectedKmIndex];
    numMinutesAtKmSelected = [self getBarCountForKMSelection:selectedKmIndex];
    [self setPaceLabels];
    [selectedPlot reloadData];
    
    //scroll to selected index
    CGRect rectToScroll = paceScroll.frame;
    rectToScroll.origin = CGPointMake(paceGraphBarWidth * selectedMinIndex, 0.0);
    [paceScroll scrollRectToVisible:rectToScroll animated:true];
    
}

- (IBAction)statusButTapped:(id)sender {
    
    //action depends on if the run is live
    if(run.live)
    {
        //animate the logger to opposite of paused/record state
        //asks the jsslider to animate the pause, includes the automatic pausing/record logic
        //meant to illustrate to user that you can swipe to pause
        [delegate pauseAnimation:nil];
        
    }else{
        
        //share the run
        NSArray *activityItems;
        
        
        //log text message
        NSString * messageToSend = NSLocalizedString(@"LoggerShareMsg", "message to be sent with sharing");
        
        //capture screenshot without modification
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            //Retina display
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        } else {
            UIGraphicsBeginImageContext(self.view.bounds.size);
        }
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (finalImage) 
            activityItems = @[messageToSend,finalImage];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityController animated:YES completion:nil];
        
        
        
    }
}

- (IBAction)ghostButTapped:(id)sender {
    
        //only if it is historical
        if(!run.live)
        {
            
            //ask user if they want to start a ghost run
            [self shouldUserGhostRun];
            
        }
}

- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
}
@end
