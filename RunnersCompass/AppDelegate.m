//
//  AppDelegate.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize frontVC, backVC;


#pragma mark - Logger Delegate Methods

- (void)menuButtonPressed:(id)sender{
    if(!self.viewController.isOpen)
    {
        [self.viewController.view setUserInteractionEnabled:false];
        [self.viewController openSlider:true completion:nil];
    }
}

//both menu and logger delegate method
- (void)finishedRun:(RunEvent *)runToSave
{
    //prevent state collision with historical runs becoming live
    [self.backVC stopRun:true];
    
    //send run to menu to add it to list
    [self.frontVC finishedRun:runToSave];
    
    //if it is in logger view
    if(!self.viewController.isOpen)
    {
        [self.viewController openSlider:true completion:^{
            
            //handle case where run is being deleted and logger view is not valid
            if(!runToSave)
            {
                
                //lock since user sliding to previous run is unintuitive
                [self.viewController setLocked:true];
                
                //set live to be false to prevent badge number
                [self.backVC.run setLive:false];
            }
            else{
                //set run to be historical
                //do not close
                [self loadRun:runToSave close:false];
            }
        }];
    }
    
    //save to db
    if(runToSave)
    {
        //creates all locations, run record and thumbnail
        [runToSave processRunForRecord];
    }
}

- (void)pauseAnimation:(void(^)(void))completion {
    
    //if in logger view and not in background, do animation
    if(!self.viewController.isOpen && !self.backVC.inBackground)
    {
        [self.viewController pauseWithBounceAnimation:completion];
    }
    else
    {
        //pause silently to not screw with slider
        //just send notification to logger without animating
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pauseToggleNotification"
         object:self.viewController.pauseImage];
    }
    
}

-(void)selectedGhostRun:(RunEvent *)runToGhost
{
    //launch new run with this run, call same methods as for any new run
    
    
    //call same method as with the startcell
    [self.frontVC selectedNewRun:runToGhost];
}


-(void)updateRunTimeForMenu:(NSString *)updateTimeString
{
    //update menu string for run in progress
    [self.frontVC updateTimeString:updateTimeString];
    
}

-(void)preventIdleForLiveRun
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)resetIdle
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark - Delegate Methods for both


-(UserPrefs *)curUserPrefs
{
    return userPrefsRecord;
}

-(Goal *)curGoal
{
    return [[Goal alloc] initWithRecord:goalRecord];
}


#pragma mark - Menu Delegate Methods

-(void)lockBeforeLoad
{
    //slider locked until loadRun below is called so user cannot slide before load finish
    [self.viewController setLocked:true];
}


- (void)loadRun:(RunEvent*) runToLoad close:(BOOL)close
{
    
    //slider unlocked from this point until app is exited
    [self.viewController setLocked:false];
    
    //lock slider bounce to  prevent pause
    [self.viewController setLiveRun:false];

    //ensure run is not live
    runToLoad.live = false;
    
    //load this run into the logger
    [self.backVC setRun:runToLoad];
    
    if(close)
        [self.viewController closeSlider:true completion:nil];
    
}

- (void)newRun:(RunEvent*)newRunTemplate animate:(BOOL)animate
{
    //slider unlocked from this point until app is exited
    [self.viewController setLocked:false];
    
    //set to live so that slider bounce is active
    [self.viewController setLiveRun:true];
    
    //ensure run is live
    newRunTemplate.live = true;
    
    //if status is currently recording, send notification to change and modify image
    if(!self.backVC.paused)
    {
        //notification with pause image
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pauseToggleNotification"
         object:self.viewController.pauseImage];
        
    }
    
    //ghost run
    if(newRunTemplate.ghost)
    {
        RunEvent * ghostRun = [[RunEvent alloc] initWithGhostRun:newRunTemplate];
        
        [self.backVC newRun:ghostRun animate:animate];
    }
    else
    {
        // new run
        [self.backVC newRun:newRunTemplate animate:animate];
    }
    
    //also close slider
    //animate if it is not already in logger view
    [self.viewController closeSlider:self.viewController.isOpen completion:nil];
    
}

- (void)selectedRunInProgress:(BOOL)shouldDiscard
{
    if(self.viewController.isOpen)
    {
        if(self.viewController.liveRun)
        {
            //discard run since garbage can is showing
            if(shouldDiscard)
            {
                //show discard sheet on completion
                [self.viewController closeSlider:true completion:^{
                    [self shouldUserDiscardRun];
                }];
            }
            else{
                [self.viewController closeSlider:true completion:nil];
            }
        }
        else{
            //just go back to logger
            [self.viewController.view setUserInteractionEnabled:false];
            [self.viewController closeSlider:true completion:nil];
        }
    }
}

-(void)shouldUserDiscardRun
{
    sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"DiscardCurrentRun", @"Question for discarding run")//@"Are you sure you want to discard this run?"
                                        delegate:self.frontVC
                               cancelButtonTitle:NSLocalizedString(@"CancelWord", @"cancel word")
                          destructiveButtonTitle:NSLocalizedString(@"DiscardWord", @"discard word")
                               otherButtonTitles:nil];
    
    // Show the sheet in view
    
    [sheet showInView:self.frontVC.view];
}

