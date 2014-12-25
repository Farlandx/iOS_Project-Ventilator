//
//  DataTableViewCell.m
//  呼吸照護
//
//  Created by Farland on 2014/2/21.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DataTableViewCell.h"

@implementation DataTableViewCell

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
