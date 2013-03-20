//
//  GoalCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GoalCell

@synthesize label,progress,dateLabel;

-(void)setup
{
    self.label.text = @"389 Cal";
    self.dateLabel.text = @"January 17th";
    
    UIImage *background = [[UIImage imageNamed:@"progress-bar-bg.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    UIImage *fill = [[UIImage imageNamed:@"progress-bar-fill.png"]
                     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 2)];
    
    [self.progress setTrackImage:background];
    [self.progress setProgressImage:fill];
    [self.progress setProgress:0.9];
    [self.progress.layer setCornerRadius:6.0f];
    [self.progress.layer setMasksToBounds:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
