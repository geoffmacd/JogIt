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
@synthesize slideView;
@synthesize chart;
@synthesize panGesture;
@synthesize statusBut;
@synthesize finishBut;
@synthesize hamburgerBut,iconMap;
@synthesize dragButton;
@synthesize fullMap;
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
@synthesize ghostDistance,ghostDistanceTitle,ghostDistanceUnitLabel;
@synthesize inBackground;
@synthesize lowSignalLabel,titleView, goalAchievedLabel;
@synthesize autopauseLabel;
@synthesize invisibleLastKmButton;
//@synthesize testStepLabel;

#pragma mark - Lifecycle

-(void)viewDidAppear:(BOOL)animated
{
    if(showPurchaseNotification)
    {
        //present notification and thank you
        //present PR notification popup
        StandardNotifyVC * vc = [[StandardNotifyVC alloc] initWithNibName:@"StandardNotify" bundle:nil];
        [vc.view setBackgroundColor:[Util redColour]];
        [vc.view.layer setCornerRadius:5.0f];
        [vc.titleLabel setText:NSLocalizedString(@"thankyou","thank you on notification label")];
        [vc.updateLabel setText:NSLocalizedString(@"AppUpdated","description on notification label")];
        
        [self presentPopupViewController:vc animationType:MJPopupViewAnimationSlideTopBottom];
        
        showPurchaseNotification = false;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set rounded corners on buttons
    [finishBut.layer setCornerRadius:8.0f];
    [finishBut.layer setMasksToBounds:true];
    
    [paceScroll setDelegate:self];
    [paceScroll setScrollsToTop:false];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceivePause:)
                                                name:@"pauseToggleNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setLabelsForUnits)
                                                 name:@"reloadUnitsNotification"
                                               object:nil];
    
    kmPaceShowMode= false;
    selectedPaceShowMode = false;
    inMapView = false;
    paused = true;
    inBackground = false;
    [iconMap removeOverlay:mapSelectionOverlay];
    mapSelectionOverlay = nil;
    
    //localization
    [timeTitle setText:NSLocalizedString(@"TimeTitle", "Logger title for time")];
    [caloriesTitle setText:NSLocalizedString(@"CaloriesTitle", "Logger title for calories")];
    [distanceTitle setText:NSLocalizedString(@"DistanceTitle", "Logger title for distance")];
    [ghostDistanceTitle setText:NSLocalizedString(@"GhostDistanceTitle", "Logger title for ghost distance")];
    [finishBut setTitle:NSLocalizedString(@"FinishButton", "Logger finish button title") forState:UIControlStateNormal];
    [lastKmLabel setText:NSLocalizedString(@"LastKMTitle", "Logger title for last km")];
    [swipeToPauseLabel setText:NSLocalizedString(@"SwipeToPauseLabel", "Label for swipe to pause shaded view")];
    [lowSignalLabel setText:NSLocalizedString(@"LowSignalLabel", "Label for low GPS signal")];
    [goalAchievedLabel setText:NSLocalizedString(@"goalAchievedLabel", "Label for target achieved")];
    
    
    //set colors for fonts
    [swipeToPauseLabel setTextColor:[UIColor whiteColor]];
    [distanceTitle setTextColor:[Util redColour]];
    [caloriesTitle setTextColor:[Util redColour]];
    [avgPaceTitle setTextColor:[Util redColour]];
    [timeTitle setTextColor:[Util redColour]];
    [lastKmLabel setTextColor:[Util redColour]];
    [currentPaceLabel setTextColor:[Util redColour]];
    [currentPaceValue setTextColor:[Util redColour]];
    
    //set custom fonts
    
    //[timeLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:36.0f]];
    //[distanceLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:36.0f]];
    //[paceLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:25.0f]];
    //[caloriesLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:25.0f]];
    //[currentPaceValue setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    
    //top run titles
    [runTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [lowSignalLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [goalAchievedLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14.0f]];
    [autopauseLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    
    //hud titles
    [distanceTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [timeTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [caloriesTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [avgPaceTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [ghostDistanceTitle setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    //bottom titles
    [currentPaceLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [lastKmLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13.0f]];
    //units
    [distanceUnitLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    [ghostDistanceUnitLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    [distanceUnitLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    [paceUnitLabel1 setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    [paceUnitLabel2 setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10.0f]];
    
    
    
    [swipeToPauseLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:22.0f]];
    /*
    [currentPaceValue setFont:[UIFont fontWithName:@"Montserrat-Bold" size:25.0f]];
    [lastKmPace setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0f]];
    [oldpace1 setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0f]];
    [oldpace2 setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0f]];
    [oldpace3 setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0f]];
     */
    
    
    //init location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    //map annotations
    mapAnnotations = [[NSMutableArray alloc] initWithCapacity:10];
    
    //pos queue
    posQueue = [[NSMutableArray alloc] initWithCapacity:10];
    
    //necessary to set the frames properly in viewdidlayout
    justLoaded = true;
    
    
    //open ears stuff
    //musicWasPlaying = ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying ? true : false);
    openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	[openEarsEventsObserver setDelegate:self];
    fliteController = [[FliteController alloc] init];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    slt = [[Slt alloc] init];
    [self setupVoice];
    speechQueue = [[NSMutableArray alloc] initWithCapacity:5];
    
    /*
    if(musicWasPlaying)
    {
        MPMusicPlayerController *mp = [MPMusicPlayerController iPodMusicPlayer];
        [mp play];
        musicWasPlaying  = false;
    }
     */
    
}

-(void) viewDidLayoutSubviews
{
    //also gets when MBProgress is displayed for some reason
    if(!justLoaded)
        return;
    
    //set correct position for mapview so that pulldrag is at bottom
    CGRect mapRect;
    mapRect.size =  slideView.frame.size;
    mapRect.origin = CGPointMake(0, self.view.frame.size.height - mapDragPullYOffset);
    [slideView setFrame:mapRect];
    [fullMap.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [fullMap.layer setBorderWidth: 1.0];
    
    [fullMap setDelegate:self];
    CGRect fullMapRect = fullMap.frame;
    fullMapRect.size.height = self.view.frame.size.height - mapViewYOffset;
    [fullMap setFrame:fullMapRect];
    
    //setup icon map
    [iconMap.layer setCornerRadius: 5.0];
    [iconMap.layer setMasksToBounds:YES];
    [iconMap.layer setBorderWidth:0.5f];
    [iconMap.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [iconMap setDelegate:self];
    
    //setup tap gesture recognizer to intercept taps
    UITapGestureRecognizer * mapIconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mapIconTapped:)];
    mapIconTap.numberOfTapsRequired = 1;
    mapIconTap.numberOfTouchesRequired = 1;
    [iconMap addGestureRecognizer:mapIconTap];
    
    //clear arrays, etc
    [self resetMap];
    
    //add shaded view for start animation
    CGRect shadeRect = self.view.frame;
    [shadeView setFrame:shadeRect];
    [self.view addSubview:shadeView];
    
    orgTitleLabelPosition = runTitle.frame;
    orgDistanceLabelPosition = distanceLabel.frame;
    orgDistanceTitlePosition = distanceTitle.frame;
    orgDistanceUnitPosition = distanceUnitLabel.frame;
    orgTimeLabel = timeLabel.frame;
    orgTimeTitle = timeTitle.frame;
    
    justLoaded = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)inBackground
{
    return inBackground;
}

-(void)setInBackground:(BOOL)toBackground
{
    inBackground = toBackground;
    
    //refresh view if coming out of background
    if(!inBackground && run.live)
    {
        //scroll to newest
        [self updateChart];
        [self drawMapPath:true];
        if(run.ghost)
            [self drawMapGhostPath:true];
        //need to reload annotations regardless since showspeed or metric could have changed
        if([mapAnnotations count] > 0)
        {
            [fullMap removeAnnotations:mapAnnotations];
            [mapAnnotations removeAllObjects];
        }
        [self drawAllAnnotations];
        [self autoZoomMap:[run.pos lastObject] animated:false withMap:fullMap];
        [self zoomMapToEntireRun:iconMap];
        
        //process accelerometer data
        NSInteger wakeup = 0;
        for(int i = 0 ; i < [accelerometerReadings count];i++)
        {
            CMAccelerometerData * acceleration = [accelerometerReadings objectAtIndex:i];
            
            if(wakeup < i)
                isSleeping = false;
            
            float xx = acceleration.acceleration.x;
            float yy = acceleration.acceleration.y;
            float zz = acceleration.acceleration.z;
            
            float dot = (px * xx) + (py * yy) + (pz * zz);
            float a = ABS(sqrt(px * px + py * py + pz * pz));
            float b = ABS(sqrt(xx * xx + yy * yy + zz * zz));
            
            dot /= (a * b);
            
            if (dot <= 0.82) {
                
                //skip next .3seconds
                if (!isSleeping) {
                    isSleeping = YES;
                    wakeup = i + 19;
                    run.steps++;
                }
            }
            
            px = xx; py = yy; pz = zz;
        }
 
    }
    else if(inBackground)
    {
        //prevent battery loss by disabling this in  case it is enabled
        [fullMap setUserTrackingMode:MKUserTrackingModeNone];
        [iconMap setUserTrackingMode:MKUserTrackingModeNone];
        
        //set accelerometer updates
        accelerometerReadings = [NSMutableArray new];
        //add acelerometer to queue in background
        [cMManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                        withHandler:^(CMAccelerometerData *data, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                [accelerometerReadings addObject:data];
                                            });}];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark -
#pragma mark UpgradeVC Delegate

-(void)didPurchase
{
    showPurchaseNotification = true;
}

#pragma mark - Accelerometer delegate

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    if(!run)
        return;
    if(paused || !run.live)
        return;
    
    // UIAccelerometerDelegate method, called when the device accelerates.
    float xx = acceleration.x;
    float yy = acceleration.y;
    float zz = acceleration.z;
    
    float dot = (px * xx) + (py * yy) + (pz * zz);
    float a = ABS(sqrt(px * px + py * py + pz * pz));
    float b = ABS(sqrt(xx * xx + yy * yy + zz * zz));
    
    dot /= (a * b);
    
    if (dot <= 0.82) {
        if (!isSleeping) {
            isSleeping = YES;
            [self performSelector:@selector(wakeUp) withObject:nil afterDelay:0.3];
            run.steps++;
            //testStepLabel.text = [NSString stringWithFormat:@"%d", run.steps];
            //NSLog(@"Stepped: %d", run.steps);
        }
    }
    
    px = xx; py = yy; pz = zz;
    
}

- (void)wakeUp {
    isSleeping = NO;
}


#pragma mark - OpenEars Delegates


- (void) setupVoice {
    
	fliteController.duration_stretch = 1.35; // Change the speed
	fliteController.target_mean = 1.3; // Change the pitch
    fliteController.target_stddev = 1.5; // Change the variance
    
    //max volume for voice
    [fliteController.audioPlayer setVolume:2.0f];
}

-(void)speechForDistanceChange
{
    UserPrefs * curPrefs = [delegate curUserPrefs];
    
    NSString * stringWithDistance = @"";
    NSString * stringWithPace = @"";
    NSString * stringWithCurPace = @"";
    if([curPrefs.metric boolValue])
    {
        if([curPrefs.speechDistance boolValue])
        {
            stringWithDistance = [NSString stringWithFormat:@"%@ %d",  NSLocalizedString(@"SpeechKM", "km word for speech "), (int)(run.distance/1000)];
        }
        if([curPrefs.speechPace boolValue])
        {
            NSTimeInterval avgPace = 1000 / run.avgPace;
            
            if(avgPace == 0 || avgPace > 3599)
            {
                stringWithPace = NSLocalizedString(@"SpeechNoSpeed", "no speed word for speech ");
            }
            else
            {
                if([curPrefs.showSpeed boolValue])
                {
                    CGFloat speed = 3600 / avgPace;
                    stringWithPace = [NSString stringWithFormat:@"%.0f %@ %@", speed,
                                      NSLocalizedString(@"SpeechAvg", "average word for speech "),NSLocalizedString(@"SpeechKPH", "kph word for speech ")];
                }
                else
                {
                    //convert to per minute format
                    NSInteger minutes,seconds;
                    
                    minutes = avgPace/ 60;
                    seconds = avgPace - (minutes * 60);
                    
                    NSString * minuteTime = @"";
                    NSString * secondTime = @"";
                    
                    if(minutes > 0)
                        minuteTime = [NSString stringWithFormat:@"%d %@",minutes, NSLocalizedString(@"SpeechMinute", "minutes word for speech ")];
                    
                    if(seconds > 0)
                        secondTime = [NSString stringWithFormat:@"%d %@",seconds, NSLocalizedString(@"SpeechSecond", "seconds word for speech ")];
                    
                    stringWithPace = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",minuteTime, secondTime,
                                      NSLocalizedString(@"SpeechAvg", "average word for speech "),
                                      NSLocalizedString(@"SpeechPacePer", "pace per word for speech "),NSLocalizedString(@"SpeechKM", "km word for speech ")];
                }
            }
        }
        if([curPrefs.speechCurPace boolValue])
        {
            CLLocationMeta * lastPos = [run.posMeta lastObject];
            NSTimeInterval curPace = 1000 / [lastPos pace];
            
            if(curPace == 0 || curPace  > 3599)
            {
                stringWithCurPace = NSLocalizedString(@"SpeechNoSpeed", "no speed word for speech ");
            }
            else
            {
                if([curPrefs.showSpeed boolValue])
                {
                    CGFloat speed = 3600 / curPace ;
                    stringWithCurPace = [NSString stringWithFormat:@"%.0f %@ %@", speed, NSLocalizedString(@"SpeechCurrent", "current word for speech "),
                        NSLocalizedString(@"SpeechKPH", "kph word for speech ")];
                }
                else
                {
                    //convert to per minute format
                    NSInteger minutes,seconds;
                    
                    minutes = curPace/ 60;
                    seconds = curPace  - (minutes * 60);
                    
                    NSString * minuteTime = @"";
                    NSString * secondTime = @"";
                    
                    if(minutes > 0)
                        minuteTime = [NSString stringWithFormat:@"%d %@",minutes, NSLocalizedString(@"SpeechMinute", "minutes word for speech ")];
                    
                    if(seconds > 0)
                        secondTime = [NSString stringWithFormat:@"%d %@",seconds, NSLocalizedString(@"SpeechSecond", "seconds word for speech ")];
                    
                    stringWithCurPace = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",minuteTime, secondTime,
                                         NSLocalizedString(@"SpeechCurrent", "current word for speech "),
                                         NSLocalizedString(@"SpeechPacePer", "pace per word for speech "),NSLocalizedString(@"SpeechKM", "km word for speech ")];
                }
            }
        }
    }
    else
    {
        if([curPrefs.speechDistance boolValue])
        {
            stringWithDistance = [NSString stringWithFormat:@"%@ %d",   NSLocalizedString(@"SpeechMile", "mile word for speech "), (int)(run.distance*convertKMToMile/1000)];
        }
        if([curPrefs.speechPace boolValue])
        {
            NSTimeInterval avgPace = 1000  /(run.avgPace* convertKMToMile);
            
            if(avgPace == 0 || avgPace > 3599)
            {
                stringWithPace = NSLocalizedString(@"SpeechNoSpeed", "no speed word for speech ");
            }
            else
            {
                if([curPrefs.showSpeed boolValue])
                {
                    CGFloat speed = 3600 / avgPace;
                    stringWithPace = [NSString stringWithFormat:@"%.0f %@ %@", speed,
                                      NSLocalizedString(@"SpeechAvg", "average word for speech "),NSLocalizedString(@"SpeechMPH", "mph word for speech ")];
                }
                else
                {
                    //convert to per minute format
                    NSInteger minutes,seconds;
                    
                    minutes = avgPace/ 60;
                    seconds = avgPace - (minutes * 60);
                    
                    NSString * minuteTime = @"";
                    NSString * secondTime = @"";
                    
                    if(minutes > 0)
                        minuteTime = [NSString stringWithFormat:@"%d %@",minutes, NSLocalizedString(@"SpeechMinute", "minutes word for speech ")];
                    
                    if(seconds > 0)
                        secondTime = [NSString stringWithFormat:@"%d %@",seconds, NSLocalizedString(@"SpeechSecond", "seconds word for speech ")];
                    
                    stringWithPace = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",minuteTime, secondTime,
                                      NSLocalizedString(@"SpeechAvg", "average word for speech "),
                                      NSLocalizedString(@"SpeechPacePer", "pace per word for speech "),NSLocalizedString(@"SpeechMile", "mile word for speech ")];
                }
            }
        }
        if([curPrefs.speechCurPace boolValue])
        {
            CLLocationMeta * lastPos = [run.posMeta lastObject];
            NSTimeInterval curPace = 1000  / ([lastPos pace]* convertKMToMile);
            
            if(curPace == 0 || curPace > 3599)
            {
                stringWithCurPace = NSLocalizedString(@"SpeechNoSpeed", "no speed word for speech ");
            }
            else
            {
                if([curPrefs.showSpeed boolValue])
                {
                    CGFloat speed = 3600 / curPace ;
                    stringWithCurPace = [NSString stringWithFormat:@"%.0f %@ %@", speed, NSLocalizedString(@"SpeechCurrent", "current word for speech "), NSLocalizedString(@"SpeechMPH", "mph word for speech ")];
                }
                else
                {
                    //convert to per minute format
                    NSInteger minutes,seconds;
                    
                    minutes = curPace/ 60;
                    seconds = curPace - (minutes * 60);
                    
                    NSString * minuteTime = @"";
                    NSString * secondTime = @"";
                    
                    if(minutes > 0)
                        minuteTime = [NSString stringWithFormat:@"%d %@",minutes, NSLocalizedString(@"SpeechMinute", "minutes word for speech ")];
                    
                    if(seconds > 0)
                        secondTime = [NSString stringWithFormat:@"%d %@",seconds, NSLocalizedString(@"SpeechSecond", "seconds word for speech ")];
                    
                    stringWithCurPace = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",minuteTime, secondTime,
                                         NSLocalizedString(@"SpeechCurrent", "current word for speech "),
                                         NSLocalizedString(@"SpeechPacePer", "pace per word for speech "),NSLocalizedString(@"SpeechMile", "mile word for speech ")];
                }
            }
        }
    }
    
    NSString * stringWithCalories = @"";
    NSString * stringWithTime = @"";
    if([curPrefs.speechTime boolValue])
    {
        if(run.time < 3600000)
        {
            NSInteger hours,minutes,seconds;
            
            hours = run.time  / 3600;
            minutes = run.time / 60 - (hours*60);
            seconds = run.time  - (minutes * 60) - (hours * 3600);
            
            NSString * hourTime = @"";
            NSString * minuteTime = @"";
            if(hours > 0)
                hourTime = [NSString stringWithFormat:@"%d %@", hours,  NSLocalizedString(@"SpeechHour", "hours word for speech ")];
            
            minuteTime = [NSString stringWithFormat:@"%d %@", minutes,  NSLocalizedString(@"SpeechMinute", "minute word for speech ")];
            
            stringWithTime = [NSString stringWithFormat:@"%@ %@ %@",NSLocalizedString(@"SpeechTime", "time word for speech "), hourTime, minuteTime];
        }
    }
    if([curPrefs.speechCalories boolValue])
    {
        stringWithCalories = [NSString stringWithFormat:@"%d %@", (int)run.calories, NSLocalizedString(@"SpeechCalorie", "calorie word for speech ")];
    }
    
    //add to queue in right order
    if(stringWithDistance.length > 0)
        [speechQueue addObject:stringWithDistance];
    if(stringWithTime.length > 0)
        [speechQueue addObject:stringWithTime];
    if(stringWithCalories.length > 0)
        [speechQueue addObject:stringWithCalories];
    if(stringWithPace.length > 0)
        [speechQueue addObject:stringWithPace];
    if(stringWithCurPace.length > 0)
        [speechQueue addObject:stringWithCurPace];
    
}

-(void)audioCue:(AudioCueType)type
{
    //do not say anything if disabled
    if(![[[delegate curUserPrefs] speech] boolValue])
        return;
    
    switch(type)
    {
        case SpeechIntro:
            [speechQueue addObject:NSLocalizedString(@"SpeechIntro", "begin run speech") ];
            break;
        case SpeechMinute:
            //[self speechForDistanceChange];
            break;
        case SpeechKM:
        case SpeechMile:
            [self speechForDistanceChange];
            break;
        case SpeechAutoPause:
            [speechQueue addObject:NSLocalizedString(@"SpeechAutopause", "autopause speech") ];
            break;
        case SpeechResume:
            [speechQueue addObject:NSLocalizedString(@"SpeechResume", "resume speech") ];
            break;
    }
    
    //remember if music was playinh 
    MPMusicPlayerController * mp = [MPMusicPlayerController iPodMusicPlayer];
    musicWasPlaying = ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying ? true : false);
    if(musicWasPlaying)
        [mp pause];
    
    //make it start processing
    [self sayNextSpeech];
}

-(void)sayNextSpeech
{
    if([speechQueue count])
    {
        [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryPlayback error:nil];
        OSStatus propertySetError = 0;
        UInt32 allowMixing = true;
        propertySetError = AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing);
        [fliteController say:[speechQueue objectAtIndex:0] withVoice:slt];
    }
    else
    {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionCategoryPlayback error:nil];
        if(musicWasPlaying)
        {
            MPMusicPlayerController * mp = [MPMusicPlayerController iPodMusicPlayer];
            [mp play];
            musicWasPlaying = false;
        }
    }
}

