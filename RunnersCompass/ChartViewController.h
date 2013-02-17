//
//  ChartViewController.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-27.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController<CPTPlotDataSource>
{
    @private
    CPTXYGraph *barChart;
    NSTimer *timer;
    
}

@property (readwrite, retain, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphView;


-(void)timerFired;

@end

