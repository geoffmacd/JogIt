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

@synthesize associatedRun;
@synthesize parent;
@synthesize expanded;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void)setup
{
    //unexpanded initially
    [self setExpand:false];
    
    if(type == runHistory && associatedRun)
    {
        //set header
        NSString * header = [NSString stringWithFormat:@"%@ - %@", associatedRun.name, [associatedRun.date description]];
        [headerLabel setText:header];
        
        //set thumbnail
        [thumbnailImage setImage:associatedRun.map.thumbnail];
        
        //set hud style to logger for now
        [hud setHUDType:loggerDisplay];
    }
    
}

-(void)setExpand:(BOOL)open
{
    
    expanded = open;
    
    if(open){
        [expandButton setImage:[UIImage imageNamed:@"DownTriangleIcon.png"] forState:UIControlStateNormal];
        
    }else{
        [expandButton setImage:[UIImage imageNamed:@"RightFillTriangleIcon.png"] forState:UIControlStateNormal];
        
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
