//
//  GGCreatCarPhotosCell.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/10/26.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGCreatCarPhotosCell.h"
#import "GGCarPhotoCell.h"
#import "GGCollectionView.h"

NSInteger const MAX_IMAGE_COUNT = 12;

@interface GGCreatCarPhotosCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)GGCollectionView *collectionView;
@property(nonatomic,strong)UILabel *tipLabel;

@end

NSString *const kCellIdentifierCreateCarPhotos = @"kGGCreatCarPhotosCell";
@implementation GGCreatCarPhotosCell

- (void)setupView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(100);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    
    @weakify(self);
    [RACObserve(self, creatVM)subscribeNext:^(GGCreateCarViewModel *x) {
        @strongify(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView setHeight:[GGCreatCarPhotosCell cellHeightWithObj:x]];
            [self.collectionView reloadData];
            
        });
        
    }];
    
}

#pragma mark CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num = self.creatVM.imageItems.count;
    self.tipLabel.hidden = num > 0 ? YES : NO;
    return num < MAX_IMAGE_COUNT ? num+ 1: num;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GGCarPhotoCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ccell" forIndexPath:indexPath];
    if (indexPath.row < _creatVM.imageItems.count) {
        GGImageItem *carImage = [self.creatVM.imageItems objectAtIndex:indexPath.row];
        ccell.carImg = carImage;
    }else{
        ccell.carImg = nil;
    }
    
    @weakify(self);
    ccell.deleteCarImage = ^(GGImageItem *item){
        @strongify(self);
        if (self.deleteItem) {
            self.deleteItem(item);
        }
    };
    
    return ccell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item + 1 > self.creatVM.imageItems.count ) {
        if (self.openAlbum) {
            self.openAlbum();
        }
    }else{
        if (self.openBroswer) {
            self.openBroswer(indexPath.row);
        }
    }
}


+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[GGCreateCarViewModel class]]) {
        GGCreateCarViewModel *creatVM = (GGCreateCarViewModel *)obj;
        NSInteger row;
        if (creatVM.imageItems.count == MAX_IMAGE_COUNT) {
            row = 3;
        }else{
            row = ceilf((float)(creatVM.imageItems.count + 1)/4.0);
        }
        
        cellHeight = ([GGCarPhotoCell ccellSize].height +15) *row;
    }
    return cellHeight;
}


- (GGCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = [GGCarPhotoCell ccellSize];
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[GGCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundView = nil;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GGCarPhotoCell class] forCellWithReuseIdentifier:@"ccell"];
        
    }
    return _collectionView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"首图车辆左前45°";
        _tipLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _tipLabel.textColor = [UIColor colorWithHexString:@"737373"];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}


@end
