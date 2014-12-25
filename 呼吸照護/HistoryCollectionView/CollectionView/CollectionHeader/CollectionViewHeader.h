//
//  CollectionViewHeader.h
//  CollectionViewTest
//
//  Created by Farland on 2014/5/15.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewHeaderProtocol <NSObject>

@required
- (void)headerDidScroll;
@end

@interface CollectionViewHeader : UICollectionView

@property (assign, nonatomic) id<CollectionViewHeaderProtocol> protocol;
@property (nonatomic) NSMutableArray *timeArray;

@end
