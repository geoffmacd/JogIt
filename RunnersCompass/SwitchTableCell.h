//
//  SwitchTableCell.h
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UISwitch *switchField;

@end
