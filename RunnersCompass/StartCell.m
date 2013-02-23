//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "StartCell.h"
#import "AnimationUtil.h"

@implementation StartCell

@synthesize folderImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize headerView;
@synthesize delegate;

@synthesize expanded;

-(void)setup
{

    
    [self setExpand:false withAnimation:false];
    
    UIColor *col = [UIColor blackColor];
    
    [headerView setBackgroundColor:col];
    
    UIColor *col3 = [UIColor colorWithRed:145.0f/255 green:153.0f/255 blue:161.0f/255 alpha:1.0f];
    
    [expandedView setBackgroundColor:col3];
    
}


-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    
    expanded = open;
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:90];
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:true];
        
        }
        
        
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:false];
            
        }
        
        [AnimationUtil rotateImage:folderImage duration:time curve:UIViewAnimationCurveEaseIn degrees:0];
    }
    
    if(!animate)
    {
        [expandedView setHidden:!open];
    }
    
    
    [delegate cellDidChangeHeight:self];
    
    
}



-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + expandedView.frame.size.height;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

- (IBAction)expandTapped:(id)sender {
    RunEvent * new = [[RunEvent alloc] initWithName:@"geoff's run" date:[NSDate date]];
    new.live = true;
    [delegate selectedNewRun:new];
}

- (IBAction)headerTapped:(id)sender {
    [self setExpand:!expanded withAnimation:true];
}


- (IBAction)paceTapped:(id)sender {
}

- (IBAction)timeTapped:(id)sender {
}

- (IBAction)calorieTapped:(id)sender {
}

- (IBAction)justGoTapped:(id)sender {
}

- (IBAction)distanceTapped:(id)sender {
}


@end
