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

#pragma mark - Settings

- (void)setUserDefaults
{
    NSMutableDictionary *defaults = [[NSMutableDictionary alloc]initWithCapacity:10];
    

    [defaults setValue:@"Geoff MacDonald"  forKey:@"name"];
    [defaults setValue:@"Toronto" forKey:@"location"];
    [defaults setValue:@"6'2" forKey:@"height"];
    [defaults setValue:[NSDate date]
                forKey:@"age"];
    [defaults setValue:[NSNumber numberWithInt:192]
                forKey:@"weight"];

    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark - Logger Delegate Methods

- (void)menuButtonPressed:(id)sender{
    if(!self.viewController.isOpen)
    {
        [self.viewController.view setUserInteractionEnabled:false];
        [self.viewController openSlider:true completion:nil];
    }
}

//both menu and logger delegate method
- (void)finishedRun:(RunEvent *)run
{
    [self.frontVC finishedRun:run];
    
    
    
    
    if(!self.viewController.isOpen)
    {
        [self.viewController.view setUserInteractionEnabled:false];
        [self.viewController openSlider:true completion:^{
            
            if(!run)
            {
                //load previous run
            }
             
        }];
    }
    
}

- (void)pauseAnimation{
    
    [self.viewController pauseWithBounceAnimation:nil];
    
}


#pragma mark - Menu Delegate Methods

- (void)loadRun:(RunEvent*) run close:(BOOL)close
{
    //slider unlocked from this point until app is exited
    [self.viewController setLocked:false];
    
    //lock slider bounce to  prevent pause
    [self.viewController setLiveRun:false];
    
    //load this run into the logger
    
    [self.backVC setRun:run];
    
    if(close)
        [self.viewController closeSlider:true completion:nil];
    
}

- (void)newRun:(NSInteger) value withMetric:(NSInteger) metric animate:(BOOL)animate
{
    //slider unlocked from this point until app is exited
    [self.viewController setLocked:false];
    
    //set to live so that slider bounce is active
    [self.viewController setLiveRun:true];
    
    //if status is currently recording, send notification to change and modify image
    if(!self.backVC.paused)
    {
        //notification with pause image
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"pauseToggleNotification"
         object:self.viewController.pauseImage];
        
    }
    
    
    //animate new run
    [self.backVC newRun:value withMetric:metric animate:animate pauseImage:self.viewController.pauseImage];
    
    //also close slider 
    [self.viewController closeSlider:true completion:nil];
    
}

- (void)selectedRunInProgress
{
    if(self.viewController.isOpen)
    {
        if(self.viewController.liveRun)
        {
            //discard run since garbage can is showing
            
            [self.viewController.view setUserInteractionEnabled:false];
            //show discard sheet on completion
            [self.viewController closeSlider:true completion:^{
                [self userDiscardTapped];
            }];
        }
        else{
            //just go back to logger
            [self.viewController.view setUserInteractionEnabled:false];
            [self.viewController closeSlider:true completion:nil];
        }
    }
}


#pragma mark - App Delegate

-(void)userDiscardTapped
{
    sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to discard this run?"
                                        delegate:self.frontVC
                               cancelButtonTitle:@"Cancel"
                          destructiveButtonTitle:@"Discard"
                               otherButtonTitles:nil];
    
    // Show the sheet in view
    
    [sheet showInView:self.frontVC.view];
}


#pragma mark - App Lifecycle Delegate MEthods


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.backVC = [[LoggerViewController alloc] initWithNibName:@"Logger" bundle:nil];
    self.backVC.delegate = self;
    [self.backVC.view setClipsToBounds:true];
    
    self.frontVC = [[MenuViewController alloc] initWithNibName:@"Menu" bundle:nil];
    self.frontVC.delegate = self;
    
    
    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:self.frontVC  backViewController:self.backVC];
    
    //set the delegates to receive the messages
    self.viewController.delegate = self.backVC;
    self.viewController.menuDelegate = self.frontVC;
    
    [self.viewController setLocked:true];//until a run is loaded/started
    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //to make corners same as those for the app
    [self.backVC.view.layer setCornerRadius:5.0f];
    
    //set user defaults
    [self setUserDefaults];
 

    return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
