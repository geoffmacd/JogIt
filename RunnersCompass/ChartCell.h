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
#import "Util.h"

#define performanceBarWidth 25
#define performanceLoadObjectsOffset 12
#define performanceSplitObjects 24
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
    NSInteger addedWeeksAfterReal;
    CPTBarPlot * selectedPlot;
    CPTBarPlot * barPlot;
    CPTXYPlotSpace *plotSpace;
    CGFloat minY;
    CGFloat maxY;
}


//UI connections

@property (weak)  IBOutlet CPTGraphHostingView *expandedView;
@property (weak) IBOutlet UIView *headerView;
@property (weak)  IBOutlet UIImageView *folderImage;
@property (weak) IBOutlet UILabel *headerLabel;
@property (weak) IBOutlet UILabel *previousLabel;
@property (weak)  IBOutlet UILabel *currentLabel;
@property (weak)  IBOutlet UILabel *currentValueLabel;
@property (weak)  IBOutlet UILabel *previousValueLabel;
@property (weak)  IBOutlet UILabel *allTimeValueLabel;
@property (weak)  IBOutlet UILabel *selectedValueLabel;
@property (weak)  IBOutlet UIView *statView;
@property (weak)  IBOutlet UIScrollView *scrollView;
@property (weak)  IBOutlet UILabel *allTimeLabel;
@property (weak)  IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

//delegate
@property id <ChartCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded
@property (nonatomic, setter = setAssociated:) RunMetric associated;
@property(nonatomic, setter = setTimePeriod:) BOOL weekly;
@property BOOL loadedGraph;
@property BOOL raceCell;
@property NSMutableArray * weeklyValues;
@property NSMutableArray * monthlyValues;
//user prefs
@property UserPrefs * prefs;

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;
- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;

@end
