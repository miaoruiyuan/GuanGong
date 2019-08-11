//
//  TZPhotoBrowserController.m
//  iautosCar
//
//  Created by three on 2017/1/9.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "TZPhotoBrowserController.h"
#import "BigImageIndexCollectionView.h"
#import <Photos/Photos.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define MaxScale 3.0
#define MinScale  1.0

@interface TZPhotoBrowserController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView * bottomScrollView;

@property (strong, nonatomic) UIScrollView *subScrollView;

@property (strong, nonatomic) UIImageView * imageView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) BigImageIndexCollectionView *indexCollectionView;

@end

@implementation TZPhotoBrowserController


#pragma mark - lazy
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate = self;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        _bottomScrollView.showsHorizontalScrollIndicator = NO;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.backgroundColor = [UIColor clearColor];
        _bottomScrollView.hidden = YES;
    }
    return _bottomScrollView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.originalRect];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[self.selectedIndex] valueForKey:@"url"]] placeholderImage:nil];
    }
    return _imageView;
}

#pragma mark - layout
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.imageView) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.imageView) {
        [self.view bringSubviewToFront:self.imageView];
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.frame = CGRectMake(0, (Screen_Height-Screen_Width)/2.0, Screen_Width, Screen_Width);
        } completion:^(BOOL finished) {
            self.bottomScrollView.hidden = NO;
            self.imageView.hidden = YES;
        }];
    }else{
        self.bottomScrollView.hidden = NO;
    }
    
//    self.imageSaveStatusArray = [NSMutableArray array];
//    for (NSMutableDictionary *dict in self.imageArr) {
//        [dict setObject:@"" forKey:@"isSave"];
//        
//    }
}
//横屏相关
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleLightContent;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationMaskAll;
//}

- (void)setupLayout{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview: self.bottomScrollView];
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    [self loadViewIfNeeded];
    self.bottomScrollView.contentSize = CGSizeMake(self.bottomScrollView.width*self.imageArr.count, 0);
    self.bottomScrollView.contentOffset = CGPointMake(self.bottomScrollView.width*self.selectedIndex, 0);
    
    [self creatView];
    [self initBottomBar];
}

-(void)initBottomBar{
    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setImage:[UIImage imageNamed:@"nav_back_btn_n"] forState:UIControlStateNormal];
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIScrollView *scroll = self.bottomScrollView.subviews[_selectedIndex];
        UIImageView * imageView = scroll.subviews.firstObject;
        self.imageView.image = imageView.image;
        self.imageView.hidden = NO;
        self.bottomScrollView.hidden = YES;
        if (self.delegate) {
            [self.delegate dismissViewWithTurnToIndex:(NSInteger)self.bottomScrollView.contentOffset.x/Screen_Width];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = self.originalRect;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 125, kScreenWidth - 50, 40)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.titleStr;;
    [self.view addSubview:self.titleLabel];
    
    // 2.保存按钮
    self.saveButton = [[UIButton alloc] init];
    [self.saveButton setImage:[UIImage imageNamed:@"car_photo_save"] forState:UIControlStateNormal];
    [self.saveButton setImage:[UIImage imageNamed:@"car_photo_save_selected"] forState:UIControlStateSelected];
    
//    car_photo_save_selected
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveImageToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.width.equalTo(@30);
    }];
    
    //序标
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-2);
        make.bottom.equalTo(self.view.mas_bottom).offset(-2);
        make.height.equalTo(@49);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.textColor = [UIColor whiteColor];
    _detailLabel.font = [UIFont boldSystemFontOfSize:12];
    
    if (self.imageArr.count > 1) {
        _detailLabel.text = [NSString stringWithFormat:@"全部(1/%ld)", (long)self.imageArr.count];
        [self.view addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(12);
            make.bottom.equalTo(self.bottomView.mas_top).offset(-2);
        }];
    }
    
    self.indexCollectionView = [[BigImageIndexCollectionView alloc] init];
    self.indexCollectionView.itemWidth = 65;
    self.indexCollectionView.minLineSpacing = 2;
    self.indexCollectionView.movieModelArray = self.imageArr;
    [self.bottomView addSubview:self.indexCollectionView];
    [self.indexCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bottomView);
        make.height.equalTo(@49);
    }];
    
    [self.indexCollectionView collectionViewDidScrollWithScrollBlock:^(NSIndexPath *indexPath) {
        DLog(@"%@",indexPath);
        _selectedIndex = indexPath.row;
        [self titleChangWithSeletedIndex];
        [self.bottomScrollView setContentOffset:CGPointMake(kScreenWidth * indexPath.row, 0) animated:YES];
    }];
    
    [self titleChangWithSeletedIndex];

}

