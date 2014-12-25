//
//  CollectionViewHeader.m
//  CollectionViewTest
//
//  Created by Farland on 2014/5/15.
//  Copyright (c) 2014年 Farland. All rights reserved.
//

#import "CollectionViewHeader.h"

#import "HistoryCollectionViewController.h"
#import "HeaderCell.h"
#import "CollectionViewFlowLayout.h"

@interface CollectionViewHeader () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation CollectionViewHeader

@synthesize protocol;
@synthesize timeArray;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDataSource:self];
        [self setDelegate:self];
        
        timeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    protocol = nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [timeArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HeaderCell *cell = (HeaderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Foo Cell" forIndexPath:indexPath];
    
    //清除已存在的內容避免memory leak
    [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0., 0., HEADER_WIDTH, HEADER_HEIGHT)];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    //Add bottom border
    CGFloat borderSize = 1.0f;
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, HEADER_HEIGHT - borderSize, HEADER_WIDTH, borderSize);
    
    bottomBorder.backgroundColor = [UIColor grayColor].CGColor;
    
    [label.layer addSublayer:bottomBorder];
    
    //最候一筆的話就加上右邊的線
    NSIndexPath *cellIndexPath = [collectionView indexPathForCell:cell];
    if (cellIndexPath.row == [timeArray count]) {
        CALayer *rightBorder = [CALayer layer];
        rightBorder.frame = CGRectMake(HEADER_WIDTH - borderSize, 0.0f, borderSize, HEADER_HEIGHT);
        
        rightBorder.backgroundColor = [UIColor grayColor].CGColor;
        
        [label.layer addSublayer:rightBorder];
    }
    
    [label setText:[NSString stringWithFormat:@"%@", [timeArray objectAtIndex:indexPath.row]]];
    
    [cell addSubview:label];
    
    return cell;
}

#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(HEADER_WIDTH, HEADER_HEIGHT);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (protocol != nil && [protocol respondsToSelector:@selector(headerDidScroll)]) {
        [protocol headerDidScroll];
    }
}


@end
