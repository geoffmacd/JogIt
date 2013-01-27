//
//  HUDCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-20.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDCell : UIView

typedef enum
{
    distance,
    elapsedTime,
    avgPace,
    curPace,
    calories,
    climbed,
    descended,
    steps,
    strideLength,
    cadence
    
} HUDCellMode;

@property (weak, nonatomic) IBOutlet UILabel *Value;
@property (weak, nonatomic) IBOutlet UILabel *Unit;

@property HUDCellMode mode;

@end
