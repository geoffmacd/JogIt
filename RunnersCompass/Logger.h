//
//  CompassSecondViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2012-10-30.
//  Copyright (c) 2012 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "JSSlidingViewController.h"



@protocol LoggerViewControllerDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;
- (void)lockSlider;
- (void)unlockSlider;

@end



@interface LoggerViewController : UIViewController <JSSlidingViewControllerDelegate>


//delegate
@property (weak, nonatomic) id <LoggerViewControllerDelegate>delegate;


//UI
@property (strong, nonatomic) IBOutlet UILabel *runTitle;

//objects
@property (nonatomic, weak, setter = setRun:) RunEvent * run;


//IB
- (IBAction)hamburgerTapped:(id)sender;

@end

