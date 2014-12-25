//
//  TitleLabel.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/16.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTextAlignment:NSTextAlignmentRight];
        
        //Add border
        CGFloat borderSize = 1.0f;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - borderSize, self.frame.size.width, borderSize);
        
        bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
        
        [self.layer addSublayer:bottomBorder];
        
        CALayer *rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake(self.frame.size.width - borderSize, 0.0f, borderSize, self.frame.size.height);
        
        rightBorder.backgroundColor = [UIColor grayColor].CGColor;
        
        [self.layer addSublayer:rightBorder];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    //padding left and right
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
