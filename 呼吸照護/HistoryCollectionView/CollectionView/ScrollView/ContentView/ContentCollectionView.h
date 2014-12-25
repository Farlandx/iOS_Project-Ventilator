//
//  ContentCollectionView.h
//  CollectionViewTest
//
//  Created by Farland on 2014/5/16.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentCollectionViewProtocol <NSObject>
@required
- (void)collectionViewDidScroll;
@end

@interface ContentCollectionView : UICollectionView

@property (nonatomic, strong) id<ContentCollectionViewProtocol> protocol;
@property (nonatomic) NSMutableArray *dataArray;

@end
