//
//  CollectionViewFlowLayout.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/16.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return self;
}

@end
