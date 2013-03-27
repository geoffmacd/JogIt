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
@synthesize mapButton,hamburgerBut;
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
@synthesize lowSignalImage;

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    [finishBut.layer setMasksToBounds:true];
    
    
    [mapButton.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [mapButton.layer setBorderWidth: 1.0];
    [mapButton.layer setCornerRadius: 5.0];
    [mapButton.layer setMasksToBounds:YES];
    
    //setup low signal gif but dont start
    lowSignalImage.animationImages = [[NSArray alloc] initWithObjects:
                                           [UIImage imageNamed:@"lowsignal.png"],
                                           [UIImage imageNamed:@"lowsignal1.png"],
                                           [UIImage imageNamed:@"lowsignal2.png"],
                                           [UIImage imageNamed:@"lowsignal3.png"],
                                           nil];
    lowSignalImage.animationRepeatCount = 0;
    lowSignalImage.animationDuration = 2;
    
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
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //locationManager.activityType = CLActivityTypeFitness;//causes location not to respond if not moving
    //[locationManager startUpdatingLocation];
    
    //init paths
    crumbPaths = [[NSMutableArray alloc] initWithCapacity:100];
    crumbPathViews = [[NSMutableArray alloc] initWithCapacity:100];
    readyForPathInit = true;
    
    //map annotations
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    
    //pos queue
    posQueue = [[NSMutableArray alloc] initWithCapacity:10];
    
    //set map hidden until user goes into logger during setRun to lower loading 
    [map setHidden:true];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Loading runs


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
                                                                           [delegate pauseAnimation:nil];
                                                                           
                                                                           
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
    //hide goal image, until we decide to display it
    [goalAchievedImage setHidden:true];
    
    //set title
    if(!run.live)
    {
        //display ghost and share
        [statusBut setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [ghostBut setHidden:false];
        
    }
    else
    {
        //hide red x if it is not a targeted run
        if(run.metric != NoMetricType)
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
                case MetricTypeStride:
                case MetricTypeClimbed:
                case MetricTypeCadence:
                default:
                    break;
            }
            
            imageRect.origin = metricRect.origin;
            imageRect.origin.x += metricRect.size.width;
            imageRect.origin.y += metricRect.size.height/6;
            [goalAchievedImage setFrame:imageRect];
            
        }
        
        [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        //hide ghost
        [ghostBut setHidden:true];
    }
    
    [self drawMapForHistoricRun];
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
    
    //load map 
    [map setHidden:false];
    [map setShowsUserLocation:true];
    [map setDelegate:self];

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


#pragma mark - Managing Live Run

-(void)startRun
{
    //stop map following user
    [map setUserTrackingMode:MKUserTrackingModeNone];
    
    //start updates
    NSLog(@"started tracking.....");
    [locationManager startUpdatingLocation];
    
    //set timer up to run once a second
    if(![timer isValid])
    {
        
        //schedule on run loop to increase priority
        timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    //to restart path at the current users location
    readyForPathInit = true;
    
    //disable km selection mode
    kmPaceShowMode = false;
    numMinutesAtKmSelected = -1;
    selectedMinIndex = [[run minCheckpointsMeta] count];
    selectedKmIndex = [[run kmCheckpointsMeta] count];
    [self setPaceLabels];
    
    //reset autopause variables
    pausedForAuto = false;
    timeSinceUnpause = [NSDate timeIntervalSinceReferenceDate];
    
    //tells to process first pos directly without calcing pace
    needsStartPos = true;
    
}


-(void) stopRun
{
    //if autopause caused this, do not stop location updates
    if(!pausedForAuto)
    {
        //stop updates otherwise for battery life etc
        NSLog(@"stopped tracking.....");
        [locationManager stopUpdatingLocation];
    }
    
    //set map to follow user before starting track
    [map setUserTrackingMode:MKUserTrackingModeFollow];
    
    //stop timer updating
    [timer invalidate];
    
    //update map icon one last time
    [self reloadMapIcon:!inMapView];
    
    //only zoom if there exists a last point
    if([run.pos lastObject])
    {
        [self autoZoomMap:[run.pos lastObject]];
    }
    
}

-(void)evalAccuracy:(CLLocationAccuracy)accuracyToAccumulate
{
    
    accuracyCount++;
    avgAccuracy += accuracyToAccumulate;
    //evaluate if more than 5
    if(accuracyCount  > 5)
    {
        if(avgAccuracy > 5 * accuracyCount)
        {
            //display
            [lowSignalImage startAnimating];
            [lowSignalImage setHidden:false];
        }
        else{
            //hide
            [lowSignalImage setHidden:true];
            [lowSignalImage stopAnimating];
        }
        
        //reset
        accuracyCount = 0;
        avgAccuracy = 0;
    }
    
}


-(void)evalAutopause:(CLLocationSpeed)speedToConsider
{
    if(pausedForAuto && speedToConsider > minSpeedUnpause)
    {
        //get closer to unpausing
        autoPauseRestartCount++;
        
        if(autoPauseRestartCount >  unPauseDelay)
        {
            NSLog(@"Unpausing from autopause");
            autoPauseRestartCount = 0;
            
            //trigger restart
            [delegate pauseAnimation:nil];
        }
    }
    else{
        //further away from unpausing because to slow or now in autopause
        if(autoPauseRestartCount > 0)
            autoPauseRestartCount--;
    }

    //if last position determined was more than 5 seconds ago, autopause
    if(speedToConsider == 0)
    {
        CLLocation * last = [run.pos lastObject];
        
        //ensure it hasn't recently autopaused
        if([last.timestamp timeIntervalSinceReferenceDate]  + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate]  && timeSinceUnpause + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate])
        {
            NSLog(@"Autopaused - no location updates");
            
            pausedForAuto = true;
            
            [delegate pauseAnimation:nil];
        }
    }else{
        
        //if current pace is less than
        if(speedToConsider < autoPauseSpeed && timeSinceUnpause + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate] )
        {
            NSLog(@"Autopaused - pace too slow");
            
            pausedForAuto = true;
            
            [delegate pauseAnimation:nil];
            
        }
    }
    
}

