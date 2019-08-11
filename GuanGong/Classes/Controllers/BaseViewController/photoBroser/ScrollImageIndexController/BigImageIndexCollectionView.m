//
//  IndexCollectionView.m
//  BigImageShow
//
//  Created by liuyan on 16/8/10.
//  Copyright © 2016年 liuyan. All rights reserved.
//

#import "BigImageIndexCollectionView.h"
#import "IndexCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "IndexFlow.h"

@interface BigImageIndexCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic,assign)BOOL isExpand;
@property(nonatomic, assign)BOOL shouldDid;

@end

@implementation BigImageIndexCollectionView

- (id)initWithFrame:(CGRect)frame{
//   IndexFlow *flowLayout = [[IndexFlow alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0,12, 0, 12);
    flowLayout.minimumLineSpacing = 2;

    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsHorizontalScrollIndicator = NO;
        self.isExpand = YES;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"IndexCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"IndexCollectionCell"];
    }
    return self;
}

#pragma mark - collectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _movieModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IndexCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndexCollectionCell" forIndexPath:indexPath];
    
    NSString *url = [_movieModelArray[indexPath.item] valueForKey:@"url"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?imageView2/1/w/%.f/h/%.f",url,100 * [[UIScreen mainScreen] scale],75 * [[UIScreen mainScreen] scale]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
//    [cell.imageView sd_setImageWithURL:[_movieModelArray[indexPath.item] valueForKey:@"url"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.didScrollBlcok) {
        self.didScrollBlcok(indexPath);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isExpand = NO;
}


- (void)collectionViewDidScrollWithScrollBlock:(IndexScrollBlock)didScrollBlcok{
    self.didScrollBlcok = didScrollBlcok;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGPoint point = self.center;
    point.x = point.x + offset.x;
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (self.shouldDid) {
        if (self.didScrollBlcok) {
            self.didScrollBlcok(indexPath);
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
     self.shouldDid = YES;
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //结束滑动时关闭scrollBlock
    self.isExpand = YES;
    self.shouldDid = NO;

    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    float xOffSet = targetContentOffset->x;
    NSInteger index = (xOffSet + ((_itemWidth + _minLineSpacing) / 2)) / (_itemWidth + _minLineSpacing);
    targetContentOffset->x = index * (_itemWidth + _minLineSpacing);
    self.currentPage = index;
}


@end
