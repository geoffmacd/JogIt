//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDView.h"
#import "RunEvent.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@protocol HierarchicalCellDelegate <NSObject>

-(void)cellDidChangeHeight;

@end

@interface HierarchicalCell : UITableViewCell

typedef enum
{
    startRun,
    runHistory
    
} HierarchicalType;

//UI connections
@property (weak, nonatomic) IBOutlet UIView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet HUDView *hud;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *buttonTapGesture;

//delegate
@property (weak, nonatomic) id <HierarchicalCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded
@property (weak, nonatomic) HierarchicalCell *parent;
@property (nonatomic, setter = setAssociated:) RunEvent * associatedRun;
@property HierarchicalType type;

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;


@end

