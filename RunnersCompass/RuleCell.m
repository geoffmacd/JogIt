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
    /*
    [titleLabel setText:@""];
    [subtitleLabel setText:@""];
    [rule1Label setText:@""];
    [rule2Label setText:@""];
    [rule3Label setText:@""];
     */
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
            [AnimationUtil cellLayerAnimate:statView toOpen:true];
        }
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:statView toOpen:false];
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
