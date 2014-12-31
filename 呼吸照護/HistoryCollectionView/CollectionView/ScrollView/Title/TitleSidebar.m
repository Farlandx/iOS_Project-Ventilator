//
//  TitleSidebar.m
//  呼吸照護
//
//  Created by Farland on 2014/12/31.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "TitleSidebar.h"
#import "HistoryCollectionViewController.h"

@implementation TitleSidebar

- (id)initWithFrame:(CGRect)frame text:(NSString *)text {
    if (self = [super initWithFrame:frame]) {
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0; //unlimited
        self.textAlignment = NSTextAlignmentCenter;
        self.text = text;
        
        CGFloat borderSize = 1.0f;
        CGColorRef borderColor = [UIColor grayColor].CGColor;
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - borderSize, self.frame.size.width, borderSize);
        bottomBorder.backgroundColor = borderColor;
        
        CALayer *rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake(self.frame.size.width - borderSize, 0.0f, borderSize, self.frame.size.height);
        rightBorder.backgroundColor = borderColor;
        
        [self.layer addSublayer:bottomBorder];
        [self.layer addSublayer:rightBorder];
    }
    return self;
}

@end
