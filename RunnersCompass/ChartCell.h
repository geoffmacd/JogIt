//
//  ChartCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "CorePlot-CocoaTouch.h"

#define performanceBarWidth 22
#define performanceLoadObjectsOffset 20
#define performanceSplitObjects 100
#define kSelectedPlot @"selected"
#define kPlot @"plot"

@protocol ChartCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;

@end

@interface ChartCell : UITableViewCell<CPTPlotDataSource,CPTBarPlotDelegate,UIScrollViewDelegate>
{
@private
    CPTXYGraph *barChart;
    
    NSInteger selectedBarIndex;
    NSInteger lastCacheMinute;
    CPTBarPlot * selectedPlot;
    CPTBarPlot * barPlot;
    CPTXYPlotSpace *plotSpace;
    
    NSMutableArray * weeklyValues;
    NSMutableArray * monthlyValues;
    NSMutableArray * weeklyXValues;
    NSMutableArray * monthlyXValues;
}


//UI connections

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *previousLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *previousValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *allTimeValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedValueLabel;
@property (strong, nonatomic) IBOutlet UIView *statView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



//delegate
@property (weak, nonatomic) id <ChartCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded
@property (nonatomic, setter = setAssociated:) RunMetric associated;
@property(setter = setTimePeriod:) BOOL weekly;
@property BOOL loadedGraph;

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;
- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;

@end
