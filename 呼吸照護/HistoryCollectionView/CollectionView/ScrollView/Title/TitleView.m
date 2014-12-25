//
//  TitleView.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/16.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "TitleView.h"

#import "HistoryCollectionViewController.h"
#import "TitleLabel.h"

@interface TitleView ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation TitleView

#pragma mark - Synthesize

@synthesize titleArray;
@synthesize totalHeight;

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Initialization code
        
        titleArray = [[NSArray alloc] initWithArray:(NSArray *)ARRAY_TITLE];
        
        CGFloat y = 0;
        
        for (int i = 0; i < [titleArray count];i++) {
            TitleLabel *label = [[TitleLabel alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, HEADER_HEIGHT)];
            [label setText:[titleArray objectAtIndex:i]];
            
            [self addSubview:label];
            
            y += HEADER_HEIGHT;
        }
        
        totalHeight = y;
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
