//
//  ChartCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationUtil.h"
#import "UserPrefs.h"

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
@property (weak, nonatomic) IBOutlet UILabel *fastestUnit;
@property (weak, nonatomic) IBOutlet UILabel *furthestUnit;
@property (weak, nonatomic) IBOutlet UILabel *fastestDate;
@property (weak, nonatomic) IBOutlet UILabel *furthestDate;
@property (weak, nonatomic) IBOutlet UILabel *calsDate;
@property (weak, nonatomic) IBOutlet UILabel *longestDate;


//delegate
@property id <PRCellDelegate>delegate;


//instance variables
@property BOOL expanded;//for whether currently expanded
@property UserPrefs *prefs;


-(CGFloat)getHeightRequired;
-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate;
-(void)setupWithFastest:(NSString*)fast fastDate:(NSDate*)fastDateObj furthest:(NSString*)furthest furthestDate:(NSDate*)furthestDateObj calories:(NSString*)cals calsDate:(NSDate*)calsDateObj longest:(NSString*)longest longestDate:(NSDate*)longestDateObj;
- (IBAction)headerTapped:(id)sender;

@end
