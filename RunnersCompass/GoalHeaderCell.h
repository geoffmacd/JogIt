//
//  GoalHeader.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"

@interface GoalHeaderCell : UIView
{
    CGRect orgFrame;
    CGRect withGoalFrame;
}

-(void)setup;

@property (weak) IBOutlet UIButton *doneBut;
@property (weak) IBOutlet UIButton *goalButton;

@property (weak) IBOutlet UILabel *metricDescriptionSubtitle;
@property (weak) IBOutlet UILabel *metricDescriptionLabel;
@property (weak) IBOutlet UILabel *metricValue;

@property (weak) IBOutlet UILabel *beganLabel;
@property  (weak) IBOutlet UILabel *beganValue;

@property (weak) IBOutlet UILabel *targetLabel;
@property  (weak) IBOutlet UILabel *targetValue;

@property  (weak) IBOutlet UILabel *countLabel;
@property (weak) IBOutlet UILabel *countValue;

@property  (weak) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIImageView *noGoalImage;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;


@property Goal *goal;
@property BOOL metric;
@end
