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
#import "TTTOrdinalNumberFormatter.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@protocol HierarchicalCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id)sender;
-(void)selectedRun:(id)sender;
-(void)updateGestureFailForCell:(UIGestureRecognizer*)cellGesture;
-(UserPrefs*)getPrefs;
- (void)garbageTapped:(id)sender;

@end

@interface HierarchicalCell : UITableViewCell

typedef enum
{
    startRun,
    runHistory
    
} HierarchicalType;

//UI connections
@property (strong, nonatomic) IBOutlet UIView *expandedView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIImageView *folderImage;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *calUnit;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *calLabel;
@property (strong, nonatomic) IBOutlet UILabel *paceUnit;
@property (strong, nonatomic) IBOutlet UILabel *minUnit;
@property (strong, nonatomic) IBOutlet UILabel *paceLabel;
@property (strong, nonatomic) IBOutlet UIButton *garbageBut;
@property (weak, nonatomic) IBOutlet UILabel *manualEntryLabel;

//delegate
@property (weak, nonatomic) id <HierarchicalCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property BOOL deletionMode;//for whether currently expanded
@property (weak, nonatomic) HierarchicalCell *parent;
@property (nonatomic, setter = setAssociated:) RunEvent * associatedRun;
@property HierarchicalType type;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGesture;

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)reloadUnitLabels;
-(void)collapseAll;
-(void)expandAll;

//IB actions
- (IBAction)expandViewTap:(id)sender;
- (IBAction)headerViewTap:(id)sender;
- (IBAction)cellSwipedRight:(id)sender;
- (IBAction)garbageTapped:(id)sender;


@end

