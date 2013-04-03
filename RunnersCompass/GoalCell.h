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

-(void)setupWithRun:(RunEvent*)runForCell withGoal:(Goal*)goal withMetric:(BOOL)metric;

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
