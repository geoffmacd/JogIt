//
//  GoalCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-23.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "GoalCell.h"

@implementation GoalCell

@synthesize label,progress,dateLabel;

-(void)setup
{
    self.label.text = @"389 Cal";
    self.dateLabel.text = @"January 17th";
    
    UIImage *trackImg = [[UIImage imageNamed:@"track.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    UIImage *progressImg = [[UIImage imageNamed:@"progress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    [self.progress setTrackImage:trackImg];
    [self.progress setProgressImage:progressImg];
    [self.progress setProgress:0.9];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
