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
@synthesize dragMapButton;
@synthesize mapView;
@synthesize panGesture;
@synthesize inMapView;
@synthesize mapThumbnail;
@synthesize paused;
@synthesize statusIcon;


-(void)setRun:(RunEvent *)_run
{
    run = _run;
    
    [runTitle setText:run.name];
}

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
        mapRect.origin = CGPointMake(0, 400);
        mapRect.size =  mapView.frame.size;
        [mapView setFrame:mapRect];
        
        [mapThumbnail setAlpha:1.0f];
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
        mapRect.origin = CGPointMake(0, 80);
        mapRect.size =  mapView.frame.size;
        [mapView setFrame:mapRect];
        
        
        [mapThumbnail setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    paused = true;
    
    CGRect mapRect;
    mapRect.origin = CGPointMake(0, 400);
    mapRect.size =  mapView.frame.size;
    [mapView setFrame:mapRect];
    
    [self.view addSubview:mapView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceivePause:)
                                                name:@"pauseToggleNotification" object:nil];
    
    inMapView = false;
}



- (void)didReceivePause:(NSNotification *)notification
{
    paused = !paused;
    
    UIImageView * pauseImage = (UIImageView *) [notification object];
    
    if(paused){
        [UIView transitionWithView:pauseImage
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"pause_logo_large.png"];
                        } completion:NULL];
        [statusIcon setImage:[UIImage imageNamed:@"pause_logo_large.png"]];
    }
    else
    {
        [UIView transitionWithView:pauseImage
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            pauseImage.image = [UIImage imageNamed:@"RightArrow.png"];
                        } completion:NULL];
        [statusIcon setImage:[UIImage imageNamed:@"RightArrow.png"]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)hamburgerTapped:(id)sender {
    [delegate menuButtonPressed:sender];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(gestureRecognizer == panGesture)
    {
        CGPoint pt = [touch locationInView:mapView];
        CGRect rect = dragMapButton.frame;
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
        
        if(current.y < 5 && inMapView){
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = true;
        } else if (current.y > 5 && !inMapView){
            
            [pan setEnabled:FALSE];
            [pan setEnabled:TRUE];
            
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        }
        
        CGRect mapRect;
        mapRect.origin = CGPointMake(0, (inMapView ? 80 : 400) + current.y);
        mapRect.size =  mapView.frame.size;
        
        [mapView setFrame:mapRect];
    }
    else
    {
        
        if(mapView.frame.origin.y > 200){
            [self closeMapWithSmoothAnimation:true completion:nil];
            inMapView = false;
        } else{
            [self openMapWithSmoothAnimation:true completion:nil];
            inMapView = true;
        }
    }
}
@end
