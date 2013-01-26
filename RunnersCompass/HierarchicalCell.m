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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSString * header = [NSString stringWithFormat:@"%@ - %@", associatedRun.name, [dateFormatter stringFromDate:associatedRun.date]];
    [headerLabel setText:header];
    
    //set thumbnail
    [thumbnailImage setImage:associatedRun.map.thumbnail];
    
    [hud setHUDType:menuDisplay];
    
    [self setExpand:false withAnimation:false];
    
    
    buttonTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleExpandTap:)];
    [buttonTapGesture setDelegate:self];
    [headerView addGestureRecognizer:buttonTapGesture];
    
}


- (void)handleExpandTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self setExpand:!expanded withAnimation:true];
}

-(void)setExpand:(BOOL)open withAnimation:(BOOL) animate
{
    
    expanded = open;
    NSTimeInterval time = animate ? 0.25f : 0.01f;
    
    if(expanded){
        
        
        [self rotateImage:expandButton.imageView duration:time
                    curve:UIViewAnimationCurveEaseIn degrees:90];
        
        expandedView.alpha = 0.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:0.4];//lags the button animation a bit
        expandedView.alpha = 1.0;
        [UIView commitAnimations];
        
        
        
    }else{
        
        [self rotateImage:expandButton.imageView duration:time
                    curve:UIViewAnimationCurveEaseIn degrees:0];
    }
    
    
    
    
    [expandedView setHidden:!expanded];
    
    
    [delegate cellDidChangeHeight];
    
    //animate hidden view
    
    
    
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
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
