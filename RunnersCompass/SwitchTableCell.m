//
//  SwitchTableCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-02-08.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SwitchTableCell.h"

@implementation SwitchTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