-(void)preventUserFromSlidingRunInvalid:(RunEvent *)runToDelete
{
    //lock slider again
    //happens if logger is loaded with historical run that has been deleted
    //this run should never be live, so you would not be stuck in menu
    
    //object is to be delete after this method
    if([runToDelete.date timeIntervalSinceReferenceDate] == [self.backVC.run.date timeIntervalSinceReferenceDate])
    {
        [self.viewController setLocked:true];
        
    }
}

-(BOOL)isRunAlreadyLoaded:(RunEvent*)runToCheck
{
    if([runToCheck.date timeIntervalSinceReferenceDate] == [backVC.run.date timeIntervalSinceReferenceDate])
        return true;
    else
        return false;
}

-(void)updateGesturesNeededtoFail:(UIGestureRecognizer*)gestureToFail
{
    
    UIPanGestureRecognizer * gestureFromSlider = [self.viewController getSliderPanGesture];
        
    [gestureFromSlider requireGestureRecognizerToFail:gestureToFail];
}


#pragma mark - App Lifecycle Delegate

-(void)settingsChanged:(NSNotification *)notification
{
    //set new settings
    userPrefsRecord = (UserPrefs *) [notification object];
    
    //save to database
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
}

-(void)goalChanged:(NSNotification *)notification
{
    //set new settings
    
    //returned object not the record
    Goal * tempGoal = (Goal *) [notification object];
    
    //must reassign to correct record
    goalRecord.type = [NSNumber numberWithInt:tempGoal.type];
    goalRecord.time = tempGoal.time;
    goalRecord.startDate = tempGoal.startDate;
    goalRecord.endDate = tempGoal.endDate;
    goalRecord.value = tempGoal.value;
    
    //save to database
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)setupTestSQL
{
    NSURL * docURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL * storeURL = [docURL URLByAppendingPathComponent:@"Data.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
    if (defaultStorePath) {
        [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:NULL];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //request products so that they are available to buy
    NSSet * productSet = [NSSet setWithObject:@"LM1.0Upgrade"];
    [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:productSet];
    
    //[self setupTestSQL];
    
    //core data setup
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Data.sqlite"];
    
    //find prefs, if not there create it
    userPrefsRecord = [UserPrefs MR_findFirst];
    if(!userPrefsRecord)
    {
        //create entity
        userPrefsRecord = [UserPrefs MR_createEntity];
        
        //default user 
        userPrefsRecord.countdown = [NSNumber numberWithInt:3];
        userPrefsRecord.autopause = [NSNumber numberWithInt:0];
        userPrefsRecord.weight = [NSNumber numberWithInt:150];
        //new.twitter = [NSNumber numberWithInt:0];
        //new.facebook = [NSNumber numberWithInt:0];
        //find systems default unit measure
        NSLocale *locale = [NSLocale currentLocale];
        BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
        userPrefsRecord.metric = [NSNumber numberWithBool:isMetric];
        userPrefsRecord.showSpeed = [NSNumber numberWithBool:false];
        userPrefsRecord.speech = [NSNumber numberWithBool:true];
        userPrefsRecord.speechTime = [NSNumber numberWithBool:false];
        userPrefsRecord.speechDistance = [NSNumber numberWithBool:true];
        userPrefsRecord.speechPace = [NSNumber numberWithBool:true];
        userPrefsRecord.speechCalories = [NSNumber numberWithBool:false];
        userPrefsRecord.speechCurPace = [NSNumber numberWithBool:false];
        //ensure user has not purchased
        userPrefsRecord.purchased = [NSNumber numberWithBool:false];
        userPrefsRecord.weekly = [NSNumber numberWithBool:false];
        
        //best to leave these blank so user does not have to backspace them
        userPrefsRecord.fullname = nil;
        userPrefsRecord.birthdate = nil;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    //test this every time
    userPrefsRecord.purchased = [NSNumber numberWithBool:false];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    //find goal, if not there create goal with no goal
    goalRecord = [GoalRecord MR_findFirst];
    if(!goalRecord)
    {
        //create entity
        goalRecord = [GoalRecord MR_createEntity];
        
        //no goal
        goalRecord.type = GoalTypeNoGoal;
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsChanged:)
                                                 name:@"settingsChangedNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goalChanged:)
                                                 name:@"goalChangedNotification"
                                               object:nil];
    
    //logger
    self.backVC = [[LoggerViewController alloc] initWithNibName:@"Logger" bundle:nil];
    self.backVC.delegate = self;
    //to make corners same as those for the app
    [self.backVC.view.layer setCornerRadius:10.0f];
    [self.backVC.view.layer setMasksToBounds:true];
    
    //menu
    self.frontVC = [[MenuViewController alloc] initWithNibName:@"Menu" bundle:nil];
    self.frontVC.delegate = self;
    
    //slider
    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:self.frontVC  backViewController:self.backVC];
    //set the delegates to receive the messages
    self.viewController.delegate = self.backVC;
    self.viewController.menuDelegate = self.frontVC;
    [self.viewController.view.layer setCornerRadius:5.0f];
    [self.viewController.view.layer setMasksToBounds:true];
    
    
    NSLog(@"not past key and visible");
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    NSLog(@"past key and visible");
    
    //set badge to nothing
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;//to indicate success
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    if(self.backVC.run.live)
    {
        //set badge to 1
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    }
    else{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    //alert logger view
    [self.backVC setInBackground:true];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //reset badge in case of crash when badge is 1
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //alert logger view
    [self.backVC setInBackground:false];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //set badge to nothing
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //clean up database
    [MagicalRecord cleanUp];
}

@end
