//
//  NameTextField.m
//  呼吸照護
//
//  Created by Farland on 2014/6/13.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "NameTextField.h"
#import "NameLabel.h"

@implementation NameTextField {
    NameLabel *label;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        label = [[NameLabel alloc] init];
        
        [self addSubview:label];
    }
    return self;
}

- (void)setLabel:(NSString *)text {
    
    [label setText:text];
    [label sizeToFit]; //取得適當的大小
    label.frame = CGRectMake(self.frame.size.width - label.frame.size.width - NAME_LABEL_PADDING_WIDTH * 2,
                             0.,
                             label.frame.size.width + NAME_LABEL_PADDING_WIDTH * 2,
                             self.frame.size.height);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds
                                     byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = label.bounds;
    maskLayer.path = maskPath.CGPath;
    label.layer.mask = maskLayer;
    label.hidden = NO;
    
}

- (void)clearLabel {
    [label setText:@""];
    label.hidden = YES;
}

@end
