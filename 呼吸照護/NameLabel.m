//
//  NameLabel.m
//  呼吸照護
//
//  Created by Farland on 2014/6/13.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "NameLabel.h"

@implementation NameLabel

- (id)init {
    if (self = [super init]) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:92/255.f green:198/255.f blue:215/255.f alpha:1.]];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, NAME_LABEL_PADDING_WIDTH, 0, NAME_LABEL_PADDING_WIDTH};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
