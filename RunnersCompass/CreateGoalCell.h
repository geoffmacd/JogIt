//
//  CreateGoalCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunEvent.h"
#import "Goal.h"

@interface CreateGoalCell : UITableViewCell

-(void)setup:(GoalType) goalType withCurrentGoalType:(GoalType) curType;

@property (strong, nonatomic) IBOutlet UIImageView *goalImage;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIImageView *curCheckImage;

@end
