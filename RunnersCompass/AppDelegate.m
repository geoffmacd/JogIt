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
        [self.viewController openSlider:true completion:nil];
}

#pragma mark - Menu Delegate Methods

- (void)loadRun:(RunEvent*) run
{
    //load this run into the logger and adjust width if it was closed
    
    [self.backVC setRun:run];
    [self.viewController closeSlider:true completion:nil];
}


#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.backVC = [[LoggerViewController alloc] initWithNibName:@"Logger" bundle:nil];
    self.backVC.delegate = self;
    
    self.frontVC = [[MenuViewController alloc] initWithNibName:@"Menu" bundle:nil];
    self.frontVC.delegate = self;
    
    
    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:self.frontVC  backViewController:self.backVC];
    //set the delegates to receive the messages
    self.viewController.delegate = self.backVC;
    self.viewController.menuDelegate = self.frontVC;
    
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //[self.viewController setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:-20.0f];
    //[self.viewController openSlider:true completion:nil];
    
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
