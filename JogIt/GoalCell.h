//
//  GoalCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "Goal.h"
#import "UserPrefs.h"

@interface GoalCell : UITableViewCell


-(void)setupWithRun:(RunEvent*)runForCell withGoal:(Goal*)goal withMetric:(BOOL)metric showSpeed:(BOOL)showSpeed withMin:(CGFloat)min withMax:(CGFloat)max;

@property (weak) IBOutlet UILabel *label;
@property (weak) IBOutlet UIProgressView *progress;
@property (weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tooShortLabel;

@end
