//
//  HierarchicalButton.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-01-11.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUDView.h"
#import "RunEvent.h"

@interface HierarchicalCell : UITableViewCell

typedef enum
{
    startRun,
    runHistory
    
} HierarchicalType;

//UI connections
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet HUDView *hud;


//instance variables
@property BOOL expanded;//for whether currently expanded
@property (weak, nonatomic) HierarchicalCell *parent;
@property (weak, nonatomic) RunEvent * associatedRun;
@property HierarchicalType type;

@end
