//
//  OrderBuilderCell.m
//  DonutRunCD
//
//  Created by Lou Valencia on 11/10/13.
//  Copyright (c) 2013 Lou Valencia. All rights reserved.
//

#import "OrderBuilderCell.h"

@implementation OrderBuilderCell
@synthesize personLabel, qtyLabel, stepper;

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