-(void) updateMapOverlay:(CLLocation*)newLocation
{
    if (readyForPathInit){
        // This is the first time we're getting a location update, so create
        // the CrumbPath and add it to the map.
        CrumbPath * newPath = [[CrumbPath alloc] initWithCenterCoordinate:newLocation.coordinate];
        [map addOverlay:newPath];
        [crumbPaths addObject:newPath];

        //inform method, path has already started drawing again
        readyForPathInit = false;
    }
    else
    {
        // This is a subsequent location update.
        // If the crumbs MKOverlay model object determines that the current location has moved
        // far enough from the previous location, use the returned updateRect to redraw just
        // the changed area.
        
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
    }
}



-(void)tick
{
    /*process 1 second gone by in timer
     Responsible for:
     -updating Meta data for only one run object of highest accuracy and deleting other
     -updating UI information
     -determining if a new minute is to be added to chart
     -determing if run should be autopaused or unpaused
     -deter if accuray is awful
     -determining if a new km happend
     */
    
    
    //update time with 1 second
    run.time += 1;
    
    
    //NSInteger posCount = [run.pos count];
    //NSInteger metaCount = [run.posMeta count];
    NSInteger queueCount = [posQueue count];
    
    //determine how many new positions were added by core location , choose latest
    if(queueCount > 0)
    {
        CLLocation * newLocation = [posQueue lastObject];
        
        //see if first pos since unpause
        if(needsStartPos)
        {
            //no pace
            [self addPosToRun:newLocation withPace:0];
            
            needsStartPos = false;
        }
        
        //1. deter accuracy for low signal
        [self evalAccuracy:newLocation.horizontalAccuracy];
        
        //2. determine if we should pause or unpause
        [self evalAutopause:newLocation.speed];
        
        //3. draw new map overlay
        [self updateMapOverlay:newLocation];
        
        //4. calculate distance
        [self calcMetrics:newLocation];
        
        //5.reload map icon
        //do not capture image if user has recently touched and map has been re-centered
        if(timeSinceMapIconRefresh < ([NSDate timeIntervalSinceReferenceDate] - reloadMapIconPeriod) &&
           (timeSinceMapTouch  < timeSinceMapCenter))
        {
            //only do so if not in map mode
            if(!inMapView)
                [self reloadMapIcon:true];
        }
        
        //6. Center map
        //do not zoom if user has recently touched
        if((timeSinceMapCenter < ([NSDate timeIntervalSinceReferenceDate] - autoZoomPeriod)) &&
           (timeSinceMapTouch < ([NSDate timeIntervalSinceReferenceDate] - userDelaysAutoZoom)))
        {
            [self autoZoomMap:newLocation];
        }
        
    }
    else
    {
        //core location did not update once, we can only update graphical times, no distance
        //potentially autopause
        
        //1. eval wheter we should pause
        [self evalAutopause:0];
        
        //cannot center map or reload icon or draw map because nothing happend
        //ignoring accuracy for now
    }

    //position independant information processed from here on:
    
    //6. update avgPace
    run.avgPace =  run.time / run.distance;
    
    //7. Update Chart every minute
    if(!((int)run.time % barPeriod))
    {
        //add one checkpoint representing past 60 seconds
        [self addMinute];
    }
    
    
    //9. Check if goal has been achieved
    [self determineGoalAchieved];
    
    //10. Update labels below
    [self updateHUD];
    
    
    //clear queue
    [posQueue removeAllObjects];
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
                            pauseImage.image = [UIImage imageNamed:@"whitepause.png"];
                        } completion:NULL];
        
        [UIView transitionWithView:statusBut
                          duration:0.3f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                        } completion:NULL];
        
        finishBut.alpha = 0.0f;
        [finishBut setHidden:false];
        runTitle.alpha = 1.0f;
        [UIView transitionWithView:finishBut
                          duration:0.5f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 1.0f;
                            runTitle.alpha = 0.0f;
                        } completion:^(BOOL finish){
                            [runTitle setHidden:true];
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
        [runTitle setHidden:false];
        runTitle.alpha = 0.0f;
        [UIView transitionWithView:finishBut
                          duration:0.5f
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 0.0f;
                            runTitle.alpha = 1.0f;
                        } completion:^(BOOL finish){
                            [finishBut setHidden:true];
                            //start run
                            [self startRun];
                            
                            
                        }];
    }
}

