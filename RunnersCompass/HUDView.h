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
    loggerDisplay,
    menuDisplay
} HUDViewMode;


@property (strong, nonatomic) IBOutlet HUDCell *quad2;
@property (strong, nonatomic) IBOutlet HUDCell *quad1;
@property (strong, nonatomic) IBOutlet HUDCell *quad3;
@property (strong, nonatomic) IBOutlet HUDCell *quad4;

-(void)setHUDType:(HUDViewMode) mode;

@end
