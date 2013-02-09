//
//  PerformanceViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface PerformanceViewController : UIViewController
{
    NSMutableArray * views;
    UIPageControl *pageControl;
    
}

@property (nonatomic, retain) IBOutlet UIPageControl * pageControl;
@property (strong, nonatomic) IBOutlet UIView *chartView;

- (IBAction) changePage:(id)sender;
- (void) animateToView:(UIView *)newView;
- (IBAction)doneTapped:(id)sender;
- (IBAction)predictTapped:(id)sender;
- (IBAction)timeChanged:(id)sender;
@end
