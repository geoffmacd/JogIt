//
//  ChartCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "RuleCell.h"

@implementation RuleCell

@synthesize folderImage;
@synthesize statView;
@synthesize headerView;
@synthesize delegate;
@synthesize expanded;
@synthesize rule1Label,rule2Label,rule3Label;
@synthesize formulaImage,subtitleLabel,titleLabel;

#pragma mark - Lifecycle

-(void)setup
{
    
    [statView setHidden:true];
    [AnimationUtil rotateImage:folderImage duration:0 curve:UIViewAnimationCurveEaseIn degrees:90];
    
    //localized labels in IB

    [titleLabel setText:NSLocalizedString(@"ruletitle", @"rule title in prediction")];
    [subtitleLabel setText:NSLocalizedString(@"rulesubtitle", @"subtitle in prediction")];
    [rule1Label setText:NSLocalizedString(@"rule1", @"rule1")];
    [rule2Label setText:NSLocalizedString(@"rule2", @"rule2")];
    [rule3Label setText:NSLocalizedString(@"rule3", @"rule3")];
    
    
    [subtitleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [rule1Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [rule2Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [rule3Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12.0f]];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:14.0f]];
}

-(void)setTimePeriod:(BOOL) toWeekly
{

}

- (IBAction)expandTapped:(id)sender {
}

- (IBAction)headerTapped:(id)sender {
    
    [self setExpand:!expanded withAnimation:true];
}

-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    expanded = open;
    
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:-90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:statView toOpen:true openTime:hierarchicalCellAnimationExpand closeTime:hierarchicalCellAnimationCollapse];
        }
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:statView toOpen:false openTime:hierarchicalCellAnimationExpand closeTime:hierarchicalCellAnimationCollapse];
        }
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:90];
    }
    
    if(!animate)
    {
        [statView setHidden:!open];
    }
    
    [delegate cellDidChangeHeight:self];
}

-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + statView.frame.size.height;
    }
}

@end
