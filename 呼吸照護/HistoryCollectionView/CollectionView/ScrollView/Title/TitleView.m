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
#import "TitleSidebar.h"

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
            TitleLabel *label = [[TitleLabel alloc] initWithFrame:CGRectMake(SIDEBAR_TITLE_WIDTH, y, self.frame.size.width - SIDEBAR_TITLE_WIDTH, HEADER_HEIGHT)];
            [label setText:[titleArray objectAtIndex:i]];
            
            [self addSubview:label];
            
            y += HEADER_HEIGHT;
        }
        
        totalHeight = y;
        
        [self drawSidebarTitle];
    }
    
    return self;
}

- (void)drawSidebarTitle {
    
    NSArray *sidebarAry = @[@{@"lines":[NSNumber numberWithInt:10], @"text":@"呼吸器之使用"},
                            @{@"lines":[NSNumber numberWithInt:6], @"text":@"動脈血氣體分析"},
                            @{@"lines":[NSNumber numberWithInt:6], @"text":@"呼吸及氣道監視"},
                            @{@"lines":[NSNumber numberWithInt:4], @"text":@"血行力學"},
                            @{@"lines":[NSNumber numberWithInt:5], @"text":@"血液生化"}];
    
    CGFloat posY = 0.0f;
    
    for (int i = 0; i < sidebarAry.count; i++) {
        TitleSidebar *sidebar = [[TitleSidebar alloc] initWithFrame:CGRectMake(0,
                                                                               posY,
                                                                               SIDEBAR_TITLE_WIDTH,
                                                                               HEADER_HEIGHT * [[sidebarAry[i] objectForKey:@"lines"] intValue])
                                                               text:[sidebarAry[i] objectForKey:@"text"]];
        [self addSubview:sidebar];
        posY += sidebar.frame.size.height;
    }
    
}

@end
