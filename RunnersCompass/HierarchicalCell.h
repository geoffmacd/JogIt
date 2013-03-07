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
#import "DataTest.h"
#import "AnimationUtil.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@protocol HierarchicalCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;
-(void)selectedRun:(id)sender;
-(void)updateGestureFailForCell:(UIGestureRecognizer*)cellGesture;

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
@property (strong, nonatomic) IBOutlet UILabel *paceUnit;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGesture;
@property (strong, nonatomic) IBOutlet UIButton *garbageBut;

//delegate
@property (weak, nonatomic) id <HierarchicalCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property BOOL deletionMode;//for whether currently expanded
@property (weak, nonatomic) HierarchicalCell *parent;
@property (nonatomic, setter = setAssociated:) RunEvent * associatedRun;
@property HierarchicalType type;

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)reloadUnitLabels;

//IB actions
- (IBAction)expandViewTap:(id)sender;
- (IBAction)headerViewTap:(id)sender;
- (IBAction)cellSwipedRight:(id)sender;


@end

