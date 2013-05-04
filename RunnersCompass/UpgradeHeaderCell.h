//
//  CreateGoalHeaderCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-24.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPShare.h"

@interface UpgradeHeaderCell : UIView
@property (weak)  IBOutlet UIButton *doneBut;
@property (weak, nonatomic) IBOutlet UIButton *upgradeBut;
@property (weak, nonatomic) IBOutlet UILabel *upgradeDescriptionLabel;


-(void) setup;

@end
