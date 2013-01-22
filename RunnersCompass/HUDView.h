//
//  HUDView.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-20.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDCell.h"

@interface HUDView : UIView

typedef enum
{
    loggerDisplay
} HUDViewMode;

@property (strong, nonatomic) HUDCell* quad1;
@property (strong, nonatomic) HUDCell* quad2;
@property (strong, nonatomic) HUDCell* quad3;
@property (strong, nonatomic) HUDCell* quad4;

-(void)setHUDType:(HUDViewMode) mode;

@end
