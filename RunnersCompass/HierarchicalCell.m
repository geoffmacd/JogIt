//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "HierarchicalCell.h"

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
@synthesize paceUnit;



-(void)setup
{
    [self reloadUnitLabels];
    
    //set thumbnail
    [thumbnailImage setImage:associatedRun.map.thumbnail];
    [thumbnailImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [thumbnailImage.layer setBorderWidth: 1.0];
    //corners to make map not look so square
    [thumbnailImage.layer setCornerRadius:5.0f];
    [thumbnailImage.layer setMasksToBounds:YES];
    
    [self setExpand:false withAnimation:false];
    
    UIColor *col = [UIColor colorWithRed:142.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    //UIColor *col = [UIColor colorWithRed:192.0f/255 green:24.0f/255 blue:37.0f/255 alpha:1.0f];
    
    [headerView setBackgroundColor:col];
    
    //[expandedView setBackgroundColor:[UIColor darkGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadUnitLabels)
                                                 name:@"reloadUnitsNotification"
                                               object:nil];
    
}


-(void) setAssociated:(RunEvent*) event
{
    if(event)
    {
        
        associatedRun = event;
        
        [self setup];
    }
}

-(void)reloadUnitLabels
{
    //set header
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    DataTest* data = [DataTest sharedData];
    NSString *distanceUnitText = [data.prefs getDistanceUnit];
    
    NSString * header = [NSString stringWithFormat:@"%.1f %@ • %@", associatedRun.distance,  distanceUnitText, [dateFormatter stringFromDate:associatedRun.date]];
    [headerLabel setText:header];
    
    
    [paceUnit setText:[NSString stringWithFormat:@"min/%@", distanceUnitText]];
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