-(void)determineGoalAchieved
{
    switch (run.metric) {
        case NoMetricType:
            //do nothing
            return;
            break;
            
        case MetricTypePace:
            if(run.avgPace*1000 <= run.metricGoal)
            {
                [goalAchievedImage setHidden:false];
            }
            else{
                
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeDistance:
            if(run.distance >= run.metricGoal)
            {
                [goalAchievedImage setHidden:false];
            }
            else{
                
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeCalories:
            if(run.calories >= run.metricGoal)
            {
                [goalAchievedImage setHidden:false];
            }
            else{
                
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeTime:
            if(run.time >= run.metricGoal)
            {
                [goalAchievedImage setHidden:false];
            }
            else{
                
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeStride:
        case MetricTypeCadence:
        case MetricTypeClimbed:
        default:
            break;
    }
    
}

-(void)addMinute
{
    
    //add meta data for recent minute, or create chart
    if(barPlot)
    {
        //aggregrate last minute, starting at most recent
        NSInteger index = [run.posMeta count] - 1;
        NSInteger sumCount = 0;
        NSInteger currentTime = run.time;
        CLLocationMeta * lastMeta ;
        NSTimeInterval paceSum = 0;
        
        if(index >= 0 )
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
            
            //should be same size at this point
            NSAssert([run.minCheckpoints count] == [run.minCheckpointsMeta count], @"KM position and meta data arrays not same size!!");
            
        }
    }
    
    //then visually update chart
    [self updateChart];
}


-(void)calcMetrics:(CLLocation*)latest
{
    //process last 4 locations to determine all metrics: distance, avgpace, climbed, calories, stride, cadence
    
    NSInteger countOfLoc = [run.pos count] ;
    
    DataTest* data = [DataTest sharedData];
    
    //only calculate if beyond min accuracy and their is at least one object to compare to 
    if(latest.horizontalAccuracy <= logRequiredAccuracy  && countOfLoc >= 1)
    {
        //latest already added, get one behind
        CLLocation *prior = [run.pos lastObject];
        
        NSTimeInterval paceTimeInterval = latest.timestamp.timeIntervalSinceReferenceDate - prior.timestamp.timeIntervalSinceReferenceDate;
        CLLocationDistance distanceToAdd = [self calcDistance:latest];
        CLLocationDistance oldRunDistance = run.distance;
        
        //set current pace
        CLLocationDistance paceDistance = distanceToAdd;
        CLLocationSpeed currentPace = paceTimeInterval / paceDistance;//s/m
        NSTimeInterval adjustedPace = (currentPace * 1000); //s / km
        NSTimeInterval speedmMin = 60 / currentPace;
        
        
        //1.distance
        run.distance += distanceToAdd;
        NSLog(@"%f distance added", distanceToAdd);
        
        //2.climbed
        //constrain to reasonable value?
        CLLocationDistance climbed = latest.altitude - prior.altitude;
        run.climbed += climbed;
        
        //3.avg pace calced in position independant
        
        //4.calories
        CGFloat grade = climbed / distanceToAdd;
        NSInteger weight = [[[data prefs] weight] floatValue] / 2.2046; //weight in kg
        run.calories += (paceTimeInterval * weight * (3.5 + (0.2 * speedmMin) + (0.9 * speedmMin * grade)))/ (12600);
        
        //5.cadence
        //6.stride
    
        //add meta to array
        [self addPosToRun:latest withPace:adjustedPace];

        //check if a new km was created
        if((NSInteger)(oldRunDistance/1000) != (NSInteger)(run.distance/1000))
        {
            //add to object
            CLLocationMeta * newKM = [[CLLocationMeta alloc] init];
            CLLocationMeta * lastPosMeta = [[run posMeta] lastObject] ;
            newKM.time = [lastPosMeta time]; //set time to most recent
            newKM.pace = 0;
            
            //get pace from difference in most recent pos time and last km object if exists
            NSTimeInterval paceToAdjustRunTime = 0;
            if([[run kmCheckpoints] count] > 0)
            {
                CLLocationMeta * oldKM = [[run kmCheckpointsMeta] lastObject];
                paceToAdjustRunTime = [oldKM time];
                
            }
            newKM.pace =  newKM.time - paceToAdjustRunTime;
            
            //add to array
            [[run kmCheckpointsMeta] addObject:newKM];
            [[run kmCheckpoints] addObject:latest];
            
            //should be same size at this point
            NSAssert([run.kmCheckpointsMeta count] == [run.kmCheckpoints count], @"KM position and meta data arrays not same size!!");
            
            
            //add annotation
            KMAnnotation * newAnnotation = [[KMAnnotation alloc] init];
            //illustrate with pace @ KM ##
            NSString *distanceUnitText = [data.prefs getDistanceUnit];
            newAnnotation.kmName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, (NSInteger)(run.distance/1000)];
            newAnnotation.paceString = [RunEvent getPaceString:[newKM pace]];
            newAnnotation.kmCoord = [latest coordinate];
            //add to array
            [mapAnnotations addObject:newAnnotation];
            //actually add to map
            [map addAnnotation:newAnnotation];
        }
    }
    else{
        
    }
    
    kmPaceShowMode = false;
    selectedMinIndex = [[run minCheckpointsMeta] count] ;
    selectedKmIndex = [[run kmCheckpointsMeta] count];
}

-(void)addPosToRun:(CLLocation*)locToAdd withPace:(NSTimeInterval)paceToAdd
{
    CLLocationMeta * metaToAdd = [[CLLocationMeta alloc] init];
    
    metaToAdd.pace = paceToAdd;
    metaToAdd.time = run.time;
    
    //add to array
    [run.posMeta addObject:metaToAdd];
    [run.pos addObject:locToAdd];
    
    //should be same size at this point
    NSAssert([run.pos count] == [run.posMeta count], @"Run position and meta data arrays not same size!!");
}

-(CLLocationDistance)calcDistance:(CLLocation *)latest 
{
    
    NSInteger locCount = [run.pos count];
    CLLocation * prior = [run.pos lastObject];
    CLLocationDistance distanceToAdd = 0.0;
    
    if(consecutiveHeadingCount > 0)
    {
     
        CLLocationDirection cumulativeCourseDifferential = 0;
        
        //ensure array range respected
        for(int i = 1; i <= consecutiveHeadingCount && (locCount - i) >= 0; i++)
        {
            //invalidate consequtive run only if cumulative error is too large or course differential is too big
            CLLocation * considerPt = [run.pos objectAtIndex:(locCount - i)];
            
            if(!NSLocationInRange(fabs(considerPt.course - latest.course), NSMakeRange(-20, 40)))
            {
                //invalid, discontinue
                consecutiveHeadingCount = 0;
                break;
            }
            
            cumulativeCourseDifferential += fabs(considerPt.course - latest.course);
            
            if(cumulativeCourseDifferential > 50)
            {
                //discontinue seris
                consecutiveHeadingCount = 0;
                break;
            }
        }
        
        //calc distance if still available
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

#pragma mark - HUD Management

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
    else{
        
        [runTitle setText:run.name];
    }
    
    //ensure it is visible
    [runTitle setHidden:false];
    runTitle.alpha = 1.0f;
    
    [self setPaceLabels];
    
}

-(void)updateHUD
{
    //Update Pace
    [self setPaceLabels];
    
    //Update last KM Pace if no km selected
    if(selectedKmIndex == [[run kmCheckpointsMeta] count])
    {
        //need current time update to lastKMLabel
        
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

    //set distance in km
    [distanceLabel setText:[NSString stringWithFormat:@"%.2f", (run.distance/1000)]];
    
    //update time displayed
    NSString * stringToSetTime = [RunEvent getTimeString:run.time];
    [timeLabel setText:stringToSetTime];
    
    //update start header cell in menu
    [delegate updateRunTimeForMenu:stringToSetTime];
    
    [caloriesLabel setText:[NSString stringWithFormat:@"%.0f", run.calories]];
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //last should the last object in run.pos
    CLLocation *newLocation = [locations lastObject];
    //CLLocation *oldLocation = [run.pos lastObject];
    
    NSLog(@"%d  - lat%f - lon%f - accur%f - alt%f - speed%f", [run.pos count], newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy, newLocation.altitude, newLocation.speed);
    
    [posQueue addObject:newLocation];
    
    /*
    //just add to array and process in tick() if new
    if (newLocation.timestamp > oldLocation.timestamp)
    {
        [run.pos addObject:newLocation];
    }
    else
    {
        NSLog(@"%@  and %@ not logged", [newLocation.timestamp description], [oldLocation.timestamp description]);
    }
     */
 }


#pragma mark - Map Custom Functions

-(void) reloadMapIcon: (BOOL) removeAnnotationsForImage
{
    
    timeSinceMapIconRefresh = [NSDate timeIntervalSinceReferenceDate];
    
    //only remove annotations if in mapview to avoid dropping them every 5 seconds
    if(removeAnnotationsForImage)
        [map removeAnnotations:mapAnnotations];
    
    UIImage * newMapIcon = [Util imageWithView:map];
    
    if(removeAnnotationsForImage)
        [map addAnnotations:mapAnnotations];
    
    //blur
    //newMapIcon = [newMapIcon imageWithGaussianBlur9];
    
    [mapButton setImage:newMapIcon forState:UIControlStateNormal];
}


-(void) autoZoomMap:(CLLocation*)newLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, mapZoomDefault, mapZoomDefault);
    //animated to prevent jumpy
    [map setRegion:region animated:(inMapView ? YES : NO)];
    
    timeSinceMapCenter = [NSDate timeIntervalSinceReferenceDate];
    
}

-(void)zoomToEntireRun
{
    //zoom out to show entire course based on all positions for completeness
    CLLocation *lastPos = [[run pos] lastObject];
    CLLocationCoordinate2D lastCoord = [lastPos coordinate];
    
    CLLocationDegrees minLat = lastCoord.latitude;
    CLLocationDegrees maxLat = lastCoord.latitude;
    CLLocationDegrees minLong = lastCoord.longitude;
    CLLocationDegrees maxLong = lastCoord.longitude;
    
    for(CLLocation * pos in [run pos])
    {
        CLLocationCoordinate2D newCoord = [pos coordinate];
        
        if(!CLLocationCoordinate2DIsValid(newCoord))
            continue;
        
        if(newCoord.latitude < minLat)
            minLat = newCoord.latitude;
        
        if(newCoord.latitude > maxLat)
            maxLat = newCoord.latitude;
        
        if(newCoord.longitude < minLong)
            minLong = newCoord.longitude;
        
        if(newCoord.longitude > maxLong)
            maxLong = newCoord.longitude;
    }
    
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((minLat+maxLat)/2, (minLong+maxLong)/2);
    
    if(CLLocationCoordinate2DIsValid(centerCoord))
    {
        MKCoordinateSpan span = MKCoordinateSpanMake(maxLat-minLat, maxLong - minLong);
        
        //make region at center coord with a span determined by the bottom left and top right points
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoord, span);
        
        //ensure that map is loaded before capturing view
        [map setRegion:region animated:false];
        
    }
    
}

-(void)mapIconFinishedForFinishTapped
{
    
    if(loadingMapTiles > 0)
    {
        //come back every 0.2s to see if map was loaded
        [self performSelector:@selector(mapIconFinishedForFinishTapped) withObject:nil afterDelay:0.2];
        return;
    }
    
    NSLog(@"saving map thumbnail");
    waitingForMapToLoad = false;
    
    [self reloadMapIcon:true];
    
    //reset show user loc
    [map setShowsUserLocation:true];
    
    //set the run to have the correct picture in table cell
    run.map.thumbnail = [mapButton imageForState:UIControlStateNormal];
    
    
    //go back to menu and add to table at top
    [delegate finishedRun:run];
}


-(void)drawMapForHistoricRun
{
    
    //reset variables
    [map removeOverlays:crumbPaths];
    [map removeAnnotations:mapAnnotations];
    [mapAnnotations removeAllObjects];
    [crumbPathViews removeAllObjects];
    [crumbPaths removeAllObjects];
    
    readyForPathInit = true;
    
    DataTest* data = [DataTest sharedData];
    
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
    
    //need both pos and meta for KM to get pace for annotation display
    for(int i = 0; i < [[run kmCheckpoints] count]; i++)
    {
        CLLocation * kmPos = [[run kmCheckpoints] objectAtIndex:i];
        CLLocationMeta * kmMeta = [[run kmCheckpointsMeta] objectAtIndex:i];
        
        
        //add annotation
        KMAnnotation * newAnnotation = [[KMAnnotation alloc] init];
        
        NSString *distanceUnitText = [data.prefs getDistanceUnit];
        //km is just the index plus 1
        newAnnotation.kmName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, i + 1];
        newAnnotation.paceString = [RunEvent getPaceString:[kmMeta pace]];
        newAnnotation.kmCoord = [kmPos coordinate];
        
        //add to array
        [mapAnnotations addObject:newAnnotation];
        //actually add to map
        [map addAnnotation:newAnnotation];

    }
    
    
    /*
    //zoom map to user location, no animation
    CLLocation * lastPos = [run.pos lastObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(lastPos.coordinate, mapZoomDefault, mapZoomDefault);
    [map setRegion:region animated:NO];
    */
    [self zoomToEntireRun];
    
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[KMAnnotation class]]) 
    {
        // try to dequeue an existing pin view first
        static NSString *kmAnnotationIdentifier = @"kmAnnotationIdentifier";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [map dequeueReusableAnnotationViewWithIdentifier:kmAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:kmAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;//MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
        
    return nil;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"finished loading tiles..");
    
    if(waitingForMapToLoad)
    {
        loadingMapTiles--;
    }
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"start loading tiles..");
    
    if(waitingForMapToLoad)
    {
        loadingMapTiles++;
    
    }
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    //check for network errors, throw up popup?
    
    if(waitingForMapToLoad)
    {
        loadingMapTiles = 0;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //call finish run after map has updated to ensure entire map tile is drawn
    
    if([NSDate timeIntervalSinceReferenceDate] < timeSinceMapCenter + 0.5)
    {
        //scrolling was caused programmatically do nothing
    }
    else{
        //user scrolled
        //set time to lastMapTouch
        
        timeSinceMapTouch = [NSDate timeIntervalSinceReferenceDate];
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
    
    //show avg pace
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
        
        CLLocationMeta * oldKMMeta;
        //get distance from km just by looking at index
        
        //set the label to say 'KM 4' or 'Km 17'
        [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, selectedKmIndex + 1]];
        
        //lastKmPace value  not set here, because it is being updated every second in tick
        
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


#pragma mark - Manage Pace Chart

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

#pragma mark -
#pragma mark Pace Chart Data Source

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


#pragma mark - Pace Chart Delegate

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

#pragma mark - Map View Slider Methods


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
            [self reloadMapIcon:true];
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

#pragma mark -
#pragma mark Action Sheet Delegate

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
    
    //run object must be cleanup to save in appdelegate where it is stored
    
    waitingForMapToLoad = true;
    loadingMapTiles = 0;
    
    //hide user location for when saving run
    [map setShowsUserLocation:false];
    
    //zoom to show entire map
    [self zoomToEntireRun];
    
    
    //call remainder after 0.5s delay to ensure map is loaded
    [self performSelector:@selector(mapIconFinishedForFinishTapped) withObject:nil afterDelay:1.5];
    
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
    
    [statusBut.layer setBorderWidth:0.0f];
    
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
    
    [ghostBut.layer setBorderWidth:0.0f];
    
    //only if it is historical
    if(!run.live)
    {
        
        //ask user if they want to start a ghost run
        [self shouldUserGhostRun];
        
    }
}