- (void) fliteDidStartSpeaking {
	//NSLog(@"Flite has started speaking"); // Log it.
    
}

- (void) fliteDidFinishSpeaking {
	//NSLog(@"Flite has finished speaking"); // Log it.
    
    //dequeue item and play next one after duration
    if([speechQueue count])
    {
        [speechQueue removeObjectAtIndex:0];
        [self performSelector:@selector(sayNextSpeech) withObject:nil afterDelay:delaySpeech];
    }
}

#pragma mark - Loading runs


- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate
{
    //configure new run with that metric and value if their is one

    
    //load most recent run on startup, but not intended any other time
    RunEvent * loadRun = newRunTemplate;
    [self setRun:loadRun];
    
    countdown = [[[delegate curUserPrefs] countdown] integerValue];
    if(countdown < 1)
        countdown = 1;
    
    [shadeView setHidden:false];
    [countdownLabel setAlpha:1.0f];
    [countdownLabel setText:[NSString stringWithFormat:@"%d", countdown]];
    
    //previous notification in app delegate has already changed status to paused
    NSAssert(paused, @"not yet paused from appdelegate notification");
    
    [self newRunAnimationLoop];
}

-(void) newRunAnimationLoop
{
    if(!paused)
    {
        //user has swiped early
        //start run
        [shadeView setHidden:true];
        [shadeView setAlpha:1.0f];
        return;
    }
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         if(countdownLabel.alpha == 0.6f)
                             [countdownLabel setAlpha:1.0f];
                         else
                             [countdownLabel setAlpha:0.6f];
                         
                         if(countdown == 1)
                         {
                             [shadeView setAlpha:0.1f];
                         }
                     }
     
                     completion:^(BOOL finish){
                         
                         countdown--;
                         [countdownLabel setText:[NSString stringWithFormat:@"%d", countdown]];
                         
                         if(countdown > 0)
                         {
                             [self newRunAnimationLoop];
                         }
                         else
                         {
                             //start run
                             [shadeView setHidden:true];
                             [shadeView setAlpha:1.0f];
                             [delegate pauseAnimation:nil];
                         }
                         
                     }
     ];

    
}


