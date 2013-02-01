//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"

// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)


@protocol StartCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;
-(void)selectedNewRun:(RunEvent *) run;

@end

@interface StartCell : UITableViewCell


//UI connections
@property (weak, nonatomic) IBOutlet UIView *expandedView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *folderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *justGoView;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@property (weak, nonatomic) IBOutlet UIView *paceView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *presetTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pacePresetLabel;
@property (weak, nonatomic) IBOutlet UILabel *distancePresetLAbel;

- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;
//delegate
@property (weak, nonatomic) id <StartCellDelegate>delegate;

//instance variables
@property BOOL expanded;//for whether currently expanded

-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
- (void)handleStartTap:(UITapGestureRecognizer *)gestureRecognizer;
-(void)setup;

@end

