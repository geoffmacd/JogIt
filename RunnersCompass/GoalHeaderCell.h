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

-(void)setup;

@property (nonatomic) IBOutlet UIButton *doneBut;
@property (nonatomic, retain) IBOutlet UIButton *goalButton;

@property (strong, nonatomic) IBOutlet UILabel *metricDescriptionSubtitle;
@property (nonatomic, retain) IBOutlet UILabel *metricDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *metricValue;

@property (nonatomic, retain) IBOutlet UILabel *beganLabel;
@property (nonatomic, retain) IBOutlet UILabel *beganValue;

@property (nonatomic, retain) IBOutlet UILabel *targetLabel;
@property (nonatomic, retain) IBOutlet UILabel *targetValue;

@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *countValue;

@property (nonatomic, retain) IBOutlet UIProgressView *progress;


@property (retain) Goal *goal;
@end
