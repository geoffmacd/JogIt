//
//  HierarchicalButton.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "HierarchicalCell.h"

@implementation HierarchicalCell

@synthesize hud;
@synthesize expandButton;
@synthesize selectButton;
@synthesize thumbnailImage;
@synthesize headerLabel;
@synthesize buttonTapGesture;
@synthesize expandedView;
@synthesize headerView;

@synthesize delegate;

@synthesize associatedRun;
@synthesize parent;
@synthesize expanded;
@synthesize type;


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
    NSString * header = [NSString stringWithFormat:@"%@ - %@", associatedRun.name, [associatedRun.date description]];
    [headerLabel setText:header];
    
    //set thumbnail
    [thumbnailImage setImage:associatedRun.map.thumbnail];
    
    [hud setHUDType:menuDisplay];
    
    [self setExpand:false];
    
    
    buttonTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleExpandTap:)];
    [buttonTapGesture setDelegate:self];
    [headerView addGestureRecognizer:buttonTapGesture];
    
}


- (void)handleExpandTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self setExpand:!expanded];
}

-(void)setExpand:(BOOL)open
{
    
    expanded = open;
    
    if(expanded){
        [expandButton setImage:[UIImage imageNamed:@"DownTriangleIcon.png"] forState:UIControlStateNormal];
        
        
    }else{
        [expandButton setImage:[UIImage imageNamed:@"RightFillTriangleIcon.png"] forState:UIControlStateNormal];
        
    }
    
    [expandedView setHidden:!expanded];
    
    
    [delegate cellDidChangeHeight];
    
    
}

-(CGFloat)getHeightRequired
{
    
    if(!expanded)
    {
        return headerView.frame.size.height;
    }else{
        return headerView.frame.size.height + 104;
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