- (IBAction)hamburgerTouched:(id)sender {
    [hamburgerBut.layer setCornerRadius:5.0f];
    [hamburgerBut.layer setMasksToBounds:true];
    
    [hamburgerBut.layer setBorderWidth:0.5f];
    [hamburgerBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
}

- (IBAction)hamburgerUnTouched:(id)sender {
    [hamburgerBut.layer setBorderWidth:0.0f];
}

- (IBAction)ghostButTouched:(id)sender {
    [ghostBut.layer setCornerRadius:5.0f];
    [ghostBut.layer setMasksToBounds:true];
    
    [ghostBut.layer setBorderWidth:0.5f];
    [ghostBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)ghostButUnTouched:(id)sender {
    
    [ghostBut.layer setBorderWidth:0.0f];
}

- (IBAction)statusTouched:(id)sender {
    [statusBut.layer setCornerRadius:5.0f];
    [statusBut.layer setMasksToBounds:true];
    
    [statusBut.layer setBorderWidth:0.5f];
    [statusBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)statusUntouched:(id)sender {
    
    [statusBut.layer setBorderWidth:0.0f];
}

- (IBAction)hamburgerTapped:(id)sender {
    
    
    [hamburgerBut.layer setBorderWidth:0.0f];
    
    [delegate menuButtonPressed:sender];
    
}
@end