-(void)setRun:(RunEvent *)_run
{
    run = _run;
    
    //hide these by default unless newrun overrides them
    [finishBut setHidden:true];
    //hide goal image, until we decide to display it
    [goalAchievedImage setHidden:true];
    //hide autopause again
    [autopauseLabel setHidden:true];
    
    //clear map and reset overlays,etc
    [self resetMap];
    
    //either live or historical run
    if(!run.live)
    {
        
        //display ghost and share
        [statusBut setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [ghostBut setHidden:false];
        
        //erase ghost ui
        [self resetGhostRun];
        
        //NSLog(@"Reset Logger %f",[NSDate timeIntervalSinceReferenceDate]);
        
        //zoom to entire run
        [self drawMapPath:true];
        //do not draw any ghost paths
        [self zoomMapToEntireRun:fullMap];
        [self zoomMapToEntireRun:iconMap];
    }
    else
    {
        //hide red x if it is not a targeted run
        if(run.targetMetric != NoMetricType)
        {
            //if it is, set the image to be besides the label
            CGRect metricRect;
            CGRect imageRect = goalAchievedImage.frame;
            
            switch (run.targetMetric) {
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
            imageRect.origin.y += metricRect.size.height/6;
            [goalAchievedImage setFrame:imageRect];
            
        }
        
        [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        //hide ghost
        [ghostBut setHidden:true];
        
        //hide labels for ghost
        if(run.ghost)
        {
            [self enableGhostRun];
        }
        else
        {
            [self resetGhostRun];
        }
        
        //add current minute bar if new live run
        CLLocationMeta * newMin = [[CLLocationMeta alloc] init];
        //leave pace to what it was
        newMin.pace = 0;
        newMin.time = barPeriod;
        [run.minCheckpointsMeta addObject:newMin];
        
        //ensure no signal animation
        lowSignal = false;
        goalAchieved = false;
        
        //set map to follow user before starting run, then stop, in order to load current location
        [iconMap setUserTrackingMode:MKUserTrackingModeFollow];
        [fullMap setUserTrackingMode:MKUserTrackingModeFollow];
    }
    
    //reset chart
    if(barPlot)
    {
        [barChart removePlot:barPlot];
        [barChart removePlot:selectedPlot];
        
        selectedPlot = nil;
        barPlot = nil;
    }
    
    //reset pace selection
    [self resetPaceSelection];
    
    //needs to be before update chart which is expensive
    [self setLabelsForUnits];
    [self updateHUD];
    
    //scrolls to end
    [self updateChart];
    
    [selectedPlot reloadData];
    
    //NSLog(@"Completed run load %f",[NSDate timeIntervalSinceReferenceDate]);
    
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

-(void)enableGhostRun
{
    //hide avgpace and calories
    [paceLabel setHidden:true];
    [paceUnitLabel2 setHidden:true];
    [caloriesLabel setHidden:true];
    [caloriesTitle setHidden:true];
    [avgPaceTitle setHidden:true];
    
    //set color of ghost to be blue and user to be red in distance labels
    [distanceLabel setTextColor:[Util redColour]];
    [ghostDistance setTextColor:[Util blueColour]];
    [ghostDistanceTitle setTextColor:[Util blueColour]];
    
    //unhide ghost distance
    [ghostDistance setHidden:false];
    [ghostDistance setText:@"0:00"];
    [ghostDistanceTitle setHidden:false];
    [ghostDistanceUnitLabel setHidden:false];
    
    //custom ghost message for swipe to pause
    [swipeToPauseLabel setText:NSLocalizedString(@"SwipeToPauseGhostLabel", "Label for swipe to pause with a ghost run")];
    
    //move time to middle
    CGFloat center = self.view.frame.size.width/2;
    CGRect labelFrame = timeLabel.frame;
    labelFrame.origin.x = center - (labelFrame.size.width/2);
    [timeLabel setFrame:labelFrame];
    CGRect titleFrame = timeTitle.frame;
    titleFrame.origin.x = center - (titleFrame.size.width/2);
    [timeTitle setFrame:titleFrame];
    
    //move distance -10 left
    labelFrame = distanceLabel.frame;
    labelFrame.origin.x = labelFrame.origin.x - 10;
    [distanceLabel setFrame:labelFrame];
    labelFrame = distanceTitle.frame;
    labelFrame.origin.x = labelFrame.origin.x - 10;
    [distanceTitle setFrame:labelFrame];
    labelFrame = distanceUnitLabel.frame;
    labelFrame.origin.x = labelFrame.origin.x - 10;
    [distanceUnitLabel setFrame:labelFrame];
    
}

-(void)resetGhostRun
{
    //unhide avgpace and calories
    [paceLabel setHidden:false];
    [paceUnitLabel2 setHidden:false];
    [caloriesLabel setHidden:false];
    [caloriesTitle setHidden:false];
    [avgPaceTitle setHidden:false];
    
    //set color of ghost to be original
    [distanceLabel setTextColor:[UIColor blackColor]];
    [ghostDistance setTextColor:[UIColor blackColor]];
    [ghostDistanceTitle setTextColor:[Util redColour]];
    
    //hide ghost distance
    [ghostDistance setHidden:true];
    [ghostDistanceTitle setHidden:true];
    [ghostDistanceUnitLabel setHidden:true];
    
    //set swipe to pause back
    [swipeToPauseLabel setText:NSLocalizedString(@"SwipeToPauseLabel", "Label for swipe to pause shaded view")];
    
    //move time back
    [timeLabel setFrame:orgTimeLabel];
    [timeTitle setFrame:orgTimeTitle];
    
    //move distance back
    [distanceLabel setFrame:orgDistanceLabelPosition];
    [distanceTitle setFrame:orgDistanceTitlePosition];
    [distanceUnitLabel setFrame:orgDistanceUnitPosition];
    
}

#pragma mark - Managing Live Run

-(void)startRun
{
    //tell app delegate to stop idle timer
    [delegate preventIdleForLiveRun];
    
    //stop map following user
    [iconMap setUserTrackingMode:MKUserTrackingModeNone];
    [fullMap setUserTrackingMode:MKUserTrackingModeNone];
    
    //start updates
    //NSLog(@"started tracking.....");
    //tells to process first pos directly without calcing pace
    needsStartPos = true;
    //clear queue
    [posQueue removeAllObjects];
    //if the run was autopaused, need to generate first position by stopping and starting
    if(pausedForAuto)
        [locationManager stopUpdatingLocation];
    //begin updating location again
    [locationManager startUpdatingLocation];
    
    //need to scroll to current position in fight
    [self updateChart];
    
    //reset selection
    [self resetPaceSelection];
    [self updateHUD];
    
    //set timer up to run once a second
    if(![timer isValid])
    {
        
        //schedule on run loop to increase priority
        timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    //reset autopause variables
    pausedForAuto = false;
    timeSinceUnpause = [NSDate timeIntervalSinceReferenceDate];
    
    //reset counter
    consecutiveHeadingCount = 0;
    
    //speech at start of run
    if(run.time == 0)
    {
        //[self audioCue:SpeechIntro];
    }
    
    //init accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / AccelUpdateFreq];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    px = py = pz = 0;
    cMManager = [[CMMotionManager alloc] init];
    [cMManager setAccelerometerUpdateInterval:(1/AccelUpdateFreq)];
}


-(void) stopRun:(BOOL)finished
{
    //if autopause caused this, do not stop location updates
    if(!pausedForAuto || finished)
    {
        //stop updates otherwise for battery life etc
        //NSLog(@"stopped tracking.....");
        [locationManager stopUpdatingLocation];
        
        //reset idle timer
        [delegate resetIdle];
        
        //stop talking
        [speechQueue removeAllObjects];
    }
    
    //stop tick() processing even for autopause
    [timer invalidate];
    
    //stop updating accelerometer by setting nil delegate
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    
    //only zoom if there exists a last point
    if([run.pos lastObject])
    {
        //add to pausepoints to know where to break overlay lines
        [run.pausePoints addObject:[run.pos lastObject]];
        if(inMapView)
            [self autoZoomMap:[run.pos lastObject] animated:inMapView withMap:fullMap];
        else
            [self zoomMapToEntireRun:iconMap];
    }
}

-(void)evalAccuracy:(CLLocationAccuracy)accuracyToAccumulate
{
    
    avgAccuracy += accuracyToAccumulate;
    //evaluate if more than 5 seconds
    if(((NSInteger)run.time % evalAccuracyPeriod) == 0)
    {
        if(avgAccuracy > maxPermittableAccuracy * evalAccuracyPeriod)
        {
            //display
            if(!lowSignal && !animatingLowSignal)
            {
                [self performSelector:@selector(lowSignalAnimation) withObject:nil];
                lowSignal = true;
            }
        }
        else{
            //hide
            lowSignal = false;
        }
        //reset
        avgAccuracy = 0;
    }
    
}


-(void)evalAutopause:(CLLocationSpeed)speedToConsider
{

    //if last position determined was more than 5 seconds ago, autopause
    if(speedToConsider == -1)
    {
        CLLocation * last = [run.pos lastObject];
        
        //ensure it hasn't recently autopaused
        if([last.timestamp timeIntervalSinceReferenceDate]  + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate]  && timeSinceUnpause + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate])
        {
            //determine if autopause is enabled in settings
            UserPrefs * curSettings = [delegate curUserPrefs];
            if([curSettings.autopause integerValue] == 1)
            {
                //NSLog(@"Autopaused - no location updates");
                
                pausedForAuto = true;
                
                [delegate pauseAnimation:nil];
                [autopauseLabel setHidden:false];
                
                [self audioCue:SpeechAutoPause];
            }
        }
    }else{
        
        //if current pace is less than minimum
        if(speedToConsider < autoPauseSpeed && timeSinceUnpause + autoPauseDelay < [NSDate timeIntervalSinceReferenceDate] )
        {
            //determine if autopause is enabled in settings
            UserPrefs * curSettings = [delegate curUserPrefs];
            if([curSettings.autopause integerValue] == 1)
            {
                //NSLog(@"Autopaused - pace too slow");
                
                pausedForAuto = true;
                
                [delegate pauseAnimation:nil];
                [autopauseLabel setHidden:false];
                
                [self audioCue:SpeechAutoPause];
            }
        }
    }
    
}


-(void)tick
{
    /*process 1 second gone by in timer
     Responsible for:
     -updating Meta data for only one run object of highest accuracy and deleting others
     -calcing new run info cals etc
     -updating UI information
     -determining if a new minute is to be added to chart and then scrolling
     -determing if run should be autopaused or unpaused
     -determing if accuray is awful
     -determining if a new km happend
     */
    
    //update time with 1 second
    run.time += 1;

    //do not process if it still needs a start position
    if(needsStartPos)
        return;
    
    NSInteger queueCount = [posQueue count];
    
    //determine how many new positions were added by core location , choose latest
    //only process every 3 seconds to get better information
    if(queueCount > 0)
    {
        CLLocation * newLocation = [posQueue lastObject];
        
        if(((int)run.time) % calcPeriod == 0)
        {
            //clear queue asap for next location update sometime in tick() method
            [posQueue removeAllObjects];
            
            //1. deter accuracy for low signal
            [self evalAccuracy:newLocation.horizontalAccuracy];
            
            //2. calculate distance
            [self calcMetrics:newLocation];
            
            //3. draw new map overlay
            [self drawMapPath:false];
            [self removeLegalLabelForMap:iconMap];
            
            //4. determine if we should pause or unpause,with latest pace
            CLLocationMeta * latestMeta = [[run posMeta] lastObject];
            [self evalAutopause:latestMeta.pace];
        }
        else{
            
            //on odd periods only update graphics, so that overlay has processed
            
            //zoom map, only when in full map
            if(timeSinceMapCenter < ([NSDate timeIntervalSinceReferenceDate] - autoZoomPeriod))
            {
                //do not zoom if user has recently touched
                if(timeSinceMapTouch < [NSDate timeIntervalSinceReferenceDate] - userDelaysAutoZoom)
                {
                    [self autoZoomMap:newLocation animated:inMapView withMap:fullMap];
                }
            }
            //center mapIcon over entire run
            if((timeSinceMapIconRefresh < ([NSDate timeIntervalSinceReferenceDate] - reloadMapIconPeriod)))
            {
                [self zoomMapToEntireRun:iconMap];
            }
        }
    }
    else
    {
        //core location did not update once, we can only update graphical times, no distance
        //potentially autopause
        
        //eval wheter we should pause if not recieving signal
        [self evalAutopause:-1];
        
    }

    //position independant information processed from here on:
    
    //update ghost run map
    if(run.ghost)
        [self drawMapGhostPath:false];
    
    //update avgPace, needs to be here in case no pos recorded
    run.avgPace =  run.distance / run.time; //m/s
    
    //Update Chart every minute
    if(!((int)run.time % barPeriod))
    {
        //add one checkpoint representing past 60 seconds
        [self addMinute];
    }
    else if((int)run.time % calcPeriod == 0)
    {
        //otherwise update size of current minute bar after a calculation
        [self adjustCurrentBar];
    }
    
    //Check if goal has been achieved
    if(run.time > delayGoalAssessment)
        [self determineGoalAchieved];
    
    //Update labels, disable selection mode
    [self updateHUD];
}


- (void)didReceivePause:(NSNotification *)notification
{
    //assume it is not locked
    paused = !paused;
    
    UIImageView * pauseImage = (UIImageView *) [notification object];
    
    if(paused){
        [UIView transitionWithView:pauseImage
                          duration:finishButtonFade
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"whitepause.png"];
                        } completion:NULL];
        
        [UIView transitionWithView:statusBut
                          duration:finishButtonFade
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [statusBut setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                        } completion:NULL];
        
        finishBut.alpha = 0.0f;
        [finishBut setHidden:false];
        runTitle.alpha = 1.0f;
        [UIView transitionWithView:finishBut
                          duration:finishButtonFade
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            finishBut.alpha = 1.0f;
                            runTitle.alpha = 0.0f;
                        } completion:^(BOOL finish){
                            [runTitle setHidden:true];
                            //stop location updates
                            [self stopRun:false];
                        }];
        
        //cancel low signal animation
        [lowSignalLabel setHidden:true];
        lowSignal = false;
        [goalAchievedLabel setHidden:true];
        goalAchieved = false;
        [runTitle setFrame:orgTitleLabelPosition];
        
    }
    else
    {
        //hide autopause again
        [autopauseLabel setHidden:true];
        
        [UIView transitionWithView:pauseImage
                          duration:finishButtonFade
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"record.png"];
                        } completion:NULL];
        
        
        [UIView transitionWithView:statusBut
                          duration:finishButtonFade
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            [statusBut setImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
                        } completion:NULL];
        
        
        finishBut.alpha = 1.0f;
        [runTitle setHidden:false];
        runTitle.alpha = 1.0f;
        [UIView transitionWithView:finishBut
                          duration:finishButtonFade
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
    switch (run.targetMetric) {
            
        case MetricTypePace:
            if(run.avgPace >= run.metricGoal)
            {
                //display
                if(!goalAchieved && !animatingGoalAchieved)
                {
                    [self performSelector:@selector(goalAchievedAnimation) withObject:nil];
                    goalAchieved = true;
                }
                [goalAchievedImage setHidden:false];
            }
            else{
                
                goalAchieved = false;
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeDistance:
            if(run.distance >= run.metricGoal)
            {
                //display
                if(!goalAchieved && !animatingGoalAchieved)
                {
                    [self performSelector:@selector(goalAchievedAnimation) withObject:nil];
                    goalAchieved = true;
                }
                [goalAchievedImage setHidden:false];
            }
            else{
                
                goalAchieved = false;
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeCalories:
            if(run.calories >= run.metricGoal)
            {
                //display
                if(!goalAchieved && !animatingGoalAchieved)
                {
                    [self performSelector:@selector(goalAchievedAnimation) withObject:nil];
                    goalAchieved = true;
                }
                [goalAchievedImage setHidden:false];
            }
            else{
                
                goalAchieved = false;
                [goalAchievedImage setHidden:true];
            }
            break;
        case MetricTypeTime:
            if(run.time >= run.metricGoal)
            {
                //display
                if(!goalAchieved && !animatingGoalAchieved)
                {
                    [self performSelector:@selector(goalAchievedAnimation) withObject:nil];
                    goalAchieved = true;
                }
                [goalAchievedImage setHidden:false];
            }
            else{
                
                goalAchieved = false;
                [goalAchievedImage setHidden:true];
            }
            break;
        default:
            goalAchieved = false;
            [goalAchievedImage setHidden:true];
            break;
    }
    
}

-(void)calcMetrics:(CLLocation*)latest
{
    //process last 4 locations to determine all metrics: distance, avgpace, climbed, calories, stride, cadence
    
    NSInteger countOfLoc = [run.pos count] ;
    
    
    //only calculate if beyond min accuracy and their is at least one object to compare to 
    if(latest.horizontalAccuracy <= logRequiredAccuracy  && countOfLoc > 0)
    {
        //latest already added, get one behind
        CLLocation *prior = [run.pos lastObject];
        
        NSTimeInterval paceTimeInterval = latest.timestamp.timeIntervalSinceReferenceDate - prior.timestamp.timeIntervalSinceReferenceDate;
        CLLocationDistance distanceToAdd = [self calcDistance:latest];
        CLLocationDistance oldRunDistance = run.distance;
        
        //set current pace
        CLLocationSpeed currentPace = distanceToAdd/ paceTimeInterval; //m/s
        NSTimeInterval speedmMin = 60  * currentPace; // m /min
        
        //1.distance
        run.distance += distanceToAdd;
        //NSLog(@"%f distance added", distanceToAdd);
        
        //2.climbed
        CLLocationDistance climbed = latest.altitude - prior.altitude;
        //run.climbed += climbed;
        
        //3.avg pace calced in position independant
        
        //4.calories
        CGFloat grade = 0;
        if(distanceToAdd > 1)
            grade = climbed / distanceToAdd;
        UserPrefs * curSettings = [delegate curUserPrefs];
        BOOL showSpeed = [[curSettings showSpeed] boolValue];
        BOOL isMetric = [[curSettings metric] boolValue];
        CGFloat weight = [[curSettings weight] floatValue] / 2.2046; //weight in kg
        CGFloat calsToAdd = (paceTimeInterval * weight * (3.5 + (0.2 * speedmMin) + (0.9 * speedmMin * grade)))/ 12600;
        //only add calories if it is positive
        if(calsToAdd > 0.0f)
            run.calories += calsToAdd;
    
        //add meta to array
        [self addPosToRun:latest withPace:currentPace withCumulativeDistance:run.distance];

        //check if a new km was created
        if((NSInteger)(oldRunDistance/1000) != (NSInteger)(run.distance/1000))
        {
            //add to object
            CLLocationMeta * newKM = [[CLLocationMeta alloc] init];
            CLLocationMeta * lastPosMeta = [[run posMeta] lastObject] ;
            newKM.time = [lastPosMeta time]; //set time to most recent
            
            //get pace from difference in most recent pos time and last km object if exists
            NSTimeInterval paceToAdjustRunTime = 0;
            if([[run kmCheckpoints] count] > 0)
            {
                CLLocationMeta * oldKM = [[run kmCheckpointsMeta] lastObject];
                paceToAdjustRunTime = [oldKM time];
                
            }
            newKM.pace =  newKM.time - paceToAdjustRunTime;//s / km
            newKM.pace = 1000 / newKM.pace; //m/s
            
            //add to array
            [[run kmCheckpointsMeta] addObject:newKM];
            [[run kmCheckpoints] addObject:latest];
            
            //should be same size at this point
            NSAssert([run.kmCheckpointsMeta count] == [run.kmCheckpoints count], @"KM position and meta data arrays not same size!!");
            
            
            //add annotation if metric and update pace labels
            if(isMetric)
            {
                KMAnnotation * newAnnotation = [[KMAnnotation alloc] init];
                //illustrate with pace @ KM ##
                NSString *distanceUnitText = [curSettings getDistanceUnit];
                newAnnotation.kmName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, (NSInteger)(run.distance/1000)];
                newAnnotation.paceString = [RunEvent getPaceString:[newKM pace] withMetric:true showSpeed:showSpeed];
                newAnnotation.kmCoord = [latest coordinate];
                //add to array
                [mapAnnotations addObject:newAnnotation];
                //actually add to map
                [fullMap addAnnotation:newAnnotation];
                
                //update pace labels
                [self resetPaceSelection];
                
                //speech
                [self audioCue:SpeechKM];
            }
        }
        
        //check if a new mile was created
        if((NSInteger)(oldRunDistance*convertKMToMile/1000) != (NSInteger)(run.distance*convertKMToMile/1000))
        {
            //add to object
            CLLocationMeta * newMile = [[CLLocationMeta alloc] init];
            CLLocationMeta * lastPosMeta = [[run posMeta] lastObject] ;
            newMile.time = [lastPosMeta time]; //set time to most recent
            
            //get pace from difference in most recent pos time and last km object if exists
            NSTimeInterval paceToAdjustRunTime = 0;
            if([[run impCheckpoints] count] > 0)
            {
                CLLocationMeta * oldMile = [[run impCheckpointsMeta] lastObject];
                paceToAdjustRunTime = [oldMile time];
                
            }
            //need to ensure mi paces are still in m/s
            newMile.pace =  newMile.time - paceToAdjustRunTime;//s / mi
            newMile.pace = 1000 / (convertKMToMile * newMile.pace); //m/s
            
            //add to array
            [[run impCheckpointsMeta] addObject:newMile];
            [[run impCheckpoints] addObject:latest];
            
            //should be same size at this point
            NSAssert([run.impCheckpointsMeta count] == [run.impCheckpoints count], @"Mile position and meta data arrays not same size!!");
            
            
            //add annotation if imperial and update pace labels
            if(!isMetric)
            {
                MileAnnotation * newAnnotation = [[MileAnnotation alloc] init];
                //illustrate with pace @ KM ##
                NSString *distanceUnitText = [curSettings getDistanceUnit];
                newAnnotation.mileName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, (NSInteger)(run.distance/1000)];
                newAnnotation.paceString = [RunEvent getPaceString:[newMile pace] withMetric:false showSpeed:showSpeed];
                newAnnotation.mileCoord = [latest coordinate];
                //add to array
                [mapAnnotations addObject:newAnnotation];
                //actually add to map
                [fullMap addAnnotation:newAnnotation];
                
                //update pace labels
                [self resetPaceSelection];
                
                //speech
                [self audioCue:SpeechMile];
            }
        }

    }
    else{
        
    }
}