- (void)creatView{
    
    [self.bottomScrollView layoutIfNeeded];
    
    for (int i =0; i<self.imageArr.count; i++) {
        self.subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(i*self.bottomScrollView.width, 0, self.bottomScrollView.width, self.bottomScrollView.height)];
        _subScrollView.backgroundColor = [UIColor clearColor];
        _subScrollView.minimumZoomScale = MinScale;
        _subScrollView.maximumZoomScale = MaxScale;
        _subScrollView.delegate = self;
        _subScrollView.contentSize = CGSizeMake(self.bottomScrollView.width, self.bottomScrollView.width);
        [self.bottomScrollView addSubview:_subScrollView];
//        [_subScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.equalTo(self.bottomScrollView);
////            make.centerX.equalTo(self.bottomScrollView.mas_centerX);
//            make.centerY.equalTo(self.bottomScrollView.mas_centerY);
//            make.width.equalTo(self.bottomView.mas_width);
//            make.height.equalTo(self.bottomView.mas_width);    
//        }];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (Screen_Height - Screen_Width)/2.0, Screen_Width, Screen_Width)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArr[i] valueForKey:@"url"]] placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_subScrollView addSubview:imageView];
        
//        [_subScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.subScrollView.mas_centerX);
//            make.centerY.equalTo(self.subScrollView.mas_centerY);
//            make.width.height.equalTo(self.view.mas_width);
//        }];
        
        imageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
        tapGesture.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
        tap.numberOfTapsRequired = 1;
        //如果不加下面的话，当单指双击时，会先调用单指单击中的处理，再调用单指双击中的处理
        [tap requireGestureRecognizerToFail:tapGesture];
        [_subScrollView addGestureRecognizer:tap];
    }
}

#pragma mark private method
- (void)dismissView:(UITapGestureRecognizer *)tap{
    UIScrollView *scroll = (UIScrollView *)tap.view;
    [scroll setZoomScale:MinScale animated:NO];
    if (self.imageView) {
        UIImageView * imageView = (UIImageView *)scroll.subviews.firstObject;
        self.imageView.image = imageView.image;
        self.imageView.hidden = NO;
        self.bottomScrollView.hidden = YES;
        if (self.delegate) {
    
            [self.delegate dismissViewWithTurnToIndex:(NSInteger)self.bottomScrollView.contentOffset.x/Screen_Width];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.frame = self.originalRect;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)didTapImageView:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint=[tap locationInView:tap.view];
    UIScrollView * scrollView = (UIScrollView *)tap.view.superview;
    
    BOOL zoomOut=scrollView.zoomScale==scrollView.minimumZoomScale;
    CGFloat scale=zoomOut?scrollView.maximumZoomScale:scrollView.minimumZoomScale;
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.zoomScale=scale;
        if(zoomOut){
            CGFloat x=touchPoint.x*scale-scrollView.bounds.size.width/2;
            CGFloat maxX=scrollView.contentSize.width-scrollView.bounds.size.width;
            CGFloat minX=0;
            x=x>maxX?maxX:x;
            x=x<minX?minX:x;
            
            CGFloat y=touchPoint.y*scale-scrollView.bounds.size.height/2;
            CGFloat maxY=scrollView.contentSize.height-scrollView.bounds.size.height;
            CGFloat minY=0;
            y=y>maxY?maxY:y;
            y=y<minY?minY:y;
            scrollView.contentOffset=CGPointMake(x, y);
        }
    }];
    
    [self.titleLabel setHidden:zoomOut];
    self.detailLabel.hidden = zoomOut;
    self.bottomView.hidden = zoomOut;
    self.saveButton.hidden = zoomOut;
    
}

