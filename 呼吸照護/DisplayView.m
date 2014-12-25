//
//  DisplayView.m
//  呼吸照護
//
//  Created by Farland on 2014/3/18.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "DisplayView.h"

@implementation DisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[UITextField class]]) {
            [((UITextField *)v) resignFirstResponder];
        }
        else if ([v isKindOfClass:[UITextView class]]) {
            [((UITextView *)v) resignFirstResponder];
        }
    }
    
    [_delegate displayViewTouchesBeganDone];
}

@end