-(void)addPosToRun:(CLLocation*)locToAdd withPace:(NSTimeInterval)paceToAdd withCumulativeDistance:(CGFloat)cumDistance
{
    //pace in m/s
    CLLocationMeta * metaToAdd = [[CLLocationMeta alloc] init];
    
    metaToAdd.pace = paceToAdd;
    metaToAdd.distance = cumDistance;
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
        for(int i = 1; i <= consecutiveHeadingCount && locCount > 0; i++)
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
    
    //NSLog(@"Consequtive %d", consecutiveHeadingCount);
    
    return distanceToAdd;
}

-(NSInteger)indexForRunAtTime:(NSTimeInterval)timeToFind
{
    
    if([run.posMeta count] == 0)
        return -1;
    
    NSInteger indexToReturn = 0;
    
    for(CLLocationMeta * position in run.posMeta)
    {
        if(position.time == timeToFind)
            return indexToReturn;
        
        indexToReturn++;
    }
    
    return -1;
}

-(NSInteger)indexForGhostRunAtTime:(NSTimeInterval)timeToFind
{
    
    if([run.associatedRun.posMeta count] == 0)
        return -1;

    NSInteger indexToReturn = 0;

    for(CLLocationMeta * position in run.associatedRun.posMeta)
    {
        if(position.time == run.time)
            return indexToReturn;
        
        indexToReturn++;
    }
    
    return 0;
}

#pragma mark - HUD Management

-(void)lowSignalAnimation
{
    //animation to slide in from the right
    
    //return right away if called during pause
    if(paused || !run.live || animatingGoalAchieved)
        return;
    
    //set low signal to org position to right of screen
    CGRect lowSignalOrgRect = orgTitleLabelPosition;
    lowSignalOrgRect.origin = CGPointMake(orgTitleLabelPosition.origin.x + orgTitleLabelPosition.size.width, orgTitleLabelPosition.origin.y);
    [lowSignalLabel setFrame:lowSignalOrgRect];
    [lowSignalLabel setHidden:false];
    
    CGRect runTitleDestRect = orgTitleLabelPosition;
    runTitleDestRect.origin = CGPointMake(orgTitleLabelPosition.origin.x - orgTitleLabelPosition.size.width, orgTitleLabelPosition.origin.y);
    
    animatingLowSignal = true;
    
    [UIView animateWithDuration:lowSignalPeriod/2
                     delay:lowSignalPeriod
                     options:UIViewAnimationCurveEaseIn
                     animations:^{
                         //move title out
                         [runTitle setFrame:runTitleDestRect];
                         //move low signal in
                         [lowSignalLabel setFrame:orgTitleLabelPosition];
                     }
                     completion:^(BOOL finished) {
                         
                         [runTitle setFrame:lowSignalOrgRect];
                         [lowSignalLabel setFrame:orgTitleLabelPosition];
                         
                         [UIView animateWithDuration:lowSignalPeriod/2
                                          delay:lowSignalPeriod
                                          options:UIViewAnimationCurveEaseIn
                                          animations:^{
                                              //move title in
                                              [runTitle setFrame:orgTitleLabelPosition];
                                              //move low signal out
                                              [lowSignalLabel setFrame:runTitleDestRect];
                                          }
                                          completion:^(BOOL finished) {
                                              //call this method again if still playing low signal
                                              if(lowSignal)
                                                  [self lowSignalAnimation];
                                              else
                                              {
                                                  animatingLowSignal = false;
                                                  [lowSignalLabel setHidden:true];
                                              }
                                          }];
                          
                     }];
    
    
}

-(void)goalAchievedAnimation
{
    //animation to slide in from the right
    
    //return right away if called during pause
    if(paused || !run.live || animatingLowSignal)
        return;
    
    //set low signal to org position to right of screen
    CGRect goalOrgRect = orgTitleLabelPosition;
    goalOrgRect.origin = CGPointMake(orgTitleLabelPosition.origin.x + orgTitleLabelPosition.size.width, orgTitleLabelPosition.origin.y);
    [goalAchievedLabel setFrame:goalOrgRect];
    [goalAchievedLabel setHidden:false];
    
    CGRect runTitleDestRect = orgTitleLabelPosition;
    runTitleDestRect.origin = CGPointMake(orgTitleLabelPosition.origin.x - orgTitleLabelPosition.size.width, orgTitleLabelPosition.origin.y);
    
    animatingGoalAchieved = true;
    
    [UIView animateWithDuration:lowSignalPeriod/2
                          delay:lowSignalPeriod
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         //move title out
                         [runTitle setFrame:runTitleDestRect];
                         //move low signal in
                         [goalAchievedLabel setFrame:orgTitleLabelPosition];
                     }
                     completion:^(BOOL finished) {
                         
                         [runTitle setFrame:goalOrgRect];
                         [goalAchievedLabel setFrame:orgTitleLabelPosition];
                         
                         [UIView animateWithDuration:lowSignalPeriod/2
                                               delay:lowSignalPeriod
                                             options:UIViewAnimationCurveEaseIn
                                          animations:^{
                                              //move title in
                                              [runTitle setFrame:orgTitleLabelPosition];
                                              //move low signal out
                                              [goalAchievedLabel setFrame:runTitleDestRect];
                                          }
                                          completion:^(BOOL finished) {
                                              //call this method again if still playing low signal
                                              if(goalAchieved)
                                                  [self goalAchievedAnimation];
                                              else
                                              {
                                                  animatingGoalAchieved = false;
                                                  [goalAchievedLabel setHidden:true];
                                              }
                                          }];
                         
                     }];
    
    
}

-(void)setLabelsForUnits
{
    UserPrefs * curSettings = [delegate curUserPrefs];
    BOOL isMetric = [[curSettings metric] boolValue];
    BOOL showSpeed = [[curSettings showSpeed] boolValue];
        
    //need to reset kmselection in order to gaurantee not above array count
    [self resetPaceSelection];
    
    //need to reload annotations regardless since showspeed or metric could have changed
    if([mapAnnotations count] > 0)
    {
        [fullMap removeAnnotations:mapAnnotations];
        [mapAnnotations removeAllObjects];
    }
    [self drawAllAnnotations];
    
    NSString *distanceUnitText = [curSettings getDistanceUnit];
    NSString * paceUnitText = [curSettings getPaceUnit];
    
    [paceUnitLabel1 setText:paceUnitText];
    [paceUnitLabel2 setText:paceUnitText];
    
    //change pace to speed if necessary
    if([[curSettings showSpeed] boolValue])
    {
        [avgPaceTitle setText:NSLocalizedString(@"PaceTitleForSpeed", "Logger title for speed")];
        [currentPaceLabel setText:NSLocalizedString(@"CurrentPaceTitleForSpeed", "Logger title for current speed")];
    }
    else
    {
        [avgPaceTitle setText:NSLocalizedString(@"PaceTitle", "Logger title for pace")];
        [currentPaceLabel setText:NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace")];
    }
    
    [distanceUnitLabel setText:distanceUnitText];
    [ghostDistanceUnitLabel setText:distanceUnitText];
    
    if(!run.live)
    {
        //set title
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        
        if(run.name)
        {
            //special name from target
            [runTitle setText:[NSString stringWithFormat:@"%@ • %@", run.name, [dateFormatter stringFromDate:run.date]]];
        }
        else
        {
            [runTitle setText:[NSString stringWithFormat:@"%.2f %@ • %@", [RunEvent getDisplayDistance:run.distance withMetric:[curSettings.metric integerValue]], distanceUnitText, [dateFormatter stringFromDate:run.date]]];
        }
    }
    else{
        //live name
        [runTitle setText:run.shortname];
    }
    
    //ensure it is visible
    [runTitle setHidden:false];
    runTitle.alpha = 1.0f;
    
    //need to ensure last km label is correct and values are changes
    [self updateHUD];
    
    //avg pace value will not change since only updating every 3 seconds in setPaceLabels so
    NSString * stringToSetTime = [RunEvent getPaceString:run.avgPace withMetric:isMetric showSpeed:showSpeed];
    [paceLabel setText:stringToSetTime];
}


-(void)setPaceLabels
{
    //responible for two bottom sections
    
    UserPrefs * curSettings = [delegate curUserPrefs];
    BOOL showSpeed = [[curSettings showSpeed] boolValue];
    BOOL isMetric = [[curSettings metric] integerValue];
    NSString *distanceUnitText = [curSettings getDistanceUnit];
    
    //this sort of a hack because if metric is changed, selectedKm is wrong, however, notification takes longer than tick() to call selector so we have to address it here where it would fail in the this where selectedKM > mile array
    if(selectedKmIndex > (isMetric ? [run.kmCheckpoints count] : [run.impCheckpoints count]))
    {
        selectedKmIndex = (isMetric ? [run.kmCheckpoints count]-1 : [run.impCheckpoints count]-1);
    }
    
    //update avg pace every 3 seconds only
    if((NSInteger)run.time % avgPaceUpdatePeriod == 0)
    {
        NSString * stringToSetTime = [RunEvent getPaceString:run.avgPace withMetric:isMetric showSpeed:showSpeed];
        [paceLabel setText:stringToSetTime];
    }
    
    
    //current pace/selected pace
    CLLocationMeta * selectedMeta;
    NSString * selectedPaceLabel;
    NSString * selectedPaceString;
    if([[run posMeta] count] == 0)
    {
        // no positions logged yet
        //change pace to speed if necessary
        if([[curSettings showSpeed] boolValue])
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitleForSpeed", "Logger title for current speed");
        else
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = [RunEvent getPaceString:0 withMetric:isMetric showSpeed:showSpeed];
    }
    else if(!kmPaceShowMode && !selectedPaceShowMode)
    {
        // current pace
        selectedMeta = [[run posMeta] lastObject];
        //change pace to speed if necessary
        if([[curSettings showSpeed] boolValue])
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitleForSpeed", "Logger title for current speed");
        else
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = [RunEvent getPaceString:selectedMeta.pace withMetric:isMetric showSpeed:showSpeed];
        //if not update to date, leave default string
        if([selectedMeta time] < run.time - barPeriod)
            selectedPaceString = [RunEvent getPaceString:0 withMetric:isMetric showSpeed:showSpeed];
            
    }
    else if(kmPaceShowMode){
        
        // just display current pace
        selectedMeta = [[run posMeta] lastObject];
        //change pace to speed if necessary
        if([[curSettings showSpeed] boolValue])
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitleForSpeed", "Logger title for current speed");
        else
            selectedPaceLabel = NSLocalizedString(@"CurrentPaceTitle", "Logger title for current pace");
        selectedPaceString = [RunEvent getPaceString:selectedMeta.pace withMetric:isMetric showSpeed:showSpeed];
        //if not update to date, leave default string
        if([selectedMeta time] < run.time - barPeriod)
            selectedPaceString = [RunEvent getPaceString:0 withMetric:isMetric showSpeed:showSpeed];
        
    }
    else if(selectedPaceShowMode){
        
        //selection mode of one bar
        selectedMeta = [[run minCheckpointsMeta] objectAtIndex:selectedMinIndex];
        selectedPaceLabel = [RunEvent getTimeString:selectedMeta.time];
        selectedPaceString = [RunEvent getPaceString:selectedMeta.pace withMetric:isMetric showSpeed:showSpeed];
    }
    [currentPaceLabel setText:selectedPaceLabel];
    [currentPaceValue setText:selectedPaceString];
    
    
    //set mile or km in list
    if(isMetric)
    {
        //set last 3 kms
        if([[run kmCheckpointsMeta] count] == 0)
        {
            //no km's so far, just set lastKm to be time
            
            //set the label to say 'KM 4' or 'Km 17'
            [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, 1]];
            
            //load current
            [lastKmPace setText:[RunEvent getCurKMPaceString:run.time]];
            
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
            
            //need current time for km to lastKMLabel
            NSTimeInterval timeToAdjust = 0;
            if([[run kmCheckpointsMeta] count] > selectedKmIndex - 1)
            {
                CLLocationMeta * priorKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex - 1];
                //get distance from km just by looking at index
                timeToAdjust = priorKmMeta.time;
            }
            NSString * paceForCurrentIndex = [RunEvent getCurKMPaceString:(run.time - timeToAdjust)];
            [lastKmPace setText:paceForCurrentIndex];
            
            //load old values
            NSString * paceForOld;
            if(selectedKmIndex - 1  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace1 setText:paceForOld];
            if(selectedKmIndex - 2  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace2 setText:paceForOld];
            if(selectedKmIndex - 3  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
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
            NSString * paceForCurrentIndex = [RunEvent getPaceString:[selectionKmMeta pace] withMetric:true showSpeed:false];
            [lastKmPace setText:paceForCurrentIndex];
            
            //load old values
            NSString * paceForOld;
            if(selectedKmIndex - 1  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace1 setText:paceForOld];
            if(selectedKmIndex - 2  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace2 setText:paceForOld];
            if(selectedKmIndex - 3  >= 0)
            {
                oldKMMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
                paceForOld = [RunEvent getPaceString:[oldKMMeta pace] withMetric:true showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace3 setText:paceForOld];
        }
    }
    else
    {
        
        //set last 3 mile
        if([[run impCheckpointsMeta] count] == 0)
        {
            //no km's so far, just set lastKm to be time
            
            //set the label to say 'KM 4' or 'Km 17'
            [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, 1]];
            
            //load current
            [lastKmPace setText:[RunEvent getCurKMPaceString:run.time]];
            
            //set old to be empty
            NSString * paceForOld = @"";
            [oldpace1 setText:paceForOld];
            [oldpace2 setText:paceForOld];
            [oldpace3 setText:paceForOld];
        }
        else if(selectedKmIndex == [[run impCheckpointsMeta] count])
        {
            //show current km in lastKmLabel
            
            CLLocationMeta * oldMileMeta;
            //get distance from km just by looking at index
            
            //set the label to say 'KM 4' or 'Km 17'
            [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d", distanceUnitText, selectedKmIndex + 1]];
            
            //need current time mile to lastKMLabel
            NSTimeInterval timeToAdjust = 0;
            
            if([[run impCheckpointsMeta] count] > selectedKmIndex - 1)
            {
                CLLocationMeta * priorMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex - 1];
                //get distance from km just by looking at index
                timeToAdjust = priorMileMeta.time;
            }
            //show current time in the current mile
            NSString * paceForCurrentIndex = [RunEvent getCurKMPaceString:(run.time - timeToAdjust)];
            [lastKmPace setText:paceForCurrentIndex];
            
            //load old values
            NSString * paceForOld;
            if(selectedKmIndex - 1  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace1 setText:paceForOld];
            if(selectedKmIndex - 2  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace2 setText:paceForOld];
            if(selectedKmIndex - 3  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace3 setText:paceForOld];
        }
        else{
            //showing only prior kms, since selection is not the last one
            
            CLLocationMeta * selectionMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex];
            CLLocationMeta * oldMileMeta;
            //get distance from km just by looking at index
            
            //set the label to say 'KM 4' or 'Km 17'
            [lastKmLabel setText:[NSString stringWithFormat:@"%@ %d ", distanceUnitText, selectedKmIndex + 1]];
            
            //load current
            NSString * paceForCurrentIndex = [RunEvent getPaceString:[selectionMileMeta pace] withMetric:false showSpeed:false];
            [lastKmPace setText:paceForCurrentIndex];
            
            //load old values
            NSString * paceForOld;
            if(selectedKmIndex - 1  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace1 setText:paceForOld];
            if(selectedKmIndex - 2  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-2];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace2 setText:paceForOld];
            if(selectedKmIndex - 3  >= 0)
            {
                oldMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-3];
                paceForOld = [RunEvent getPaceString:[oldMileMeta pace] withMetric:false showSpeed:false];
            }
            else
                paceForOld = @"";
            [oldpace3 setText:paceForOld];
        }
    }
}


