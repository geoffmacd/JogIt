//
//  ChartCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationUtil.h"


@protocol PRCellDelegate <NSObject>

-(void)cellDidChangeHeight:(id) sender;

@end

@interface PRCell : UITableViewCell
{

}


//UI connections

@property (weak)  IBOutlet UIImageView *folderImage;
@property (weak) IBOutlet UIView *headerView;
@property (weak)  IBOutlet UIView *statView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fastestTitle;
@property (weak, nonatomic) IBOutlet UILabel *furthestTitle;
@property (weak, nonatomic) IBOutlet UILabel *caloriesTitle;
@property (weak, nonatomic) IBOutlet UILabel *longestTitle;
@property (weak, nonatomic) IBOutlet UILabel *fastestValue;
@property (weak, nonatomic) IBOutlet UILabel *furthestValue;
@property (weak, nonatomic) IBOutlet UILabel *caloriesValue;
@property (weak, nonatomic) IBOutlet UILabel *longestValue;


//delegate
@property id <PRCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setupWithFastest:(NSString*)fast furthest:(NSString*)furthest calories:(NSString*)cals longest:(NSString*)longest;
- (IBAction)expandTapped:(id)sender;
- (IBAction)headerTapped:(id)sender;

@end
