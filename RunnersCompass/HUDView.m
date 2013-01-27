//
//  HUDView.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-20.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "HUDView.h"
#import "HUDCell.h"
#import "Log.h"

@implementation HUDView

@synthesize quad1;
@synthesize quad2;
@synthesize quad3;
@synthesize quad4;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    
    [self setup];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    [self setup];
    
}


-(void)setup
{
    
}

-(void)setHUDType:(HUDViewMode) mode
{
    //fill array of HUDCells and then setup
    switch(mode)
    {
        case loggerDisplay:
            quad1.mode = elapsedTime;
            quad2.mode = distance;
            quad3.mode = avgPace;
            quad4.mode = calories;
            break;
    
        case menuDisplay:
            quad1.mode = avgPace;
            quad2.mode = calories;
            quad3 = nil;
            quad4 = nil;
            [quad3 setHidden:true];
            [quad4 setHidden:true];
            break;
        
        default:
            [Log logMessageOfType:LogWarning withFormat:@"Not correct parameter count sent to setHUDType"];
            
            break;
            
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