-(void)updateHUD
{
    //Update Pace
    [self setPaceLabels];

    //set time dependant vars except pace
    BOOL isMetric = [[[delegate curUserPrefs] metric] integerValue];
    
    //set all 3 labels
    [distanceLabel setText:[NSString stringWithFormat:@"%.2f", [RunEvent getDisplayDistance:run.distance withMetric:isMetric]]];
    NSString * stringToSetTime = [RunEvent getTimeString:run.time];
    [timeLabel setText:stringToSetTime];
    [caloriesLabel setText:[NSString stringWithFormat:@"%.0f", run.calories]];
    
    //update ghosts distance if necessary
    if(run.ghost)
    {
        //find associated run position for current run time and display in label
        NSInteger index = [self indexForGhostRunAtTime:run.time];
        
        if(index > 0)
        {
            CLLocationMeta * ghostPos = [run.associatedRun.posMeta objectAtIndex:index];
            
            //set ghost label
            [ghostDistance setText:[NSString stringWithFormat:@"%.2f", [RunEvent getDisplayDistance:ghostPos.distance withMetric:isMetric]]];
        }
        
    }
    
    //update start header cell in menu
    //[delegate updateRunTimeForMenu:stringToSetTime];
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //last should the last object in run.pos
    CLLocation *newLocation = [locations lastObject];
    
    //NSLog(@"%d  - lat%f - lon%f - accur%f - alt%f - speed%f", [run.pos count], newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy, newLocation.altitude, newLocation.speed);
    
    
    //see if first pos since unpause
    if(needsStartPos)
    {
        //needs at least one position to calculate distances from
        //add position and focus in on it
    
        needsStartPos = false;
        
        //no pace
        [self addPosToRun:newLocation withPace:0 withCumulativeDistance:run.distance];
        
        //deter accuracy for low signal
        [self evalAccuracy:newLocation.horizontalAccuracy];
        
        //auto zoom and reload map icon
        [self autoZoomMap:newLocation animated:false withMap:fullMap];
        [self zoomMapToEntireRun:iconMap];
        
        //add start flag if necessary
        //if it is the first spot, add annotation for start
        if([mapAnnotations count] == 0)
        {
            StartAnnotation * firstAnnotation = [[StartAnnotation alloc] init];
            firstAnnotation.mileName = NSLocalizedString(@"StartFlagText", @"map annotation flag - start");
            firstAnnotation.paceString = [RunEvent getTimeString:0];
            if([run.pos count])
            {
                firstAnnotation.mileCoord = newLocation.coordinate;
            }
            //add to array
            [mapAnnotations addObject:firstAnnotation];
            //actually add to map
            [fullMap addAnnotation:firstAnnotation];
        }
    }
    else{
        
        //just add to queue
        [posQueue addObject:newLocation];
        
        //posQueue builds up until unpause autopause
        if(pausedForAuto)
        {
            //only unpause after minimum 3 updates
            if([posQueue count] > 2)
            {
                //gaurunteed to be 3 locations here
        
                CLLocation  * thirdLast = [posQueue objectAtIndex:[posQueue count] -3];
                CLLocation * secondLast = [posQueue objectAtIndex:[posQueue count] -2];
                CLLocation * lastInQueue = [posQueue lastObject];
                
                
                CLLocationDistance distance2 = [thirdLast distanceFromLocation:secondLast];
                NSTimeInterval interval2 = [secondLast.timestamp timeIntervalSinceDate:thirdLast.timestamp];
                
                CLLocationSpeed speed2 = distance2 / interval2;
                
                CLLocationDistance distance1 = [secondLast distanceFromLocation:lastInQueue];
                NSTimeInterval interval1 = [lastInQueue.timestamp timeIntervalSinceDate:secondLast.timestamp];
                
                CLLocationSpeed speed1 = distance1 / interval1;
                
                if(speed1 > minSpeedUnpause && speed2 > minSpeedUnpause)
                {
                    //unpause
                    [delegate pauseAnimation:nil];
                    [self audioCue:SpeechResume];
                    return;
                }
                //else try again next update and delete first object
                
                //trim array to keep only 2 objects, so that there are 3 for next update
                [posQueue removeObjectAtIndex:0];
            }
        }
    }

 }


#pragma mark - Map Custom Functions

-(void) autoZoomMap:(CLLocation*)newLocation animated:(BOOL)animate withMap:(MKMapView*)mapToZoom
{
    //return if in background or not necessary
    if(inBackground)
        return;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, mapZoomDefault, mapZoomDefault);
    //animated to prevent jumpy
    [mapToZoom setRegion:region animated:animate];
    
    if(mapToZoom == fullMap)
        timeSinceMapCenter = [NSDate timeIntervalSinceReferenceDate];
    
}

-(void)zoomMapToEntireRun:(MKMapView*)mapToZoom
{
    if(inBackground)
        return;
    
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
        
        if(span.latitudeDelta < mapMinSpanForRun)
            span.latitudeDelta = mapMinSpanForRun;
        else
            span.latitudeDelta = span.latitudeDelta * mapSpanMultipler;
        if(span.longitudeDelta < mapMinSpanForRun)
            span.longitudeDelta = mapMinSpanForRun;
        else
            span.longitudeDelta = span.longitudeDelta * mapSpanMultipler;
        
        //make region at center coord with a span determined by the bottom left and top right points
        MKCoordinateRegion region = MKCoordinateRegionMake(centerCoord, span);
        
        //ensure that map is loaded before capturing view
        [mapToZoom setRegion:region animated:false];
        
    }
    
    if(mapToZoom == iconMap)
        timeSinceMapIconRefresh = [NSDate timeIntervalSinceReferenceDate];
    
}

-(void)mapIconFinishedForFinishTapped
{
    
    if(timeSinceLastMapLoadFinish + mapLoadSinceFinishWait > [NSDate timeIntervalSinceReferenceDate])
    {
        //come back every 1s to see if time is at least 2 seconds since the last map finish load
        [self performSelector:@selector(mapIconFinishedForFinishTapped) withObject:nil afterDelay:1];
        return;
    }
    
    //NSLog(@"saving map thumbnail");
    waitingForMapToLoad = false;
    
    //ensure legal is gone
    [self removeLegalLabelForMap:iconMap];
    
    //ensure user location is hidden
    [iconMap setShowsUserLocation:false];
    
    //set the run to have the correct picture in table cell
    run.thumbnail = [Util imageWithView:iconMap withSize:iconMap.frame.size];
    
    //reset
    [iconMap setShowsUserLocation:true];
    
    //stop loading indicator
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //go back to menu and add to table at top
    [delegate finishedRun:run];
}

-(void)resetMap
{
    if([mapOverlays lastObject] == nil)
        mapOverlays = [[NSMutableArray alloc] initWithCapacity:100];
    if([mapAnnotations lastObject] == nil)
        mapAnnotations = [[NSMutableArray alloc] initWithCapacity:100];
    if([mapGhostOverlays lastObject] == nil)
        mapGhostOverlays = [[NSMutableArray alloc] initWithCapacity:100];
    
    
    [fullMap removeAnnotations:mapAnnotations];
    [fullMap removeOverlays:mapOverlays];
    [fullMap removeOverlays:mapGhostOverlays];
    [iconMap removeOverlays:mapOverlays];
    [mapAnnotations removeAllObjects];
    [mapOverlays removeAllObjects];
    [mapGhostOverlays removeAllObjects];
    
    //set index to 0 again
    lastPathIndex = 0;
    lastGhostPathIndex = 0;
}

-(void)drawAllAnnotations
{
    if(inBackground)
        return;
    
    //only for full map
    UserPrefs * curSettings = [delegate curUserPrefs];
    BOOL showSpeed = [[curSettings showSpeed] boolValue];
    BOOL isMetric = [[curSettings metric] boolValue];
    NSString *distanceUnitText = [curSettings getDistanceUnit];
    
    //add annotation for start
    //called when live run is first starting as well
    //do not process until run has added at least one position at which time, calcMetrics will have added start
    if([run.pos count] > 0)
    {
        StartAnnotation * firstAnnotation = [[StartAnnotation alloc] init];
        firstAnnotation.mileName = NSLocalizedString(@"StartFlagText", @"map annotation flag - start");
        firstAnnotation.paceString = [RunEvent getTimeString:0];
        if([run.pos count])
        {
            CLLocation * first = [run.pos objectAtIndex:0];
            firstAnnotation.mileCoord = first.coordinate;
        }
        //add to array
        [mapAnnotations addObject:firstAnnotation];
        //actually add to map
        [fullMap addAnnotation:firstAnnotation];
    }
    
    if(isMetric)
    {
        //need both pos and meta for KM to get pace for annotation display
        for(int i = 0; i < [[run kmCheckpoints] count]; i++)
        {
            CLLocation * kmPos = [[run kmCheckpoints] objectAtIndex:i];
            CLLocationMeta * kmMeta = [[run kmCheckpointsMeta] objectAtIndex:i];
            
            //add annotation
            KMAnnotation * newAnnotation = [[KMAnnotation alloc] init];
            
            //km is just the index plus 1
            newAnnotation.kmName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, i + 1];
            newAnnotation.paceString = [RunEvent getPaceString:[kmMeta pace] withMetric:true showSpeed:showSpeed];
            newAnnotation.kmCoord = [kmPos coordinate];
            
            //add to array
            [mapAnnotations addObject:newAnnotation];
            //actually add to map
            [fullMap addAnnotation:newAnnotation];
            
        }
    }
    else
    {
        //need both pos and meta for KM to get pace for annotation display
        for(int i = 0; i < [[run impCheckpoints] count]; i++)
        {
            CLLocation * milePos = [[run impCheckpoints] objectAtIndex:i];
            CLLocationMeta * mileMeta = [[run impCheckpointsMeta] objectAtIndex:i];
            
            //add annotation
            MileAnnotation * newAnnotation = [[MileAnnotation alloc] init];
            
            //km is just the index plus 1
            newAnnotation.mileName = [NSString stringWithFormat:@"%@ %d", distanceUnitText, i + 1];
            newAnnotation.paceString = [RunEvent getPaceString:[mileMeta pace] withMetric:false showSpeed:showSpeed];
            newAnnotation.mileCoord = [milePos coordinate];
            
            //add to array
            [mapAnnotations addObject:newAnnotation];
            //actually add to map
            [fullMap addAnnotation:newAnnotation];
            
        }
    }
    
    //add annotation for finish if it is historical
    //need at least two points for finish flag
    if(!run.live && [run.pos count] > 1)
    {
        FinishAnnotation * lastAnnotation = [[FinishAnnotation alloc] init];
        lastAnnotation.mileName = NSLocalizedString(@"FinishFlagText", @"map annotation flag - finish");
        lastAnnotation.paceString = [RunEvent getTimeString:run.time];
        //last object of pos not min or km
        CLLocation * last = [run.pos lastObject];
        lastAnnotation.mileCoord = last.coordinate;
        //add to array
        [mapAnnotations addObject:lastAnnotation];
        //actually add to map
        [fullMap addAnnotation:lastAnnotation];
    }
}

