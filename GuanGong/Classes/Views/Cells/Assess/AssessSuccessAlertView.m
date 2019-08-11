//
//  AssessSuccessAlertView.m
//  bluebook
//
//  Created by three on 2017/5/31.
//  Copyright © 2017年 iautos_miaoruiyuan. All rights reserved.
//

#import "AssessSuccessAlertView.h"

@interface AssessSuccessAlertView ()

@property (nonatomic, strong) UIView *backview;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation AssessSuccessAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        _backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _backview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [self addSubview:_backview];
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 2.0;
        _contentView.layer.masksToBounds = YES;
        [_backview addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backview.mas_centerX);
            make.centerY.equalTo(self.backview.mas_centerY);
            make.height.equalTo(@315);
            make.width.equalTo(@300);
        }];
        
        _closeButton  = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"viewclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(12);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        [[_closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self hide];
            if (self.closeBlock) {
                self.closeBlock();
            }
        }];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//        [_contentView addGestureRecognizer:tap];
        
        self.topImageView = [[UIImageView alloc] init];
        self.topImageView.image = [UIImage imageNamed:@"createCarSuccess"];
        [_contentView addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(50);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
        self.titleLabel.text = @"提交成功";
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        
        self.sureButton  = [[UIButton alloc] init];
        [self.sureButton setTitle:@"知道了" forState:UIControlStateNormal];
        [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sureButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.sureButton.backgroundColor = themeColor;
        [self.contentView addSubview:self.sureButton];
        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
            make.left.equalTo(self.contentView.mas_left).offset(35);
            make.right.equalTo(self.contentView.mas_right).offset(-35);
            make.height.equalTo(@45);
        }];
        
        [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
            if (self.sureButtonBlock) {
                self.sureButtonBlock();
            }
        }];
        
    }
    return self;
}

-(void)setImage:(NSString *)imageSring andTitle:(NSString *)titleString andButtonTitle:(NSString *)buttonTitle
{
    self.topImageView.image = [UIImage imageNamed:imageSring];
    self.titleLabel.text = titleString;
    if (buttonTitle  == nil) {
        self.sureButton.hidden = YES;
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@240);
        }];
    }else{
        [self.sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    }
    
}

-(void)tap:(UITapGestureRecognizer*)gestureRecognizer{
//    if (self.tapBlock) {
//        self.tapBlock();
//
//    }
    [self hide];
    
}

#pragma mark- 显示和隐藏
-(void)show{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    [self animationWithView:self.contentView duration:0.5];
}

-(void)hide{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.backgroundColor = [UIColor clearColor];
    [self removeFromSuperview];
    //    [UIView animateWithDuration:0.3f animations:^{
    //        _contentView.y = _contentView.height;
    //        _contentView.height = 0;
    //
    //    } completion:^(BOOL finished) {
    //        [self removeFromSuperview];
    //    }];
}


#pragma mark- 动画
-(void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [view.layer addAnimation:animation forKey:nil];
}


@end
