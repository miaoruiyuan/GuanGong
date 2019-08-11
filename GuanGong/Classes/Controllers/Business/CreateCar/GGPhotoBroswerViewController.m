//
//  GGPhotoBroswerViewController.m
//  GuanGong
//
//  Created by 苗芮源 on 2016/11/1.
//  Copyright © 2016年 iautos. All rights reserved.
//

#import "GGPhotoBroswerViewController.h"
#import "GGMaskViewController.h"
#import "GGImageItem.h"

@interface GGPhotoBroswerViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *deleteButton;
@property(nonatomic,strong)UIButton *setFirstButton;
@property(nonatomic,strong)UIButton *editButton;
@property(nonatomic,strong)UILabel *countLabel;

@end

@implementation GGPhotoBroswerViewController

- (void)setupView{
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(22);
        make.left.equalTo(self.view.mas_left).offset(18);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
//    //删除
//    [self.view addSubview:self.deleteButton];
//    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.closeButton);
//        make.right.equalTo(self.view.mas_right).offset(-12);
//        make.size.mas_equalTo(CGSizeMake(40, 22));
//    }];
//    
    //索引
    [self.view addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.closeButton);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 22));
    }];
    
    //设为首图
    [self.view addSubview:self.setFirstButton];
    [self.setFirstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.closeButton);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
        make.size.mas_equalTo(CGSizeMake(80, 22));
    }];
    
    //涂抹
    [self.view addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.centerY.equalTo(self.setFirstButton);
        make.size.mas_equalTo(CGSizeMake(80, 22));
    }];
    
    
    [self.view addSubview:self.scrollView];
    UIImageView *lastImageView = nil;
    for (int i = 0; i < self.items.count ; i ++) {
        GGImageItem *item = self.items[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        if (item.photoUrl) {
            [imageView setImageWithURL:[NSURL URLWithString:item.photoUrl] placeholder:[UIImage imageNamed:@"car_detail_image_failed"]];
        }else{
            imageView.image = [UIImage imageWithData:item.imageData];
        }
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.centerY.equalTo(self.view);
            if (lastImageView) {
                make.left.equalTo(lastImageView.mas_right);
            }else{
                make.left.equalTo(self.scrollView);
            }
        }];
        
        lastImageView = imageView;
    }
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(60, 0, 60, 0));
        make.right.equalTo(lastImageView.mas_right);
    }];
    

    //关闭
    @weakify(self);
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    
    [[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        GGMaskViewController *maskVC = [[GGMaskViewController alloc] init];
        maskVC.value = self.items[0];
        [self presentViewController:maskVC animated:YES completion:nil];
    }];
    
}

- (void)bindViewModel{
    [self bk_performBlock:^(GGPhotoBroswerViewController *obj) {
        [obj.scrollView setContentOffset:CGPointMake(kScreenWidth * obj.index, 0) animated:NO];
    } afterDelay:.1];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.mj_offsetX / scrollView.width + 1;
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)self.items.count];
    
}



- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
    }
    return _closeButton;
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.delegate =  self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightLight]];
    }
    return _deleteButton;
}

- (UIButton *)setFirstButton{
    if (!_setFirstButton) {
        _setFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setFirstButton setTitle:@"设为首图" forState:UIControlStateNormal];
        [_setFirstButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightLight]];
    }
    return _setFirstButton;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"涂抹" forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightLight]];
    }
    return _editButton;
}



- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)self.index + 1,(unsigned long)self.items.count];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
    }
    return _countLabel;
}

@end