-(void)drawMapGhostPath:(BOOL)historical
{
    if(inBackground)
        return;
    
    //find associated run position for current run time
    NSInteger ghostPosToUse = [self indexForGhostRunAtTime:run.time];
    
    if(!run.ghost || ghostPosToUse < 1)
    {
        //don't draw 
        return;
    }
    
    BOOL discontinuousPathBreak = false;
    BOOL continuousPathBreak = false;
    NSInteger lastConnectedIndex = lastGhostPathIndex;
    NSInteger numberForLine = 0;
    
    //cycle through all paths until all paths drawn
    do
    {
        CLLocationCoordinate2D coordinates[mapPathSize];
        discontinuousPathBreak = false;
        continuousPathBreak = false;
        numberForLine = 0;
        
        //stop drawing if on last position or else the for loop is broken on path breaks
        for (NSInteger i = lastConnectedIndex; i < ghostPosToUse; i++)
        {
            CLLocation *location = [run.associatedRun.pos  objectAtIndex:i];
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            coordinates[numberForLine] = coordinate;
            
            //dislocate lines if on pause point
            for(CLLocation * pausePoint in run.associatedRun.pausePoints)
            {
                if((pausePoint.coordinate.latitude == coordinate.latitude) &&
                   (pausePoint.coordinate.longitude == coordinate.longitude))
                {
                    //set next point to start at next index
                    lastConnectedIndex = i+1;
                    discontinuousPathBreak = true;
                    //break out of for loop
                    break;
                }
            }
            
            numberForLine++;
            
            //split line for line size if it is on last index (4) for size 5
            if(numberForLine == mapPathSize - 1)
            {
                //set last connected to be one less so that lines get connected
                lastConnectedIndex = i;
                continuousPathBreak = true;
            }
            
            //break out of for loop if going on to next line
            if(discontinuousPathBreak || continuousPathBreak)
                break;
        }
        
        MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberForLine];
        //must remove previous line first,if gradually adding
        //historical does not need this
        if(numberForLine < mapPathSize && numberForLine > 1 && [mapGhostOverlays lastObject] && !historical)
        {
            [fullMap removeOverlay:[mapGhostOverlays lastObject]];
            [mapGhostOverlays removeLastObject];
        }
        [mapGhostOverlays addObject:polyLine];
        
        //add to both maps
        [fullMap addOverlay:polyLine];
        
    }while(discontinuousPathBreak || continuousPathBreak);
    
    lastGhostPathIndex = lastConnectedIndex;
}

-(void)drawMapPath:(BOOL)historical
{
    if(inBackground)
        return;
    
    NSInteger numberOfSteps = [run.pos count];
    if(numberOfSteps == 0)
        return;
    
    BOOL discontinuousPathBreak = false;
    BOOL continuousPathBreak = false;
    NSInteger lastConnectedIndex = lastPathIndex;
    NSInteger numberForLine = 0;
    
    //cycle through all paths until all paths drawn
    do 
    {
        CLLocationCoordinate2D coordinates[mapPathSize];
        discontinuousPathBreak = false;
        continuousPathBreak = false;
        numberForLine = 0;
        
        //stop drawing if on last position or else the for loop is broken on path breaks
        for (NSInteger i = lastConnectedIndex; i < numberOfSteps; i++)
        {
            CLLocation *location = [run.pos  objectAtIndex:i];
            
            CLLocationMeta *locationMeta = [run.posMeta  objectAtIndex:i];
            CLLocationDistance testAlt = location.altitude;
            //NSLog(@"Altitude @ %.0fs : %.1f m    - accuracy:%.1f", [locationMeta time], testAlt, location.verticalAccuracy);
            
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            coordinates[numberForLine] = coordinate;
            
            //dislocate lines if on pause point
            for(CLLocation * pausePoint in run.pausePoints)
            {
                if((pausePoint.coordinate.latitude == coordinate.latitude) &&
                   (pausePoint.coordinate.longitude == coordinate.longitude))
                {
                    //set next point to start at next index
                    lastConnectedIndex = i+1;
                    discontinuousPathBreak = true;
                    //break out of for loop
                    break;
                }
            }
            
            numberForLine++;
            
            //split line for line size if it is on last index (4) for size 5 
            if(numberForLine == mapPathSize - 1)
            {
                //set last connected to be one less so that lines get connected
                lastConnectedIndex = i;
                continuousPathBreak = true;
            }
            
            //break out of for loop if going on to next line
            if(discontinuousPathBreak || continuousPathBreak)
                break;
        }
        
        //only add if there is something
        if(numberForLine > 0)
        {
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberForLine];
            //must remove previous line first
            //historical does not need this
            //cannot do this with discontinuous path
            if(numberForLine <  mapPathSize && numberForLine > 1 && [mapOverlays lastObject] && !historical && !discontinuousPathBreak)
            {
                [iconMap removeOverlay:[mapOverlays lastObject]];
                [fullMap removeOverlay:[mapOverlays lastObject]];
                [mapOverlays removeLastObject];
            }
            [mapOverlays addObject:polyLine];
            
            //add to both maps
            [fullMap addOverlay:polyLine];
            [iconMap addOverlay:polyLine];
        }
        
    }while(discontinuousPathBreak || continuousPathBreak);
    
    lastPathIndex = lastConnectedIndex;
}


-(void)removeLegalLabelForMap:(MKMapView*)mapToRemove
{
    //move legal label off screen
    UIView *legalView = nil;
    for (UIView *subview in mapToRemove.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            // Legal label iOS 6
            legalView = subview;
        }
    }
    CGRect legalFrame = legalView.frame;
    legalFrame.origin.y += 200;
    [legalView setFrame:legalFrame];
}

#pragma mark - MapKit Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(mapView == iconMap)
    {
        MKAnnotationView* annotationView = [mapView viewForAnnotation:userLocation];
        annotationView.canShowCallout = NO;

    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    //cpu intensive only search if necessary
    if(run.ghost)
    {
        //may be requesting ghost run, search array for id
        for(MKPolyline * ghostLine in mapGhostOverlays)
        {
            if(ghostLine == overlay)
            {
                //return blue line
                MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
                polylineView.strokeColor = [Util blueColour];
                
                //should be fixed line
                polylineView.lineWidth = mapPathWidth;
                
                return polylineView;
            }
        }
    }
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [Util redColour];
    //should be fixed line
    polylineView.lineWidth = mapPathWidth;
    
    //for icon map only
    if(mapView == iconMap)
    {
        //should be fixed line
        polylineView.lineWidth = mapIconPathWidth;
    }
    
    //check if it is selectedmapoverlay to modify
    if(mapSelectionOverlay == overlay)
    {
        polylineView.strokeColor = [UIColor lightGrayColor];
        polylineView.lineWidth = mapIconPathWidth + 2; // to highlight
    }
    
    return polylineView;
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
        [fullMap dequeueReusableAnnotationViewWithIdentifier:kmAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:kmAnnotationIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            pinView = customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        //ensure color is correct
        pinView.pinColor = MKPinAnnotationColorRed;
        return pinView;
    }
    else if ([annotation isKindOfClass:[MileAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString *mileAnnotationIdentifier = @"mileAnnotationIdentifier";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [fullMap dequeueReusableAnnotationViewWithIdentifier:mileAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:mileAnnotationIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            pinView = customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        
        //ensure color is correct
        pinView.pinColor = MKPinAnnotationColorRed;
        return pinView;
    }
    else if ([annotation isKindOfClass:[StartAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString *startAnnotationIdentifier = @"startAnnotationIdentifier";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [fullMap dequeueReusableAnnotationViewWithIdentifier:startAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:startAnnotationIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            pinView = customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        //green color
        
        pinView.pinColor = MKPinAnnotationColorGreen;
        return pinView;
    }
    else if ([annotation isKindOfClass:[FinishAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString *finishAnnotationIdentifier = @"finishAnnotationIdentifier";
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)
        [fullMap dequeueReusableAnnotationViewWithIdentifier:finishAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:finishAnnotationIdentifier];
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            pinView = customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        //purple color
        pinView.pinColor = MKPinAnnotationColorPurple;
        
        return pinView;
    }
    
    
    return nil;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    //NSLog(@"finished loading tiles..");
    
    if(waitingForMapToLoad)
    {
        loadingMapTiles--;
        timeSinceLastMapLoadFinish = [NSDate timeIntervalSinceReferenceDate];
    }
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    //NSLog(@"start loading tiles..");
    
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
    //determine if user touched full screen map or not
    if(mapView == fullMap)
    {
        //if we haven't autozoomed in at least 1 second record map touch as from user
        if(timeSinceMapCenter < [NSDate timeIntervalSinceReferenceDate] - 1)
        {
            timeSinceMapTouch = [NSDate timeIntervalSinceReferenceDate];
        }
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
    
    
    //NSLog(@"Scroll @ %.f with cache @ %d, %d min with plot start = %f , end = %f , %d min", curViewOffset, lastCacheMinute, curViewMinute, startLocation, endLocation, endLocationMinute);
    

    if(curViewMinute < lastCacheMinute)
    {
        //reload to the left
        lastCacheMinute = curViewMinute - (paceGraphSplitObjects - paceGraphSplitLoadOffset);
        //constrain to zero
        if(lastCacheMinute < 0)
            lastCacheMinute = 0;
        
        //NSLog(@"Reload to left @ %d", lastCacheMinute);
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(paceGraphSplitObjects)];
        
        plotSpace.xRange = newRange;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
        //barPlot.baseValue = CPTDecimalFromDouble(paceGraphBarBasePrecent * [self maxYForChart]);//needs to be adjust with maxY
        [barPlot reloadData];
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [chart frame];
        //newGraphViewRect.origin.x -= [self convertToX:paceGraphSplitObjects - paceGraphSplitLoadOffset];
        newGraphViewRect.origin.x = [self convertToX:lastCacheMinute];
        [chart setFrame:newGraphViewRect];
    }
    else if(curViewMinute > lastCacheMinute + paceGraphSplitObjects - paceGraphSplitLoadOffset &&
            !(curViewMinute + paceGraphSplitObjects - paceGraphSplitLoadOffset >= [[run minCheckpoints] count]))
    {
        //reload to right
        lastCacheMinute = curViewMinute;
        //constrain to length of chart
        if(lastCacheMinute >= [[run minCheckpoints] count] - (paceGraphSplitObjects - paceGraphSplitLoadOffset))
            lastCacheMinute = [[run minCheckpoints] count] - (paceGraphSplitObjects - paceGraphSplitLoadOffset);
        
        //NSLog(@"Reload to right @ %d", lastCacheMinute);
        
        CPTPlotRange * newRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(lastCacheMinute) length:CPTDecimalFromFloat(paceGraphSplitObjects)];
        
        plotSpace.xRange = newRange;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
        //barPlot.baseValue = CPTDecimalFromDouble(paceGraphBarBasePrecent * [self maxYForChart]);//needs to be adjust with maxY
        [barPlot reloadData];
        
        //move the view with the scroll view
        CGRect newGraphViewRect = [chart frame];
        //newGraphViewRect.origin.x += [self convertToX:paceGraphSplitObjects - paceGraphSplitLoadOffset];
        newGraphViewRect.origin.x = [self convertToX:lastCacheMinute];
        [chart setFrame:newGraphViewRect];
    }
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    //to allow menu view to scroll to top
    return false;
}


#pragma mark - KM Selection methods

-(NSInteger) getMinBarIndexForKMSelecton:(NSInteger) kmIndex
{
    BOOL isMetric = [[[ delegate curUserPrefs] metric] integerValue];
    
    if(isMetric)
    {
        if([[run kmCheckpointsMeta] count] > kmIndex - 1 && kmIndex > 0)
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
    }
    else{
        
        if([[run impCheckpointsMeta] count] > kmIndex - 1 && kmIndex > 0)
        {
            CLLocationMeta * previousMile = [[run impCheckpointsMeta] objectAtIndex:kmIndex-1];
            NSTimeInterval mileStartTime = [previousMile time];
            
            //get all minutes within these bounds
            NSTimeInterval time;
            NSInteger minIndex = 0;
            
            for (CLLocationMeta * min in [run minCheckpointsMeta])
            {
                time = [min time];
                
                if(time > mileStartTime)
                    return minIndex;
                
                minIndex++;
            }
            
            return  [[run minCheckpointsMeta] count] - 1;
        }
    }
    return 0;
}


-(NSInteger) getBarCountForKMSelection:(NSInteger) kmIndex
{
    
    BOOL isMetric = [[[ delegate curUserPrefs] metric] integerValue];
    
    if(isMetric)
    {
        //km 
        if([[run kmCheckpointsMeta] count] > kmIndex && kmIndex >= 0)
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
    }
    else
    {
        //miles instead
        if([[run impCheckpointsMeta] count] > kmIndex && kmIndex >= 0)
        {
            CLLocationMeta * selectedMile = [[run impCheckpointsMeta] objectAtIndex:kmIndex];
            NSTimeInterval mileEndTime = [selectedMile time];
            NSTimeInterval mileStartTime;
            if([[run impCheckpointsMeta] count] > 0 && kmIndex-1 >= 0)
            {
                CLLocationMeta * previousMile = [[run impCheckpointsMeta] objectAtIndex:kmIndex-1];
                mileStartTime = [previousMile time];
            }
            else
            {
                mileStartTime = 0;
            }
            
            //get all minutes within these bounds
            NSTimeInterval time;
            NSInteger numBars = 0;
            
            for (CLLocationMeta * min in [run minCheckpointsMeta])
            {
                time = [min time];
                
                if(time > mileStartTime && time < mileEndTime)
                    numBars++;
                
            }
            
            return  numBars;
        }
        else{
            //next km doesnt exist to get end time
            NSTimeInterval mileStartTime;
            if([[run impCheckpointsMeta] count]  > 0 && kmIndex-1 >= 0)
            {
                CLLocationMeta * previousMile = [[run impCheckpointsMeta] objectAtIndex:kmIndex-1];
                mileStartTime = [previousMile time];
            }
            else
            {
                mileStartTime = 0;
            }
            
            //get all minutes within these bounds
            NSTimeInterval time;
            NSInteger numBars = 0;
            
            for (CLLocationMeta * min in [run minCheckpointsMeta])
            {
                time = [min time];
                
                if(time > mileStartTime)
                    numBars++;
                
            }
            
            return  numBars;
        }
    }
    
    return [[run minCheckpointsMeta] count];
}

-(void)resetPaceSelection
{
    //disable selection mode
    kmPaceShowMode = false;
    selectedPaceShowMode = false;
    //remove overlay if it is there
    [iconMap removeOverlay:mapSelectionOverlay];
    mapSelectionOverlay = nil;
    numMinutesAtKmSelected = -1;
    selectedMinIndex = [[run minCheckpointsMeta] count] - 1;
    BOOL isMetric = [[[ delegate curUserPrefs] metric] integerValue];
    selectedKmIndex = (isMetric ? [[run kmCheckpointsMeta] count] :[[run impCheckpointsMeta] count]);
}

#pragma mark - Manage Pace Chart

-(CGFloat)maxYForChart
{
    CGFloat maxYPace = 0.0f;
    CGFloat avgPace = 0.0f;
    NSInteger zeroPaces = 0;
    
    //find max
    for(CLLocationMeta * meta in run.minCheckpointsMeta)
    {
        //do not display ridiculous speeds incase they happen
        if(meta.pace > maxYPace && meta.pace < 100)
        {
            maxYPace = meta.pace;
        }
        if(meta.pace <= 0)
            zeroPaces++;
        
        avgPace += meta.pace;
    }
    
    if([run.minCheckpointsMeta count] - zeroPaces > 0)
        avgPace = avgPace / ([run.minCheckpointsMeta count] - zeroPaces);
    
    //constrain to limit of 4x avg pace
    if(maxYPace > avgPace * 4)
        maxYPace = avgPace * 4;
    
    //constraint pace to at least 1 m/s
    if(maxYPace < paceChartMaxYMin)
        maxYPace = paceChartMaxYMin;
    
    
    return maxYPace * (1+paceChartCutoffPercent); //add small amount to not cutoff top
    
}

-(void)updateChartForIndex:(NSInteger)targetMinIndex
{
    //scroll to the destination rect for this minute index
    //scrollviewDidScroll will take care of reloading the chart except for selectPlot
    
    if(!barPlot)
    {
        //if bar graph not yet loaded
        
        //draw bar graph with new data from run
        CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt((lastCacheMinute < 0 ? 0 : lastCacheMinute)) length:CPTDecimalFromInt(paceGraphSplitObjects)];
        [self setupGraphForView:chart withRange:firstRangeToShow];
    }
    else{
        //no adjustments necessary,just display new selected bar
        [selectedPlot reloadData];
    }
    
    //scroll to latest value
    if([[run minCheckpointsMeta] count] * paceGraphBarWidth < paceScroll.frame.size.width)
    {
        //no need to scroll since on first page
    }
    else
    {
        //if index is on last page, scroll to just the whole page
        if(targetMinIndex > [[run minCheckpointsMeta] count] - (paceScroll.frame.size.width / paceGraphBarWidth))
        {
            CGRect animatedDestination = CGRectMake(([[run minCheckpointsMeta] count] * paceGraphBarWidth) - paceScroll.frame.size.width, 0, paceScroll.frame.size.width, paceScroll.frame.size.height);
            [paceScroll scrollRectToVisible:animatedDestination animated:paceGraphAnimated];
        }
        else
        {
            CGRect animatedDestination = CGRectMake((targetMinIndex * paceGraphBarWidth), 0, paceScroll.frame.size.width, paceScroll.frame.size.height);
            [paceScroll scrollRectToVisible:animatedDestination animated:paceGraphAnimated];
        }
    }
}


-(void)updateChart
{
    //called to add data or when loading run
    
    //crashes sometimes if run in background
    if(inBackground)
        return;
    
    //do not animate if the barplot doesn't exist or when the runs are set
    BOOL denyAnimatedScroll = !barPlot;
    
    if(!barPlot)
    {
        //if bar graph not yet loaded
        
        //draw bar graph with new data from run
        lastCacheMinute = [[run minCheckpointsMeta] count] - paceGraphSplitObjects ;
        if(lastCacheMinute < 0)
            lastCacheMinute = 0;
        CPTPlotRange * firstRangeToShow = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(lastCacheMinute) length:CPTDecimalFromInt(paceGraphSplitObjects)];
        [self setupGraphForView:chart withRange:firstRangeToShow];
    }
    else{
        //if loaded, just update ranges
        
        //only set y in case a new value needs to adjust range, x set already for the whole cache
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
        //barPlot.baseValue = CPTDecimalFromDouble(paceGraphBarBasePrecent * [self maxYForChart]);//needs to be adjust with maxY
        
        [barPlot reloadData];
    }
    
    //scroll to latest value
    if([[run minCheckpointsMeta] count] * paceGraphBarWidth < paceScroll.frame.size.width)
    {
        [paceScroll setContentSize:CGSizeMake([[run minCheckpointsMeta] count] * paceGraphBarWidth, paceScroll.frame.size.height)];
        CGRect animatedDestination = CGRectMake(0, 0, paceScroll.frame.size.width, paceScroll.frame.size.height);
        [paceScroll scrollRectToVisible:animatedDestination animated:(denyAnimatedScroll ? false : paceGraphAnimated)];
    }
    else{
        
        //set scroll to be at the end of run
        [paceScroll setContentSize:CGSizeMake([[run minCheckpointsMeta] count] * paceGraphBarWidth, paceScroll.frame.size.height)];
        CGRect animatedDestination = CGRectMake(([[run minCheckpointsMeta] count] * paceGraphBarWidth) - paceScroll.frame.size.width, 0, paceScroll.frame.size.width, paceScroll.frame.size.height);
        [paceScroll scrollRectToVisible:animatedDestination animated:(denyAnimatedScroll ? false : paceGraphAnimated)];
    }
}



-(void)adjustCurrentBar
{
    if([run.minCheckpointsMeta count] > 0 && [run.posMeta count] > 0)
    {
        CLLocationMeta * currentMin = [run.minCheckpointsMeta lastObject];
        //adjust pace to reflect minute
        CLLocationMeta * currentPos = [run.posMeta lastObject];
        
        //adjust pace, only if element is not stale
        if([currentPos time] + calcPeriod > run.time)
            currentMin.pace = currentPos.pace;
        else
            currentMin.pace = 0;
        
        //need to adjust plot range for potentially offscreen bars
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([self maxYForChart])];
        
        if(!kmPaceShowMode && !selectedPaceShowMode)
        {
            selectedMinIndex = [[run minCheckpointsMeta] count] - 1;
            
            [self determineBarColors];
        }
        else
        {
            //decide to switch off selection and zoom back to current pace
            if(timeSinceKmSelection < [NSDate timeIntervalSinceReferenceDate]  - paceSelectionOverrideTime &&
               timeSinceBarSelection < [NSDate timeIntervalSinceReferenceDate]  - paceSelectionOverrideTime)
            {
                [self resetPaceSelection];
                
                CGRect animatedDestination = CGRectMake(([[run minCheckpointsMeta] count] * paceGraphBarWidth) - paceScroll.frame.size.width, 0, paceScroll.frame.size.width, paceScroll.frame.size.height);
                [paceScroll scrollRectToVisible:animatedDestination animated:true];
                
                [self determineBarColors];
            }
        }
        
        //reload data just for this bar
        [barPlot reloadData];
        //must reload both in case the size changes
        [selectedPlot reloadData];
    }
}

-(void)determineBarColors
{
    //if ghost enabled, color label based on who was faster
    if(run.ghost)
    {
        //find associated run position for current run time and display in label
        NSInteger index = [self indexForGhostRunAtTime:run.time];
        
        //ensure ghost has a position
        if(index > 0)
        {
            CLLocationMeta * ghostPos = [run.associatedRun.posMeta objectAtIndex:index];
            CLLocationMeta * lastPos = [run.posMeta lastObject];
            
            if(ghostPos.pace > [lastPos pace])
            {
                //set to blue
                selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util blueColour] CGColor]]];
            }
            else{
                //set to red
                selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
            }
        }
        else if(((int)run.time) % calcPeriod == 0)
        {
            //ensure it is not just an odd time
            selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
        }
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
        CLLocationMeta * lastMeta ;
        NSTimeInterval paceSum = 0;
        
        if(index >= 0)
        {
            lastMeta = [run.posMeta objectAtIndex:index];
            
            //while pos is later than last bar period
            while ((run.time - barPeriod) < [lastMeta time] && index > 0)
            {
                //aggregate pace
                paceSum += [lastMeta pace];
                sumCount++;
                
                index--;
                lastMeta = [run.posMeta objectAtIndex:index];
            }
            
            NSTimeInterval avgPaceInMin = 0;
            if(sumCount > 0)
                avgPaceInMin = paceSum / sumCount;
            
            CLLocationMeta * newMinMeta = [run.minCheckpointsMeta lastObject];
            //adjust current bar and make it official
            newMinMeta.pace = avgPaceInMin; //m/s
            //save real position
            [run.minCheckpoints addObject:[run.pos lastObject]];

            
            //add new currentminute object
            CLLocationMeta * curMin = [[CLLocationMeta alloc] init];
            //set pace to most recent adjusted pace
            lastMeta = [run.posMeta lastObject];
            curMin.pace = [lastMeta pace];
            curMin.time = run.time + barPeriod;
            [run.minCheckpointsMeta addObject:curMin];
        }
    }
    
    //disable selection, update pace labels
    [self resetPaceSelection];
    
    [self determineBarColors];
    
    //then visually update chart and scroll to new minute
    [self updateChart];
    [selectedPlot reloadData];
    
    //speech
    //[self audioCue:SpeechMinute];
}

