//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "HierarchicalCell.h"
#import "AnimationUtil.h"
#import <QuartzCore/QuartzCore.h>

@implementation HierarchicalCell

@synthesize folderImage;
@synthesize thumbnailImage;
@synthesize headerLabel;
@synthesize expandedView;
@synthesize headerView;

@synthesize delegate;

@synthesize associatedRun;
@synthesize parent;
@synthesize expanded;
@synthesize type;
@synthesize index;


-(void) setAssociated:(RunEvent*) event
{
    if(event)
    {
    
        associatedRun = event;
    
        [self setup];
    }
}

-(void)setup
{
    //set header
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSString * header = [NSString stringWithFormat:@"%@ • %@", associatedRun.name, [dateFormatter stringFromDate:associatedRun.date]];
    [headerLabel setText:header];
    
    //set thumbnail
    [thumbnailImage setImage:associatedRun.map.thumbnail];
    
    [self setExpand:false withAnimation:false];
    
    UIColor *col = [UIColor colorWithRed:142.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    
    [headerView setBackgroundColor:col];
    
    UIColor *col2 = [UIColor colorWithRed:145.0f/255 green:153.0f/255 blue:161.0f/255 alpha:1.0f];
    
    //[expandedView setBackgroundColor:col2];
    
    [thumbnailImage.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [thumbnailImage.layer setBorderWidth: 1.0];
    
}

- (IBAction)expandViewTap:(id)sender
{
    [delegate selectedRun:self];
}

- (IBAction)headerViewTap:(id)sender
{
    
    [self setExpand:!expanded withAnimation:true];
}


-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    
    expanded = open;
    NSTimeInterval time = animate ? folderRotationAnimationTime : 0.01f;
    
    if(expanded){
        
        
        [AnimationUtil rotateImage:folderImage duration:time
                    curve:UIViewAnimationCurveEaseIn degrees:90];
        
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:true];
            
        }
        
        
        
    }else{
        
        if(animate)
        {
            [AnimationUtil cellLayerAnimate:expandedView toOpen:false];
            
        }
        
        [AnimationUtil rotateImage:folderImage duration:time
                    curve:UIViewAnimationCurveEaseIn degrees:0];
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

@end
