//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationUtil.h"
#import "UserPrefs.h"
#import "Util.h"
#import "HierarchicalCell.h"
#import "TTTOrdinalNumberFormatter.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@protocol DateCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;
-(void)selectedRun:(id)sender;
-(void)updateGestureFailForCell:(UIGestureRecognizer*)cellGesture;
-(UserPrefs*)getPrefs;
-(void)preventUserFromSlidingRunInvalid:(RunEvent*)runToInvalid;
-(void)presentShareWithItems:(NSArray*)items;
-(void)didDeleteRun:(NSTimeInterval)runDate withCell:(id)datecell;

@end

@interface DateCell : UITableViewCell <HierarchicalCellDelegate>
{
    NSMutableArray * cells;
}


//UI connections
@property (weak, nonatomic) IBOutlet UIView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBut;
@property (weak, nonatomic) IBOutlet UILabel *distanceUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceValue;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paceValue;
@property (weak, nonatomic) IBOutlet UILabel *paceLabel;
@property (weak, nonatomic) IBOutlet UILabel *runsLabel;
@property (weak, nonatomic) IBOutlet UILabel *runsValue;
@property (weak, nonatomic) IBOutlet UITableView *table;


//delegate
@property (weak, nonatomic) id <DateCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property BOOL locked;
@property NSDate * periodStart;

@property NSMutableArray * runs;
@property CGFloat totalDistance;
@property CGFloat avgPace;
@property NSInteger numRuns;
@property NSUInteger indexForColor;

-(void)setup;
-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)reloadUnitLabels;
-(void)collapseAll:(NSInteger)state;
-(void)expandAll:(NSInteger)state;

//IB actions
- (IBAction)expandViewTap:(id)sender;
- (IBAction)headerViewTap:(id)sender;
-(IBAction)shareButTap:(id)sender;

@end