-(void)setupGraphForView:(CPTGraphHostingView *)hostingView withRange:(CPTPlotRange *)range
{

    //builds, configures and adds bar and selectedplot to chart view
    
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
    
    //x-axis
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    //axis line style
    CPTMutableLineStyle *majorLineStyle = [CPTMutableLineStyle lineStyle];
    majorLineStyle.lineColor = [CPTColor colorWithGenericGray:CPTFloat(0.3)];
    majorLineStyle.lineWidth = CPTFloat(0.0);
    x.axisLineStyle                  = majorLineStyle;
    
    //y-axis
    CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
     
    // add bar plot to view, all bar customization done here
    barPlot = [[CPTBarPlot alloc] init];
    barPlot.fill       = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[UIColor lightGrayColor] CGColor]]];
    CPTMutableLineStyle *barLineStyle = [CPTMutableLineStyle lineStyle];
	barLineStyle.lineWidth = CPTFloat(0.5);
    barPlot.lineStyle = barLineStyle;
    barPlot.barWidth                      = CPTDecimalFromDouble(0.7);
    barPlot.barWidthsAreInViewCoordinates = NO;
    barPlot.barCornerRadius               = CPTFloat(5.0);
    //barPlot.baseValue = CPTDecimalFromDouble(paceGraphBarBasePrecent * [self maxYForChart]);//needs to be adjust with maxY
    //barPlot.barBasesVary = NO;
    //barPlot.barBaseCornerRadius             = CPTFloat(5.0);
    barPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    barPlot.dataSource = self;
    barPlot.identifier = kPlot;
    barPlot.delegate = self;
    
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    //selected Plot
    selectedPlot = [[CPTBarPlot alloc] init];
    selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
    CPTMutableLineStyle *selectedLineStyle = [CPTMutableLineStyle lineStyle];
	selectedLineStyle.lineWidth = CPTFloat(0.5);
    selectedPlot.lineStyle = selectedLineStyle;
    selectedPlot.barWidth                      = CPTDecimalFromDouble(0.7);
    selectedPlot.barCornerRadius               = CPTFloat(5.0);
    //selectedPlot.baseValue = CPTDecimalFromDouble(0.7);
    //selectedPlot.barBaseCornerRadius             = CPTFloat(5.0);
    selectedPlot.cachePrecision = CPTPlotCachePrecisionDouble;
    selectedPlot.dataSource = self;
    selectedPlot.identifier = kSelectedPlot;
    selectedPlot.delegate = self;
    
    [barChart addPlot:selectedPlot toPlotSpace:plotSpace];
    
    //set position of chart view within scrollview to be at start
    CGRect paceGraphRect = chart.frame;
    paceGraphRect.size = CGSizeMake(paceGraphSplitObjects * paceGraphBarWidth, paceScroll.frame.size.height);
    paceGraphRect.origin = CGPointMake(0, 0);
    [chart setFrame:paceGraphRect];

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
    NSNumber *num;
    CLLocationMeta * metaForPos;
    
    if([[run minCheckpointsMeta] count] <= index)
    {
        if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
            switch ( fieldEnum ) {
                case CPTBarPlotFieldBarLocation:
                    //x location of index
                    return [NSNumber numberWithDouble:index+0.5];
                case CPTBarPlotFieldBarTip:
                    if(plot == barPlot)
                        return [NSNumber numberWithDouble:paceGraphBarBasePrecent * [self maxYForChart]];
                    else
                        return [NSNumber numberWithDouble:0];
            }
        }
    }
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                //x location of index
                
                metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                
                //divide time by 60 seconds to get minute index, then minus half a minute to center bar plots
                if(index == [[run minCheckpointsMeta] count] - 1)//load current bar
                    num = [NSNumber  numberWithDouble:[[run minCheckpointsMeta] count]-0.5];
                else
                    num = [NSNumber  numberWithDouble:((metaForPos.time)/barPeriod)-0.5];
                break;
                
            case CPTBarPlotFieldBarTip:
                //y location of bar
                if(!kmPaceShowMode)
                {
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && index == selectedMinIndex))
                    {
                        metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                        if(metaForPos.pace < paceGraphBarBasePrecent * [self maxYForChart])
                            num = [NSNumber numberWithDouble:paceGraphBarBasePrecent * [self maxYForChart]];
                        else
                            num = [NSNumber numberWithDouble:metaForPos.pace];
                    }
                }
                else{
                    if([plot.identifier isEqual: kPlot] ||  ([plot.identifier isEqual: kSelectedPlot] && (index >= selectedMinIndex && index <= (selectedMinIndex + numMinutesAtKmSelected))))
                    {
                        metaForPos = [[run minCheckpointsMeta] objectAtIndex:index];
                        if(metaForPos.pace < paceGraphBarBasePrecent * [self maxYForChart])
                            num = [NSNumber numberWithDouble:paceGraphBarBasePrecent * [self maxYForChart]];
                        else
                            num = [NSNumber numberWithDouble:metaForPos.pace];
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
    //ignore taps of bars that aren't created yet, go to current pace
    if(idx >= [run.minCheckpoints count])
    {
        [self resetPaceSelection];
        [self determineBarColors];
        [selectedPlot reloadData];
        return;
    }
    
    timeSinceBarSelection = [NSDate timeIntervalSinceReferenceDate];
    
    //if ghost enabled, color bar 
    if(run.ghost)
    {
        //some other index
        selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
    }
    
    //set the  minute
    selectedPaceShowMode = true;
    kmPaceShowMode = false;
    numMinutesAtKmSelected = -1;
    selectedMinIndex = idx;
    
    
    //show overlay in iconMap of full minute
    CLLocationMeta * selectedMinMeta = [[run minCheckpointsMeta] objectAtIndex:selectedMinIndex];
    NSTimeInterval startTime = selectedMinMeta.time - barPeriod;
    //ensure it is at least full minute
    if(startTime < 0)
        startTime = 0;
    //add overlay with these times
    NSMutableArray * pointsToSelect = [[NSMutableArray alloc] initWithCapacity:10];
    for(NSTimeInterval timeToFind = startTime ; timeToFind <= selectedMinMeta.time; timeToFind++)
    {
        NSInteger indexToFind = [self indexForRunAtTime:timeToFind];
        if(indexToFind > 0)
        {
            //add meta to array to display
            CLLocation * posToAdd = [run.pos objectAtIndex:indexToFind];
            if(posToAdd)
                [pointsToSelect addObject:posToAdd];

        }
    }
    //we have all the positions to show now add to line and display
    CLLocationCoordinate2D coordinates[[pointsToSelect count]];
    NSInteger indexToAdd = 0;
    for(CLLocation * posToAdd in pointsToSelect)
    {
        CLLocationCoordinate2D coordinate = posToAdd.coordinate;
        coordinates[indexToAdd] = coordinate;
        indexToAdd++;
        if(indexToAdd == [pointsToSelect count])
            break;
    }
    if(indexToAdd > 0)
    {
        //remove if already present from selecting another bar
        if(mapSelectionOverlay)
            [iconMap removeOverlay:mapSelectionOverlay];
        mapSelectionOverlay = [MKPolyline polylineWithCoordinates:coordinates count:indexToAdd];
        //add to icon map
        [iconMap addOverlay:mapSelectionOverlay];
    }
    
    
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
    
    inMapView = false;
    
    [UIView animateWithDuration:duration  delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration animations:^{
        
        //set back to start
        CGRect mapRect;
        mapRect.origin = CGPointMake(0, self.view.frame.size.height - mapDragPullYOffset);//gaurentees position
        mapRect.size =  slideView.frame.size;
        [slideView setFrame:mapRect];
        
    } completion:^(BOOL finished) {
        [self zoomMapToEntireRun:iconMap];
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
    
    inMapView = true;
    
    [UIView animateWithDuration:duration  delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration animations:^{
        
        //open mapview and pin to top
        CGRect mapRect;
        mapRect.size =  slideView.frame.size;
        mapRect.origin = CGPointMake(0, mapViewYOffset - mapDragPullYOffset);//gauranteed position
        [slideView setFrame:mapRect];
        
    } completion:^(BOOL finished) {
        //autozoom
        if(run.live)
            [self autoZoomMap:[run.pos lastObject] animated:true withMap:fullMap];
        if (completion) {
            completion();
        }
        
    }];
}

#pragma mark -
#pragma mark Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button %d", buttonIndex);
    
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
        CGPoint pt = [touch locationInView:slideView];
        //check the drag button
        CGRect rect  = dragButton.frame;
        if(CGRectContainsPoint(rect, pt))
        {
            return true;
        }
        
        pt = [touch locationInView:self.view];
        rect = iconMap.frame;
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
        } else if (current.y > mapDragPreventOpposite && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
        } else if (current.y < -mapDragCutoff && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self openMapWithSmoothAnimation:true completion:nil];
        }else if (current.y > mapDragCutoff && inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
        } else{
            
            //translate on the finger of the user with current.y
            CGRect mapRect;
            mapRect.size =  slideView.frame.size;
            mapRect.origin = CGPointMake(0, (inMapView ? mapViewYOffset - mapDragPullYOffset : self.view.frame.size.height - mapDragPullYOffset) + current.y);
            
            
            [slideView setFrame:mapRect];
        
        }
    }
    else
    {
        
        if(slideView.frame.origin.y > mapDragCutoff){
            [self closeMapWithSmoothAnimation:true completion:nil];
        } else{
            [self openMapWithSmoothAnimation:true completion:nil];
        }
    }
}

