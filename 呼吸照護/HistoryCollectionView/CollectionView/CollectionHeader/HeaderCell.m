//
//  HeaderCell.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/15.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "HeaderCell.h"
#import "HistoryCollectionViewController.h"

@implementation HeaderCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
//        label = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., HEADER_WIDTH, HEADER_HEIGHT)];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        [self addSubview:label];
//        
//        //Add bottom border
//        CGFloat borderSize = 1.0f;
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.frame = CGRectMake(0.0f, HEADER_HEIGHT - borderSize, HEADER_WIDTH, borderSize);
//        
//        bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
//        
//        [self.layer addSublayer:bottomBorder];
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

@end