- (CGRect)zoomRectByScale:(CGFloat)scale Center:(CGPoint)center
{
    CGRect zoomRect;
    //求出新的长和宽
    zoomRect.size.width = Screen_Width / scale;
    zoomRect.size.height = Screen_Height / scale;
    
    //找到新的原点
    zoomRect.origin.x = center.x * (1 - 1/scale);
    zoomRect.origin.y = center.y * (1 - 1/scale);
    
    return zoomRect;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return scrollView.subviews.firstObject;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIImageView * imageView = (UIImageView *)scrollView.subviews.firstObject;
    CGSize originalSize=scrollView.bounds.size;
    CGSize contentSize=scrollView.contentSize;
    CGFloat offsetX=originalSize.width>contentSize.width?(originalSize.width-contentSize.width)/2:0;
    CGFloat offsetY=originalSize.height>contentSize.height?(originalSize.height-contentSize.height)/2:0;
    imageView.center=CGPointMake(contentSize.width/2+offsetX, contentSize.height/2+offsetY);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    DLog(@"%f",scale);
    if (scale >1) {
        [self.titleLabel setHidden:YES];
        self.detailLabel.hidden = YES;
        self.bottomView.hidden = YES;
        self.saveButton.hidden = YES;
    }else{
        [self.titleLabel setHidden:NO];
        self.detailLabel.hidden = NO;
        self.bottomView.hidden = NO;
        self.saveButton.hidden = NO;
    }
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    [self.titleLabel setHidden:YES];
    self.detailLabel.hidden = YES;
    self.bottomView.hidden = YES;
    self.saveButton.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //翻页恢复最小状态
    for (UIScrollView *tempScroll in scrollView.subviews) {
        if ([tempScroll isKindOfClass:[UIScrollView class]]) {
            tempScroll.zoomScale = MinScale;
        }
    }
    
    _selectedIndex = self.bottomScrollView.contentOffset.x / Screen_Width;
    [self titleChangWithSeletedIndex];
    [self saveButtonChange];

}


-(void)saveButtonChange{
    CarScrollImageModel *carModel = self.imageArr[_selectedIndex];
    if (carModel.isSavedImage == NO) {
        [self.saveButton setImage:[UIImage imageNamed:@"car_photo_save"] forState:UIControlStateNormal];
        self.saveButton.userInteractionEnabled = YES;
    }else{
        [self.saveButton setImage:[UIImage imageNamed:@"car_photo_save_selected"] forState:UIControlStateNormal];
        self.saveButton.userInteractionEnabled = NO;
    }

}

-(void)titleChangWithSeletedIndex{
    _detailLabel.text = [NSString stringWithFormat:@"全部(%ld/%ld)",(long)_selectedIndex + 1, (long)self.imageArr.count];
    
    [self.indexCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    [self.indexCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


// 保存图片到系统相册
- (void)saveImageToAlbum{
    UIScrollView *scroll = self.bottomScrollView.subviews[_selectedIndex];
    UIImageView *imageView = scroll.subviews.firstObject;
    
    
    @weakify(self);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
         [PHAssetChangeRequest creationRequestForAssetFromImage:imageView.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
                CarScrollImageModel *carModel = self.imageArr[_selectedIndex];
                carModel.isSavedImage = YES;
                [self.imageArr replaceObjectAtIndex:_selectedIndex withObject:carModel];
                [self.saveButton setImage:[UIImage imageNamed:@"car_photo_save_selected"] forState:UIControlStateNormal];
                self.saveButton.userInteractionEnabled = NO;
            });
        } else {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"保存失败" toView:self.view];
            });
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
