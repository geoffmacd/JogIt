//
//  CreateGoalCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CreateGoalCell.h"


@implementation CreateGoalCell

@synthesize goalImage,titleLabel, subtitleLabel,curCheckImage;


-(void)setup:(GoalType) goalType withCurrentGoalType:(GoalType) curType
{
    if(curType != GoalTypeNoGoal)
    {
        if(curType == goalType)
        {
            //show checkmark
            [curCheckImage setHidden:false];
        }
    }
    
    //get object for getting button titles only
    Goal * emptyGoal ;
    emptyGoal = [[Goal alloc] initWithType:goalType];
    [titleLabel setText:[emptyGoal stringForDescription]];
    [subtitleLabel setText:[emptyGoal stringSubtitleDescription]];
    
    //set image and text
    switch(goalType)
    {
        case GoalTypeCalories:
            [goalImage setImage:[UIImage imageNamed:@"whitecalories.png"]];
            break;
        case GoalTypeOneDistance:
            [goalImage setImage:[UIImage imageNamed:@"medal.png"]];
            break;
        case GoalTypeRace:
            [goalImage setImage:[UIImage imageNamed:@"whitespeed.png"]];
            break;
        case GoalTypeTotalDistance:
            [goalImage setImage:[UIImage imageNamed:@"whiteodometer.png"]];
            break;
        default:
            break;
    }
    
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15.0f]];
    [subtitleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
