//
//  PerformanceViewController.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PerformanceViewController.h"
#import "ChartViewController.h"

@implementation PerformanceViewController

@synthesize pageControl;
@synthesize chartView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //add ChartViewControllers to views
    
    views = [[NSMutableArray alloc] initWithCapacity:6];
    for(NSUInteger i = 0;i<6;i++)
    {
    
        ChartViewController * test = [[ChartViewController alloc] initWithNibName:@"BarChart" bundle:nil];
    
        [views addObject:test];
    }
    
    
    pageControl.numberOfPages = [views count];
    pageControl.currentPage = 0;
    ChartViewController * first = [views objectAtIndex:0];
    chartView = first.graphView;
    
    // Either wire this up in Interface Builder or do it here.
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (IBAction) changePage:(id)sender {
    ChartViewController * newChart = [views objectAtIndex:[pageControl currentPage]];
    [self animateToView:newChart.graphView];
    
    //change labels
}

- (void) animateToView:(UIView *)newView {
    // You'd have to implement this yourself
    
    chartView = newView;
    
}

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)predictTapped:(id)sender {
}

- (IBAction)timeChanged:(id)sender {
}


@end
