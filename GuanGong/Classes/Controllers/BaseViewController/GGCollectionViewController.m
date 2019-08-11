//
//  GGCollectionViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 16/6/22.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCollectionViewController.h"

@interface GGCollectionViewController ()

@property(nonatomic,strong)MJRefreshStateHeader *refreshHeader;
@property(nonatomic,strong)MJRefreshAutoStateFooter *refreshFooter;

@end

@implementation GGCollectionViewController

- (void)viewDidLoad {
    [self.view addSubview:self.baseCollectionView];
    [super viewDidLoad];
}

#pragma mark - PublicMothd
- (void)beginHeaderRefreshing{
    [self.refreshHeader beginRefreshing];
}
- (void)endRefreshHeader{
    [self.refreshHeader endRefreshing];
}
- (void)refreshHeaderAction{
    
}
- (void)beginFooterRefreshing{
    [self.refreshFooter beginRefreshing];
}
- (void)endRefreshFooter{
    [self.refreshFooter endRefreshing];
}
- (void)refreshFooterAction{
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floorf((collectionView.width - 25) / 3), floorf((collectionView.width - 25) / 3 * 0.9));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.contentView.backgroundColor = sectionColor;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.contentView.backgroundColor = nil;
}


#pragma mark - Getter
-(UICollectionView *)baseCollectionView{
    if (!_baseCollectionView) {
        _baseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(12, 0, self.view.width - 24, self.view.height) collectionViewLayout:self.colletionLayout];
        _baseCollectionView.backgroundColor = [UIColor whiteColor];
        _baseCollectionView.delegate = self;
        _baseCollectionView.dataSource = self;
        _baseCollectionView.showsVerticalScrollIndicator = NO;
        _baseCollectionView.scrollsToTop = YES;
        _baseCollectionView.alwaysBounceVertical = YES;
        
        _baseCollectionView.layer.masksToBounds = YES;
        _baseCollectionView.layer.cornerRadius = 5;
    }
    return _baseCollectionView;
}

-(UICollectionViewFlowLayout *)colletionLayout{
    if (!_colletionLayout) {
        _colletionLayout = [[UICollectionViewFlowLayout alloc]init];
    }
    return _colletionLayout;
}

-(MJRefreshStateHeader *)refreshHeader{
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
        _refreshHeader.stateLabel.textColor = [UIColor colorWithHexString:@"d1d1d1"];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}

-(MJRefreshAutoStateFooter *)refreshFooter{
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
    }
    return _refreshFooter;
}

#pragma mark - Setter
-(void)setEnabledRefreshHeader:(BOOL)enabledRefreshHeader{
    if (_enabledRefreshHeader != enabledRefreshHeader) {
        _enabledRefreshHeader = enabledRefreshHeader;
        self.baseCollectionView.mj_header = _enabledRefreshHeader ? self.refreshHeader : nil;
    }
}

-(void)setEnabledRefreshFooter:(BOOL)enabledRefreshFooter{
    if (_enabledRefreshFooter != enabledRefreshFooter) {
        _enabledRefreshFooter = enabledRefreshFooter;
        self.baseCollectionView.mj_footer = _enabledRefreshFooter ? self.refreshFooter : nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
