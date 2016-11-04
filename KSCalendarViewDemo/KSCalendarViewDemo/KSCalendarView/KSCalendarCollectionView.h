//
//  KSCalendarCollectionView.h
//  test
//
//  Created by kong on 2016/10/25.
//  Copyright © 2016年 孔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCalendarTool.h"


@class KSCalendarCollectionView;
@protocol KSCalendarCollectionViewSource <NSObject>
@required
- (NSInteger)k_c_numberOfSectionsInCollectionView:(UICollectionView *)collectionView;

- (UICollectionViewCell *)k_c_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)k_c_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)k_c_collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)k_c_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath*)indexPath;

@optional
- (void)k_c_scrollViewDidEndScroll:(UIScrollView*)scrollView;

@end


@interface KSCalendarCollectionView : UIView

@property (nonatomic,assign) id<KSCalendarCollectionViewSource> collectDateSource;
@property (nonatomic, strong) UICollectionView* collectionView;

/**
 @param frame     frame
 @param direction ScrollDirection
 @param cellClass cellClass
 */
- (instancetype)initWithFrame:(CGRect)frame
                    direction:(UICollectionViewScrollDirection)direction
                    cellClass:(Class)cellClass;

@end

static NSString* KSCalendarCollectionViewCellIdentifier = @"KSCalendarCollectionViewCellIdentifier";

