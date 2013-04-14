//
//  ChartCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "PRCell.h"

@implementation PRCell

@synthesize folderImage;
@synthesize statView;
@synthesize headerView;
@synthesize delegate;
@synthesize expanded;
@synthesize furthestTitle,furthestValue,fastestTitle,fastestValue;
@synthesize caloriesTitle,caloriesValue,longestTitle,longestValue;
@synthesize subtitleLabel,titleLabel;

#pragma mark - Lifecycle

-(void)setupWithFastest:(NSString*)fast furthest:(NSString*)furthest calories:(NSString*)cals longest:(NSString*)longest
{
    
    [statView setHidden:true];
    [AnimationUtil rotateImage:folderImage duration:0 curve:UIViewAnimationCurveEaseIn degrees:90];
    
    //set values
    [furthestValue setText:furthest];
    [fastestValue setText:fast];
    [caloriesValue setText:cals];
    [longestValue setText:longest];
    
    //localized labels in IB
    [furthestTitle setText:NSLocalizedString(@"prcellfurthest", @"prcell furthest")];
    [fastestTitle setText:NSLocalizedString(@"prcellfastest", @"prcell fast")];
    [longestTitle setText:NSLocalizedString(@"prcelllongest", @"prcell long")];
    [caloriesTitle setText:NSLocalizedString(@"prcellcalories", @"prcell cals")];
    
    [titleLabel setText:NSLocalizedString(@"prcelltitle", @"prcell title")];
    [subtitleLabel setText:NSLocalizedString(@"prcellsubtitle", @"prcell subtitle")];
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
