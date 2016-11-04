//
//  KSCalendarCollectionView.m
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSCalendarCollectionView.h"
#import "KSCalendarCollectionViewCell.h"

@interface KSCalendarCollectionView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign)UICollectionViewScrollDirection direction;

@end

@implementation KSCalendarCollectionView

- (instancetype)initWithFrame:(CGRect)frame direction:(UICollectionViewScrollDirection)direction cellClass:(Class)cellClass{
    
    self = [super initWithFrame:frame];
    if (self) {
        _direction = direction;
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = direction;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:cellClass forCellWithReuseIdentifier:KSCalendarCollectionViewCellIdentifier];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        [self addSubview:_collectionView];
    }
    
    return self;
}

#pragma mark-
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.collectDateSource k_c_numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [KSCalendarTool weeksOfSeciton:section] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.collectDateSource k_c_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark-
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [KSCalendarTool collectionView:collectionView cellSizeOfSection:indexPath.section];
}

#pragma mark-
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectDateSource) {
        [self.collectDateSource k_c_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.collectDateSource) {
        [self.collectDateSource k_c_collectionView:collectionView didDeselectItemAtIndexPath:indexPath ];
    }
}

#pragma mark-
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.collectDateSource && [self.collectDateSource respondsToSelector:@selector(k_c_scrollViewDidEndScroll:)]) {
        [self.collectDateSource k_c_scrollViewDidEndScroll:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.collectDateSource && [self.collectDateSource respondsToSelector:@selector(k_c_scrollViewDidEndScroll:)]) {
        [self.collectDateSource k_c_scrollViewDidEndScroll:scrollView];
    }
}


@end