- (IBAction)mapIconTapped:(id)sender {
    
    if(inMapView){
        [self closeMapWithSmoothAnimation:true completion:nil];
    } else{
        [self openMapWithSmoothAnimation:true completion:nil];
    }

}

- (IBAction)finishTapped:(id)sender {
    
    //run object must be cleanup to save in appdelegate where it is stored
    //stopRun is called in appdelegate
    
    //to prevent autopause from preventing stopping updates
    pausedForAuto = false;
    
    //aggregrate last minute, starting at most recent
    NSInteger index = [run.posMeta count] - 1;
    NSInteger sumCount = 0;
    NSTimeInterval paceSum = 0;
    //save last postion and process pace
    if(index >= 0)
    {
        CLLocationMeta * lastMeta = [run.posMeta objectAtIndex:index];
        
        //while pos is later than last bar period
        while ((run.time - barPeriod) < [lastMeta time] && index > 0)
        {
            //aggregate pace
            paceSum += [lastMeta pace];
            sumCount++;
            
            index--;
            lastMeta = [run.posMeta objectAtIndex:index];
        }
        
        NSTimeInterval avgPaceInMin = 0;
        if(sumCount > 0)
            avgPaceInMin = paceSum / sumCount;
        
        CLLocationMeta * newMinMeta = [run.minCheckpointsMeta lastObject];
        //adjust current bar and make it official
        newMinMeta.pace = avgPaceInMin; //m/s
        //save real position
        [run.minCheckpoints addObject:[run.pos lastObject]];
    }
    
    waitingForMapToLoad = true;
    loadingMapTiles = 0;
    
    //remove selection overlay
    [iconMap removeOverlay:mapSelectionOverlay];
    mapSelectionOverlay = nil;
    
    //zoom to show entire map
    [self zoomMapToEntireRun:iconMap];
    
    //cancel low signal animation
    [lowSignalLabel setHidden:true];
    lowSignal = false;
    [goalAchievedLabel setHidden:true];
    goalAchieved = false;
    [runTitle setFrame:orgTitleLabelPosition];
    
    //start loading indicator
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //ensure map is loaded
    [self performSelector:@selector(mapIconFinishedForFinishTapped) withObject:nil afterDelay:1.0];
    
}

- (IBAction)invisibleButtonTapped:(id)sender {
    
    [invisibleLastKmButton.layer setBorderWidth:0.0f];
    
    BOOL isMetric = [[[ delegate curUserPrefs] metric] integerValue];
    
    timeSinceKmSelection = [NSDate timeIntervalSinceReferenceDate];
    
    //if not already in the mode, just select current km/partial km and remove the label
    if(!kmPaceShowMode)
    {
        kmPaceShowMode = true;
        selectedPaceShowMode = false;
        [iconMap removeOverlay:mapSelectionOverlay];
        mapSelectionOverlay = nil;
        
        //start at last km
        selectedKmIndex = (isMetric ? [[run kmCheckpointsMeta] count] :[[run impCheckpointsMeta] count]);
    }
    else{
        //already in this mode, cycle to next km
        selectedKmIndex --;
        if(selectedKmIndex < 0)    //cycle to beginning if necessary
        {
            selectedKmIndex = (isMetric ? [[run kmCheckpointsMeta] count] :[[run impCheckpointsMeta] count]);
            
            //need to show actual current km time as if kmselection was just started as above
        }
    }
    
    //reload labels/selection
    selectedMinIndex = [self getMinBarIndexForKMSelecton:selectedKmIndex];
    numMinutesAtKmSelected = [self getBarCountForKMSelection:selectedKmIndex];
    [self setPaceLabels];
    //if ghost enabled, color bar
    if(run.ghost)
    {
        //some other index
        selectedPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[Util redColour] CGColor]]];
    }
    
    //scroll to selected index
    [self updateChartForIndex:selectedMinIndex];
    
    //show km on icon  map
    NSMutableArray * pointsToSelect = [[NSMutableArray alloc] initWithCapacity:10];
    if(isMetric)
    {
        if([[run kmCheckpointsMeta] count] == 0)
        {
            //use all run pos so far
            pointsToSelect = [run.pos mutableCopy];
        }
        else if([[run kmCheckpointsMeta] count] == selectedKmIndex)
        {
            //not a complete km
            CLLocationMeta * previousKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
            //add overlay with these times
            //show all seconds in km
            NSTimeInterval timeToFind = previousKmMeta.time;
            NSInteger indexToFind = [self indexForRunAtTime:timeToFind];
            for(NSInteger i = indexToFind; i < [run.pos count]; i++)
            {
                if(i >= 0)
                {
                    //add meta to array to display
                    CLLocation * posToAdd = [run.pos objectAtIndex:i];
                    if(posToAdd)
                        [pointsToSelect addObject:posToAdd];
                }
            }
        }
        else
        {
            CLLocationMeta * selectedKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex];
            NSTimeInterval startTime = 0;
            if(selectedKmIndex - 1  >= 0)
            {
                CLLocationMeta * previousKmMeta = [[run kmCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                startTime = previousKmMeta.time;
            }
            //ensure it is at full km
            if(startTime < 0)
                startTime = 0;
            //add overlay with these times
            //show all seconds in km
            for(NSTimeInterval timeToFind = startTime ; timeToFind <= selectedKmMeta.time; timeToFind++)
            {
                NSInteger indexToFind = [self indexForRunAtTime:timeToFind];
                if(indexToFind >= 0)
                {
                    //add meta to array to display
                    CLLocation * posToAdd = [run.pos objectAtIndex:indexToFind];
                    if(posToAdd)
                        [pointsToSelect addObject:posToAdd];
                }
            }
        }
    }
    else
    {
        if([[run impCheckpointsMeta] count] == 0)
        {
            //use all run pos so far
            pointsToSelect = [run.pos mutableCopy];
        }
        else if([[run impCheckpointsMeta] count] == selectedKmIndex)
        {
            //not a complete mile
            CLLocationMeta * previousMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
            //add overlay with these times
            //show all seconds in km
            NSTimeInterval timeToFind = previousMileMeta.time;
            NSInteger indexToFind = [self indexForRunAtTime:timeToFind];
            for(NSInteger i = indexToFind; i < [run.pos count]; i++)
            {
                if(i >= 0)
                {
                    //add meta to array to display
                    CLLocation * posToAdd = [run.pos objectAtIndex:i];
                    if(posToAdd)
                        [pointsToSelect addObject:posToAdd];
                }
            }
        }
        else
        {
            CLLocationMeta * selectedMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex];
            NSTimeInterval startTime = 0;
            if(selectedKmIndex - 1  >= 0)
            {
                CLLocationMeta * previousMileMeta = [[run impCheckpointsMeta] objectAtIndex:selectedKmIndex-1];
                startTime = previousMileMeta.time;
            }
            //ensure it is at full km
            if(startTime < 0)
                startTime = 0;
            //add overlay with these times
            //show all seconds in km
            for(NSTimeInterval timeToFind = startTime ; timeToFind <= selectedMileMeta.time; timeToFind++)
            {
                NSInteger indexToFind = [self indexForRunAtTime:timeToFind];
                if(indexToFind >= 0)
                {
                    //add meta to array to display
                    CLLocation * posToAdd = [run.pos objectAtIndex:indexToFind];
                    if(posToAdd)
                        [pointsToSelect addObject:posToAdd];
                }
            }
        }
    }
    //we have all the positions to show now add to line and display
    CLLocationCoordinate2D coordinates[[pointsToSelect count]];
    NSInteger indexToAdd = 0;
    for(CLLocation * posToAdd in pointsToSelect)
    {
        CLLocationCoordinate2D coordinate = posToAdd.coordinate;
        coordinates[indexToAdd] = coordinate;
        indexToAdd++;
        if(indexToAdd == [pointsToSelect count])
            break;
    }
    if(indexToAdd > 0)
    {
        //remove if already present from selecting another bar
        if(mapSelectionOverlay)
            [iconMap removeOverlay:mapSelectionOverlay];
        mapSelectionOverlay = [MKPolyline polylineWithCoordinates:coordinates count:indexToAdd];
        //add to icon map
        [iconMap addOverlay:mapSelectionOverlay];
    }
}


- (IBAction)invisibleTouched:(id)sender {
    [invisibleLastKmButton.layer setCornerRadius:5.0f];
    [invisibleLastKmButton.layer setMasksToBounds:true];
    
    [invisibleLastKmButton.layer setBorderWidth:0.5f];
    [invisibleLastKmButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    //[invisibleLastKmButton setAlpha:0.2];
}

- (IBAction)invisibleUntouched:(id)sender {
    
    [invisibleLastKmButton.layer setBorderWidth:0.0f];
    
    //[invisibleLastKmButton setAlpha:0.0];
}

- (IBAction)statusButTapped:(id)sender {
    
    [statusBut.layer setBorderWidth:0.0f];
    
    //action depends on if the run is live
    if(run.live)
    {
        //show label again but only in right condition otherwise it will appear in historical,etc
        if(pausedForAuto)
            [autopauseLabel setHidden:false];
        
        //animate the logger to opposite of paused/record state
        //asks the jsslider to animate the pause, includes the automatic pausing/record logic
        //meant to illustrate to user that you can swipe to pause
        [delegate pauseAnimation:nil];
        
    }else{
        
        //share the run
        NSArray *activityItems;
        
        //log text message - I just comleted a 17.1km run with RunIt.
        CGFloat distanceToShare = run.distance/([[[delegate curUserPrefs] metric] boolValue] ? 1000 : (1000/convertKMToMile));
        NSString * messageToSend = [NSString stringWithFormat:@"%@ %.1f %@ %@", NSLocalizedString(@"LoggerShareMsg1", "message to be sent with sharing"), distanceToShare, [[delegate curUserPrefs] getDistanceUnit], NSLocalizedString(@"LoggerShareMsg2", "message to be sent with sharing")];
        
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

- (IBAction)statusTouched:(id)sender {
    
    //hide the auto label if autopaused
    if(pausedForAuto && run.live)
        [autopauseLabel setHidden:true];
    
    [statusBut.layer setCornerRadius:5.0f];
    [statusBut.layer setMasksToBounds:true];
    
    [statusBut.layer setBorderWidth:0.5f];
    [statusBut.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
}

- (IBAction)statusUntouched:(id)sender {
    
    //show label again but only in right condition otherwise it will appear in historical,etc
    if(pausedForAuto && run.live)
        [autopauseLabel setHidden:false];
    
    [statusBut.layer setBorderWidth:0.0f];
}

- (IBAction)hamburgerTapped:(id)sender {
    
    [hamburgerBut.layer setBorderWidth:0.0f];
    
    [delegate menuButtonPressed:sender];
    
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

- (IBAction)ghostButTapped:(id)sender {
    
    [ghostBut.layer setBorderWidth:0.0f];
    
    /*
    //only if it is historical
    if(!run.live)
    {
        
        //ask user if they want to start a ghost run
        [self shouldUserGhostRun];
    }
     */
    
    //only if purchased
    if([[[delegate curUserPrefs] purchased] boolValue])
    {
        
        //only if it is historical
        if(!run.live)
        {
            
            //ask user if they want to start a ghost run
            [self shouldUserGhostRun];
        }
    }
    else
    {
        UpgradeVC * vc = [[UpgradeVC alloc] initWithNibName:@"Upgrade" bundle:nil];
        [vc setPrefs:[delegate curUserPrefs]];
        [vc setDelegate:self];
        
        [self presentViewController:vc animated:true completion:nil];
    }
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


@end
