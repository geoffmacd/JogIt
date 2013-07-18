//
//  SJCell.m
//  RunnersCompass
//
//  Created by Geoff MacDonald on 2013-03-19.
//  Copyright (c) 2013 Geoff MacDonald. All rights reserved.
//

#import "SJCell.h"

@implementation SJCell

@synthesize label,fat;

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

-(NSString*)reuseIdentifier
{
    return @"SJ";
}

@end
