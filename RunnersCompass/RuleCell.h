//
//  ChartCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationUtil.h"


@protocol RuleCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;

@end

@interface RuleCell : UITableViewCell
{

}


//UI connections

@property (weak)  IBOutlet UIImageView *folderImage;
@property (weak) IBOutlet UIView *headerView;
@property (weak)  IBOutlet UIView *statView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *formulaImage;
@property (weak, nonatomic) IBOutlet UILabel *rule1Label;
@property (weak, nonatomic) IBOutlet UILabel *rule2Label;
@property (weak, nonatomic) IBOutlet UILabel *rule3Label;

//delegate
@property id <RuleCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setup;
- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;

@end
