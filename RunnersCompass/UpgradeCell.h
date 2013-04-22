//
//  ChartCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationUtil.h"


@protocol UpgradeCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;

@end

@interface UpgradeCell : UITableViewCell
{

}


//UI connections

@property (weak)  IBOutlet UIImageView *folderImage;
@property (weak) IBOutlet UIView *headerView;
@property (weak)  IBOutlet UIView *statView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *point1Label;
@property (weak, nonatomic) IBOutlet UILabel *point2Label;
@property (weak, nonatomic) IBOutlet UILabel *point3Label;
@property (weak, nonatomic) IBOutlet UIImageView *sampleImage;
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;

//delegate
@property id <UpgradeCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;
- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;

@end
