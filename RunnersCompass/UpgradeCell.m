//
//  ChartCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-16.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "UpgradeCell.h"

@implementation UpgradeCell

@synthesize folderImage;
@synthesize statView;
@synthesize headerView;
@synthesize delegate;
@synthesize expanded;
@synthesize point1Label,point2Label,point3Label,titleLabel;
@synthesize sampleImage,fullImage;

#pragma mark - Lifecycle

-(void)setup
{
    
    [statView setHidden:true];
    [AnimationUtil rotateImage:folderImage duration:0 curve:UIViewAnimationCurveEaseIn degrees:90];
    
    
    [fullImage.layer setCornerRadius:10.0f];
    [fullImage.layer setMasksToBounds:true];
    
    [fullImage.layer setBorderWidth:1.0f];
    [fullImage.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];

    
    [point3Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [point2Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [point1Label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11.0f]];
    [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:14.0f]];
    
    //localized labels setup in upgradeVC
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
