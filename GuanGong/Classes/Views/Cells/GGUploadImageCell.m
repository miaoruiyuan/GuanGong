//
//  GGUploadImageCell.m
//  GuanGong
//
//  Created by 苗芮源 on 16/7/8.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGUploadImageCell.h"
#import "GGCustomCollectionView.h"

#define kTweetSendImageCCell_Width floorf((kScreenWidth - 15*2- 10*3)/4)

@class GGImageCell;

NSString * const kCellIdentifierUploadImage = @"kGGUploadImageCell";
@interface GGUploadImageCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)GGCustomCollectionView *mediaView;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)NSInteger maxPhotoCount;


@end

@implementation GGUploadImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.mediaView = [[GGCustomCollectionView alloc] initWithFrame:CGRectMake(15, 6, kScreenWidth-2*15, 80) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor clearColor]];
            [self.mediaView registerClass:[GGImageCell class] forCellWithReuseIdentifier:kCellIdentifierImageCell];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self.contentView addSubview:self.mediaView];
        }

        @weakify(self);
        [RACObserve(self, imageArray)subscribeNext:^(id x) {
            @strongify(self);
            [self.mediaView setHeight:[GGUploadImageCell cellHeightWithArray:self.imageArray]];
            [self.mediaView reloadData];
        }];
        self.maxPhotoCount = 4;
    }
    return self;
}

- (void)setTitle:(NSString *)title andMaxPhotoCount:(NSInteger)maxPhotoCount
{
    self.maxPhotoCount = maxPhotoCount;
    self.titleLabel.frame = CGRectMake(15, 8, 200, 16);
    self.titleLabel.text = title;
    self.mediaView.frame = CGRectMake(15, 32, kScreenWidth - 2 * 15, 80);
}

+ (CGFloat)cellHeightWithArray:(NSMutableArray *)array{
    CGFloat cellHeight = 0;
    
    NSInteger row;
    if (array.count <= 0) {
        row = 1;
    }else{
        row = ceilf((float)(array.count)/4.0);
    }
    cellHeight = ([GGImageCell ccellSize].height +10) *row;
    return cellHeight;
}

+ (CGFloat)cellHaveTitleHeightWithArray:(NSMutableArray *)array
{
    return [GGUploadImageCell cellHeightWithArray:array] + 32;
}

#pragma mark Collection 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num = self.imageArray.count;
    return num == self.maxPhotoCount ? num : num + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    GGImageCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierImageCell forIndexPath:indexPath];
    if (indexPath.row < self.imageArray.count) {
        GGImageItem *curImage = self.imageArray[indexPath.row];
        ccell.curImage = curImage;
    }else{
        ccell.curImage = nil;
    }
    ccell.deleteTweetImageBlock = ^(GGImageItem *toDelete){
        if (weakSelf.deleteTweetImageBlock) {
            weakSelf.deleteTweetImageBlock(toDelete);
        }
    };

    return ccell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [GGImageCell ccellSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imageArray.count) {
        if (_addPicturesBlock) {
            _addPicturesBlock();
        }
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = textNormalColor;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end


NSString * const kCellIdentifierImageCell = @"kGGImageCell";
@implementation GGImageCell


- (void)setCurImage:(GGImageItem *)curImage{
    
    
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kTweetSendImageCCell_Width, kTweetSendImageCCell_Width)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    
    _curImage = curImage;
    
    if (_curImage) {
        if (!_deleteBtn) {
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kTweetSendImageCCell_Width-20, 0, 20, 20)];
            [_deleteBtn setImage:[UIImage imageNamed:@"btn_delete_image"] forState:UIControlStateNormal];
            _deleteBtn.backgroundColor = [UIColor blackColor];
            _deleteBtn.layer.cornerRadius = CGRectGetWidth(_deleteBtn.bounds)/2;
            _deleteBtn.layer.masksToBounds = YES;
            
            [_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_deleteBtn];
        }
        //RAC(self.imgView, image) = [RACObserve(self.curImage, thumbnailImage) takeUntil:self.rac_prepareForReuseSignal];
        if (_curImage.photoUrl) {
            [_imgView setImageWithURL:[NSURL URLWithString:_curImage.photoUrl] placeholder:[UIImage imageNamed:@"addPictureBgImage"]];
        }
        
        _deleteBtn.hidden = NO;
    }else{
        _imgView.image = [UIImage imageNamed:@"addPictureBgImage"];
        if (_deleteBtn) {
            _deleteBtn.hidden = YES;
        }
    }
    
}

- (void)deleteBtnClicked:(id)sender{
    if (_deleteTweetImageBlock) {
        _deleteTweetImageBlock(_curImage);
    }
}

+(CGSize)ccellSize{
    return CGSizeMake(kTweetSendImageCCell_Width, kTweetSendImageCCell_Width);
}


@end
