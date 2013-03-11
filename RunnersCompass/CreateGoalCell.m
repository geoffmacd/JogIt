//
//  CreateGoalCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "CreateGoalCell.h"
#import "DataTest.h"


@implementation CreateGoalCell

@synthesize goalImage,button,curCheckImage;


-(void)setup:(GoalType) goalType
{
    DataTest * core = [DataTest sharedData];
    if(core.curGoal)
    {
        if(core.curGoal.type == goalType)
        {
            //show checkmark
            [curCheckImage setHidden:false];
        }
    }
    
    //get object for getting button titles only
    Goal * emptyGoal ;
    //set image and text
    switch(goalType)
    {
        case GoalTypeCalories:
            emptyGoal = [[Goal alloc] initWithType:goalType];
            [button setTitle:[emptyGoal stringForDescription] forState:UIControlStateNormal];
            [goalImage setImage:[UIImage imageNamed:@"scale.jpg"]];
            break;
        case GoalTypeOneDistance:
            emptyGoal = [[Goal alloc] initWithType:goalType];
            [button setTitle:[emptyGoal stringForDescription] forState:UIControlStateNormal];
            [goalImage setImage:[UIImage imageNamed:@"finishflag.png"]];
            break;
        case GoalTypeRace:
            emptyGoal = [[Goal alloc] initWithType:goalType];
            [button setTitle:[emptyGoal stringForDescription]  forState:UIControlStateNormal];
            [goalImage setImage:[UIImage imageNamed:@"goldmedal.jpeg"]];
            break;
        case GoalTypeTotalDistance:
            emptyGoal = [[Goal alloc] initWithType:goalType];
            [button setTitle:[emptyGoal stringForDescription]  forState:UIControlStateNormal];
            [goalImage setImage:[UIImage imageNamed:@"stopwatch.png"]];
            break;
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
